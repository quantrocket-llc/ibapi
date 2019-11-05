/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers.base;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.socket2dde.datamap.BaseDataMap;
import com.ib.api.dde.socket2dde.notifications.DdeNotificationEvent;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;
import com.ib.client.TickType;

/** Class contains common methods and data for handlers */
public abstract class BaseHandler {

    private final EClientSocket m_clientSocket;
    private final TwsService m_twsService;

    public BaseHandler(EClientSocket clientSocket, TwsService twsService) {
        m_clientSocket = clientSocket;
        m_twsService = twsService;
    }
    
    protected EClientSocket clientSocket() {
        return m_clientSocket;
    }

    protected TwsService twsService() {
        return m_twsService;
    }
    
    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles tick request */
    public String handleTickRequest(TickRequest tickRequest, BaseDataMap dataMap) {
        String ret = " ";
        if(dataMap != null) {
            String tickType = tickRequest.tickType();
            if (tickType.equals(DdeRequestType.ERROR.topic())) {
                ret = dataMap.error();
            } else if (tickType.equals(DdeRequestType.STATUS.topic())) {
                ret = dataMap.ddeRequestStatus().toString();
            } else {
                Object value = dataMap.getValue(tickType);
                if(value != null) {
                    if (tickType.equals(TickType.FUNDAMENTAL_RATIOS.field()) && value.toString().length() >= 255) {
                        ret = Utils.LONGVALUE;
                    } else {
                        ret = String.valueOf(value);
                    }
                }
            }
        }
        return ret;
    }
    
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates data end and status tick/field for requestId */
    public void updateDataEnd(int requestId, BaseDataMap dataMap, String topic) {
        if(dataMap != null) {
            updateRequestStatus(requestId, dataMap, DdeRequestStatus.RECEIVED, topic);
        }
    }

    /** Method updates data end */
    public void updateDataEnd(BaseDataMap dataMap, String topic) {
        if (dataMap != null) {
            updateRequestStatus(dataMap, DdeRequestStatus.RECEIVED, topic);
        }
    }

    /** Method updates request status */
    protected void updateRequestStatus(BaseDataMap dataMap, DdeRequestStatus status, String topic) {
        if (dataMap.ddeRequestStatus() != status) {
            dataMap.ddeRequestStatus(status);
            notifyDde(topic, dataMap.ddeRequest().ddeRequestString());
        }
    }

    /** Method updates request status for requestId */
    protected void updateRequestStatus(int requestId, BaseDataMap dataMap, DdeRequestStatus status, String topic) {
        if (dataMap.ddeRequestStatus() != status) {
            dataMap.ddeRequestStatus(status);
            notifyDde(requestId, topic, DdeRequestType.STATUS.topic());
        }
    }
    
    /** Method updates request error for requestId */
    public void updateRequestError(int requestId, String errorMsgStr, BaseDataMap dataMap, String topic) {
        if(dataMap != null) {
            dataMap.error(errorMsgStr);
            updateRequestStatus(requestId, dataMap, DdeRequestStatus.ERROR, topic);
            notifyDde(requestId, topic, DdeRequestType.ERROR.topic());
        }
    }
    
    /** Method updates request error */
    public void updateRequestError(String errorMsgStr, BaseDataMap dataMap, String topic) {
        if (dataMap != null) {
            dataMap.error(errorMsgStr);
            updateRequestStatus(dataMap, DdeRequestStatus.ERROR, topic);
        }
    }
    
    
    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
   /** Method sends notification to DDE */
    protected void notifyDde(int requestId, String topic, String field) {
        DdeNotificationEvent event = RequestParser.createDdeNotificationEvent(requestId, topic, field);
        m_twsService.notifyDde(event);
    }
    
    /** Method sends notification to DDE */
    protected void notifyDde(String topic, String requestStr) {
        DdeNotificationEvent event = RequestParser.createDdeNotificationEvent(topic, requestStr);
        m_twsService.notifyDde(event);
    }
}
