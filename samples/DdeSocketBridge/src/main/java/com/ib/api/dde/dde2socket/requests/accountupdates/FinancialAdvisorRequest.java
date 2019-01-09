/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.accountupdates;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE FA request */
public class FinancialAdvisorRequest extends DdeRequest {
    private final int m_faDataType;
    
    // gets
    public int faDataType() { return m_faDataType; }
    
    public FinancialAdvisorRequest(int requestId, int faDataType, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_FA, ddeRequestString);
        m_faDataType = faDataType;
    }
}
