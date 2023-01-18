/* Copyright (C) 2022 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using IBApi;

namespace IBSampleApp.messages
{
    class TickGenericMessage : MarketDataMessage
    {
        public TickGenericMessage(int requestId, int field, double price)
            : base(requestId, field)
        {
            Price = price;
        }

        public double Price { get; set; }
    }
}
