/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.contractdetails;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE matching symbols request */
public class MatchingSymbolsRequest extends DdeRequest {
    private final String m_pattern;

    // gets
    public String pattern() { return m_pattern; }

    public MatchingSymbolsRequest(int requestId, String pattern, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_MATCHING_SYMBOLS, ddeRequestString);
        m_pattern = pattern;
    }
}
