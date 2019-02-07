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
import com.ib.api.dde.dde2socket.requests.contractdetails.MatchingSymbolsRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.datamap.BaseListDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.ContractDescription;
import com.ib.client.EClientSocket;

/** Class handles matching symbols related requests and data */
public class MatchingSymbolsHandler extends BaseHandler {
    // parser
    private MatchingSymbolsRequestParser m_requestParser = new MatchingSymbolsRequestParser();
    
    // security definition option parameters requests
    private Map<Integer, BaseListDataMap<ContractDescription>> m_matchingSymbolsRequests = Collections.synchronizedMap(new HashMap<Integer, BaseListDataMap<ContractDescription>>());
    
    public MatchingSymbolsHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles matching symbols request */
    public String handleMatchingSymbolsRequest(String requestStr) {
        MatchingSymbolsRequest request = m_requestParser.parseMatchingSymbolsRequest(requestStr);
        System.out.println("Handling matching symbols request: id=" + request.requestId() + " pattern=" + request.pattern());
        
        String ret = "";
        BaseListDataMap<ContractDescription> dataMap = m_matchingSymbolsRequests.get(request.requestId());
        if (dataMap == null) {
            dataMap = new BaseListDataMap<ContractDescription>(request);
            m_matchingSymbolsRequests.put(request.requestId(), dataMap);
        }
        if (dataMap.ddeRequestStatus() == DdeRequestStatus.UNKNOWN) {
            clientSocket().reqMatchingSymbols(request.requestId(), request.pattern());
            dataMap.ddeRequestStatus(DdeRequestStatus.REQUESTED);
        }

        ret = dataMap.ddeRequestStatus().toString();

        if (dataMap.ddeRequestStatus() == DdeRequestStatus.ERROR) {
            dataMap.ddeRequestStatus(DdeRequestStatus.REQUESTED);
        }
        return ret;
    }

    /** Method handles matching symbols array request */
    public byte[] handleMatchingSymbolsArrayRequest(String requestStr) {
        MatchingSymbolsRequest request = m_requestParser.parseMatchingSymbolsRequest(requestStr);
        System.out.println("Handling matching symbols array request: id=" + request.requestId() + " pattern=" + request.pattern());
        int requestId = request.requestId();
        
        byte[] array = Utils.dataListToByteArray(syncCopySymbolSamples(requestId), false, false); 

        BaseListDataMap<ContractDescription> dataMap = m_matchingSymbolsRequests.get(requestId);
        if (dataMap != null) {
            dataMap.ddeRequestStatus(DdeRequestStatus.FINISHED);
            notifyDde(request.ddeRequestType().topic(), request.ddeRequestString());
            dataMap.clearAllItems();
        }
        return array;
    }

    /** Method handles mathcing symbols cancel */
    public byte[] handleMatchingSymbolsCancel(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_MATCHING_SYMBOLS);
        System.out.println("Handling matching symbols cancel: id=" + request.requestId());
        m_matchingSymbolsRequests.remove(request.requestId());
        return null;
    }
    
    /** Method handles matching symbols error request */
    public String handleMatchingSymbolsErrorRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_MATCHING_SYMBOLS_ERROR);
        // error request
        BaseListDataMap<ContractDescription> dataMap = m_matchingSymbolsRequests.get(request.requestId());
        if (dataMap != null) {
            m_matchingSymbolsRequests.remove(request.requestId());
            return dataMap.error();
        }
        return "";
    }
    
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates symbol samples */
    public void updateSymbolSamples(int requestId, ContractDescription[] contractDescriptions) {
        BaseListDataMap<ContractDescription> dataMap = m_matchingSymbolsRequests.get(requestId);
        if (dataMap != null) {
            dataMap.addAllItems(Arrays.asList(contractDescriptions));
            updateRequestStatus(dataMap, DdeRequestStatus.RECEIVED, DdeRequestType.REQUEST_MATCHING_SYMBOLS.topic());
        }
    }

    /** Method updates errors during matching symbols request */
    public void updateMatchingSymbolsRequestError(int requestId, String errorMsgStr) {
        updateRequestError(errorMsgStr, m_matchingSymbolsRequests.get(requestId), DdeRequestType.REQUEST_MATCHING_SYMBOLS.topic());
    }
    
    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    protected List<ContractDescription> syncCopySymbolSamples(int requestId) {
        synchronized(m_matchingSymbolsRequests) {
            BaseListDataMap<ContractDescription> dataMap = m_matchingSymbolsRequests.get(requestId);
            return (dataMap != null ? dataMap.syncCopyList() : new ArrayList<ContractDescription>());
        }
    }
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests 
     * and TWS responses to DDE notifications */
    private class MatchingSymbolsRequestParser extends RequestParser {

        /** Method parses DDE request string to MatchingSymbolsRequest */
        private MatchingSymbolsRequest parseMatchingSymbolsRequest(String requestStr) {
            int requestId = -1;
            String pattern = "";
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            if (requestTokens.length > 1) {
                pattern = requestTokens[1];
            }
            return new MatchingSymbolsRequest(requestId, pattern, requestStr);
       }
    }
}
