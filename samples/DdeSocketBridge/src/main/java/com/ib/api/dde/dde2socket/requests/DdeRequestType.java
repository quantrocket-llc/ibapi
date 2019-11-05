/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.dde2socket.requests;

/** Enum with DDE request types */
public enum DdeRequestType {

    NOTHING("nothing"),
    VALUE("value"),
    REQ("req"), // old-style
    REQ2("req2"), // old-style
    
    // errors
    ERROR("error"),
    REQUEST_ERRORS("reqErrors"),
    ERR("err"), // old-style
    ERR_ID("id"), // old-style
    ERR_CODE("errorCode"), // old-style
    ERR_MSG("errorMsg"), // old-style

    // market data
    REQUEST_MARKET_DATA("reqMktData"), 
    REQUEST_MARKET_DATA_LONG_VALUE("reqMktDataLongValue"), 
    CANCEL_MARKET_DATA("cancelMktData"),
    CALCULATE_IMPLIED_VOLATILITY("calculateImpliedVolatility"),
    CANCEL_CALCULATE_IMPLIED_VOLATILITY("cancelCalculateImpliedVolatility"),
    CALCULATE_IMPLIED_VOLATILITY_TICK("calculateImpliedVolatilityTick"),
    IMPLIED_VOLATILITY("impliedVolatility"),
    CALCULATE_OPTION_PRICE("calculateOptionPrice"),
    CANCEL_CALCULATE_OPTION_PRICE("cancelCalculateOptionPrice"),
    CALCULATE_OPTION_PRICE_TICK("calculateOptionPriceTick"),
    OPTION_PRICE("optionPrice"),
    
    // market data tick
    TICK("tick"), 
    TIK("tik"), // old-style 
    GEN_TIK("gentik"), // old-style
    CALC_IMPL_VOL("calcimplvol"), // old-style
    CALC_OPTION_PRICE("calcoptionprice"),  // old-style
    
    // place order
    PLACE_ORDER("placeOrder"),
    CANCEL_ORDER("cancelOrder"),
    CLEAR_ORDER("clearOrder"),
    GLOBAL_CANCEL("globalCancel"),
    ORD("ord"), // old-style

    // order status
    ORDER_STATUS("orderStatus"),
    STATUS("status"),
    FILLED("filled"),
    REMAINING("remaining"),
    AVG_FILL_PRICE("price"),
    LAST_FILL_PRICE("lastFillPrice"),
    WHY_HELD("whyHeld"),
    MKT_CAP_PRICE("mktCapPrice"),
    PARENT_ID("parentId"),
    CLIENT_ID("clientId"),
    PERM_ID("permId"),
    
    // open orders
    REQ_OPEN_ORDERS("reqOpenOrders"),
    REQ_ALL_OPEN_ORDERS("reqAllOpenOrders"),
    REQ_AUTO_OPEN_ORDERS("reqAutoOpenOrders"),
    CANCEL_OPEN_ORDERS("cancelOpenOrders"),
    OPENS("opens"), // old-style

    // positions
    REQ_POSITIONS("reqPositions"),
    CANCEL_POSITIONS("cancelPositions"),
    REQ_POSITIONS_MULTI("reqPositionsMulti"),
    REQ_POSITIONS_MULTI_ERROR("reqPositionsMultiError"),
    CANCEL_POSITIONS_MULTI("cancelPositionsMulti"),

    // executions
    REQ_EXECUTIONS("reqExecutions"),
    REQ_EXECUTIONS_ERROR("reqExecutionsError"),
    CANCEL_EXECUTIONS("cancelExecutions"),
    EXECS("execs"), // old-style

    // account updates multi
    REQ_ACCOUNT_UPDATES_MULTI("reqAccountUpdatesMulti"),
    REQ_ACCOUNT_UPDATES_MULTI_ERROR("reqAccountUpdatesMultiError"),
    CANCEL_ACCOUNT_UPDATES_MULTI("cancelAccountUpdatesMulti"),
    REQ_ACCOUNT_UPDATE_TIME("reqAccountUpdateTime"),
    
    // account summary
    REQ_ACCOUNT_SUMMARY("reqAccountSummary"),
    REQ_ACCOUNT_SUMMARY_ERROR("reqAccountSummaryError"),
    CANCEL_ACCOUNT_SUMMARY("cancelAccountSummary"),

    // account + portfolio updates
    REQ_ACCOUNT_PORTFOLIO("reqAccountPortfolio"),
    REQ_PORTFOLIO("reqPortfolio"),
    REQ_ACCOUNT_PORTFOLIO_ERROR("reqAccountPortfolioError"),
    CANCEL_ACCOUNT_PORTFOLIO("cancelAccountPortfolio"),
    ACCT("acct"), // old-style
    ACCTS("accts"), // old-style
    PORTS("ports"), // old-style
    FAACCTS("FAaccts"), // old-style
    
    // market depth
    REQUEST_MARKET_DEPTH("reqMktDepth"),
    CANCEL_MARKET_DEPTH("cancelMktDepth"),
    MARKET_DEPTH_TICK("mktDepthTick"),
    MKTDEPTH("mktDepth"), // old-style
    
    // market depth exchanges
    REQUEST_MARKET_DEPTH_EXCHANGES("reqMktDepthExchanges"),
    
    // log level
    LOG_LEVEL("logLevel"),
    
    // news
    REQ_NEWS_BULLETINS("reqNewsBulletins"),
    CANCEL_NEWS_BULLETINS("cancelNewsBulletins"),
    NEWS("news"), // old-style
    NEWS_SUB("sub"), // old-style
    NEWS_MSG("msg"), // old-style
    
    // news ticks
    REQ_NEWS_TICKS("reqNewsTicks"),
    CANCEL_NEWS_TICKS("cancelNewsTicks"),
    NEWS_TICKS_TICK("newsTicksTick"),
    
    // news providers
    REQ_NEWS_PROVIDERS("reqNewsProviders"),
    
    // market scanner
    REQUEST_SCANNER_SUBSCRIPTION("reqScannerSubscription"),
    CANCEL_SCANNER_SUBSCRIPTION("cancelScannerSubscription"),
    SCANNER_SUBSCRIPTION_TICK("scannerSubscriptionTick"),
    REQUEST_SCANNER_PARAMETERS("reqScannerParameters"),
    SCAN("scan"), // old-style
    
    // contract details
    REQUEST_CONTRACT_DETAILS("reqContractDetails"),
    CANCEL_CONTRACT_DETAILS("cancelContractDetails"),
    CONTRACT_DETAILS_TICK("contractDetailsTick"),
    CONTRACT("contract"), // old-style

    // historical data
    REQUEST_HISTORICAL_DATA("reqHistoricalData"),
    CANCEL_HISTORICAL_DATA("cancelHistoricalData"),
    HISTORICAL_DATA_TICK("historicalDataTick"),
    HIST("hist"), // old-style
    
    // real time bars
    REQUEST_REAL_TIME_BARS("reqRealTimeBars"),
    CANCEL_REAL_TIME_BARS("cancelRealTimeBars"),
    REAL_TIME_BARS_TICK("realTimeBarsTick"),

    // tick-by-tick
    REQUEST_TICK_BY_TICK_DATA("reqTickByTickData"),
    CANCEL_TICK_BY_TICK_DATA("cancelTickByTickData"),
    TICK_BY_TICK_DATA_TICK("tickByTickDataTick"),
    REQUEST_TICK_BY_TICK_DATA_EXT("reqTickByTickDataExt"),
    CANCEL_TICK_BY_TICK_DATA_EXT("cancelTickByTickDataExt"),
    TICK_BY_TICK_DATA_TICK_EXT("tickByTickDataTickExt"),

    // fundamental data
    REQUEST_FUNDAMENTAL_DATA("reqFundamentalData"),
    CANCEL_FUNDAMENTAL_DATA("cancelFundamentalData"),
    FUNDAMENTAL_DATA_TICK("fundamentalDataTick"),
    
    // historical ticks
    REQUEST_HISTORICAL_TICKS("reqHistoricalTicks"),
    CANCEL_HISTORICAL_TICKS("cancelHistoricalTicks"),
    HISTORICAL_TICKS_TICK("historicalTicksTick"),

    // security definition option parameters
    REQUEST_SEC_DEF_OPT_PARAMS("reqSecDefOptParams"),
    CANCEL_SEC_DEF_OPT_PARAMS("cancelSecDefOptParams"),
    SEC_DEF_OPT_PARAMS_TICK("secDefOptParamsTick"),
    
    // family codes
    REQUEST_FAMILY_CODES("reqFamilyCodes"),

    // managed accounts
    REQUEST_MANAGED_ACCOUNTS("reqManagedAccounts"),

    // head timestamp
    REQUEST_HEAD_TIMESTAMP("reqHeadTimestamp"),
    CANCEL_HEAD_TIMESTAMP("cancelHeadTimestamp"),
    HEAD_TIMESTAMP_TICK("headTimestampTick"),
    HEAD_TIMESTAMP("headTimestamp"),
    
    // matching symbols
    REQUEST_MATCHING_SYMBOLS("reqMatchingSymbols"),
    REQUEST_MATCHING_SYMBOLS_ERROR("reqMatchingSymbolsError"),
    CANCEL_MATCHING_SYMBOLS("cancelMatchingSymbols"),
    
    // historical news
    REQUEST_HISTORICAL_NEWS("reqHistoricalNews"),
    CANCEL_HISTORICAL_NEWS("cancelHistoricalNews"),
    HISTORICAL_NEWS_TICK("historicalNewsTick"),
    
    // news article
    REQUEST_NEWS_ARTICLE("reqNewsArticle"),
    CANCEL_NEWS_ARTICLE("cancelNewsArticle"),
    NEWS_ARTICLE_TICK("newsArticleTick"),
    NEWS_ARTICLE("newsArticle"),
    REQUEST_NEWS_ARTICLE_LONG_VALUE("reqNewsArticleLongValue"), 
    
    // PnL
    REQUEST_PNL("reqPnL"),
    CANCEL_PNL("cancelPnL"),
    PNL_TICK("PnLTick"),

    // exericse options
    EXERCISE_OPTIONS("exerciseOptions"),
    EXERCISE_OPTIONS_TICK("exerciseOptionsTick"),
    
    // current time
    REQ_CURRENT_TIME("reqCurrentTime"),
    
    // market rule
    REQUEST_MARKET_RULE("reqMarketRule"),
    REQUEST_MARKET_RULE_ERROR("reqMarketRuleError"),

    // smart components
    REQUEST_SMART_COMPONENTS("reqSmartComponents"),
    REQUEST_SMART_COMPONENTS_ERROR("reqSmartComponentsError"),
    
    // soft dollar tiers
    REQUEST_SOFT_DOLLAR_TIERS("reqSoftDollarTiers"),
    
    // histogram data
    REQUEST_HISTOGRAM_DATA("reqHistogramData"),
    CANCEL_HISTOGRAM_DATA("cancelHistogramData"),
    HISTOGRAM_DATA_TICK("histogramDataTick"),

    // financial advisor
    REQUEST_FA("reqFA"),
    REQUEST_FA_ERROR("reqFAError"),
    REPLACE_FA("replaceFA"),
    REPLACE_FA_ERROR("replaceFAError"),

    // completed orders
    REQ_COMPLETED_ORDERS("reqCompletedOrders"),

    // other old-style requests (not supported anymore)
    PROCESS_RATE("processRate"),
    REFRESH_RATE("refreshRate");
    
    private final String m_topic;

    private DdeRequestType(String topic) {
        m_topic = topic;
    }

    public String topic() {
        return m_topic;
    }

    public static DdeRequestType getRequestType(String topic) {
        for (DdeRequestType type: values()) {
            if (type.topic().equals(topic)) {
                return type;
            }
        }
        return NOTHING;
    }
}
