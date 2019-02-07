/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.handlers;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.contractdetails.ContractDetailsRequest;
import com.ib.api.dde.handlers.ContractDetailsHandler;
import com.ib.api.dde.old.requests.parser.OldRequestParser;
import com.ib.api.dde.socket2dde.datamap.ContractDetailsMap;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;

/** Class handles old-style contract details related requests, data and messages */
public class OldContractDetailsHandler extends ContractDetailsHandler {
    // parser
    private OldContractDetailsRequestParser m_requestParser = new OldContractDetailsRequestParser();

    public OldContractDetailsHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles contract details tick request */
    @Override
    public String handleContractDetailsTickRequest(String requestStr) {
        String ret = "";
        DdeRequest ddeRequest = m_requestParser. parseContractDetailsRequest(requestStr);
        if (ddeRequest == null) {
            return ret;
        }
        System.out.println("Handling contract details tick request: " + requestStr);
        
        if (ddeRequest instanceof ContractDetailsRequest) {
            ContractDetailsRequest request = (ContractDetailsRequest)ddeRequest;
            clientSocket().reqContractDetails(request.requestId(), request.contract());
            ContractDetailsMap dataMap = new ContractDetailsMap(request);
            m_contractDetailsRequests.put(request.requestId(), dataMap);
        } else if (ddeRequest instanceof TickRequest) {
            TickRequest tickRequest = (TickRequest)ddeRequest;
            ContractDetailsMap dataMap = m_contractDetailsRequests.get(tickRequest.requestId());
            ret = handleTickRequest(tickRequest, dataMap);
        }
        return ret;
    }    

    /** Method stops tick advise loop */
    public void handleContractDetailsTickStopAdvise(String requestStr) {
        int requestId = m_requestParser.getRequesIdFromString(requestStr);
        if (m_contractDetailsRequests.containsKey(requestId)) {
            System.out.println("Handling contract details tick stop advise: " + requestStr);
            m_contractDetailsRequests.remove(requestId);
        }
    }    

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates contract details end for requestId */
    @Override
    public void updateContractDetailsEnd(int requestId) {
        ContractDetailsMap dataMap = m_contractDetailsRequests.get(requestId);
        if(dataMap != null) {
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.ORDER_TYPES);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.VALID_EXCHANGES);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.CON_ID);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.MIN_TICK);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.MULTIPLIER);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.MARKET_NAME);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.TRADING_CLASS);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.SYMBOL);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.COUPON);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.MATURITY);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.ISSUE_DATE);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.RATINGS);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.BOND_TYPE);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.COUPON_TYPE);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.CONVERTIBLE);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.CALLABLE);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.PUTABLE);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.DESC_APPEND);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.NEXT_OPTION_DATE);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.NEXT_OPTION_TYPE);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.NEXT_OPTION_PARTIAL);
            notifyDde(requestId, DdeRequestType.CONTRACT.topic(), ContractDetailsMap.NOTES);
        }
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class OldContractDetailsRequestParser extends OldRequestParser {

        /** Method parses DDE request string to DdeRequest */
        public DdeRequest parseContractDetailsRequest(String requestStr) {
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
                Contract contract = tickTypeStr.equals(DdeRequestType.REQ.topic()) ? parseContract(contractStr, false, false, true) : parseContract(contractStr, true, false, true);
                return new ContractDetailsRequest(requestId, contract, requestStr);
            } else {
                if (requestTokens.length > 2) {
                    tickTypeStr = requestTokens[2] + PARAM_SEPARATOR + tickTypeStr;
                }
                return new TickRequest(requestId, tickTypeStr, DdeRequestType.CONTRACT_DETAILS_TICK, requestStr);
            }
        }
    }
}
