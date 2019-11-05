/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.accountupdates;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE account updates multi request */
public class AccountUpdatesMultiRequest extends DdeRequest {
    private final String m_account;
    private final String m_modelCode;
    private final boolean m_ledgerAndNLV;
    
    // gets
    public String account()       { return m_account; }
    public String modelCode()     { return m_modelCode; }
    public boolean ledgerAndNLV() { return m_ledgerAndNLV; }
    
    public AccountUpdatesMultiRequest(int requestId, String account, String modelCode, boolean ledgerAndNLV, String ddeRequestString) {
        super(requestId, DdeRequestType.REQ_ACCOUNT_UPDATES_MULTI, ddeRequestString);
        m_account = account;
        m_modelCode = modelCode;
        m_ledgerAndNLV = ledgerAndNLV;
    }
}
