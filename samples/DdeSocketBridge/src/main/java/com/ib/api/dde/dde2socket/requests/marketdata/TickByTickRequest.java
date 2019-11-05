/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.marketdata;

import com.ib.client.Contract;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE tick-by-tick data request (reqTickByTickData) */
public class TickByTickRequest extends DdeRequest {

    private final Contract m_contract;
    private final String m_tickType;
    private final int m_numberOfRows;
    private final boolean m_ignoreSize;
    
    // gets
    public Contract contract()  { return m_contract; }
    public String tickType()    { return m_tickType; }
    public int numberOfRows()   { return m_numberOfRows; }
    public boolean ignoreSize() { return m_ignoreSize; }

    public TickByTickRequest(int requestId, Contract contract, String tickType, int numberOfRows, boolean ignoreSize, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_TICK_BY_TICK_DATA, ddeRequestString);
        m_contract = contract;
        m_tickType = tickType;
        m_numberOfRows = numberOfRows;
        m_ignoreSize = ignoreSize;
    }
}
