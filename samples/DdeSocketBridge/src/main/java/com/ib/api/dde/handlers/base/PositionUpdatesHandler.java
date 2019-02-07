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
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.dde2socket.requests.positions.PositionsMultiRequest;
import com.ib.api.dde.socket2dde.data.PositionData;
import com.ib.api.dde.socket2dde.datamap.BaseMapDataMap;
import com.ib.api.dde.utils.PositionsUtils.PositionKey;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;

/** Base class for position update related requests and data */
public abstract class PositionUpdatesHandler extends BaseHandler {
    // parser
    protected RequestParser m_requestParser = new RequestParser();
    
    // positions
    protected Map<Integer, BaseMapDataMap<PositionKey, PositionData>> m_positionsDataMap = Collections.synchronizedMap(new HashMap<Integer, BaseMapDataMap<PositionKey, PositionData>>());

    public PositionUpdatesHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles positions request */
    public String handlePositionsRequest(DdeRequest request) {
        String ret = "";
        BaseMapDataMap<PositionKey, PositionData> positionDataMap = m_positionsDataMap.get(request.requestId());
        if (positionDataMap == null) {
            positionDataMap = new BaseMapDataMap<PositionKey, PositionData>(request);
            m_positionsDataMap.put(request.requestId(), positionDataMap);
        }
        if (positionDataMap.ddeRequestStatus() == DdeRequestStatus.UNKNOWN) {
            switch(request.ddeRequestType()){
                case REQ_POSITIONS:
                    // send reqPositions request
                    clientSocket().reqPositions();
                    break;
                case REQ_POSITIONS_MULTI:
                    // send reqPositionsMulti request
                    PositionsMultiRequest positionMultiRequest = (PositionsMultiRequest)request;
                    clientSocket().reqPositionsMulti(positionMultiRequest.requestId(), 
                            positionMultiRequest.account(), positionMultiRequest.modelCode());
                    break;
                default:
                    break;
            }
            positionDataMap.ddeRequestStatus(DdeRequestStatus.REQUESTED);
        }

        ret = positionDataMap.ddeRequestStatus().toString();

        if (positionDataMap.ddeRequestStatus() == DdeRequestStatus.ERROR) {
            positionDataMap.ddeRequestStatus(DdeRequestStatus.UNKNOWN);
        }
        return ret;
    }
    
    /** Method handles cancel positions */
    public byte[] handlePositionsCancel(DdeRequest request) {
        switch(request.ddeRequestType()){
            case CANCEL_POSITIONS:
                clientSocket().cancelPositions();
                break;
            case CANCEL_POSITIONS_MULTI:
                clientSocket().cancelPositionsMulti(request.requestId());
                break;
            default:
                break;
        }
        m_positionsDataMap.remove(request.requestId());
        return null;
    }
    
    /** Method handles positions array request */
    public byte[] handlePositionsArrayRequest(DdeRequest request) {
        int requestId = request.requestId();
        byte[] array = Utils.dataListToByteArray(syncCopyPositionDataValues(requestId), true, request.ddeRequestType());
        BaseMapDataMap<PositionKey, PositionData> positionDataMap = m_positionsDataMap.get(requestId);
        if (positionDataMap != null) {
            positionDataMap.ddeRequestStatus(DdeRequestStatus.SUBSCRIBED);
            notifyDde(request.ddeRequestType().topic(), request.ddeRequestString());
            positionDataMap.clearDataMap();
        }
        return array;
    }
    
    /** Method handles positions error request */
    public String handlePositionsErrorRequest(String requestStr, DdeRequestType ddeRequestType) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, ddeRequestType);
        System.out.println("Handling positions error request: id=" + request.requestId());
        // error request
        BaseMapDataMap<PositionKey, PositionData> positionDataMap = m_positionsDataMap.get(request.requestId());
        if (positionDataMap != null) {
            m_positionsDataMap.remove(request.requestId());
            return positionDataMap.error();
        }
        return "";
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates position data */
    public void updatePositionData(PositionData positionData, String topic) {
        BaseMapDataMap<PositionKey, PositionData> positionDataMap = m_positionsDataMap.get(positionData.requestId());
        if (positionDataMap != null) {
            PositionKey key = new PositionKey(positionData.contract().conid(), positionData.account(), positionData.modelCode());
            positionDataMap.addData(key, positionData);
            if (positionDataMap.ddeRequestStatus() == DdeRequestStatus.SUBSCRIBED) {
                positionDataMap.ddeRequestStatus(DdeRequestStatus.RECEIVED);
                notifyDde(topic, positionDataMap.ddeRequest().ddeRequestString());
            }
        }
    }

    /** Method updates position end marker */
    public void updatePositionDataEnd(int requestId, DdeRequestType ddeRequestType) {
        updateDataEnd(m_positionsDataMap.get(requestId), ddeRequestType.topic());
    }

    /** Method handles errors during positions request */
    public void updatePositionError(int requestId, String errorMsgStr, String topic) {
        updateRequestError(errorMsgStr, m_positionsDataMap.get(requestId), topic);
    }

    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    protected List<PositionData> syncCopyPositionDataValues(int requestId) {
        synchronized(m_positionsDataMap) {
            BaseMapDataMap<PositionKey, PositionData> positionDataMap = m_positionsDataMap.get(requestId);
            return (positionDataMap != null ? positionDataMap.syncCopyMapValues() : new ArrayList<PositionData>());
        }
    }
}
