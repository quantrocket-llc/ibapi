/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

/** Class represents market depth data received from TWS */
public class MarketDepthData {
    private final int m_position;
    private final String m_marketMaker;
    private final int m_operation;
    private final int m_side;
    private final double m_price;
    private final int m_size;
    private final boolean m_isSmartDepth;
    
    // gets
    public int position()         { return m_position; }
    public String marketMaker()   { return m_marketMaker; }
    public int operation()        { return m_operation; }
    public int side()             { return m_side; }
    public double price()         { return m_price; }
    public int size()             { return m_size; }
    public boolean isSmartDepth() { return m_isSmartDepth; }
    
    public MarketDepthData(int position, String marketMaker, int operation, int side, double price, int size, boolean isSmartDepth) {
        m_position = position;
        m_marketMaker = marketMaker;
        m_operation = operation;
        m_side = side;
        m_price = price;
        m_size = size;
        m_isSmartDepth = isSmartDepth;
    }
}
