/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Collections.Generic;
using System.Runtime.InteropServices;
using IBApi;

namespace TWSLib
{
    [ComVisible(true), Guid("505BDC19-DA33-4C3B-A905-87F0C8898485")]
    public interface IHistoricalTickList
    {
        [DispId(-4)]
        object _NewEnum { [return: MarshalAs(UnmanagedType.IUnknown)] get; }
        [DispId(0)]
        object this[int index] { [return: MarshalAs(UnmanagedType.IDispatch)] get; }
        [DispId(1)]
        int Count { get; }
        [DispId(2)]
        [return: MarshalAs(UnmanagedType.IDispatch)]
        object AddEmpty();
        [DispId(3)]
        [return: MarshalAs(UnmanagedType.IDispatch)]
        object Add(ComHistoricalTick comHistoricalTick);
    }

    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComHistoricalTickList : IHistoricalTickList
    {
        private ComList<ComHistoricalTick, IBApi.HistoricalTick> HistoricalTickList;

        public ComHistoricalTickList() : this(null) { }

        public ComHistoricalTickList(HistoricalTick[] historicalTickArray)
        {
            this.HistoricalTickList = (historicalTickArray.Length > 0) ? new ComList<ComHistoricalTick, IBApi.HistoricalTick>(new List<IBApi.HistoricalTick>(historicalTickArray)) : null;
        }

        public object _NewEnum
        {
            get { return HistoricalTickList.GetEnumerator(); }
        }

        public object this[int index]
        {
            get { return HistoricalTickList[index]; }
        }

        public int Count
        {
            get { return HistoricalTickList.Count; }
        }

        public object AddEmpty()
        {
            var rval = new ComHistoricalTick();

            HistoricalTickList.Add(rval);

            return rval;
        }

        public object Add(ComHistoricalTick cht)
        {
            var rval = cht;

            HistoricalTickList.Add(rval);

            return rval;
        }
    }
}
