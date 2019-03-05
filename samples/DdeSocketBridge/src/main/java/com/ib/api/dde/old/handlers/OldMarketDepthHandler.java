/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.handlers;

import java.util.ArrayList;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.marketdepth.MarketDepthRequest;
import com.ib.api.dde.handlers.MarketDepthHandler;
import com.ib.api.dde.old.requests.parser.OldRequestParser;
import com.ib.api.dde.socket2dde.data.MarketDepthData;
import com.ib.api.dde.socket2dde.datamap.MarketDepthDataMap;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;

/** Class handles old-style market depth related requests, data and messages */
public class OldMarketDepthHandler extends MarketDepthHandler {
    // parser
    private OldMarketDepthRequestParser m_requestParser = new OldMarketDepthRequestParser();

    public OldMarketDepthHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles market depth tick request */
    @Override
    public String handleMktDepthTickRequest(String requestStr) {
        String ret = "";
        DdeRequest ddeRequest = m_requestParser.parseMarketDepthRequest(requestStr);
        if (ddeRequest == null) {
            return ret;
        }
        System.out.println("Handling market depth tick request: " + requestStr);
        
        if (ddeRequest instanceof MarketDepthRequest) {
            MarketDepthRequest request = (MarketDepthRequest)ddeRequest;
            clientSocket().reqMktDepth(request.requestId(), request.contract(), request.numRows(), request.isSmartDepth(), null);
            MarketDepthDataMap dataMap = new MarketDepthDataMap(request);
            m_marketDepthRequests.put(request.requestId(), dataMap);
        } else if (ddeRequest instanceof TickRequest) {
            TickRequest tickRequest = (TickRequest)ddeRequest;
            MarketDepthDataMap dataMap = m_marketDepthRequests.get(tickRequest.requestId());
            ret = handleTickRequest(tickRequest, dataMap);
            if (ret.equalsIgnoreCase(" ")) {
                ret = String.valueOf(0);
            }
        }
        return ret;
    }

    /** Method stops tick advise loop */
    public void handleMktDepthTickStopAdvise(String requestStr) {
        int requestId = m_requestParser.getRequesIdFromString(requestStr);
        if (m_marketDepthRequests.containsKey(requestId)) {
            System.out.println("Handling market depth tick stop advise: " + requestStr);
            clientSocket().cancelMktDepth(requestId, true);
            m_marketDepthRequests.remove(requestId);
        }
    }    

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates market depth data for requestId */
    @Override
    public void updateMarketDepthData(int requestId, MarketDepthData marketDepthData, DdeRequestStatus status) {
        MarketDepthDataMap dataMap = m_marketDepthRequests.get(requestId);
        if(dataMap != null) {
            ArrayList<String> fields = dataMap.updateMarketDepthData(marketDepthData);
            for (String field: fields) {
                notifyDde(requestId, DdeRequestType.MKTDEPTH.topic(), m_requestParser.convertToOld(field));
            }
        }
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class OldMarketDepthRequestParser extends OldRequestParser {

        /** Method parses DDE request string to MarketDepthRequest */
        public DdeRequest parseMarketDepthRequest(String requestStr) {
            
            int requestId = -1;
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            String tickTypeStr = "";
            if (requestTokens.length > 1) {
                tickTypeStr = requestTokens[1];
            }
            if (tickTypeStr.equals(DdeRequestType.REQ.topic()) || tickTypeStr.equals(DdeRequestType.REQ2.topic())) {
                String[] contractDetails = requestTokens[2].split(CONTRACT_DETAILS_SEPARATOR);
                String contractStr = "";
                if (contractDetails.length > 0) {
                    contractStr = contractDetails[0];
                }
                Contract contract = tickTypeStr.equals(DdeRequestType.REQ.topic()) ? parseContract(contractStr, false, false, false) : parseContract(contractStr, true, false, false);
                return new MarketDepthRequest(requestId, contract, 30, true, requestStr);
            } else {
                if (requestTokens.length > 2) {
                    tickTypeStr = requestTokens[2] + PARAM_SEPARATOR + tickTypeStr;
                }
                return new TickRequest(requestId, tickTypeStr, DdeRequestType.MARKET_DEPTH_TICK, requestStr);
            }
            
        }
        
        public String convertToOld(String field) {
            String[] tokens = field.split(PARAM_SEPARATOR);
            return tokens[2] + DDE_REQUEST_SEPARATOR + tokens[0] + PARAM_SEPARATOR + tokens[1];
        }
    }
}
