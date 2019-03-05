/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

import com.ib.client.CommissionReport;
import com.ib.client.Contract;
import com.ib.client.Execution;

/** Class represents execution data received from TWS */
public class ExecutionData {

    private final Contract m_contract;
    private final Execution m_execution;
    private CommissionReport m_commissionReport;

    // gets
    public Contract contract()     { return m_contract; }
    public Execution execution()   { return m_execution; }
    public CommissionReport commissionReport() { return m_commissionReport; }

    // sets
    public void commissionReport(CommissionReport commissionReport) { m_commissionReport = commissionReport; }
    
    public ExecutionData(Contract contract, Execution execution) {
        m_contract = contract;
        m_execution = execution;
    }
}
