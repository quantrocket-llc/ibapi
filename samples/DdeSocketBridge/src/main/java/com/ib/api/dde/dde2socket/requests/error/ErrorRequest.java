/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.error;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE error request */
public class ErrorRequest extends DdeRequest {
    private final int m_errorIndex; // index of error to start 

    public int errorsCount() {
        return m_errorIndex;
    }

    public ErrorRequest(int requestId, int errorIndex, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_ERRORS, ddeRequestString);
        m_errorIndex = errorIndex;
    }
}
