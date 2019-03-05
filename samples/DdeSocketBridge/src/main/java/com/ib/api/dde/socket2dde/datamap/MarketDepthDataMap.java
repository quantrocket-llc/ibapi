/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.datamap;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.socket2dde.data.MarketDepthData;
import com.ib.api.dde.utils.Utils;

/** Class represents market depth data map received from TWS */
public class MarketDepthDataMap extends BaseDataMap {
    private final static String BID = "BID"; 
    private final static String ASK = "ASK"; 
    private final static String MARKET_MAKER = "mktMaker"; 
    private final static String PRICE = "price"; 
    private final static String SIZE = "size"; 

    private List<MarketDepthData> m_bids = Collections.synchronizedList(new ArrayList<MarketDepthData>());
    private List<MarketDepthData> m_asks = Collections.synchronizedList(new ArrayList<MarketDepthData>());

    public MarketDepthDataMap(DdeRequest ddeRequest) {
        super(ddeRequest);
    }

    /** Method returns value for appropriate field (e.g. 0_bid_marketMaker) */
    @Override
    public Object getValue(String field){
        String[] fieldTokens = field.split(RequestParser.PARAM_SEPARATOR);
        int position = -1;
        if (fieldTokens.length > 0) {
            position = RequestParser.getIntFromString(fieldTokens[0]);
        }
        String side = "";
        if (fieldTokens.length > 1) {
            side = fieldTokens[1];
        }
        if (position != -1 && Utils.isNotNull(side)) {
            List<MarketDepthData> dataArray = side.equalsIgnoreCase(BID) ? m_bids : m_asks;
            if (position < dataArray.size()) {
                MarketDepthData data = side.equalsIgnoreCase(BID) ? m_bids.get(position) : m_asks.get(position);
                String tickType = "";
                if (fieldTokens.length > 2) {
                    tickType = fieldTokens[2];
                }
                if (tickType.equalsIgnoreCase(MARKET_MAKER)) {
                    return data.marketMaker();
                }
                if (tickType.equalsIgnoreCase(PRICE)) {
                    return data.price();
                }
                if (tickType.equalsIgnoreCase(SIZE)) {
                    return data.size();
                }
            }
        }
        return null;
    }

    /** Method updates market depth data */
    public ArrayList<String> updateMarketDepthData(MarketDepthData marketDepthData) {
        // side 0-ask, 1-bid
        StringBuilder sb = new StringBuilder();
        sb.append(String.valueOf(marketDepthData.position()));
        sb.append(RequestParser.PARAM_SEPARATOR);
        if (marketDepthData.side() == 0) {
            updateMarketDepthBidOrAskData(marketDepthData, m_asks);
            sb.append(ASK);
        } else if (marketDepthData.side() == 1) {
            updateMarketDepthBidOrAskData(marketDepthData, m_bids);
            sb.append(BID);
        }
        sb.append(RequestParser.PARAM_SEPARATOR);
        String field = sb.toString();
        ArrayList<String> fields = new ArrayList<String>();
        fields.add(field + MARKET_MAKER);
        fields.add(field + PRICE);
        fields.add(field + SIZE);
        return fields;
    }

    /** Method updates market depth data */
    private void updateMarketDepthBidOrAskData(MarketDepthData marketDepthData, List<MarketDepthData> bidsOrAsks){
        // operation 0-insert, 1 -update, 2-delete
        if (marketDepthData.operation() == 0) {
            // insert
            bidsOrAsks.add(marketDepthData.position(), marketDepthData);
        } else if (marketDepthData.operation() == 1) {
            // update
            bidsOrAsks.set(marketDepthData.position(), marketDepthData);
        } else if (marketDepthData.operation() == 2) {
            // delete
            bidsOrAsks.remove(marketDepthData.position());
        }
    }
}
