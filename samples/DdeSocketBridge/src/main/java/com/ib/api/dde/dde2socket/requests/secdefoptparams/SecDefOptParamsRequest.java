/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.secdefoptparams;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE security definition option parameters request */
public class SecDefOptParamsRequest extends DdeRequest {
    
    private final String m_underlyingSymbol;
    private final String m_futFopExchange;
    private final String m_underlyingSecType;
    private final int m_underlyingConId;

    // gets
    public String underlyingSymbol()  { return m_underlyingSymbol; }
    public String futFopExchange()    { return m_futFopExchange; }
    public String underlyingSecType() { return m_underlyingSecType; }
    public int underlyingConId()      { return m_underlyingConId; }

    public SecDefOptParamsRequest(int requestId, String underlyingSymbol, String futFopExchange, String underlyingSecType,
            int underlyingConId, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_SEC_DEF_OPT_PARAMS, ddeRequestString);
        m_underlyingSymbol = underlyingSymbol;
        m_futFopExchange = futFopExchange;
        m_underlyingSecType = underlyingSecType;
        m_underlyingConId = underlyingConId;
    }
}
