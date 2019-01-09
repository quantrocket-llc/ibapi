/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.utils;

import com.ib.client.Types.SecType;

/** Class contains some utility methods */
public class OldUtils {

    public static boolean hasLmtPrice(String orderTypeStr) {
        return orderTypeStr.equalsIgnoreCase("LMT") || orderTypeStr.equalsIgnoreCase("STPLMT") || orderTypeStr.equalsIgnoreCase("REL") || 
                orderTypeStr.equalsIgnoreCase("LIT") || orderTypeStr.equalsIgnoreCase("LOC") || orderTypeStr.equalsIgnoreCase("PEGMKT") || 
                orderTypeStr.equalsIgnoreCase("TRAILLIMIT") || orderTypeStr.equalsIgnoreCase("SCALE") || orderTypeStr.equalsIgnoreCase("PEGMID") || 
                orderTypeStr.equalsIgnoreCase("PEG MID") || orderTypeStr.equalsIgnoreCase("PASSV REL") || orderTypeStr.equalsIgnoreCase("PPV");  
    }

    public static boolean hasAuxPrice(String orderTypeStr) {
        return orderTypeStr.equalsIgnoreCase("STP") || orderTypeStr.equalsIgnoreCase("STPLMT") || orderTypeStr.equalsIgnoreCase("REL") || 
                orderTypeStr.equalsIgnoreCase("LIT") || orderTypeStr.equalsIgnoreCase("MIT") || orderTypeStr.equalsIgnoreCase("PEGMKT") || 
                orderTypeStr.equalsIgnoreCase("TRAIL") || orderTypeStr.equalsIgnoreCase("TRAILLIMIT") || orderTypeStr.equalsIgnoreCase("SCALE") || 
                orderTypeStr.equalsIgnoreCase("PEGMID") || orderTypeStr.equalsIgnoreCase("PEG MID") || orderTypeStr.equalsIgnoreCase("PASSV REL") ||
                orderTypeStr.equalsIgnoreCase("PPV");
    }
    
    public static boolean isExpDeriv(SecType secType) {
        return secType == SecType.OPT || secType == SecType.FUT || secType == SecType.FOP || secType == SecType.IOPT || secType == SecType.WAR;
    }

    public static boolean isOpt(SecType secType) {
        return secType == SecType.OPT || secType == SecType.FOP || secType == SecType.IOPT || secType == SecType.WAR;
    }
}
