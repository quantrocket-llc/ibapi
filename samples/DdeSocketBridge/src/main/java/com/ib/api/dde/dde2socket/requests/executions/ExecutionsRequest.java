/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.executions;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.client.ExecutionFilter;

/** Class represents DDE executions request */
public class ExecutionsRequest extends DdeRequest {
    
    private final ExecutionFilter m_executionFilter;
    
    // gets
    public ExecutionFilter executionFilter()    { return m_executionFilter; }
    
    public ExecutionsRequest(int requestId, ExecutionFilter executionFilter, String ddeRequestString) {
        super(requestId, DdeRequestType.REQ_EXECUTIONS, ddeRequestString);
        m_executionFilter = executionFilter;
    }
}
