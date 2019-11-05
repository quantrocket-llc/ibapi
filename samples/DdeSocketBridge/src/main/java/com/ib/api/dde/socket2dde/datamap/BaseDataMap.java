/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.datamap;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;

/** Class represents base data map received from TWS */
abstract public class BaseDataMap {
    private DdeRequestStatus m_ddeRequestStatus = DdeRequestStatus.UNKNOWN;
    private DdeRequest m_ddeRequest;
    private String m_error = "";
    
    // gets
    public DdeRequest ddeRequest()             { return m_ddeRequest; }
    public DdeRequestStatus ddeRequestStatus() { return m_ddeRequestStatus; }
    public String error() { return m_error; }
    
    // sets
    public void ddeRequestStatus(DdeRequestStatus ddeRequestStatus) { m_ddeRequestStatus = ddeRequestStatus; }
    public void error(String error) { m_error = error; }

    public Object getValue(String field) {
        return null;
    }
    
    public BaseDataMap(DdeRequest ddeRequest) {
        m_ddeRequest = ddeRequest;
    }
}
