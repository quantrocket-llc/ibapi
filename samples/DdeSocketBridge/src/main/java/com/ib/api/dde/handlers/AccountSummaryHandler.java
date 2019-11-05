/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.accountupdates.AccountSummaryRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.AccountUpdatesHandler;
import com.ib.api.dde.socket2dde.datamap.AccountUpdateDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;

/** Class handles account summary related requests and data */
public class AccountSummaryHandler extends AccountUpdatesHandler {
    // parser
    private AccountSummaryRequestParser m_requestParser = new AccountSummaryRequestParser();

    public AccountSummaryHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles account summary request */
    public String handleAccountSummaryRequest(String requestStr) {
        AccountSummaryRequest request = m_requestParser.parseAccountSummaryRequest(requestStr);
        System.out.println("Handling account summary request: id=" + request.requestId() + " group=" + request.group());
        return handleAccountUpdatesRequest(request);
    }

    public byte[] handleAccountSummaryRequestWithData(String requestStr, byte[] data) {
        AccountSummaryRequest request = m_requestParser.parseAccountSummaryRequestWithData(requestStr + "?", data);
        AccountUpdateDataMap accountUpdateDataMap = m_accountUpdateDataMap.get(request.requestId());
        if (accountUpdateDataMap == null) {
            accountUpdateDataMap = new AccountUpdateDataMap(request);
            m_accountUpdateDataMap.put(request.requestId(), accountUpdateDataMap);
        }
        // send reqAccountSummary request
        clientSocket().reqAccountSummary(request.requestId(), request.group(), request.tags());
        return null;
    }
        
    /** Method handles account summary array request */
    public byte[] handleAccountSummaryArrayRequest(String requestStr) {
        AccountSummaryRequest request = m_requestParser.parseAccountSummaryRequest(requestStr);
        System.out.println("Handling account summary array request: id=" + request.requestId() + " group=" + request.group());
        return handleAccountUpdatesArrayRequest(request);
    }

    /** Method handles cancel account summary request */
    public byte[] handleAccountSummaryCancel(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_ACCOUNT_SUMMARY);
        System.out.println("Handling account summary cancel: id=" + request.requestId());
        return handleAccountUpdatesCancel(request);
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests 
     * and TWS responses to DDE notifications */
    private class AccountSummaryRequestParser extends RequestParser {

        /** Method parses DDE request string to AccoutSummaryRequest with data */
        private AccountSummaryRequest parseAccountSummaryRequestWithData(String requestStr, byte[] data) {
            int requestId = -1;
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            String group = "";
            String tags = "";
            ArrayList<String> table = Utils.convertArrayToTable(data);
            if (table.size() > 0) {
                group = table.get(0);
            }
            if (table.size() > 1) {
                StringBuilder sb = new StringBuilder();
                for (int i = 1; i < table.size(); i++) {
                    sb.append(table.get(i));
                    if (i < table.size() - 1) {
                        sb.append(",");
                    }
                }
                tags = sb.toString();
            }
            return new AccountSummaryRequest(requestId, group, tags, requestStr);
        }
        
        /** Method parses DDE request string to AccoutSummaryRequest */
        private AccountSummaryRequest parseAccountSummaryRequest(String requestStr) {
            int requestId = -1;
            String group = "";
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            return new AccountSummaryRequest(requestId, group, "", requestStr);
       }
    }
}
