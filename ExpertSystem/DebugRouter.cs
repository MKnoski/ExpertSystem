using System;
using System.Diagnostics;
using Mommosoft.ExpertSystem;

namespace ExpertSystem
{
    public class DebugRouter : Router
    {
        public override string Name => "DebugRouter";

        public override int Priority => 10;

        public override bool Query(string logicalName)
        {
            return (logicalName.Equals("wwarning") ||
                    logicalName.Equals("werror") ||
                    logicalName.Equals("wtrace") ||
                    logicalName.Equals("wdialog") ||
                    logicalName.Equals("wclips") ||
                    logicalName.Equals("wdisplay"));
        }

        public override int Print(string logicalName, string message)
        {
            Debug.Write(message);
            Console.Write(message);
            return 1;
        }
    }
}