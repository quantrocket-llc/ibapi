/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.historicaldata;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.client.Contract;

/** Class represents DDE historical data request */
public class HistoricalDataRequest extends DdeRequest {
    private final Contract m_contract;
    private final String m_endDateTime;
    private final String m_durationStr;
    private final String m_barSizeSetting;
    private final String m_whatToShow;
    private final int m_useRth;
    private final int m_formatDate;
    private final boolean m_keepUpToDate;

    // gets
    public Contract contract()     { return m_contract; }
    public String endDateTime()    { return m_endDateTime; }
    public String durationStr()    { return m_durationStr; }
    public String barSizeSetting() { return m_barSizeSetting; }
    public String whatToShow()     { return m_whatToShow; }
    public int useRth()            { return m_useRth; }
    public int formatDate()        { return m_formatDate; }
    public boolean keepUpToDate()  { return m_keepUpToDate; }

    public HistoricalDataRequest(int requestId, Contract contract, String endDateTime, String durationStr, String barSizeSetting, String whatToShow,
            int useRth, int formatDate, boolean keepUpToDate, String ddeRequestString) {
        super(requestId, DdeRequestType.REQUEST_HISTORICAL_DATA, ddeRequestString);
        m_contract= contract;
        m_endDateTime = endDateTime;
        m_durationStr = durationStr;
        m_barSizeSetting = barSizeSetting;
        m_whatToShow = whatToShow;
        m_useRth = useRth;
        m_formatDate = formatDate;
        m_keepUpToDate = keepUpToDate;
    }
}
