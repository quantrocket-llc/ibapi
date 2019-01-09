/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.util.ArrayList;

import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.socket2dde.data.PositionData;
import com.ib.api.dde.utils.Utils;

/** Class contains some utility methods related to positions requests */
public class PositionsUtils {

    /** Method creates single table row (array of strings) from PositionData */
    static ArrayList<String> createTableItem(PositionData positionData, DdeRequestType ddeRequestType, boolean isNew, boolean isPortfolio) {
        ArrayList<String> item = new ArrayList<String>();
        if (positionData.contract() != null) {
            item.add(Utils.toString(positionData.contract().symbol()));
            item.add(Utils.toString(positionData.contract().getSecType()));
            item.add(Utils.toString(positionData.contract().lastTradeDateOrContractMonth()));
            item.add(Utils.toString(positionData.contract().strike()));
            String right = positionData.contract().getRight();
            item.add(Utils.toString((Utils.isNotNull(right) && !right.equals("0")) ? right : ""));
            if (isNew) {
                item.add(Utils.toString(positionData.contract().multiplier()));
            }
            item.add(Utils.toString(positionData.contract().tradingClass()));
            if (isNew) {
                item.add(Utils.toString(isPortfolio ? positionData.contract().primaryExch() : positionData.contract().exchange()));
            }
            item.add(Utils.toString(positionData.contract().currency()));
            item.add(Utils.toString(positionData.contract().localSymbol()));
            if (isNew) {
                item.add(Utils.toString(positionData.contract().conid()));
            }
        } else {
            for (int j = 0; j < (isNew ? 11 : 8); j++) {
                item.add(Utils.toString(""));
            }
        }

        if (isNew) {
            item.add(Utils.toString(positionData.account()));
            if (ddeRequestType == DdeRequestType.REQ_POSITIONS_MULTI) {
                item.add(Utils.toString(positionData.modelCode()));
            }
            item.add(Utils.toString(positionData.position(), "0"));
            item.add(Utils.toString(positionData.avgCost(), "0"));
            
            if (ddeRequestType == DdeRequestType.REQ_ACCOUNT_PORTFOLIO) {
                item.add(Utils.toString(positionData.marketPrice(), "0"));
                item.add(Utils.toString(positionData.marketValue(), "0"));
                item.add(Utils.toString(positionData.unrealizedPNL(), "0"));
                item.add(Utils.toString(positionData.realizedPNL(), "0"));
            }
        } else {
            item.add(Utils.toString(positionData.position(), "0"));
            item.add(Utils.toString(positionData.marketPrice(), "0"));
            item.add(Utils.toString(positionData.marketValue(), "0"));
            item.add(Utils.toString(positionData.avgCost(), "0"));
            item.add(Utils.toString(positionData.unrealizedPNL(), "0"));
            item.add(Utils.toString(positionData.realizedPNL(), "0"));
            item.add(Utils.toString(positionData.account()));
        }

        return item;
    }

    /** Class used as key in positions list */
    public static class PositionKey implements Comparable<PositionKey> {
        private int m_conId;
        private String m_account;
        private String m_modelCode;
        
        // gets
        public int conId() { return m_conId; }
        public String account() { return m_account; }
        public String modelCode() { return m_modelCode; }
        
        public PositionKey(int conId, String account, String modelCode) {
            m_conId = conId;
            m_account = account;
            m_modelCode = modelCode;
        }
        
        @Override
        public int compareTo(PositionKey other) {
            int res = Utils.compare(String.valueOf(conId()), String.valueOf(other.conId()));
            if (res != Integer.MAX_VALUE) return res;
            res = Utils.compare(account(), other.account());
            if (res != Integer.MAX_VALUE) return res;
            return 0;
        }
    }
    
}
