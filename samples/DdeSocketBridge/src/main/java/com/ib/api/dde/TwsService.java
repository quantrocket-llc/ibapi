/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.handlers.AccountPortfolioHandler;
import com.ib.api.dde.handlers.AccountSummaryHandler;
import com.ib.api.dde.handlers.AccountUpdatesMultiHandler;
import com.ib.api.dde.handlers.CalcImplVolOptPriceHandler;
import com.ib.api.dde.handlers.ContractDetailsHandler;
import com.ib.api.dde.handlers.ErrorsHandler;
import com.ib.api.dde.handlers.ExecutionsHandler;
import com.ib.api.dde.handlers.ExerciseOptionsHandler;
import com.ib.api.dde.handlers.FundamentalDataHandler;
import com.ib.api.dde.handlers.HeadTimestampHandler;
import com.ib.api.dde.handlers.HistogramDataHandler;
import com.ib.api.dde.handlers.HistoricalDataHandler;
import com.ib.api.dde.handlers.HistoricalTicksHandler;
import com.ib.api.dde.handlers.MarketDataHandler;
import com.ib.api.dde.handlers.MarketDepthHandler;
import com.ib.api.dde.handlers.MatchingSymbolsHandler;
import com.ib.api.dde.handlers.MiscHandler;
import com.ib.api.dde.handlers.NewsDataHandler;
import com.ib.api.dde.handlers.OrdersHandler;
import com.ib.api.dde.handlers.PnLHandler;
import com.ib.api.dde.handlers.PositionsHandler;
import com.ib.api.dde.handlers.PositionsMultiHandler;
import com.ib.api.dde.handlers.RealTimeBarsHandler;
import com.ib.api.dde.handlers.ScannerDataHandler;
import com.ib.api.dde.handlers.SecDefOptParamsHandler;
import com.ib.api.dde.handlers.TickByTickDataHandler;
import com.ib.api.dde.old.handlers.OldAccountPortfolioHandler;
import com.ib.api.dde.old.handlers.OldContractDetailsHandler;
import com.ib.api.dde.old.handlers.OldErrorsHandler;
import com.ib.api.dde.old.handlers.OldExecutionsHandler;
import com.ib.api.dde.old.handlers.OldHistoricalDataHandler;
import com.ib.api.dde.old.handlers.OldMarketDataHandler;
import com.ib.api.dde.old.handlers.OldMarketDepthHandler;
import com.ib.api.dde.old.handlers.OldMiscHandler;
import com.ib.api.dde.old.handlers.OldNewsHandler;
import com.ib.api.dde.old.handlers.OldOrdersHandler;
import com.ib.api.dde.old.handlers.OldScannerDataHandler;
import com.ib.api.dde.socket2dde.data.AccountUpdateData;
import com.ib.api.dde.socket2dde.data.ErrorData;
import com.ib.api.dde.socket2dde.data.ExecutionData;
import com.ib.api.dde.socket2dde.data.MarketDepthData;
import com.ib.api.dde.socket2dde.data.NewsBulletinData;
import com.ib.api.dde.socket2dde.data.NewsData;
import com.ib.api.dde.socket2dde.data.OpenOrderData;
import com.ib.api.dde.socket2dde.data.OrderStatusData;
import com.ib.api.dde.socket2dde.data.PositionData;
import com.ib.api.dde.socket2dde.data.ScannerData;
import com.ib.api.dde.socket2dde.data.SecDefOptParamsData;
import com.ib.api.dde.socket2dde.data.TickByTickData;
import com.ib.api.dde.socket2dde.notifications.DdeNotificationEvent;
import com.ib.api.impl.EWrapperImpl;
import com.ib.client.Bar;
import com.ib.client.CommissionReport;
import com.ib.client.ContractDescription;
import com.ib.client.ContractDetails;
import com.ib.client.DepthMktDataDescription;
import com.ib.client.EClientSocket;
import com.ib.client.EReader;
import com.ib.client.EReaderSignal;
import com.ib.client.FamilyCode;
import com.ib.client.HistogramEntry;
import com.ib.client.NewsProvider;
import com.ib.client.PriceIncrement;
import com.ib.client.SoftDollarTier;
import com.ib.client.TickType;

/** Class represents TwsService. Connection to TWS is performed here. */
public class TwsService {

    private final String m_host;
    private final int m_port;
    private final int m_clientId;
    private final EWrapperImpl m_wrapper;
    private final SocketDdeBridge m_socketDdeBridge;

    private final ErrorsHandler m_errorsHandler;
    private final MarketDataHandler m_marketDataHandler;
    private final OrdersHandler m_ordersHandler;
    private final PositionsHandler m_positionsHandler;
    private final PositionsMultiHandler m_positionsMultiHandler;
    private final ExecutionsHandler m_executionsHandler;
    private final AccountUpdatesMultiHandler m_accountUpdatesMultiHandler;
    private final AccountSummaryHandler m_accountSummaryHandler;
    private final AccountPortfolioHandler m_accountPortfolioHandler;
    private final MarketDepthHandler m_marketDepthHandler;
    private final ScannerDataHandler m_scannerDataHandler;
    private final ContractDetailsHandler m_contractDetailsHandler;
    private final HistoricalDataHandler m_historicalDataHandler;
    private final RealTimeBarsHandler m_realTimeBarsHandler;
    private final TickByTickDataHandler m_tickByTickDataHandler;
    private final FundamentalDataHandler m_fundamentalDataHandler;
    private final HistoricalTicksHandler m_historicalTicksHandler;
    private final SecDefOptParamsHandler m_secDefOptParamsHandler;
    private final HeadTimestampHandler m_headTimestampHandler;
    private final MatchingSymbolsHandler m_matchingSymbolsHandler;
    private final NewsDataHandler m_newsDataHandler;
    private final PnLHandler m_pnlHandler;
    private final CalcImplVolOptPriceHandler m_calcImplVolOptPriceHandler;
    private final ExerciseOptionsHandler m_exerciseOptionsHandler;
    private final MiscHandler m_miscHandler;
    private final HistogramDataHandler m_histogramDataHandler;
    
    // old-style
    private final OldMarketDataHandler m_oldMarketDataHandler;
    private final OldErrorsHandler m_oldErrorsHandler;
    private final OldNewsHandler m_oldNewsHandler;
    private final OldOrdersHandler m_oldOrdersHandler;
    private final OldExecutionsHandler m_oldExecutionsHandler;
    private final OldAccountPortfolioHandler m_oldAccountPortfolioHandler;
    private final OldMarketDepthHandler m_oldMarketDepthHandler;
    private final OldScannerDataHandler m_oldScannerDataHandler;
    private final OldContractDetailsHandler m_oldContractDetailsHandler;
    private final OldHistoricalDataHandler m_oldHistoricalDataHandler;
    private final OldMiscHandler m_oldMiscHandler;

    public TwsService(String host, int port, int clientId, SocketDdeBridge bridge) {
        m_host = host;
        m_port = port;
        m_clientId = clientId;
        m_socketDdeBridge = bridge;
        m_wrapper = new EWrapperImpl(this);
        m_errorsHandler = new ErrorsHandler(this);
        m_marketDataHandler = new MarketDataHandler(m_wrapper, this);
        m_ordersHandler = new OrdersHandler(m_wrapper, this);
        m_positionsHandler = new PositionsHandler(m_wrapper, this);
        m_positionsMultiHandler = new PositionsMultiHandler(m_wrapper, this);
        m_executionsHandler = new ExecutionsHandler(m_wrapper, this);
        m_accountUpdatesMultiHandler = new AccountUpdatesMultiHandler(m_wrapper, this);
        m_accountSummaryHandler = new AccountSummaryHandler(m_wrapper, this);
        m_accountPortfolioHandler = new AccountPortfolioHandler(m_wrapper, this);
        m_marketDepthHandler = new MarketDepthHandler(m_wrapper, this);
        m_scannerDataHandler = new ScannerDataHandler(m_wrapper, this);
        m_contractDetailsHandler = new ContractDetailsHandler(m_wrapper, this);
        m_historicalDataHandler = new HistoricalDataHandler(m_wrapper, this);
        m_realTimeBarsHandler = new RealTimeBarsHandler(m_wrapper, this);
        m_tickByTickDataHandler = new TickByTickDataHandler(m_wrapper, this);
        m_fundamentalDataHandler = new FundamentalDataHandler(m_wrapper, this);
        m_historicalTicksHandler = new HistoricalTicksHandler(m_wrapper, this);
        m_secDefOptParamsHandler = new SecDefOptParamsHandler(m_wrapper, this);
        m_headTimestampHandler = new HeadTimestampHandler(m_wrapper, this);
        m_matchingSymbolsHandler = new MatchingSymbolsHandler(m_wrapper, this);
        m_newsDataHandler = new NewsDataHandler(m_wrapper, this);
        m_pnlHandler = new PnLHandler(m_wrapper, this);
        m_calcImplVolOptPriceHandler = new CalcImplVolOptPriceHandler(m_wrapper, this);
        m_exerciseOptionsHandler = new ExerciseOptionsHandler(m_wrapper, this);
        m_miscHandler = new MiscHandler(m_wrapper, this);
        m_histogramDataHandler = new HistogramDataHandler(m_wrapper, this);

        // old-style
        m_oldMarketDataHandler = new OldMarketDataHandler(m_wrapper, this);
        m_oldErrorsHandler = new OldErrorsHandler(this);
        m_oldNewsHandler = new OldNewsHandler(m_wrapper, this);
        m_oldOrdersHandler = new OldOrdersHandler(m_wrapper, this);
        m_oldExecutionsHandler = new OldExecutionsHandler(m_wrapper, this);
        m_oldAccountPortfolioHandler = new OldAccountPortfolioHandler(m_wrapper, this);
        m_oldMarketDepthHandler = new OldMarketDepthHandler(m_wrapper, this);
        m_oldScannerDataHandler = new OldScannerDataHandler(m_wrapper, this);
        m_oldContractDetailsHandler = new OldContractDetailsHandler(m_wrapper, this);
        m_oldHistoricalDataHandler = new OldHistoricalDataHandler(m_wrapper, this);
        m_oldMiscHandler = new OldMiscHandler(m_wrapper, this);

    }

    /** Method sends DDE message to TWS */
    public String sendDdeToTws(String topic, String requestStr) {
        m_miscHandler.resetAccountTime();
        m_oldMiscHandler.resetAccountTime();
        
        DdeRequestType requestType = DdeRequestType.getRequestType(topic);
        switch(requestType) {
            case ORDER_STATUS:
                return m_ordersHandler.handleOrderStatusRequest(requestStr);
            case TICK:
                return m_marketDataHandler.handleTickRequest(requestStr);
            case REQUEST_ERRORS:
                return m_errorsHandler.handleErrorRequest(requestStr);
            case REQ_OPEN_ORDERS:
                return m_ordersHandler.handleOpenOrdersRequest(requestStr, false);
            case REQ_ALL_OPEN_ORDERS:
                return m_ordersHandler.handleOpenOrdersRequest(requestStr, true);
            case REQ_POSITIONS:
                return m_positionsHandler.handlePositionsRequest(requestStr);
            case REQ_POSITIONS_MULTI:
                return m_positionsMultiHandler.handlePositionsMultiRequest(requestStr);
            case REQ_POSITIONS_MULTI_ERROR:
                return m_positionsMultiHandler.handlePositionsErrorRequest(requestStr, DdeRequestType.REQ_POSITIONS_MULTI_ERROR);
            case REQ_EXECUTIONS:
                return m_executionsHandler.handleExecutionsRequest(requestStr);
            case REQ_EXECUTIONS_ERROR:
                return m_executionsHandler.handleExecutionsErrorRequest(requestStr);
            case REQ_ACCOUNT_UPDATES_MULTI:
                return m_accountUpdatesMultiHandler.handleAccountUpdatesMultiRequest(requestStr);
            case REQ_ACCOUNT_UPDATES_MULTI_ERROR:
                return m_accountUpdatesMultiHandler.handleAccountUpdatesErrorRequest(requestStr, DdeRequestType.REQ_ACCOUNT_UPDATES_MULTI_ERROR);
            case REQ_ACCOUNT_UPDATE_TIME:
                return m_miscHandler.handleAccountUpdateTimeRequest();
            case REQ_ACCOUNT_SUMMARY:
                return m_accountSummaryHandler.handleAccountSummaryRequest(requestStr);
            case REQ_ACCOUNT_SUMMARY_ERROR:
                return m_accountSummaryHandler.handleAccountUpdatesErrorRequest(requestStr, DdeRequestType.REQ_ACCOUNT_SUMMARY_ERROR);
            case REQ_ACCOUNT_PORTFOLIO:
                return m_accountPortfolioHandler.handleAccountPortfolioRequest(requestStr);
            case REQ_ACCOUNT_PORTFOLIO_ERROR:
                return m_accountPortfolioHandler.handleAccountUpdatesErrorRequest(requestStr, DdeRequestType.REQ_ACCOUNT_PORTFOLIO_ERROR);
            case MARKET_DEPTH_TICK:
                return m_marketDepthHandler.handleMktDepthTickRequest(requestStr);
            case SCANNER_SUBSCRIPTION_TICK:
                return m_scannerDataHandler.handleScannerSubscriptionTickRequest(requestStr);
            case CONTRACT_DETAILS_TICK:
                return m_contractDetailsHandler.handleContractDetailsTickRequest(requestStr);
            case REQUEST_SCANNER_PARAMETERS:
                return m_scannerDataHandler.handleScannerParametersRequest(requestStr);
            case HISTORICAL_DATA_TICK:
                return m_historicalDataHandler.handleHistoricalDataTickRequest(requestStr);
            case REAL_TIME_BARS_TICK:
                return m_realTimeBarsHandler.handleRealTimeBarsTickRequest(requestStr);
            case TICK_BY_TICK_DATA_TICK:
                return m_tickByTickDataHandler.handleTickByTickDataTickRequest(requestStr);
            case TICK_BY_TICK_DATA_TICK_EXT:
                return m_tickByTickDataHandler.handleTickByTickDataTickRequestExt(requestStr);
            case FUNDAMENTAL_DATA_TICK:
                return m_fundamentalDataHandler.handleFundamentalDataTickRequest(requestStr);
            case HISTORICAL_TICKS_TICK:
                return m_historicalTicksHandler.handleHistoricalTicksTickRequest(requestStr);
            case SEC_DEF_OPT_PARAMS_TICK:
                return m_secDefOptParamsHandler.handleSecDefOptParamsTickRequest(requestStr);
            case REQUEST_FAMILY_CODES:
                return m_accountUpdatesMultiHandler.handleFamilyCodesRequest(requestStr);
            case REQUEST_MANAGED_ACCOUNTS:
                return m_miscHandler.handleManagedAccountsRequest(requestStr);
            case HEAD_TIMESTAMP_TICK:
                return m_headTimestampHandler.handleHeadTimestampTickRequest(requestStr);
            case REQUEST_MATCHING_SYMBOLS:
                return m_matchingSymbolsHandler.handleMatchingSymbolsRequest(requestStr);
            case REQUEST_MATCHING_SYMBOLS_ERROR:
                return m_matchingSymbolsHandler.handleMatchingSymbolsErrorRequest(requestStr);
            case REQUEST_MARKET_DEPTH_EXCHANGES:
                return m_marketDepthHandler.handleMktDepthExchangesRequest(requestStr);
            case NEWS_TICKS_TICK:
                return m_newsDataHandler.handleNewsTicksTickRequest(requestStr);
            case REQ_NEWS_PROVIDERS:
                return m_newsDataHandler.handleNewsProvidersRequest(requestStr);
            case HISTORICAL_NEWS_TICK:
                return m_newsDataHandler.handleHistoricalNewsTickRequest(requestStr);
            case NEWS_ARTICLE_TICK:
                return m_newsDataHandler.handleNewsArticleTickRequest(requestStr);
            case REQ_NEWS_BULLETINS:
                return m_newsDataHandler.handleNewsBulletinsRequest(requestStr);
            case PNL_TICK:
                return m_pnlHandler.handlePnLTickRequest(requestStr);
            case CALCULATE_IMPLIED_VOLATILITY_TICK:
                return m_calcImplVolOptPriceHandler.handleCalculateTickRequest(requestStr, DdeRequestType.CALCULATE_IMPLIED_VOLATILITY_TICK);
            case CALCULATE_OPTION_PRICE_TICK:
                return m_calcImplVolOptPriceHandler.handleCalculateTickRequest(requestStr, DdeRequestType.CALCULATE_OPTION_PRICE_TICK);
            case EXERCISE_OPTIONS_TICK:
                return m_exerciseOptionsHandler.handleExerciseOptionsTickRequest(requestStr);
            case REQ_CURRENT_TIME:
                return m_miscHandler.handleCurrentTimeRequest();
            case REQUEST_MARKET_RULE:
                return m_contractDetailsHandler.handleMarketRuleRequest(requestStr);
            case REQUEST_MARKET_RULE_ERROR:
                return m_contractDetailsHandler.handleMarketRuleErrorRequest(requestStr);
            case REQUEST_SMART_COMPONENTS:
                return m_miscHandler.handleSmartComponentsRequest(requestStr);
            case REQUEST_SMART_COMPONENTS_ERROR:
                return m_miscHandler.handleSmartComponentsErrorRequest(requestStr);
            case REQUEST_SOFT_DOLLAR_TIERS:
                return m_miscHandler.handleSoftDollarTiersRequest(requestStr);
            case HISTOGRAM_DATA_TICK:
                return m_histogramDataHandler.handleHistogramDataTickRequest(requestStr);
            case REQUEST_FA:
                return m_accountUpdatesMultiHandler.handleFARequest(requestStr);
            case REQUEST_FA_ERROR:
                return m_accountUpdatesMultiHandler.handleFARequestError(requestStr);
            case REPLACE_FA:
                return m_accountUpdatesMultiHandler.handleFAReplaceStatus(requestStr);
            case REPLACE_FA_ERROR:
                return m_accountUpdatesMultiHandler.handleFAReplaceError(requestStr);
                
            // old-style
            case TIK:
                return m_oldMarketDataHandler.handleTickRequest(requestStr, false);
            case ERR:
                return m_oldErrorsHandler.handleErrorRequest(requestStr);
            case GEN_TIK:
                return m_oldMarketDataHandler.handleTickRequest(requestStr, true);
            case PROCESS_RATE:
                return "Setting processing rate is not supported";
            case REFRESH_RATE:
                return "Setting refresh rate is not supported";
            case LOG_LEVEL:
                setServerLogLevel(requestStr);
                return requestStr;
            case CALC_IMPL_VOL:
                return m_oldMarketDataHandler.handleCalcImplVolRequest(requestStr);
            case CALC_OPTION_PRICE:
                return m_oldMarketDataHandler.handleCalcOptionPriceRequest(requestStr);
            case NEWS:
                return m_oldNewsHandler.handleNewsBulletinsRequest(requestStr);
            case ORD:
                return m_oldOrdersHandler.handlePlaceOrderRequest(requestStr);
            case OPENS:
                return m_oldOrdersHandler.handleOpenOrdersRequest(requestStr);
            case EXECS:
                return m_oldExecutionsHandler.handleExecutionsRequest(requestStr);
            case ACCT:
                return m_oldMiscHandler.handleAccountUpdateTimeRequest();
            case ACCTS:
                return m_oldAccountPortfolioHandler.handleAccountDataRequest(requestStr);
            case PORTS:
                return m_oldAccountPortfolioHandler.handlePortfolioRequest(requestStr);
            case FAACCTS:
                return m_oldMiscHandler.handleManagedAccountsRequestOld(requestStr);
            case MKTDEPTH:
                return m_oldMarketDepthHandler.handleMktDepthTickRequest(requestStr);
            case SCAN:
                return m_oldScannerDataHandler.handleScannerSubscriptionRequest(requestStr);
            case CONTRACT:
                return m_oldContractDetailsHandler.handleContractDetailsTickRequest(requestStr);
            case HIST:
                return m_oldHistoricalDataHandler.handleHistoricalDataRequest(requestStr);
                
            default:
                break;
        }

        return DdeRequestStatus.UNKNOWN.name();
    }

    /** Method sends DDE message to TWS with binary data */
    public byte[] sendDdeToTwsWithData(String topic, String requestStr, byte[] data) {
        DdeRequestType requestType = DdeRequestType.getRequestType(topic);
        switch(requestType) {
            case PLACE_ORDER:
                return m_ordersHandler.handlePlaceOrderRequest(requestStr, data);
            case CANCEL_ORDER:
                return m_ordersHandler.handleCancelOrderRequest(requestStr);
            case CLEAR_ORDER:
                return m_ordersHandler.handleClearOrderRequest(requestStr);
            case REQUEST_MARKET_DATA:
                return m_marketDataHandler.handleMarketDataRequest(requestStr, data);
            case REQUEST_MARKET_DATA_LONG_VALUE:
                return m_marketDataHandler.handleTickLongValueRequest(requestStr);
            case CANCEL_MARKET_DATA:
                return m_marketDataHandler.handleMktDataCancel(requestStr);
            case REQUEST_ERRORS:
                return m_errorsHandler.handleErrorsArrayRequest(requestStr);
            case REQ_OPEN_ORDERS:
                return m_ordersHandler.handleOpenOrdersArrayRequest(requestStr);
            case REQ_ALL_OPEN_ORDERS:
                return m_ordersHandler.handleAllOpenOrdersArrayRequest(requestStr);
            case REQ_AUTO_OPEN_ORDERS:
                return m_ordersHandler.handleAutoOpenOrdersRequest(requestStr);
            case CANCEL_OPEN_ORDERS:
                return m_ordersHandler.handleOpenOrdersCancel(requestStr);
            case REQ_POSITIONS:
                return m_positionsHandler.handlePositionsArrayRequest(requestStr);
            case CANCEL_POSITIONS:
                return m_positionsHandler.handlePositionsCancel(requestStr);
            case REQ_POSITIONS_MULTI:
                return m_positionsMultiHandler.handlePositionsMultiArrayRequest(requestStr);
            case CANCEL_POSITIONS_MULTI:
                return m_positionsMultiHandler.handlePositionsMultiCancel(requestStr);
            case REQ_EXECUTIONS:
                return m_executionsHandler.handleExecutionsArrayRequest(requestStr);
            case CANCEL_EXECUTIONS:
                return m_executionsHandler.handleExecutionsCancelRequest(requestStr);
            case REQ_ACCOUNT_UPDATES_MULTI:
                return m_accountUpdatesMultiHandler.handleAccountUpdatesMultiArrayRequest(requestStr);
            case CANCEL_ACCOUNT_UPDATES_MULTI:
                return m_accountUpdatesMultiHandler.handleAccountUpdatesMultiCancel(requestStr);
            case REQ_ACCOUNT_SUMMARY:
                if (data == null) {
                    return m_accountSummaryHandler.handleAccountSummaryArrayRequest(requestStr);
                } else {
                    return m_accountSummaryHandler.handleAccountSummaryRequestWithData(requestStr, data);
                }
            case CANCEL_ACCOUNT_SUMMARY:
                return m_accountSummaryHandler.handleAccountSummaryCancel(requestStr);
            case REQ_ACCOUNT_PORTFOLIO:
                return m_accountPortfolioHandler.handleAccountPortfolioArrayRequest(requestStr);
            case CANCEL_ACCOUNT_PORTFOLIO:
                return m_accountPortfolioHandler.handleAccountPortfolioCancel(requestStr);
            case REQ_PORTFOLIO:
                return m_accountPortfolioHandler.handlePortfolioArrayRequest(requestStr);
            case REQUEST_MARKET_DEPTH:
                return m_marketDepthHandler.handleMarketDepthRequest(requestStr, data);
            case CANCEL_MARKET_DEPTH:
                return m_marketDepthHandler.handleMktDepthCancel(requestStr);
            case REQUEST_SCANNER_SUBSCRIPTION:
                if (data == null) {
                    return m_scannerDataHandler.handleScannerDataArrayRequest(requestStr);
                    
                } else {
                    return m_scannerDataHandler.handleScannerSubscriptionRequest(requestStr, data);
                }
            case CANCEL_SCANNER_SUBSCRIPTION:
                return m_scannerDataHandler.handleScannerSubscriptionCancel(requestStr);
            case REQUEST_SCANNER_PARAMETERS:
                return m_scannerDataHandler.handleScannerParametersArrayRequest(requestStr);
            case REQUEST_CONTRACT_DETAILS:
                if (data == null) {
                    return m_contractDetailsHandler.handleContractDetailsArrayRequest(requestStr);
                } else {
                    return m_contractDetailsHandler.handleContractDetailsRequest(requestStr, data);
                }
            case CANCEL_CONTRACT_DETAILS:
                return m_contractDetailsHandler.handleContractDetailsCancel(requestStr);
            case REQUEST_HISTORICAL_DATA:
                if (data == null) {
                    return m_historicalDataHandler.handleHistoricalDataArrayRequest(requestStr);
                } else {
                    return m_historicalDataHandler.handleHistoricalDataRequest(requestStr, data);
                }
            case CANCEL_HISTORICAL_DATA:
                return m_historicalDataHandler.handleHistoricalDataCancel(requestStr);
            case REQUEST_REAL_TIME_BARS:
                if (data == null) {
                    return m_realTimeBarsHandler.handleRealTimeBarsArrayRequest(requestStr);
                } else {
                    return m_realTimeBarsHandler.handleRealTimeBarsRequest(requestStr, data);
                }
            case CANCEL_REAL_TIME_BARS:
                return m_realTimeBarsHandler.handleRealTimeBarsCancel(requestStr);
            case REQUEST_TICK_BY_TICK_DATA:
                return m_tickByTickDataHandler.handleTickByTickDataRequest(requestStr, data);
            case CANCEL_TICK_BY_TICK_DATA:
                return m_tickByTickDataHandler.handleTickByTickDataCancel(requestStr);
            case REQUEST_TICK_BY_TICK_DATA_EXT:
                return m_tickByTickDataHandler.handleTickByTickDataRequestExt(requestStr, data);
            case CANCEL_TICK_BY_TICK_DATA_EXT:
                return m_tickByTickDataHandler.handleTickByTickDataCancelExt(requestStr);
            case REQUEST_FUNDAMENTAL_DATA:
                if (data == null) {
                    return m_fundamentalDataHandler.handleFundamentalDataArrayRequest(requestStr);
                } else {
                    return m_fundamentalDataHandler.handleFundamentalDataRequest(requestStr, data);
                }
            case CANCEL_FUNDAMENTAL_DATA:
                return m_fundamentalDataHandler.handleFundamentalDataCancel(requestStr);
            case REQUEST_HISTORICAL_TICKS:
                if (data == null) {
                    return m_historicalTicksHandler.handleHistoricalTicksArrayRequest(requestStr);
                } else {
                    return m_historicalTicksHandler.handleHistoricalTicksRequest(requestStr, data);
                }
            case CANCEL_HISTORICAL_TICKS:
                return m_historicalTicksHandler.handleHistoricalTicksCancel(requestStr);
            case REQUEST_SEC_DEF_OPT_PARAMS:
                if (data == null) {
                    return m_secDefOptParamsHandler.handleSecDefOptParamsArrayRequest(requestStr);
                } else {
                    return m_secDefOptParamsHandler.handleSecDefOptParamsRequest(requestStr, data);
                }
            case CANCEL_SEC_DEF_OPT_PARAMS:
                return m_secDefOptParamsHandler.handleSecDefOptParamsCancel(requestStr);
            case REQUEST_FAMILY_CODES:
                return m_accountUpdatesMultiHandler.handleFamilyCodesArrayRequest(requestStr);
            case REQUEST_MANAGED_ACCOUNTS:
                return m_miscHandler.handleManagedAccountsLongValueRequest(requestStr);
            case REQUEST_HEAD_TIMESTAMP:
                return m_headTimestampHandler.handleHeadTimestampRequest(requestStr, data);
            case CANCEL_HEAD_TIMESTAMP:
                return m_headTimestampHandler.handleHeadTimestampCancel(requestStr);
            case REQUEST_MATCHING_SYMBOLS:
                return m_matchingSymbolsHandler.handleMatchingSymbolsArrayRequest(requestStr);
            case CANCEL_MATCHING_SYMBOLS:
                return m_matchingSymbolsHandler.handleMatchingSymbolsCancel(requestStr);
            case REQUEST_MARKET_DEPTH_EXCHANGES:
                return m_marketDepthHandler.handleMktDepthExchangesArrayRequest(requestStr);
            case REQ_NEWS_TICKS:
                if (data == null) {
                    return m_newsDataHandler.handleNewsTicksArrayRequest(requestStr);
                } else {
                    return m_newsDataHandler.handleNewsTicksRequest(requestStr, data);
                }
            case CANCEL_NEWS_TICKS:
                return m_newsDataHandler.handleNewsTicksCancel(requestStr);
            case REQ_NEWS_PROVIDERS:
                return m_newsDataHandler.handleNewsProvidersArrayRequest(requestStr);
            case REQUEST_HISTORICAL_NEWS:
                if (data == null) {
                    return m_newsDataHandler.handleHistoricalNewsArrayRequest(requestStr);
                } else {
                    return m_newsDataHandler.handleHistoricalNewsRequest(requestStr, data);
                }
            case CANCEL_HISTORICAL_NEWS:
                return m_newsDataHandler.handleHistoricalNewsCancel(requestStr);
            case REQUEST_NEWS_ARTICLE:
                return m_newsDataHandler.handleNewsArticleRequest(requestStr, data);
            case CANCEL_NEWS_ARTICLE:
                return m_newsDataHandler.handleNewsArticleCancel(requestStr);
            case REQUEST_NEWS_ARTICLE_LONG_VALUE:
                return m_newsDataHandler.handleNewsArticleLongValueRequest(requestStr);
            case REQ_NEWS_BULLETINS:
                return m_newsDataHandler.handleNewsBulletinsArrayRequest(requestStr);
            case REQUEST_PNL:
                return m_pnlHandler.handlePnLRequest(requestStr, data);
            case CANCEL_PNL:
                return m_pnlHandler.handlePnLCancel(requestStr);
            case GLOBAL_CANCEL:
                return m_ordersHandler.handleGlobalCancel(requestStr);
            case CALCULATE_IMPLIED_VOLATILITY:
                return m_calcImplVolOptPriceHandler.handleCalculateRequest(requestStr, data, DdeRequestType.CALCULATE_IMPLIED_VOLATILITY);
            case CANCEL_CALCULATE_IMPLIED_VOLATILITY:
                return m_calcImplVolOptPriceHandler.handleCalculateCancel(requestStr, DdeRequestType.CANCEL_CALCULATE_IMPLIED_VOLATILITY);
            case CALCULATE_OPTION_PRICE:
                return m_calcImplVolOptPriceHandler.handleCalculateRequest(requestStr, data, DdeRequestType.CALCULATE_OPTION_PRICE);
            case CANCEL_CALCULATE_OPTION_PRICE:
                return m_calcImplVolOptPriceHandler.handleCalculateCancel(requestStr, DdeRequestType.CANCEL_CALCULATE_OPTION_PRICE);
            case EXERCISE_OPTIONS:
                return m_exerciseOptionsHandler.handleExerciseOptionsRequest(requestStr, data);
            case REQ_CURRENT_TIME:
                m_miscHandler.handleCurrentTimeRequest();
                break;
            case REQUEST_MARKET_RULE:
                return m_contractDetailsHandler.handleMarketRuleArrayRequest(requestStr);
            case REQUEST_SMART_COMPONENTS:
                return m_miscHandler.handleSmartComponentsArrayRequest(requestStr);
            case REQUEST_SOFT_DOLLAR_TIERS:
                return m_miscHandler.handleSoftDollarTiersArrayRequest(requestStr);
            case REQUEST_HISTOGRAM_DATA:
                if (data == null) {
                    return m_histogramDataHandler.handleHistogramDataArrayRequest(requestStr);
                } else {
                    return m_histogramDataHandler.handleHistogramDataRequest(requestStr, data);
                }
            case CANCEL_HISTOGRAM_DATA:
                return m_histogramDataHandler.handleHistogramDataCancel(requestStr);
            case REQUEST_FA:
                return m_accountUpdatesMultiHandler.handleFARequestArray(requestStr);
            case REPLACE_FA:
                return m_accountUpdatesMultiHandler.handleFAReplace(requestStr, data);
                
            // old-style
            case OPENS:
                return m_oldOrdersHandler.handleOpenOrdersArrayRequest(requestStr);
            case EXECS:
                return m_oldExecutionsHandler.handleExecutionsArrayRequest(requestStr);
            case ACCTS:
                return m_oldAccountPortfolioHandler.handleAccountDataArrayRequest(requestStr);
            case PORTS:
                return m_oldAccountPortfolioHandler.handlePortfolioArrayRequest(requestStr);
            case SCAN:
                return m_oldScannerDataHandler.handleScannerDataArrayRequest(requestStr);
            case HIST:
                return m_oldHistoricalDataHandler.handleHistoricalDataArrayRequest(requestStr);
                
            default:
                break;
        }

        return null;
    }

    /** Method stops DDE advise loop */
    public void stopAdviseDde(String topic, String requestStr) {
        DdeRequestType requestType = DdeRequestType.getRequestType(topic);
        switch(requestType) {
            case REQ_POSITIONS:
                m_positionsHandler.handlePositionsCancel(requestStr);
                break;
            case REQ_POSITIONS_MULTI:
                m_positionsMultiHandler.handlePositionsMultiCancel(requestStr);
                break;
            case REQ_EXECUTIONS:
                m_executionsHandler.handleExecutionsCancelRequest(requestStr);
                break;
            case REQ_ACCOUNT_UPDATES_MULTI:
                m_accountUpdatesMultiHandler.handleAccountUpdatesMultiCancel(requestStr);
                break;
            case REQ_ACCOUNT_SUMMARY:
                m_accountSummaryHandler.handleAccountSummaryCancel(requestStr);
                break;
            case REQ_OPEN_ORDERS:
                m_ordersHandler.handleOpenOrdersCancel(requestStr);
                break;
            case REQ_ACCOUNT_PORTFOLIO:
                m_accountPortfolioHandler.handleAccountPortfolioCancel(requestStr);
                break;
            case MARKET_DEPTH_TICK:
                m_marketDepthHandler.handleMktDepthStopAdvise(requestStr);
                break;
            case TICK:
                if (!requestStr.contains(TickType.FUNDAMENTAL_RATIOS.field())) {
                    m_marketDataHandler.handleMktDataCancel(requestStr);
                }
                break;
            case SCANNER_SUBSCRIPTION_TICK:
                m_scannerDataHandler.handleScannerSubscriptionCancel(requestStr);
                break;
            case CONTRACT_DETAILS_TICK:
                m_contractDetailsHandler.handleContractDetailsCancel(requestStr);
                break;
            case HISTORICAL_DATA_TICK:
                m_historicalDataHandler.handleHistoricalDataCancel(requestStr);
                break;
            case REAL_TIME_BARS_TICK:
                m_realTimeBarsHandler.handleRealTimeBarsCancel(requestStr);
                break;
            case TICK_BY_TICK_DATA_TICK:
                m_tickByTickDataHandler.handleTickByTickDataCancel(requestStr);
                break;
            case TICK_BY_TICK_DATA_TICK_EXT:
                m_tickByTickDataHandler.handleTickByTickDataCancelExt(requestStr);
                break;
            case REQUEST_SCANNER_PARAMETERS:
                m_scannerDataHandler.handleScannerParametersCancel(requestStr);
                break;
            case FUNDAMENTAL_DATA_TICK:
                m_fundamentalDataHandler.handleFundamentalDataCancel(requestStr);
                break;
            case HISTORICAL_TICKS_TICK:
                m_historicalTicksHandler.handleHistoricalTicksCancel(requestStr);
                break;
            case SEC_DEF_OPT_PARAMS_TICK:
                m_secDefOptParamsHandler.handleSecDefOptParamsCancel(requestStr);
                break;
            case REQUEST_FAMILY_CODES:
                m_accountUpdatesMultiHandler.handleFamilyCodesCancel(requestStr);
                break;
            case HEAD_TIMESTAMP_TICK:
                m_headTimestampHandler.handleHeadTimestampCancel(requestStr);
                break;
            case REQUEST_MATCHING_SYMBOLS:
                m_matchingSymbolsHandler.handleMatchingSymbolsCancel(requestStr);
                break;
            case REQUEST_MARKET_DEPTH_EXCHANGES:
                m_marketDepthHandler.handleMktDepthExchangesCancel(requestStr);
                break;
            case NEWS_TICKS_TICK:
                m_newsDataHandler.handleNewsTicksCancel(requestStr);
                break;
            case REQ_NEWS_PROVIDERS:
                m_newsDataHandler.handleNewsProvidersCancel(requestStr);
                break;
            case HISTORICAL_NEWS_TICK:
                m_newsDataHandler.handleHistoricalNewsCancel(requestStr);
                break;
            case NEWS_ARTICLE_TICK:
                if (!requestStr.contains(DdeRequestType.NEWS_ARTICLE.topic())) {
                    m_newsDataHandler.handleNewsArticleCancel(requestStr);
                }
                break;
            case REQ_NEWS_BULLETINS:
                m_newsDataHandler.handleNewsBulletinsCancel(requestStr);
                break;
            case PNL_TICK:
                m_pnlHandler.handlePnLCancel(requestStr);
                break;
            case CALCULATE_IMPLIED_VOLATILITY_TICK:
                m_calcImplVolOptPriceHandler.handleCalculateCancel(requestStr, DdeRequestType.CALCULATE_IMPLIED_VOLATILITY_TICK);
                break;
            case CALCULATE_OPTION_PRICE_TICK:
                m_calcImplVolOptPriceHandler.handleCalculateCancel(requestStr, DdeRequestType.CALCULATE_OPTION_PRICE_TICK);
                break;
            case EXERCISE_OPTIONS_TICK:
                m_exerciseOptionsHandler.handleExerciseOptionsStopAdvise(requestStr);
                break;
            case REQUEST_MARKET_RULE:
                m_contractDetailsHandler.handleMarketRuleStopAdvise(requestStr);
                break;
            case REQUEST_SMART_COMPONENTS:
                m_miscHandler.handleSmartComponentsCancel(requestStr);
                break;
            case REQUEST_SOFT_DOLLAR_TIERS:
                m_miscHandler.handleSoftDollarTiersCancel(requestStr);
                break;
            case HISTOGRAM_DATA_TICK:
                m_histogramDataHandler.handleHistogramDataCancel(requestStr);
                break;
            case REQUEST_FA:
                m_accountUpdatesMultiHandler.handleFARequestStopAdvise(requestStr);
                break;
            case REPLACE_FA:
                m_accountUpdatesMultiHandler.handleFAReplaceStopAdvise(requestStr);
                break;
            
            // old-style
            case TIK:
                m_oldMarketDataHandler.handleTickStopAdvise(requestStr);
                break;
            case ERR:
                m_oldErrorsHandler.handleErrorStopAdvise(requestStr);
                break;
            case NEWS:
                m_oldNewsHandler.handleNewsBulletinsStopAdvise(requestStr);
                break;
            case OPENS:
                m_oldOrdersHandler.handleOpenOrdersStopAdvise(requestStr);
                break;
            case EXECS:
                m_oldExecutionsHandler.handleExecutionsStopAdvise(requestStr);
                break;
            case ACCTS:
                m_oldAccountPortfolioHandler.handleAccountDataStopAdvise(requestStr);
                break;
            case PORTS:
                m_oldAccountPortfolioHandler.handlePortfolioStopAdvise(requestStr);
                break;
            case MKTDEPTH:
                m_oldMarketDepthHandler.handleMktDepthTickStopAdvise(requestStr);
                break;
            case SCAN:
                m_oldScannerDataHandler.handleScannerSubscriptionStopAdvise(requestStr);
                break;
            case CONTRACT:
                m_oldContractDetailsHandler.handleContractDetailsTickStopAdvise(requestStr);
            case HIST:
                m_oldHistoricalDataHandler.handleHistoricalDataStopAdvise(requestStr);
            default:
                break;
        }
    }
    
    public void notifyDde(DdeNotificationEvent ddeEvent) {
        m_socketDdeBridge.notifyDde(ddeEvent);
    }

    /* *****************************************************************************************************
     *                                             Connect
    /* *****************************************************************************************************/
    /** Connect to TWS */
    public boolean connect() throws InterruptedException {
        System.out.println("Connecting to host [" + m_host + "] port [" + m_port + "] clientId [" + m_clientId + "]");

        m_wrapper.clientSocket().eConnect(m_host, m_port, m_clientId);

        final EClientSocket client = m_wrapper.clientSocket();
        final EReaderSignal signal = m_wrapper.readerSignal();

        if (m_wrapper.clientSocket().isConnected()) {
            System.out.println("Connected to Tws server version " + m_wrapper.clientSocket().serverVersion() + " at " + m_wrapper.clientSocket().getTwsConnectionTime());
        } else {
            return false;
        }

        final EReader reader = new EReader (client, signal);   

        reader.start();
        //An additional thread is created in this program design to empty the messaging queue
        new Thread(() -> {
            while (client.isConnected()) {
                signal.waitForSignal();
                try {
                    reader.processMsgs();
                } catch (Exception e) {
                    System.out.println("Exception: " + e.getMessage());
                }
            }
        }).start();

        return true;
    }
    
    /** Called when TWS interrupts the connection */
    public void disconnect() {
        m_socketDdeBridge.stop();
    }

    
    /* *****************************************************************************************************
     *                                             Misc Methods
    /* *****************************************************************************************************/
    private void setServerLogLevel(String requestString) {
        int logLevel = 0;
        try {
            logLevel = Integer.parseInt(requestString);
        } catch (NumberFormatException e){
            System.out.println("Exception: " + e.getMessage());
        }
        System.out.println("Setting server log level to " + logLevel);
        m_wrapper.clientSocket().setServerLogLevel(logLevel);
    }

    /* *****************************************************************************************************
     *                                             Market Data
    /* *****************************************************************************************************/
    /** Method updates market data */
    public void updateMarketData(int requestId, String fieldStr, Object value, DdeRequestStatus status) {
        m_marketDataHandler.updateMarketData(requestId, DdeRequestType.TICK.topic(), fieldStr, value, status);
        m_oldMarketDataHandler.updateMarketData(requestId, fieldStr, value, status);
    }
    
    /** Method updates market data error */
    public void updateMarketDataError(int requestId, String errorMsgStr) {
        m_marketDataHandler.updateMarketDataError(requestId, errorMsgStr, DdeRequestType.TICK.topic());
    }
    
    /** Method sets market data type to 4 (Delayed-Frozen) */
    public void setMarketDataType() {
        m_wrapper.clientSocket().reqMarketDataType(4);
    }

    /* *****************************************************************************************************
     *                                             Orders
    /* *****************************************************************************************************/
    /** Method updates order status with error for orderId */
    public void updateOrderStatusError(int orderId, String errorMessage) {
        m_ordersHandler.updateOrderStatusError(orderId, errorMessage);
    }

    /** Method updates order status for orderId */
    public void updateOrderStatus(OrderStatusData orderStatus) {
        m_ordersHandler.updateOrderStatus(orderStatus);
        m_oldOrdersHandler.updateOrderStatus(orderStatus);
    }

    /** Method updates open order data */
    public void updateOpenOrderData(OpenOrderData openOrderData) {
        m_ordersHandler.updateOpenOrderData(openOrderData);
        m_oldOrdersHandler.updateOpenOrderData(openOrderData);
    }

    /** Method updates open order end */
    public void updateOpenOrderEnd() {
        m_ordersHandler.updateOpenOrderEnd();
        m_oldOrdersHandler.updateOpenOrderEnd();
    }

    /* *****************************************************************************************************
     *                                             Errors
    /* *****************************************************************************************************/
    /** Method updates error data */
    public void addErrorMessage(ErrorData errorData) {
        m_errorsHandler.addErrorData(errorData);
        m_oldErrorsHandler.updateErrorData(errorData);
    }

    /* *****************************************************************************************************
     *                                          Position Updates
    /* *****************************************************************************************************/
    /** Method updates position data */
    public void updatePositionData(PositionData positionData, DdeRequestType ddeRequestType) {
        switch(ddeRequestType) {
        case REQ_POSITIONS_MULTI:
            m_positionsMultiHandler.updatePositionData(positionData, ddeRequestType.topic());
            break;
        case REQ_POSITIONS:
            m_positionsHandler.updatePositionData(positionData, ddeRequestType.topic());
            break;
        default:
            break;
        }
    }

    /** Method updates position end */
    public void updatePositionDataEnd(int requestId, DdeRequestType ddeRequestType) {
        switch(ddeRequestType) {
        case REQ_POSITIONS_MULTI:
            m_positionsMultiHandler.updatePositionDataEnd(requestId, ddeRequestType);
            break;
        case REQ_POSITIONS:
            m_positionsHandler.updatePositionDataEnd(requestId, ddeRequestType);
            break;
        default:
            break;
        }
    }

    /** Method updates position error */
    public void updatePositionDataError(int requestId, String errorMsgStr, DdeRequestType ddeRequestType) {
        switch(ddeRequestType) {
        case REQ_POSITIONS_MULTI:
            m_positionsMultiHandler.updatePositionError(requestId, errorMsgStr, ddeRequestType.topic());
           break;
        default:
            break;
        }
    }

    /* *****************************************************************************************************
     *                                          Executions
    /* *****************************************************************************************************/
    /** Method updates execution data */
    public void updateExecution(int requestId, ExecutionData executionData) {
        m_executionsHandler.updateExecution(requestId, executionData);
        m_oldExecutionsHandler.updateExecution(requestId, executionData);
    }

    /** Method updates execution end */
    public void updateExecutionEnd(int requestId) {
        m_executionsHandler.updateExecutionEnd(requestId);
        m_oldExecutionsHandler.updateExecutionEnd(requestId);
    }

    /** Method updates execution error */
    public void updateExecutionError(int requestId, String errorMsgStr) {
        m_executionsHandler.updateExecutionError(requestId, errorMsgStr);
    }

    /** Method updates commission report */
    public void updateCommissionReport(CommissionReport commissionReport) {
        m_executionsHandler.updateCommissionReport(commissionReport);
    }
    
    /* *****************************************************************************************************
     *                                          Account Updates
    /* *****************************************************************************************************/
    /** Method updates account data */
    public void updateAccountUpdate(AccountUpdateData accountUpdateData, DdeRequestType ddeRequestType) {
        switch(ddeRequestType) {
            case REQ_ACCOUNT_UPDATES_MULTI:
                m_accountUpdatesMultiHandler.updateAccountData(accountUpdateData, ddeRequestType);
                break;
            case REQ_ACCOUNT_SUMMARY:
                m_accountSummaryHandler.updateAccountData(accountUpdateData, ddeRequestType);
                break;
            case REQ_ACCOUNT_PORTFOLIO:
                m_accountPortfolioHandler.updateAccountData(accountUpdateData, ddeRequestType);
                m_oldAccountPortfolioHandler.updateAccountData(accountUpdateData, DdeRequestType.ACCTS);
                break;
            default:
                break;
        }
    }

    /** Method updates account data end */
    public void updateAccountDataEnd(int requestId, DdeRequestType ddeRequestType) {
        switch(ddeRequestType) {
            case REQ_ACCOUNT_UPDATES_MULTI:
                m_accountUpdatesMultiHandler.updateAccountDataEnd(requestId, ddeRequestType);
                break;
            case REQ_ACCOUNT_SUMMARY:
                m_accountSummaryHandler.updateAccountDataEnd(requestId, ddeRequestType);
                break;
            case REQ_ACCOUNT_PORTFOLIO:
                m_accountPortfolioHandler.updateAccountDataEnd(requestId, ddeRequestType);
                m_oldAccountPortfolioHandler.updateAccountDataEnd(requestId, DdeRequestType.ACCTS);
                m_oldAccountPortfolioHandler.updatePortfolioDataEnd(requestId, DdeRequestType.PORTS);
                break;
            default:
                break;
        }
    }

    /** Method updates account updates error */
    public void updateAccountDataError(int requestId, String errorMsgStr, DdeRequestType ddeRequestType) {
        switch(ddeRequestType) {
            case REQ_ACCOUNT_UPDATES_MULTI:
                m_accountUpdatesMultiHandler.updateAccountDataError(requestId, errorMsgStr, ddeRequestType);
                break;
            case REQ_ACCOUNT_SUMMARY:
                m_accountSummaryHandler.updateAccountDataError(requestId, errorMsgStr, ddeRequestType);
                break;
            case REQ_ACCOUNT_PORTFOLIO:
                m_accountPortfolioHandler.updateAccountDataError(requestId, errorMsgStr, ddeRequestType);
                break;
            default:
                break;
        }
    }

    /* *****************************************************************************************************
     *                                          Account Time
    /* *****************************************************************************************************/
    /** Method updates account time */
    public void updateAccountTime(String timeStamp) {
        m_miscHandler.updateAccountTime(timeStamp);
        m_oldMiscHandler.updateAccountTime(timeStamp);
    }

    /* *****************************************************************************************************
     *                                          Managed accounts
    /* *****************************************************************************************************/
    /** Method updates managed accounts */
    public void updateManagedAccounts(String accountsList) {
        m_miscHandler.updateManagedAccounts(accountsList);
        m_oldMiscHandler.updateManagedAccounts(accountsList);
    }
    
    /* *****************************************************************************************************
     *                                          Portfolio Updates
    /* *****************************************************************************************************/
    public void updatePortfolio(PositionData positionData) {
        m_accountPortfolioHandler.updatePortfolio(positionData);
        m_oldAccountPortfolioHandler.updatePortfolio(positionData);
    }

    /* *****************************************************************************************************
     *                                             Market Depth
    /* *****************************************************************************************************/
    /** Method updates market depth */
    public void updateMarketDepthData(int requestId, MarketDepthData marketDepthData, DdeRequestStatus status) {
        m_marketDepthHandler.updateMarketDepthData(requestId, marketDepthData, status);
        m_oldMarketDepthHandler.updateMarketDepthData(requestId, marketDepthData, status);
    }
    
    /** Method updates market depth error */
    public void updateMarketDepthError(int requestId, String errorMsgStr) {
        m_marketDepthHandler.updateMarketDepthError(requestId, errorMsgStr);
    }
    
    /** Method updates market depth exchanges */
    public void updateMktDepthExchanges(DepthMktDataDescription[] depthMktDataDescriptions) {
        m_marketDepthHandler.updateMktDepthExchanges(depthMktDataDescriptions);
    }

    /* *****************************************************************************************************
     *                                             Scanner Data
    /* *****************************************************************************************************/
    /** Method updates scanner data */
    public void updateScannerData(int requestId, ScannerData scannerData) {
        m_scannerDataHandler.updateScannerData(requestId, scannerData);
        m_oldScannerDataHandler.updateScannerData(requestId, scannerData);
    }

    /** Method updates scanner data end */
    public void updateScannerDataEnd(int requestId) {
        m_scannerDataHandler.updateScannerDataEnd(requestId);
        m_oldScannerDataHandler.updateScannerDataEnd(requestId);
    }
    
    /** Method updates scanner subscription error */
    public void updateScannerSubscriptionError(int requestId, String errorMsgStr) {
        m_scannerDataHandler.updateScannerSubscriptionError(requestId, errorMsgStr);
    }

    /** Method updates scanner parameters */
    public void updateScannerParameters(String xml) {
        m_scannerDataHandler.updateScannerParameters(xml);
    }
    
    /* *****************************************************************************************************
     *                                             Contract Details
    /* *****************************************************************************************************/
    /** Method updates contract details */
    public void updateContractDetails(int requestId, ContractDetails contractDetails) {
        m_contractDetailsHandler.updateContractDetails(requestId, contractDetails);
        m_oldContractDetailsHandler.updateContractDetails(requestId, contractDetails);
    }

    /** Method updates contract details end */
    public void updateContractDetailsEnd(int requestId) {
        m_contractDetailsHandler.updateContractDetailsEnd(requestId);
        m_oldContractDetailsHandler.updateContractDetailsEnd(requestId);
    }

    /** Method updates contract details request error */
    public void updateContractDetailsRequestError(int requestId, String errorMsgStr) {
        m_contractDetailsHandler.updateContractDetailsRequestError(requestId, errorMsgStr);
    }

    /* *****************************************************************************************************
     *                                             Historical Data
    /* *****************************************************************************************************/
    /** Method updates historical data */
    public void updateHistoricalData(int requestId, Bar bar) {
        m_historicalDataHandler.updateHistoricalData(requestId, bar);
        m_oldHistoricalDataHandler.updateHistoricalData(requestId, bar);
    }

    /** Method updates historical data end */
    public void updateHistoricalDataEnd(int requestId) {
        m_historicalDataHandler.updateHistoricalDataEnd(requestId, DdeRequestType.HISTORICAL_DATA_TICK.topic());
        m_oldHistoricalDataHandler.updateHistoricalDataEnd(requestId);
    }

    public void liveUpdateHistoricalData(int requestId, Bar bar) {
        m_historicalDataHandler.liveUpdateHistoricalData(requestId, bar);
    }
    
    /** Method updates historical data request error */
    public void updateHistoricalDataRequestError(int requestId, String errorMsgStr) {
        m_historicalDataHandler.updateHistoricalDataRequestError(requestId, errorMsgStr, DdeRequestType.HISTORICAL_DATA_TICK.topic());
    }

    /* *****************************************************************************************************
     *                                             Real Time Bars
    /* *****************************************************************************************************/
    /** Method updates real time bars */
    public void updateRealTimeBars(int requestId, Bar bar) {
        m_realTimeBarsHandler.updateHistoricalData(requestId, bar);
        m_realTimeBarsHandler.updateHistoricalDataEnd(requestId, DdeRequestType.REAL_TIME_BARS_TICK.topic());
    }

    /** Method updates real time bars request error */
    public void updateRealTimeBarsRequestError(int requestId, String errorMsgStr) {
        m_realTimeBarsHandler.updateHistoricalDataRequestError(requestId, errorMsgStr, DdeRequestType.REAL_TIME_BARS_TICK.topic());
    }

    /* *****************************************************************************************************
     *                                             Tick-By-Tick Data
    /* *****************************************************************************************************/
    /** Method updates tick-by-tick data */
    public void updateTickByTickData(int requestId, String fieldStr, Object value, DdeRequestStatus status) {
        m_tickByTickDataHandler.updateMarketData(requestId, DdeRequestType.TICK_BY_TICK_DATA_TICK.topic(), fieldStr, value, status);
    }
    
    /** Method updates tick-by-tick data error */
    public void updateTickByTickDataError(int requestId, String errorMsgStr) {
        m_tickByTickDataHandler.updateMarketDataError(requestId, errorMsgStr, DdeRequestType.TICK_BY_TICK_DATA_TICK.topic());
    }
    
    /* *****************************************************************************************************
     *                                             Tick-By-Tick Data Ext
    /* *****************************************************************************************************/
    /** Method updates tick-by-tick data */
    public void updateTickByTickDataExt(int requestId, TickByTickData tickByTickData, DdeRequestStatus status) {
        m_tickByTickDataHandler.updateTickByTickDataExt(requestId, tickByTickData, status);
    }
    
    /** Method updates tick-by-tick data error */
    public void updateTickByTickDataErrorExt(int requestId, String errorMsgStr) {
        m_tickByTickDataHandler.updateTickByTickDataErrorExt(requestId, errorMsgStr);
    }

    /* *****************************************************************************************************
     *                                             Fundamental Data
    /* *****************************************************************************************************/
    /** Method updates fundamental data */
    public void updateFundamentalData(int requestId, String fundamentalData) {
        m_fundamentalDataHandler.updateFundamentalData(requestId, fundamentalData);
    }

    /** Method updates fundamental data request error */
    public void updateFundamentalDataRequestError(int requestId, String errorMsgStr) {
        m_fundamentalDataHandler.updateFundamentalDataRequestError(requestId, errorMsgStr);
    }    

    /* *****************************************************************************************************
     *                                             Historical Ticks
    /* *****************************************************************************************************/
    /** Method updates historical ticks */
    public void updateHistoricalTicks(int requestId, TickByTickData tickByTickData) {
        m_historicalTicksHandler.updateData(requestId, tickByTickData);
    }

    /** Method updates historical ticks end */
    public void updateHistoricalTicksEnd(int requestId) {
        m_historicalTicksHandler.updateDataEnd(requestId, DdeRequestType.HISTORICAL_TICKS_TICK.topic());
    }

    /** Method updates historical ticks request error */
    public void updateHistoricalTicksRequestError(int requestId, String errorMsgStr) {
        m_historicalTicksHandler.updateDataRequestError(requestId, errorMsgStr, DdeRequestType.HISTORICAL_TICKS_TICK.topic());
    }
    
    /* *****************************************************************************************************
     *                                    Security Definition Option Parameters
    /* *****************************************************************************************************/
    /** Method updates security definition option parameters */
    public void updateSecDefOptParams(int requestId, SecDefOptParamsData secDefOptParamsData) {
        m_secDefOptParamsHandler.updateData(requestId, secDefOptParamsData);
    }

    /** Method updates security definition option parameters end */
    public void updateSecDefOptParamsEnd(int requestId) {
        m_secDefOptParamsHandler.updateDataEnd(requestId, DdeRequestType.SEC_DEF_OPT_PARAMS_TICK.topic());
    }

    /** Method updates security definition option parameters request error */
    public void updateSecDefOptParamsRequestError(int requestId, String errorMsgStr) {
        m_secDefOptParamsHandler.updateDataRequestError(requestId, errorMsgStr, DdeRequestType.SEC_DEF_OPT_PARAMS_TICK.topic());
    }
    
    /* *****************************************************************************************************
     *                                              Family Codes
    /* *****************************************************************************************************/
    public void updateFamilyCodes(FamilyCode[] familyCodes) {
        m_accountUpdatesMultiHandler.updateFamilyCodes(familyCodes);
    }
    
    /* *****************************************************************************************************
     *                                             Head Timestamp
    /* *****************************************************************************************************/
    /** Method updates head timestamp */
    public void updateHeadTimestamp(int requestId, String headTimestamp) {
        m_headTimestampHandler.updateHeadTimestamp(requestId, headTimestamp);
    }

    /** Method updates head timestamp request error */
    public void updateHeadTimestampRequestError(int requestId, String errorMsgStr) {
        m_headTimestampHandler.updateHeadTimestampRequestError(requestId, errorMsgStr);
    }
    
    /* *****************************************************************************************************
     *                                          Symbol Samples
    /* *****************************************************************************************************/
    /** Method updates symbol samples */
    public void updateSymbolSamples(int requestId, ContractDescription[] contractDescriptions) {
        m_matchingSymbolsHandler.updateSymbolSamples(requestId, contractDescriptions);
    }

    /** Method updates matching symbols request error */
    public void updateMatchingSymbolsRequestError(int requestId, String errorMsgStr) {
        m_matchingSymbolsHandler.updateMatchingSymbolsRequestError(requestId, errorMsgStr);
    }
    
    /* *****************************************************************************************************
     *                                          News
    /* *****************************************************************************************************/
    /** Method updates news bulletins */
    public void updateNewsBulletins(NewsBulletinData newsBulletinData) {
        m_newsDataHandler.updateNewsBulletinData(newsBulletinData);
        m_oldNewsHandler.updateNewsBulletinData(newsBulletinData);
    }
    
    /** Method updates news data */
    public void updateNewsData(int requestId, NewsData newsData, DdeRequestType ddeRequestType) {
        m_newsDataHandler.updateNewsData(requestId, newsData, ddeRequestType);
    }

    /** Method updates news data end */
    public void updateNewsDataEnd(int requestId, DdeRequestType ddeRequestType) {
        m_newsDataHandler.updateNewsDataEnd(requestId, ddeRequestType);
    }
    
    /** Method updates news data request error */
    public void updateNewsDataRequestError(int requestId, String errorMsgStr, DdeRequestType ddeRequestType) {
       m_newsDataHandler.updateNewsDataRequestError(requestId, errorMsgStr, ddeRequestType);
    }    
    
    /** Method updates news providers */
    public void updateNewsProviders(NewsProvider[] newsProviders) {
        m_newsDataHandler.updateNewsProviders(newsProviders);
    }
    
    /** Method updates news article */
    public void updateNewsArticle(int requestId, int articleType, String articleText) {
        m_newsDataHandler.updateNewsArticle(requestId, articleType, articleText);
    }

    /** Method updates news article request error */
    public void updateNewsArticleRequestError(int requestId, String errorMsgStr) {
        m_newsDataHandler.updateNewsArticleRequestError(requestId, errorMsgStr);
    }
    
    /* *****************************************************************************************************
     *                                             PnL
    /* *****************************************************************************************************/
    /** Method updates PnL */
    public void updatePnL(int requestId, String fieldStr, Object value, DdeRequestStatus status) {
        m_pnlHandler.updateMarketData(requestId, DdeRequestType.PNL_TICK.topic(), fieldStr, value, status);
    }
    
    /** Method updates PnL request error */
    public void updatePnLRequestError(int requestId, String errorMsgStr) {
        m_pnlHandler.updateMarketDataError(requestId, errorMsgStr, DdeRequestType.PNL_TICK.topic());
    }
    
    /* *****************************************************************************************************
     *                         Calculate Implied Volatility / Calculate Option Price
    /* *****************************************************************************************************/
    /** Method updates custom option computation */
    public void updateCustomOptionComputation(int requestId, String fieldStr, Object value, DdeRequestStatus status, DdeRequestType requestType) {
        m_calcImplVolOptPriceHandler.updateMarketData(requestId, requestType.topic(), fieldStr, value, status);
        m_oldMarketDataHandler.updateCustomOptionComputation(requestId, fieldStr, value, status);
    }
    
    /** Method updates calculate implied volatility/option price request error */
    public void updateCalculateRequestError(int requestId, String errorMsgStr, DdeRequestType requestType) {
        m_calcImplVolOptPriceHandler.updateMarketDataError(requestId, errorMsgStr, requestType.topic());
    }
    
    /* *****************************************************************************************************
     *                                          Exercise options
    /* *****************************************************************************************************/
    /** Method updates exercise options order status */
    public void updateExerciseOptionsOrderStatus(int requestId, String orderStatus) {
        m_exerciseOptionsHandler.updateExerciseOptionsOrderStatus(requestId, orderStatus);
    }
    
    /** Method updates exercise options request error */
    public void updateExerciseOptionsRequestError(int requestId, String errorMsgStr) {
        m_exerciseOptionsHandler.updateExerciseOptionsRequestError(requestId, errorMsgStr);
    }

    /* *****************************************************************************************************
     *                                          Current Time
    /* *****************************************************************************************************/
    /** Method updates current time */
    public void updateCurrentTime(long currentTime) {
        m_miscHandler.updateCurrentTime(currentTime);
    }
    
    /* *****************************************************************************************************
     *                                   Market Rule / Price Increments
    /* *****************************************************************************************************/
    /** Method updates price increments */
    public void updatePriceIncrements(int requestId, PriceIncrement[] priceIncrements) {
        m_contractDetailsHandler.updatePriceIncrements(requestId, priceIncrements);
    }

    /** Method updates market rule request error */
    public void updateMarketRuleRequestError(int requestId, String errorMsgStr) {
        m_contractDetailsHandler.updateMarketRuleRequestError(requestId, errorMsgStr);
    }

    /* *****************************************************************************************************
     *                                          Smart Components
    /* *****************************************************************************************************/
    /** Method updates smart components */
    public void updateSmartComponents(int requestId, Map<Integer, Entry<String, Character>> theMap) {
        m_miscHandler.updateSmartComponents(requestId, theMap);
    }

    /** Method updates smart components request error */
    public void updateSmartComponentsRequestError(int requestId, String errorMsgStr) {
        m_miscHandler.updateSmartComponentsRequestError(requestId, errorMsgStr);
    }
    
    /* *****************************************************************************************************
     *                                          Soft Dollar Tiers
    /* *****************************************************************************************************/
    /** Method updates soft dollar tiers */
    public void updateSoftDollarTiers(int requestId,  SoftDollarTier[] tiers) {
        m_miscHandler.updateSoftDollarTiers(requestId, tiers);
    }
    
    /* *****************************************************************************************************
     *                                             Histogram Data
    /* *****************************************************************************************************/
    /** Method updates histogram data */
    public void updateHistogramData(int requestId, List<HistogramEntry> items) {
        m_histogramDataHandler.updateAllData(requestId, items);
        m_histogramDataHandler.updateDataEnd(requestId, DdeRequestType.HISTOGRAM_DATA_TICK.topic());
    }

    /** Method updates histogram data request error */
    public void updateHistogramDataRequestError(int requestId, String errorMsgStr) {
        m_histogramDataHandler.updateDataRequestError(requestId, errorMsgStr, DdeRequestType.HISTOGRAM_DATA_TICK.topic());
    }
    
    /* *****************************************************************************************************
     *                                             Financial Advisor
    /* *****************************************************************************************************/
    /** Method updates financial advisor data */
    public void updateFA(int faDataType, String xml) {
        m_accountUpdatesMultiHandler.updateFA(faDataType, xml);
    }

    /** Method updates financial advisor request error */
    public void updateFARequestError(String errorMsgStr) {
        if (m_accountUpdatesMultiHandler.updateFARequestError(errorMsgStr)) {
            return;
        }
        m_accountUpdatesMultiHandler.updateFAReplaceError(errorMsgStr);
    }
    
}
