/* Copyright (C) 2021 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using IBApi;
using System.Runtime.InteropServices;

namespace TWSLib
{
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComHistoricalSession : ComWrapper<IBApi.HistoricalSession>, IHistoricalSession
    {
        string StartDateTime
        {
            get { return data != null ? data.StartDateTime : default(string); }
        }

        string EndDateTime
        {
            get { return data != null ? data.EndDateTime : default(string); }
        }

        string RefDate
        {
            get { return data != null ? data.RefDate : default(string); }
        }

        public ComHistoricalSession()
        {
        }

        string TWSLib.IHistoricalSession.startDateTime
        {
            get { return StartDateTime; }
        }

        string TWSLib.IHistoricalSession.endDateTime
        {
            get { return EndDateTime; }
        }

        string TWSLib.IHistoricalSession.refDate
        {
            get { return RefDate; }
        }

        public static explicit operator HistoricalSession(ComHistoricalSession comHistoricalSession)
        {
            return comHistoricalSession.ConvertTo();
        }

        public static explicit operator ComHistoricalSession(HistoricalSession historicalSession)
        {
            return new ComHistoricalSession().ConvertFrom(historicalSession) as ComHistoricalSession;
        }
    }
}
