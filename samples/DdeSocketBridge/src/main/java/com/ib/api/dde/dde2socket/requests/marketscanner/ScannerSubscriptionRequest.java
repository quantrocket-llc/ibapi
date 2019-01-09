/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.marketscanner;

import java.util.List;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.client.ScannerSubscription;
import com.ib.client.TagValue;

/** Class represents DDE scanner subscription request */
public class ScannerSubscriptionRequest extends DdeRequest {
    private final ScannerSubscription m_scannerSubscription;
    private final List<TagValue> m_scannerSubscriptionFilterOptions;

    // gets
    public ScannerSubscription scannerSubscription()   { return m_scannerSubscription; }
    public List<TagValue> scannerSubscriptionFilterOptions() { return m_scannerSubscriptionFilterOptions; }

    public ScannerSubscriptionRequest(int requestId, ScannerSubscription scannerSubscription, List<TagValue> scannerSubscriptionFilterOptions, 
            String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_SCANNER_SUBSCRIPTION, ddeRequestString);
        m_scannerSubscription = scannerSubscription;
        m_scannerSubscriptionFilterOptions = scannerSubscriptionFilterOptions;
    }
}
