/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.datamap;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ib.api.dde.dde2socket.requests.DdeRequest;

/** Class represents base data map received from TWS */
public class BaseMapDataMap<S, T> extends BaseDataMap {

    private Map<S, T> m_map = Collections.synchronizedMap(new HashMap<S, T>());

    public BaseMapDataMap(DdeRequest ddeRequest){
        super(ddeRequest);
    }

    public List<T> syncCopyMapValues() {
        synchronized(m_map) {
            return new ArrayList<T>(m_map.values());
        }
    }

    public void addData(S key, T data) {
        m_map.put(key, data);
    }

    public void clearDataMap() {
        m_map.clear();
    }
}
