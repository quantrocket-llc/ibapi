/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.fundamentaldata;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.client.Contract;

/** Class represents DDE fundamental data request */
public class FundamentalDataRequest extends DdeRequest {
    private final Contract m_contract;
    private final String m_reportType;

    // gets
    public Contract contract() { return m_contract; }
    public String reportType() { return m_reportType; }

    public FundamentalDataRequest(int requestId, Contract contract, String reportType, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_FUNDAMENTAL_DATA, ddeRequestString);
        m_contract= contract;
        m_reportType = reportType;
    }
}
