/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

/** Class represents smart component data received from TWS */
public class SmartComponentData {
    private final int m_bitNumber;
    private final String m_exchange; 
    private final Character m_exchangeLetter; 

    // gets
    public int bitNumber()            { return m_bitNumber; }
    public String exchange()          { return m_exchange; }
    public Character exchangeLetter() { return m_exchangeLetter; }

    public SmartComponentData(int bitNumber, String exchange, Character exchangeLetter) {
        m_bitNumber = bitNumber;
        m_exchange = exchange;
        m_exchangeLetter = exchangeLetter;
    }
}
