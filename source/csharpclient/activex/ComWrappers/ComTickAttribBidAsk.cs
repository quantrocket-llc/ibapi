/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using IBApi;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace TWSLib
{
    /**
     * @class TickAttribBidAsk
     * @brief Class describing tick attrib bid/ask
     */
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComTickAttribBidAsk : ComWrapper<TickAttribBidAsk>, ITickAttribBidAsk
    {
        /**
         * @brief bidPastlow
         */
        bool BidPastLow
        {
            get { return data != null ? data.BidPastLow : default(bool); }
            set { if (data != null) data.BidPastLow = value; }
        }

        /**
         * @brief askPastHigh
         */
        bool AskPastHigh
        {
            get { return data != null ? data.AskPastHigh : default(bool); }
            set { if (data != null) data.AskPastHigh = value; }
        }

        public ComTickAttribBidAsk()
        {
        }

        public static explicit operator TickAttribBidAsk(ComTickAttribBidAsk comTickAttribBidAsk)
        {
            return comTickAttribBidAsk.ConvertTo();
        }

        public static explicit operator ComTickAttribBidAsk(TickAttribBidAsk tickAttribBidAsk)
        {
            return new ComTickAttribBidAsk().ConvertFrom(tickAttribBidAsk) as ComTickAttribBidAsk;
        }

        bool TWSLib.ITickAttribBidAsk.bidPastLow { get { return BidPastLow; } set { BidPastLow = value; } }
        bool TWSLib.ITickAttribBidAsk.askPastHigh { get { return AskPastHigh; } set { AskPastHigh = value; } }
    }
}
