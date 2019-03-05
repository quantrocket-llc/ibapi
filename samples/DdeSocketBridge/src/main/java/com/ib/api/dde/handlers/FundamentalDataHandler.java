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
import com.ib.api.dde.dde2socket.requests.fundamentaldata.FundamentalDataRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.datamap.BaseStringDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;

/** Class handles fundamental data related requests, data and messages */
public class FundamentalDataHandler extends BaseHandler {
    // parser
    private FundamentalDataRequestParser m_requestParser = new FundamentalDataRequestParser();

    // fundamental data requests
    private Map<Integer, BaseStringDataMap> m_fundamentalDataRequests = Collections.synchronizedMap(new HashMap<Integer, BaseStringDataMap>());

    public FundamentalDataHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends fundamental data request to TWS */
    public byte[] handleFundamentalDataRequest(String requestStr, byte[] data) {
        FundamentalDataRequest request = m_requestParser.parseFundamentalDataRequest(requestStr, data);
        System.out.println("Sending fundamental data request: id=" + request.requestId() + " contract=" + Utils.shortContractString(request.contract()));
        clientSocket().reqFundamentalData(request.requestId(), request.contract(), request.reportType(), null);
        BaseStringDataMap dataMap = new BaseStringDataMap(request);
        m_fundamentalDataRequests.put(request.requestId(), dataMap);
        updateRequestStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        return null;
    }

    /** Method handles fundamental data cancel request */
    public byte[] handleFundamentalDataCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_FUNDAMENTAL_DATA);
        BaseStringDataMap dataMap = m_fundamentalDataRequests.get(request.requestId());
        if(dataMap != null) {
            System.out.println("Cancelling fundamental data: id=" + request.requestId());
            clientSocket().cancelFundamentalData(request.requestId());
            updateRequestStatus(request.requestId(), dataMap, DdeRequestStatus.CANCELLED);
            m_fundamentalDataRequests.remove(request.requestId());
        }
        return null;
    }

    /** Method handles fundamental data tick request */
    public String handleFundamentalDataTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.FUNDAMENTAL_DATA_TICK);
        System.out.println("Handling fundamental data tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        BaseStringDataMap dataMap = m_fundamentalDataRequests.get(tickRequest.requestId());
        return handleTickRequest(tickRequest, dataMap);
    }
    
    /** Method handles fundamental data array request */
    public byte[] handleFundamentalDataArrayRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_FUNDAMENTAL_DATA);
        System.out.println("Handling fundamental data array request: id=" + request.requestId());
        BaseStringDataMap dataMap = m_fundamentalDataRequests.get(request.requestId());
        byte[] array = null;
        if (dataMap != null) {
            array = Utils.xmlToByteArray(dataMap.getString());
            updateRequestStatus(request.requestId(), dataMap, DdeRequestStatus.FINISHED);
        }
        return array;
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates fundamental data for requestId */
    public void updateFundamentalData(int requestId, String fundamentalData) {
        BaseStringDataMap dataMap = m_fundamentalDataRequests.get(requestId);
        if(dataMap != null) {
            dataMap.setString(fundamentalData);
        }
        updateDataEnd(requestId, m_fundamentalDataRequests.get(requestId), DdeRequestType.FUNDAMENTAL_DATA_TICK.topic());
    }

    /** Method updates fundamental data request status tick/field for requestId */
    protected void updateRequestStatus(int requestId, BaseStringDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.FUNDAMENTAL_DATA_TICK.topic());
    }

    /** Method updates fundamental data request error tick/field for requestId */
    public void updateFundamentalDataRequestError(int requestId, String errorMsgStr) {
        updateRequestError(requestId, errorMsgStr, m_fundamentalDataRequests.get(requestId), DdeRequestType.FUNDAMENTAL_DATA_TICK.topic());
    }
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class FundamentalDataRequestParser extends RequestParser {

        /** Method parses DDE request string to FundamentalDataRequest */
        public FundamentalDataRequest parseFundamentalDataRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseShortContract(table);
            String reportType = "";
            if (table.size() < 8) {
                System.out.println("Cannot extract fundamental data report type");
                return null;
            }
            if (Utils.isNotNull(table.get(7))) {
                reportType = table.get(7);
            }
            return new FundamentalDataRequest(requestId, contract, reportType, requestStr);
        }
    }
}
