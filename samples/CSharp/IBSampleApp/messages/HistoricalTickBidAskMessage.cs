/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using IBApi;

namespace IBSampleApp.messages
{
    class HistoricalTickBidAskMessage
    {
        public int ReqId { get; set; }
        public long Time { get; set; }
        public TickAttribBidAsk TickAttribBidAsk { get; set; }
        public double PriceBid { get; set; }
        public double PriceAsk { get; set; }
        public long SizeBid { get; set; }
        public long SizeAsk { get; set; }

        public HistoricalTickBidAskMessage(int reqId, long time, TickAttribBidAsk tickAttribBidAsk, double priceBid, double priceAsk, long sizeBid, long sizeAsk)
        {
            ReqId = reqId;
            Time = time;
            TickAttribBidAsk = tickAttribBidAsk;
            PriceBid = priceBid;
            PriceAsk = priceAsk;
            SizeBid = sizeBid;
            SizeAsk = sizeAsk;
        }
    }
}
