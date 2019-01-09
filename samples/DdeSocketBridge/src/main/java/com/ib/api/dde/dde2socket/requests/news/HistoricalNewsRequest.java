/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.news;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE historical news request (reqHistoricalNews) */
public class HistoricalNewsRequest extends DdeRequest {

    private final int m_conId;
    private final String m_providerCodes;
    private final String m_startDateTime;
    private final String m_endDateTime;
    private final int m_totalResults;
    
    // gets
    public int conId()            { return m_conId; }
    public String providerCodes() { return m_providerCodes; }
    public String startDateTime() { return m_startDateTime; }
    public String endDateTime()   { return m_endDateTime; }
    public int totalResults()     { return m_totalResults; }

    public HistoricalNewsRequest(int requestId, int conId, String providerCodes, String startDateTime, String endDateTime, 
            int totalResults, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_HISTORICAL_NEWS, ddeRequestString);
        m_conId = conId;
        m_providerCodes = providerCodes;
        m_startDateTime = startDateTime;
        m_endDateTime = endDateTime;
        m_totalResults = totalResults;
    }
}
