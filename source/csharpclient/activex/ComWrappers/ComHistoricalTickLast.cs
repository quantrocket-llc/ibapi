/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using IBApi;
using System.Runtime.InteropServices;

namespace TWSLib
{
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComHistoricalTickLast : ComWrapper<IBApi.HistoricalTickLast>, IHistoricalTickLast
    {
        string Time
        {
            get { return data != null ? data.Time.ToString("G") : default(string); }
        }

        ComTickAttribLast TickAttribLast
        { 
            get { return (ComTickAttribLast)data.TickAttribLast; }
        }

        double Price
        {
            get { return data != null ? data.Price : default(double); }
        }

        long Size
        {
            get { return data != null ? data.Size : default(long); }
        }

        string Exchange
        {
            get { return data != null ? data.Exchange : default(string); }
        }

        string SpecialConditions
        {
            get { return data != null ? data.SpecialConditions : default(string); }
        }

        public ComHistoricalTickLast()
        {
        }

        string TWSLib.IHistoricalTickLast.time
        {
            get { return Time; }
        }
        
        object TWSLib.IHistoricalTickLast.tickAttribLast
        {
            get { return TickAttribLast; }
        }

        double TWSLib.IHistoricalTickLast.price
        {
            get { return Price; }
        }

        int TWSLib.IHistoricalTickLast.size
        {
            get { return (int)Size; }
        }

        string TWSLib.IHistoricalTickLast.exchange
        {
            get { return Exchange; }
        }

        string TWSLib.IHistoricalTickLast.specialConditions
        {
            get { return SpecialConditions; }
        }

        public static explicit operator HistoricalTickLast(ComHistoricalTickLast comHistoricalTickLast)
        {
            return comHistoricalTickLast.ConvertTo();
        }

        public static explicit operator ComHistoricalTickLast(HistoricalTickLast historicalTickLast)
        {
            return new ComHistoricalTickLast().ConvertFrom(historicalTickLast) as ComHistoricalTickLast;
        }
    }
}
