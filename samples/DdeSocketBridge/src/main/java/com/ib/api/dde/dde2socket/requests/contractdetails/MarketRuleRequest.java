/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.contractdetails;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE market rule request */
public class MarketRuleRequest extends DdeRequest {
    private final int m_marketRuleId;

    // gets
    public int marketRuleId() { return m_marketRuleId; }

    public MarketRuleRequest(int requestId, int marketRuleId, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_MARKET_RULE, ddeRequestString);
        m_marketRuleId = marketRuleId;
    }
}
