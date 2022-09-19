/* Copyright (C) 2021 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.historicaldata.HistoricalScheduleRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.datamap.BaseStringDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;
import com.ib.client.HistoricalSession;

/** Class handles historical schedule related requests, data and messages */
public class HistoricalScheduleHandler extends BaseHandler {
    // parser
    private HistoricalScheduleRequestParser m_requestParser = new HistoricalScheduleRequestParser();

    // historical schedule requests
    private Map<Integer, BaseStringDataMap> m_historicalScheduleRequests = Collections.synchronizedMap(new HashMap<Integer, BaseStringDataMap>());

    public HistoricalScheduleHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/

    /** Method sends historical schedule request to TWS */
    public byte[] handleHistoricalScheduleRequest(String requestStr, byte[] data) {
        HistoricalScheduleRequest request = m_requestParser.parseHistoricalScheduleRequest(requestStr, data);
        System.out.println("Sending historical schedule request: id=" + request.requestId() + " contract=" + Utils.shortContractString(request.contract()));
        BaseStringDataMap dataMap = new BaseStringDataMap(request);
        m_historicalScheduleRequests.put(request.requestId(), dataMap);
        updateHistoricalScheduleRequestStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        clientSocket().reqHistoricalData(request.requestId(), request.contract(), request.endDateTime(), request.durationStr(),
                "1 day", "SCHEDULE", request.useRth(), request.formatDate(), false, null);
        return null;
    }
    
    /** Method handles historical schedule cancel request */
    public byte[] handleHistoricalScheduleCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_HISTORICAL_SCHEDULE);
        System.out.println("Cancelling historical schedule: id=" + request.requestId());
        clientSocket().cancelHistoricalData(request.requestId());
        BaseStringDataMap dataMap = m_historicalScheduleRequests.get(request.requestId());
        if(dataMap != null) {
            updateHistoricalScheduleRequestStatus(request.requestId(), dataMap, DdeRequestStatus.CANCELLED);
            m_historicalScheduleRequests.remove(request.requestId());
        }
        return null;
    }

    /** Method handles historical schedule tick request */
    public String handleHistoricalScheduleTickRequest(String requestStr) {
        String ret = "";
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.HISTORICAL_SCHEDULE_TICK);
        System.out.println("Handling historical schedule tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        BaseStringDataMap dataMap = m_historicalScheduleRequests.get(tickRequest.requestId());
        if (dataMap != null) {
            if (tickRequest.tickType().equals(DdeRequestType.HISTORICAL_SCHEDULE.topic())) {
                if (dataMap.ddeRequestStatus() != DdeRequestStatus.ERROR) {
                    ret = dataMap.getString();
                    updateHistoricalScheduleRequestStatus(tickRequest.requestId(), dataMap, DdeRequestStatus.FINISHED);
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
    /** Method updates historical schedule for requestId */
    public void updateHistoricalSchedule(int requestId, String startDateTime, String endDateTime, String timeZone, List<HistoricalSession> sessions) {
        BaseStringDataMap dataMap = m_historicalScheduleRequests.get(requestId);
        if(dataMap != null) {
            StringBuilder historicalScheduleStr = new StringBuilder();
            historicalScheduleStr.append("Start: ").append(startDateTime).append(", ");
            historicalScheduleStr.append("End: ").append(endDateTime).append(", ");
            historicalScheduleStr.append("Time Zone: ").append(timeZone).append("; ");
            historicalScheduleStr.append("Sessions [ ");
            for (HistoricalSession session : sessions) {
                historicalScheduleStr.append("Start: ").append(session.startDateTime()).append(", ");
                historicalScheduleStr.append("End: ").append(session.endDateTime()).append(", ");
                historicalScheduleStr.append("Ref Date: ").append(session.refDate()).append("; ");
            }
            historicalScheduleStr.append("]");
            dataMap.setString(historicalScheduleStr.toString());
            notifyDde(requestId, DdeRequestType.HISTORICAL_SCHEDULE_TICK.topic(), DdeRequestType.HISTORICAL_SCHEDULE.topic());
        }
    }

    /** Method updates historical schedule request status field for requestId */
    public void updateHistoricalScheduleRequestStatus(int requestId, BaseStringDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.HISTORICAL_SCHEDULE_TICK.topic());
    }

    /** Method updates historical schedule request error field for requestId */
    public void updateHistoricalScheduleRequestError(int requestId, String errorMsgStr) {
        updateRequestError(requestId, errorMsgStr, m_historicalScheduleRequests.get(requestId), DdeRequestType.HISTORICAL_SCHEDULE_TICK.topic());
    }    
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class HistoricalScheduleRequestParser extends RequestParser {

        /** Method parses DDE request string to HistoricalScheduleRequest */
        public HistoricalScheduleRequest parseHistoricalScheduleRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, true, true, false, false, false, true);
            String endDateTime = "";
            String durationStr = "";
            int useRth = 0;
            int formatDate = 0;
            
            if (Utils.isNotNull(table.get(13))) {
                endDateTime = table.get(13);
            }
            if (Utils.isNotNull(table.get(14))) {
                durationStr = table.get(14);
            }
            if (Utils.isNotNull(table.get(15))) {
                useRth = getIntFromString(table.get(15));
            }
            if (Utils.isNotNull(table.get(16))) {
                formatDate = getIntFromString(table.get(16));
            }
            return new HistoricalScheduleRequest(requestId, contract, endDateTime, durationStr, useRth, formatDate, requestStr);
        }
    }
}
