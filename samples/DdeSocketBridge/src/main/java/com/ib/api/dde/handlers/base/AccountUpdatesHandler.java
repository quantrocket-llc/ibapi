/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers.base;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.accountupdates.AccountPortfolioRequest;
import com.ib.api.dde.dde2socket.requests.accountupdates.AccountUpdatesMultiRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.socket2dde.data.AccountUpdateData;
import com.ib.api.dde.socket2dde.datamap.AccountUpdateDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;

/** Base class for account update related requests and data */
public abstract class AccountUpdatesHandler extends BaseHandler {
    // parser
    protected RequestParser m_requestParser = new RequestParser();

    // account updates
    protected Map<Integer, AccountUpdateDataMap> m_accountUpdateDataMap = Collections.synchronizedMap(new HashMap<Integer, AccountUpdateDataMap>());

    public AccountUpdatesHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles account updates request */
    public String handleAccountUpdatesRequest(DdeRequest request) {
        String ret = "";
        AccountUpdateDataMap accountUpdateDataMap = m_accountUpdateDataMap.get(request.requestId());
        if (accountUpdateDataMap == null) {
            accountUpdateDataMap = new AccountUpdateDataMap(request);
            m_accountUpdateDataMap.put(request.requestId(), accountUpdateDataMap);
        }
        if (accountUpdateDataMap.ddeRequestStatus() == DdeRequestStatus.UNKNOWN) {
            switch(request.ddeRequestType()){
                case REQ_ACCOUNT_SUMMARY:
                    // do nothing
                    break;
                case REQ_ACCOUNT_UPDATES_MULTI:
                    // send reqPositionsMulti request
                    AccountUpdatesMultiRequest accountUpdatesMultiRequest = (AccountUpdatesMultiRequest)request;
                    clientSocket().reqAccountUpdatesMulti(accountUpdatesMultiRequest.requestId(), accountUpdatesMultiRequest.account(), 
                            accountUpdatesMultiRequest.modelCode(), accountUpdatesMultiRequest.ledgerAndNLV());
                    break;
                case REQ_ACCOUNT_PORTFOLIO:
                    AccountPortfolioRequest accountPortfolioRequest = (AccountPortfolioRequest)request;
                    // send reqAccountUpdates request
                    clientSocket().reqAccountUpdates(true, accountPortfolioRequest.account());
                    
                default:
                    break;
            }
            accountUpdateDataMap.ddeRequestStatus(DdeRequestStatus.REQUESTED);
        }

        ret = accountUpdateDataMap.ddeRequestStatus().toString();

        if (accountUpdateDataMap.ddeRequestStatus() == DdeRequestStatus.ERROR) {
            accountUpdateDataMap.ddeRequestStatus(DdeRequestStatus.REQUESTED);
        }
        return ret;
    }
    
    /** Method handles account updates array request */
    public byte[] handleAccountUpdatesArrayRequest(DdeRequest request) {
        int requestId = request.requestId();
        
        byte[] array = Utils.dataListToByteArray(syncCopyAccountUpdateDataValues(requestId), 
                request.ddeRequestType() == DdeRequestType.REQ_ACCOUNT_UPDATES_MULTI, true);

        AccountUpdateDataMap accountUpdateDataMap = m_accountUpdateDataMap.get(requestId);
        if (accountUpdateDataMap != null) {
            accountUpdateDataMap.ddeRequestStatus(DdeRequestStatus.SUBSCRIBED);
            notifyDde(request.ddeRequestType().topic(), request.ddeRequestString());
            accountUpdateDataMap.clearAccountUpdateDataMap();
        }
        return array;
    }
    
    /** Method handles cancel account updates request */
    public byte[] handleAccountUpdatesCancel(DdeRequest request) {
        switch(request.ddeRequestType()){
            case CANCEL_ACCOUNT_SUMMARY:
                clientSocket().cancelAccountSummary(request.requestId());
                break;
            case CANCEL_ACCOUNT_UPDATES_MULTI:
                clientSocket().cancelAccountUpdatesMulti(request.requestId());
                break;
            case CANCEL_ACCOUNT_PORTFOLIO:
                clientSocket().reqAccountUpdates(false, "");
                break;
            default:
                break;
        }
        m_accountUpdateDataMap.remove(request.requestId());
        return null;
    }
    
    /** Method handles account updates error request */
    public String handleAccountUpdatesErrorRequest(String requestStr, DdeRequestType ddeRequestType) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, ddeRequestType);
        System.out.println("Handling account updates error request: id=" + request.requestId());
        // error request
        AccountUpdateDataMap accountUpdateDataMap = m_accountUpdateDataMap.get(request.requestId());
        if (accountUpdateDataMap != null) {
            m_accountUpdateDataMap.remove(request.requestId());
            return accountUpdateDataMap.error();
        }
        return "";
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates account updates data */
    public void updateAccountData(AccountUpdateData accountUpdateData, DdeRequestType ddeRequestType) {
        AccountUpdateDataMap accountUpdateDataMap = m_accountUpdateDataMap.get(accountUpdateData.requestId());
        if (accountUpdateDataMap != null) {
            accountUpdateDataMap.addAccountUpdateData(accountUpdateData);
            if (accountUpdateDataMap.ddeRequestStatus() == DdeRequestStatus.SUBSCRIBED) {
                accountUpdateDataMap.ddeRequestStatus(DdeRequestStatus.RECEIVED);
                notifyDde(ddeRequestType.topic(), accountUpdateDataMap.ddeRequest().ddeRequestString());
            }
        }
    }

    /** Method updates account update end marker */
    public void updateAccountDataEnd(int requestId, DdeRequestType ddeRequestType) {
        updateDataEnd(m_accountUpdateDataMap.get(requestId), ddeRequestType.topic());
    }

    /** Method updates errors during account updates request */
    public void updateAccountDataError(int requestId, String errorMsgStr, DdeRequestType ddeRequestType) {
        updateRequestError(errorMsgStr, m_accountUpdateDataMap.get(requestId), ddeRequestType.topic());
    }

    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    protected List<AccountUpdateData> syncCopyAccountUpdateDataValues(int requestId) {
        synchronized(m_accountUpdateDataMap) {
            AccountUpdateDataMap accountUpdateDataMap = m_accountUpdateDataMap.get(requestId);
            return (accountUpdateDataMap != null ? accountUpdateDataMap.syncCopyAccountUpdateDataValues() : new ArrayList<AccountUpdateData>());
        }
    }
}
