/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.handlers;

import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.marketdata.CalculateImpliedVolatilityRequest;
import com.ib.api.dde.dde2socket.requests.marketdata.CalculateOptionPriceRequest;
import com.ib.api.dde.dde2socket.requests.marketdata.MarketDataRequest;
import com.ib.api.dde.handlers.MarketDataHandler;
import com.ib.api.dde.old.requests.parser.OldRequestParser;
import com.ib.api.dde.socket2dde.datamap.MarketDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;
import com.ib.client.TagValue;
import com.ib.client.TickType;

/** Class handles old-style market data related requests, data and messages */
public class OldMarketDataHandler extends MarketDataHandler {

    private static final String GET = "get";
    private static final String MDOFF = "mdoff,";
    private static final String CUST_OPT_COMP_IMPLIED_VOL = "custOptCompImpliedVol";
    private static final String CUST_OPT_COMP_OPT_PRICE = "custOptCompOptPrice";

    // parser
    private MarketDataRequestParser m_requestParser = new MarketDataRequestParser();

    // mapping: newField -> <topic, oldField> (e.g. bidPrice -> <tik, bid>; lastRTHTrade -> <gentik, 318>; etc)
    private final Map<String, TagValue> m_fieldMap = new HashMap<String, TagValue>();
    
    public OldMarketDataHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
        
        // initialize map
        // ticks
        m_fieldMap.put(TickType.BID_SIZE.field(), new TagValue(DdeRequestType.TIK.topic(), "bidSize"));
        m_fieldMap.put(TickType.BID.field(), new TagValue(DdeRequestType.TIK.topic(), "bid"));
        m_fieldMap.put(TickType.ASK.field(), new TagValue(DdeRequestType.TIK.topic(), "ask"));
        m_fieldMap.put(TickType.ASK_SIZE.field(), new TagValue(DdeRequestType.TIK.topic(), "askSize"));
        m_fieldMap.put(TickType.LAST.field(), new TagValue(DdeRequestType.TIK.topic(), "last"));
        m_fieldMap.put(TickType.LAST_SIZE.field(), new TagValue(DdeRequestType.TIK.topic(), "lastSize"));
        m_fieldMap.put(TickType.HIGH.field(), new TagValue(DdeRequestType.TIK.topic(), "high"));
        m_fieldMap.put(TickType.LOW.field(), new TagValue(DdeRequestType.TIK.topic(), "low"));
        m_fieldMap.put(TickType.VOLUME.field(), new TagValue(DdeRequestType.TIK.topic(), "volume"));
        m_fieldMap.put(TickType.CLOSE.field(), new TagValue(DdeRequestType.TIK.topic(), "close"));
        // models
        m_fieldMap.put(TickType.BID_OPTION.field() + Utils.IMPLIED_VOL_STR, new TagValue(DdeRequestType.TIK.topic(), "bidImpliedVol"));
        m_fieldMap.put(TickType.BID_OPTION.field() + Utils.DELTA_STR, new TagValue(DdeRequestType.TIK.topic(), "bidDelta"));
        m_fieldMap.put(TickType.ASK_OPTION.field() + Utils.IMPLIED_VOL_STR, new TagValue(DdeRequestType.TIK.topic(), "askImpliedVol"));
        m_fieldMap.put(TickType.ASK_OPTION.field() + Utils.DELTA_STR, new TagValue(DdeRequestType.TIK.topic(), "askDelta"));
        m_fieldMap.put(TickType.LAST_OPTION.field() + Utils.IMPLIED_VOL_STR, new TagValue(DdeRequestType.TIK.topic(), "lastImpliedVol"));
        m_fieldMap.put(TickType.LAST_OPTION.field() + Utils.DELTA_STR, new TagValue(DdeRequestType.TIK.topic(), "lastDelta"));
        m_fieldMap.put(TickType.MODEL_OPTION.field() + Utils.IMPLIED_VOL_STR, new TagValue(DdeRequestType.TIK.topic(), "modelVolatility"));
        m_fieldMap.put(TickType.MODEL_OPTION.field() + Utils.DELTA_STR, new TagValue(DdeRequestType.TIK.topic(), "modelDelta"));
        m_fieldMap.put(TickType.MODEL_OPTION.field() + Utils.OPT_PRICE_STR, new TagValue(DdeRequestType.TIK.topic(), "modelPrice"));
        m_fieldMap.put(TickType.MODEL_OPTION.field() + Utils.PV_DIVIDEND_STR, new TagValue(DdeRequestType.TIK.topic(), "pvDividend"));
        m_fieldMap.put(TickType.MODEL_OPTION.field() + Utils.GAMMA_STR, new TagValue(DdeRequestType.TIK.topic(), "modelGamma"));
        m_fieldMap.put(TickType.MODEL_OPTION.field() + Utils.VEGA_STR, new TagValue(DdeRequestType.TIK.topic(), "modelVega"));
        m_fieldMap.put(TickType.MODEL_OPTION.field() + Utils.THETA_STR, new TagValue(DdeRequestType.TIK.topic(), "modelTheta"));
        m_fieldMap.put(TickType.MODEL_OPTION.field() + Utils.UND_PRICE_STR, new TagValue(DdeRequestType.TIK.topic(), "modelUndPrice"));
        // efp
        m_fieldMap.put(TickType.LAST_EFP_COMPUTATION.field() + Utils.HOLD_DAYS_STR, new TagValue(DdeRequestType.TIK.topic(), "HoldDays"));
        m_fieldMap.put(TickType.LAST_EFP_COMPUTATION.field() + Utils.FUTURE_EXPIRY_STR, new TagValue(DdeRequestType.TIK.topic(), "FuturesExpiry"));
        m_fieldMap.put(TickType.LAST_EFP_COMPUTATION.field() + Utils.DIVIDENDS_TO_EXPIRY_STR, new TagValue(DdeRequestType.TIK.topic(), "DividendsToExpiry"));
        m_fieldMap.put(TickType.BID_EFP_COMPUTATION.field() + Utils.BASIS_POINTS_STR, new TagValue(DdeRequestType.TIK.topic(), "BidEFPBasisPoints"));
        m_fieldMap.put(TickType.BID_EFP_COMPUTATION.field() + Utils.FORMATTED_BASIS_POINTS_STR, new TagValue(DdeRequestType.TIK.topic(), "BidEFPQuoteForm"));
        m_fieldMap.put(TickType.BID_EFP_COMPUTATION.field() + Utils.IMPLIED_FUTURE_STR, new TagValue(DdeRequestType.TIK.topic(), "BidEFPImpliedFuture"));
        m_fieldMap.put(TickType.BID_EFP_COMPUTATION.field() + Utils.DIVIDEND_IMPACT_STR, new TagValue(DdeRequestType.TIK.topic(), "BidEFPDividendImpact"));
        m_fieldMap.put(TickType.ASK_EFP_COMPUTATION.field() + Utils.BASIS_POINTS_STR, new TagValue(DdeRequestType.TIK.topic(), "AskEFPBasisPoints"));
        m_fieldMap.put(TickType.ASK_EFP_COMPUTATION.field() + Utils.FORMATTED_BASIS_POINTS_STR, new TagValue(DdeRequestType.TIK.topic(), "AskEFPQuoteForm"));
        m_fieldMap.put(TickType.ASK_EFP_COMPUTATION.field() + Utils.IMPLIED_FUTURE_STR, new TagValue(DdeRequestType.TIK.topic(), "AskEFPImpliedFuture"));
        m_fieldMap.put(TickType.ASK_EFP_COMPUTATION.field() + Utils.DIVIDEND_IMPACT_STR, new TagValue(DdeRequestType.TIK.topic(), "AskEFPDividendImpact"));
        m_fieldMap.put(TickType.LAST_EFP_COMPUTATION.field() + Utils.BASIS_POINTS_STR, new TagValue(DdeRequestType.TIK.topic(), "LastEFPBasisPoints"));
        m_fieldMap.put(TickType.LAST_EFP_COMPUTATION.field() + Utils.FORMATTED_BASIS_POINTS_STR, new TagValue(DdeRequestType.TIK.topic(), "LastEFPQuoteForm"));
        m_fieldMap.put(TickType.LAST_EFP_COMPUTATION.field() + Utils.IMPLIED_FUTURE_STR, new TagValue(DdeRequestType.TIK.topic(), "LastEFPImpliedFuture"));
        m_fieldMap.put(TickType.LAST_EFP_COMPUTATION.field() + Utils.DIVIDEND_IMPACT_STR, new TagValue(DdeRequestType.TIK.topic(), "LastEFPDividendImpact"));
        
        // generic ticks
        m_fieldMap.put(TickType.LAST_RTH_TRADE.field(), new TagValue(DdeRequestType.GEN_TIK.topic(), "318"));
    }
    
    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method handles tick request */
    public String handleTickRequest(String requestStr, boolean hasGenTicks) {
        System.out.println("Handling " + (hasGenTicks ? " generic" : " " ) + "tick request: " + requestStr);
        DdeRequest ddeRequest = m_requestParser.parseMarketDataTickRequest(requestStr, hasGenTicks);
        String ret = "";
        
        if (ddeRequest instanceof MarketDataRequest) {
            MarketDataRequest request = (MarketDataRequest)ddeRequest;
            clientSocket().reqMktData(request.requestId(), request.contract(), 
                    request.genericTicks(), request.snapshot(), false, null);
            MarketDataMap marketDataMap = new MarketDataMap(ddeRequest);
            m_marketDataRequests.put(request.requestId(), marketDataMap);
        } else if (ddeRequest instanceof TickRequest) {
            TickRequest tickRequest = (TickRequest)ddeRequest;
            MarketDataMap dataMap = m_marketDataRequests.get(tickRequest.requestId());
            ret = handleTickRequest(tickRequest, dataMap);
        }
        return ret;
    }
    
    /** Method handles calc impl vol request */
    public String handleCalcImplVolRequest(String requestStr) {
        System.out.println("Handling calc impl vol request: " + requestStr);
        CalculateImpliedVolatilityRequest ddeRequest = (CalculateImpliedVolatilityRequest)m_requestParser.parseCalcRequest(requestStr, DdeRequestType.CALC_IMPL_VOL);
        String ret = "";
        MarketDataMap data = m_marketDataRequests.get(ddeRequest.requestId());
        if(data != null) {
            Object value = data.getValue(CUST_OPT_COMP_IMPLIED_VOL);
            if(value != null) {
                ret = String.valueOf(value);
            }
        } else {
            clientSocket().calculateImpliedVolatility(ddeRequest.requestId(), ddeRequest.contract(), 
                    ddeRequest.optionPrice(), ddeRequest.underlyingPrice(), null);
            m_marketDataRequests.put(ddeRequest.requestId(), new MarketDataMap(ddeRequest));
        }
        return ret;
    }
    
    /** Method handles calc option price request */
    public String handleCalcOptionPriceRequest(String requestStr) {
        System.out.println("Handling calc option price request: " + requestStr);
        CalculateOptionPriceRequest ddeRequest = (CalculateOptionPriceRequest)m_requestParser.parseCalcRequest(requestStr, DdeRequestType.CALC_OPTION_PRICE);
        String ret = "";
        MarketDataMap data = m_marketDataRequests.get(ddeRequest.requestId());
        if(data != null) {
            Object value = data.getValue(CUST_OPT_COMP_OPT_PRICE);
            if(value != null) {
                ret = String.valueOf(value);
            }
        } else {
            clientSocket().calculateOptionPrice(ddeRequest.requestId(), ddeRequest.contract(), 
                    ddeRequest.impliedVolatility(), ddeRequest.underlyingPrice(), null);
            m_marketDataRequests.put(ddeRequest.requestId(), new MarketDataMap(ddeRequest));
        }
        return ret;
    }    
    
    /** Method stops tick advise loop */
    public void handleTickStopAdvise(String requestStr) {
        int requestId = m_requestParser.getRequesIdFromString(requestStr);
        if (m_marketDataRequests.containsKey(requestId)) {
            System.out.println("Handling tick stop advise: " + requestStr);
            clientSocket().cancelMktData(requestId);
            m_marketDataRequests.remove(requestId);
        }
    }    

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates market data for requestId */
    public void updateMarketData(int requestId, String fieldStr, Object value, DdeRequestStatus status) {
        MarketDataMap data = m_marketDataRequests.get(requestId);
        if(data != null) {
            TagValue tagValue = m_fieldMap.get(fieldStr);
            if (tagValue != null) {
                String oldTopic = m_fieldMap.get(fieldStr).m_tag;
                String oldField = m_fieldMap.get(fieldStr).m_value;
                data.setValue(oldField, value);
                notifyDde(requestId, oldTopic, oldField);
            }
        }
    }

    /** Method updates custom option computation for requestId */
    public void updateCustomOptionComputation(int requestId, String fieldStr, Object value, DdeRequestStatus status) {
        MarketDataMap data = m_marketDataRequests.get(requestId);
        if(data != null) {
            if (fieldStr.equals(CUST_OPT_COMP_IMPLIED_VOL)) {
                data.setValue(fieldStr, value);
                notifyDde(DdeRequestType.CALC_IMPL_VOL.topic(), data.ddeRequest().ddeRequestString());
            }
            if (fieldStr.equals(CUST_OPT_COMP_OPT_PRICE)) {
                data.setValue(fieldStr, value);
                notifyDde(DdeRequestType.CALC_OPTION_PRICE.topic(), data.ddeRequest().ddeRequestString());
            }
        }
    }
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class MarketDataRequestParser extends OldRequestParser {

        /** Method parses DDE request string to MarketDataTickRequest */
        public DdeRequest parseMarketDataTickRequest(String requestStr, boolean hasGenTicks) {
            // e.g.:
            // id0?req?EUR_CASH_IDEALPRO_USD_~/
            // id3?req?GOOG_OPT_20160115_570_C_100_SMART_USD_~_~/
            // id5?req2?ESU5_FUT_GLOBEX_USD_~/
            // id3?bidSize
            // id15?req?318?GE_STK_SMART_USD_~/
            // id37?req?IBM_BAG_IBEFP_USD_CMBLGS_2_336700314_1_BUY_SMART_0_8314_1_SELL_SMART_0_CMBLGS_~/
            int counter = 0;
            int requestId = -1;
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[counter++]);
            }
            String tickTypeStr = "";
            String genTicksStr = "";
            if (requestTokens.length > 1) {
                tickTypeStr = requestTokens[counter++];
            }
            if (hasGenTicks && requestTokens.length > 2){
                genTicksStr = MDOFF + requestTokens[counter++];
            }
            if (tickTypeStr.equals(DdeRequestType.REQ.topic()) || tickTypeStr.equals(DdeRequestType.REQ2.topic())) {
                String[] contractDetails = requestTokens[counter++].split(CONTRACT_DETAILS_SEPARATOR);
                String contractStr = "";
                if (contractDetails.length > 0) {
                    contractStr = contractDetails[0];
                }
                Contract contract = tickTypeStr.equals(DdeRequestType.REQ.topic()) ? parseContract(contractStr, false, true, false) : parseContract(contractStr, true, true, false);
                return new MarketDataRequest(requestId, contract, genTicksStr, false, requestStr);
            } else {
                return new TickRequest(requestId, tickTypeStr, DdeRequestType.TICK, requestStr);
            }
        }

        public DdeRequest parseCalcRequest(String requestStr, DdeRequestType ddeRequestType) {
            // e.g.: id14?get?1_10_BMW_OPT_20181116_76_C_100_DTB_EUR_~/
            int requestId = -1;
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            String tickTypeStr = "";
            if (requestTokens.length > 1) {
                tickTypeStr = requestTokens[1];
            }
            Contract contract = new Contract();
            double firstValue = 0;
            double secondValue = 0;
            if (tickTypeStr.equals(GET)) {
                String[] contractDetails = requestTokens[2].split(CONTRACT_DETAILS_SEPARATOR);
                String contractStr = "";
                if (contractDetails.length > 0) {
                    contractStr = contractDetails[0];
                    StringTokenizer st = new StringTokenizer(contractStr, PARAM_SEPARATOR);
                    try {
                        if (st.hasMoreElements()) {
                            firstValue = Double.parseDouble(st.nextToken());
                        }
                        if (st.hasMoreElements()) {
                            secondValue = Double.parseDouble(st.nextToken());
                        }
                        
                    } catch(NumberFormatException e) {
                        System.out.println(e.getMessage());
                    }
                    
                    int index = contractStr.indexOf(PARAM_SEPARATOR, contractStr.indexOf(PARAM_SEPARATOR) + 1);
                    contractStr = contractStr.substring(index + 1, contractStr.length());
                }
                if (Utils.isNotNull(contractStr)) {
                    contract = parseContract(contractStr, false, true, false);
                }
            }
            switch(ddeRequestType) {
                case CALC_IMPL_VOL: 
                    return new CalculateImpliedVolatilityRequest(requestId, contract, firstValue, secondValue, requestStr);
                case CALC_OPTION_PRICE:
                    return new CalculateOptionPriceRequest(requestId, contract, firstValue, secondValue, requestStr);
                default:
                    break;
            }
            return null;
        }
    }
}
