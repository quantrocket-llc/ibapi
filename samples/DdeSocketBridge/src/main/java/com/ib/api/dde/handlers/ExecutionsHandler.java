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
import com.ib.api.dde.dde2socket.requests.executions.ExecutionsRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.data.ExecutionData;
import com.ib.api.dde.socket2dde.datamap.BaseListDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.CommissionReport;
import com.ib.client.EClientSocket;
import com.ib.client.ExecutionFilter;

/** Class handles executions related requests and data */
public class ExecutionsHandler extends BaseHandler {
    // parser
    private ExecutionsRequestParser m_requestParser = new ExecutionsRequestParser();
    
    // executions
    private Map<Integer, BaseListDataMap<ExecutionData>> m_executionDataMap = Collections.synchronizedMap(new HashMap<Integer, BaseListDataMap<ExecutionData>>());

    public ExecutionsHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles executions request */
    public String handleExecutionsRequest(String requestStr) {
        ExecutionsRequest request = m_requestParser.parseExecutionsRequest(requestStr);
        String ret = "";
        BaseListDataMap<ExecutionData> executionDataMap = m_executionDataMap.get(request.requestId());
        if (executionDataMap == null) {
            executionDataMap = new BaseListDataMap<ExecutionData>(request);
            m_executionDataMap.put(request.requestId(), new BaseListDataMap<ExecutionData>(request));
        }
        if (executionDataMap.ddeRequestStatus() == DdeRequestStatus.UNKNOWN) {
            // send reqExecutions request
            System.out.println("Handling executions request: id=" + request.requestId());
            clientSocket().reqExecutions(request.requestId(), request.executionFilter());
            executionDataMap.ddeRequestStatus(DdeRequestStatus.REQUESTED);
        }
        
        ret = executionDataMap.ddeRequestStatus().toString();
        
        if (executionDataMap.ddeRequestStatus() == DdeRequestStatus.ERROR) {
            executionDataMap.ddeRequestStatus(DdeRequestStatus.UNKNOWN);
        }
        return ret;
    }
    
    /** Method handles executions array request */
    public byte[] handleExecutionsArrayRequest(String requestStr) {
        ExecutionsRequest request = m_requestParser.parseExecutionsRequest(requestStr);
        int requestId = request.requestId();
        
        System.out.println("Handling executions array request: id=" + requestId);
        byte[] array = Utils.dataListToByteArray(syncCopyExecutions(requestId), true);
        
        BaseListDataMap<ExecutionData> executionDataMap = m_executionDataMap.get(requestId);
        if (executionDataMap != null) {
            executionDataMap.ddeRequestStatus(DdeRequestStatus.SUBSCRIBED);
            notifyDde(DdeRequestType.REQ_EXECUTIONS.topic(), request.ddeRequestString());
            executionDataMap.clearAllItems();
        }
        return array;
    }
    
    /** Method handles cancel executions request */
    public byte[] handleExecutionsCancelRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_EXECUTIONS);
        System.out.println("Handling executions cancel: id=" + request.requestId());
        m_executionDataMap.remove(request.requestId());
        return null;
    }

    /** Method handles executions error request */
    public String handleExecutionsErrorRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQ_EXECUTIONS_ERROR);
        System.out.println("Handling executions error request: id=" + request.requestId());
        // error request
        BaseListDataMap<ExecutionData> executionData = m_executionDataMap.get(request.requestId());
        if (executionData != null) {
            m_executionDataMap.remove(request.requestId());
            return executionData.error();
        }
        return "";
    }
    
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates execution data */
    public void updateExecution(int requestId, ExecutionData executionData) {
        BaseListDataMap<ExecutionData> executionDataMap = null;
        if (requestId != -1) {
            executionDataMap = m_executionDataMap.get(requestId);
        }
        if (executionDataMap != null) {
            executionDataMap.addItem(executionData);
            if (executionDataMap.ddeRequestStatus() == DdeRequestStatus.SUBSCRIBED) {
                executionDataMap.ddeRequestStatus(DdeRequestStatus.RECEIVED);
                notifyDde(DdeRequestType.REQ_EXECUTIONS.topic(), executionDataMap.ddeRequest().ddeRequestString());
            }
        } else if (!m_executionDataMap.isEmpty()) {
            for (BaseListDataMap<ExecutionData> executionDataMapEntry : m_executionDataMap.values()) {
                executionDataMapEntry.addItem(executionData);
                if (executionDataMapEntry.ddeRequestStatus() == DdeRequestStatus.SUBSCRIBED) {
                    executionDataMapEntry.ddeRequestStatus(DdeRequestStatus.RECEIVED);
                    notifyDde(DdeRequestType.REQ_EXECUTIONS.topic(), executionDataMapEntry.ddeRequest().ddeRequestString());
                }
            }
        }
    }

    /** Method updates execution data */
    public void updateExecutionEnd(int requestId) {
        updateDataEnd(m_executionDataMap.get(requestId), DdeRequestType.REQ_EXECUTIONS.topic());
    }

    /** Method updates errors during reqExecution request */
    public void updateExecutionError(int requestId, String errorMsgStr) {
        updateRequestError(errorMsgStr, m_executionDataMap.get(requestId), DdeRequestType.REQ_EXECUTIONS.topic());
    }

    /** Method updates commission report */
    public void updateCommissionReport(CommissionReport commissionReport) {
        ExecutionData executionDataMap = getExecutionDataMapByExecId(commissionReport.execId());
        if (executionDataMap != null) {
            executionDataMap.commissionReport(commissionReport);
        }
    }

    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    /** Method finds execution data by execId */
    private ExecutionData getExecutionDataMapByExecId(String execId) {
        ExecutionData executionDataRet = null;
        synchronized(m_executionDataMap) {
            for (BaseListDataMap<ExecutionData> executionDataMap : m_executionDataMap.values()) {
                for (ExecutionData executionData: executionDataMap.syncCopyList()) {
                    if (executionData.execution().execId().equals(execId)){
                        executionDataRet = executionData;
                    }
                }
            }
        }
        return executionDataRet;
    }

    private List<ExecutionData> syncCopyExecutions(int requestId) {
        synchronized(m_executionDataMap) {
            BaseListDataMap<ExecutionData> executionDataMap = m_executionDataMap.get(requestId);
            return (executionDataMap != null ? executionDataMap.syncCopyList() : new ArrayList<ExecutionData>());
        }
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests 
     * and TWS responses to DDE notifications */
    private class ExecutionsRequestParser extends RequestParser {

        /** Method parses DDE request string to ExecutionsRequest */
        private ExecutionsRequest parseExecutionsRequest(String requestStr) {
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            int requestId = parseRequestId(messageTokens[0]);
            ExecutionFilter executionFilter = new ExecutionFilter();
            if (messageTokens.length > 1) {
                String[] params = messageTokens[1].split(PARAM_SEPARATOR);
                if (params.length >= 1) {
                    int clientId = 0;
                    try {
                        clientId = Utils.isNotNull(params[0]) ? Integer.valueOf(params[0]): 0;
                        executionFilter.clientId(clientId);
                    } catch (NumberFormatException ex) {
                        System.out.println("Error parsing clientId. NumberFormatException: " + ex.getMessage());
                    }
                }
                if (params.length >= 2) {
                    executionFilter.acctCode(params[1]);
                }
                if (params.length >= 3) {
                    if (Utils.isNotNull(params[2]) && params[2].length() == 14) {
                        StringBuilder sb = new StringBuilder();
                        sb.append(params[2].substring(0, 8));
                        sb.append("-");
                        sb.append(params[2].substring(8, 10));
                        sb.append(":");
                        sb.append(params[2].substring(10, 12));
                        sb.append(":");
                        sb.append(params[2].substring(12, 14));
                        executionFilter.time(sb.toString());
                    }
                }
                if (params.length >= 4) {
                    executionFilter.symbol(params[3]);
                }
                if (params.length >= 5) {
                    executionFilter.secType(params[4]);
                }
                if (params.length >= 6) {
                    executionFilter.exchange(params[5]);
                }
                if (params.length >= 7) {
                    executionFilter.side(params[6]);
                }
            }
            return new ExecutionsRequest(requestId, executionFilter, requestStr);
        }
    }
}
