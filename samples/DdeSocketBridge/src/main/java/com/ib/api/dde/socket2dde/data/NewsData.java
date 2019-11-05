/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

/** Class represents news data received from TWS */
public class NewsData {
    private long m_time;
    private final String m_providerCode; 
    private final String m_articleId; 
    private final String m_headline; 
    private final String m_extraData; 
    
    // gets
    public long time()            { return m_time; }
    public String providerCode()  { return m_providerCode; }
    public String articleId()     { return m_articleId; }
    public String headline()      { return m_headline; }
    public String extraData()     { return m_extraData; }

    public NewsData(long time, String providerCode, String articleId, String headline, String extraData) {
        m_time = time;
        m_providerCode = providerCode;
        m_articleId = articleId;
        m_headline = headline;
        m_extraData = extraData;
    }
}
