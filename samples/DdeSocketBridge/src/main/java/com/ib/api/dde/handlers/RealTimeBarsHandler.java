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
import com.ib.api.dde.dde2socket.requests.realtimebars.RealTimeBarsRequest;
import com.ib.api.dde.handlers.base.HistoricalDataBaseHandler;
import com.ib.api.dde.socket2dde.datamap.HistoricalDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;

/** Class handle real time bars related requests, data and messages */
public class RealTimeBarsHandler extends HistoricalDataBaseHandler {
    // parser
    private RealTimeBarsRequestParser m_requestParser = new RealTimeBarsRequestParser();

    public RealTimeBarsHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends real time bars request to TWS */
    public byte[] handleRealTimeBarsRequest(String requestStr, byte[] data) {
        RealTimeBarsRequest request = m_requestParser.parseRealTimeBarsRequest(requestStr, data);
        System.out.println("Sending real time bars request: id=" + request.requestId() + " contract=" + Utils.shortContractString(request.contract()));
        clientSocket().reqRealTimeBars(request.requestId(), request.contract(), request.barSize(), request.whatToShow(), request.useRth(), null);
        return handleHistoricalDataBaseRequest(request);
    }

    /** Method handles real time bars cancel request */
    public byte[] handleRealTimeBarsCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_REAL_TIME_BARS);
        System.out.println("Cancelling real time bars: id=" + request.requestId());
        return handleHistoricalDataBaseCancel(request);
    }

    /** Method handles real time bars tick request (error, status) */
    public String handleRealTimeBarsTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.REAL_TIME_BARS_TICK);
        System.out.println("Handling real time bars tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        return handleHistoricalDataTickBaseRequest(tickRequest);
    }
    
    /** Method handles real time bars array request */
    public byte[] handleRealTimeBarsArrayRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_REAL_TIME_BARS);
        System.out.println("Handling real time bars array request: id=" + request.requestId());
        return handleHistoricalDataArrayBaseRequest(request);
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates real time bars status field for requestId */
    @Override
    public void updateHistoricalDataRequestStatus(int requestId, HistoricalDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.REAL_TIME_BARS_TICK.topic());
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class RealTimeBarsRequestParser extends RequestParser {

        /** Method parses DDE request string to RealTimeBarsRequest */
        public RealTimeBarsRequest parseRealTimeBarsRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, true, false, false, false, false);
            int barSize = 0;
            String whatToShow = "";
            boolean useRth = false;
            
            if (Utils.isNotNull(table.get(12))) {
                barSize = getIntFromString(table.get(12));
            }
            if (Utils.isNotNull(table.get(13))) {
                whatToShow = table.get(13);
            }
            if (Utils.isNotNull(table.get(14))) {
                useRth = getBooleanFromString(table.get(14));
            }
            return new RealTimeBarsRequest(requestId, contract, barSize, whatToShow, useRth, requestStr);
            
        }
    }
}
