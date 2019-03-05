/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.positions;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE positions request */
public class PositionsRequest extends DdeRequest {
    
    public PositionsRequest(int requestId, String ddeRequestString) {
        super(requestId, DdeRequestType.REQ_POSITIONS, ddeRequestString);
    }
}
