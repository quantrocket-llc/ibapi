/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.orders;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE completed orders request */
public class CompletedOrdersRequest extends DdeRequest {

    private boolean m_apiOnly;

    //gets
    public boolean apiOnly() { return m_apiOnly; }

    public CompletedOrdersRequest(int requestId, boolean apiOnly, String ddeRequestString) {
        super(requestId, DdeRequestType.REQ_COMPLETED_ORDERS, ddeRequestString);
        m_apiOnly = apiOnly;
    }
}
