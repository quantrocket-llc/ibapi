/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.dde2socket.requests.positions.PositionsRequest;
import com.ib.api.dde.handlers.base.PositionUpdatesHandler;
import com.ib.client.EClientSocket;

/** Class handles positions related requests, data and messages */
public class PositionsHandler extends PositionUpdatesHandler {
    // parser
    private PositionsRequestParser m_requestParser = new PositionsRequestParser();

    public PositionsHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles positions request */
    public String handlePositionsRequest(String requestStr) {
        PositionsRequest request = m_requestParser.parsePositionsRequest(requestStr);
        System.out.println("Handling positions request");
        return handlePositionsRequest(request);
    }

    /** Method handles positions array request */
    public byte[] handlePositionsArrayRequest(String requestStr) {
        PositionsRequest request = m_requestParser.parsePositionsRequest(requestStr);
        System.out.println("Handling positions array request");
        return handlePositionsArrayRequest(request);
    }

    /** Method handles cancel positions */
    public byte[] handlePositionsCancel(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_POSITIONS);
        System.out.println("Handling positions cancel: id=" + request.requestId());
        return handlePositionsCancel(request);
    }

    /* *****************************************************************************************************
     *                                          Parsing
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests 
     * and TWS responses to DDE notifications */
    private class PositionsRequestParser extends RequestParser {

        /** Method parses DDE request string to PositionsRequest */
        private PositionsRequest parsePositionsRequest(String requestStr) {
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            int requestId = parseRequestId(requestTokens[0]);
            return new PositionsRequest(requestId, requestStr);
       }
    }
}
