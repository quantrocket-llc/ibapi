/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.handlers;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.MiscHandler;
import com.ib.api.dde.socket2dde.notifications.DdeNotificationEvent;
import com.ib.client.EClientSocket;

/** Class handles some old-style minor requests */
public class OldMiscHandler extends MiscHandler {

    public OldMiscHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Managed accounts
    /* *****************************************************************************************************/
    /** Method handles managed accounts request */
    public String handleManagedAccountsRequestOld(String requestStr) {
        return requestStr.contains(DdeRequestType.VALUE.topic()) ? m_accountsList : "";
    }
    
    /* *****************************************************************************************************
     *                                          Account Time
    /* *****************************************************************************************************/
    /** Method updates account time */
    public void updateAccountTime(String timeStamp) {
        m_accountUpdateTime = timeStamp;
        DdeNotificationEvent oldEvent = RequestParser.createDdeNotificationEvent(DdeRequestType.ACCT.topic(), "id1?acctTime");
        twsService().notifyDde(oldEvent);
    }
}
