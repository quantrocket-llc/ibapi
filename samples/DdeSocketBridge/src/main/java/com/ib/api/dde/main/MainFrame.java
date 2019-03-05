/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.main;

import javax.swing.JFrame;
import javax.swing.JTextArea;

import com.ib.api.dde.SocketDdeBridge;
import com.pretty_tools.dde.DDEException;

/** MainFrame class which starts SocketDdeBridge */
public class MainFrame extends JFrame {
    private static final long serialVersionUID = 5170383608469214906L;

    JTextArea m_textArea = new JTextArea("", 18, 18);
    
    public MainFrame() {
        setTitle("DdeSocketBridge");
        setSize(300, 200);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        m_textArea.setEditable(false);
        getContentPane().add(m_textArea);
    }
    
    /** Starts DdeSocket bridge */
    public void start(String ddeServiceName, String host, int port, int clientId) {
        String text = "Service name: " + ddeServiceName + "\n" +
                "Host: " + host + "\n" +
                "Port: " + port + "\n" + 
                "Client Id: " + clientId + "\n";
        m_textArea.setText(text);
        System.out.println("Starting DdeSocket bridge server [" + ddeServiceName + "]");
        
        SocketDdeBridge bridge = new SocketDdeBridge(ddeServiceName, host, port, clientId);
        
        try {
            bridge.start(new Runnable() {
                @Override
                public void run()
                {
                    setText(text, bridge.isConnected());
                }
            });
        } catch (DDEException e) {
            System.out.println("Failed! " + e);
        } catch (InterruptedException e) {
            setText(text, bridge.isConnected());
            System.out.println("Failed! " + e);
        }
    }
    
    private void setText(String text, boolean isConnected) {
        m_textArea.setText(text + (isConnected? "Connected!\n" : "Disconnected!\n"));
    }
}
