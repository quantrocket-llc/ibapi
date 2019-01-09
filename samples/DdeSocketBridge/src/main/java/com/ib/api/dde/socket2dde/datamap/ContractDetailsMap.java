/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.datamap;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.client.ContractDetails;

/** Class represents contract details map received from TWS */
public class ContractDetailsMap extends BaseListDataMap<ContractDetails> {

    public final static String ORDER_TYPES = "orderTypes"; 
    public final static String VALID_EXCHANGES = "validExchanges"; 
    public final static String CON_ID = "conid"; 
    public final static String MIN_TICK = "minTick"; 
    public final static String MULTIPLIER = "multiplier"; 
    public final static String MARKET_NAME = "marketName"; 
    public final static String TRADING_CLASS = "tradingClass"; 
    public final static String SYMBOL = "symbol";
    public final static String COUPON = "coupon";
    public final static String MATURITY = "maturity";
    public final static String ISSUE_DATE = "issueDate";
    public final static String RATINGS = "ratings";
    public final static String BOND_TYPE = "bondType";
    public final static String COUPON_TYPE = "couponType";
    public final static String CONVERTIBLE = "convertible";
    public final static String CALLABLE = "callable";
    public final static String PUTABLE = "putable";
    public final static String DESC_APPEND = "descAppend";
    public final static String NEXT_OPTION_DATE = "nextOptionDate";
    public final static String NEXT_OPTION_TYPE = "nextOptionType";
    public final static String NEXT_OPTION_PARTIAL = "nextOptionPartial";
    public final static String NOTES = "notes";
    
    public ContractDetailsMap(DdeRequest ddeRequest){
        super(ddeRequest);
    }

    /** Method returns value for appropriate tick of first item from the list */
    public Object getValue(String tickType){
        ContractDetails contractDetails = null;
        if (m_list.size() > 0 ) {
            contractDetails = (ContractDetails)m_list.get(0);
        }
        if (contractDetails != null) {
            if (tickType.equalsIgnoreCase(ORDER_TYPES)) {
                return contractDetails.orderTypes();
            }
            if (tickType.equalsIgnoreCase(VALID_EXCHANGES)) {
                return contractDetails.validExchanges();
            }
            if (tickType.equalsIgnoreCase(CON_ID)) {
                return contractDetails.conid();
            }
            if (tickType.equalsIgnoreCase(MIN_TICK)) {
                return contractDetails.minTick();
            }
            if (tickType.equalsIgnoreCase(MULTIPLIER)) {
                return contractDetails.contract().multiplier();
            }
            if (tickType.equalsIgnoreCase(MARKET_NAME)) {
                return contractDetails.marketName();
            }
            if (tickType.equalsIgnoreCase(TRADING_CLASS)) {
                return contractDetails.contract().tradingClass();
            }
            if (tickType.equalsIgnoreCase(SYMBOL)) {
                return contractDetails.contract().symbol();
            }
            if (tickType.equalsIgnoreCase(COUPON)) {
                return contractDetails.coupon();
            }
            if (tickType.equalsIgnoreCase(MATURITY)) {
                return contractDetails.maturity();
            }
            if (tickType.equalsIgnoreCase(ISSUE_DATE)) {
                return contractDetails.issueDate();
            }
            if (tickType.equalsIgnoreCase(RATINGS)) {
                return contractDetails.ratings();
            }
            if (tickType.equalsIgnoreCase(BOND_TYPE)) {
                return contractDetails.bondType();
            }
            if (tickType.equalsIgnoreCase(COUPON_TYPE)) {
                return contractDetails.couponType();
            }
            if (tickType.equalsIgnoreCase(CONVERTIBLE)) {
                return contractDetails.convertible();
            }
            if (tickType.equalsIgnoreCase(CALLABLE)) {
                return contractDetails.callable();
            }
            if (tickType.equalsIgnoreCase(PUTABLE)) {
                return contractDetails.putable();
            }
            if (tickType.equalsIgnoreCase(DESC_APPEND)) {
                return contractDetails.descAppend();
            }
            if (tickType.equalsIgnoreCase(NEXT_OPTION_DATE)) {
                return contractDetails.nextOptionDate();
            }
            if (tickType.equalsIgnoreCase(NEXT_OPTION_TYPE)) {
                return contractDetails.nextOptionType();
            }
            if (tickType.equalsIgnoreCase(NEXT_OPTION_PARTIAL)) {
                return contractDetails.nextOptionPartial();
            }
            if (tickType.equalsIgnoreCase(NOTES)) {
                return contractDetails.notes();
            }
        }
        return null;
    }
}
