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
import com.ib.api.dde.dde2socket.requests.historicaldata.HistoricalDataRequest;
import com.ib.api.dde.socket2dde.datamap.HistoricalDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Bar;
import com.ib.client.EClientSocket;

/** Class handles base historical data related requests, data and messages */
public abstract class HistoricalDataBaseHandler extends BaseHandler {

    // historical data requests
    protected Map<Integer, HistoricalDataMap> m_historicalDataRequests = Collections.synchronizedMap(new HashMap<Integer, HistoricalDataMap>());

    public HistoricalDataBaseHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles historical data request */
    public byte[] handleHistoricalDataBaseRequest(DdeRequest request) {
        HistoricalDataMap dataMap = new HistoricalDataMap(request);
        m_historicalDataRequests.put(request.requestId(), dataMap);
        updateHistoricalDataRequestStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        return null;
    }

    /** Method handles historical data cancel request */
    public byte[] handleHistoricalDataBaseCancel(DdeRequest request) {
        HistoricalDataMap dataMap = m_historicalDataRequests.get(request.requestId());
        if(dataMap != null) {
            switch(request.ddeRequestType()){
                case CANCEL_HISTORICAL_DATA:
                    // send cancelHistoricalData
                    clientSocket().cancelHistoricalData(request.requestId());
                    break;
                case CANCEL_REAL_TIME_BARS:
                    // send cancelRealTimeBars
                    clientSocket().cancelRealTimeBars(request.requestId());
                    break;
                default:
                    break;
            }
            updateHistoricalDataRequestStatus(request.requestId(), dataMap, DdeRequestStatus.CANCELLED);
            m_historicalDataRequests.remove(request.requestId());
        }
        return null;
    }

    /** Method handles historical data tick request */
    public String handleHistoricalDataTickBaseRequest(TickRequest tickRequest) {
        HistoricalDataMap dataMap = m_historicalDataRequests.get(tickRequest.requestId());
        return handleTickRequest(tickRequest, dataMap);
    }
    
    /** Method handles historical data array request */
    public byte[] handleHistoricalDataArrayBaseRequest(DdeRequest request) {
        HistoricalDataMap dataMap = m_historicalDataRequests.get(request.requestId());
        byte[] array = null;
        if (dataMap != null) {
            int requestId = request.requestId();
            array = Utils.dataListToByteArray(syncCopyHistoricalData(requestId));
          
            DdeRequestStatus status = DdeRequestStatus.SUBSCRIBED;
            if (dataMap.ddeRequest() instanceof HistoricalDataRequest) {
                HistoricalDataRequest histRequest = (HistoricalDataRequest)dataMap.ddeRequest();
                dataMap.clearAllItems();
                status = histRequest.keepUpToDate() ? DdeRequestStatus.SUBSCRIBED : DdeRequestStatus.FINISHED;
            }
            updateHistoricalDataRequestStatus(request.requestId(), dataMap, status);
        }
        return array;
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates historical data for requestId */
    public void updateHistoricalData(int requestId, Bar bar) {
        HistoricalDataMap dataMap = m_historicalDataRequests.get(requestId);
        if(dataMap != null) {
            dataMap.addItem(bar);
        }
    }

    /** Method updates historical data end for requestId */
    public void updateHistoricalDataEnd(int requestId, String topic) {
        HistoricalDataMap dataMap = m_historicalDataRequests.get(requestId);
        if (dataMap != null) {
            if (dataMap.ddeRequest() instanceof HistoricalDataRequest) {
                HistoricalDataRequest request = (HistoricalDataRequest)dataMap.ddeRequest(); 
                if (request.keepUpToDate()) {
                    dataMap.initLiveBar();
                }
            }
        }
        updateDataEnd(requestId, m_historicalDataRequests.get(requestId), topic);
    }
    
    public abstract void updateHistoricalDataRequestStatus(int requestId, HistoricalDataMap dataMap, DdeRequestStatus status);

    /** Method updates historical data request error field for requestId */
    public void updateHistoricalDataRequestError(int requestId, String errorMsgStr, String topic) {
        updateRequestError(requestId, errorMsgStr, m_historicalDataRequests.get(requestId), topic);
    }
    
    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    private List<Bar> syncCopyHistoricalData(int requestId) {
        synchronized(m_historicalDataRequests) {
            HistoricalDataMap dataMap = m_historicalDataRequests.get(requestId);
            return (dataMap != null ? dataMap.syncCopyList() : new ArrayList<Bar>());
        }
    }
}
