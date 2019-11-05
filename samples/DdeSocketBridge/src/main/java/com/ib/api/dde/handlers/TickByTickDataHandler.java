/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.marketdata.TickByTickRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.MarketDataBaseHandler;
import com.ib.api.dde.socket2dde.data.TickByTickData;
import com.ib.api.dde.socket2dde.datamap.MarketDataMap;
import com.ib.api.dde.socket2dde.datamap.TickByTickDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;
import com.ib.client.Types.SecType;

/** Class handles tick-by-tick data related requests, data and messages */
public class TickByTickDataHandler extends MarketDataBaseHandler {
    // parser
    private TickByTickRequestParser m_requestParser = new TickByTickRequestParser();

    // tick-by-tick requests ext
    private Map<Integer, TickByTickDataMap> m_tickByTickDataRequests = Collections.synchronizedMap(new HashMap<Integer, TickByTickDataMap>());
    
    public TickByTickDataHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends tick-by-tick data request to TWS */
    public byte[] handleTickByTickDataRequest(String requestStr, byte[] data) {
        TickByTickRequest request = m_requestParser.parseTickByTickRequest(requestStr, data);
        System.out.println("Sending tick-by-tick data request: id=" + request.requestId() + " for contract=" + Utils.shortContractString(request.contract()) + " tickType=" + request.tickType());
        clientSocket().reqTickByTickData(request.requestId(), request.contract(), request.tickType(), 0, request.ignoreSize());
        return handleMarketDataBaseRequest(request);
    }
    
    /** Method sends tick-by-tick request to TWS */
    public byte[] handleTickByTickDataRequestExt(String requestStr, byte[] data) {
        TickByTickRequest request = m_requestParser.parseTickByTickRequestExt(requestStr, data);
        System.out.println("Sending tick-by-tick data request: id=" + request.requestId() + " for contract=" + Utils.shortContractString(request.contract()));
        clientSocket().reqTickByTickData(request.requestId(), request.contract(), request.tickType(), 0, request.ignoreSize());
        clientSocket().reqTickByTickData(request.requestId() + 50000, request.contract(), TickByTickData.BID_ASK, 0, request.ignoreSize());
        
        TickByTickDataMap dataMap = new TickByTickDataMap(request);
        dataMap.numberOfRows(request.numberOfRows());
        m_tickByTickDataRequests.put(request.requestId(), dataMap);
        updateTickByTickDataStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        return null;
    }

    /** Method sends tick-by-tick data cancel to TWS */
    public byte[] handleTickByTickDataCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_TICK_BY_TICK_DATA);
        if(m_marketDataRequests.containsKey(request.requestId())) {
            System.out.println("Sending tick-by-tick data cancel: id=" + request.requestId());
            clientSocket().cancelTickByTickData(request.requestId());
        }
        return handleMktDataBaseCancel(request);
    }

    /** Method sends tick-by-tick data cancel to TWS */
    public byte[] handleTickByTickDataCancelExt(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_TICK_BY_TICK_DATA_EXT);
        System.out.println("Sending tick-by-tick data cancel: id=" + request.requestId());
        TickByTickDataMap dataMap = m_tickByTickDataRequests.get(request.requestId());
        if(dataMap != null) {
            clientSocket().cancelTickByTickData(request.requestId());
            clientSocket().cancelTickByTickData(request.requestId() + 50000);
            updateTickByTickDataStatus(request.requestId(), dataMap, DdeRequestStatus.CANCELLED);
            m_tickByTickDataRequests.remove(request.requestId());
        }
        return null;
    }
    
    /** Method handles tick-by-tick data tick request */
    public String handleTickByTickDataTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.TICK_BY_TICK_DATA_TICK);
        System.out.println("Handling tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        return handleTickBaseRequest(tickRequest);
    }
    
    /** Method handles tick-by-tick data tick request */
    public String handleTickByTickDataTickRequestExt(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.TICK_BY_TICK_DATA_TICK_EXT);
        System.out.println("Handling tick-by-tick data tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        TickByTickDataMap dataMap = m_tickByTickDataRequests.get(tickRequest.requestId());
        return handleTickRequest(tickRequest, dataMap);
    }
    

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates tick-by-tick data for requestId */
    public void updateTickByTickDataExt(int requestId, TickByTickData tickByTickData, DdeRequestStatus status) {
        TickByTickDataMap dataMap = m_tickByTickDataRequests.get(requestId);
        if(dataMap != null) {
            ArrayList<String> fields = dataMap.updateTickByTickData(tickByTickData);
            updateTickByTickDataStatus(requestId, dataMap, status);
            for (String field: fields) {
                notifyDde(requestId, DdeRequestType.TICK_BY_TICK_DATA_TICK_EXT.topic(), field);
            }
        }
    }
    
    /** Method updates tick-by-tick data status field for requestId */
    private void updateTickByTickDataStatus(int requestId, TickByTickDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.TICK_BY_TICK_DATA_TICK_EXT.topic());
    }
    
    /** Method updates tick-by-tick data error field for requestId */
    public void updateTickByTickDataErrorExt(int requestId, String errorMsgStr) {
        updateRequestError(requestId, errorMsgStr, m_tickByTickDataRequests.get(requestId), DdeRequestType.TICK_BY_TICK_DATA_TICK_EXT.topic());
    }
    
    /** Method updates tick-by-tick data status field for requestId */
    @Override 
    protected void updateMarketDataStatus(int requestId, MarketDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.TICK_BY_TICK_DATA_TICK.topic());
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class TickByTickRequestParser extends RequestParser {

        /** Method parses DDE request string to TickByTickRequest */
        public TickByTickRequest parseTickByTickRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            String tickType = "";
            if (messageTokens.length > 1) {
                tickType = messageTokens[1];
            }
            boolean ignoreSize = false;
            if (messageTokens.length > 2) {
                ignoreSize = getBooleanFromString(messageTokens[2]);
            }
            
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, true, false, false, false, false);
            
            return new TickByTickRequest(requestId, contract, tickType, 0, ignoreSize, requestStr);
        }
        
        /** Method parses DDE request string to TickByTickRequest */
        public TickByTickRequest parseTickByTickRequestExt(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            boolean ignoreSize = false;
            if (messageTokens.length > 1) {
                ignoreSize = getBooleanFromString(messageTokens[1]);
            }
            int numberOfRows = 0;
            if (messageTokens.length > 2) {
                numberOfRows = getIntFromString(messageTokens[2]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, true, false, false, false, false);
            String tickType = TickByTickData.ALL_LAST;
            if (contract.secType() == SecType.CASH) {
                tickType = TickByTickData.MID_POINT;
            }
            
            return new TickByTickRequest(requestId, contract, tickType, numberOfRows, ignoreSize, requestStr);
        }        
    }
}
