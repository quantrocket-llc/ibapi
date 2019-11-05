/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.util.ArrayList;

import com.ib.api.dde.socket2dde.data.SmartComponentData;
import com.ib.api.dde.utils.Utils;
import com.ib.client.SoftDollarTier;

/** Class contains some utility methods related to misc requests */
public class MiscUtils {
    
    /** Method creates single table row (array of strings) from SmartComponentData */
    static ArrayList<String> createTableItem(SmartComponentData data) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(data.bitNumber(), "0"));
        item.add(Utils.toString(data.exchange()));
        item.add(Utils.toString(data.exchangeLetter()));
        return item;
    }

    /** Method creates single table row (array of strings) from SoftDollarTier */
    static ArrayList<String> createTableItem(SoftDollarTier data) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(data.name()));
        item.add(Utils.toString(data.value()));
        item.add(Utils.toString(data.toString()));
        return item;
    }
}
