/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.datamap;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.ib.api.dde.dde2socket.requests.DdeRequest;

/** Class represents base data map with list */
public class BaseListDataMap<T> extends BaseDataMap {

    protected List<T> m_list = Collections.synchronizedList(new ArrayList<T>());

    public BaseListDataMap(DdeRequest ddeRequest){
        super(ddeRequest);
    }

    public List<T> syncCopyList() {
        synchronized(m_list) {
            return new ArrayList<T>(m_list);
        }
    }

    public void addItem(T item) {
        m_list.add(item);
    }

    public void addAllItems(List<T> items) {
        m_list.addAll(items);
    }
    
    public void clearAllItems() {
        m_list.clear();
    }
}
