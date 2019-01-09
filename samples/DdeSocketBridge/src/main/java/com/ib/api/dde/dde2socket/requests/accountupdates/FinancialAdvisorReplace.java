/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.accountupdates;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE FA replace */
public class FinancialAdvisorReplace extends DdeRequest {
    private final int m_faDataType;
    private final String m_xml;
    
    // gets
    public int faDataType() { return m_faDataType; }
    public String xml()     { return m_xml; }
    
    public FinancialAdvisorReplace(int requestId, int faDataType, String xml, String ddeRequestString) {
        super(requestId, DdeRequestType.REPLACE_FA, ddeRequestString);
        m_faDataType = faDataType;
        m_xml = xml;
    }
}
