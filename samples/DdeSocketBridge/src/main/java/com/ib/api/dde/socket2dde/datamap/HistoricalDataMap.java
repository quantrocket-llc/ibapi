/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.datamap;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.client.Bar;

/** Class represents historical data map received from TWS */
public class HistoricalDataMap extends BaseListDataMap<Bar> {

    private Bar m_liveBar; // live bar (historicalDataUpdate callback)

    public HistoricalDataMap(DdeRequest ddeRequest){
        super(ddeRequest);
    }

    public void initLiveBar() {
        if (m_list.size() > 0) {
            m_liveBar = m_list.get(m_list.size() - 1);
        }
    }
    
    public boolean updateLiveBar(Bar bar) {
        boolean ret = false;
        if (m_liveBar != null && !m_liveBar.time().equals(bar.time())){
            m_list.add(m_liveBar);
            ret = true;
        }
        m_liveBar = bar;
        return ret;
    }
}
