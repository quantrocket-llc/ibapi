/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.news;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;

/** Class represents DDE news article request (reqNewsArticle) */
public class NewsArticleRequest extends DdeRequest {

    private final String m_providerCode;
    private final String m_articleId;
    private final String m_directoryToSavePDF;
    
    // gets
    public String providerCode() { return m_providerCode; }
    public String articleId() { return m_articleId; }
    public String directoryToSavePDF() { return m_directoryToSavePDF; }

    public NewsArticleRequest(int requestId, String providerCode, String articleId, String directoryToSavePDF, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_NEWS_ARTICLE, ddeRequestString);
        m_providerCode = providerCode;
        m_articleId = articleId;
        m_directoryToSavePDF = directoryToSavePDF;
    }
}
