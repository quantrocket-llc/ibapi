/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers.base;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.socket2dde.datamap.BaseDataMap;
import com.ib.api.dde.socket2dde.datamap.BaseListDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;

/** Class handles base list data requests, data and messages */
abstract public class BaseListDataHandler<T> extends BaseHandler {

    // requests
    protected Map<Integer, BaseListDataMap<T>> m_requests = Collections.synchronizedMap(new HashMap<Integer, BaseListDataMap<T>>());
    
    public BaseListDataHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles base request */
    public byte[] handleBaseRequest(DdeRequest request) {
        BaseListDataMap<T> dataMap = new BaseListDataMap<T>(request);
        m_requests.put(request.requestId(), dataMap);
        updateRequestStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        return null;
    }

    /** Method handles  base cancel */
    public byte[] handleBaseCancel(DdeRequest request) {
        BaseListDataMap<T> dataMap = m_requests.get(request.requestId());
        if(dataMap != null) {
            updateRequestStatus(request.requestId(), dataMap, DdeRequestStatus.CANCELLED);
            m_requests.remove(request.requestId());
        }
        return null;
    }

    /** Method handles  base tick request */
    public String handleBaseTickRequest(TickRequest tickRequest) {
        BaseListDataMap<T> dataMap = m_requests.get(tickRequest.requestId());
        return handleTickRequest(tickRequest, dataMap);
    }
    
    /** Method handles base array request */
    public byte[] handleBaseArrayRequest(DdeRequest request) {
        BaseListDataMap<T> dataMap = m_requests.get(request.requestId());
        byte[] array = null;
        if (dataMap != null) {
            array = Utils.dataListToByteArray(syncCopyList(request.requestId()));
          
            dataMap.clearAllItems();
            updateRequestStatus(request.requestId(), dataMap, DdeRequestStatus.FINISHED);
        }
        return array;        
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates data for requestId */
    public void updateData(int requestId, T data) {
        BaseListDataMap<T> dataMap = m_requests.get(requestId);
        if(dataMap != null) {
            dataMap.addItem(data);
        }
    }

    /** Method updates all data for requestId */
    public void updateAllData(int requestId, List<T> allData) {
        BaseListDataMap<T> dataMap = m_requests.get(requestId);
        if(dataMap != null) {
            dataMap.addAllItems(allData);
        }
    }
    
    /** Method updates data end for requestId */
    public void updateDataEnd(int requestId, String topic) {
        updateDataEnd(requestId, m_requests.get(requestId), topic);
    }
    
    /** Method updates request status field for requestId */
    public abstract void updateRequestStatus(int requestId, BaseDataMap dataMap, DdeRequestStatus status);
    
    /** Method updates request error field for requestId */
    public void updateDataRequestError(int requestId, String errorMsgStr, String topic) {
        updateRequestError(requestId, errorMsgStr, m_requests.get(requestId), topic);
    }

    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    private List<T> syncCopyList(int requestId) {
        synchronized(m_requests) {
            BaseListDataMap<T> dataMap = m_requests.get(requestId);
            return (dataMap != null ? dataMap.syncCopyList() : new ArrayList<T>());
        }
    }
}
