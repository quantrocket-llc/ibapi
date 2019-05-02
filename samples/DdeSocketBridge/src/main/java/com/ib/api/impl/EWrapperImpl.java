/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.impl;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import com.ib.client.Bar;
import com.ib.client.CommissionReport;
import com.ib.client.Contract;
import com.ib.client.ContractDescription;
import com.ib.client.ContractDetails;
import com.ib.client.EWrapper;
import com.ib.client.Execution;
import com.ib.client.FamilyCode;
import com.ib.client.HistogramEntry;
import com.ib.client.HistoricalTick;
import com.ib.client.HistoricalTickBidAsk;
import com.ib.client.HistoricalTickLast;
import com.ib.client.MarketDataType;
import com.ib.client.NewsProvider;
import com.ib.client.Order;
import com.ib.client.OrderState;
import com.ib.client.PriceIncrement;
import com.ib.client.SoftDollarTier;
import com.ib.client.TickAttrib;
import com.ib.client.TickAttribBidAsk;
import com.ib.client.TickAttribLast;
import com.ib.client.TickType;
import com.ib.client.DeltaNeutralContract;
import com.ib.client.DepthMktDataDescription;
import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.socket2dde.data.AccountUpdateData;
import com.ib.api.dde.socket2dde.data.ErrorData;
import com.ib.api.dde.socket2dde.data.ExecutionData;
import com.ib.api.dde.socket2dde.data.MarketDepthData;
import com.ib.api.dde.socket2dde.data.NewsBulletinData;
import com.ib.api.dde.socket2dde.data.NewsData;
import com.ib.api.dde.socket2dde.data.OpenOrderData;
import com.ib.api.dde.socket2dde.data.OrderData;
import com.ib.api.dde.socket2dde.data.OrderStatusData;
import com.ib.api.dde.socket2dde.data.PositionData;
import com.ib.api.dde.socket2dde.data.ScannerData;
import com.ib.api.dde.socket2dde.data.SecDefOptParamsData;
import com.ib.api.dde.socket2dde.data.TickByTickData;
import com.ib.api.dde.utils.Utils;

/** Class implements EWrapper interface. All responses from TWS come here. */
public class EWrapperImpl implements EWrapper {

    private final TwsService m_twsService; 

    public EWrapperImpl(TwsService twsService) {
        this.m_twsService = twsService;
    }

    @Override
    public void error(Exception e) {
        System.out.println("Error: " + e);
    }

    @Override
    public void error(String str) {
        System.out.println("Error: " + str);
    }

    @Override
    public void error(int id, int errorCode, String errorMsg) {
        errorMsg = errorMsg.replace("\n", " "); // replace new lines with spaces
        System.out.println("Error: Id[" + id + "] ErrorCode [" + errorCode + "] ErrorMsg [" + errorMsg + "]");
        
        if (errorCode == 507) {
            m_twsService.disconnect();
        }
        // error event
        m_twsService.addErrorMessage(new ErrorData(id, errorCode, errorMsg));

        String errorMsgStr = new String(errorCode + ":" + errorMsg);
        
        // order errors
        if (id > 10000000) {
            m_twsService.updateOrderStatusError(id, errorMsgStr);
        }

        // market data errors
        // 100001-200000 - reqMarketData
        if (id >= 100001 && id <= 200000) {
            m_twsService.updateMarketDataError(id, errorMsgStr);
        }

        // reqPositionMulti errors
        // 200001-300000 - reqPositionsMulti
        if (id >= 200001 && id <= 300000) {
            m_twsService.updatePositionDataError(id, errorMsgStr, DdeRequestType.REQ_POSITIONS_MULTI);
        }
        
        // reqExecutions errors
        // 300001-400000 - reqExecutions
        if (id >= 300001 && id <= 400000) {
            m_twsService.updateExecutionError(id, errorMsgStr);
        }

        // reqAccountUpdatesMulti errors
        // 400001-500000 - reqAccountUpdatesMulti
        if (id >= 400001 && id <= 500000) {
            m_twsService.updateAccountDataError(id, errorMsgStr, DdeRequestType.REQ_ACCOUNT_UPDATES_MULTI);
        }

        // reqAccountSummary errors
        // 500001-600000 - reqAccountSummary
        if (id >= 500001 && id <= 600000) {
            m_twsService.updateAccountDataError(id, errorMsgStr, DdeRequestType.REQ_ACCOUNT_SUMMARY);
        }

        // reqAccountUpdates errors
        // no id - reqAccountUpdates 
        if (id == Integer.MAX_VALUE) {//2147483647
            if (errorMsg.contains("Institutional customer account does not have account info") ||
                    errorMsg.contains("ALL account is not supported") ||
                    errorMsg.contains("Invalid account code") ||
                    errorMsg.contains("The account code is required for this operation")) {
                m_twsService.updateAccountDataError(0, errorMsgStr, DdeRequestType.REQ_ACCOUNT_PORTFOLIO);
            }
            if (errorMsg.contains("FA data operations ignored for non FA customers") ||
                    errorMsg.contains("Non-existent FA data operation request") ||
                    errorMsg.contains("An XML string is required for this operation")) {
                m_twsService.updateFARequestError(errorMsgStr);
            }
        }
        // reqMarketRule errors
        if (id == -1) {
            if (errorMsg.contains("Market rule with id") ||
                    errorMsg.contains("Price increment rule for market rule with id") ||
                    errorMsg.contains("Price increment intervals for market rule with id")) {
                m_twsService.updateMarketRuleRequestError(0, errorMsgStr);
            }
        }

        // reqMktDepth errors
        // 600001-700000 - reqMktDepth
        if (id >= 600001 && id <= 700000) {
            m_twsService.updateMarketDepthError(id, errorMsgStr);
        }

        // reqScannerSubscription errors
        // 700001-800000 - reqScannerSubscription
        if (id >= 700001 && id <= 800000) {
            m_twsService.updateScannerSubscriptionError(id, errorMsgStr);
        }

        // reqContractDetails errors
        // 800001-900000 - reqContractDetails
        if (id >= 800001 && id <= 900000) {
            m_twsService.updateContractDetailsRequestError(id, errorMsgStr);
        }

        // reqHistoricalData errors
        // 900001-1000000 - reqHistoricalData
        if (id >= 900001 && id <= 1000000) {
            m_twsService.updateHistoricalDataRequestError(id, errorMsgStr);
        }

        // reqRealTimeBars errors
        // 1000001-1100000 - reqRealTimeBars
        if (id >= 1000001 && id <= 1100000) {
            m_twsService.updateRealTimeBarsRequestError(id, errorMsgStr);
        }

        // reqTickByTickData errors
        // 1100001-1200000 - reqTickByTickData
        if (id >= 1100001 && id <= 1200000) {
            m_twsService.updateTickByTickDataError(id, errorMsgStr);
        }
        // 1200001-1300000 - reqTickByTickData ext
        if (id >= 1200001 && id <= 1300000) {
            m_twsService.updateTickByTickDataErrorExt(id, errorMsgStr);
        }

        // reqFundamentalData errors
        // 1300001-1400000 - reqFundamentalData
        if (id >= 1300001 && id <= 1400000) {
            m_twsService.updateFundamentalDataRequestError(id, errorMsgStr);
        }

        // reqHistoricalTicks errors
        // 1400001-1500000 - reqHistoricalTicks
        if (id >= 1400001 && id <= 1500000) {
            m_twsService.updateHistoricalTicksRequestError(id, errorMsgStr);
        }

        // reqSecDefOptParams errors
        // 1500001-1600000 - reqSecDefOptParams
        if (id >= 1500001 && id <= 1600000) {
            m_twsService.updateSecDefOptParamsRequestError(id, errorMsgStr);
        }

        // reqHeadTimestamp errors
        // 1600001-1700000 - reqHeadTimestamp
        if (id >= 1600001 && id <= 1700000) {
            m_twsService.updateHeadTimestampRequestError(id, errorMsgStr);
        }

        // reqMatchingSymbols errors
        // 1700001-1800000 - reqMatchingSymbols
        if (id >= 1700001 && id <= 1800000) {
            m_twsService.updateMatchingSymbolsRequestError(id, errorMsgStr);
        }

        // reqMktData (newsTicks) errors
        // 1800001-1900000 - reqMktData
        if (id >= 1800001 && id <= 1900000) {
            m_twsService.updateNewsDataRequestError(id, errorMsgStr,  DdeRequestType.NEWS_TICKS_TICK);
        }

        // reqHistoricalNews errors
        // 1900001-2000000 - reqHistoricalNews
        if (id >= 1900001 && id <= 2000000) {
            m_twsService.updateNewsDataRequestError(id, errorMsgStr, DdeRequestType.HISTORICAL_NEWS_TICK);
        }

        // reqNewsArticle errors
        // 2000001-2100000 - reqNewsArticle
        if (id >= 2000001 && id <= 2100000) {
            m_twsService.updateNewsArticleRequestError(id, errorMsgStr);
        }

        // reqPnL, reqPnLSingle errors
        // 2100001-2200000 - reqPnL, reqPnLSingle
        if (id >= 2100001 && id <= 2200000) {
            m_twsService.updatePnLRequestError(id, errorMsgStr);
        }

        // calculateImpliedVolatility
        // 2200001-2300000 - calculateImpliedVolatility
        if (id >= 2200001 && id <= 2300000) {
            m_twsService.updateCalculateRequestError(id, errorMsgStr, DdeRequestType.CALCULATE_IMPLIED_VOLATILITY_TICK);
        }

        // calculateOptionPrice
        // 2300001-2400000 - calculateOptionPrice
        if (id >= 2300001 && id <= 2400000) {
            m_twsService.updateCalculateRequestError(id, errorMsgStr, DdeRequestType.CALCULATE_OPTION_PRICE_TICK);
        }

        // exerciseOptions
        // 2400001-2500000 - exerciseOptions
        if (id >= 2400001 && id <= 2500000) {
            m_twsService.updateExerciseOptionsRequestError(id, errorMsgStr);
        }

        // reqSmartComponents
        // 2500001-2600000 - reqSmartComponents
        if (id >= 2500001 && id <= 2600000) {
            m_twsService.updateSmartComponentsRequestError(id, errorMsgStr);
        }
        
        // reqHistogramData errors
        // 2600001-2700000 - reqHistogramData
        if (id >= 2600001 && id <= 2700000) {
            m_twsService.updateHistogramDataRequestError(id, errorMsgStr);
        }
        
    }

    @Override
    public void connectionClosed() {
        System.out.println("Connection closed");
    }

    @Override
    public void tickPrice(int tickerId, int field, double price, TickAttrib attrib) {
        String fieldStr = Utils.getField(field);
        System.out.println("tickPrice TickerId [" + tickerId + "] Field [" + fieldStr + "] Price [" + price + "]");
        m_twsService.updateMarketData(tickerId, fieldStr, price, DdeRequestStatus.SUBSCRIBED);
    }

    @Override
    public void tickSize(int tickerId, int field, int size) {
        String fieldStr = Utils.getField(field);
        System.out.println("tickSize TickerId [" + tickerId + "] Field [" + fieldStr + "] Size [" + size + "]");
        m_twsService.updateMarketData(tickerId, fieldStr, size, DdeRequestStatus.SUBSCRIBED);
    }

    @Override
    public void tickOptionComputation(int tickerId, int field,
            double impliedVol, double delta, double optPrice,
            double pvDividend, double gamma, double vega, double theta,
            double undPrice) {
        String fieldStr = Utils.getField(field);
        System.out.println("tickOptionComputation TickerId [" + tickerId + "] Field [" + fieldStr + "] ImpliedVol [" + impliedVol + "] OptPrice [" + optPrice + "]"
                + " UndPrice [" + undPrice + "] PvDividend [" + pvDividend + "] Delta [" + delta + "] Gamma [" + gamma + "]"
                + " Vega [" + vega + "] Theta [" + theta + "]");
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.IMPLIED_VOL_STR, impliedVol, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.OPT_PRICE_STR, optPrice, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.UND_PRICE_STR, undPrice, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.PV_DIVIDEND_STR, pvDividend, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.DELTA_STR, delta, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.GAMMA_STR, gamma, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.VEGA_STR, vega, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.THETA_STR, theta, DdeRequestStatus.SUBSCRIBED);
        
        if (field == TickType.CUST_OPTION_COMPUTATION.index()) {
            m_twsService.updateCustomOptionComputation(tickerId, fieldStr + Utils.IMPLIED_VOL_STR, impliedVol, 
                    DdeRequestStatus.SUBSCRIBED, DdeRequestType.CALCULATE_IMPLIED_VOLATILITY_TICK);
            m_twsService.updateCustomOptionComputation(tickerId, fieldStr + Utils.OPT_PRICE_STR, optPrice, 
                    DdeRequestStatus.SUBSCRIBED, DdeRequestType.CALCULATE_OPTION_PRICE_TICK);
        }
    }

    @Override
    public void tickGeneric(int tickerId, int tickType, double value) {
        String fieldStr = Utils.getField(tickType);
        System.out.println("tickGeneric TickerId [" + tickerId + "] Field [" + fieldStr + "] Value [" + value + "]");
        m_twsService.updateMarketData(tickerId, fieldStr, value, DdeRequestStatus.SUBSCRIBED);
    }

    @Override
    public void tickString(int tickerId, int tickType, String value) {
        String fieldStr = Utils.getField(tickType);
        System.out.println("tickString TickerId [" + tickerId + "] Field [" + fieldStr + "] Value [" + value + "]");
        m_twsService.updateMarketData(tickerId, fieldStr, value, DdeRequestStatus.SUBSCRIBED);
    }

    @Override
    public void tickEFP(int tickerId, int tickType, double basisPoints,
            String formattedBasisPoints, double impliedFuture, int holdDays,
            String futureExpiry, double dividendImpact, double dividendsToExpiry) {
        String fieldStr = Utils.getField(tickType);
        System.out.println("tickEFP TickerId [" + tickerId + "] Field [" + fieldStr + "] BasisPoints [" + basisPoints + "]"
                + " FormattedBasisPoints [" + formattedBasisPoints + "] ImpliedFuture [" + impliedFuture + "]"
                + " HoldDays [" + holdDays + "] FutureExpiry [" + futureExpiry + "]"
                + " DividendImpact [" + dividendImpact + "] DividendsToExpiry [" + dividendsToExpiry + "]");
        
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.BASIS_POINTS_STR, basisPoints, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.FORMATTED_BASIS_POINTS_STR, formattedBasisPoints, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.IMPLIED_FUTURE_STR, impliedFuture, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.HOLD_DAYS_STR, holdDays, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.FUTURE_EXPIRY_STR, futureExpiry, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.DIVIDEND_IMPACT_STR, dividendImpact, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, fieldStr + Utils.DIVIDENDS_TO_EXPIRY_STR, dividendsToExpiry, DdeRequestStatus.SUBSCRIBED);
    }

    @Override
    public void orderStatus(int orderId, String status, double filled, 
            double remaining, double avgFillPrice, int permId, int parentId, 
            double lastFillPrice, int clientId, String whyHeld, double mktCapPrice) {
        System.out.println("orderStatus OrderId [" + orderId + "] Status [" + status + "] Filled [" + filled + "] "
                + "Remaining [" + remaining + "] AvgFillPrice [" + avgFillPrice + "] PermId [" + permId + "]"
                + " ParentId [" + parentId + "] LastFillPrice [" + lastFillPrice + "] ClientId [" + clientId + "] "
                + "WhyHeld [" + whyHeld + "] MktCapPrice [" + mktCapPrice + "]");
        
        m_twsService.updateOrderStatus(new OrderStatusData(orderId, status, filled, remaining, avgFillPrice, permId, 
                parentId, lastFillPrice, clientId, whyHeld, mktCapPrice));
        
        // exercise options
        // 2400001-2500000 - exerciseOptions
        if (orderId >= 2400001 && orderId <= 2500000) {
            m_twsService.updateExerciseOptionsOrderStatus(orderId, status);
        }
    }

    @Override
    public void openOrder(int orderId, Contract contract, Order order, OrderState orderState) {
        System.out.println("openOrder OrderId [" + orderId + "] Contract [" + Utils.shortContractString(contract) + "] Order [" + Utils.shortOrderString(order) + "]");
        m_twsService.updateOpenOrderData(new OpenOrderData(orderId, contract, order, orderState, true));
    }

    @Override
    public void openOrderEnd() {
        System.out.println("openOrderEnd");
        m_twsService.updateOpenOrderEnd();
    }

    @Override
    public void nextValidId(int orderId) {
        System.out.println("nextValidId [" + orderId + "]");
        m_twsService.setMarketDataType();
    }
    
    @Override
    public void execDetails(int reqId, Contract contract, Execution execution) {
        System.out.println("execDetails ReqId [" + reqId + "] Contract [" + Utils.shortContractString(contract) + "] Execution: " + Utils.shortExecutionString(execution));
        m_twsService.updateExecution(reqId, new ExecutionData(contract, execution));
    }

    @Override
    public void execDetailsEnd(int reqId) {
        System.out.println("execDetailsEnd ReqId [" + reqId + "]");
        m_twsService.updateExecutionEnd(reqId);
    }

    @Override
    public void currentTime(long time) {
        System.out.println("currentTime Time [" + time + "]");
        m_twsService.updateCurrentTime(time);
    }

    @Override
    public void managedAccounts(String accountsList) {
        System.out.println("managedAccounts AccountsList [" + accountsList + "]");
        m_twsService.updateManagedAccounts(accountsList);
    }

    @Override
    public void position(String account, Contract contract, double pos, double avgCost) {
        System.out.println("position Account [" + account + "] Contract [" + Utils.shortContractString(contract) + "] Position [" + pos + "] AvgCost [" + avgCost + "]");
        m_twsService.updatePositionData(new PositionData(0, account, "", contract, pos, avgCost), DdeRequestType.REQ_POSITIONS);
    }

    @Override
    public void positionEnd() {
        System.out.println("positionEnd");
        m_twsService.updatePositionDataEnd(0, DdeRequestType.REQ_POSITIONS);
    }

    @Override
    public void connectAck() {
        System.out.println("connectAck");
    }

    @Override
    public void positionMulti(int reqId, String account, String modelCode, Contract contract, double pos, double avgCost) {
        System.out.println("positionMulti ReqId [" + reqId + "] Account [" + account + "] ModelCode [" + modelCode + "] Contract [" + Utils.shortContractString(contract) + "] Position [" + pos + "] AvgCost [" + avgCost + "]");
        m_twsService.updatePositionData(new PositionData(reqId, account, modelCode, contract, pos, avgCost), DdeRequestType.REQ_POSITIONS_MULTI);
    }

    @Override
    public void positionMultiEnd(int reqId) {
        System.out.println("positionMultiEnd ReqId [" + reqId + "]");
        m_twsService.updatePositionDataEnd(reqId, DdeRequestType.REQ_POSITIONS_MULTI);
    }

    @Override
    public void accountUpdateMulti(int reqId, String account, String modelCode, String key, String value, String currency) {
        System.out.println("accountUpdateMulti ReqId [" + reqId + "] Account [" + account + "] ModelCode [" + modelCode + "] Key [" + key + "] Value [" + value + "] Currency [" + currency + "]");
        m_twsService.updateAccountUpdate(new AccountUpdateData(reqId, account, modelCode, key, value, currency), DdeRequestType.REQ_ACCOUNT_UPDATES_MULTI);
    }

    @Override
    public void accountUpdateMultiEnd(int reqId) {
        System.out.println("accountUpdateMultiEnd ReqId [" + reqId + "]");
        m_twsService.updateAccountDataEnd(reqId, DdeRequestType.REQ_ACCOUNT_UPDATES_MULTI);
    }

    @Override
    public void updateAccountTime(String timeStamp) {
        System.out.println("updateAccountTime TimeStamp [" + timeStamp + "]");
        m_twsService.updateAccountTime(timeStamp);
    }
    
    @Override
    public void commissionReport(CommissionReport commissionReport) {
        System.out.println("commissionReport ExecId [" + commissionReport.execId() + "] Commission [" + commissionReport.commission() + 
                "] Currency [" + commissionReport.currency() + "] RealizedPnL [" + commissionReport.realizedPNL() + 
                "] Yield [" + commissionReport.yield() + "] YieldRedemptionDate [" + commissionReport.yieldRedemptionDate() + "]");
        m_twsService.updateCommissionReport(commissionReport);
    }

    @Override
    public void accountSummary(int reqId, String account, String tag, String value, String currency) {
        System.out.println("accountSummary ReqId [" + reqId + "] Account [" + account + "] Tag [" + tag + "] Value [" + value + "] Currency [" + currency + "]");
        m_twsService.updateAccountUpdate(new AccountUpdateData(reqId, account, "", tag, value, currency), DdeRequestType.REQ_ACCOUNT_SUMMARY);
    }

    @Override
    public void accountSummaryEnd(int reqId) {
        System.out.println("accountSummaryEnd ReqId [" + reqId + "]");
        m_twsService.updateAccountDataEnd(reqId, DdeRequestType.REQ_ACCOUNT_SUMMARY);
    }

    
    @Override
    public void updateAccountValue(String key, String value, String currency, String accountName) {
        System.out.println("updateAccountValue Key [" + key + "] Value [" + value + "] Currency [" + currency + "] Account [" + accountName + "]");
        m_twsService.updateAccountUpdate(new AccountUpdateData(0, accountName, "", key, value, currency), DdeRequestType.REQ_ACCOUNT_PORTFOLIO);
    }

    @Override
    public void updatePortfolio(Contract contract, double position, 
            double marketPrice, double marketValue, double averageCost, 
            double unrealizedPNL, double realizedPNL, String accountName) {
        System.out.println("updatePortfolio Contract [" + Utils.shortContractString(contract) + "] Position [" + position + "] MarketPrice [" + marketPrice + 
                "] MarketValue [" + marketValue + "] AverageCost [" + averageCost + "] UnrealizedPnL [" + unrealizedPNL + 
                "] RealizedPnL [" + realizedPNL + "] AccountName [" + accountName + "]");
        m_twsService.updatePortfolio(new PositionData(0, accountName, contract, position, averageCost, marketPrice, marketValue, 
                unrealizedPNL, realizedPNL));
    }

    @Override
    public void accountDownloadEnd(String accountName) {
        System.out.println("accountDownloadEnd Account [" + accountName + "]");
        m_twsService.updateAccountDataEnd(0, DdeRequestType.REQ_ACCOUNT_PORTFOLIO);
    }

    @Override
    public void updateNewsBulletin(int msgId, int msgType, String message, String origExchange) {
        System.out.println("updateNewsBulletin MsgId [" + msgId + "] MsgType [" + msgType + "] Message [" + message + "] OrigExchange [" + origExchange + "]");
        m_twsService.updateNewsBulletins(new NewsBulletinData(msgId, msgType, message, origExchange));
    }

    @Override
    public void updateMktDepth(int tickerId, int position, int operation, int side, double price, int size) {
        /* not supported */
        System.out.println("updateMktDepth TickerId [" + tickerId + "] Position [" + position + "] Operation [" + operation + "] "
                + "Side [" + side + "] Price [" + price + "] Size [" + size + "] ");
    }

    @Override
    public void updateMktDepthL2(int tickerId, int position, String marketMaker, int operation, int side, double price, int size, boolean isSmartDepth) {
        System.out.println("updateMktDepthL2 TickerId [" + tickerId + "] Position [" + position + "] MarketMaker [" + marketMaker + "] Operation [" + operation + "] "
                + "Side [" + side + "] Price [" + price + "] Size [" + size + "] IsSmartDepth [" + isSmartDepth + "]");
        m_twsService.updateMarketDepthData(tickerId, new MarketDepthData(position, marketMaker, operation, side, price, size, isSmartDepth), DdeRequestStatus.SUBSCRIBED);
    }
    
    @Override
    public void scannerParameters(String xml) {
        System.out.println("scannerParameters");
        m_twsService.updateScannerParameters(xml);
    }

    @Override
    public void scannerData(int reqId, int rank,
            ContractDetails contractDetails, String distance, String benchmark,
            String projection, String legsStr) {
        System.out.println("scannerData ReqId [" + reqId + "] Rank [" + rank + "] Contract [" + Utils.shortContractString(contractDetails.contract()) + "] "
                + "Distance [" + distance + "] Benchmark [" + benchmark + "] Projection [" + projection + "] LegsStr [" + legsStr + "]");
        m_twsService.updateScannerData(reqId, new ScannerData(reqId, rank, contractDetails, distance, benchmark, projection, legsStr));
    }

    @Override
    public void scannerDataEnd(int reqId) {
        System.out.println("scannerDataEnd ReqId [" + reqId + "]");
        m_twsService.updateScannerDataEnd(reqId);
    }
    
    @Override
    public void contractDetails(int reqId, ContractDetails contractDetails) {
        System.out.println("contractDetails ReqId [" + reqId + "] ContractDetails [" + Utils.shortContractString(contractDetails.contract()) + "]");
        m_twsService.updateContractDetails(reqId, contractDetails);
    }

    @Override
    public void bondContractDetails(int reqId, ContractDetails contractDetails) {
        System.out.println("bondContractDetails ReqId [" + reqId + "] ContractDetails [" + Utils.shortContractString(contractDetails.contract()) + "]");
        m_twsService.updateContractDetails(reqId, contractDetails);
    }

    @Override
    public void contractDetailsEnd(int reqId) {
        System.out.println("contractDetailsEnd ReqId [" + reqId + "]");
        m_twsService.updateContractDetailsEnd(reqId);
    }

    @Override
    public void historicalData(int reqId, Bar bar) {
        System.out.println("historicalData ReqId [" + reqId + "] Time [" + bar.time() + "] Open [" + bar.open() + "] High [" + bar.high() + "] "
                + "Low [" + bar.low() + "] Close [" + bar.close() + "] Volume [" + bar.volume() + "] Count [" + bar.count() + "] "
                + "Wap [" + bar.wap() + "]");
        m_twsService.updateHistoricalData(reqId, bar);
    }
    
    @Override
    public void historicalDataEnd(int reqId, String startDateStr, String endDateStr) {
        System.out.println("historicalDataEnd ReqId [" + reqId + "] StartDate [" + startDateStr + "] EndDate [" + endDateStr + "]");
        m_twsService.updateHistoricalDataEnd(reqId);
    }

    @Override
    public void historicalDataUpdate(int reqId, Bar bar) {
        System.out.println("historicalDataUpdate ReqId [" + reqId + "] Time [" + bar.time() + "] Open [" + bar.open() + "] High [" + bar.high() + "] "
                + "Low [" + bar.low() + "] Close [" + bar.close() + "] Volume [" + bar.volume() + "] Count [" + bar.count() + "] "
                + "Wap [" + bar.wap() + "]");
        m_twsService.liveUpdateHistoricalData(reqId, bar);
    }

    @Override
    public void realtimeBar(int reqId, long time, double open, double high, double low, double close, long volume, double wap, int count) {
        System.out.println("realTimeBar ReqId [" + reqId + "] Time [" + time + "] Open [" + open + "] High [" + high + "] "
                + "Low [" + low + "] Close [" + close + "] Volume [" + volume + "] Count [" + count + "] Wap [" + wap + "]");
        m_twsService.updateRealTimeBars(reqId, new Bar(Utils.longSecondsToDateTimeString(time, "yyyyMMdd HH:mm:ss"), open, high, low, close, volume, count, wap));
    }
    
    @Override
    public void tickByTickAllLast(int reqId, int tickType, long time, double price, int size, TickAttribLast attribs,
            String exchange, String specialConditions) {
        System.out.println("tickByTickAllLast ReqId [" + reqId + "] TickType [" + tickType + "] Time [" + time + "] Price [" + price + "] "
                + "Size [" + size + "] PastLimit [" + attribs.pastLimit() + "] Unreported [" + attribs.unreported() + "]");
        m_twsService.updateTickByTickData(reqId, Utils.TIME, Utils.longSecondsToDateTimeString(time, "HH:mm:ss"), DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateTickByTickData(reqId, Utils.PRICE, price, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateTickByTickData(reqId, Utils.SIZE, size, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateTickByTickData(reqId, Utils.PAST_LIMIT, attribs.pastLimit(), DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateTickByTickData(reqId, Utils.UNREPORTED, attribs.unreported(), DdeRequestStatus.SUBSCRIBED);

        m_twsService.updateTickByTickDataExt(reqId, new TickByTickData(time, price, size, attribs, exchange, specialConditions), DdeRequestStatus.SUBSCRIBED);
    }

    @Override
    public void tickByTickBidAsk(int reqId, long time, double bidPrice, double askPrice, int bidSize, int askSize,
            TickAttribBidAsk attribs) {
        System.out.println("tickByTickBidAsk ReqId [" + reqId + "] Time [" + time + "] BidPrice [" + bidPrice + "] AskPrice [ " + askPrice + "] "
                + "BidSize [" + bidSize + "] AskSize [" + askSize + "] BidPastLow [" + attribs.bidPastLow() + "] AskPastHigh [" + attribs.askPastHigh() + "]");
        
        m_twsService.updateTickByTickData(reqId, Utils.TIME, Utils.longSecondsToDateTimeString(time, "HH:mm:ss"), DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateTickByTickData(reqId, Utils.BID_PRICE, bidPrice, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateTickByTickData(reqId, Utils.ASK_PRICE, askPrice, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateTickByTickData(reqId, Utils.BID_SIZE, bidSize, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateTickByTickData(reqId, Utils.ASK_SIZE, askSize, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateTickByTickData(reqId, Utils.BID_PAST_LOW, attribs.bidPastLow(), DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateTickByTickData(reqId, Utils.ASK_PAST_HIGH, attribs.askPastHigh(), DdeRequestStatus.SUBSCRIBED);

        m_twsService.updateTickByTickDataExt(reqId - 50000, new TickByTickData(time, bidPrice, askPrice, bidSize, askSize, attribs), DdeRequestStatus.SUBSCRIBED);
    }

    @Override
    public void tickByTickMidPoint(int reqId, long time, double midPoint) {
        System.out.println("tickByTickMidPoint ReqId [" + reqId + "] Time [" + time + "] MidPoint [" + midPoint + "]");
        m_twsService.updateTickByTickData(reqId, Utils.TIME, Utils.longSecondsToDateTimeString(time, "HH:mm:ss"), DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateTickByTickData(reqId, Utils.MIDPOINT, midPoint, DdeRequestStatus.SUBSCRIBED);
        
        m_twsService.updateTickByTickDataExt(reqId, new TickByTickData(time, midPoint), DdeRequestStatus.SUBSCRIBED);
    }
    
    @Override
    public void fundamentalData(int reqId, String data) {
        System.out.println("fundamentalData ReqId [" + reqId + "]");
        m_twsService.updateFundamentalData(reqId, data);
    }

    @Override
    public void historicalTicks(int reqId, List<HistoricalTick> ticks, boolean done) {
        System.out.println("historicalTicks ReqId [" + reqId + "]");
        for (HistoricalTick tick : ticks) {
            System.out.println("historicalTick Time [" + tick.time() + "] Price [" + tick.price() + "]");
            m_twsService.updateHistoricalTicks(reqId, new TickByTickData(tick.time(), tick.price()));
        }
        if (done) {
            System.out.println("historicalTicksEnd ReqId [" + reqId + "]");
            m_twsService.updateHistoricalTicksEnd(reqId);
        }
    }

    @Override
    public void historicalTicksBidAsk(int reqId, List<HistoricalTickBidAsk> ticks, boolean done) {
        System.out.println("historicalTicksBidAsk ReqId [" + reqId + "]");
        for (HistoricalTickBidAsk tick : ticks) {
            System.out.println("historicalTickBidAsk Time [" + tick.time() + "] PriceBid [" + tick.priceBid() + "] PriceAsk [" + tick.priceAsk() + "]"
                    + " SizeBid [" + tick.sizeBid() + "] SizeAsk [" + tick.sizeAsk() + "]"
                    + " BidPastLow [" + tick.tickAttribBidAsk().bidPastLow() + "] AskPastHigh [" + tick.tickAttribBidAsk().askPastHigh() + "]");
            m_twsService.updateHistoricalTicks(reqId, new TickByTickData(tick.time(), tick.priceBid(), tick.priceAsk(), 
                    tick.sizeBid(), tick.sizeAsk(), tick.tickAttribBidAsk()));
        }
        if (done) {
            System.out.println("historicalTicksBidAskEnd ReqId [" + reqId + "]");
            m_twsService.updateHistoricalTicksEnd(reqId);
        }
    }

    @Override
    public void historicalTicksLast(int reqId, List<HistoricalTickLast> ticks, boolean done) {
        System.out.println("historicalTicksLast ReqId [" + reqId + "]");
        for (HistoricalTickLast tick : ticks) {
            System.out.println("historicalTickLast Time [" + tick.time() + "] Price [" + tick.price() + "] Size [" + tick.size() + "]"
                    + " Exchange [" + tick.exchange() + "] Special Conditions [" + tick.specialConditions() + "]"
                    + " PastLimit [" + tick.tickAttribLast().pastLimit() + "] Unreported [" + tick.tickAttribLast().unreported() + "]");
            m_twsService.updateHistoricalTicks(reqId, new TickByTickData(tick.time(), tick.price(), tick.size(), tick.tickAttribLast(), 
                    tick.exchange(), tick.specialConditions()));
        }
        if (done) {
            System.out.println("historicalTicksLastEnd ReqId [" + reqId + "]");
            m_twsService.updateHistoricalTicksEnd(reqId);
        }
    }

    @Override
    public void securityDefinitionOptionalParameter(int reqId, String exchange, int underlyingConId,
            String tradingClass, String multiplier, Set<String> expirations, Set<Double> strikes) {
        System.out.println("securityDefinitionOptionParameter ReqId [" + reqId + "] Exchange [" + exchange + "] UnderlyingConId [" + underlyingConId + "]"
                + " TradingClass [" + tradingClass + "] Multipier [" + multiplier + "]"
                + " Expirations [" + expirations + "] Strikes [" + strikes + "]");
        m_twsService.updateSecDefOptParams(reqId, new SecDefOptParamsData(exchange, underlyingConId, tradingClass, 
                multiplier, expirations, strikes));
    }
    
    @Override
    public void securityDefinitionOptionalParameterEnd(int reqId) {
        System.out.println("securityDefinitionOptionParameterEnd ReqId [" + reqId + "]");
        m_twsService.updateSecDefOptParamsEnd(reqId);
    }

    @Override
    public void familyCodes(FamilyCode[] familyCodes) {
        System.out.println("familyCodes:");
        for (FamilyCode familyCode : familyCodes) {
            System.out.println("familyCode AccountId [" + familyCode.accountID() + "] FamilyCode [" + familyCode.familyCodeStr() + "]");
        }
        m_twsService.updateFamilyCodes(familyCodes);
    }

    @Override
    public void headTimestamp(int reqId, String headTimestamp) {
        System.out.println("headTimestamp ReqId [" + reqId + "] HeadTimestamp [" + headTimestamp + "]");
        m_twsService.updateHeadTimestamp(reqId, headTimestamp);
    }

    @Override
    public void symbolSamples(int reqId, ContractDescription[] contractDescriptions) {
        System.out.println("symbolSamples ReqId [" + reqId + "]:");
        for (ContractDescription contractDescription : contractDescriptions) {
            System.out.println("contractDescription ConId [" + contractDescription.contract().conid() + "]"
                    + " Symbol [" + contractDescription.contract().symbol() + "] SecType [" + contractDescription.contract().getSecType() + "]"
                    + " PrimExchange [" + contractDescription.contract().primaryExch() + "] Currency [" + contractDescription.contract().currency() + "]"
                    + " Derivative SecTypes [" + contractDescription.derivativeSecTypes() + "]");
        }
        m_twsService.updateSymbolSamples(reqId, contractDescriptions);
    }

    @Override
    public void mktDepthExchanges(DepthMktDataDescription[] depthMktDataDescriptions) {
        for (DepthMktDataDescription depthMktDataDescription : depthMktDataDescriptions) {
            System.out.println("mktDepthExchange Exchange [" + depthMktDataDescription.exchange() + "]"
                    + " SecType [" + depthMktDataDescription.secType() + "] ListingExchange [" + depthMktDataDescription.listingExch() + "]"
                    + " ServiceDataType [" + depthMktDataDescription.serviceDataType() + "] AggGroup [" + depthMktDataDescription.aggGroup() + "]");
        }
        m_twsService.updateMktDepthExchanges(depthMktDataDescriptions);
    }
    
    @Override
    public void tickNews(int tickerId, long timeStamp, String providerCode, String articleId, String headline,
            String extraData) {
        System.out.println("tickNews ReqId [" + tickerId + "] Timestamp [" + timeStamp + "] ProviderCode [" + providerCode + "]"
                + " ArticleId [" + articleId + "] Headline [" + headline + "] ExtraData [" + extraData + "]");
        m_twsService.updateNewsData(tickerId, new NewsData(timeStamp, providerCode, articleId, headline, extraData), 
                DdeRequestType.NEWS_TICKS_TICK);
    }

    @Override
    public void newsProviders(NewsProvider[] newsProviders) {
        System.out.println("newsProviders:");
        for (NewsProvider newsProvider : newsProviders) {
            System.out.println("newsProvider Code [" + newsProvider.providerCode() + "] Name [" + newsProvider.providerName() + "]");
        }
        m_twsService.updateNewsProviders(newsProviders);
    }

    @Override
    public void historicalNews(int requestId, String time, String providerCode, String articleId, String headline) {
        System.out.println("historicalNews ReqId [" + requestId + "] Time [" + time + "] ProviderCode [" + providerCode + "]"
                + " ArticleId [" + articleId + "] Headline [" + headline + "]");
        m_twsService.updateNewsData(requestId, new NewsData(Utils.stringDateTimeToLong(time, "yyyy-MM-dd HH:mm:ss.s"), 
                providerCode, articleId, headline, ""), DdeRequestType.HISTORICAL_NEWS_TICK);
    }

    @Override
    public void historicalNewsEnd(int requestId, boolean hasMore) {
        System.out.println("historicalNewsEnd ReqId [" + requestId + "] HasMore [" + hasMore + "]");
        m_twsService.updateNewsDataEnd(requestId, DdeRequestType.HISTORICAL_NEWS_TICK);
    }

    @Override
    public void newsArticle(int requestId, int articleType, String articleText) {
        System.out.println("newsArticle ReqId [" + requestId + "] ArticleType [" + articleType + "]");
        m_twsService.updateNewsArticle(requestId, articleType, articleText);
    }

    @Override
    public void pnl(int reqId, double dailyPnL, double unrealizedPnL, double realizedPnL) {
        System.out.println("pnl ReqId [" + reqId + "] DailyPnL [" + dailyPnL + "] UnrealizedPnL [" + unrealizedPnL + "] RealizedPnL [" + realizedPnL + "]");
        m_twsService.updatePnL(reqId, Utils.POSITION, Integer.MAX_VALUE, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updatePnL(reqId, Utils.DAILY_PNL, dailyPnL, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updatePnL(reqId, Utils.UNREALIZED_PNL, unrealizedPnL, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updatePnL(reqId, Utils.REALIZED_PNL, realizedPnL, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updatePnL(reqId, Utils.VALUE, Double.MAX_VALUE, DdeRequestStatus.SUBSCRIBED);
    }

    @Override
    public void pnlSingle(int reqId, int pos, double dailyPnL, double unrealizedPnL, double realizedPnL, double value) {
        System.out.println("pnlSingle ReqId [" + reqId + "] Position [" + pos + "] DailyPnL [" + dailyPnL + "] UnrealizedPnL [" + unrealizedPnL + "] "
                + "RealizedPnL [" + realizedPnL + "] Value [" + value + "]");
        m_twsService.updatePnL(reqId, Utils.POSITION, pos, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updatePnL(reqId, Utils.DAILY_PNL, dailyPnL, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updatePnL(reqId, Utils.UNREALIZED_PNL, unrealizedPnL, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updatePnL(reqId, Utils.REALIZED_PNL, realizedPnL, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updatePnL(reqId, Utils.VALUE, value, DdeRequestStatus.SUBSCRIBED);
    }

    @Override
    public void rerouteMktDataReq(int reqId, int conId, String exchange) {
        System.out.println("rerouteMktDataReq ReqId [" + reqId + "] ConId [" + conId + "] Exchange [" + exchange + "]");
        String errorMsgStr = "Re-route market data request. Req Id: " + reqId + ", Con Id: " + conId + ", Exchange: " + exchange;
        m_twsService.updateMarketDataError(reqId, errorMsgStr);
    }

    @Override
    public void rerouteMktDepthReq(int reqId, int conId, String exchange) {
        System.out.println("rerouteMktDepthReq ReqId [" + reqId + "] ConId [" + conId + "] Exchange [" + exchange + "]");
        String errorMsgStr = "Re-route market depth request. Req Id: " + reqId + ", Con Id: " + conId + ", Exchange: " + exchange;
        m_twsService.updateMarketDepthError(reqId, errorMsgStr);
    }

    @Override
    public void marketDataType(int reqId, int marketDataType) {
        System.out.println("marketDataType TickerId [" + reqId+ "] MarketDataType [" + marketDataType + "]");
        m_twsService.updateMarketData(reqId, Utils.MARKET_DATA_TYPE, MarketDataType.getField(marketDataType), DdeRequestStatus.SUBSCRIBED);
    }

    @Override
    public void marketRule(int marketRuleId, PriceIncrement[] priceIncrements) {
        System.out.println("marketRule Id [" + marketRuleId + "]");
        for (PriceIncrement priceIncrement : priceIncrements) {
            System.out.println("priceIncrement LowEdge [" + priceIncrement.lowEdge() + "] Increment [" + priceIncrement.increment() + "]");
        }
        m_twsService.updatePriceIncrements(0, priceIncrements);
    }
    
    @Override
    public void tickReqParams(int tickerId, double minTick, String bboExchange, int snapshotPermissions) {
        System.out.println("tickReqParams TickerId [" + tickerId + "] MinTick [" + minTick + "]"
                + " BboExchange [" + bboExchange + "] SnapshotPermissions [" + snapshotPermissions + "]");
        m_twsService.updateMarketData(tickerId, Utils.MIN_TICK, minTick, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, Utils.BBO_EXCHANGE, bboExchange, DdeRequestStatus.SUBSCRIBED);
        m_twsService.updateMarketData(tickerId, Utils.SNAPSHOT_PERMISSIONS, snapshotPermissions, DdeRequestStatus.SUBSCRIBED);
    }

    @Override
    public void smartComponents(int reqId, Map<Integer, Entry<String, Character>> theMap) {
        System.out.println("smartComponents: ReqId [" + reqId + "]");
        for (Entry<String, Character> smartComponent : theMap.values()) {
            System.out.println("SmartComponent [" + smartComponent.getKey() + "=" + smartComponent.getValue() + "]");
        }
        m_twsService.updateSmartComponents(reqId, theMap);
    }
    
    @Override
    public void softDollarTiers(int reqId, SoftDollarTier[] tiers) {
        System.out.println("softDollarTiers:");
        for (SoftDollarTier tier : tiers) {
            System.out.println("softDollarTier Name [" + tier.name() + "] Value [" + tier.value() + "] DisplayName [" + tier.toString() + "]");
        }
        m_twsService.updateSoftDollarTiers(reqId,  tiers);
    }

    @Override
    public void histogramData(int reqId, List<HistogramEntry> items) {
        System.out.println("histogramData:");
        for (HistogramEntry item : items) {
            System.out.println("histogramEntry Price [" + item.price + "] Value [" + item.size + "]");
        }
        m_twsService.updateHistogramData(reqId,  items);
    }
    
    @Override
    public void receiveFA(int faDataType, String xml) {
        System.out.println("ReceiveFA FADataType [" + faDataType + "]");
        m_twsService.updateFA(faDataType,  xml);
    }

    @Override
    public void deltaNeutralValidation(int reqId, DeltaNeutralContract deltaNeutralContract) {
        /* not yet supported */
    }

    @Override
    public void tickSnapshotEnd(int reqId) {
        /* not yet supported */
    }

    @Override
    public void verifyMessageAPI(String apiData) {
        /* not yet supported */
    }

    @Override
    public void verifyCompleted(boolean isSuccessful, String errorText) {
        /* not yet supported */
    }

    @Override
    public void verifyAndAuthMessageAPI(String apiData, String xyzChallenge) {
        /* not yet supported */
    }

    @Override
    public void verifyAndAuthCompleted(boolean isSuccessful, String errorText) {
        /* not yet supported */
    }

    @Override
    public void displayGroupList(int reqId, String groups) {
        /* not yet supported */
    }

    @Override
    public void displayGroupUpdated(int reqId, String contractInfo) {
        /* not yet supported */
    }

    @Override
    public void orderBound(long orderId, int apiClientId, int apiOrderId) {
        /* not yet supported */
    }

    @Override
    public void completedOrder(Contract contract, Order order, OrderState orderState) {
        System.out.println("completedOrder Contract [" + Utils.shortContractString(contract) + "] Order [" + Utils.shortOrderString(order) + "]");
        m_twsService.updateCompletedOrderData(new OrderData(contract, order, orderState));
    }

    @Override
    public void completedOrdersEnd() {
        System.out.println("completedOrdersEnd");
        m_twsService.updateCompletedOrdersEnd();
    }
}
