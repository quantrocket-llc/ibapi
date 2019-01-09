/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests;

/** Enum with DDE request statuses */
public enum DdeRequestStatus {

    UNKNOWN,  // request is unknown
    PARSED,  // request is parsed (known), not yet sent to TWS
    REQUESTED, // request is sent to TWS, response is not yet received
    RECEIVED, // single response is received
    CANCELLED, // request is cancelled
    SUBSCRIBED, // response is received and continues updating
    FINISHED, // response is sent and not updating anymore
    ERROR // some error
}
