/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

import com.ib.client.Contract;
import com.ib.client.Order;
import com.ib.client.OrderState;

/** Class represents order data received from TWS */
public class OrderData {
    private Contract m_contract;
    private Order m_order;
    private OrderState m_orderState;

    // gets
    public Contract contract()       { return m_contract; }
    public Order order()             { return m_order; }
    public OrderState orderState()   { return m_orderState; }
    
    // sets
    public void contract(Contract contract) { m_contract = contract; }
    public void order(Order order) { m_order = order; }
    public void orderState(OrderState orderState) { m_orderState = orderState; }

    public OrderData() { }
    
    public OrderData(Contract contract, Order order, OrderState orderState) {
        m_contract = contract;
        m_order = order;
        m_orderState = orderState;
    }
}
