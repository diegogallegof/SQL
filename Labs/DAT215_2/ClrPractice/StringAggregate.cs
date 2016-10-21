using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text;
using System.IO;

[Serializable]
[SqlUserDefinedAggregate(Format.UserDefined, IsInvariantToNulls = true, IsInvariantToDuplicates = false, IsInvariantToOrder = false, MaxByteSize = 8000)]
public struct StringAggregate : IBinarySerialize
{
    private StringBuilder m_SB;

    public void Init()
    {
        this.m_SB = new StringBuilder();
    }

    public void Accumulate(SqlString value)
    {
        if (!value.IsNull)
        {
            if (m_SB.Length > 0)
                m_SB.Append(", ");

            m_SB.Append(value.Value);
        }
    }

    public void Merge (StringAggregate group)
    {
        if (group.m_SB != null && group.m_SB.Length > 0)
        {
            if (m_SB.Length > 0)
                m_SB.Append(", ");

            m_SB.Append(group);
        }
    }

    public SqlString Terminate ()
    {
        return new SqlString(m_SB.ToString());
    }

    public void Read(BinaryReader rdr)
    {
        m_SB = new StringBuilder(rdr.ReadString());
    }

    public void Write(BinaryWriter wtr)
    {
        wtr.Write(m_SB.ToString());
    }
}
