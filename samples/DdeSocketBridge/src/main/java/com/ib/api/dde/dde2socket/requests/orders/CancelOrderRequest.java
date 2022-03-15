/* Copyright (C) 2022 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.orders;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE cancel order request (cancelOrder) */
public class CancelOrderRequest extends DdeRequest {

    private final String m_manualOrderCancelTime;

    // gets
    public String manualOrderCancelTime() { return m_manualOrderCancelTime; }

    public CancelOrderRequest(int requestId, String manualOrderCancelTime, String ddeRequestString) {
        super(requestId, DdeRequestType.CANCEL_ORDER, ddeRequestString);
        m_manualOrderCancelTime = manualOrderCancelTime;
    }
}
