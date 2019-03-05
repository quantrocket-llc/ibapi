/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.handlers;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.ErrorsHandler;
import com.ib.api.dde.socket2dde.data.ErrorData;

/** Class handles error data and messages */
public class OldErrorsHandler extends ErrorsHandler {
    private OldErrorRequestParser m_requestParser = new OldErrorRequestParser();
    
    // error data
    private ErrorData m_errorData;
    private boolean m_hasErrorRequest = false;
    
    public OldErrorsHandler(TwsService twsService) {
        super(twsService);
    }
    
    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles error request */
    @Override
    public String handleErrorRequest(String requestStr) {
        System.out.println("Handling error request: " + requestStr);
        m_hasErrorRequest = true;
        DdeRequestType requestType = m_requestParser.parseErrorRequest(requestStr);
        String ret = "";
        if (m_errorData != null) {
            switch (requestType){
                case ERR_ID:
                    ret = String.valueOf(m_errorData.requesId());
                    break;
                case ERR_CODE:
                    ret = String.valueOf(m_errorData.errorCode());
                    break;
                case ERR_MSG:
                    ret = m_errorData.errorMessage();
                    break;
                default:
                    break;
            }
        }
        return ret;
    }    
    
    /** Method stops error advise loop */
    public void handleErrorStopAdvise(String requestStr) {
        System.out.println("Handling error stop advise: " + requestStr);
        m_hasErrorRequest = false;
    }
 
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method saves error data */
    public void updateErrorData(ErrorData errorData) {
        m_errorData = errorData;

        // notification
        if (m_hasErrorRequest) {
            notifyDde(DdeRequestType.ERR.topic(), DdeRequestType.ERR_ID.topic());
            notifyDde(DdeRequestType.ERR.topic(), DdeRequestType.ERR_CODE.topic());
            notifyDde(DdeRequestType.ERR.topic(), DdeRequestType.ERR_MSG.topic());
        }
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests 
     * and TWS responses to DDE notifications */
    private class OldErrorRequestParser extends RequestParser {

        /** Method parses DDE request string to DdeRequestType */
        private DdeRequestType parseErrorRequest(String requestStr) {
            String[] requestTokens = requestStr.split(RequestParser.DDE_REQUEST_SEPARATOR_PARSE);
            DdeRequestType requestType = DdeRequestType.NOTHING;
            if (requestTokens.length > 0) {
                requestType = DdeRequestType.getRequestType(requestTokens[0]);
            }
            return requestType;
        }
    }
}
