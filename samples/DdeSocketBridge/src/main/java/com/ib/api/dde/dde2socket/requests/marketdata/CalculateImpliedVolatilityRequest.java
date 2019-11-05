/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.marketdata;

import com.ib.client.Contract;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE calculate implied volatility request (calculateImpliedVolatility) */
public class CalculateImpliedVolatilityRequest extends DdeRequest {

    private final Contract m_contract;
    private final double m_optionPrice;
    private final double m_underlyingPrice;
    
    // gets
    public Contract contract()      { return m_contract; }
    public double optionPrice()     { return m_optionPrice; }
    public double underlyingPrice() { return m_underlyingPrice; }

    public CalculateImpliedVolatilityRequest(int requestId, Contract contract, double optionPrice, double underlyingPrice, String ddeRequestString) {
        super(requestId, DdeRequestType.CALCULATE_IMPLIED_VOLATILITY, ddeRequestString);
        m_contract = contract;
        m_optionPrice = optionPrice;
        m_underlyingPrice = underlyingPrice;
    }
}
