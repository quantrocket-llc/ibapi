/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.orders;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE open orders request */
public class OpenOrdersRequest extends DdeRequest {
    
    private boolean m_allOrders;
    
    //gets
    public boolean allOrders() { return m_allOrders; }

    public OpenOrdersRequest(int requestId, boolean allOrders, String ddeRequestString) {
        super(requestId, DdeRequestType.REQ_OPEN_ORDERS, ddeRequestString);
    }
}
