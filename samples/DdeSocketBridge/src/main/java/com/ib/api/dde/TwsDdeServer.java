/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde;

import java.util.function.BiConsumer;

import com.ib.api.dde.SocketDdeBridge.FunctionWithFourParams;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.pretty_tools.dde.ClipboardFormat;
import com.pretty_tools.dde.server.DDEServer;

/** Class acts as TwsDdeServer */
public class TwsDdeServer extends DDEServer {

    private final BiConsumer<String, String> m_handleStopAdvise;
    private final FunctionWithFourParams m_handleDdeRequest;
    
    TwsDdeServer(String serviceName, FunctionWithFourParams handleDdeRequest, BiConsumer<String, String> handleStopAdvise) {
        super(serviceName);
        m_handleDdeRequest = handleDdeRequest;
        m_handleStopAdvise = handleStopAdvise;
    }

     @Override
     protected boolean isTopicSupported(String topicName) {
         //To mimic current DDE behaviour, we accept any topic and simply return an error
         return true;
     }

     @Override
     protected boolean isItemSupported(String topic, String item, int uFmt)
     {
         //Here is where the request from the Excel file reaches first.
         boolean isTopicSupported = isTopicSupported(topic);
         boolean res = isTopicSupported
                 && (uFmt == ClipboardFormat.CF_TEXT.getNativeCode() || uFmt == ClipboardFormat.CF_UNICODETEXT.getNativeCode());
         return res;
     }

     /** Not supported */
     @Override
     protected boolean onPoke(String topic, String item, String data)
     {
         System.out.println("onPoke: Topic: ["+topic+"] Item: ["+item+"]");
         // not supported
         return false;
     }

    /** Method is called when DDEPoke method is called in Excel */
    @Override
    protected boolean onPoke(String topic, String item, byte[] data, int uFmt)
    {
         // =Stwsserver|reqMktData!id0
         // topic=reqMktData item=id0 data=<some binary data>
         System.out.println("onPoke 2: Topic: [" + topic + "] Item: [" + item + "]");
         //String str = new String(data);
         //System.out.println(str);
         
         try {
             m_handleDdeRequest.function(topic, item, data, true);
         } catch(Exception ex) {
             System.out.println("Failed to handle request: " + ex);
         }
         return true;
    }

    /** Method is called when DDE request string is created in Excel */
     @Override
     protected String onRequest(String topic, String item) {
        // =Stwsserver|tik!id0?bidSize
        // topic=tik item=id0?bidSize
        System.out.println("onRequest: Topic: [" + topic + "] Item: [" + item + "].");
        try {
            return m_handleDdeRequest.function(topic, item, (String)null, false);
        } catch(Exception ex) {
            System.out.println("Failed to handle request: " + ex);
        }
        return DdeRequestStatus.ERROR.name();
     }

    /** Method is called when DDERequest method is called in Excel */
    @Override
    protected byte[] onRequest(String topic, String item, int uFmt) {
        // =Stwsserver|cancelMktData!id0
        // topic=cancelMktData item=id0
        System.out.println("onRequest 2: Topic: [" + topic + "] Item: [" + item + "].");
         try {
             return m_handleDdeRequest.function(topic, item, (byte[])null, true);
         } catch(Exception ex) {
             System.out.println("Failed to handle request: " + ex);
         }
        return null;
    }
    
    @Override
    protected boolean onAdvise(String topic, String item, int uFmt, long hconv)
    {
        // System.out.println("onAdvise: Topic: [" + topic + "] Item: [" + item + "].");
        return isItemSupported(topic, item, uFmt);
    }

    @Override
    protected void onStopAdvise(String topic, String item, int uFmt, long hconv)
    {
        System.out.println("onStopAdvise: Topic: [" + topic + "] Item: [" + item + "].");
        m_handleStopAdvise.accept(topic, item);
    }
    
    
}
