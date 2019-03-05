/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.orders;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents order status request (status, filled, remaining etc) from DDE */
public class OrderStatusRequest extends DdeRequest {

    private final String m_field;

    // gets
    public String field() { return m_field; }

    public OrderStatusRequest(int requestId, String field, String ddeRequestString) {
        super(requestId, DdeRequestType.ORDER_STATUS, ddeRequestString);
        m_field = field;
    }
}
