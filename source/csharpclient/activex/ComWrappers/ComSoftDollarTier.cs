/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace TWSLib
{
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComSoftDollarTier : ComWrapper<IBApi.SoftDollarTier>, ISoftDollarTier
    {
        public ComSoftDollarTier(IBApi.Order order)
        {
            this.data = order.Tier;
        }

        public ComSoftDollarTier(IBApi.SoftDollarTier tier)
        {
            this.data = tier;
        }

        public ComSoftDollarTier()
        {
            this.data = new IBApi.SoftDollarTier();
        }

        public string Name { get { return data.Name; } set { data.Name = value; } }
        public string DisplayName { get { return data.DisplayName; } set { data.DisplayName = value; } }
        public string Value { get { return data.Value; } set { data.Value = value; } }
    }
}
