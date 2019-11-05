/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;
import java.util.List;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.error.ErrorRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.data.ErrorData;
import com.ib.api.dde.utils.Utils;

/** Class handles error data and messages */
public class ErrorsHandler extends BaseHandler {
    private ErrorRequestParser m_requestParser = new ErrorRequestParser();
    
    // error data
    private ErrorRequest m_errorRequest; // original DDE request
    private List<ErrorData> m_errorDataList = new ArrayList<ErrorData>();
    
    public ErrorsHandler(TwsService twsService) {
        super(null, twsService);
    }
    
    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles errors array request */
    public byte[] handleErrorsArrayRequest(String requestStr) {
        ErrorRequest errorRequest = m_requestParser.parseErrorRequest(requestStr);
        System.out.println("Handling errors array request: id=" + errorRequest.requestId() + " type=" + errorRequest.ddeRequestType().topic());

        int errorsCount = ((ErrorRequest)errorRequest).errorsCount();
        if (errorsCount >= m_errorDataList.size()){
            return null;
        }
        return errorDataListToByteArray(syncCopyErrorDataList(), errorsCount);
    }

    /** Method handles error request */
    public String handleErrorRequest(String requestStr) {
        m_errorRequest = m_requestParser.parseErrorRequest(requestStr);
        System.out.println("Handling error request: id=" + m_errorRequest.requestId() + " type=" + m_errorRequest.ddeRequestType().topic());
        return DdeRequestStatus.SUBSCRIBED.toString();
    }
 
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method saves error data */
    public void addErrorData(ErrorData errorData) {
        m_errorDataList.add(errorData);
        if (m_errorRequest != null) {
            notifyDde(DdeRequestType.REQUEST_ERRORS.topic(), m_errorRequest.ddeRequestString());
        }
    }
    
    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    private List<ErrorData> syncCopyErrorDataList() {
        synchronized(m_errorDataList) {
            return new ArrayList<ErrorData>(m_errorDataList);
        }
    }
    
    /** Method converts error data list to byte array*/
    private static byte[] errorDataListToByteArray(List<ErrorData> errorDataList, int errorsCount) {
        ArrayList<ArrayList<String>> list = new ArrayList<ArrayList<String>>();
    
        for (int i = errorsCount; i < errorDataList.size(); i++) {
            ErrorData msg = errorDataList.get(i);
            ArrayList<String> item = new ArrayList<String>();
            item.add(String.valueOf(msg.requesId()));
            item.add(String.valueOf(msg.errorCode()));
            // split long error message into substrings with length = 255, then merge these substrings in Excel
            item.addAll(Utils.chunkStringByLength(msg.errorMessage(), 255));
            list.add(new ArrayList<String>(item));
            item.clear();
        }
        
        byte[] bytes = list.size() > 0 ? Utils.convertTableToByteArray(list) : null;
        
        return bytes;
    }
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests 
     * and TWS responses to DDE notifications */
    private class ErrorRequestParser extends RequestParser {

        /** Method parses DDE request string to ErrorRequest */
        private ErrorRequest parseErrorRequest(String requestStr) {
            int requestId = -1;
            int errorIndex = 0;
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            requestId = parseRequestId(requestTokens[0]);
            if (requestTokens.length > 1 && !requestTokens[1].equals(DdeRequestType.ERROR.topic())) {    
                errorIndex = Integer.parseInt(requestTokens[1]);
            }
            return new ErrorRequest(requestId, errorIndex, requestStr);
        }
    }
}
