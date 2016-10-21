using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;


[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.Native)]
public struct Rectangle: INullable
{
    private bool m_IsNull;
    private Int32 m_X;
    private Int32 m_Y;
    private Int32 m_Width;
    private Int32 m_Height;

    public Rectangle(bool isNull)
    {
        m_IsNull = isNull;
        m_X = 0;
        m_Y = 0;
        m_Width = 0;
        m_Height = 0;
    }

    public Rectangle(Int32 x, Int32 y, Int32 width, Int32 height)
    {
        if (width < 0)
            throw new ArgumentOutOfRangeException("width");

        if (height < 0)
            throw new ArgumentOutOfRangeException("height");

        m_IsNull = false;
        m_X = x;
        m_Y = y;
        m_Width = width;
        m_Height = height;
    }

    public bool IsNull
    {
        get { return m_IsNull; }
    }

    public Int32 X
    {
        get { return m_X; }
    }

    public Int32 Y
    {
        get { return m_Y; }
    }

    public Int32 Width
    {
        get { return m_Width; }
    }

    public Int32 Height
    {
        get { return m_Height; }
    }

    public Int64 Area
    {
        get { return m_Width * m_Height; }
    }

    public override string ToString()
    {
        return string.Format("X={0}, Y={1}, Width={2}, Height={3}", X, Y, Width, Height);
    }
    
    public static Rectangle Null
    {
        get { return new Rectangle(true); }
    }
    
    public static Rectangle Parse(SqlString s)
    {
        Rectangle r;

        if (s.IsNull)
        {
            r = new Rectangle(true);
        }
        else
        {
            string[] elements = s.Value.Split(new char[] { ',' });

            if (elements.Length != 4)
                throw new ArgumentException("Wrong number of elements.");

            // X
            Int32 x;
            if (!ParseElement(elements[0], "X", out x))
                throw new ArgumentException("Invalid format (X).");

            // Y
            Int32 y;
            if (!ParseElement(elements[1], "Y", out y))
                throw new ArgumentException("Invalid format (Y).");

            // Width
            Int32 width;
            if (!ParseElement(elements[2], "Width", out width))
                throw new ArgumentException("Invalid format (Width).");

            // Height
            Int32 height;
            if (!ParseElement(elements[3], "Height", out height))
                throw new ArgumentException("Invalid format (Height).");

            r = new Rectangle(x, y, width, height);
        }

        return r;
    }

    private static bool ParseElement(string s, string elementName, out Int32 value)
    {
        bool retval = false;
        value = 0;

        string[] parts = s.Split(new char[] { '=' });
        if (parts.Length == 2)
        {
            if (string.Compare(parts[0].Trim(), elementName, true) == 0)
            {
                retval = Int32.TryParse(parts[1], out value);
            }
        }

        return retval;
    }
}