/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.util.ArrayList;

import com.ib.api.dde.socket2dde.data.TickByTickData;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Bar;
import com.ib.client.HistogramEntry;

/** Class contains some utility methods related to historical data */
public class HistoricalDataUtils {
    
    /** Method creates single table row (array of strings) from Bar */
    static ArrayList<String> createTableItem(Bar bar) {
        ArrayList<String> item = new ArrayList<String>();

        item.add(Utils.toString(bar.time()));
        item.add(Utils.toString(bar.open()));
        item.add(Utils.toString(bar.high()));
        item.add(Utils.toString(bar.low()));
        item.add(Utils.toString(bar.close()));
        item.add(Utils.toString(bar.volume()));
        item.add(Utils.toString(bar.count()));
        item.add(Utils.toString(bar.wap()));
        return item;
    }
    
    /** Method creates single table row (array of strings) from TickByTickData */
    static ArrayList<String> createTableItem(TickByTickData tick) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.longSecondsToDateTimeString(tick.time(), "yyyyMMdd HH:mm:ss"));
        if (tick.isAllLast()) {
            item.add(Utils.toString(tick.price()));
            item.add(Utils.toString(tick.size()));
            item.add(Utils.toString(tick.tickAttribLast().pastLimit()));
            item.add(Utils.toString(tick.tickAttribLast().unreported()));
            item.add(Utils.toString(tick.exchange()));
            item.add(Utils.toString(tick.specialConditions()));
        } else if (tick.isBidAsk()) {
            item.add(Utils.toString(tick.bidPrice()));
            item.add(Utils.toString(tick.bidSize()));
            item.add(Utils.toString(tick.askPrice()));
            item.add(Utils.toString(tick.askSize()));
            item.add(Utils.toString(tick.tickAttribBidAsk().bidPastLow()));
            item.add(Utils.toString(tick.tickAttribBidAsk().askPastHigh()));
        } else if (tick.isMidPoint()) {
            item.add(Utils.toString(tick.price()));
        }
        return item;
    }    
    
    /** Method creates single table row (array of strings) from HistogramEntry */
    static ArrayList<String> createTableItem(HistogramEntry histogramEntry) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(histogramEntry.price));
        item.add(Utils.toString(histogramEntry.size));
        return item;
    }
    
}
