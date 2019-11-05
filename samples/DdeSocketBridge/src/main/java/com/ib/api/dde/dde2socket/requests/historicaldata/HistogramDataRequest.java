/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.historicaldata;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.client.Contract;

/** Class represents DDE histogram data request */
public class HistogramDataRequest extends DdeRequest {
    private final Contract m_contract;
    private final String m_timePeriod;
    private final boolean m_useRth;
    
    // gets
    public Contract contract() { return m_contract; }
    public String timePeriod() { return m_timePeriod; }
    public boolean useRth()    { return m_useRth; }

    public HistogramDataRequest(int requestId, Contract contract, String timePeriod, boolean useRth, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_HISTOGRAM_DATA, ddeRequestString);
        m_contract = contract;
        m_timePeriod = timePeriod;
        m_useRth = useRth;
    }
}
