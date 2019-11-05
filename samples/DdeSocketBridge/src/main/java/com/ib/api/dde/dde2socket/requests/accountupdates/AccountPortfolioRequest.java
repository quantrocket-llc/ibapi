/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.accountupdates;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE account updates multi request */
public class AccountPortfolioRequest extends DdeRequest {
    private final String m_account;
    
    // gets
    public String account() { return m_account; }
    
    public AccountPortfolioRequest(int requestId, String account, String ddeRequestString) {
        super(requestId, DdeRequestType.REQ_ACCOUNT_PORTFOLIO, ddeRequestString);
        m_account = account;
    }
}
