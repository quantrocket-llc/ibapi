/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.historicaldata.HistoricalTicksRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseListDataHandler;
import com.ib.api.dde.socket2dde.data.TickByTickData;
import com.ib.api.dde.socket2dde.datamap.BaseDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;

/** Class handles historical ticks related requests, data and messages */
public class HistoricalTicksHandler extends BaseListDataHandler<TickByTickData> {
    // parser
    private HistoricalTicksRequestParser m_requestParser = new HistoricalTicksRequestParser();

    public HistoricalTicksHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends historical ticks request to TWS */
    public byte[] handleHistoricalTicksRequest(String requestStr, byte[] data) {
        HistoricalTicksRequest request = m_requestParser.parseHistoricalTicksRequest(requestStr, data);
        System.out.println("Sending historical ticks request: id=" + request.requestId() + " contract=" + Utils.shortContractString(request.contract()));
        clientSocket().reqHistoricalTicks(request.requestId(), request.contract(), request.startDateTime(), request.endDateTime(), 
                request.numberOfTicks(), request.whatToShow(), request.useRth(), request.ignoreSize(), null);
        return handleBaseRequest(request);
    }

    /** Method handles historical ticks cancel request */
    public byte[] handleHistoricalTicksCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_HISTORICAL_TICKS);
        System.out.println("Cancelling historical ticks: id=" + request.requestId());
        return handleBaseCancel(request);
    }

    /** Method handles historical ticks tick request */
    public String handleHistoricalTicksTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.HISTORICAL_TICKS_TICK);
        System.out.println("Handling historical ticks tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        return handleBaseTickRequest(tickRequest);
    }
    
    /** Method handles historical ticks array request */
    public byte[] handleHistoricalTicksArrayRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_HISTORICAL_TICKS);
        System.out.println("Handling historical ticks array request: id=" + request.requestId());
        return handleBaseArrayRequest(request);
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates historical ticks request status field for requestId */
    @Override
    public void updateRequestStatus(int requestId, BaseDataMap ticksMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, ticksMap, status, DdeRequestType.HISTORICAL_TICKS_TICK.topic());
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class HistoricalTicksRequestParser extends RequestParser {

        /** Method parses DDE request string to HistoricalTicksRequest */
        public HistoricalTicksRequest parseHistoricalTicksRequest(String requestStr, byte[] data) {
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
            String startDateTime = "";
            String endDateTime = "";
            int numberOfTicks = 0;
            String whatToShow = "";
            int useRth = 0;
            boolean ignoreSize = false;
            
            if (Utils.isNotNull(table.get(13))) {
                startDateTime = table.get(13);
            }
            if (Utils.isNotNull(table.get(14))) {
                endDateTime = table.get(14);
            }
            if (Utils.isNotNull(table.get(15))) {
                numberOfTicks = getIntFromString(table.get(15));
            }
            if (Utils.isNotNull(table.get(16))) {
                whatToShow = table.get(16);
            }
            if (Utils.isNotNull(table.get(17))) {
                useRth = getIntFromString(table.get(17));
            }
            if (Utils.isNotNull(table.get(18))) {
                ignoreSize = getBooleanFromString(table.get(18));
            }
            return new HistoricalTicksRequest(requestId, contract, startDateTime, endDateTime, numberOfTicks, whatToShow, useRth, 
                    ignoreSize, requestStr);
        }
    }
}
