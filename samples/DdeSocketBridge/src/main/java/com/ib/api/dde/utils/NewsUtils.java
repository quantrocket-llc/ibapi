/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.util.ArrayList;

import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.socket2dde.data.NewsBulletinData;
import com.ib.api.dde.socket2dde.data.NewsData;
import com.ib.api.dde.utils.Utils;
import com.ib.client.NewsProvider;

/** Class contains some utility methods related to news */
public class NewsUtils {
    
    /** Method creates single table row (array of strings) from NewsData */
    static ArrayList<String> createTableItem(NewsData data, boolean hasExtraData) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.longMilliSecondsToDateTimeString(data.time(), "yyyyMMdd HH:mm:ss"));
        item.add(Utils.toString(data.providerCode()));
        item.add(Utils.toString(data.articleId()));
        if (Utils.isNotNull(data.headline())) {
            item.add(Utils.LONGVALUE + RequestParser.PARAM_SEPARATOR + Utils.toString(Utils.calcNumOfChunks(data.headline(), 255)));
            item.addAll(Utils.chunkStringByLength(data.headline(), 255)); // long string
        }
        if (hasExtraData) {
            item.add(Utils.toString(data.extraData()));
        }
        return item;
    }

    /** Method creates single table row (array of strings) from NewsProvider */
    static ArrayList<String> createTableItem(NewsProvider data) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(data.providerCode()));
        item.add(Utils.toString(data.providerName()));
        return item;
    }
    
    /** Method creates single table row (array of strings) from NewsBulletinData */
    static ArrayList<String> createTableItem(NewsBulletinData data) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(data.msgId()));
        item.add(Utils.toString(data.msgType()));
        if (Utils.isNotNull(data.message())) {
            item.add(Utils.LONGVALUE + RequestParser.PARAM_SEPARATOR + Utils.toString(Utils.calcNumOfChunks(data.message(), 255)));
            item.addAll(Utils.chunkStringByLength(data.message(), 255)); // long string
        }
        
        item.add(Utils.toString(data.originExch()));
        return item;
    }
}
