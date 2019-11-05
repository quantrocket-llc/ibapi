/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

/** Class represents news bulletin data received from TWS */
public class NewsBulletinData {
    private final int m_msgId;
    private final int m_msgType; 
    private final String m_message; 
    private final String m_originExch; 

    // gets
    public int msgId()         { return m_msgId; }
    public int msgType()       { return m_msgType; }
    public String message()    { return m_message; }
    public String originExch() { return m_originExch; }

    public NewsBulletinData(int msgId, int msgType, String message, String originExch) {
        m_msgId = msgId;
        m_msgType = msgType;
        m_message = message;
        m_originExch = originExch;
    }
}
