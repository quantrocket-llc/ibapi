/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.util.ArrayList;

import com.ib.api.dde.socket2dde.data.ExecutionData;
import com.ib.api.dde.utils.Utils;

/** Class contains some utility methods related to executions requests */
public class ExecutionsUtils {

    /** Method creates single table row (array of strings) from ExecutionData */
    static ArrayList<String> createTableItem(ExecutionData executionData, boolean isNew) {
        ArrayList<String> item = new ArrayList<String>();

        if (executionData.contract() != null) {
            item.add(Utils.toString(executionData.contract().symbol()));
            item.add(Utils.toString(executionData.contract().getSecType()));
            item.add(Utils.toString(executionData.contract().lastTradeDateOrContractMonth()));
            item.add(Utils.toString(executionData.contract().strike()));
            item.add(Utils.toString(executionData.contract().getRight()));
            if (isNew) {
                item.add(Utils.toString(executionData.contract().multiplier()));
            }
            item.add(Utils.toString(executionData.contract().tradingClass()));
            item.add(Utils.toString(executionData.contract().exchange()));
            item.add(Utils.toString(executionData.contract().currency()));
            if (isNew) {
                item.add(Utils.toString(executionData.contract().localSymbol()));
                item.add(Utils.toString(executionData.contract().conid()));
            }
        } else {
            for (int j = 0; j < (isNew ? 11 : 8); j++) {
                item.add(Utils.toString(""));
            }
        }

        item.add(Utils.toString(executionData.execution().orderId()));
        item.add(Utils.toString(executionData.execution().execId()));
        item.add(Utils.toString(executionData.execution().time()));
        item.add(Utils.toString(executionData.execution().acctNumber()));
        if (isNew) {
            item.add(Utils.toString(executionData.execution().modelCode()));
        }
        item.add(Utils.toString(executionData.execution().exchange()));
        item.add(Utils.toString(executionData.execution().side()));
        item.add(Utils.toString(executionData.execution().shares()));
        item.add(Utils.toString(executionData.execution().price()));
        item.add(Utils.toString(executionData.execution().permId()));
        if (isNew) {
            item.add(Utils.toString(executionData.execution().clientId()));
        }
        item.add(Utils.toString(executionData.execution().liquidation()));
        if (isNew) {
            item.add(Utils.toString(executionData.execution().cumQty()));
            item.add(Utils.toString(executionData.execution().avgPrice()));
        }
        item.add(Utils.toString(executionData.execution().orderRef()));
        if (isNew) {
            item.add(Utils.toString(executionData.execution().evRule()));
            item.add(Utils.toString(executionData.execution().evMultiplier()));
            item.add(Utils.toString(executionData.execution().lastLiquidityStr()));
        }
        if (!isNew) {
            item.add("");
        }
            
        if (isNew) {
            if (executionData.commissionReport() != null) {
                item.add(Utils.toString(executionData.commissionReport().commission()));
                item.add(Utils.toString(executionData.commissionReport().currency()));
                item.add(Utils.toString(executionData.commissionReport().realizedPNL()));
                item.add(Utils.toString(executionData.commissionReport().yield()));
                item.add(Utils.toString(executionData.commissionReport().yieldRedemptionDate()));
            } else {
                for (int j = 0; j < 5; j++) {
                    item.add(Utils.toString(""));
                }
            }
        }

        return item;
    }
}
