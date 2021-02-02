/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

namespace IBSampleApp.messages
{
    class TickSizeMessage : MarketDataMessage
    {
        public TickSizeMessage(int requestId, int field, int size) : base(requestId, field)
        {
            Size = size;
        }

        public int Size { get; set; }
    }
}
