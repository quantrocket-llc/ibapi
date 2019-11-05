/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.util.ArrayList;

import com.ib.api.dde.utils.Utils;
import com.ib.client.DepthMktDataDescription;

/** Class contains some utility methods related to market depth data */
public class MarketDepthUtils {

    /** Method creates single table row (array of strings) from DepthMktDataDescription */
    static ArrayList<String> createTableItem(DepthMktDataDescription depthMktDataDescription) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(depthMktDataDescription.exchange()));
        item.add(Utils.toString(depthMktDataDescription.secType()));
        item.add(Utils.toString(depthMktDataDescription.listingExch()));
        item.add(Utils.toString(depthMktDataDescription.serviceDataType()));
        item.add(Utils.toString(depthMktDataDescription.aggGroup()));
        return item;
    }
}
