/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using IBApi;

namespace TWSLib
{
    [ComVisible(true)]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    [Guid("0A77CCF7-052C-11D6-B0EC-00B0D074179C")]
    public interface ITwsEvents
    {
        [DispId(1)]
        void tickPrice(int id, int tickType, double price, bool canAutoExecute, bool pastLimit, bool preOpen);
        [DispId(2)]
        void tickSize(int id, int tickType, int size);
        [DispId(3)]
        void connectionClosed();
        [DispId(4)]
        void openOrder1(int id, string symbol, string secType, string lastTradeDate, double strike, string right, string exchange, string curency, string localSymbol);
        [DispId(5)]
        void openOrder2(int id, string action, double quantity, string orderType, double lmtPrice, double auxPrice, string tif, string ocaGroup, string account, string openClose, int origin, string orderRef, int clientId);
        [DispId(6)]
        void updateAccountTime(string timeStamp);
        [DispId(7)]
        void updateAccountValue(string key, string value, string curency, string accountName);
        [DispId(8)]
        void nextValidId(int id);
        [DispId(10)]
        void permId(int id, int permId);
        [DispId(11)]
        void errMsg(int id, int errorCode, string errorMsg);
        [DispId(12)]
        void updatePortfolio(string symbol, string secType, string lastTradeDate, double strike, string right, string curency, string localSymbol, double position, double marketPrice, double marketValue, double averageCost, double unrealizedPNL, double realizedPNL, string accountName);
        [DispId(13)]
        void orderStatus(int id, string status, double filled, double remaining, double avgFillPrice, int permId, int parentId, double lastFillPrice, int clientId, string whyHeld, double mktCapPrice);
        [DispId(14)]
        void contractDetails(string symbol, string secType, string lastTradeDate, double strike, string right, string exchange, string curency, string localSymbol, string marketName, string tradingClass, int conId, double minTick, int priceMagnifier, string multiplier, string orderTypes, string validExchanges);
        [DispId(15)]
        void execDetails(int id, string symbol, string secType, string lastTradeDate, double strike, string right, string cExchange, string curency, string localSymbol, string execId, string time, string acctNumber, string eExchange, string side, double shares, double price, int permId, int clientId, int isLiquidation, string lastLiquidity);
        [DispId(16)]
        void updateMktDepth(int id, int position, int operation, int side, double price, int size);
        [DispId(17)]
        void updateMktDepthL2(int id, int position, string marketMaker, int operation, int side, double price, int size, bool isSmartDepth);
        [DispId(18)]
        void updateNewsBulletin(short msgId, short msgType, string message, string origExchange);
        [DispId(19)]
        void managedAccounts(string accountsList);
        [DispId(20)]
        void openOrder3(int id, string symbol, string secType, string lastTradeDate, double strike, string right, string exchange, string curency, string localSymbol, string action, double quantity, string orderType, double lmtPrice, double auxPrice, string tif, string ocaGroup, string account, string openClose, int origin, string orderRef, int clientId, int permId, string sharesAllocation, string faGroup, string faMethod, string faPercentage, string faProfile, string goodAfterTime, string goodTillDate);
        [DispId(21)]
        void receiveFA(int faDataType, string cxml);
        [DispId(22)]
        void historicalData(int reqId, string date, double open, double high, double low, double close, int volume, int barCount, double WAP, int hasGaps);
        [DispId(23)]
        void openOrder4(int id, string symbol, string secType, string lastTradeDate, double strike, string right, string exchange, string curency, string localSymbol, string action, double quantity, string orderType, double lmtPrice, double auxPrice, string tif, string ocaGroup, string account, string openClose, int origin, string orderRef, int clientId, int permId, string sharesAllocation, string faGroup, string faMethod, string faPercentage, string faProfile, string goodAfterTime, string goodTillDate, int ocaType, string rule80A, string settlingFirm, int allOrNone, int minQty, double percentOffset, int eTradeOnly, int firmQuoteOnly, double nbboPriceCap, int auctionStrategy, double startingPrice, double stockRefPrice, double delta, double stockRangeLower, double stockRangeUpper, int blockOrder, int sweepToFill, int ignoreRth, int hidden, double discretionaryAmt, int displaySize, int parentId, int triggerMethod, int shortSaleSlot, string designatedLocation, double volatility, int volatilityType, string deltaNeutralOrderType, double deltaNeutralAuxPrice, int continuousUpdate, int referencePriceType, double trailStopPrice, double basisPoints, int basisPointsType, string legsStr, int scaleInitLevelSize, int scaleSubsLevelSize, double scalePriceIncrement);
        [DispId(24)]
        void bondContractDetails(string symbol, string secType, string cusip, double coupon, string maturity, string issueDate, string ratings, string bondType, string couponType, int convertible, int callable, int putable, string descAppend, string exchange, string curency, string marketName, string tradingClass, int conId, double minTick, string orderTypes, string validExchanges, string nextOptionDate, string nextOptionType, int nextOptionPartial, string notes);
        [DispId(25)]
        void scannerParameters(string xml);
        [DispId(26)]
        void scannerData(int reqId, int rank, string symbol, string secType, string lastTradeDate, double strike, string right, string exchange, string curency, string localSymbol, string marketName, string tradingClass, string distance, string benchmark, string projection, string legsStr);
        [DispId(27)]
        void tickOptionComputation(int id, int tickType, int tickAttrib, double impliedVol, double delta, double optPrice, double pvDividend, double gamma, double vega, double theta, double undPrice);
        [DispId(28)]
        void tickGeneric(int id, int tickType, double value);
        [DispId(29)]
        void tickString(int id, int tickType, string value);
        [DispId(30)]
        void tickEFP(int tickerId, int field, double basisPoints, string formattedBasisPoints,
                     double totalDividends, int holdDays, string futureLastTradeDate, double dividendImpact,
                     double dividendsToLastTradeDate);
        [DispId(31)]
        void realtimeBar(int tickerId, int time, double open, double high, double low, double close,
                         int volume, double WAP, int count);
        [DispId(32)]
        void currentTime(int time);
        [DispId(33)]
        void scannerDataEnd(int reqId);
        [DispId(34)]
        void fundamentalData(int reqId, string data);
        [DispId(35)]
        void contractDetailsEnd(int reqId);
        [DispId(36)]
        void openOrderEnd();
        [DispId(37)]
        void accountDownloadEnd(string accountName);
        [DispId(38)]
        void execDetailsEnd(int reqId);
        [DispId(39)]
        void deltaNeutralValidation(int reqId, IDeltaNeutralContract deltaNeutralContract);
        [DispId(40)]
        void tickSnapshotEnd(int reqId);
        [DispId(41)]
        void marketDataType(int reqId, int marketDataType);
        [DispId(100)]
        void contractDetailsEx(int reqId, IContractDetails contractDetails);
        [DispId(101)]
        void openOrderEx(int orderId, IContract contract, IOrder order, IOrderState orderState);
        [DispId(102)]
        void execDetailsEx(int reqId, IContract contract, IExecution execution);
        [DispId(103)]
        void updatePortfolioEx(IContract contract, double position, double marketPrice,
            double marketValue, double averageCost, double unrealizedPNL, double realizedPNL, string accountName);
        [DispId(104)]
        void scannerDataEx(int reqId, int rank, IContractDetails contractDetails, string distance, string benchmark, string projection, string legsStr);
        [DispId(105)]
        void commissionReport(ICommissionReport commissionReport);
        [DispId(106)]
        void position(string account, IContract contract, double position, double avgCost);
        [DispId(107)]
        void positionEnd();
        [DispId(108)]
        void accountSummary(int reqId, string account, string tag, string value, string curency);
        [DispId(109)]
        void accountSummaryEnd(int reqId);
        [DispId(110)]
        void verifyMessageAPI(string apiData);
        [DispId(111)]
        void verifyCompleted(bool isSuccessful, string errorText);
        [DispId(112)]
        void displayGroupList(int reqId, string groups);
        [DispId(113)]
        void displayGroupUpdated(int reqId, string contractInfo);
        [DispId(114)]
        void verifyAndAuthMessageAPI(string apiData, string xyzChallenge);
        [DispId(115)]
        void verifyAndAuthCompleted(bool isSuccessful, string errorText);
        [DispId(116)]
        void historicalDataEnd(int reqId, string startDate, string endDate);
        [DispId(117)]
        void bondContractDetailsEx(int reqId, IContractDetails contractDetails);
        [DispId(118)]
        void connectAck();
        [DispId(119)]
        void positionMulti(int requestId, string account, string modelCode, IContract contract, double position, double avgCost);
        [DispId(120)]
        void positionMultiEnd(int requestId);
        [DispId(121)]
        void accountUpdateMulti(int requestId, string account, string modelCode, string key, string value, string currency);
        [DispId(122)]
        void accountUpdateMultiEnd(int requestId);
        [DispId(123)]
        void securityDefinitionOptionParameter(
            int reqId, 
            string exchange, 
            int underlyingConId, 
            string tradingClass, 
            string multiplier,             
            string expirations,
            string strikes);
        [DispId(124)]
        void securityDefinitionOptionParameterEnd(int reqId);
        [DispId(125)]
        void softDollarTiers(int reqid, IComList tiers);
        [DispId(126)]
        void familyCodes(IFamilyCodeList familyCodes);
        [DispId(127)]
        void symbolSamples(int reqId, IContractDescriptionList contractDescriptions);
        [DispId(128)]
        void mktDepthExchanges(IDepthMktDataDescriptionList depthMktDataDescriptions);
        [DispId(129)]
        void tickNews(int tickerId, string timeStamp, string providerCode, string articleId, string headline, string extraData);
        [DispId(130)]
        void smartComponents(int reqId, IComList theMap);
        [DispId(131)]
        void tickReqParams(int tickerId, double minTick, string bboExchange, int snapshotPermissions);
        [DispId(132)]
        void newsProviders(INewsProviderList newsProviders);
        [DispId(133)]
        void newsArticle(int requestId, int articleType, string articleText);
        [DispId(134)]
        void historicalNews(int requestId, string time, string providerCode, string articleId, string headline);
        [DispId(135)]
        void historicalNewsEnd(int requestId, bool hasMore);
        [DispId(136)]
        void headTimestamp(int reqId, string timestamp);
        [DispId(137)]
        void histogramData(int reqId, IHistogramEntry data);
        [DispId(138)]
        void rerouteMktDataReq(int reqId, int conId, string exchange);
        [DispId(139)]
        void rerouteMktDepthReq(int reqId, int conId, string exchange);
        [DispId(140)]
        void marketRule(int marketRuleId, IPriceIncrementList priceIncrements);
        [DispId(141)]
        void pnl(int reqId, double dailyPnL, double unrealizedPnL, double realizedPnL);
        [DispId(142)]
        void pnlSingle(int reqId, int pos, double dailyPnL, double unrealizedPnL, double realizedPnL, double value);
        [DispId(143)]
        void historicalTicks(int reqId, IHistoricalTickList ticks, bool done);
        [DispId(144)]
        void historicalTicksBidAsk(int reqId, IHistoricalTickBidAskList ticks, bool done);
        [DispId(145)]
        void historicalTicksLast(int reqId, IHistoricalTickLastList ticks, bool done);
        [DispId(146)]
        void tickByTickAllLast(int reqId, int tickType, string time, double price, int size, ITickAttribLast tickAttribLast, string exchange, string specialConditions);
        [DispId(147)]
        void tickByTickBidAsk(int reqId, string time, double bidPrice, double askPrice, int bidSize, int askSize, ITickAttribBidAsk tickAttribBidAsk);
        [DispId(148)]
        void tickByTickMidPoint(int reqId, string time, double midPoint);
        [DispId(149)]
        void orderBound(string orderId, int apiClientId, int apiOrderId);
        [DispId(150)]
        void histogramDataEnd(int reqId);
        [DispId(151)]
        void completedOrder(IContract contract, IOrder order, IOrderState orderState);
        [DispId(152)]
        void completedOrdersEnd();
        [DispId(153)]
        void replaceFAEnd(int reqId, string text);
    }
}
