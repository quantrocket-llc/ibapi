/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Runtime.InteropServices;

namespace TWSLib
{
    [ComVisible(true), Guid("7CE1D107-2ED4-4A57-AB32-990EE8089C8E")]

    public interface IHistoricalTick
    {
        [DispId(1)]
        string time { get; }
        [DispId(2)]
        double price { get; }
        [DispId(3)]
        int size { get; }
    }
}
