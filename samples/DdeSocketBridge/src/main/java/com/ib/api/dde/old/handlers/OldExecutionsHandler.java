/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.handlers;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.handlers.ExecutionsHandler;
import com.ib.api.dde.socket2dde.data.ExecutionData;
import com.ib.api.dde.utils.Utils;
import com.ib.client.EClientSocket;
import com.ib.client.ExecutionFilter;

/** Class handles executions related requests and data */
public class OldExecutionsHandler extends ExecutionsHandler {
    private String m_executionRequestStr = "";
    
    // executions
    private DdeRequestStatus m_executionsSubscriptionStatus = DdeRequestStatus.UNKNOWN;
    private List<ExecutionData> m_executions = Collections.synchronizedList(new ArrayList<ExecutionData>());

    public OldExecutionsHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles executions request */
    @Override
    public String handleExecutionsRequest(String requestStr) {
        m_executionRequestStr = requestStr;
        if (m_executionsSubscriptionStatus == DdeRequestStatus.UNKNOWN) {
            // send reqExecutions request
            System.out.println("Handling executions request: " + requestStr);
            m_executions.clear();
            clientSocket().reqExecutions(0, new ExecutionFilter());
            m_executionsSubscriptionStatus = DdeRequestStatus.REQUESTED;
        }
        
        return m_executionsSubscriptionStatus.toString();
    }
    
    /** Method handles executions array request */
    @Override
    public byte[] handleExecutionsArrayRequest(String requestStr) {
        System.out.println("Handling executions array request: id=" + requestStr);
        byte[] array = Utils.dataListToByteArray(syncCopyExecutions(), false);
        m_executionsSubscriptionStatus = DdeRequestStatus.SUBSCRIBED;
        notifyDde(DdeRequestType.EXECS.topic(), m_executionRequestStr);
        m_executions.clear();
        return array;
    }

    /** Method stops executions advise loop */
    public void handleExecutionsStopAdvise(String requestStr) {
        System.out.println("Handling executions stop advise: " + requestStr);
        m_executionsSubscriptionStatus = DdeRequestStatus.UNKNOWN;
    }    
    
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates execution data */
    @Override
    public void updateExecution(int requestId, ExecutionData executionData) {
        m_executions.add(executionData);
        if (m_executionsSubscriptionStatus == DdeRequestStatus.SUBSCRIBED) {
            m_executionsSubscriptionStatus = DdeRequestStatus.RECEIVED;
            notifyDde(DdeRequestType.EXECS.topic(), m_executionRequestStr);
        }
    }

    /** Method updates execution data */
    @Override
    public void updateExecutionEnd(int requestId) {
        m_executionsSubscriptionStatus = DdeRequestStatus.RECEIVED;
        notifyDde(DdeRequestType.EXECS.topic(), m_executionRequestStr);
    }

    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    public List<ExecutionData> syncCopyExecutions() {
        synchronized(m_executions) {
            return new ArrayList<ExecutionData>(m_executions);
        }
    }
}
