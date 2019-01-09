/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.pnl;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE PnL request (reqPnL, reqPnLSingle) */
public class PnLRequest extends DdeRequest {

    private final String m_account;
    private final String m_modelCode;
    private final int m_conId;
    
    // gets
    public String account()   { return m_account; }
    public String modelCode() { return m_modelCode; }
    public int conId()        { return m_conId; }

    public PnLRequest(int requestId, String account, String modelCode, int conId, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_PNL, ddeRequestString);
        m_account = account;
        m_modelCode = modelCode;
        m_conId = conId;
    }
}
