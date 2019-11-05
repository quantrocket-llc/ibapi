/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.util.ArrayList;

import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.socket2dde.data.SecDefOptParamsData;
import com.ib.api.dde.utils.Utils;

/** Class contains some utility methods related to security definition option parameters */
public class SecDefOptParamsUtils {
    
    /** Method creates single table row (array of strings) from SecDefOptParamsData */
    static ArrayList<String> createTableItem(SecDefOptParamsData data) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(data.exchange()));
        item.add(Utils.toString(data.underlyingConId()));
        item.add(Utils.toString(data.tradingClass()));
        item.add(Utils.toString(data.multiplier()));

        String expirations = data.expirations().toString();
        if (Utils.isNotNull(expirations)) {
            item.add(Utils.LONGVALUE + RequestParser.PARAM_SEPARATOR + Utils.toString(Utils.calcNumOfChunks(expirations, 255)));
            item.addAll(Utils.chunkStringByLength(expirations, 255)); // long string
        }
        String strikes = data.strikes().toString();
        if (Utils.isNotNull(strikes)) {
            item.add(Utils.LONGVALUE + RequestParser.PARAM_SEPARATOR + Utils.toString(Utils.calcNumOfChunks(strikes, 255)));
            item.addAll(Utils.chunkStringByLength(strikes, 255)); // long string
        }
        return item;
    }
    
}
