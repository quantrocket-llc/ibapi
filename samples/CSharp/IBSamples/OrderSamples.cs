﻿/* Copyright (C) 2013 Interactive Brokers LLC. All rights reserved.  This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using IBApi;

namespace Samples
{
    public class OrderSamples
    {
        public static Order LimitOrder()
        {
            Order order = new Order();
            order.Action = "BUY";
            order.OrderType = "LMT";
            order.TotalQuantity = 100;
            //When the TWS/IB Gateway's username has access to more than a single account. it is necessary to pass in the account id
            //to which the order will be allocated.
            order.Account = "DU74649";
            order.LmtPrice = 0.8;
            return order;
        }

        public static Order MarketOrder()
        {
            Order order = new Order();
            order.Action = "BUY";
            order.OrderType = "MKT";
            order.TotalQuantity = 1;
            return order;
        }

        /**
         * Combos require the NonGuaranteed routing parameter.
         */
        public static Order ComboMarketOrder()
        {
            Order order = new Order();
            order.Action = "BUY";
            order.OrderType = "MKT";
            order.TotalQuantity = 1;
            order.SmartComboRoutingParams = new List<TagValue>();
            //order.SmartComboRoutingParams.Add(new TagValue("NonGuaranteed", "1"));
            return order;
        }
        public static Order ComboLimitOrder()
        {
            Order order = new Order();
            order.Action = "BUY";
            order.OrderType = "LMT";
            order.TotalQuantity = 1;
            order.LmtPrice = -0.15;
            order.SmartComboRoutingParams = new List<TagValue>();
            order.Transmit = false;
            //order.SmartComboRoutingParams.Add(new TagValue("NonGuaranteed", "1"));
            return order;
        }

        public static Order LimitOrderForComboWithLegPrice()
        {
            Order order = new Order();
            order.Action = "BUY";
            order.OrderType = "LMT";
            order.TotalQuantity = 1;

            OrderComboLeg ocl1 = new OrderComboLeg();
            ocl1.Price = 5.0;

            OrderComboLeg ocl2 = new OrderComboLeg();
            ocl2.Price = 5.90;
            order.OrderComboLegs = new List<OrderComboLeg>();
            order.OrderComboLegs.Add(ocl1);
            order.OrderComboLegs.Add(ocl2);

            order.SmartComboRoutingParams = new List<TagValue>();
            order.SmartComboRoutingParams.Add(new TagValue("NonGuaranteed", "1"));

            return order;
        }

    }
}
