/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Runtime.InteropServices;

namespace TWSLib
{
    [ComVisible(true), Guid("6C3C65C9-C314-4DAA-BC85-34A4FC6DEB6B")]

    public interface IHistoricalTickBidAsk
    {
        [DispId(1)]
        string time { get; }
        [DispId(2)]
        object tickAttribBidAsk { get; }
        [DispId(3)]
        double priceBid { get; }
        [DispId(4)]
        double priceAsk { get; }
        [DispId(5)]
        int sizeBid { get; }
        [DispId(6)]
        int sizeAsk { get; }
    }
}
