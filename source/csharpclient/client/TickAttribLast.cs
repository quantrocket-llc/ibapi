/* Copyright (C) 2018 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace IBApi
{
    /**
     * @class TickAttribLast
     * @brief Tick attributes that describes additional information for last price ticks
     * @sa EWrapper::tickByTickAllLast, EWrapper::historicalTicksLast
     */
    public class TickAttribLast
    {
        /**
         * @brief Used with tick-by-tick last data or historical ticks last to indicate if a trade is halted
         */
        public bool PastLimit { get; set; }

        /**
         * @brief Used with tick-by-tick last data or historical ticks last to indicate if a trade is classified as 'unreportable' (odd lots, combos, derivative trades, etc)
        */
        public bool Unreported { get; set; }

        /**
         * @brief Returns string to display. 
         */
        public string toString()
        {
            return (PastLimit ? "pastLimit " : "") +
                (Unreported ? "unreported " : "");
        }
    }
}
