/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.orders.ExerciseOptionsRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.datamap.BaseStringDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;

/** Class handles exercise options related requests */
public class ExerciseOptionsHandler extends BaseHandler {
    // parser
    private ExerciseOptionsRequestParser m_requestParser = new ExerciseOptionsRequestParser();

    // exercise options requests
    private Map<Integer, BaseStringDataMap> m_exerciseOptionsRequests = Collections.synchronizedMap(new HashMap<Integer, BaseStringDataMap>());

    public ExerciseOptionsHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/

    /** Method sends exercise options request to TWS */
    public byte[] handleExerciseOptionsRequest(String requestStr, byte[] data) {
        ExerciseOptionsRequest request = m_requestParser.parseExerciseOptionsRequest(requestStr, data);
        System.out.println("Sending exercise options request: id=" + request.requestId() + " contract=" + Utils.shortContractString(request.contract()) 
                    + " action=" + request.exerciseAction() + " quantity=" + request.exerciseQuantity() + " override=" + request.override());
        clientSocket().exerciseOptions(request.requestId(), request.contract(), request.exerciseAction(), 
                request.exerciseQuantity(), request.account(), request.override()); 
        BaseStringDataMap dataMap = new BaseStringDataMap(request);
        m_exerciseOptionsRequests.put(request.requestId(), dataMap);
        updateExerciseOptionsRequestStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        return null;
    }
    
    /** Method handles exercise options stop advise */
    public void handleExerciseOptionsStopAdvise(String requestStr) {
        int requestId = m_requestParser.getRequesIdFromString(requestStr);
        if (m_exerciseOptionsRequests.containsKey(requestId)) {
            System.out.println("Handling exercise options stop advise: " + requestStr);
            m_exerciseOptionsRequests.remove(requestId);
        }
    }

    /** Method handles exercise options tick request */
    public String handleExerciseOptionsTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.EXERCISE_OPTIONS_TICK);
        System.out.println("Handling exercise options tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        BaseStringDataMap dataMap = m_exerciseOptionsRequests.get(tickRequest.requestId());
        if (dataMap != null && tickRequest.tickType().equals(DdeRequestType.ORDER_STATUS.topic())) {
            return dataMap.getString();
        }
        return handleTickRequest(tickRequest, dataMap);
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates exercise options order status field for requestId */
    public void updateExerciseOptionsOrderStatus(int requestId, String orderStatus) {
        BaseStringDataMap dataMap = m_exerciseOptionsRequests.get(requestId);
        dataMap.setString(orderStatus);
        notifyDde(requestId, DdeRequestType.EXERCISE_OPTIONS_TICK.topic(), DdeRequestType.ORDER_STATUS.topic());
        updateExerciseOptionsRequestStatus(requestId, dataMap, DdeRequestStatus.FINISHED);
    }

    /** Method updates exercise options request status field for requestId */
    public void updateExerciseOptionsRequestStatus(int requestId, BaseStringDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.EXERCISE_OPTIONS_TICK.topic());
    }

    /** Method updates exercise options request error field for requestId */
    public void updateExerciseOptionsRequestError(int requestId, String errorMsgStr) {
        updateRequestError(requestId, errorMsgStr, m_exerciseOptionsRequests.get(requestId), DdeRequestType.EXERCISE_OPTIONS_TICK.topic());
    }    
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class ExerciseOptionsRequestParser extends RequestParser {

        /** Method parses DDE request string to ExerciseOptionsRequest */
        public ExerciseOptionsRequest parseExerciseOptionsRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, false, false, false, false, false);
            
            String account = "";
            int exerciseAction = Integer.MAX_VALUE;
            int exerciseQuantity = Integer.MAX_VALUE;
            int override = Integer.MAX_VALUE;
            
            String messageParamsStr = "";
            
            if (messageTokens.length > 1) {
                messageParamsStr = messageTokens[1];
                String[] messageParams = messageParamsStr.split(PARAM_SEPARATOR);
                if (messageParams.length > 0) {
                    account = messageParams[0];
                }
                if (messageParams.length > 1) {
                    exerciseAction = getIntFromString(messageParams[1]);
                }
                if (messageParams.length > 2) {
                    exerciseQuantity = getIntFromString(messageParams[2]);
                }
                if (messageParams.length > 3) {
                    override = getIntFromString(messageParams[3]);
                }
            }
            return new ExerciseOptionsRequest(requestId, contract, account, exerciseAction, exerciseQuantity, override, requestStr);
        }
    }
}
