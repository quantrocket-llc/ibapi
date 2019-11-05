/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using IBApi;
using System.Runtime.InteropServices;

namespace TWSLib
{
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComHistoricalTick : ComWrapper<IBApi.HistoricalTick>, IHistoricalTick
    {

        string Time
        {
            get { return data != null ? data.Time.ToString("G") : default(string); }
        }

        double Price
        {
            get { return data != null ? data.Price : default(double); }
        }

        long Size
        {
            get { return data != null ? data.Size : default(long); }
        }

        public ComHistoricalTick()
        {
        }

        string TWSLib.IHistoricalTick.time
        {
            get { return Time; }
        }

        double TWSLib.IHistoricalTick.price
        {
            get { return Price; }
        }

        int TWSLib.IHistoricalTick.size
        {
            get { return (int)Size; }
        }

        public static explicit operator HistoricalTick(ComHistoricalTick comHistoricalTick)
        {
            return comHistoricalTick.ConvertTo();
        }

        public static explicit operator ComHistoricalTick(HistoricalTick historicalTick)
        {
            return new ComHistoricalTick().ConvertFrom(historicalTick) as ComHistoricalTick;
        }
    }
}
