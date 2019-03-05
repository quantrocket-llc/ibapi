/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

import com.ib.client.ContractDetails;

/** Class represents scanner data received from TWS */
public class ScannerData {
    private final int m_requestId; 
    private final int m_rank;
    private final ContractDetails m_contractDetails;
    private final String m_distance;
    private final String m_benchmark;
    private final String m_projection;
    private final String m_legsStr;

    // gets
    public int requestId()                   { return m_requestId; }
    public int rank()                        { return m_rank; }
    public ContractDetails contractDetails() { return m_contractDetails; }
    public String distance()                 { return m_distance; }
    public String benchmark()                { return m_benchmark; }
    public String projection()               { return m_projection; }
    public String legsStr()                  { return m_legsStr; }

    public ScannerData(int requestId, int rank, ContractDetails contractDetails, String distance, String benchmark, 
            String projection, String legsStr) {
        m_requestId = requestId;
        m_rank = rank;
        m_contractDetails = contractDetails;
        m_distance = distance;
        m_benchmark = benchmark;
        m_projection = projection;
        m_legsStr = legsStr;
    }
}
