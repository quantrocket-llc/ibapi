/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.handlers;

import java.util.StringTokenizer;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.marketscanner.ScannerSubscriptionRequest;
import com.ib.api.dde.handlers.ScannerDataHandler;
import com.ib.api.dde.old.requests.parser.OldRequestParser;
import com.ib.api.dde.socket2dde.data.ScannerData;
import com.ib.api.dde.socket2dde.datamap.BaseDataMap;
import com.ib.api.dde.socket2dde.datamap.BaseMapDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;
import com.ib.client.ScannerSubscription;

/** Class handles old-style scanner subscription related requests, data and messages */
public class OldScannerDataHandler extends ScannerDataHandler {
    // parser
    private OldScannerSubscriptionParser m_requestParser = new OldScannerSubscriptionParser();

    public OldScannerDataHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends scanner subscription request to TWS */
    public String handleScannerSubscriptionRequest(String requestStr) {
        ScannerSubscriptionRequest request = m_requestParser.parseScannerSubscriptionRequest(requestStr);
        System.out.println("Handling scanner subscription request: id=" + request.requestId() + " scanCode=" + request.scannerSubscription().scanCode());

        BaseMapDataMap<Integer, ScannerData> dataMap = m_scannerSubscriptionRequests.get(request.requestId());
        if(dataMap == null) {
            System.out.println("Sending scanner subscription request: id=" + request.requestId() + " scanCode=" + request.scannerSubscription().scanCode());
            clientSocket().reqScannerSubscription(request.requestId(), request.scannerSubscription(), null, request.scannerSubscriptionFilterOptions());
            dataMap = new BaseMapDataMap<Integer, ScannerData>(request);
            m_scannerSubscriptionRequests.put(request.requestId(), dataMap);
            updateScannerSubscriptionStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        }
        return dataMap.ddeRequestStatus().toString();
    }

    /** Method stops scanner subscription advise loop */
    public void handleScannerSubscriptionStopAdvise(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_SCANNER_SUBSCRIPTION);
        System.out.println("Sending scanner subscription cancel: id=" + request.requestId());
        if (m_scannerSubscriptionRequests.containsKey(request.requestId())) {
            clientSocket().cancelScannerSubscription(request.requestId());
            m_scannerSubscriptionRequests.remove(request.requestId());
        }
    }    
    
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates scanner subscription status field for requestId */
    @Override
    protected void updateScannerSubscriptionStatus(int requestId, BaseDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(dataMap, status, DdeRequestType.SCAN.topic());
    }
    
    /** Method updates scanner data end for requestId */
    @Override
    public void updateScannerDataEnd(int requestId) {
        updateDataEnd(m_scannerSubscriptionRequests.get(requestId), DdeRequestType.SCAN.topic());
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class OldScannerSubscriptionParser extends OldRequestParser {

        /** Method parses DDE request string to ScannerSubscriptionRequest */
        public ScannerSubscriptionRequest parseScannerSubscriptionRequest(String requestStr) {
            int requestId = -1;
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }

            ScannerSubscription scannerSubscription = new ScannerSubscription();
            String tickTypeStr = "";
            if (requestTokens.length > 1) {
                tickTypeStr = requestTokens[1];
            }
            if (tickTypeStr.equals(DdeRequestType.REQ.topic())) {
                scannerSubscription = parseScannerSubscriptionParams(requestTokens[2]);
            }
            return new ScannerSubscriptionRequest(requestId, scannerSubscription, null, requestStr);
        }
        
        /** Method parses scanner subscription params */
        private ScannerSubscription parseScannerSubscriptionParams(String scannerSubscriptionParamsStr) {
            ScannerSubscription scannerSubscription = new ScannerSubscription();
            StringTokenizer st = new StringTokenizer(scannerSubscriptionParamsStr, PARAM_SEPARATOR);
            
            String token = getParameter(st);
            if (Utils.isNotNull(token)){
                token = token.replace("uNdErScOrE", PARAM_SEPARATOR);
                scannerSubscription.scanCode(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.instrument(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.locationCode(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.stockTypeFilter(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.numberOfRows(getIntFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.abovePrice(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.belowPrice(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.aboveVolume(getIntFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.averageOptionVolumeAbove(getIntFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.marketCapAbove(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.marketCapBelow(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.moodyRatingAbove(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.moodyRatingBelow(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.spRatingAbove(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.spRatingBelow(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.maturityDateAbove(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.maturityDateBelow(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.couponRateAbove(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.couponRateBelow(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.excludeConvertible(getBooleanFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                scannerSubscription.scannerSettingPairs(token);
            }

            return scannerSubscription;
        }
    }
}
