/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.handlers;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.NewsDataHandler;
import com.ib.api.dde.socket2dde.data.NewsBulletinData;
import com.ib.api.dde.socket2dde.notifications.DdeNotificationEvent;
import com.ib.client.EClientSocket;

/** Class handles news data and messages */
public class OldNewsHandler extends NewsDataHandler {
    private NewsRequestParser m_requestParser = new NewsRequestParser();
    
    // error data
    private NewsBulletinData m_newsBulletinData;
    private boolean m_hasNewsBulletinsRequest = false;
    
    public OldNewsHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }
    
    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles news bulletins request */
    public String handleNewsBulletinsRequest(String requestStr) {
        System.out.println("Handling news bulletins request: " + requestStr);
        m_hasNewsBulletinsRequest = true;
        DdeRequestType requestType = m_requestParser.parseNewsBulletinsRequest(requestStr);
        String ret = "";
        if (m_newsBulletinData != null) {
            switch (requestType){
                case NEWS_SUB:
                    clientSocket().reqNewsBulletins(true);
                    break;
                case NEWS_MSG:
                    ret = String.valueOf(m_newsBulletinData.message());
                    break;
                default:
                    break;
            }
        }
        return ret;
    }    
    
    /** Method stops news bulletins advise loop */
    public void handleNewsBulletinsStopAdvise(String requestStr) {
        System.out.println("Handling news bulletins stop advise: " + requestStr);
        m_hasNewsBulletinsRequest = false;
        clientSocket().cancelNewsBulletins();
    }
 
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method saves news bulletin */
    public void updateNewsBulletinData(NewsBulletinData newsBulletinData) {
        m_newsBulletinData = newsBulletinData;

        // notification
        if (m_hasNewsBulletinsRequest) {
            notifyDde(DdeRequestType.NEWS_MSG.topic());
        }
    }

    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    /** Method sends notification to DDE */
    private void notifyDde(String requestString) {
        DdeNotificationEvent event = RequestParser.createDdeNotificationEvent(DdeRequestType.NEWS.topic(), requestString);
        twsService().notifyDde(event);
    }

    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class NewsRequestParser extends RequestParser {

        /** Method parses DDE request string to DdeRequestType */
        private DdeRequestType parseNewsBulletinsRequest(String requestStr) {
            String[] requestTokens = requestStr.split(RequestParser.DDE_REQUEST_SEPARATOR_PARSE);
            DdeRequestType requestType = DdeRequestType.NOTHING;
            if (requestTokens.length > 0) {
                requestType = DdeRequestType.getRequestType(requestTokens[0]);
            }
            return requestType;
        }
    }
}
