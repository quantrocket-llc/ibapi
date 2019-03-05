/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

import com.ib.client.TickAttribBidAsk;
import com.ib.client.TickAttribLast;

/** Class represents tick-by-tick data received from TWS */
public class TickByTickData {
    
    // tick-by-tick types
    public final static String ALL_LAST = "AllLast";
    public final static String BID_ASK = "BidAsk";
    public final static String MID_POINT = "MidPoint";
    
    private String m_tickByTickType;
    private long m_time; // AllLast, BidAsk, MidPoint
    private double m_price = Double.MAX_VALUE; // AllLast, MidPoint
    private long m_size = Long.MAX_VALUE; // AllLast
    private TickAttribLast m_tickAttribLast = new TickAttribLast(); // AllLast
    private String m_exchange; // AllLast
    private String m_specialConditions; // AllLast
    private double m_bidPrice = Double.MAX_VALUE; // BidAsk
    private double m_askPrice = Double.MAX_VALUE; // BidAsk
    private long m_bidSize = Long.MAX_VALUE; // BidAsk
    private long m_askSize = Long.MAX_VALUE; // BidAsk
    private TickAttribBidAsk m_tickAttribBidAsk = new TickAttribBidAsk(); // BidAsk
    
    // gets
    public String tickByTickType()             { return m_tickByTickType; }
    public long time()                         { return m_time; }
    public double price()                      { return m_price; }
    public long size()                         { return m_size; }
    public TickAttribLast tickAttribLast()     { return m_tickAttribLast; }
    public String exchange()                   { return m_exchange; }
    public String specialConditions()          { return m_specialConditions; }
    public double bidPrice()                   { return m_bidPrice; }
    public double askPrice()                   { return m_askPrice; }
    public long bidSize()                      { return m_bidSize; }
    public long askSize()                      { return m_askSize; }
    public TickAttribBidAsk tickAttribBidAsk() { return m_tickAttribBidAsk; }
    public boolean isAllLast()                 { return m_tickByTickType.equals(ALL_LAST); }
    public boolean isMidPoint()                { return m_tickByTickType.equals(MID_POINT); }
    public boolean isBidAsk()                  { return m_tickByTickType.equals(BID_ASK); }

    public TickByTickData(long time, double price, long size, TickAttribLast tickAttribLast,
            String exchange, String specialConditions) {
        m_tickByTickType = ALL_LAST;
        m_time = time;
        m_price = price;
        m_size = size;
        m_tickAttribLast = tickAttribLast;
        m_exchange = exchange;
        m_specialConditions = specialConditions;
    }
    
    public TickByTickData(long time, double bidPrice, double askPrice, long bidSize, long askSize,
            TickAttribBidAsk tickAttribBidAsk) {
        m_tickByTickType = BID_ASK;
        m_time = time;
        m_bidPrice = bidPrice;
        m_askPrice = askPrice;
        m_bidSize = bidSize;
        m_askSize = askSize;
        m_tickAttribBidAsk = tickAttribBidAsk;
    }
    
    public TickByTickData(long time, double midPoint) {
        m_tickByTickType = MID_POINT;
        m_time = time;
        m_price = midPoint;
    }
    
    public void setBidAskData(double bidPrice, double askPrice, long bidSize, long askSize,
            TickAttribBidAsk tickAttribBidAsk) {
        m_bidPrice = bidPrice;
        m_askPrice = askPrice;
        m_bidSize = bidSize;
        m_askSize = askSize;
        m_tickAttribBidAsk = tickAttribBidAsk;
    }

    public void setLastData(double price, long size, TickAttribLast tickAttribLast,
            String exchange, String specialConditions) {
        m_price = price;
        m_size = size;
        m_tickAttribLast = tickAttribLast;
        m_exchange = exchange;
        m_specialConditions = specialConditions;
    }
}
