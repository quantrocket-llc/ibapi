/* Copyright (C) 2021 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Collections.Generic;
using System.Runtime.InteropServices;
using IBApi;

namespace TWSLib
{
    [ComVisible(true), Guid("4E5A2137-9F49-47CD-A0D2-10BFC4C784EB")]

    public interface IHistoricalSessionList
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
        object Add(ComHistoricalSession comHistoricalSession);
    }

    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComHistoricalSessionList : IHistoricalSessionList
    {
        private ComList<ComHistoricalSession, IBApi.HistoricalSession> HistoricalSessionList;

        public ComHistoricalSessionList() : this(null) { }

        public ComHistoricalSessionList(HistoricalSession[] historicalSessionArray)
        {
            this.HistoricalSessionList = (historicalSessionArray.Length > 0) ? new ComList<ComHistoricalSession, IBApi.HistoricalSession>(new List<IBApi.HistoricalSession>(historicalSessionArray)) : null;
        }

        public object _NewEnum
        {
            get { return HistoricalSessionList.GetEnumerator(); }
        }

        public object this[int index]
        {
            get { return HistoricalSessionList[index]; }
        }

        public int Count
        {
            get { return HistoricalSessionList.Count; }
        }

        public object AddEmpty()
        {
            var rval = new ComHistoricalSession();

            HistoricalSessionList.Add(rval);

            return rval;
        }

        public object Add(ComHistoricalSession comHistoricalSession)
        {
            var rval = comHistoricalSession;

            HistoricalSessionList.Add(rval);

            return rval;
        }
    }
}
