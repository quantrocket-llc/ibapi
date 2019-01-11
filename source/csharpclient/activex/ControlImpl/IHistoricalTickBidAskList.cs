/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Collections.Generic;
using System.Runtime.InteropServices;
using IBApi;

namespace TWSLib
{
    [ComVisible(true), Guid("42CE9025-DE39-4999-8E95-10AF06711CEB")]

    public interface IHistoricalTickBidAskList
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
        object Add(ComHistoricalTickBidAsk comHistoricalTickBidAsk);
    }

    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComHistoricalTickBidAskList : IHistoricalTickBidAskList
    {
        private ComList<ComHistoricalTickBidAsk, IBApi.HistoricalTickBidAsk> HistoricalTickBidAskList;

        public ComHistoricalTickBidAskList() : this(null) { }

        public ComHistoricalTickBidAskList(HistoricalTickBidAsk[] historicalTickBidAskArray)
        {
            this.HistoricalTickBidAskList = (historicalTickBidAskArray.Length > 0) ? new ComList<ComHistoricalTickBidAsk, IBApi.HistoricalTickBidAsk>(new List<IBApi.HistoricalTickBidAsk>(historicalTickBidAskArray)) : null;
        }

        public object _NewEnum
        {
            get { return HistoricalTickBidAskList.GetEnumerator(); }
        }

        public object this[int index]
        {
            get { return HistoricalTickBidAskList[index]; }
        }

        public int Count
        {
            get { return HistoricalTickBidAskList.Count; }
        }

        public object AddEmpty()
        {
            var rval = new ComHistoricalTickBidAsk();

            HistoricalTickBidAskList.Add(rval);

            return rval;
        }

        public object Add(ComHistoricalTickBidAsk comHistoricalTickBidAsk)
        {
            var rval = comHistoricalTickBidAsk;

            HistoricalTickBidAskList.Add(rval);

            return rval;
        }
    }
}
