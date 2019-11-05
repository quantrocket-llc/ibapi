/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.data;

/** Class represents error data received from TWS */
public class ErrorData {
    private final int m_requesId;
    private final int m_errorCode;
    private final String m_errorMessage;

    // gets
    public int requesId()        { return m_requesId; } 
    public int errorCode()       { return m_errorCode; }
    public String errorMessage() { return m_errorMessage; }

    public ErrorData(int requesId, int errorCode, String errorMessage) {
        m_requesId = requesId;
        m_errorCode = errorCode;
        m_errorMessage = errorMessage;
    }

    public String toString() {
        return m_requesId + ";" + m_errorCode + ";" + m_errorMessage;
    }
}
