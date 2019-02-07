/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.historicaldata.HistoricalDataRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.HistoricalDataBaseHandler;
import com.ib.api.dde.socket2dde.datamap.HistoricalDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Bar;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;

/** Class handles historical data related requests, data and messages */
public class HistoricalDataHandler extends HistoricalDataBaseHandler {
    // parser
    private HistoricalDataRequestParser m_requestParser = new HistoricalDataRequestParser();

    public HistoricalDataHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends historical data request to TWS */
    public byte[] handleHistoricalDataRequest(String requestStr, byte[] data) {
        HistoricalDataRequest request = m_requestParser.parseHistoricalDataRequest(requestStr, data);
        System.out.println("Sending historical data request: id=" + request.requestId() + " contract=" + Utils.shortContractString(request.contract()));
        clientSocket().reqHistoricalData(request.requestId(), request.contract(), request.endDateTime(), request.durationStr(), 
                request.barSizeSetting(), request.whatToShow(), request.useRth(), request.formatDate(), request.keepUpToDate(), null);
        return handleHistoricalDataBaseRequest(request);
    }

    /** Method handles historical data cancel request */
    public byte[] handleHistoricalDataCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_HISTORICAL_DATA);
        System.out.println("Cancelling historical data: id=" + request.requestId());
        return handleHistoricalDataBaseCancel(request);
    }

    /** Method handles historical data tick request */
    public String handleHistoricalDataTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.HISTORICAL_DATA_TICK);
        System.out.println("Handling historical data tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        return handleHistoricalDataTickBaseRequest(tickRequest);
    }
    
    /** Method handles historical data array request */
    public byte[] handleHistoricalDataArrayRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_HISTORICAL_DATA);
        System.out.println("Handling historical data array request: id=" + request.requestId());
        return handleHistoricalDataArrayBaseRequest(request);
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates historical data with new bar for requestId */
    public void liveUpdateHistoricalData(int requestId, Bar bar) {
        HistoricalDataMap dataMap = m_historicalDataRequests.get(requestId);
        if(dataMap != null) {
            boolean newBarAdded = dataMap.updateLiveBar(bar);
            if (newBarAdded) {
                if (dataMap.ddeRequestStatus() == DdeRequestStatus.SUBSCRIBED) {
                    updateRequestStatus(requestId, dataMap, DdeRequestStatus.RECEIVED, DdeRequestType.HISTORICAL_DATA_TICK.topic());
                }
            }
        }
    }
    
    /** Method updates historical data request status field for requestId */
    @Override
    public void updateHistoricalDataRequestStatus(int requestId, HistoricalDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.HISTORICAL_DATA_TICK.topic());
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class HistoricalDataRequestParser extends RequestParser {

        /** Method parses DDE request string to HistoricalDataRequest */
        public HistoricalDataRequest parseHistoricalDataRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, true, true, false, false, true);
            String endDateTime = "";
            String durationStr = "";
            String barSizeSetting = "";
            String whatToShow = "";
            int useRth = 0;
            int formatDate = 0;
            boolean keepUpToDate = false;
            
            if (Utils.isNotNull(table.get(14))) {
                endDateTime = table.get(14);
            }
            if (Utils.isNotNull(table.get(15))) {
                durationStr = table.get(15);
            }
            if (Utils.isNotNull(table.get(16))) {
                barSizeSetting = table.get(16);
            }
            if (Utils.isNotNull(table.get(17))) {
                whatToShow = table.get(17);
            }
            if (Utils.isNotNull(table.get(18))) {
                useRth = getIntFromString(table.get(18));
            }
            if (Utils.isNotNull(table.get(19))) {
                formatDate = getIntFromString(table.get(19));
            }
            if (Utils.isNotNull(table.get(20))) {
                keepUpToDate = getBooleanFromString(table.get(20));
            }
            return new HistoricalDataRequest(requestId, contract, endDateTime, durationStr, barSizeSetting, whatToShow, 
                    useRth, formatDate, keepUpToDate, requestStr);
            
        }
    }
}
