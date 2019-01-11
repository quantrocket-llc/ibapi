/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Collections.Generic;
using System.Runtime.InteropServices;
using IBApi;

namespace TWSLib
{
    [ComVisible(true), Guid("7AEF6924-7BCE-4562-8146-41C6A71AE3D3")]

    public interface IHistoricalTickLastList
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
        object Add(ComHistoricalTickLast comHistoricalTickLast);
    }

    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComHistoricalTickLastList : IHistoricalTickLastList
    {
        private ComList<ComHistoricalTickLast, IBApi.HistoricalTickLast> HistoricalTickLastList;

        public ComHistoricalTickLastList() : this(null) { }

        public ComHistoricalTickLastList(HistoricalTickLast[] historicalTickLastArray)
        {
            this.HistoricalTickLastList = (historicalTickLastArray.Length > 0) ? new ComList<ComHistoricalTickLast, IBApi.HistoricalTickLast>(new List<IBApi.HistoricalTickLast>(historicalTickLastArray)) : null;
        }

        public object _NewEnum
        {
            get { return HistoricalTickLastList.GetEnumerator(); }
        }

        public object this[int index]
        {
            get { return HistoricalTickLastList[index]; }
        }

        public int Count
        {
            get { return HistoricalTickLastList.Count; }
        }

        public object AddEmpty()
        {
            var rval = new ComHistoricalTickLast();

            HistoricalTickLastList.Add(rval);

            return rval;
        }

        public object Add(ComHistoricalTickLast comHistoricalTickLast)
        {
            var rval = comHistoricalTickLast;

            HistoricalTickLastList.Add(rval);

            return rval;
        }
    }
}
