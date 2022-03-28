/* Copyright (C) 2022 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

namespace IBApi
{
    public class WshEventData
    {
        public int ConId { get; set; }

        public string Filter { get; set; }

        public bool FillWatchlist { get; set; }

        public bool FillPortfolio { get; set; }

        public bool FillCompetitors { get; set; }

        public WshEventData()
        {
            ConId = int.MaxValue;
            Filter = Order.EMPTY_STR;
            FillWatchlist = false;
            FillPortfolio = false;
            FillCompetitors = false;
        }

        public WshEventData(int conId)
        {
            ConId = conId;
            Filter = Order.EMPTY_STR;
            FillWatchlist = false;
            FillPortfolio = false;
            FillCompetitors = false;
        }

        public WshEventData(string filter, bool fillWatchlist, bool fillPortfolio, bool fillCompetitors)
        {
            ConId = int.MaxValue;
            Filter = filter;
            FillWatchlist = fillWatchlist;
            FillPortfolio = fillPortfolio;
            FillCompetitors = fillCompetitors;
        }
    }
}
