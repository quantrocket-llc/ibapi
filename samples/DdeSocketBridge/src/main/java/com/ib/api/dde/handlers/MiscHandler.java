/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.misc.SmartComponentsRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.data.SmartComponentData;
import com.ib.api.dde.socket2dde.datamap.BaseListDataMap;
import com.ib.api.dde.socket2dde.notifications.DdeNotificationEvent;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;
import com.ib.client.SoftDollarTier;

/** Class handles some minor requests */
public class MiscHandler extends BaseHandler {
    protected String m_accountsList = "";
    protected String m_accountUpdateTime = "";
    protected String m_currentTime = "";
    
    // parser
    private MiscRequestParser m_requestParser = new MiscRequestParser();

    // smart components
    private Map<Integer, BaseListDataMap<SmartComponentData>> m_smartComponentRequests = Collections.synchronizedMap(new HashMap<Integer, BaseListDataMap<SmartComponentData>>());

    // soft dollar tiers
    private Map<Integer, BaseListDataMap<SoftDollarTier>> m_softDollarTiersRequests = Collections.synchronizedMap(new HashMap<Integer, BaseListDataMap<SoftDollarTier>>());
    
    public MiscHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    
    /* *****************************************************************************************************
     *                                          Managed accounts
    /* *****************************************************************************************************/
    /** Method handles managed accounts request */
    public String handleManagedAccountsRequest(String requestStr) {
        System.out.println("Handling managed accounts request.");
        String ret = m_accountsList;
        if (ret.length() >= 255) {
            ret = Utils.LONGVALUE;
        }
        return ret;
    }

    /** Method handles managed accounts long value request */
    public byte[] handleManagedAccountsLongValueRequest(String requestStr) {
        System.out.println("Handling managed accounts long value request.");
        return Utils.longStringValueToByteArray(m_accountsList);
    }
    
    /** Method updates managed accounts */
    public void updateManagedAccounts(String accountsList) {
        m_accountsList = accountsList;
        DdeNotificationEvent oldEvent = RequestParser.createDdeNotificationEvent(DdeRequestType.FAACCTS.topic(), "id1?value");
        twsService().notifyDde(oldEvent);
    }
    
    /* *****************************************************************************************************
     *                                          Account Time
    /* *****************************************************************************************************/
    /** Method resets account time */
    public void resetAccountTime() {
        m_accountUpdateTime = "";
    }
    
    /** Method handles account update time request */
    public String handleAccountUpdateTimeRequest() {
        System.out.println("Handling account update time request.");
        if (Utils.isNull(m_accountUpdateTime)) {
            m_accountUpdateTime = new SimpleDateFormat("HH:mm").format(new Date());
        }
        return m_accountUpdateTime;
    }
    
    /** Method updates account time */
    public void updateAccountTime(String timeStamp) {
        m_accountUpdateTime = timeStamp;
        DdeNotificationEvent event = RequestParser.createDdeNotificationEvent(DdeRequestType.REQ_ACCOUNT_UPDATE_TIME.topic(), RequestParser.ID_ZERO);
        twsService().notifyDde(event);
    }
    
    /* *****************************************************************************************************
     *                                          Current Time
    /* *****************************************************************************************************/
    /** Method handles current time request */
    public String handleCurrentTimeRequest() {
        System.out.println("Handling current time request.");
        if (Utils.isNull(m_currentTime)) {
            clientSocket().reqCurrentTime();
        }
        String ret = m_currentTime;
        m_currentTime = "";
        return ret;
    }
    
    /** Method updates current time */
    public void updateCurrentTime(long currentTime) {
        m_currentTime = new SimpleDateFormat("yyyyMMdd HH:mm:ss").format(new Date(currentTime * 1000));
        DdeNotificationEvent event = RequestParser.createDdeNotificationEvent(DdeRequestType.REQ_CURRENT_TIME.topic(), RequestParser.ID_ZERO);
        twsService().notifyDde(event);
    }
    
    
    /* *****************************************************************************************************
     *                                          Smart Components
    /* *****************************************************************************************************/
    /** Method handles smart components request */
    public String handleSmartComponentsRequest(String requestStr) {
        SmartComponentsRequest request = m_requestParser.parseSmartComponentsRequest(requestStr);
        System.out.println("Handling smart components request: id=" + request.requestId() + " bboExchange=" + request.bboExchange());
        BaseListDataMap<SmartComponentData> dataMap = m_smartComponentRequests.get(request.requestId());
        if (dataMap == null) {
            dataMap = new  BaseListDataMap<SmartComponentData>(request);
            m_smartComponentRequests.put(request.requestId(), dataMap);
        }
        if (dataMap.ddeRequestStatus() == DdeRequestStatus.UNKNOWN) {
            clientSocket().reqSmartComponents(request.requestId(), request.bboExchange());
            dataMap.ddeRequestStatus(DdeRequestStatus.REQUESTED);
        }
        String ret = dataMap.ddeRequestStatus().toString();
        if (dataMap.ddeRequestStatus() == DdeRequestStatus.ERROR) {
            dataMap.ddeRequestStatus(DdeRequestStatus.REQUESTED);
        }
        return ret;
    }

    /** Method handles smart components array request */
    public byte[] handleSmartComponentsArrayRequest(String requestStr) {
        SmartComponentsRequest request = m_requestParser.parseSmartComponentsRequest(requestStr);
        System.out.println("Handling smart components array request: id=" + request.requestId());
        byte[] array = Utils.dataListToByteArray(syncCopySmartComponents(request.requestId()));
        BaseListDataMap<SmartComponentData> dataMap = m_smartComponentRequests.get(request.requestId());
        if (dataMap != null) {
            dataMap.ddeRequestStatus(DdeRequestStatus.FINISHED);
            notifyDde(request.ddeRequestType().topic(), request.ddeRequestString());
            dataMap.clearAllItems();
        }
        return array;
    }
    
    /** Method handles smart components cancel */
    public byte[] handleSmartComponentsCancel(String requestStr) {
        int requestId = m_requestParser.getRequesIdFromString(requestStr);
        System.out.println("Handling smart components cancel: id=" + requestId);
        m_smartComponentRequests.remove(requestId);
        return null;
    }

    /** Method handles smart components error request */
    public String handleSmartComponentsErrorRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_SMART_COMPONENTS_ERROR);
        // error request
        BaseListDataMap<SmartComponentData> dataMap = m_smartComponentRequests.get(request.requestId());
        if (dataMap != null) {
            m_smartComponentRequests.remove(request.requestId());
            return dataMap.error();
        }
        return "";
    }
    
    /** Method updates smart components */
    public void updateSmartComponents(int requestId, Map<Integer, Entry<String, Character>> theMap) {
        BaseListDataMap<SmartComponentData> dataMap = m_smartComponentRequests.get(requestId);
        if (dataMap != null) {
            for (Map.Entry<Integer, Entry<String, Character>> item : theMap.entrySet()) {
                dataMap.addItem(new SmartComponentData(item.getKey(), item.getValue().getKey(), item.getValue().getValue()));
            }
            dataMap.ddeRequestStatus(DdeRequestStatus.RECEIVED);
            notifyDde(DdeRequestType.REQUEST_SMART_COMPONENTS.topic(), dataMap.ddeRequest().ddeRequestString());
        }
    }

    /** Method updates smart components request error */
    public void updateSmartComponentsRequestError(int requestId, String errorMsgStr) {
        updateRequestError(errorMsgStr, m_smartComponentRequests.get(requestId), DdeRequestType.REQUEST_SMART_COMPONENTS.topic());
    }
    
    protected List<SmartComponentData> syncCopySmartComponents(int requestId) {
        synchronized(m_smartComponentRequests) {
            BaseListDataMap<SmartComponentData> dataMap = m_smartComponentRequests.get(requestId);
            return (dataMap != null ? dataMap.syncCopyList() : new ArrayList<SmartComponentData>());
        }
    }

    /* *****************************************************************************************************
     *                                          Soft Dollar Tiers
    /* *****************************************************************************************************/
    /** Method handles soft dollar tiers request */
    public String handleSoftDollarTiersRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_SOFT_DOLLAR_TIERS);
        System.out.println("Handling soft dollar tiers request: id=" + request.requestId());
        BaseListDataMap<SoftDollarTier> dataMap = m_softDollarTiersRequests.get(request.requestId());
        if (dataMap == null) {
            dataMap = new  BaseListDataMap<SoftDollarTier>(request);
            m_softDollarTiersRequests.put(request.requestId(), dataMap);
        }
        if (dataMap.ddeRequestStatus() == DdeRequestStatus.UNKNOWN) {
            clientSocket().reqSoftDollarTiers(request.requestId());
            dataMap.ddeRequestStatus(DdeRequestStatus.REQUESTED);
        }
        return dataMap.ddeRequestStatus().toString();
    }    
    
    /** Method handles soft dollar tiers array request */
    public byte[] handleSoftDollarTiersArrayRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_SOFT_DOLLAR_TIERS);
        System.out.println("Handling soft dollar tiers array request: id=" + request.requestId());
        byte[] array = Utils.dataListToByteArray(syncCopySoftDollarTiers(request.requestId()));
        BaseListDataMap<SoftDollarTier> dataMap = m_softDollarTiersRequests.get(request.requestId());
        if (dataMap != null) {
            dataMap.ddeRequestStatus(DdeRequestStatus.FINISHED);
            notifyDde(DdeRequestType.REQUEST_SOFT_DOLLAR_TIERS.topic(), dataMap.ddeRequest().ddeRequestString());
            dataMap.clearAllItems();
        }
        return array;
    }
    
    /** Method handles soft dollar tiers cancel */
    public byte[] handleSoftDollarTiersCancel(String requestStr) {
        int requestId = m_requestParser.getRequesIdFromString(requestStr);
        System.out.println("Handling soft dollar tiers cancel: id=" + requestId);
        m_softDollarTiersRequests.remove(requestId);
        return null;
    }
    
    /** Method updates soft dollar tiers */
    public void updateSoftDollarTiers(int requestId,  SoftDollarTier[] tiers) {
        BaseListDataMap<SoftDollarTier> dataMap = m_softDollarTiersRequests.get(requestId);
        if (dataMap != null) {
            dataMap.addAllItems(Arrays.asList(tiers));
            dataMap.ddeRequestStatus(DdeRequestStatus.RECEIVED);
            notifyDde(DdeRequestType.REQUEST_SOFT_DOLLAR_TIERS.topic(), dataMap.ddeRequest().ddeRequestString());
        }
    }
    
    protected List<SoftDollarTier> syncCopySoftDollarTiers(int requestId) {
        synchronized(m_softDollarTiersRequests) {
            BaseListDataMap<SoftDollarTier> dataMap = m_softDollarTiersRequests.get(requestId);
            return (dataMap != null ? dataMap.syncCopyList() : new ArrayList<SoftDollarTier>());
        }
    }
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests 
     * and TWS responses to DDE notifications */
    private class MiscRequestParser extends RequestParser {

        /** Method parses DDE request string to SmartComponentsRequest */
        private SmartComponentsRequest parseSmartComponentsRequest(String requestStr) {
            int requestId = -1;
            String bboExchange = "";
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            if (requestTokens.length > 1) {
                bboExchange = requestTokens[1];
            }
            return new SmartComponentsRequest(requestId, bboExchange, requestStr);
       }
    }    
}
