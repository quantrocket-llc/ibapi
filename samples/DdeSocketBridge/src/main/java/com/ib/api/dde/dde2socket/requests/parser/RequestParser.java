/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests.parser;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.socket2dde.notifications.DdeNotificationEvent;
import com.ib.api.dde.utils.Utils;
import com.ib.client.ComboLeg;
import com.ib.client.Contract;
import com.ib.client.DeltaNeutralContract;
import com.ib.client.TagValue;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

/** Class represents request parser and contains some request parsing methods */
public class RequestParser  {

    // constants
    public static final String DDE_REQUEST_SEPARATOR = "?";
    public static final String DDE_REQUEST_SEPARATOR_PARSE = "\\" + DDE_REQUEST_SEPARATOR;
    public static final String PARAM_SEPARATOR = "_";
    public static final String CONTRACT_DETAILS_SEPARATOR = "/";
    protected static final String EMPTY_STR_REPLACEMENT = "~";
    protected static final String COMBO_DELIMITER = "CMBLGS";
    protected static final String ID = "id";
    protected static final String EMPTY_STR = "";
    private static final String EQUALS_SIGN = "=";
    protected static final String SEMICOLON_SIGN = ";";
    public static final String ID_ZERO = ID + "0" + DDE_REQUEST_SEPARATOR;
    
    
    /** Method extracts request id from request string */
    public int getRequesIdFromString(String requestStr) {
        String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
        return parseRequestId(requestTokens[0]);
    }
    
    /** Method parses DDE request string to TickRequest */
    public TickRequest parseTickRequest(String requestStr, DdeRequestType ddeRequestType) {
        String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
        int requestId = parseRequestId(requestTokens[0]);
        String tickTypeStr = "";
        if (requestTokens.length > 1) {
            tickTypeStr = requestTokens[1];
        }
        return new TickRequest(requestId, tickTypeStr, ddeRequestType, requestStr);
    }
    
    /** Method parses DDE request string to DdeRequest */
    public DdeRequest parseRequest(String requestStr, DdeRequestType ddeRequestType) {
        int requestId = -1;
        String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
        if (requestTokens.length > 0) {
            requestId = parseRequestId(requestTokens[0]);
        }
        return new DdeRequest(requestId, ddeRequestType, requestStr);
    }

    /** Method parses TWS message/response to DDE notification event */
    public static DdeNotificationEvent createDdeNotificationEvent(String topic, String requestStr) {
        return new DdeNotificationEvent(topic, requestStr);
    }
    
    /** Method parses TWS message/response to DDE notification event */
    public static DdeNotificationEvent createDdeNotificationEvent(int reqId, String topic, String field) {
        String ddeRequestString = ID + reqId + DDE_REQUEST_SEPARATOR + field;
        return new DdeNotificationEvent(topic, ddeRequestString);
    }

    /** Method parses request id */
    protected int parseRequestId(String token) {
        return Integer.valueOf(token.substring(2));
    }

    /** Method parses contract */
    protected Contract parseContract(ArrayList<String> table, boolean hasPrimExchange, boolean hasComboLegs, boolean hasDeltaNeutral, boolean hasSecIdTypeAndSecId, boolean hasIncludeExpired) {
        Contract contract = new Contract();
        int size = 11;
        if (hasPrimExchange) {
            size += 1;
        }
        if (hasComboLegs) {
            size += 1;
        }
        if (hasDeltaNeutral) {
            size += 1;
        }
        if (hasSecIdTypeAndSecId) {
            size += 2;
        }
        if (hasIncludeExpired) {
            size += 1;
        }
        if (table.size() < size) {
            System.out.println("Cannot extract contract fields");
            return null;
        }
        int index = 0; 
        // use index because different requests has different fields 
        // e.g. reqMktData has comboLegsAndDeltaNeutral, but not secIdTypeAndSecId
        // placeOrder has both comboLegsAndDeltaNeutral and secIdTypeAndSecId
        // reqMktDepth has none of the above
        // reqContractDetails has only secIdTypeAndSecId
        if (Utils.isNotNull(table.get(index))) {
            contract.symbol(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.secType(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.lastTradeDateOrContractMonth(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.strike(getDoubleFromString(table.get(index)));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.right(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.multiplier(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.tradingClass(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.exchange(table.get(index));
        }
        index++;
        if (hasPrimExchange) {
            if (Utils.isNotNull(table.get(index))) {
                contract.primaryExch(table.get(index));
            }
            index++;
        }
        if (Utils.isNotNull(table.get(index))) {
            contract.currency(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.localSymbol(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.conid(getIntFromString(table.get(index)));
        }
        index++;

        if (hasComboLegs) {
            if (Utils.isNotNull(table.get(index))) {
                contract.comboLegs().addAll(parseComboLegs(table.get(index), true));
            }
            index++;
        }
        if (hasDeltaNeutral) {
            if (Utils.isNotNull(table.get(index))) {
                parseDeltaNeutral(contract, table.get(index));
            }
            index++;
        }
        if (hasSecIdTypeAndSecId) {
            if (Utils.isNotNull(table.get(index))) {
                contract.secIdType(table.get(index));
            }
            index++;
            if (Utils.isNotNull(table.get(index))) {
                contract.secId(table.get(index));
            }
            index++;
        }
        if (hasIncludeExpired) {
            if (Utils.isNotNull(table.get(index))) {
                contract.includeExpired(getBooleanFromString(table.get(index)));
            }
            index++;
        }
        
        return contract;
    }

    /** Method parses short contract */
    protected Contract parseShortContract(ArrayList<String> table) {
        Contract contract = new Contract();
        int size = 7;
        if (table.size() < size) {
            System.out.println("Cannot extract contract fields");
            return null;
        }
        int index = 0; 
        if (Utils.isNotNull(table.get(index))) {
            contract.symbol(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.secType(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.exchange(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.primaryExch(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.currency(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.localSymbol(table.get(index));
        }
        index++;
        if (Utils.isNotNull(table.get(index))) {
            contract.conid(getIntFromString(table.get(index)));
        }
        return contract;
    }
    
    /** Method parses combo legs */
    public static List<ComboLeg> parseComboLegs(String comboLegsStr, boolean isNew) {
        List<ComboLeg> comboLegs = new ArrayList<ComboLeg>();
        if (comboLegsStr != null && !comboLegsStr.isEmpty()) {
            StringTokenizer tokenizer = new StringTokenizer(comboLegsStr, PARAM_SEPARATOR);
            int numberOfLegs = 0;
            if (tokenizer.hasMoreElements()) {
                numberOfLegs = Integer.parseInt(tokenizer.nextToken());
            }
            if (tokenizer.hasMoreElements()) {
                for (int i = 0; i < numberOfLegs; i++) {
                    ComboLeg comboLeg = new ComboLeg();
                    String token = "";
                    if (tokenizer.hasMoreElements()) {
                        token = tokenizer.nextToken();
                        if (!token.equals(EMPTY_STR_REPLACEMENT)) { 
                            comboLeg.conid(Integer.parseInt(token));
                        }
                    }
                    if (tokenizer.hasMoreElements()) {
                        token = tokenizer.nextToken();
                        if (!token.equals(EMPTY_STR_REPLACEMENT)) { 
                            comboLeg.ratio(Integer.parseInt(token));
                        }
                    }
                    if (tokenizer.hasMoreElements()) {
                        token = tokenizer.nextToken();
                        if (!token.equals(EMPTY_STR_REPLACEMENT)) { 
                            comboLeg.action(token);
                        }
                    }
                    if (tokenizer.hasMoreElements()) {
                        token = tokenizer.nextToken();
                        if (!token.equals(EMPTY_STR_REPLACEMENT)) { 
                            comboLeg.exchange(token);
                        }
                    }
                    if (tokenizer.hasMoreElements()) {
                        token = tokenizer.nextToken();
                        if (!token.equals(EMPTY_STR_REPLACEMENT)) { 
                            comboLeg.openClose(Integer.parseInt(token));
                        }
                    }
                    if (isNew) {
                        if (tokenizer.hasMoreElements()) {
                            token = tokenizer.nextToken();
                            if (!token.equals(EMPTY_STR_REPLACEMENT)) { 
                                comboLeg.shortSaleSlot(Integer.parseInt(token));
                            }
                        }
                        if (tokenizer.hasMoreElements()) {
                            token = tokenizer.nextToken();
                            if (!token.equals(EMPTY_STR_REPLACEMENT)) { 
                                comboLeg.designatedLocation(token);
                            }
                        }
                        if (tokenizer.hasMoreElements()) {
                            token = tokenizer.nextToken();
                            if (!token.equals(EMPTY_STR_REPLACEMENT)) { 
                                comboLeg.exemptCode(Integer.parseInt(token));
                            }
                        }
                    }
                    comboLegs.add(comboLeg);
                }
            }
        }
        return comboLegs;
    }

    /** Method parses delta neutral */
    private void parseDeltaNeutral(Contract contract, String deltaNeutralStr) {
        if (deltaNeutralStr != null && !deltaNeutralStr.isEmpty()) {
            StringTokenizer tokenizer = new StringTokenizer(deltaNeutralStr, PARAM_SEPARATOR);
            DeltaNeutralContract deltaNeutralContract = new DeltaNeutralContract();
            if (tokenizer.hasMoreElements()) {
                deltaNeutralContract.conid(Integer.parseInt(tokenizer.nextToken()));
            }
            if (tokenizer.hasMoreElements()) {
                deltaNeutralContract.delta(Double.parseDouble(tokenizer.nextToken()));
            }
            if (tokenizer.hasMoreElements()) {
                deltaNeutralContract.price(Double.parseDouble(tokenizer.nextToken()));
            }
            contract.deltaNeutralContract(deltaNeutralContract);
        }
    }

    /** Method parses generic ticks */
    protected boolean parseSmartDepth(ArrayList<String> table) {
        if (table.size() < 13) {
            System.out.println("Cannot extract isSmartDepth");
            return false;
        }
        return getBooleanFromString(table.get(12));
    }
    
    /** Method parses generic ticks */
    protected String parseGenericTicks(ArrayList<String> table) {
        if (table.size() < 15) {
            System.out.println("Cannot extract generic ticks");
            return null;
        }
        return table.get(14);
    }

    /** Method parses tag/value string in format: "tag1=value1;tag2=valu2;" into List<TagValue> */
    protected List<TagValue> parseTagValueStr(String tagValueStr) {
        List<TagValue> tagValueList = new ArrayList<TagValue>();
        String[] splittedTagValueStr = tagValueStr.split(SEMICOLON_SIGN);
        for (String tagValueItem : splittedTagValueStr){
            String[] tagValueItemSplitted = tagValueItem.split(EQUALS_SIGN);
            if (tagValueItemSplitted.length >= 2) {
                tagValueList.add(new TagValue(tagValueItemSplitted[0], tagValueItemSplitted[1]));
            }
        }
        return tagValueList;
    }

    /** Method extracts integer from string */
    public static int getIntFromString(String str) {
        int ret = Integer.MAX_VALUE;
        if (str != null && !str.isEmpty()) {
            try {
                ret = Integer.parseInt(str);
            } catch (NumberFormatException e) {
                System.out.println("Error: " + e.getMessage());
            }
        }
        return ret;
    }

    /** Method extracts double from string */
    protected double getDoubleFromString(String str) {
        double ret = Double.MAX_VALUE;
        if (str != null && !str.isEmpty()) {
            try {
                ret = Double.parseDouble(str);
            } catch (NumberFormatException e) {
                System.out.println("Error: " + e.getMessage());
            }
        }
        return ret;
    }
    
    /** Method extracts boolean from string */
    protected boolean getBooleanFromString(String str) {
        boolean ret = false;
        if (str != null && !str.isEmpty()) {
            if (str.equalsIgnoreCase("true")) {
                return true;
            } else if (str.equalsIgnoreCase("false")) {
                return false;
            }
            try {
                ret = Integer.parseInt(str) == 1;
            } catch (NumberFormatException e) {
                System.out.println("Error: " + e.getMessage());
            }
        }
        return ret;
    }
}
