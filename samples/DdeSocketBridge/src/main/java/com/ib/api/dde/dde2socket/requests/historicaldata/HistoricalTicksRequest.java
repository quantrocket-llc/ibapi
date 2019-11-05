/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.historicaldata;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.client.Contract;

/** Class represents DDE historical ticks request */
public class HistoricalTicksRequest extends DdeRequest {
    private final Contract m_contract;
    private final String m_startDateTime;
    private final String m_endDateTime;
    private final int m_numberOfTicks;
    private final String m_whatToShow;
    private final int m_useRth;
    private final boolean m_ignoreSize;
    
    // gets
    public Contract contract()    { return m_contract; }
    public String startDateTime() { return m_startDateTime; }
    public String endDateTime()   { return m_endDateTime; }
    public int numberOfTicks()    { return m_numberOfTicks; }
    public String whatToShow()    { return m_whatToShow; }
    public int useRth()           { return m_useRth; }
    public boolean ignoreSize()   { return m_ignoreSize; }

    public HistoricalTicksRequest(int requestId, Contract contract, String startDateTime, String endDateTime, int numberOfTicks,
            String whatToShow, int useRth, boolean ignoreSize, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_HISTORICAL_TICKS, ddeRequestString);
        m_contract= contract;
        m_startDateTime = startDateTime;
        m_endDateTime = endDateTime;
        m_numberOfTicks = numberOfTicks;
        m_whatToShow = whatToShow;
        m_useRth = useRth;
        m_ignoreSize = ignoreSize;
    }
}
