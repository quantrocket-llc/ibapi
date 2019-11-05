/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.marketdata.MarketDataRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.MarketDataBaseHandler;
import com.ib.api.dde.socket2dde.datamap.MarketDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;

/** Class handles market data related requests, data and messages */
public class MarketDataHandler extends MarketDataBaseHandler {
    // parser
    private MarketDataRequestParser m_requestParser = new MarketDataRequestParser();

    public MarketDataHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends market data request to TWS */
    public byte[] handleMarketDataRequest(String requestStr, byte[] data) {
        MarketDataRequest request = m_requestParser.parseMarketDataRequest(requestStr, data);
        System.out.println("Sending market data request: id=" + request.requestId() + " for contract=" + Utils.shortContractString(request.contract()) + " genTicks=" + request.genericTicks());
        clientSocket().reqMktData(request.requestId(), request.contract(), 
                request.genericTicks(), request.snapshot(), false, null);
        return handleMarketDataBaseRequest(request);
    }

    /** Method returns array with long value */
    public byte[] handleTickLongValueRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.TICK);
        return handleTickLongValueBaseRequest(tickRequest);
    }
    
    /** Method sends market data cancel to TWS */
    public byte[] handleMktDataCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_MARKET_DATA);
        if(m_marketDataRequests.containsKey(request.requestId())) {
            System.out.println("Sending market data cancel: id=" + request.requestId());
            clientSocket().cancelMktData(request.requestId());
        }
        return handleMktDataBaseCancel(request);
    }

    /** Method handles tick request (bid, ask, bidSize etc) */
    public String handleTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.TICK);
        System.out.println("Handling tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        return handleTickBaseRequest(tickRequest);
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates market data status field */
    @Override 
    protected void updateMarketDataStatus(int requestId, MarketDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.TICK.topic());
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests 
     * and TWS responses to DDE notifications */
    private class MarketDataRequestParser extends RequestParser {

        /** Method parses DDE request string to MarketDataRequest */
        public MarketDataRequest parseMarketDataRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = parseRequestId(requestStr);
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, true, true, true, false, false);
            String genericTicks = parseGenericTicks(table);
            return new MarketDataRequest(requestId, contract, genericTicks, false, requestStr);
        }
    }
}
