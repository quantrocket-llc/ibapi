using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace TWSLib
{
    [ComVisible(true)]
    public interface ISoftDollarTier
    {
        string Name { get; }
        string DisplayName { get; }
        string Value { get; }
    }
}
