using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlBoolean IsRegexMatch(SqlString input, SqlString pattern)
    {
        SqlBoolean retval = SqlBoolean.Null;

        if (!input.IsNull && !pattern.IsNull)
        {
            bool result = Regex.IsMatch(input.Value, pattern.Value);
            retval = result ? new SqlBoolean(true) : new SqlBoolean(false);
        }

        return retval;
    }
}
