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
        m_twsDdeServer = new TwsDdeServer(ddeServiceName, 
                (new HandleDdeRequest())::handleDdeRequest, 
                (new HandleStopAdvise())::handleDdeStopAdvise);
        
        m_twsService = new TwsService(twsHost, twsPort, twsClientId, 
                (new NotifyClients())::notifyDde,
                (new StopDdeSocketBridge())::stop
        );
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
    
    @FunctionalInterface
    interface FunctionWithFourParams {
        <T> T function(String s1, String s2, T d, boolean b);
    }
    
    /** Class with single method which handles DDE request */
    private class HandleDdeRequest {
        <T> T handleDdeRequest(String topic, String requestStr, T data, boolean withData) {
            return m_twsService.sendDdeToTws(topic, requestStr, data, withData);
        }
    }

    /** Class with single method which handles DDE stop advise */
    private class HandleStopAdvise {
        void handleDdeStopAdvise(String topic, String requestStr) {
            m_twsService.stopAdviseDde(topic, requestStr);
        }
    }
    
    /** Class with single method which notifies Excel that appropriate data was updated */
    private class NotifyClients {
        void notifyDde(DdeNotificationEvent ddeEvent) {
            try {
                m_twsDdeServer.notifyClients(ddeEvent.topic(), ddeEvent.requestString());
            }
            catch(DDEException ddeEx) {
                System.out.println("Failed to send to DDE: " + ddeEx);
            }
        }
    }

    /** Class with single method which stops DDE socket bridge */ 
    private class StopDdeSocketBridge {
        void stop() {
            try {
                m_twsDdeServer.stop();
            } catch (DDEException e) {
                System.out.println("Failed to stop SocketDdeBridge! " + e);
            }
            m_isConnected = false;
            if (m_callback != null) {
                m_callback.run();
            }
        }
    }
}
