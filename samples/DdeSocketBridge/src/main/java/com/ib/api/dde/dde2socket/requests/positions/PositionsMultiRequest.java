/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.positions;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE positions multi request */
public class PositionsMultiRequest extends DdeRequest {
    private final String m_account;
    private final String m_modelCode;
    
    // gets
    public String account()   { return m_account; }
    public String modelCode() { return m_modelCode; }
    
    public PositionsMultiRequest(int requestId, String account, String modelCode, String ddeRequestString) {
        super(requestId, DdeRequestType.REQ_POSITIONS_MULTI, ddeRequestString);
        m_account = account;
        m_modelCode = modelCode;
    }
}
