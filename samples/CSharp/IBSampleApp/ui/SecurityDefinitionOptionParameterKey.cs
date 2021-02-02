/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

namespace IBSampleApp.ui
{
    class SecDefOptParamKey
    {
        string exchange;
        private int underlyingConId;
        private string tradingClass;
        private string multiplier;

        public SecDefOptParamKey(string exchange, int underlyingConId, string tradingClass, string multiplier)
        {
            this.exchange = exchange;
            this.underlyingConId = underlyingConId;
            this.tradingClass = tradingClass;
            this.multiplier = multiplier;
        }

        public override bool Equals(object obj)
        {
            if (!(obj is SecDefOptParamKey))
                return false;

            SecDefOptParamKey left = obj as SecDefOptParamKey;

            return left.underlyingConId == underlyingConId && left.tradingClass == tradingClass && left.multiplier == multiplier;
        }

        public override int GetHashCode()
        {
            return exchange.GetHashCode() + underlyingConId + tradingClass.GetHashCode() + multiplier.GetHashCode();
        }

        public override string ToString()
        {
            return exchange + " " + underlyingConId + " " + tradingClass + " " + multiplier;
        }
    }
}
