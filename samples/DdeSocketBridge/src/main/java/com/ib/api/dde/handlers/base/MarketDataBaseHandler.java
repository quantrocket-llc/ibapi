/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers.base;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.socket2dde.datamap.MarketDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;

/** Class handles market data related requests, data and messages */
public abstract class MarketDataBaseHandler extends BaseHandler {
    // market data requests
    protected Map<Integer, MarketDataMap> m_marketDataRequests = Collections.synchronizedMap(new HashMap<Integer, MarketDataMap>());

    public MarketDataBaseHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles market data base request */
    public byte[] handleMarketDataBaseRequest(DdeRequest request) {
        MarketDataMap marketDataMap = new MarketDataMap(request);
        m_marketDataRequests.put(request.requestId(), marketDataMap);
        updateMarketDataStatus(request.requestId(), marketDataMap, DdeRequestStatus.REQUESTED);
        return null;
    }

    /** Method handles long value base request */
    public byte[] handleTickLongValueBaseRequest(TickRequest tickRequest) {
        System.out.println("Handling tick long value request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        MarketDataMap tickData = m_marketDataRequests.get(tickRequest.requestId());
        byte[] bytes = null;
        if(tickData != null) {
            String tickType = tickRequest.tickType();
            Object value = tickData.getValue(tickType);
            if(value != null) {
                bytes = Utils.longStringValueToByteArray(value.toString());
            }
        }
        return bytes;
    }
    
    /** Method handles market data base cancel */
    public byte[] handleMktDataBaseCancel(DdeRequest request) {
        MarketDataMap data = m_marketDataRequests.get(request.requestId());
        if(data != null) {
            updateMarketDataStatus(request.requestId(), data, DdeRequestStatus.CANCELLED);
            m_marketDataRequests.remove(request.requestId());
        }
        return null;
    }

    /** Method handles tick base request */
    public String handleTickBaseRequest(TickRequest tickRequest) {
        MarketDataMap dataMap = m_marketDataRequests.get(tickRequest.requestId());
        return handleTickRequest(tickRequest, dataMap);
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates market data for requestId */
    public void updateMarketData(int requestId, String topic, String fieldStr, Object value, DdeRequestStatus status) {
        MarketDataMap data = m_marketDataRequests.get(requestId);
        if(data != null) {
            data.setValue(fieldStr, value);
            updateMarketDataStatus(requestId, data, status);
            notifyDde(requestId, topic, fieldStr);
        }
    }

    /** Method updates market data status field */
    abstract protected void updateMarketDataStatus(int requestId, MarketDataMap dataMap, DdeRequestStatus status);
    
    /** Method updates market data error field for requestId */
    public void updateMarketDataError(int requestId, String errorMsgStr, String topic) {
        updateRequestError(requestId, errorMsgStr, m_marketDataRequests.get(requestId), topic);
    }
}
