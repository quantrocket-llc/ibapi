/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Runtime.InteropServices;

namespace TWSLib
{
    [ComVisible(true), Guid("C080F665-D8AD-4A2A-82CC-3A90C3939A5E")]
    public interface IHistoricalTickLast
    {
        [DispId(1)]
        string time { get; }
        [DispId(2)]
        object tickAttribLast { get; }
        [DispId(3)]
        double price { get; }
        [DispId(4)]
        int size { get; }
        [DispId(5)]
        string exchange { get; }
        [DispId(6)]
        string specialConditions { get; }
    }
}
