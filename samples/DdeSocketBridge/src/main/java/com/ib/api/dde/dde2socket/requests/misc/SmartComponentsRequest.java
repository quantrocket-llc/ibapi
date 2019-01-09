/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.misc;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE smart components request */
public class SmartComponentsRequest extends DdeRequest {
    private final String m_bboExchange;

    // gets
    public String bboExchange() { return m_bboExchange; }

    public SmartComponentsRequest(int requestId, String bboExchange, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_SMART_COMPONENTS, ddeRequestString);
        m_bboExchange = bboExchange;
    }
}
