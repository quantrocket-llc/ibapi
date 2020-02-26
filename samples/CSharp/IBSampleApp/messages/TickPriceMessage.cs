/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using IBApi;

namespace IBSampleApp.messages
{
    class TickPriceMessage : MarketDataMessage
    {
        public TickPriceMessage(int requestId, int field, double price, TickAttrib attribs)
            : base(requestId, field)
        {
            Price = price;
            Attribs = attribs;
        }

        public TickAttrib Attribs { get; set; }

        public double Price { get; set; }
    }
}
