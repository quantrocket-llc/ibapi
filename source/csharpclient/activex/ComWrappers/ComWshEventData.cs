/* Copyright (C) 2022 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using IBApi;

namespace TWSLib
{
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComWshEventData : ComWrapper<WshEventData>, IWshEventData
    {
        int ConId
        {
            get { return data != null ? data.ConId : default(int); }
            set { if (data != null) data.ConId = value; }
        }

        string Filter
        {
            get { return data != null ? data.Filter : default(string); }
            set { if (data != null) data.Filter = value; }
        }

        bool FillWatchlist
        {
            get { return data != null ? data.FillWatchlist : default(bool); }
            set { if (data != null) data.FillWatchlist = value; }
        }

        bool FillPortfolio
        {
            get { return data != null ? data.FillPortfolio : default(bool); }
            set { if (data != null) data.FillPortfolio = value; }
        }

        bool FillCompetitors
        {
            get { return data != null ? data.FillCompetitors : default(bool); }
            set { if (data != null) data.FillCompetitors = value; }
        }
        string StartDate
        {
            get { return data != null ? data.StartDate : default(string); }
            set { if (data != null) data.StartDate = value; }
        }
        string EndDate
        {
            get { return data != null ? data.EndDate : default(string); }
            set { if (data != null) data.EndDate = value; }
        }
        int TotalLimit
        {
            get { return data != null ? data.TotalLimit : default(int); }
            set { if (data != null) data.TotalLimit = value; }
        }

        public ComWshEventData()
        {
        }

        public static explicit operator IBApi.WshEventData(ComWshEventData comWshEventData)
        {
            return comWshEventData.ConvertTo();
        }

        public static explicit operator ComWshEventData(IBApi.WshEventData wshEventData)
        {
            return new ComWshEventData().ConvertFrom(wshEventData) as ComWshEventData;
        }

        int IWshEventData.conId { get { return ConId; } set { ConId = value; } }
        string IWshEventData.filter { get { return Filter; } set { Filter = value; } }
        bool IWshEventData.fillWatshlist { get { return FillWatchlist; } set { FillWatchlist = value; } }
        bool IWshEventData.fillPortfolio { get { return FillPortfolio; } set { FillPortfolio = value; } }
        bool IWshEventData.fillCompetitors { get { return FillCompetitors; } set { FillCompetitors = value; } }
        string IWshEventData.startDate { get { return StartDate; } set { StartDate = value; } }
        string IWshEventData.endDate { get { return EndDate; } set { EndDate = value; } }
        int IWshEventData.totalLimit { get { return TotalLimit; } set { TotalLimit = value; } }
    }
}
