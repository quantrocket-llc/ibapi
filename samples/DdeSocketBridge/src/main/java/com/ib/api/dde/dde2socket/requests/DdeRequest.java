/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests;

/** Class represents DDE base request */
public class DdeRequest {

    protected final int m_requestId;
    protected final DdeRequestType m_ddeRequestType;
    protected final String m_ddeRequestString;

    // gets
    public int requestId()                 { return m_requestId; }
    public DdeRequestType ddeRequestType() { return m_ddeRequestType; }
    public String ddeRequestString()       { return m_ddeRequestString; }

    public DdeRequest(int requestId, DdeRequestType ddeRequestType, String ddeRequestString) {
        m_requestId = requestId;
        m_ddeRequestType = ddeRequestType;
        m_ddeRequestString = ddeRequestString;
    }
}
