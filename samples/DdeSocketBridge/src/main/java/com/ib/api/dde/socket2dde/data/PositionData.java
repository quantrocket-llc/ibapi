/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

import com.ib.client.Contract;

/** Class represents position/position multi data received from TWS */
public class PositionData {
    private final int m_requestId; 
    private final String m_account;
    private final String m_modelCode;
    private final Contract m_contract;
    private final double m_position;
    private final double m_avgCost;
    
    private final double m_marketPrice;
    private final double m_marketValue;
    private final double m_unrealizedPNL;
    private final double m_realizedPNL;
    
    // gets
    public int requestId()        { return m_requestId; }
    public String account()       { return m_account; }
    public String modelCode()     { return m_modelCode; }
    public Contract contract()    { return m_contract; }
    public double position()      { return m_position; }
    public double avgCost()       { return m_avgCost; }
    public double marketPrice()   { return m_marketPrice; }
    public double marketValue()   { return m_marketValue; }
    public double unrealizedPNL() { return m_unrealizedPNL; }
    public double realizedPNL()   { return m_realizedPNL; }

    public PositionData(int requestId, String account, String modelCode, Contract contract, double position, double avgCost) {
        m_requestId = requestId;
        m_account = account;
        m_modelCode = modelCode;
        m_contract = contract;
        m_position = position;
        m_avgCost = avgCost;
        m_marketPrice = 0;
        m_marketValue = 0;
        m_unrealizedPNL = 0;
        m_realizedPNL = 0;
    }
    
    public PositionData(int requestId, String account, Contract contract, double position, double avgCost, 
            double marketPrice, double marketValue, double unrealizedPNL, double realizedPNL) {
        m_requestId = requestId;
        m_account = account;
        m_modelCode = "";
        m_contract = contract;
        m_position = position;
        m_avgCost = avgCost;
        m_marketPrice = marketPrice;
        m_marketValue = marketValue;
        m_unrealizedPNL = unrealizedPNL;
        m_realizedPNL = realizedPNL;

    }
    
}
