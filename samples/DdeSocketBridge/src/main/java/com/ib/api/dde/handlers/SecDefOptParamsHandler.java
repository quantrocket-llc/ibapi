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
import com.ib.api.dde.dde2socket.requests.secdefoptparams.SecDefOptParamsRequest;
import com.ib.api.dde.handlers.base.BaseListDataHandler;
import com.ib.api.dde.socket2dde.data.SecDefOptParamsData;
import com.ib.api.dde.socket2dde.datamap.BaseDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;

/** Class handles security definition option parameters related requests, data and messages */
public class SecDefOptParamsHandler extends BaseListDataHandler<SecDefOptParamsData> {
    // parser
    private SecDefOptParamsRequestParser m_requestParser = new SecDefOptParamsRequestParser();

    public SecDefOptParamsHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends security definition option parameters request to TWS */
    public byte[] handleSecDefOptParamsRequest(String requestStr, byte[] data) {
        SecDefOptParamsRequest request = m_requestParser.parseSecDefOptParamsRequest(requestStr, data);
        System.out.println("Sending sec def opt params request: id=" + request.requestId() + " underlyingSymbol=" + request.underlyingSymbol() + 
                " futFopExchange=" + request.futFopExchange() + " underlyingSecType=" + request.underlyingSecType() + 
                " underlyingConId=" + request.underlyingConId());
        clientSocket().reqSecDefOptParams(request.requestId(), request.underlyingSymbol(), request.futFopExchange(), 
                request.underlyingSecType(), request.underlyingConId());
        return handleBaseRequest(request);
    }

    /** Method handles security definition option parameters cancel request */
    public byte[] handleSecDefOptParamsCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_SEC_DEF_OPT_PARAMS);
        System.out.println("Cancelling sec def opt params: id=" + request.requestId());
        return handleBaseCancel(request);
    }

    /** Method handles security definition option parameters tick request */
    public String handleSecDefOptParamsTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.SEC_DEF_OPT_PARAMS_TICK);
        System.out.println("Handling sec def opt params tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        return handleBaseTickRequest(tickRequest);
    }
    
    /** Method handles security definition option parameters array request */
    public byte[] handleSecDefOptParamsArrayRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_SEC_DEF_OPT_PARAMS);
        System.out.println("Handling sec def opt params array request: id=" + request.requestId());
        return handleBaseArrayRequest(request);
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates security definition option parameters request status field for requestId */
    @Override
    public void updateRequestStatus(int requestId, BaseDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.SEC_DEF_OPT_PARAMS_TICK.topic());
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class SecDefOptParamsRequestParser extends RequestParser {

        /** Method parses DDE request string to SecDefOptParamsRequest */
        public SecDefOptParamsRequest parseSecDefOptParamsRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            String underlyingSymbol = "";
            String futFopExchange = "";
            String underlyingSecType = "";
            int underlyingConId = 0;
            
            if (Utils.isNotNull(table.get(0))) {
                underlyingSymbol = table.get(0);
            }
            if (Utils.isNotNull(table.get(1))) {
                futFopExchange = table.get(1);
            }
            if (Utils.isNotNull(table.get(2))) {
                underlyingSecType = table.get(2);
            }
            if (Utils.isNotNull(table.get(3))) {
                underlyingConId = getIntFromString(table.get(3));
            }
            
            return new SecDefOptParamsRequest(requestId, underlyingSymbol, futFopExchange, underlyingSecType, underlyingConId, requestStr);
        }
    }
}
