/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.orders;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE auto open orders request */
public class AutoOpenOrdersRequest extends DdeRequest {
    
    private final boolean m_autoBind;
    
    // gets
    public boolean autoBind() { return m_autoBind; }
    
    public AutoOpenOrdersRequest(int reqId, boolean autoBind, String ddeRequestString) {
        super(reqId, DdeRequestType.REQ_AUTO_OPEN_ORDERS, ddeRequestString);
        m_autoBind = autoBind;
    }
}
