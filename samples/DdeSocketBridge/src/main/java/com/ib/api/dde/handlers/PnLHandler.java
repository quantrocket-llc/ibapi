/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.dde2socket.requests.pnl.PnLRequest;
import com.ib.api.dde.handlers.base.MarketDataBaseHandler;
import com.ib.api.dde.socket2dde.datamap.MarketDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;

/** Class handles PnL related requests, data and messages */
public class PnLHandler extends MarketDataBaseHandler {
    // parser
    private PnLRequestParser m_requestParser = new PnLRequestParser();

    public PnLHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends PnL request to TWS */
    public byte[] handlePnLRequest(String requestStr, byte[] data) {
        PnLRequest request = m_requestParser.parsePnLRequest(requestStr, data);
        if (request.conId() == 0) {
            System.out.println("Sending PnL request: id=" + request.requestId() + " account=" + request.account() + " modelCode=" + request.modelCode());
            clientSocket().reqPnL(request.requestId(), request.account(), request.modelCode());
        } else {
            System.out.println("Sending PnL single request: id=" + request.requestId() + " account=" + request.account() + " modelCode=" + request.modelCode() + 
                    " conId=" + request.conId());
            clientSocket().reqPnLSingle(request.requestId(), request.account(), request.modelCode(), request.conId());
        }
        return handleMarketDataBaseRequest(request);
    }
    
    /** Method sends PnL cancel to TWS */
    public byte[] handlePnLCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_PNL);
        
        MarketDataMap data = m_marketDataRequests.get(request.requestId());
        if(data != null) {
            // get initial request
            PnLRequest pnlRequest = (PnLRequest)data.ddeRequest();
            if (pnlRequest.conId() == 0) {
                System.out.println("Sending PnL cancel: id=" + request.requestId());
                clientSocket().cancelPnL(request.requestId());
            } else {
                System.out.println("Sending PnL single cancel: id=" + request.requestId());
                clientSocket().cancelPnLSingle(request.requestId());
            }
        }
        return handleMktDataBaseCancel(request);
    }

    /** Method handles PnL tick request */
    public String handlePnLTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.PNL_TICK);
        System.out.println("Handling PnL tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        return handleTickBaseRequest(tickRequest);
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates PnL request status field for requestId */
    @Override 
    protected void updateMarketDataStatus(int requestId, MarketDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.PNL_TICK.topic());
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class PnLRequestParser extends RequestParser {

        /** Method parses DDE request string to PnLRequest */
        public PnLRequest parsePnLRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            String account = "";
            String modelCode = "";
            int conId = 0;
                    
            ArrayList<String> table = Utils.convertArrayToTable(data);
            if (table.size() < 3) {
                System.out.println("Cannot extract PnL request fields");
                return null;
            }
            if (Utils.isNotNull(table.get(0))) {
                account = table.get(0);
            }
            if (Utils.isNotNull(table.get(1))) {
                modelCode = table.get(1);
            }
            if (Utils.isNotNull(table.get(2))) {
                conId = getIntFromString(table.get(2));
            }
            return new PnLRequest(requestId, account, modelCode, conId, requestStr);
        }
    }
}
