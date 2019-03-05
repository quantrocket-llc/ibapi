/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.contractdetails;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.client.Contract;

/** Class represents DDE contract details request */
public class ContractDetailsRequest extends DdeRequest {
    private final Contract m_contract;

    // gets
    public Contract contract() { return m_contract; }

    public ContractDetailsRequest(int requestId, Contract contract, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_CONTRACT_DETAILS, ddeRequestString);
        m_contract= contract;
    }
}
