/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace TWSLib
{
    [ComVisible(true)]
    public interface IHistogramEntry
    {
        double Price { get; }
        int Size { get; }
    }

    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComHistogramEntry : ComWrapper<IBApi.HistogramEntry>, IHistogramEntry
    {
        public double Price { get { return data.Price; } }
        public int Size { get { return (int)data.Size; } }

        public static explicit operator IBApi.HistogramEntry(ComHistogramEntry ctv)
        {
            return ctv.ConvertTo();
        }

        public static explicit operator ComHistogramEntry(IBApi.HistogramEntry tv)
        {
            return new ComHistogramEntry().ConvertFrom(tv) as ComHistogramEntry;
        }
    }
}
