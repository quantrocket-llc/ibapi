/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
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
import com.ib.api.dde.dde2socket.requests.marketscanner.ScannerSubscriptionRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.data.ScannerData;
import com.ib.api.dde.socket2dde.datamap.BaseDataMap;
import com.ib.api.dde.socket2dde.datamap.BaseMapDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;
import com.ib.client.ScannerSubscription;
import com.ib.client.TagValue;

/** Class handles scanner subscription related requests, data and messages */
public class ScannerDataHandler extends BaseHandler {
    // parser
    private ScannerSubscriptionParser m_requestParser = new ScannerSubscriptionParser();

    // scanner subscription requests
    protected Map<Integer, BaseMapDataMap<Integer, ScannerData>> m_scannerSubscriptionRequests = Collections.synchronizedMap(new HashMap<Integer, BaseMapDataMap<Integer, ScannerData>>());
    private String m_scannerParameters = "";
    private DdeRequestStatus m_scannerParametersRequestStatus = DdeRequestStatus.UNKNOWN;

    public ScannerDataHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    
    /** Method sends scanner parameters request to TWS */
    public String handleScannerParametersRequest(String requestStr) {
        if (m_scannerParametersRequestStatus == DdeRequestStatus.UNKNOWN) {
            DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_SCANNER_PARAMETERS);
            System.out.println("Sending scanner parameters request: id=" + request.requestId());
            clientSocket().reqScannerParameters();
            m_scannerParametersRequestStatus = DdeRequestStatus.REQUESTED;
        }
        return m_scannerParametersRequestStatus.toString();
    }
    
    /** Method sends scanner subscription request to TWS */
    public byte[] handleScannerSubscriptionRequest(String requestStr, byte[] data) {
        ScannerSubscriptionRequest request = m_requestParser.parseScannerSubscriptionRequest(requestStr, data);
        System.out.println("Sending scanner subscription request: id=" + request.requestId() + " scanCode=" + request.scannerSubscription().scanCode());
        clientSocket().reqScannerSubscription(request.requestId(), request.scannerSubscription(), null, request.scannerSubscriptionFilterOptions());

        BaseMapDataMap<Integer, ScannerData> dataMap = new BaseMapDataMap<Integer, ScannerData>(request);
        m_scannerSubscriptionRequests.put(request.requestId(), dataMap);
        updateScannerSubscriptionStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        return null;
    }

    /** Method sends scanner subscription cancel to TWS */
    public byte[] handleScannerSubscriptionCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_SCANNER_SUBSCRIPTION);
        System.out.println("Sending scanner subscription cancel: id=" + request.requestId());
        BaseMapDataMap<Integer, ScannerData> dataMap = m_scannerSubscriptionRequests.get(request.requestId());
        if(dataMap != null) {
            clientSocket().cancelScannerSubscription(request.requestId());
            updateScannerSubscriptionStatus(request.requestId(), dataMap, DdeRequestStatus.CANCELLED);
            m_scannerSubscriptionRequests.remove(request.requestId());
        }
        return null;
    }

    /** Method handles scanner subscription tick request */
    public String handleScannerSubscriptionTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.SCANNER_SUBSCRIPTION_TICK);
        System.out.println("Handling scanner subscrption tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        BaseMapDataMap<Integer, ScannerData> dataMap = m_scannerSubscriptionRequests.get(tickRequest.requestId());
        return handleTickRequest(tickRequest, dataMap);
    }
    
    /** Method handles scanner data array request */
    public byte[] handleScannerDataArrayRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_SCANNER_SUBSCRIPTION);
        System.out.println("Handling scanner data array request: id=" + request.requestId());
        int requestId = request.requestId();
        
        byte[] array = Utils.dataListToByteArray(syncCopyScannerDataValues(requestId));

        BaseMapDataMap<Integer, ScannerData> dataMap = m_scannerSubscriptionRequests.get(requestId);
        if (dataMap != null) {
            updateScannerSubscriptionStatus(requestId, dataMap, DdeRequestStatus.SUBSCRIBED);
            dataMap.clearDataMap();
        }
        return array;
    }

    /** Method handles scanner parameters array request */
    public byte[] handleScannerParametersArrayRequest(String requestStr) {
        System.out.println("Handling scanner parameters array request");
        byte[] array = Utils.xmlToByteArray(m_scannerParameters);
        m_scannerParametersRequestStatus = DdeRequestStatus.FINISHED;
        notifyDde(DdeRequestType.REQUEST_SCANNER_PARAMETERS.topic(), RequestParser.ID_ZERO);
        return array;
    }
    
    /** Method stops scanner parameters advise loop */
    public void handleScannerParametersCancel(String requestStr) {
        System.out.println("Handling scanner parameters cancel: " + requestStr);
        m_scannerParametersRequestStatus = DdeRequestStatus.UNKNOWN;
    }
    
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates scanner data for requestId */
    public void updateScannerData(int requestId, ScannerData scannerData) {
        BaseMapDataMap<Integer, ScannerData> dataMap = m_scannerSubscriptionRequests.get(requestId);
        if(dataMap != null) {
            dataMap.addData(scannerData.rank(), scannerData);
        }
    }

    /** Method updates scanner data end for requestId */
    public void updateScannerDataEnd(int requestId) {
        updateDataEnd(requestId, m_scannerSubscriptionRequests.get(requestId), DdeRequestType.SCANNER_SUBSCRIPTION_TICK.topic());
    }

    /** Method updates scanner subscription status field for requestId */
    protected void updateScannerSubscriptionStatus(int requestId, BaseDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.SCANNER_SUBSCRIPTION_TICK.topic());
    }

    /** Method updates scanner subscription error field for requestId */
    public void updateScannerSubscriptionError(int requestId, String errorMsgStr) {
        updateRequestError(requestId, errorMsgStr, m_scannerSubscriptionRequests.get(requestId), DdeRequestType.SCANNER_SUBSCRIPTION_TICK.topic());
    }

    /** Method updates scanner parameters */
    public void updateScannerParameters(String xml) {
        m_scannerParameters = xml;
        m_scannerParametersRequestStatus = DdeRequestStatus.RECEIVED;
        notifyDde(DdeRequestType.REQUEST_SCANNER_PARAMETERS.topic(), RequestParser.ID_ZERO);
    }
    
    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    private List<ScannerData> syncCopyScannerDataValues(int requestId) {
        synchronized(m_scannerSubscriptionRequests) {
            BaseMapDataMap<Integer, ScannerData> scannerDataMap = m_scannerSubscriptionRequests.get(requestId);
            return (scannerDataMap != null ? scannerDataMap.syncCopyMapValues() : new ArrayList<ScannerData>());
        }
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class ScannerSubscriptionParser extends RequestParser {

        /** Method parses DDE request string to ScannerSubscriptionRequest */
        public ScannerSubscriptionRequest parseScannerSubscriptionRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            ScannerSubscription scannerSubscription = parseScannerSubscription(table);
            List<TagValue> scannerSubscriptionFilterOptions = parseScannerSubscriptionFilterOptions(table);;
            
            return new ScannerSubscriptionRequest(requestId, scannerSubscription, scannerSubscriptionFilterOptions, requestStr);
        }

        /** Method extracts ScannerSubscription from table */
        private ScannerSubscription parseScannerSubscription(ArrayList<String> table) {
            ScannerSubscription scannerSubscription = new ScannerSubscription();
            if (table.size() < 21) {
                System.out.println("Cannot extract scanner subscription fields");
                return null;
            }
            // scanner subscription fields
            if (Utils.isNotNull(table.get(0))) {
                scannerSubscription.scanCode(table.get(0));
            }
            if (Utils.isNotNull(table.get(1))) {
                scannerSubscription.instrument(table.get(1));
            }
            if (Utils.isNotNull(table.get(2))) {
                scannerSubscription.locationCode(table.get(2));
            }
            if (Utils.isNotNull(table.get(3))) {
                scannerSubscription.stockTypeFilter(table.get(3));
            }
            if (Utils.isNotNull(table.get(4))) {
                scannerSubscription.numberOfRows(getIntFromString(table.get(4)));
            }
            if (Utils.isNotNull(table.get(5))) {
                scannerSubscription.abovePrice(getDoubleFromString(table.get(5)));
            }
            if (Utils.isNotNull(table.get(6))) {
                scannerSubscription.belowPrice(getDoubleFromString(table.get(6)));
            }
            if (Utils.isNotNull(table.get(7))) {
                scannerSubscription.aboveVolume(getIntFromString(table.get(7)));
            }
            if (Utils.isNotNull(table.get(8))) {
                scannerSubscription.averageOptionVolumeAbove(getIntFromString(table.get(8)));
            }
            if (Utils.isNotNull(table.get(9))) {
                scannerSubscription.marketCapAbove(getDoubleFromString(table.get(9)));
            }
            if (Utils.isNotNull(table.get(10))) {
                scannerSubscription.marketCapBelow(getDoubleFromString(table.get(10)));
            }
            if (Utils.isNotNull(table.get(11))) {
                scannerSubscription.moodyRatingAbove(table.get(11));
            }
            if (Utils.isNotNull(table.get(12))) {
                scannerSubscription.moodyRatingBelow(table.get(12));
            }
            if (Utils.isNotNull(table.get(13))) {
                scannerSubscription.spRatingAbove(table.get(13));
            }
            if (Utils.isNotNull(table.get(14))) {
                scannerSubscription.spRatingBelow(table.get(14));
            }
            if (Utils.isNotNull(table.get(15))) {
                scannerSubscription.maturityDateAbove(table.get(15));
            }
            if (Utils.isNotNull(table.get(16))) {
                scannerSubscription.maturityDateBelow(table.get(16));
            }
            if (Utils.isNotNull(table.get(17))) {
                scannerSubscription.couponRateAbove(getDoubleFromString(table.get(17)));
            }
            if (Utils.isNotNull(table.get(18))) {
                scannerSubscription.couponRateBelow(getDoubleFromString(table.get(18)));
            }
            if (Utils.isNotNull(table.get(19))) {
                scannerSubscription.excludeConvertible(getBooleanFromString(table.get(19)));
            }
            if (Utils.isNotNull(table.get(20))) {
                scannerSubscription.scannerSettingPairs(table.get(20));
            }
            return scannerSubscription;
        }

        /** Method extracts scanner subscription filter options from table */
        private List<TagValue> parseScannerSubscriptionFilterOptions(ArrayList<String> table) {
            List<TagValue> scannerSubscriptionFilterOptions = new ArrayList<TagValue>();
            if (table.size() < 22) {
                System.out.println("Cannot extract scanner subscription filter options");
                return null;
            }
            if (Utils.isNotNull(table.get(21))) {
                scannerSubscriptionFilterOptions = parseTagValueStr(table.get(21));
            }
            return scannerSubscriptionFilterOptions;
        }
    }
}
