using System.Collections.Generic;

namespace ExpertSystem.Resources
{
    public class AnswersDictionary
    {
        public AnswersDictionary()
        {
            Answers = new Dictionary<string, string>
            {
                { "pain-in-one-place", "Silny ból w jednym miejscu" },
                { "bad-mood", "Ogólne złe samopoczucie" },
                { "other", "Inne" },

                { "head", "Ból głowy" },
                { "lungs", "Ból w okolicach płuc" },
                { "stomach", "Ból brzucha" },
                { "ear", "Ból ucha" },
                { "eye", "Ból oka" },
                { "heart", "Ból serca" },
                { "teeth", "Ból zęba" },
                { "kidneys", "Ból nerek" },

                { "skin", "Świąd skóry" },
                { "overstrain", "Przemęczenie" },
                { "hairs", "Wypadanie włosów" },
                { "allergy", "Alergia" },
                { "obesity", "Problem z otyłością" },
                { "senility", "Problem starcze" },
                { "reproductive-system", "Problemy układu płciowego" },
                { "rheumatological-problems", "Ból stawów lub/i kości" },

                { "none", "Brak" },
                { "food-poisoning", "Nudności, brak apetytu, wymioty" },
                { "depression", "Depresja" },
                { "dizziness", "Zawroty głowy" },
                { "cold", "Ból głowy, ból stawów" },
                { "flu", "Kaszel oraz katar" },

                { "yes", "Tak" },
                { "no", "Nie" },

                { "man", "Mężczyzna" },
                { "woman", "Kobieta" },
            };
        }

        public Dictionary<string, string> Answers{ get; }
    }
}