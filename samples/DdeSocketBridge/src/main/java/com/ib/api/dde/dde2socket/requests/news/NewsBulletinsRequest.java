/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.news;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE news bulletins request (reqNewsBulletins) */
public class NewsBulletinsRequest extends DdeRequest {

    private final boolean m_allMsgs;
    
    // gets
    public boolean allMsgs() { return m_allMsgs; }

    public NewsBulletinsRequest(int requestId, boolean allMsgs, String ddeRequestString) {
        super(requestId, DdeRequestType.REQ_NEWS_BULLETINS, ddeRequestString);
        m_allMsgs = allMsgs;
    }
}
