/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.datamap;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.socket2dde.data.TickByTickData;
import com.ib.api.dde.utils.Utils;

/** Class represents tick-by-tick data map received from TWS */
public class TickByTickDataMap extends BaseDataMap {
    
    private final static String SINGLE_SPACE = " ";
    private final static String TRUE = "TRUE";
    
    
    // fields
    private final static String TIME = "time"; 
    private final static String PRICE = "price"; 
    private final static String SIZE = "size"; 
    private final static String EXCHANGE = "exchange";
    private final static String SPEC_COND = "specCond";
    private final static String PAST_LIMIT = "pastLimit";
    private final static String UNREPORTED = "unreported";
    private final static String BID_PRICE = "bidPrice"; 
    private final static String BID_SIZE = "bidSize"; 
    private final static String ASK_PRICE = "askPrice"; 
    private final static String ASK_SIZE = "askSize"; 
    private final static String BID_PAST_LOW = "bidPastLow"; 
    private final static String ASK_PAST_HIGH = "askPastHigh"; 
    
    private static int NUMBER_OF_ROWS= 25;

    private List<TickByTickData> m_data = Collections.synchronizedList(new ArrayList<TickByTickData>());
    private int m_numberOfRows = NUMBER_OF_ROWS;
    
    // sets
    public void numberOfRows(int numberOfRows) {
        m_numberOfRows = numberOfRows;
    }
    
    public TickByTickDataMap(DdeRequest ddeRequest) {
        super(ddeRequest);
    }

    /** Method returns value for appropriate field (e.g. 0_price) */
    @Override
    public Object getValue(String field){
        
        String[] fieldTokens = field.split(RequestParser.PARAM_SEPARATOR);
        int position = -1;
        if (fieldTokens.length > 0) {
            position = RequestParser.getIntFromString(fieldTokens[0]);
        }
        if (position != -1) {
            String tickType = "";
            if (fieldTokens.length > 1) {
                tickType = fieldTokens[1];
            }
            if (position < m_data.size()) {
                TickByTickData data = m_data.get(position);
                if (tickType.equalsIgnoreCase(TIME)) {
                    return Utils.longSecondsToDateTimeString(data.time(), "HH:mm:ss");
                }
                if (tickType.equalsIgnoreCase(PRICE)) {
                    return Utils.toString(data.price(), SINGLE_SPACE);
                }
                if (tickType.equalsIgnoreCase(SIZE)) {
                    return Utils.toString(data.size(), SINGLE_SPACE);
                }
                if (tickType.equalsIgnoreCase(EXCHANGE)) {
                    return data.exchange();
                }
                if (tickType.equalsIgnoreCase(SPEC_COND)) {
                    return data.specialConditions();
                }
                if (tickType.equalsIgnoreCase(PAST_LIMIT)) {
                    return data.tickAttribLast().pastLimit() ? TRUE : SINGLE_SPACE;
                }
                if (tickType.equalsIgnoreCase(UNREPORTED)) {
                    return data.tickAttribLast().unreported() ? TRUE : SINGLE_SPACE;
                }
                if (tickType.equalsIgnoreCase(BID_PRICE)) {
                    return Utils.toString(data.bidPrice(), SINGLE_SPACE);
                }
                if (tickType.equalsIgnoreCase(BID_SIZE)) {
                    return Utils.toString(data.bidSize(), SINGLE_SPACE);
                }
                if (tickType.equalsIgnoreCase(ASK_PRICE)) {
                    return Utils.toString(data.askPrice(), SINGLE_SPACE);
                }
                if (tickType.equalsIgnoreCase(ASK_SIZE)) {
                    return Utils.toString(data.askSize(), SINGLE_SPACE);
                }
                if (tickType.equalsIgnoreCase(BID_PAST_LOW)) {
                    return data.tickAttribBidAsk().bidPastLow() ? TRUE : SINGLE_SPACE;
                }
                if (tickType.equalsIgnoreCase(ASK_PAST_HIGH)) {
                    return data.tickAttribBidAsk().askPastHigh() ? TRUE : SINGLE_SPACE;
                }
            }
        }
        return null;
    }

    /** Method updates tick-by-tick data and returns list of fields that were updated. List of fields is used to notify DDE. */
    public ArrayList<String> updateTickByTickData(TickByTickData tickByTickData) {
        
        ArrayList<String> fields = new ArrayList<String>();
        if (m_data.size() > 0) {
            TickByTickData prevData = m_data.get(0);
            if (tickByTickData.isAllLast() || tickByTickData.isMidPoint()) {
                    tickByTickData.setBidAskData(prevData.bidPrice(), prevData.askPrice(), prevData.bidSize(), prevData.askSize(), 
                            prevData.tickAttribBidAsk());
            } else if (tickByTickData.isBidAsk()) {
                    tickByTickData.setLastData(prevData.price(), prevData.size(), prevData.tickAttribLast(), prevData.exchange(), 
                            prevData.specialConditions());
            }
        }
        m_data.add(0, tickByTickData);

        // fields to update
        for (int i = 0; i < Math.min(m_data.size(), m_numberOfRows); i++) {
            TickByTickData data = m_data.get(i);
            if (data.isAllLast() || data.isMidPoint()) {
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + TIME);
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + PRICE);
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + SIZE);
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + EXCHANGE);
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + SPEC_COND);
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + PAST_LIMIT);
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + UNREPORTED);
            }
            if (data.isBidAsk()) {
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + TIME);
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + BID_PRICE);
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + BID_SIZE);
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + ASK_PRICE);
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + ASK_SIZE);
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + BID_PAST_LOW);
                fields.add(String.valueOf(i) + RequestParser.PARAM_SEPARATOR + ASK_PAST_HIGH);
            }
        }
        
        // remove old elements
        if (m_numberOfRows < m_data.size()) {
            for (int i = m_numberOfRows; i < m_data.size(); i++) {
                m_data.remove(i);
            }
        }
        
        return fields;
    }
}
