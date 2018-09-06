/* Copyright (C) 2018 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace TWSLib
{
    [ComVisible(true)]
    public class ComSoftDollarTier
    {
        private IBApi.SoftDollarTier tier;

        public ComSoftDollarTier(IBApi.Order order)
        {
            this.tier = order.Tier;
        }

        public ComSoftDollarTier(IBApi.SoftDollarTier tier)
        {
            this.tier = tier;
        }

        public string Name { get { return tier.Name; } set { tier = new IBApi.SoftDollarTier(value, tier.Value, tier.DisplayName); } }
        public string Value { get { return tier.Value; } set { tier = new IBApi.SoftDollarTier(tier.Name, value, tier.DisplayName); } }
    }
}
