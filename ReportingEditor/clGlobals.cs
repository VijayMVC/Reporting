using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReportingEditor
{
    static class clGlobals
    {
        public static string ConnectionString { get; set; }

        static clGlobals()
        {
            ConnectionString = @"";
        }
    }

}
