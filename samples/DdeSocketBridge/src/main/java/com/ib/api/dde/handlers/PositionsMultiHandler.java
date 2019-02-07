/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.dde2socket.requests.positions.PositionsMultiRequest;
import com.ib.api.dde.handlers.base.PositionUpdatesHandler;
import com.ib.client.EClientSocket;

/** Class handles positions multi related requests and data */
public class PositionsMultiHandler extends PositionUpdatesHandler {
    // parser
    private PositionsMultiRequestParser m_requestParser = new PositionsMultiRequestParser();

    public PositionsMultiHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles positions multi request */
    public String handlePositionsMultiRequest(String requestStr) {
        PositionsMultiRequest request = m_requestParser.parsePositionsMultiRequest(requestStr);
        System.out.println("Handling positions multi request: id=" + request.requestId() + " account=" + request.account() + " modelCode=" + request.modelCode());
        return handlePositionsRequest(request);
    }

    /** Method handles positions multi array request */
    public byte[] handlePositionsMultiArrayRequest(String requestStr) {
        PositionsMultiRequest request = m_requestParser.parsePositionsMultiRequest(requestStr);
        System.out.println("Handling positions multi array request: id=" + request.requestId() + " account=" + request.account() + 
                " modelCode=" + request.modelCode() + " type=" + request.ddeRequestType().topic());
        return handlePositionsArrayRequest(request);
    }

    /** Method handles cancel positions multi request */
    public byte[] handlePositionsMultiCancel(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_POSITIONS_MULTI);
        System.out.println("Handling positions multi cancel: id=" + request.requestId());
        return handlePositionsCancel(request);
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests 
     * and TWS responses to DDE notifications */
    private class PositionsMultiRequestParser extends RequestParser {

        /** Method parses DDE request string to PositionsMultiRequest */
        private PositionsMultiRequest parsePositionsMultiRequest(String requestStr) {
            int requestId = -1;
            String account = "";
            String model = "";
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
                if (requestParams.length > 1) {
                    model = requestParams[1];
                }

            }
            return new PositionsMultiRequest(requestId, account, model, requestStr);
       }
    }
}
