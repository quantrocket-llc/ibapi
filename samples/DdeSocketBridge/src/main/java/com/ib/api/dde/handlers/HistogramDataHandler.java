/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.historicaldata.HistogramDataRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseListDataHandler;
import com.ib.api.dde.socket2dde.datamap.BaseDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;
import com.ib.client.HistogramEntry;

/** Class handles histogram data related requests, data and messages */
public class HistogramDataHandler extends BaseListDataHandler<HistogramEntry> {
    // parser
    private HistogramDataRequestParser m_requestParser = new HistogramDataRequestParser();

    public HistogramDataHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends histogram data request to TWS */
    public byte[] handleHistogramDataRequest(String requestStr, byte[] data) {
        HistogramDataRequest request = m_requestParser.parseHistogramDataRequest(requestStr, data);
        System.out.println("Sending histogram data request: id=" + request.requestId() + " contract=" + Utils.shortContractString(request.contract()));
        clientSocket().reqHistogramData(request.requestId(), request.contract(), request.useRth(), request.timePeriod()); 
        return handleBaseRequest(request);
    }

    /** Method handles histogram data cancel request */
    public byte[] handleHistogramDataCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_HISTOGRAM_DATA);
        System.out.println("Cancelling histogram data: id=" + request.requestId());
        if(m_requests.containsKey(request.requestId())) {
            clientSocket().cancelHistogramData(request.requestId()); 
        }
        return handleBaseCancel(request);
    }

    /** Method handles histogram data tick request */
    public String handleHistogramDataTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.HISTOGRAM_DATA_TICK);
        System.out.println("Handling histogram data tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        return handleBaseTickRequest(tickRequest);
    }
    
    /** Method handles histogram data array request */
    public byte[] handleHistogramDataArrayRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_HISTOGRAM_DATA);
        System.out.println("Handling histogram data array request: id=" + request.requestId());
        return handleBaseArrayRequest(request);
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates histogram data request status field for requestId */
    @Override
    public void updateRequestStatus(int requestId, BaseDataMap ticksMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, ticksMap, status, DdeRequestType.HISTOGRAM_DATA_TICK.topic());
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class HistogramDataRequestParser extends RequestParser {

        /** Method parses DDE request string to HistogramDataRequest */
        public HistogramDataRequest parseHistogramDataRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, true, false, false, false, true);
            String timePeriod = "";
            boolean useRth = false;
            
            if (Utils.isNotNull(table.get(13))) {
                timePeriod = table.get(13);
            }
            if (Utils.isNotNull(table.get(14))) {
                useRth = getBooleanFromString(table.get(14));
            }
            return new HistogramDataRequest(requestId, contract, timePeriod, useRth, requestStr);
        }
    }
}
