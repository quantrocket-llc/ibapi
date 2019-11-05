/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

/** Class represents account update multi data received from TWS */
public class AccountUpdateData {
    private final int m_requestId;
    private final String m_account; 
    private final String m_modelCode; 
    private final String m_key; 
    private final String m_value;
    private final String m_currency;

    // gets
    public int requestId()     { return m_requestId; }
    public String account()    { return m_account; }
    public String modelCode()  { return m_modelCode; }
    public String key()        { return m_key; }
    public String value()      { return m_value; }
    public String currency()   { return m_currency; }

    public AccountUpdateData(int requestId, String account, String modelCode, String key, String value, String currency) {
        m_requestId = requestId;
        m_account = account;
        m_modelCode = modelCode;
        m_key = key;
        m_value = value;
        m_currency = currency;
    }
}
