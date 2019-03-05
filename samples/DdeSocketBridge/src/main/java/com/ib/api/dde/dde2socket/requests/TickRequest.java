/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents tick request from DDE */
public class TickRequest extends DdeRequest {

    private final String m_tickType;

    // gets
    public String tickType() { return m_tickType; }

    public TickRequest(int requestId, String tickType, DdeRequestType ddeRequestType, String ddeRequestString) {
        super(requestId, ddeRequestType, ddeRequestString);
        m_tickType = tickType;
    }
}
