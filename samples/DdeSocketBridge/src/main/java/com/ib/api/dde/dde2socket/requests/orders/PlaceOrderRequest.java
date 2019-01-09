/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.orders;

import com.ib.client.Contract;
import com.ib.client.Order;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE place order request (placeOrder) */
public class PlaceOrderRequest extends DdeRequest {

    private final Contract m_contract;
    private final Order m_order;
    
    // gets
    public Contract contract() { return m_contract; }
    public Order order()       { return m_order; }

    public PlaceOrderRequest(int requestId, Contract contract, Order order, String ddeRequestString) {
        super(requestId, DdeRequestType.PLACE_ORDER, ddeRequestString);
        m_contract = contract;
        m_order = order;
    }
}
