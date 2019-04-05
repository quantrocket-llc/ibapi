/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

import com.ib.client.Contract;
import com.ib.client.Order;
import com.ib.client.OrderState;

/** Class represents open order data received from TWS */
public class OpenOrderData extends OrderData {
    private final int m_orderId;
    private OrderStatusData m_orderStatus;
    private boolean m_isUpdated;

    // gets
    public int orderId()             { return m_orderId; }
    public OrderStatusData orderStatus() { return m_orderStatus; }
    public boolean isUpdated()       { return m_isUpdated; }
    
    // sets
    public void orderStatus(OrderStatusData orderStatus) { m_orderStatus = orderStatus; }
    public void isUpdated(boolean isUpdated) { m_isUpdated = isUpdated; }

    public OpenOrderData(int orderId, OrderStatusData orderStatus, boolean isUpdated) {
        m_orderId = orderId;
        m_orderStatus = orderStatus;
        m_isUpdated = isUpdated;
    }
    
    public OpenOrderData(int orderId, Contract contract, Order order, OrderState orderState, boolean isUpdated) {
        super(contract, order, orderState);
        m_orderId = orderId;
        m_isUpdated = isUpdated;
    }
    
    public OpenOrderData(int orderId, Contract contract, Order order, OrderState orderState, OrderStatusData orderStatus, boolean isUpdated) {
        this(orderId, contract, order, orderState, isUpdated);
        m_orderStatus = orderStatus;
        m_isUpdated = isUpdated;
    }
    
}
