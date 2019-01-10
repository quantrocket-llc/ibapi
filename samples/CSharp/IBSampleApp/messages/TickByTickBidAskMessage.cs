﻿/* Copyright (C) 2018 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using IBApi;

namespace IBSampleApp.messages
{
    class TickByTickBidAskMessage
    {
        public int ReqId { get; private set; }
        public long Time { get; private set; }
        public double BidPrice { get; private set; }
        public double AskPrice { get; private set; }
        public long BidSize { get; private set; }
        public long AskSize { get; private set; }
        public TickAttribBidAsk TickAttribBidAsk { get; private set; }

        public TickByTickBidAskMessage(int reqId, long time, double bidPrice, double askPrice, long bidSize, long askSize, TickAttribBidAsk tickAttribBidAsk)
        {
            ReqId = reqId;
            Time = time;
            BidPrice = bidPrice;
            AskPrice = askPrice;
            BidSize = bidSize;
            AskSize = askSize;
            TickAttribBidAsk = tickAttribBidAsk;
        }
    }
}
