/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.marketdepth;

import com.ib.client.Contract;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE market depth request (reqMktDepth) */
public class MarketDepthRequest extends DdeRequest {

    private final Contract m_contract;
    private final int m_numRows;
    private final boolean m_isSmartDepth;

    // gets
    public Contract contract()    { return m_contract; }
    public int numRows()          { return m_numRows; }
    public boolean isSmartDepth() { return m_isSmartDepth; }

    public MarketDepthRequest(int requestId, Contract contract, int numRows, boolean isSmartDepth, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_MARKET_DEPTH, ddeRequestString);
        m_contract = contract;
        m_numRows = numRows;
        m_isSmartDepth = isSmartDepth;
    }
}
