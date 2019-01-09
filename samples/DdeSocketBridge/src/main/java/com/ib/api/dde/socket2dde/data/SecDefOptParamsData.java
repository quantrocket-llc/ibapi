/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

import java.util.Set;

/** Class represents security definition option parameter data received from TWS */
public class SecDefOptParamsData {

    private final String m_exchange;
    private final int m_underlyingConId;
    private final String m_tradingClass;
    private final String m_multiplier;
    private final Set<String> m_expirations;
    private final Set<Double> m_strikes;
    
    // gets
    public String exchange()         { return m_exchange; }
    public int underlyingConId()     { return m_underlyingConId; }
    public String tradingClass()     { return m_tradingClass; }
    public String multiplier()       { return m_multiplier; }
    public Set<String> expirations() { return m_expirations; }
    public Set<Double> strikes()     { return m_strikes; }

    public SecDefOptParamsData(String exchange, int underlyingConId, String tradingClass, String multiplier, 
            Set<String> expirations, Set<Double> strikes) {
        m_exchange = exchange;
        m_underlyingConId = underlyingConId;
        m_tradingClass = tradingClass;
        m_multiplier = multiplier;
        m_expirations = expirations;
        m_strikes = strikes;
    }
}
