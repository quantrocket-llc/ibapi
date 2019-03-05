/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.util.ArrayList;

import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.utils.Utils;
import com.ib.client.ContractDescription;
import com.ib.client.ContractDetails;
import com.ib.client.PriceIncrement;

/** Class contains some utility methods related to contract details */
public class ContractDetailsUtils {
    
    /** Method creates single table row (array of strings) from ContractDescription */
    static ArrayList<String> createTableItem(ContractDescription contractDescription) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(contractDescription.contract().conid()));
        item.add(Utils.toString(contractDescription.contract().symbol()));
        item.add(Utils.toString(contractDescription.contract().getSecType()));
        item.add(Utils.toString(contractDescription.contract().primaryExch()));
        item.add(Utils.toString(contractDescription.contract().currency()));
        item.add(String.join(",", contractDescription.derivativeSecTypes()));
        return item;
    }
    
    /** Method creates single table row (array of strings) from ContractDetails */
    static ArrayList<String> createTableItem(ContractDetails contractDetails) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(contractDetails.contract().symbol()));
        item.add(Utils.toString(contractDetails.contract().getSecType()));
        item.add(Utils.toString(contractDetails.contract().lastTradeDateOrContractMonth()));
        item.add(Utils.toString(contractDetails.contract().strike()));
        item.add(Utils.toString(contractDetails.contract().getRight()));
        item.add(Utils.toString(contractDetails.contract().exchange()));
        item.add(Utils.toString(contractDetails.contract().currency()));
        item.add(Utils.toString(contractDetails.contract().localSymbol()));
        item.add(Utils.toString(contractDetails.marketName()));
        item.add(Utils.toString(contractDetails.contract().tradingClass()));
        item.add(Utils.toString(contractDetails.contract().conid()));
        item.add(Utils.toString(contractDetails.minTick()));
        item.add(Utils.toString(contractDetails.mdSizeMultiplier()));
        item.add(Utils.toString(contractDetails.contract().multiplier()));
        if (Utils.isNotNull(contractDetails.orderTypes())) {
            item.add(Utils.LONGVALUE + RequestParser.PARAM_SEPARATOR + Utils.toString(Utils.calcNumOfChunks(contractDetails.orderTypes(), 255)));
            item.addAll(Utils.chunkStringByLength(contractDetails.orderTypes(), 255)); // long string
        }
        if (Utils.isNotNull(contractDetails.validExchanges())) {
            item.add(Utils.LONGVALUE + RequestParser.PARAM_SEPARATOR + Utils.toString(Utils.calcNumOfChunks(contractDetails.validExchanges(), 255)));
            item.addAll(Utils.chunkStringByLength(contractDetails.validExchanges(), 255)); // long string
        }
        item.add(Utils.toString(contractDetails.priceMagnifier()));
        item.add(Utils.toString(contractDetails.underConid()));
        item.add(Utils.toString(contractDetails.longName()));
        item.add(Utils.toString(contractDetails.contract().primaryExch()));
        item.add(Utils.toString(contractDetails.contractMonth()));
        item.add(Utils.toString(contractDetails.industry()));
        item.add(Utils.toString(contractDetails.category()));
        item.add(Utils.toString(contractDetails.subcategory()));
        item.add(Utils.toString(contractDetails.timeZoneId()));
        if (Utils.isNotNull(contractDetails.tradingHours())) {
            item.add(Utils.LONGVALUE + RequestParser.PARAM_SEPARATOR + Utils.toString(Utils.calcNumOfChunks(contractDetails.tradingHours(), 255)));
            item.addAll(Utils.chunkStringByLength(contractDetails.tradingHours(), 255)); // long string
        }
        if (Utils.isNotNull(contractDetails.liquidHours())) {
            item.add(Utils.LONGVALUE + RequestParser.PARAM_SEPARATOR + Utils.toString(Utils.calcNumOfChunks(contractDetails.liquidHours(), 255)));
            item.addAll(Utils.chunkStringByLength(contractDetails.liquidHours(), 255)); // long string
        }
        item.add(Utils.toString(contractDetails.evRule()));
        item.add(Utils.toString(contractDetails.evMultiplier()));
        item.add(Utils.tagValueListToString(contractDetails.secIdList()));
        item.add(Utils.toString(contractDetails.aggGroup()));
        item.add(Utils.toString(contractDetails.underSymbol()));
        item.add(Utils.toString(contractDetails.underSecType()));
        item.add(Utils.toString(contractDetails.marketRuleIds()));
        item.add(Utils.toString(contractDetails.realExpirationDate()));
        return item;
    }
    
    /** Method creates single table row (array of strings) from ContractDetails for bond, bill, fixed sectype */
    static ArrayList<String> createTableItemFixedIncome(ContractDetails contractDetails) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(contractDetails.contract().symbol()));
        item.add(Utils.toString(contractDetails.contract().getSecType()));
        item.add(Utils.toString(contractDetails.cusip()));
        item.add(Utils.toString(contractDetails.coupon()));
        item.add(Utils.toString(contractDetails.maturity()));
        item.add(Utils.toString(contractDetails.lastTradeTime()));
        item.add(Utils.toString(contractDetails.timeZoneId()));
        item.add(Utils.toString(contractDetails.issueDate()));
        item.add(Utils.toString(contractDetails.ratings()));
        item.add(Utils.toString(contractDetails.bondType()));
        item.add(Utils.toString(contractDetails.couponType()));
        item.add(Utils.toString(contractDetails.convertible()));
        item.add(Utils.toString(contractDetails.callable()));
        item.add(Utils.toString(contractDetails.putable()));
        item.add(Utils.toString(contractDetails.descAppend()));
        item.add(Utils.toString(contractDetails.contract().exchange()));
        item.add(Utils.toString(contractDetails.contract().currency()));
        item.add(Utils.toString(contractDetails.marketName()));
        item.add(Utils.toString(contractDetails.contract().tradingClass()));
        item.add(Utils.toString(contractDetails.contract().conid()));
        item.add(Utils.toString(contractDetails.minTick()));
        item.add(Utils.toString(contractDetails.mdSizeMultiplier()));
        if (Utils.isNotNull(contractDetails.orderTypes())) {
            item.add(Utils.LONGVALUE + RequestParser.PARAM_SEPARATOR + Utils.toString(Utils.calcNumOfChunks(contractDetails.orderTypes(), 255)));
            item.addAll(Utils.chunkStringByLength(contractDetails.orderTypes(), 255)); // long string
        }
        if (Utils.isNotNull(contractDetails.validExchanges())) {
            item.add(Utils.LONGVALUE + RequestParser.PARAM_SEPARATOR + Utils.toString(Utils.calcNumOfChunks(contractDetails.validExchanges(), 255)));
            item.addAll(Utils.chunkStringByLength(contractDetails.validExchanges(), 255)); // long string
        }
        item.add(Utils.toString(contractDetails.nextOptionDate()));
        item.add(Utils.toString(contractDetails.nextOptionType()));
        item.add(Utils.toString(contractDetails.nextOptionPartial()));
        item.add(Utils.toString(contractDetails.notes()));
        item.add(Utils.toString(contractDetails.longName()));
        item.add(Utils.toString(contractDetails.evRule()));
        item.add(Utils.toString(contractDetails.evMultiplier()));
        item.add(Utils.tagValueListToString(contractDetails.secIdList()));
        item.add(Utils.toString(contractDetails.aggGroup()));
        item.add(Utils.toString(contractDetails.marketRuleIds()));
        return item;
    }
    
    /** Method creates single table row (array of strings) from PriceIncrement */
    static ArrayList<String> createTableItem(PriceIncrement priceIncrement) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(priceIncrement.lowEdge(), "0"));
        item.add(Utils.toString(priceIncrement.increment()));
        return item;
    }
    
}
