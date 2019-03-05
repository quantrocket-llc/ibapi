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
import com.ib.api.dde.dde2socket.requests.contractdetails.ContractDetailsRequest;
import com.ib.api.dde.dde2socket.requests.contractdetails.MarketRuleRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.datamap.BaseListDataMap;
import com.ib.api.dde.socket2dde.datamap.ContractDetailsMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.ContractDetails;
import com.ib.client.EClientSocket;
import com.ib.client.PriceIncrement;

/** Class handles contract details related requests, data and messages */
public class ContractDetailsHandler extends BaseHandler {
    // parser
    private ContractDetailsRequestParser m_requestParser = new ContractDetailsRequestParser();

    // contract details requests
    protected Map<Integer, ContractDetailsMap> m_contractDetailsRequests = Collections.synchronizedMap(new HashMap<Integer, ContractDetailsMap>());

    // market rule requests
    private Map<Integer, BaseListDataMap<PriceIncrement>> m_marketRuleRequests = Collections.synchronizedMap(new HashMap<Integer, BaseListDataMap<PriceIncrement>>());
    
    public ContractDetailsHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends contract details request to TWS */
    public byte[] handleContractDetailsRequest(String requestStr, byte[] data) {
        ContractDetailsRequest request = m_requestParser.parseContractDetailsRequest(requestStr, data);
        System.out.println("Sending contract details request: id=" + request.requestId() + " contract=" + Utils.shortContractString(request.contract()));
        clientSocket().reqContractDetails(request.requestId(), request.contract());

        ContractDetailsMap dataMap = new ContractDetailsMap(request);
        m_contractDetailsRequests.put(request.requestId(), dataMap);
        updateRequestStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        return null;
    }

    /** Method handles contract details cancel request */
    public byte[] handleContractDetailsCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_CONTRACT_DETAILS);
        System.out.println("Cancelling contract details: id=" + request.requestId());
        ContractDetailsMap dataMap = m_contractDetailsRequests.get(request.requestId());
        if(dataMap != null) {
            updateRequestStatus(request.requestId(), dataMap, DdeRequestStatus.CANCELLED);
            m_contractDetailsRequests.remove(request.requestId());
        }
        return null;
    }

    /** Method handles contract details tick request */
    public String handleContractDetailsTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.CONTRACT_DETAILS_TICK);
        System.out.println("Handling contract details tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        ContractDetailsMap dataMap = m_contractDetailsRequests.get(tickRequest.requestId());
        return handleTickRequest(tickRequest, dataMap);
    }
    
    /** Method handles contract details array request */
    public byte[] handleContractDetailsArrayRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_CONTRACT_DETAILS);
        System.out.println("Handling contract details array request: id=" + request.requestId());
        ContractDetailsMap dataMap = m_contractDetailsRequests.get(request.requestId());
        byte[] array = null;
        if (dataMap != null) {
            ContractDetailsRequest originalRequest = (ContractDetailsRequest)dataMap.ddeRequest();
            int requestId = request.requestId();
            boolean isFixedIncome = Utils.isFixedIncome(originalRequest.contract().secType()); 
            array = Utils.dataListToByteArray(syncCopyContractDetails(requestId), isFixedIncome);
            updateRequestStatus(request.requestId(), dataMap, DdeRequestStatus.FINISHED);
            dataMap.clearAllItems();
        }
        return array;
    }

    /** Method handles market rule request */
    public String handleMarketRuleRequest(String requestStr) {
        MarketRuleRequest request = m_requestParser.parseMarketRuleRequest(requestStr);
        String ret = "";
        BaseListDataMap<PriceIncrement> dataMap = m_marketRuleRequests.get(request.requestId());
        if (dataMap == null) {
            dataMap = new BaseListDataMap<PriceIncrement>(request);
            m_marketRuleRequests.put(request.requestId(), dataMap);
        }
        if (dataMap.ddeRequestStatus() == DdeRequestStatus.UNKNOWN) {
            System.out.println("Sending market rule request: marketRuleId=" + request.marketRuleId());
            clientSocket().reqMarketRule(request.marketRuleId());
            dataMap.ddeRequestStatus(DdeRequestStatus.REQUESTED);
        }
        ret = dataMap.ddeRequestStatus().toString();
        if (dataMap.ddeRequestStatus() == DdeRequestStatus.ERROR) {
            dataMap.ddeRequestStatus(DdeRequestStatus.REQUESTED);
        }
        return ret;
    }

    /** Method handles market rule array request */
    public byte[] handleMarketRuleArrayRequest(String requestStr) {
        MarketRuleRequest request = m_requestParser.parseMarketRuleRequest(requestStr);
        System.out.println("Handling market rule array request: marketRuleId=" + request.marketRuleId());
        BaseListDataMap<PriceIncrement> dataMap = m_marketRuleRequests.get(request.requestId());
        
        byte[] array = null;
        if (dataMap != null && dataMap.ddeRequestStatus() == DdeRequestStatus.RECEIVED) {
            array = Utils.dataListToByteArray(syncCopyPriceIncrements(request.requestId()));
            dataMap.ddeRequestStatus(DdeRequestStatus.FINISHED);
            notifyDde(DdeRequestType.REQUEST_MARKET_RULE.topic(), dataMap.ddeRequest().ddeRequestString());
            dataMap.clearAllItems();
        }
        return array;
    }

    /** Method handles market rule stop advise */
    public void handleMarketRuleStopAdvise(String requestStr) {
        int requestId = m_requestParser.getRequesIdFromString(requestStr);
        System.out.println("Handling market rule cancel: id=" + requestId);
        if (m_marketRuleRequests.containsKey(requestId)) {
            m_marketRuleRequests.remove(requestId);
        }
    }    
    
    /** Method handles market rule error request */
    public String handleMarketRuleErrorRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_MARKET_RULE_ERROR);
        // error request
        BaseListDataMap<PriceIncrement> dataMap = m_marketRuleRequests.get(request.requestId());
        if (dataMap != null) {
            m_marketRuleRequests.remove(request.requestId());
            return dataMap.error();
        }
        return "";
    }
    
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates contract details for requestId */
    public void updateContractDetails(int requestId, ContractDetails contractDetails) {
        ContractDetailsMap dataMap = m_contractDetailsRequests.get(requestId);
        if(dataMap != null) {
            dataMap.addItem(contractDetails);
        }
    }

    /** Method updates contract details end for requestId */
    public void updateContractDetailsEnd(int requestId) {
        updateDataEnd(requestId, m_contractDetailsRequests.get(requestId), DdeRequestType.CONTRACT_DETAILS_TICK.topic());
    }

    /** Method updates contract details request status tick/field for requestId */
    protected void updateRequestStatus(int requestId, ContractDetailsMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.CONTRACT_DETAILS_TICK.topic());
    }

    /** Method updates contract details request error tick/field for requestId */
    public void updateContractDetailsRequestError(int requestId, String errorMsgStr) {
        updateRequestError(requestId, errorMsgStr, m_contractDetailsRequests.get(requestId), DdeRequestType.CONTRACT_DETAILS_TICK.topic());
    }
    
    /** Method updates price increments for market rule request */
    public void updatePriceIncrements(int requestId, PriceIncrement[] priceIncrements) {
        BaseListDataMap<PriceIncrement> dataMap = m_marketRuleRequests.get(requestId);
        dataMap.addAllItems(Arrays.asList(priceIncrements));
        dataMap.ddeRequestStatus(DdeRequestStatus.RECEIVED);
        notifyDde(DdeRequestType.REQUEST_MARKET_RULE.topic(), dataMap.ddeRequest().ddeRequestString());
    }
    
    /** Method updates errors during market rule request */
    public void updateMarketRuleRequestError(int requestId, String errorMsgStr) {
        updateRequestError(errorMsgStr, m_marketRuleRequests.get(requestId), DdeRequestType.REQUEST_MARKET_RULE.topic());
    }
    
    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    private List<ContractDetails> syncCopyContractDetails(int requestId) {
        synchronized(m_contractDetailsRequests) {
            ContractDetailsMap dataMap = m_contractDetailsRequests.get(requestId);
            return (dataMap != null ? dataMap.syncCopyList() : new ArrayList<ContractDetails>());
        }
    }
    
    private List<PriceIncrement> syncCopyPriceIncrements(int requestId) {
        synchronized(m_marketRuleRequests) {
            BaseListDataMap<PriceIncrement> dataMap = m_marketRuleRequests.get(requestId);
            return (dataMap != null ? dataMap.syncCopyList() : new ArrayList<PriceIncrement>());
        }
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class ContractDetailsRequestParser extends RequestParser {

        /** Method parses DDE request string to ContractDetailsRequest */
        public ContractDetailsRequest parseContractDetailsRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, true, false, false, true, true);

            return new ContractDetailsRequest(requestId, contract, requestStr);
        }
        
        /** Method parses DDE request string to MarketRuleRequest */
        public MarketRuleRequest parseMarketRuleRequest(String requestStr) {
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            int marketRuleId = Integer.MAX_VALUE;
            if (messageTokens.length > 1) {
                marketRuleId = getIntFromString(messageTokens[1]);
            }
            return new MarketRuleRequest(requestId, marketRuleId, requestStr);
        }
    }
}
