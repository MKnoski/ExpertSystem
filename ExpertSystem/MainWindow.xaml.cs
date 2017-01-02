using System.Linq;
using System.Windows;
using System.Windows.Controls;
using ExpertSystem.Resources;
using Mommosoft.ExpertSystem;

namespace ExpertSystem
{
    public partial class MainWindow
    {
        private readonly Environment environment = new Environment();
        private readonly AnswersDictionary answersDictionary;

        public MainWindow()
        {
            answersDictionary = new AnswersDictionary();

            InitializeComponent();
            this.environment.AddRouter(new DebugRouter());
            this.environment.Clear();
            this.environment.Load("illness.clp");
            this.environment.Reset();
            NextUiState();
        }

        private void NextUiState()
        {
            NextBtn.Visibility = Visibility.Hidden;
            PrevBtn.Visibility = Visibility.Hidden;
            AnswersPanel.Children.Clear();
            this.environment.Run();

            var evalStr = "(find-all-facts ((?f state-list)) TRUE)";
            using (var allFacts = (FactAddressValue)((MultifieldValue)this.environment.Eval(evalStr))[0])
            {
                var currentId = allFacts.GetFactSlot("current").ToString();
                evalStr = "(find-all-facts ((?f UI-state)) " + "(eq ?f:id " + currentId + "))";
            }

            using (var evalFact = (FactAddressValue)((MultifieldValue)this.environment.Eval(evalStr))[0])
            {
                var state = evalFact.GetFactSlot("state").ToString();
                switch (state)
                {
                    case "initial":
                        NextBtn.Content = "Dalej";
                        NextBtn.Visibility = Visibility.Visible;
                        break;
                    case "final":
                        NextBtn.Content = "Reset";
                        NextBtn.Visibility = Visibility.Visible;
                        break;
                    default:
                        NextBtn.Content = "Dalej";
                        NextBtn.Visibility = Visibility.Visible;
                        PrevBtn.Content = "Powrót";
                        PrevBtn.Visibility = Visibility.Visible;
                        break;
                }

                using (var validAnswers = (MultifieldValue)evalFact.GetFactSlot("valid-answers"))
                {
                    foreach (var validAnswer in validAnswers)
                    {
                        var answer = validAnswer.ToString();
                        string content;
                        this.answersDictionary.Answers.TryGetValue(answer, out content);
                        var rb = new RadioButton { Margin = new Thickness(3), Content = content, GroupName = "answers" };
                        this.AnswersPanel.Children.Add(rb);
                    }
                }

                QuestionLbl.Content = Messages.ResourceManager.GetString((SymbolValue)evalFact.GetFactSlot("display"));
            }
        }

        private string GetAnswer()
        {
            foreach (var child in AnswersPanel.Children)
            {
                var radio = child as RadioButton;
                if (radio?.IsChecked != null && radio.IsChecked.Value)
                {
                    var content = radio.Content.ToString();
                    var name = this.answersDictionary.Answers.FirstOrDefault(x => x.Value == content).Key;
                    return name;
                }              
            }
            return null;
        }

        private void NextBtn_OnClick(object sender, RoutedEventArgs e)
        {
            var button = sender as Button;
            if (button == null) return;
            const string evalStr = "(find-all-facts ((?f state-list)) TRUE)";
            using (var f = (FactAddressValue)((MultifieldValue)this.environment.Eval(evalStr))[0])
            {
                var currentId = f.GetFactSlot("current").ToString();
                switch (button.Content.ToString())
                {
                    case "Dalej":
                        if (AnswersPanel.Children.Count == 0)
                        {
                            this.environment.AssertString("(next " + currentId + ")");
                        }
                        else
                        {
                            var t = $"(next {currentId} {GetAnswer()})";
                            this.environment.AssertString(t);
                        }
                        NextUiState();
                        break;
                    case "Reset":
                        this.environment.Reset();
                        NextUiState();
                        break;
                    case "Powrót":
                        this.environment.AssertString("(prev " + currentId + ")");
                        NextUiState();
                        break;
                }
            }
        }
    }
}
