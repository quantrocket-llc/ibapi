/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.handlers;

import java.util.StringTokenizer;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.historicaldata.HistoricalDataRequest;
import com.ib.api.dde.handlers.HistoricalDataHandler;
import com.ib.api.dde.old.requests.parser.OldRequestParser;
import com.ib.api.dde.socket2dde.datamap.HistoricalDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;

/** Class handles old-style historical data related requests, data and messages */
public class OldHistoricalDataHandler extends HistoricalDataHandler {
    // parser
    private OldHistoricalDataRequestParser m_requestParser = new OldHistoricalDataRequestParser();

    public OldHistoricalDataHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends historical data request to TWS */
    public String handleHistoricalDataRequest(String requestStr) {
        HistoricalDataRequest request = m_requestParser.parseHistoricalDataRequest(requestStr);
        System.out.println("Handling historical data request: id=" + request.requestId() + " contract=" + Utils.shortContractString(request.contract()));
        
        HistoricalDataMap dataMap = m_historicalDataRequests.get(request.requestId());
        if(dataMap == null) {
            clientSocket().reqHistoricalData(request.requestId(), request.contract(), request.endDateTime(), request.durationStr(), 
                    request.barSizeSetting(), request.whatToShow(), request.useRth(), request.formatDate(), request.keepUpToDate(), null);
            dataMap = new HistoricalDataMap(request);
            m_historicalDataRequests.put(request.requestId(), dataMap);
            updateHistoricalDataRequestStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        }
        return dataMap.ddeRequestStatus().toString();
    }

    /** Method stops historical data advise loop */
    public void handleHistoricalDataStopAdvise(String requestStr) {
        int requestId = m_requestParser.getRequesIdFromString(requestStr);
        if (m_historicalDataRequests.containsKey(requestId)) {
            System.out.println("Handling historical data stop advise: " + requestStr);
            clientSocket().cancelHistoricalData(requestId);
            m_historicalDataRequests.remove(requestId);
        }
    }    
    
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates historical data end for requestId */
    public void updateHistoricalDataEnd(int requestId) {
        updateDataEnd(m_historicalDataRequests.get(requestId), DdeRequestType.HIST.topic());
    }
    
    /** Method updates historical data request status field for requestId */
    @Override
    public void updateHistoricalDataRequestStatus(int requestId, HistoricalDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(dataMap, status, DdeRequestType.HIST.topic());
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class OldHistoricalDataRequestParser extends OldRequestParser {

        /** Method parses DDE request string to HistoricalDataRequest */
        public HistoricalDataRequest parseHistoricalDataRequest(String requestStr) {
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            String tickTypeStr = "";
            if (messageTokens.length > 1) {
                tickTypeStr = messageTokens[1];
            }
            
            Contract contract = new Contract();
            String endDateTime = "";
            String durationStr = "";
            String barSizeSetting = "";
            String whatToShow = "";
            int useRth = 0;
            int formatDate = 0;
            boolean keepUpToDate = false;
            
            if (tickTypeStr.equals(DdeRequestType.REQ.topic()) || tickTypeStr.equals(DdeRequestType.REQ2.topic())) {
                String[] contractDetails = messageTokens[2].split(CONTRACT_DETAILS_SEPARATOR);
                String contractStr = "";
                String orderStr = "";
                if (contractDetails.length > 0) {
                    contractStr = contractDetails[0];
                }
                
                contract = tickTypeStr.equals(DdeRequestType.REQ.topic()) ? parseContract(contractStr, false, true, false) : parseContract(contractStr, true, true, false);

                if (contractDetails.length > 1) {
                    orderStr = contractDetails[1];
                }
                
                StringTokenizer st = new StringTokenizer(orderStr, PARAM_SEPARATOR);
                String token = getParameter(st);
                if (Utils.isNotNull(token)){
                    endDateTime = OldRequestParser.getString(token);
                }
                token = getParameter(st);
                if (Utils.isNotNull(token)){
                    durationStr = OldRequestParser.getString(token);
                }
                token = getParameter(st);
                if (Utils.isNotNull(token)){
                    barSizeSetting = OldRequestParser.getString(token);
                }
                token = getParameter(st);
                if (Utils.isNotNull(token)){
                    whatToShow = token;
                }
                token = getParameter(st);
                if (Utils.isNotNull(token)){
                    useRth = getIntFromString(token);
                }
                if (Utils.isNotNull(token) && useRth == Integer.MAX_VALUE) {
                    whatToShow += (PARAM_SEPARATOR + token);
                    token = getParameter(st);
                    if (Utils.isNotNull(token)){
                        useRth = getIntFromString(token);
                    }
                }
                token = getParameter(st);
                if (Utils.isNotNull(token)){
                    formatDate = getIntFromString(token);
                }
                token = getParameter(st);
                if (Utils.isNotNull(token)){
                    contract.includeExpired(getBooleanFromString(token));
                }
            }
            return new HistoricalDataRequest(requestId, contract, endDateTime, durationStr, barSizeSetting, whatToShow, 
                    useRth, formatDate, keepUpToDate, requestStr);
        }
    }
}
