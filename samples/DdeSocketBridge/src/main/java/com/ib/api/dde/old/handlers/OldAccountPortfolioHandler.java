/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.handlers;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.AccountUpdatesHandler;
import com.ib.api.dde.socket2dde.data.AccountUpdateData;
import com.ib.api.dde.socket2dde.data.PositionData;
import com.ib.api.dde.utils.AccountUpdatesUtils.AccountUpdateKey;
import com.ib.api.dde.utils.PositionsUtils.PositionKey;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;

/** Class handles account updates multi related requests and data */
public class OldAccountPortfolioHandler extends AccountUpdatesHandler {
    // position data
    private Map<AccountUpdateKey, AccountUpdateData> m_accountData = Collections.synchronizedSortedMap(new TreeMap<AccountUpdateKey, AccountUpdateData>());  // map key->AccountData
    private Map<PositionKey, PositionData> m_portfolioData = Collections.synchronizedMap(new TreeMap<PositionKey, PositionData>()); // map key->PositionData
    
    private DdeRequestStatus m_accountSubscriptionStatus = DdeRequestStatus.UNKNOWN;
    private DdeRequestStatus m_portfolioSubscriptionStatus = DdeRequestStatus.UNKNOWN;
    
    private String m_accountRequestStr = "";
    private String m_portfolioRequestStr = "";
    
    private boolean m_hasActiveRequest = false;
    
    
    // parser
    private AccountPortfolioRequestParser m_requestParser = new AccountPortfolioRequestParser();

    public OldAccountPortfolioHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles account data request */
    public String handleAccountDataRequest(String requestStr) {
        m_accountRequestStr = requestStr;
        String account = m_requestParser.parseAccountPortfolioRequest(requestStr);
        System.out.println("Handling account/portfolio updates request: account=" + account);
        
        if (m_accountSubscriptionStatus == DdeRequestStatus.UNKNOWN) {
            if (m_hasActiveRequest) {
                m_accountSubscriptionStatus = DdeRequestStatus.RECEIVED;
            } else {
                // send reqAccountUpdates request
                clientSocket().reqAccountUpdates(true, account);
                m_hasActiveRequest = true;
                m_accountSubscriptionStatus = DdeRequestStatus.REQUESTED;
            }
        }

        return m_accountSubscriptionStatus.toString();
    }

    /** Method handles portfolio request */
    public String handlePortfolioRequest(String requestStr) {
        m_portfolioRequestStr = requestStr;
        String account = m_requestParser.parseAccountPortfolioRequest(requestStr);
        System.out.println("Handling portfolio updates request: account=" + account);
        
        if (m_portfolioSubscriptionStatus == DdeRequestStatus.UNKNOWN) {
            if (m_hasActiveRequest) {
                m_portfolioSubscriptionStatus = DdeRequestStatus.RECEIVED;
            } else {
                // send reqAccountUpdates request
                clientSocket().reqAccountUpdates(true, account);
                m_hasActiveRequest = true;
                m_portfolioSubscriptionStatus = DdeRequestStatus.REQUESTED;
            }
        }

        return m_portfolioSubscriptionStatus.toString();
    }
    
    /** Method handles account data array request */
    public byte[] handleAccountDataArrayRequest(String requestStr) {
        System.out.println("Handling account updates array request: " + requestStr);
        byte[] array = Utils.dataListToByteArray(syncCopyAccountUpdateDataValues(), false, false);
        m_accountSubscriptionStatus = DdeRequestStatus.SUBSCRIBED;
        notifyDde(DdeRequestType.ACCTS.topic(), m_accountRequestStr);
        return array;
    }

    /** Method handles portfolio array request */
    public byte[] handlePortfolioArrayRequest(String requestStr) {
        System.out.println("Handling portfolio array request: " + requestStr);
        byte[] array = Utils.dataListToByteArray(syncCopyPortfolioDataValues(), false, DdeRequestType.REQ_ACCOUNT_PORTFOLIO);
        m_portfolioSubscriptionStatus = DdeRequestStatus.SUBSCRIBED;
        notifyDde(DdeRequestType.PORTS.topic(), m_portfolioRequestStr);
        return array;
    }
    
    /** Method stops account data advise loop */
    public void handleAccountDataStopAdvise(String requestStr) {
        System.out.println("Handling account/portfolio stop advise: " + requestStr);
        m_accountSubscriptionStatus = DdeRequestStatus.UNKNOWN;
        if (m_portfolioSubscriptionStatus != DdeRequestStatus.SUBSCRIBED) {
            clientSocket().reqAccountUpdates(false, "");
            m_hasActiveRequest = false;
        }
    }    

    /** Method stops portfolio advise loop */
    public void handlePortfolioStopAdvise(String requestStr) {
        System.out.println("Handling account/portfolio stop advise: " + requestStr);
        m_portfolioSubscriptionStatus = DdeRequestStatus.UNKNOWN;
        if (m_accountSubscriptionStatus != DdeRequestStatus.SUBSCRIBED) {
            clientSocket().reqAccountUpdates(false, "");
            m_hasActiveRequest = false;
        }
    }    
    
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates account updates data */
    @Override
    public void updateAccountData(AccountUpdateData accountUpdateData, DdeRequestType ddeRequestType) {
        AccountUpdateKey key = new AccountUpdateKey(accountUpdateData.account(), "", accountUpdateData.key(), accountUpdateData.currency());
        if (m_accountSubscriptionStatus == DdeRequestStatus.SUBSCRIBED) {
            m_accountSubscriptionStatus = DdeRequestStatus.RECEIVED;
            notifyDde(ddeRequestType.topic(), m_accountRequestStr);
        }
        m_accountData.put(key, accountUpdateData);
    }

    /** Method updates account update end marker */
    @Override
    public void updateAccountDataEnd(int requestId, DdeRequestType ddeRequestType) {
        m_accountSubscriptionStatus = DdeRequestStatus.RECEIVED;
        notifyDde(ddeRequestType.topic(), m_accountRequestStr);
    }
    
    /** Method updates portfolio data */
    public void updatePortfolio(PositionData positionData) {
        PositionKey key = new PositionKey(positionData.contract().conid(), positionData.account(), positionData.modelCode());
        if (m_portfolioSubscriptionStatus == DdeRequestStatus.SUBSCRIBED) {
            m_portfolioSubscriptionStatus = DdeRequestStatus.RECEIVED;
            notifyDde(DdeRequestType.PORTS.topic(), m_portfolioRequestStr);
        }
        m_portfolioData.put(key, positionData);
    }

    /** Method updates portfolio data  end marker */
    public void updatePortfolioDataEnd(int requestId, DdeRequestType ddeRequestType) {
        m_portfolioSubscriptionStatus = DdeRequestStatus.RECEIVED;
        notifyDde(ddeRequestType.topic(), m_portfolioRequestStr);
    }

    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    protected List<AccountUpdateData> syncCopyAccountUpdateDataValues() {
        synchronized(m_accountData) {
            return (m_accountData != null ? new ArrayList<AccountUpdateData>(m_accountData.values()) : new ArrayList<AccountUpdateData>());
        }
    }

    protected List<PositionData> syncCopyPortfolioDataValues() {
        synchronized(m_portfolioData) {
            return (m_portfolioData != null ? new ArrayList<PositionData>(m_portfolioData.values()) : new ArrayList<PositionData>());
        }
    }
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class AccountPortfolioRequestParser extends RequestParser {

        /** Method parses DDE request string to AccoutPortfolioiRequest */
        private String parseAccountPortfolioRequest(String requestStr) {
            String account = "";
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 2) {
                account = requestTokens[2];
            }
            return account;
       }
    }
}
