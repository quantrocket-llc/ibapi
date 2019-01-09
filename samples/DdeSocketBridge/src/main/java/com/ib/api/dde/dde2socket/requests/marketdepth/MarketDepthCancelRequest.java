/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.marketdepth;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE market depth cancel request (cancelMktDepth) */
public class MarketDepthCancelRequest extends DdeRequest {

    private final boolean m_isSmartDepth;
    
    // gets
    public boolean isSmartDepth() { return m_isSmartDepth; }

    public MarketDepthCancelRequest(int requestId, boolean isSmartDepth, String ddeRequestString) {
        super(requestId, DdeRequestType.CANCEL_MARKET_DEPTH, ddeRequestString);
        m_isSmartDepth = isSmartDepth;
    }
}
