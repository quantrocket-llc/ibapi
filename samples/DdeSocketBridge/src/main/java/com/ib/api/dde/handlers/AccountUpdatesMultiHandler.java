/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.accountupdates.AccountUpdatesMultiRequest;
import com.ib.api.dde.dde2socket.requests.accountupdates.FinancialAdvisorReplace;
import com.ib.api.dde.dde2socket.requests.accountupdates.FinancialAdvisorRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.AccountUpdatesHandler;
import com.ib.api.dde.socket2dde.datamap.BaseStringDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;
import com.ib.client.FamilyCode;

/** Class handles account updates multi related requests and data */
public class AccountUpdatesMultiHandler extends AccountUpdatesHandler {
    // parser
    private AccountUpdatesMultiRequestParser m_requestParser = new AccountUpdatesMultiRequestParser();
    
    // family codes
    private DdeRequestStatus m_familyCodesRequestStatus = DdeRequestStatus.UNKNOWN;
    private List<FamilyCode> m_familyCodes = Collections.synchronizedList(new ArrayList<FamilyCode>());

    // financial advisor
    private BaseStringDataMap m_faRequest;
    private BaseStringDataMap m_faReplace;

    public AccountUpdatesMultiHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests - Account Updates Multi
    /* *****************************************************************************************************/
    /** Method handles account updates multi request */
    public String handleAccountUpdatesMultiRequest(String requestStr) {
        AccountUpdatesMultiRequest request = m_requestParser.parseAccountUpdatesMultiRequest(requestStr);
        System.out.println("Handling account updates multi request: id=" + request.requestId() + " account=" + request.account() + " modelCode=" + request.modelCode());
        return handleAccountUpdatesRequest(request);
    }

    /** Method handles account updates multi array request */
    public byte[] handleAccountUpdatesMultiArrayRequest(String requestStr) {
        AccountUpdatesMultiRequest request = m_requestParser.parseAccountUpdatesMultiRequest(requestStr);
        System.out.println("Handling account updates multi array request: id=" + request.requestId() + " account=" + request.account() + 
                " modelCode=" + request.modelCode() + " ledgerAndNLV=" + request.ledgerAndNLV());
        return handleAccountUpdatesArrayRequest(request);
    }

    /** Method handles cancel account updates multi request */
    public byte[] handleAccountUpdatesMultiCancel(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_ACCOUNT_UPDATES_MULTI);
        System.out.println("Handling account updates multi cancel: id=" + request.requestId());
        return handleAccountUpdatesCancel(request);
    }
    
    /* *****************************************************************************************************
     *                                          Requests - Family Codes
    /* *****************************************************************************************************/
    /** Method handles family codes request */
    public String handleFamilyCodesRequest(String requestStr) {
        if (m_familyCodesRequestStatus == DdeRequestStatus.UNKNOWN) {
            System.out.println("Handling family codes request.");
            clientSocket().reqFamilyCodes();
            m_familyCodesRequestStatus = DdeRequestStatus.REQUESTED;
        }
        return m_familyCodesRequestStatus.toString();
    }

    /** Method handles family codes array request */
    public byte[] handleFamilyCodesArrayRequest(String requestStr) {
        byte[] array = null;
        if (m_familyCodesRequestStatus == DdeRequestStatus.RECEIVED) {
            System.out.println("Handling family codes array request.");
            array = Utils.dataListToByteArray(syncCopyFamilyCodes());
            m_familyCodesRequestStatus = DdeRequestStatus.FINISHED;
            notifyDde(DdeRequestType.REQUEST_FAMILY_CODES.topic(), RequestParser.ID_ZERO);
        }
        return array;
    }

    /** Method handles family codes cancel */
    public String handleFamilyCodesCancel(String requestStr) {
        if (m_familyCodesRequestStatus == DdeRequestStatus.FINISHED) {
            System.out.println("Handling family codes cancel.");
            m_familyCodesRequestStatus = DdeRequestStatus.UNKNOWN;
            m_familyCodes.clear();
        }
        return m_familyCodesRequestStatus.toString();
    }
    
    /* *****************************************************************************************************
     *                                          Requests - FA Request
    /* *****************************************************************************************************/
    /** Method handles FA request */
    public String handleFARequest(String requestStr) {
        if (m_faRequest == null || m_faRequest.ddeRequestStatus() == DdeRequestStatus.UNKNOWN) {
            FinancialAdvisorRequest request = m_requestParser.parseFARequest(requestStr);
            System.out.println("Handling FA request.");
            m_faRequest = new BaseStringDataMap(request);
            clientSocket().requestFA(request.faDataType());
            m_faRequest.ddeRequestStatus(DdeRequestStatus.REQUESTED);
        }
        return m_faRequest != null ? m_faRequest.ddeRequestStatus().toString() : "";
    }

    /** Method handles FA request array request */
    public byte[] handleFARequestArray(String requestStr) {
        byte[] array = null;
        if (m_faRequest.ddeRequestStatus() == DdeRequestStatus.RECEIVED) {
            System.out.println("Handling FA array request.");
            array = Utils.xmlToByteArray(m_faRequest.getString());
            m_faRequest.ddeRequestStatus(DdeRequestStatus.FINISHED);
            notifyDde(m_faRequest.ddeRequest().ddeRequestType().topic(), m_faRequest.ddeRequest().ddeRequestString());
        }
        return array;
    }
    
    /** Method handles FA request stop advise */
    public void handleFARequestStopAdvise(String requestStr) {
        if (m_faRequest.ddeRequestStatus() == DdeRequestStatus.FINISHED || m_faRequest.ddeRequestStatus() == DdeRequestStatus.ERROR) {
            System.out.println("Handling FA request stop advise.");
            m_faRequest = null;
        }
    }
    
    /** Method handles FA request error */
    public String handleFARequestError(String requestStr) {
        return m_faRequest != null ? m_faRequest.error() : "";
    }
    
    /* *****************************************************************************************************
     *                                          Requests - FA Replace
    /* *****************************************************************************************************/
    /** Method handles FA replace */
    public byte[] handleFAReplace(String requestStr, byte[] data) {
        if (m_faReplace == null || m_faReplace.ddeRequestStatus() == DdeRequestStatus.UNKNOWN) {
            FinancialAdvisorReplace request = m_requestParser.parseFAReplace(requestStr, data);
            System.out.println("Handling FA replace.");
            m_faReplace = new BaseStringDataMap(request);
            clientSocket().replaceFA(request.faDataType(), request.xml());
            m_faReplace.ddeRequestStatus(DdeRequestStatus.FINISHED);
            notifyDde(m_faReplace.ddeRequest().ddeRequestType().topic(), RequestParser.ID_ZERO);
        }
        return null;
    }

    /** Method handles FA replace status */
    public String handleFAReplaceStatus(String requestStr) {
        return m_faReplace != null ? m_faReplace.ddeRequestStatus().toString() : DdeRequestStatus.UNKNOWN.toString();
    }
    
    /** Method handles FA replace stop advise */
    public void handleFAReplaceStopAdvise(String requestStr) {
        if (m_faReplace.ddeRequestStatus() == DdeRequestStatus.FINISHED || m_faReplace.ddeRequestStatus() == DdeRequestStatus.ERROR) {
            System.out.println("Handling FA replace stop advise.");
            m_faReplace = null;
        }
    }
    
    /** Method handles FA replace error */
    public String handleFAReplaceError(String requestStr) {
        return  m_faReplace != null ? m_faReplace.error() : "";
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates family codes */
    public void updateFamilyCodes(FamilyCode[] familyCodes) {
        m_familyCodes = Arrays.asList(familyCodes);
        m_familyCodesRequestStatus = DdeRequestStatus.RECEIVED;
        notifyDde(DdeRequestType.REQUEST_FAMILY_CODES.topic(), RequestParser.ID_ZERO);
    }

    /** Method updates FA data */
    public void updateFA(int faDataType, String xml) {
        m_faRequest.setString(xml);
        m_faRequest.ddeRequestStatus(DdeRequestStatus.RECEIVED);
        notifyDde(m_faRequest.ddeRequest().ddeRequestType().topic(), m_faRequest.ddeRequest().ddeRequestString());
    }
    
    /** Method updates FA request error */
    public boolean updateFARequestError(String errorMsgStr) {
        if (m_faRequest != null && m_faRequest.ddeRequestStatus() != DdeRequestStatus.FINISHED 
                && m_faRequest.ddeRequestStatus() != DdeRequestStatus.ERROR) {
            updateRequestError(errorMsgStr, m_faRequest, m_faRequest.ddeRequest().ddeRequestType().topic());
            return true;
        }
        return false;
    }

    /** Method updates FA replace error */
    public boolean updateFAReplaceError(String errorMsgStr) {
        if (m_faReplace != null) {
            updateRequestError(errorMsgStr, m_faReplace, m_faReplace.ddeRequest().ddeRequestType().topic());
            return true;
        }
        return false;
    }
    
    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    private List<FamilyCode> syncCopyFamilyCodes() {
        synchronized(m_familyCodes) {
            return new ArrayList<FamilyCode>(m_familyCodes);
        }
    }
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests 
     * and TWS responses to DDE notifications */
    private class AccountUpdatesMultiRequestParser extends RequestParser {

        /** Method parses DDE request string to AccoutUpdateMultiRequest */
        private AccountUpdatesMultiRequest parseAccountUpdatesMultiRequest(String requestStr) {
            int requestId = -1;
            String account = "";
            String model = "";
            String requestParamsStr = "";
            boolean ledgerAndNLV = false;
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            if (requestTokens.length > 1) {
                requestParamsStr = requestTokens[1];
                String[] requestParams = requestParamsStr.split(PARAM_SEPARATOR);
                if (requestParams.length > 0) {
                    account = requestParams[0];
                }
                if (requestParams.length > 1) {
                    model = requestParams[1];
                }
                if (requestParams.length > 2) {
                    ledgerAndNLV = requestParams[2].equals("True");
                }

            }
            return new AccountUpdatesMultiRequest(requestId, account, model, ledgerAndNLV, requestStr);
       }
        
        /** Method parses DDE request string to FinancialAdvisorRequest */
        private FinancialAdvisorRequest parseFARequest(String requestStr) {
            int requestId = -1;
            int faDataType = Integer.MAX_VALUE;
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            if (requestTokens.length > 1) {
                faDataType = getIntFromString(requestTokens[1]);
            }
            return new FinancialAdvisorRequest(requestId, faDataType, requestStr);
       }
        
        /** Method parses DDE request string to FinancialAdvisorRequest */
        private FinancialAdvisorReplace parseFAReplace(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            int faDataType = Integer.MAX_VALUE;
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            if (requestTokens.length > 1) {
                faDataType = getIntFromString(requestTokens[1]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < table.size(); i++) {
                sb.append(table.get(i));
            }
            String xml = sb.toString();
            
            return new FinancialAdvisorReplace(requestId, faDataType, xml, requestStr);
       }
    }
}
