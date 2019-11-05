/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.news;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.client.Contract;

/** Class represents DDE news ticks request (reqMktData(genTicks=mdoff,292)) */
public class NewsTicksRequest extends DdeRequest {

    private final Contract m_contract;
    
    // gets
    public Contract contract() { return m_contract; }

    public NewsTicksRequest(int requestId, Contract contract, String ddeRequestString) {
        super(requestId, DdeRequestType.REQ_NEWS_TICKS, ddeRequestString);
        m_contract = contract;
    }
}
