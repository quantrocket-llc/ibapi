/* Copyright (C) 2021 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.historicaldata;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.client.Contract;

/** Class represents DDE historical schedule request */
public class HistoricalScheduleRequest extends DdeRequest {
    private final Contract m_contract;
    private final String m_endDateTime;
    private final String m_durationStr;
    private final int m_useRth;
    private final int m_formatDate;

    // gets
    public Contract contract()     { return m_contract; }
    public String endDateTime()    { return m_endDateTime; }
    public String durationStr()    { return m_durationStr; }
    public int useRth()            { return m_useRth; }
    public int formatDate()        { return m_formatDate; }

    public HistoricalScheduleRequest(int requestId, Contract contract, String endDateTime, String durationStr, int useRth, int formatDate, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_HISTORICAL_SCHEDULE, ddeRequestString);
        m_contract= contract;
        m_endDateTime = endDateTime;
        m_durationStr = durationStr;
        m_useRth = useRth;
        m_formatDate = formatDate;
    }
}
