/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.accountupdates;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE account summary request */
public class AccountSummaryRequest extends DdeRequest {

    private final String m_group;
    private final String m_tags;

    // gets
    public String group() { return m_group; }
    public String tags()  { return m_tags; }

    public AccountSummaryRequest(int requestId, String group, String tags, String ddeRequestString) {
        super(requestId, DdeRequestType.REQ_ACCOUNT_SUMMARY, ddeRequestString);
        m_group = group;
        m_tags = tags;
    }
}
