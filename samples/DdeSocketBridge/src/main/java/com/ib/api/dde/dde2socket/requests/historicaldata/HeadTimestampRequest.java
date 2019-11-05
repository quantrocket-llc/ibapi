/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.historicaldata;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.client.Contract;

/** Class represents DDE head timestamp request */
public class HeadTimestampRequest extends DdeRequest {
    private final Contract m_contract;
    private final String m_whatToShow;
    private final int m_useRth;
    private final int m_formatDate;

    // gets
    public Contract contract()     { return m_contract; }
    public String whatToShow()     { return m_whatToShow; }
    public int useRth()            { return m_useRth; }
    public int formatDate()        { return m_formatDate; }

    public HeadTimestampRequest(int requestId, Contract contract, String whatToShow, int useRth, int formatDate, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_HEAD_TIMESTAMP, ddeRequestString);
        m_contract= contract;
        m_whatToShow = whatToShow;
        m_useRth = useRth;
        m_formatDate = formatDate;
    }
}
