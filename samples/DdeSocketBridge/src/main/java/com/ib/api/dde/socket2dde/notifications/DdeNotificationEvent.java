/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.notifications;

/** Class represents DDE notification event */
public class DdeNotificationEvent {

    private final String m_topic;
    private final String m_requestString;

    // gets
    public String topic()         { return m_topic; }
    public String requestString() { return m_requestString; }

    public DdeNotificationEvent(String topic, String requestString) {
        m_topic = topic;
        m_requestString = requestString;
    }
}
