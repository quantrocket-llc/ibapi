/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.datamap;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import com.ib.api.dde.dde2socket.requests.DdeRequest;

/** Class represents market data map received from TWS */
public class MarketDataMap extends BaseDataMap {
    private Map<String, Object> m_dataMap = Collections.synchronizedMap(new HashMap<String, Object>()); // Map field->value
    
    public MarketDataMap(DdeRequest ddeRequest) {
        super(ddeRequest);
    }
    
    @Override
    public Object getValue(String field){
        Object value = null;
        if(m_dataMap.containsKey(field)){
            value = m_dataMap.get(field);
            
            if (value instanceof Double){
                if ((Double)value == Double.MAX_VALUE) {
                    return " ";
                }
            }
            if (value instanceof Integer){
                if ((Integer)value == Integer.MAX_VALUE) {
                    return " ";
                }
            }
            
            return value;
        }
        return -1;
    }

    public void setValue(String field, Object value) {
        m_dataMap.put(field, value);
    }
}
