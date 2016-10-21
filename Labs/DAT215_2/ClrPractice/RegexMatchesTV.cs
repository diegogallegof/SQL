using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Text;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;

namespace ClrPractice
{
    public class RegexMatchesTV
    {
        [SqlFunction(Name = "RegexMatches", FillRowMethodName = "FillRow", TableDefinition = "match nvarchar(500)")]
        public static IEnumerable InitMethod(string text, string pattern)
        {
            List<string> list = new List<string>();

            if (!string.IsNullOrEmpty(text) && !string.IsNullOrEmpty(pattern))
            {
                foreach (Match match in Regex.Matches(text, pattern))
                {
                    list.Add(match.Value);
                }
            }

            return list;
        }

        public static void FillRow(object obj, out SqlString match)
        {
            match = (string)obj;
        }
    }
}
