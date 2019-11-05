/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.marketdata;

import com.ib.client.Contract;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE market data request (reqMktData) */
public class MarketDataRequest extends DdeRequest {

    private final Contract m_contract;
    private final String m_genericTicks;
    private final boolean m_snapshot;
    
    // gets
    public Contract contract()   { return m_contract; }
    public String genericTicks() { return m_genericTicks; }
    public boolean snapshot()    { return m_snapshot; }

    public MarketDataRequest(int requestId, Contract contract, String genericTicks, boolean snapshot, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_MARKET_DATA, ddeRequestString);
        m_contract = contract;
        m_genericTicks = genericTicks;
        m_snapshot = snapshot;
    }
}
