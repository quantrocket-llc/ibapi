/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde;

import com.ib.api.dde.socket2dde.notifications.DdeNotificationEvent;
import com.pretty_tools.dde.DDEException;

/** Class represents DDE->Socket bridge */
public class SocketDdeBridge {

    private final TwsDdeServer m_twsDdeServer;
    private final TwsService m_twsService;
    private boolean m_isConnected = false;
    private Runnable m_callback = null;

    public boolean isConnected() { return m_isConnected; }
    
    public SocketDdeBridge(String ddeServiceName, String twsHost, int twsPort, int twsClientId) {
        m_twsDdeServer = new TwsDdeServer(ddeServiceName, this);
        m_twsService = new TwsService(twsHost, twsPort, twsClientId, this);
    }

    /** Method starts DDE socket bridge: starts TwsDdeServer and tries to connect TwsService */
    public void start(Runnable callback) throws DDEException, InterruptedException {
        m_callback = callback;
        m_twsDdeServer.start();
        if (m_twsService.connect() ) {
            m_isConnected = true;
            System.out.println("Connected successfully!");
        } else {
            throw new InterruptedException("Connection failed!");
        }
        callback.run();
    }
    
    /** Method stops DDE socket bridge */
    public void stop() {
        m_isConnected = false;
        if (m_callback != null) {
            m_callback.run();
        }
    }

    /** Method handles DDE request */
    public String handleDdeRequest(String topic, String requestStr) {
        return m_twsService.sendDdeToTws(topic, requestStr);
    }

    /** Method handles DDE request with binary data */
    public byte[] handleDdeRequestWithData(String topic, String requestStr, byte[] data) {
        return m_twsService.sendDdeToTwsWithData(topic, requestStr, data);
    }

    /** Method handles DDE stop advise */
    public void handleDdeStopAdvise(String topic, String requestStr) {
        m_twsService.stopAdviseDde(topic, requestStr);
    }
    
    /** Method notifies Excel that appropriate data was updated */
    public void notifyDde(DdeNotificationEvent ddeEvent) {
        try {
            m_twsDdeServer.notifyClients(ddeEvent.topic(), ddeEvent.requestString());
        }
        catch(DDEException ddeEx) {
            System.out.println("Failed to send to DDE: " + ddeEx);
        }
    }
}
