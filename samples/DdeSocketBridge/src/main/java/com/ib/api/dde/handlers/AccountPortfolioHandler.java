/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.accountupdates.AccountPortfolioRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.AccountUpdatesHandler;
import com.ib.api.dde.socket2dde.data.PositionData;
import com.ib.api.dde.utils.Utils;
import com.ib.api.dde.utils.PositionsUtils.PositionKey;
import com.ib.client.EClientSocket;

/** Class handles account.portfolio updates related requests and data */
public class AccountPortfolioHandler extends AccountUpdatesHandler {
    // position data
    private Map<PositionKey, PositionData> m_portfolioData = Collections.synchronizedMap(new HashMap<PositionKey, PositionData>()); // map key->PositionData
    
    // parser
    private AccountPortfolioRequestParser m_requestParser = new AccountPortfolioRequestParser();

    public AccountPortfolioHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles account/portfolio request */
    public String handleAccountPortfolioRequest(String requestStr) {
        AccountPortfolioRequest request = m_requestParser.parseAccountPortfolioRequest(requestStr);
        System.out.println("Handling account/portfolio updates request: account=" + request.account());
        return handleAccountUpdatesRequest(request);
    }

    /** Method handles account updates array request */
    public byte[] handleAccountPortfolioArrayRequest(String requestStr) {
        AccountPortfolioRequest request = m_requestParser.parseAccountPortfolioRequest(requestStr);
        System.out.println("Handling account updates array request: id=" + request.requestId() + " account=" + request.account());
        return handleAccountUpdatesArrayRequest(request);
    }

    /** Method handles portfolio array request */
    public byte[] handlePortfolioArrayRequest(String requestStr) {
        AccountPortfolioRequest request = m_requestParser.parseAccountPortfolioRequest(requestStr);
        System.out.println("Handling portfolio array request: id=" + request.requestId() + " account=" + request.account());
        byte[] array = Utils.dataListToByteArray(syncCopyPortfolioDataValues(), true, true, request.ddeRequestType());
        m_portfolioData.clear();
        return array;
    }
    
    /** Method handles cancel account/portfolio request */
    public byte[] handleAccountPortfolioCancel(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_ACCOUNT_PORTFOLIO);
        System.out.println("Handling account/portfolio updates cancel");
        return handleAccountUpdatesCancel(request);
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates portfolio data */
    public void updatePortfolio(PositionData positionData) {
        PositionKey key = new PositionKey(positionData.contract().conid(), positionData.account(), positionData.modelCode());
        m_portfolioData.put(key, positionData);
    }
    
    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    protected List<PositionData> syncCopyPortfolioDataValues() {
        synchronized(m_portfolioData) {
            return (m_portfolioData != null ? new ArrayList<PositionData>(m_portfolioData.values()) : new ArrayList<PositionData>());
        }
    }
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests 
     * and TWS responses to DDE notifications */
    private class AccountPortfolioRequestParser extends RequestParser {

        /** Method parses DDE request string to AccoutPortfolioiRequest */
        private AccountPortfolioRequest parseAccountPortfolioRequest(String requestStr) {
            int requestId = -1;
            String account = "";
            String requestParamsStr = "";
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            if (requestTokens.length > 1) {
                requestParamsStr = requestTokens[1];
                String[] requestParams = requestParamsStr.split(PARAM_SEPARATOR);
                if (requestParams.length > 0) {
                    account = requestParams[0];
                }
            }
            return new AccountPortfolioRequest(requestId, account, requestStr);
       }
    }
}
