/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.marketdata.CalculateImpliedVolatilityRequest;
import com.ib.api.dde.dde2socket.requests.marketdata.CalculateOptionPriceRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.MarketDataBaseHandler;
import com.ib.api.dde.socket2dde.datamap.MarketDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;

/** Class handles calculate implied volatility and calculate option price related requests, data and messages */
public class CalcImplVolOptPriceHandler extends MarketDataBaseHandler {
    // parser
    private CalcImplVolOptPriceRequestParser m_requestParser = new CalcImplVolOptPriceRequestParser();

    public CalcImplVolOptPriceHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends calculate implied volatility/option price request to TWS */
    public byte[] handleCalculateRequest(String requestStr, byte[] data, DdeRequestType requestType) {
        DdeRequest ddeRequest = m_requestParser.parseCalculateRequest(requestStr, data, requestType);
        switch(requestType) {
            case CALCULATE_IMPLIED_VOLATILITY:
                CalculateImpliedVolatilityRequest implVolRequest = (CalculateImpliedVolatilityRequest)ddeRequest;
                System.out.println("Sending calculate implied volatility request: id=" + implVolRequest.requestId() + " for contract=" 
                        + Utils.shortContractString(implVolRequest.contract()) + " optionPrice=" + implVolRequest.optionPrice() 
                        + " underlyingPrice=" + implVolRequest.underlyingPrice());
                clientSocket().calculateImpliedVolatility(implVolRequest.requestId(), implVolRequest.contract(), 
                        implVolRequest.optionPrice(), implVolRequest.underlyingPrice(), null);
                break;
            case CALCULATE_OPTION_PRICE:
                CalculateOptionPriceRequest optPriceRequest = (CalculateOptionPriceRequest)ddeRequest;
                System.out.println("Sending calculate option price request: id=" + optPriceRequest.requestId() + " for contract=" + Utils.shortContractString(optPriceRequest.contract()) + 
                        " impiedVolatility=" + optPriceRequest.impliedVolatility() + " underlyingPrice=" + optPriceRequest.underlyingPrice());
                clientSocket().calculateOptionPrice(optPriceRequest.requestId(), optPriceRequest.contract(), 
                        optPriceRequest.impliedVolatility(), optPriceRequest.underlyingPrice(), null);
                break;
            default:
                break;
        }
        return handleMarketDataBaseRequest(ddeRequest);
    }
    
    /** Method sends calculate implied volatility/option price cancel to TWS */
    public byte[] handleCalculateCancel(String requestStr, DdeRequestType requestType) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, requestType);
        if (m_marketDataRequests.containsKey(request.requestId())) {
            switch(requestType) {
                case CANCEL_CALCULATE_IMPLIED_VOLATILITY:
                    System.out.println("Sending calculate implied volatility cancel: id=" + request.requestId());
                    clientSocket().cancelCalculateImpliedVolatility(request.requestId());
                    break;
                case CANCEL_CALCULATE_OPTION_PRICE:
                    System.out.println("Sending calculate option price cancel: id=" + request.requestId());
                    clientSocket().cancelCalculateOptionPrice(request.requestId());
                    break;
                default:
                    break;
            }
        }
        return handleMktDataBaseCancel(request);
    }

    /** Method handles calculate implied volatility/option price tick request */
    public String handleCalculateTickRequest(String requestStr, DdeRequestType requestType) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, requestType);
        switch(requestType) {
            case CALCULATE_IMPLIED_VOLATILITY_TICK:
                System.out.println("Handling calculate implied volatility tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
                break;
            case CALCULATE_OPTION_PRICE_TICK:
                System.out.println("Handling calculate option price tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
                break;
            default:
                break;
        }
        return handleTickBaseRequest(tickRequest);
    }
    

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates calculate implied volatility status field for requestId */
    @Override 
    protected void updateMarketDataStatus(int requestId, MarketDataMap dataMap, DdeRequestStatus status) {
        if (dataMap.ddeRequest() instanceof CalculateImpliedVolatilityRequest) {
            updateRequestStatus(requestId, dataMap, status, DdeRequestType.CALCULATE_IMPLIED_VOLATILITY_TICK.topic());
        } else if (dataMap.ddeRequest() instanceof CalculateOptionPriceRequest) {
            updateRequestStatus(requestId, dataMap, status, DdeRequestType.CALCULATE_OPTION_PRICE_TICK.topic());
        }
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class CalcImplVolOptPriceRequestParser extends RequestParser {

        /** Method parses DDE request string to CalculateImpliedVolatilityRequest */
        public DdeRequest parseCalculateRequest(String requestStr, byte[] data,DdeRequestType requestType) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            double firstVal = Double.MAX_VALUE;
            if (messageTokens.length > 1) {
                firstVal = getDoubleFromString(messageTokens[1]);
            }
            double secondVal = Double.MAX_VALUE;
            if (messageTokens.length > 2) {
                secondVal = getDoubleFromString(messageTokens[2]);
            }
            
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, true, false, false, false, false);
            
            switch(requestType) {
                case CALCULATE_IMPLIED_VOLATILITY:
                    return new CalculateImpliedVolatilityRequest(requestId, contract, firstVal, secondVal, requestStr);
                case CALCULATE_OPTION_PRICE:
                    return new CalculateOptionPriceRequest(requestId, contract, firstVal, secondVal, requestStr);
                default:
                    break;
            }
            return null;
        }
        

    }
}
