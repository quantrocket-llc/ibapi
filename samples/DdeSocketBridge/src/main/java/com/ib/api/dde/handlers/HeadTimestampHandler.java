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
import com.ib.api.dde.dde2socket.requests.historicaldata.HeadTimestampRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.datamap.BaseStringDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;

/** Class handles head timestamp related requests, data and messages */
public class HeadTimestampHandler extends BaseHandler {
    // parserSystem.out.println
    private HeadTimestampRequestParser m_requestParser = new HeadTimestampRequestParser();

    // head timestamp requests
    private Map<Integer, BaseStringDataMap> m_headTimestampDataRequests = Collections.synchronizedMap(new HashMap<Integer, BaseStringDataMap>());

    public HeadTimestampHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/

    /** Method sends head timestamp request to TWS */
    public byte[] handleHeadTimestampRequest(String requestStr, byte[] data) {
        HeadTimestampRequest request = m_requestParser.parseHeadTimestampRequest(requestStr, data);
        System.out.println("Sending head timestamp request: id=" + request.requestId() + " contract=" + Utils.shortContractString(request.contract()));
        clientSocket().reqHeadTimestamp(request.requestId(), request.contract(), request.whatToShow(), request.useRth(), 
                request.formatDate());
        BaseStringDataMap dataMap = new BaseStringDataMap(request);
        m_headTimestampDataRequests.put(request.requestId(), dataMap);
        updateHeadTimestampRequestStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        return null;
    }
    
    /** Method handles head timestamp cancel request */
    public byte[] handleHeadTimestampCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_HEAD_TIMESTAMP);
        System.out.println("Cancelling head timestamp: id=" + request.requestId());
        clientSocket().cancelHeadTimestamp(request.requestId());
        BaseStringDataMap dataMap = m_headTimestampDataRequests.get(request.requestId());
        if(dataMap != null) {
            updateHeadTimestampRequestStatus(request.requestId(), dataMap, DdeRequestStatus.CANCELLED);
            m_headTimestampDataRequests.remove(request.requestId());
        }
        return null;
    }

    /** Method handles head timestamp tick request */
    public String handleHeadTimestampTickRequest(String requestStr) {
        String ret = "";
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.HEAD_TIMESTAMP_TICK);
        System.out.println("Handling head timestamp tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        BaseStringDataMap dataMap = m_headTimestampDataRequests.get(tickRequest.requestId());
        if (dataMap != null) {
            if (tickRequest.tickType().equals(DdeRequestType.HEAD_TIMESTAMP.topic())) {
                if (dataMap.ddeRequestStatus() != DdeRequestStatus.ERROR) {
                    ret = dataMap.getString();
                    updateHeadTimestampRequestStatus(tickRequest.requestId(), dataMap, DdeRequestStatus.FINISHED);
                }
            } else {
                ret = handleTickRequest(tickRequest, dataMap);
            }
        }
        return ret;
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates head timestamp for requestId */
    public void updateHeadTimestamp(int requestId, String headTimestamp) {
        BaseStringDataMap dataMap = m_headTimestampDataRequests.get(requestId);
        if(dataMap != null) {
            dataMap.setString(headTimestamp);
            notifyDde(requestId, DdeRequestType.HEAD_TIMESTAMP_TICK.topic(), DdeRequestType.HEAD_TIMESTAMP.topic());
        }
    }

    /** Method updates head timestamp request status field for requestId */
    public void updateHeadTimestampRequestStatus(int requestId, BaseStringDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.HEAD_TIMESTAMP_TICK.topic());
    }

    /** Method updates head timestamp request error field for requestId */
    public void updateHeadTimestampRequestError(int requestId, String errorMsgStr) {
        updateRequestError(requestId, errorMsgStr, m_headTimestampDataRequests.get(requestId), DdeRequestType.HEAD_TIMESTAMP_TICK.topic());
    }    
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class HeadTimestampRequestParser extends RequestParser {

        /** Method parses DDE request string to HeadTimestampRequest */
        public HeadTimestampRequest parseHeadTimestampRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, true, true, false, false, true);
            String whatToShow = "";
            int useRth = 0;
            int formatDate = 0;
            
            if (Utils.isNotNull(table.get(14))) {
                whatToShow = table.get(14);
            }
            if (Utils.isNotNull(table.get(15))) {
                useRth = getIntFromString(table.get(15));
            }
            if (Utils.isNotNull(table.get(16))) {
                formatDate = getIntFromString(table.get(16));
            }
            return new HeadTimestampRequest(requestId, contract, whatToShow, useRth, formatDate, requestStr);
        }
    }
}
