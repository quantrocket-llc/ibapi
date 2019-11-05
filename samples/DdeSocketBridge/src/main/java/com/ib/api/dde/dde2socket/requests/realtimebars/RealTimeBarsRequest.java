/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.realtimebars;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.client.Contract;

/** Class represents DDE real time bars request */
public class RealTimeBarsRequest extends DdeRequest {
    private final Contract m_contract;
    private final int m_barSize;
    private final String m_whatToShow;
    private final boolean m_useRth;

    // gets
    public Contract contract() { return m_contract; }
    public int barSize()       { return m_barSize; }
    public String whatToShow() { return m_whatToShow; }
    public boolean useRth()    { return m_useRth; }

    public RealTimeBarsRequest(int requestId, Contract contract, int barSize, String whatToShow,
            boolean useRth, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_REAL_TIME_BARS, ddeRequestString);
        m_contract= contract;
        m_barSize = barSize;
        m_whatToShow = whatToShow;
        m_useRth = useRth;
    }
}
