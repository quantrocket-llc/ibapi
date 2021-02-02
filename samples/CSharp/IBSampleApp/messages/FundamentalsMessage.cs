/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

namespace IBSampleApp.messages
{
    class FundamentalsMessage
    {
        public FundamentalsMessage(string data)
        {
            Data = data;
        }

        public string Data { get; set; }
    }
}
