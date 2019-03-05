/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.marketdata;

import com.ib.client.Contract;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE calculate option price request (calculateOptionPrice) */
public class CalculateOptionPriceRequest extends DdeRequest {

    private final Contract m_contract;
    private final double m_impliedVolatility;
    private final double m_underlyingPrice;
    
    // gets
    public Contract contract()      { return m_contract; }
    public double impliedVolatility()     { return m_impliedVolatility; }
    public double underlyingPrice() { return m_underlyingPrice; }

    public CalculateOptionPriceRequest(int requestId, Contract contract, double impliedVolatility, double underlyingPrice, String ddeRequestString) {
        super(requestId, DdeRequestType.CALCULATE_OPTION_PRICE, ddeRequestString);
        m_contract = contract;
        m_impliedVolatility = impliedVolatility;
        m_underlyingPrice = underlyingPrice;
    }
}
