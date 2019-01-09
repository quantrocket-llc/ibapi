/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

/** Class represents order status data received from TWS */
public class OrderStatusData {
    private final int m_orderId;
    private final String m_status;
    private final double m_filled;
    private final double m_remaining;
    private final double m_avgFillPrice;
    private final int m_permId;
    private final int m_parentId; 
    private final double m_lastFillPrice;
    private final int m_clientId;
    private final String m_whyHeld;
    private final double m_mktCapPrice;
    private String m_errorMessage;
    
    // gets
    public int orderId()          { return m_orderId; }
    public String status()        { return m_status; }
    public double filled()        { return m_filled; }
    public double remaining()     { return m_remaining; }
    public double avgFillPrice()  { return m_avgFillPrice; }
    public int permId()           { return m_permId; }
    public int parentId()         { return m_parentId; }
    public double lastFillPrice() { return m_lastFillPrice; }
    public int clientId()         { return m_clientId; }
    public String whyHeld()       { return m_whyHeld; }
    public double mktCapPrice()   { return m_mktCapPrice; }
    public String errorMessage()  { return m_errorMessage; }
    
    // sets
    public void errorMessage(String errorMessage) { m_errorMessage = errorMessage; }
    
    public OrderStatusData(int orderId, String status, double filled, 
                double remaining, double avgFillPrice, int permId, int parentId, 
                double lastFillPrice, int clientId, String whyHeld, double mktCapPrice) {
        m_orderId = orderId;
        m_status = status;
        m_filled = filled;
        m_remaining = remaining;
        m_avgFillPrice = avgFillPrice;
        m_permId = permId;
        m_parentId = parentId;
        m_lastFillPrice = lastFillPrice;
        m_clientId = clientId;
        m_whyHeld = whyHeld;
        m_mktCapPrice = mktCapPrice;
    }
}
