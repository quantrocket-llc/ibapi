/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.util.ArrayList;

import com.ib.api.dde.socket2dde.data.ScannerData;
import com.ib.api.dde.utils.Utils;

/** Class contains some utility methods related to market scanner data */
public class MarketScannerUtils {

    /** Method creates single table row (array of strings) from ScannerData */
    static ArrayList<String> createTableItem(ScannerData scannerData) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(scannerData.rank(), "0"));
        item.add(Utils.toString(scannerData.contractDetails().contract().conid()));
        item.add(Utils.toString(scannerData.contractDetails().contract().symbol()));
        item.add(Utils.toString(scannerData.contractDetails().contract().getSecType()));
        item.add(Utils.toString(scannerData.contractDetails().contract().lastTradeDateOrContractMonth()));
        item.add(Utils.toString(scannerData.contractDetails().contract().strike()));
        item.add(Utils.toString(scannerData.contractDetails().contract().getRight()));
        item.add(Utils.toString(scannerData.contractDetails().contract().exchange()));
        item.add(Utils.toString(scannerData.contractDetails().contract().currency()));
        item.add(Utils.toString(scannerData.contractDetails().contract().localSymbol()));
        item.add(Utils.toString(scannerData.contractDetails().marketName()));
        item.add(Utils.toString(scannerData.contractDetails().contract().tradingClass()));
        item.add(Utils.toString(scannerData.distance()));
        item.add(Utils.toString(scannerData.benchmark()));
        item.add(Utils.toString(scannerData.projection()));
        item.add(Utils.toString(scannerData.legsStr()));
        return item;
    }
}
