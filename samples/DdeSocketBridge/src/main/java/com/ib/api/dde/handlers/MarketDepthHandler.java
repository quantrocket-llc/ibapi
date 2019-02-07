/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.marketdepth.MarketDepthCancelRequest;
import com.ib.api.dde.dde2socket.requests.marketdepth.MarketDepthRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.data.MarketDepthData;
import com.ib.api.dde.socket2dde.datamap.MarketDepthDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.DepthMktDataDescription;
import com.ib.client.EClientSocket;

/** Class handles market depth related requests, data and messages */
public class MarketDepthHandler extends BaseHandler {
    // parser
    private MarketDepthRequestParser m_requestParser = new MarketDepthRequestParser();

    // market depth requests
    protected Map<Integer, MarketDepthDataMap> m_marketDepthRequests = Collections.synchronizedMap(new HashMap<Integer, MarketDepthDataMap>());

    // market depth exchanges
    private List<DepthMktDataDescription> m_mktDepthExchanges = Collections.synchronizedList(new ArrayList<DepthMktDataDescription>());
    private DdeRequestStatus m_mktDepthExchangesRequestStatus = DdeRequestStatus.UNKNOWN;
    
    public MarketDepthHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends market depth request to TWS */
    public byte[] handleMarketDepthRequest(String requestStr, byte[] data) {
        MarketDepthRequest request = m_requestParser.parseMarketDepthRequest(requestStr, data);
        System.out.println("Sending market depth request: id=" + request.requestId() + " for contract=" + Utils.shortContractString(request.contract()) + " isSmartDepth=" + request.isSmartDepth());
        clientSocket().reqMktDepth(request.requestId(), request.contract(), request.numRows(), request.isSmartDepth(), null);
        MarketDepthDataMap dataMap = new MarketDepthDataMap(request);
        m_marketDepthRequests.put(request.requestId(), dataMap);
        updateMarketDepthStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        return null;
    }

    /** Method sends market depth cancel to TWS */
    public byte[] handleMktDepthCancel(String requestStr) {
        MarketDepthCancelRequest request =  m_requestParser.parseMarketDepthCancelRequest(requestStr);
        MarketDepthDataMap dataMap = m_marketDepthRequests.get(request.requestId());
        return sendCancelMktDepth(dataMap);
    }

    /** Method sends market depth cancel to TWS */
    public void handleMktDepthStopAdvise(String requestStr) {
        DdeRequest ddeRequest =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_MARKET_DEPTH);
        MarketDepthDataMap dataMap = m_marketDepthRequests.get(ddeRequest.requestId());
        sendCancelMktDepth(dataMap);
    }
    
    /** Method sends market depth cancel to TWS */
    private byte[] sendCancelMktDepth(MarketDepthDataMap dataMap) {
        if(dataMap != null) {
            MarketDepthRequest request = ((MarketDepthRequest)dataMap.ddeRequest());
            System.out.println("Sending market depth cancel: id=" + request.requestId() + " isSmartDepth=" + request.isSmartDepth());
            clientSocket().cancelMktDepth(request.requestId(), request.isSmartDepth());
            updateMarketDepthStatus(request.requestId(), dataMap, DdeRequestStatus.CANCELLED);
            m_marketDepthRequests.remove(request.requestId());
        }
        return null;
    }
    
    /** Method handles market depth tick request */
    public String handleMktDepthTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.MARKET_DEPTH_TICK);
        System.out.println("Handling market depth tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        MarketDepthDataMap dataMap = m_marketDepthRequests.get(tickRequest.requestId());
        return handleTickRequest(tickRequest, dataMap);
    }
    
    /** Method sends market depth exchanges request to TWS */
    public String handleMktDepthExchangesRequest(String requestStr) {
        if (m_mktDepthExchangesRequestStatus == DdeRequestStatus.UNKNOWN) {
            System.out.println("Sending mkt depth exchanges request.");
            clientSocket().reqMktDepthExchanges();
            m_mktDepthExchangesRequestStatus = DdeRequestStatus.REQUESTED;
        }
        return m_mktDepthExchangesRequestStatus.toString();
    }
    
    /** Method handles market depth exchanges array request */
    public byte[] handleMktDepthExchangesArrayRequest(String requestStr) {
        System.out.println("Handling mkt depth exchanges array request");
        m_mktDepthExchangesRequestStatus = DdeRequestStatus.FINISHED;
        notifyDde(DdeRequestType.REQUEST_MARKET_DEPTH_EXCHANGES.topic(), RequestParser.ID_ZERO);
        byte[] array = Utils.dataListToByteArray(syncCopyMktDepthExchanges());
        m_mktDepthExchanges.clear();
        return array;
    }
    
    /** Method stops market depth exchanges advise loop */
    public void handleMktDepthExchangesCancel(String requestStr) {
        System.out.println("Handling mkt depth exchanges cancel: " + requestStr);
        m_mktDepthExchangesRequestStatus = DdeRequestStatus.UNKNOWN;
    }
    

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates market depth data for requestId */
    public void updateMarketDepthData(int requestId, MarketDepthData marketDepthData, DdeRequestStatus status) {
        MarketDepthDataMap dataMap = m_marketDepthRequests.get(requestId);
        if(dataMap != null) {
            ArrayList<String> fields = dataMap.updateMarketDepthData(marketDepthData);
            updateMarketDepthStatus(requestId, dataMap, status);
            for (String field: fields) {
                notifyDde(requestId, DdeRequestType.MARKET_DEPTH_TICK.topic(), field);
            }
        }
    }

    /** Method updates market depth status field for requestId */
    private void updateMarketDepthStatus(int requestId, MarketDepthDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.MARKET_DEPTH_TICK.topic());
    }

    /** Method updates market depth error field for requestId */
    public void updateMarketDepthError(int requestId, String errorMsgStr) {
        updateRequestError(requestId, errorMsgStr,m_marketDepthRequests.get(requestId), DdeRequestType.MARKET_DEPTH_TICK.topic());
    }
    
    /** Method updates market depth exchanges */
    public void updateMktDepthExchanges(DepthMktDataDescription[] depthMktDataDescriptions) {
        m_mktDepthExchanges.addAll(Arrays.asList(depthMktDataDescriptions));
        m_mktDepthExchangesRequestStatus = DdeRequestStatus.RECEIVED;
        notifyDde(DdeRequestType.REQUEST_MARKET_DEPTH_EXCHANGES.topic(), RequestParser.ID_ZERO);
    }
    
    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    private List<DepthMktDataDescription> syncCopyMktDepthExchanges() {
        synchronized(m_mktDepthExchanges) {
            return new ArrayList<DepthMktDataDescription>(m_mktDepthExchanges);
        }
    }
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class MarketDepthRequestParser extends RequestParser {

        /** Method parses DDE request string to MarketDepthRequest */
        public MarketDepthRequest parseMarketDepthRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            boolean isSmartDepth = true;
            if (messageTokens.length > 1) {
                isSmartDepth = getBooleanFromString(messageTokens[1]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, true, false, false, false, false);
            
            return new MarketDepthRequest(requestId, contract, 15, isSmartDepth, requestStr);
        }

        /** Method parses DDE request string to MarketDepthCancelRequest */
        public MarketDepthCancelRequest parseMarketDepthCancelRequest(String requestStr) {
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            boolean isSmartDepth = true;
            if (messageTokens.length > 1) {
                isSmartDepth = getBooleanFromString(messageTokens[1]);
            }

            return new MarketDepthCancelRequest(requestId, isSmartDepth, requestStr);
        }
    }
}
