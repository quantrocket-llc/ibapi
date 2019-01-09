/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.datamap;

import com.ib.api.dde.dde2socket.requests.DdeRequest;

/** Class represents int + string data received from TWS */
public class BaseStringDataMap extends BaseDataMap {

    private int m_intValue = Integer.MAX_VALUE;
    private String m_stringValue = "";

    public BaseStringDataMap(DdeRequest ddeRequest){
        super(ddeRequest);
    }

    // gets
    public int getInt()       { return m_intValue; }
    public String getString() { return m_stringValue; }
   
    // sets
    public void setInt(int intValue)          { m_intValue = intValue; }
    public void setString(String stringValue) { m_stringValue = stringValue; }
}
