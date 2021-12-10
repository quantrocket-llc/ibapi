﻿/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using IBApi;
using System.Runtime.InteropServices;

namespace TWSLib
{
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComHistoricalTickBidAsk : ComWrapper<IBApi.HistoricalTickBidAsk>, IHistoricalTickBidAsk
    {

        string Time
        {
            get { return data != null ? data.Time.ToString("G") : default(string); }
        }

        ComTickAttribBidAsk TickAttribBidAsk
        {
            get { return (ComTickAttribBidAsk)data.TickAttribBidAsk; }
        }

        double PriceBid
        {
            get { return data != null ? data.PriceBid : default(double); }
        }

        double PriceAsk
        {
            get { return data != null ? data.PriceAsk : default(double); }
        }

        object SizeBid
        {
            get { return data != null ? data.SizeBid : default(object); }
        }

        object SizeAsk
        {
            get { return data != null ? data.SizeAsk : default(object); }
        }

        public ComHistoricalTickBidAsk()
        {
        }

        string TWSLib.IHistoricalTickBidAsk.time
        {
            get { return Time; }
        }

        object TWSLib.IHistoricalTickBidAsk.tickAttribBidAsk
        {
            get { return TickAttribBidAsk; }
        }

        double TWSLib.IHistoricalTickBidAsk.priceBid
        {
            get { return PriceBid; }
        }

        double TWSLib.IHistoricalTickBidAsk.priceAsk
        {
            get { return PriceAsk; }
        }

        object TWSLib.IHistoricalTickBidAsk.sizeBid
        {
            get { return SizeBid; }
        }

        object TWSLib.IHistoricalTickBidAsk.sizeAsk
        {
            get { return SizeAsk; }
        }

        public static explicit operator HistoricalTickBidAsk(ComHistoricalTickBidAsk comHistoricalTickBidAsk)
        {
            return comHistoricalTickBidAsk.ConvertTo();
        }

        public static explicit operator ComHistoricalTickBidAsk(HistoricalTickBidAsk historicalTickBidAsk)
        {
            return new ComHistoricalTickBidAsk().ConvertFrom(historicalTickBidAsk) as ComHistoricalTickBidAsk;
        }
    }
}
