/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.requests.parser;

import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.old.utils.OldUtils;
import com.ib.client.Contract;
import java.util.StringTokenizer;

/** Class represents request parser and contains some request parsing methods */
public class OldRequestParser extends RequestParser {

    public static String getString(String str) {
        return str.replaceAll("singleSpace", " ").replaceAll("singleColon", ":");
    }
    
    protected String getParameter(StringTokenizer st) {
        if (st.hasMoreElements()) {
            String token = st.nextToken();
            if (!token.equals(EMPTY_STR_REPLACEMENT)) {
                return token;
            }
        }
        return "";
    }
    
    public Contract parseContract(String contractStr, boolean useLocalSymbol, boolean hasPrimExch, boolean hasExpired) {
        
        Contract contract = new Contract();
        StringTokenizer st = new StringTokenizer(contractStr, PARAM_SEPARATOR);
        String nextToken = null;
        if (useLocalSymbol) {
            // local symbol
            contract.localSymbol(OldRequestParser.getString(st.nextToken()));
            contract.secType(st.nextToken());
        } else {
            contract.symbol(OldRequestParser.getString(st.nextToken()));
            contract.secType(st.nextToken());
            
            if (OldUtils.isExpDeriv(contract.secType())) {
                contract.lastTradeDateOrContractMonth(st.nextToken());
            }
            if (OldUtils.isOpt(contract.secType())) {
                contract.strike(Double.parseDouble(st.nextToken()));
                contract.right(st.nextToken());
            }
            
            if (OldUtils.isExpDeriv(contract.secType())) {
                nextToken = st.nextToken();
                try {
                    Double.parseDouble(nextToken);
                    contract.multiplier(nextToken);
                    nextToken = null;
                } catch(NumberFormatException ex){
                    // do nothing - multiplier is optional
                }
            }
        }
        if (nextToken == null) {
            nextToken = st.nextToken();
        }
        
        contract.exchange(nextToken);
        contract.currency(st.nextToken());
        
        String test = null;
        if (st.hasMoreElements()) {
            test = st.nextToken();
        }
        // combo legs
        if (test != null && test.equalsIgnoreCase(RequestParser.COMBO_DELIMITER)) {
            String comboLegsStr = contractStr.substring(contractStr.indexOf(RequestParser.COMBO_DELIMITER) + RequestParser.COMBO_DELIMITER.length() + 1, 
                    contractStr.lastIndexOf(RequestParser.COMBO_DELIMITER) - 1);
            contract.comboLegs().addAll(RequestParser.parseComboLegs(comboLegsStr, false));
            
            while(st.hasMoreElements()) {
                if (st.nextToken().equalsIgnoreCase(RequestParser.COMBO_DELIMITER)) {
                    break;
                }
            }
            if (st.hasMoreElements()) {
                test = st.nextToken();
            } else {
                test = null;
            }
        }
        // primary exchange
        if (test != null && hasPrimExch) {
            contract.primaryExch(test.equals(RequestParser.EMPTY_STR_REPLACEMENT) ? "" : test);
            test = null;
        }
        // include expired
        if (test == null && st.hasMoreElements()) {
            test = st.nextToken();
        }
        if (test != null && hasExpired) {
            contract.includeExpired(!(test.equals(RequestParser.EMPTY_STR_REPLACEMENT) || test.equalsIgnoreCase("false")));
        }
        // trading class
        if (st.hasMoreElements()){
            if (OldUtils.isExpDeriv(contract.secType())) {
                test = st.nextToken();
                contract.tradingClass(test.equals(RequestParser.EMPTY_STR_REPLACEMENT) ? "" : test);
            }
        }
        
        return contract;
    }    

}
