/* Copyright (C) 2013 Interactive Brokers LLC. All rights reserved.  This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package apidemo;

import java.io.IOException;
import java.util.AbstractMap.SimpleEntry;
import java.util.Map;
import java.util.Set;

import com.ib.client.*;
import static apidemo.util.Util.sleep;

public class Test implements EWrapper {
	EJavaSignal m_signal = new EJavaSignal();
	EClientSocket m_s = new EClientSocket(this, m_signal);
	int NextOrderId = -1;

	public static void main(String[] args) {
		new Test().run();
	}

	private void run() {
		m_s.eConnect("localhost", 4002, 0);
		
        final EReader reader = new EReader(m_s, m_signal);
        
        reader.start();
       
		new Thread() {
			public void run() {
				while (m_s.isConnected()) {
					m_signal.waitForSignal();
					try {
						javax.swing.SwingUtilities
								.invokeAndWait(new Runnable() {
									@Override
									public void run() {
										try {
											reader.processMsgs();
										} catch (IOException e) {
											error(e);
										}
									}
								});
					} catch (Exception e) {
						error(e);
					}
				}
			}
		}.start();

		if (NextOrderId < 0) {
			sleep(1000);
		}

		m_s.reqSecDefOptParams(0, "IBM", "",/* "",*/ "STK", 8314);

		try {
			System.in.read();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		m_s.eDisconnect();
	}

	@Override public void nextValidId(int orderId) {
		NextOrderId = orderId;
		System.out.println(EWrapperMsgGenerator.nextValidId(orderId));
	}

	@Override public void error(Exception e) {
		System.out.println(EWrapperMsgGenerator.error(e));
	}

	@Override public void error(int id, int errorCode, String errorMsg) {
		System.out.println(EWrapperMsgGenerator.error(id, errorCode, errorMsg));
	}

	@Override public void connectionClosed() {
		System.out.println(EWrapperMsgGenerator.connectionClosed());
	}

	@Override public void error(String str) {
		System.out.println(EWrapperMsgGenerator.error(str));
	}

	@Override public void tickPrice(int tickerId, int field, double price, TickAttr attribs) {
		System.out.println(EWrapperMsgGenerator.tickPrice(tickerId, field, price, attribs));
	}

	@Override public void tickSize(int tickerId, int field, int size) {
		System.out.println(EWrapperMsgGenerator.tickSize(tickerId, field, size));
	}

	@Override public void tickOptionComputation(int tickerId, int field, double impliedVol, double delta, double optPrice, double pvDividend, double gamma, double vega, double theta, double undPrice) {
		System.out.println(EWrapperMsgGenerator.tickOptionComputation(tickerId, field, impliedVol, delta, optPrice, pvDividend, gamma, vega, theta, undPrice));
	}

	@Override public void tickGeneric(int tickerId, int tickType, double value) {
		System.out.println(EWrapperMsgGenerator.tickGeneric(tickerId, tickType, value));
	}

	@Override public void tickString(int tickerId, int tickType, String value) {
		System.out.println(EWrapperMsgGenerator.tickString(tickerId, tickType, value));
	}

	@Override public void tickEFP(int tickerId, int tickType, double basisPoints, String formattedBasisPoints, double impliedFuture, int holdDays, String futureLastTradeDate, double dividendImpact,
			double dividendsToLastTradeDate) {
		System.out.println(EWrapperMsgGenerator.tickEFP( tickerId, tickType, basisPoints, formattedBasisPoints, impliedFuture, holdDays, futureLastTradeDate, dividendImpact, dividendsToLastTradeDate));
	}

	@Override public void orderStatus(int orderId, String status, double filled, double remaining, double avgFillPrice, int permId, int parentId, double lastFillPrice, int clientId, String whyHeld) {
		System.out.println(EWrapperMsgGenerator.orderStatus( orderId,  status, filled, remaining, avgFillPrice, permId, parentId, lastFillPrice, clientId, whyHeld));
		}

	@Override public void openOrder(int orderId, Contract contract, Order order, OrderState orderState) {
		System.out.println(EWrapperMsgGenerator.openOrder( orderId, contract, order, orderState));
	}

	@Override public void openOrderEnd() {
		System.out.println(EWrapperMsgGenerator.openOrderEnd());
	}

	@Override public void updateAccountValue(String key, String value, String currency, String accountName) {
		System.out.println(EWrapperMsgGenerator.updateAccountValue( key, value, currency, accountName));
	}

	@Override public void updatePortfolio(Contract contract, double position, double marketPrice, double marketValue, double averageCost, double unrealizedPNL, double realizedPNL, String accountName) {
		System.out.println(EWrapperMsgGenerator.updatePortfolio( contract, position, marketPrice, marketValue, averageCost, unrealizedPNL, realizedPNL, accountName));
	}

	@Override public void updateAccountTime(String timeStamp) {
		System.out.println(EWrapperMsgGenerator.updateAccountTime( timeStamp));
	}

	@Override public void accountDownloadEnd(String accountName) {
		System.out.println(EWrapperMsgGenerator.accountDownloadEnd(accountName));
	}

	@Override public void contractDetails(int reqId, ContractDetails contractDetails) {
		System.out.println(EWrapperMsgGenerator.contractDetails( reqId, contractDetails));
	}

	@Override public void bondContractDetails(int reqId, ContractDetails contractDetails) {
		System.out.println(EWrapperMsgGenerator.bondContractDetails( reqId, contractDetails));
	}

	@Override public void contractDetailsEnd(int reqId) {
		System.out.println(EWrapperMsgGenerator.contractDetailsEnd(reqId));
	}

	@Override public void execDetails(int reqId, Contract contract, Execution execution) {
		System.out.println(EWrapperMsgGenerator.execDetails( reqId, contract, execution));
	}

	@Override public void execDetailsEnd(int reqId) {
		System.out.println(EWrapperMsgGenerator.execDetailsEnd( reqId));
	}

	@Override public void updateMktDepth(int tickerId, int position, int operation, int side, double price, int size) {
		System.out.println(EWrapperMsgGenerator.updateMktDepth(tickerId, position, operation, side, price, size));
	}

	@Override public void updateMktDepthL2(int tickerId, int position, String marketMaker, int operation, int side, double price, int size) {
		System.out.println(EWrapperMsgGenerator.updateMktDepthL2( tickerId, position, marketMaker, operation, side, price, size));
	}

	@Override public void updateNewsBulletin(int msgId, int msgType, String message, String origExchange) {
		System.out.println(EWrapperMsgGenerator.updateNewsBulletin( msgId, msgType, message, origExchange));
	}

	@Override public void managedAccounts(String accountsList) {
		System.out.println(EWrapperMsgGenerator.managedAccounts( accountsList));
	}

	@Override public void receiveFA(int faDataType, String xml) {
		System.out.println(EWrapperMsgGenerator.receiveFA( faDataType, xml));
	}

	@Override public void historicalData(int reqId, String date, double open, double high, double low, double close, int volume, int count, double WAP, boolean hasGaps) {
		System.out.println(EWrapperMsgGenerator.historicalData( reqId, date, open, high, low, close, volume, count, WAP, hasGaps));
	}

	@Override public void scannerParameters(String xml) {
		System.out.println(EWrapperMsgGenerator.scannerParameters(xml));
	}

	@Override public void scannerData(int reqId, int rank, ContractDetails contractDetails, String distance, String benchmark, String projection, String legsStr) {
		System.out.println(EWrapperMsgGenerator.scannerData( reqId, rank, contractDetails, distance, benchmark, projection, legsStr));
	}

	@Override public void scannerDataEnd(int reqId) {
		System.out.println(EWrapperMsgGenerator.scannerDataEnd(reqId));
	}

	@Override public void realtimeBar(int reqId, long time, double open, double high, double low, double close, long volume, double wap, int count) {
		System.out.println(EWrapperMsgGenerator.realtimeBar( reqId, time, open, high, low, close, volume, wap, count));
	}

	@Override public void currentTime(long time) {
		System.out.println(EWrapperMsgGenerator.currentTime( time));
	}

	@Override public void fundamentalData(int reqId, String data) {
		System.out.println(EWrapperMsgGenerator.fundamentalData( reqId,  data));
	}

	@Override public void deltaNeutralValidation(int reqId, DeltaNeutralContract underComp) {
		System.out.println(EWrapperMsgGenerator.deltaNeutralValidation( reqId, underComp));
	}

	@Override public void tickSnapshotEnd(int reqId) {
		System.out.println(EWrapperMsgGenerator.tickSnapshotEnd( reqId));
	}

	@Override public void marketDataType(int reqId, int marketDataType) {
		System.out.println(EWrapperMsgGenerator.marketDataType( reqId, marketDataType));
	}

	@Override public void commissionReport(CommissionReport commissionReport) {
		System.out.println(EWrapperMsgGenerator.commissionReport( commissionReport));
	}

	@Override public void position(String account, Contract contract, double pos, double avgCost) {
		System.out.println(EWrapperMsgGenerator.position( account,  contract,  pos,  avgCost));
	}

	@Override public void positionEnd() {
		System.out.println(EWrapperMsgGenerator.positionEnd());
	}

	@Override public void accountSummary(int reqId, String account, String tag, String value, String currency) {
		System.out.println(EWrapperMsgGenerator.accountSummary( reqId, account, tag, value, currency));
	}

	@Override public void accountSummaryEnd(int reqId) {
		System.out.println(EWrapperMsgGenerator.accountSummaryEnd( reqId));
	}
	
	@Override public void verifyMessageAPI( String apiData) {
	}

	@Override public void verifyCompleted( boolean isSuccessful, String errorText){
	}

	@Override public void verifyAndAuthMessageAPI( String apiData, String xyzChallenge) {
	}

	@Override public void verifyAndAuthCompleted( boolean isSuccessful, String errorText){
	}

	@Override public void displayGroupList( int reqId, String groups){
	}

	@Override public void displayGroupUpdated( int reqId, String contractInfo){
	}
	
	@Override public void positionMulti( int reqId, String account, String modelCode, Contract contract, double pos, double avgCost) {
		System.out.println(EWrapperMsgGenerator.positionMulti( reqId, account, modelCode, contract, pos, avgCost));
	}

	@Override public void positionMultiEnd( int reqId) {
		System.out.println(EWrapperMsgGenerator.positionMultiEnd( reqId));
	}

	@Override public void accountUpdateMulti( int reqId, String account, String modelCode, String key, String value, String currency) {
		System.out.println(EWrapperMsgGenerator.accountUpdateMulti( reqId, account, modelCode, key, value, currency));
	}

	@Override public void accountUpdateMultiEnd( int reqId) {
		System.out.println(EWrapperMsgGenerator.accountUpdateMultiEnd( reqId));
	}
	
	public void connectAck() {
	}

	@Override
	public void securityDefinitionOptionalParameter(int reqId, String exchange, int underlyingConId, String tradingClass,
			String multiplier, Set<String> expirations, Set<Double> strikes) {
		System.out.println(EWrapperMsgGenerator.securityDefinitionOptionalParameter( reqId, exchange, underlyingConId, tradingClass, multiplier, expirations, strikes));
	}

	@Override
	public void securityDefinitionOptionalParameterEnd(int reqId) {
		System.out.println(EWrapperMsgGenerator.securityDefinitionOptionalParameterEnd( reqId));
	}

	@Override
	public void softDollarTiers(int reqId, SoftDollarTier[] tiers) {
		System.out.println(EWrapperMsgGenerator.softDollarTiers( reqId,tiers));
	}

    @Override
    public void familyCodes(FamilyCode[] familyCodes) {
		System.out.println(EWrapperMsgGenerator.familyCodes(familyCodes));
    }

    @Override
    public void symbolSamples(int reqId, ContractDescription[] contractDescriptions) {
		System.out.println(EWrapperMsgGenerator.symbolSamples( reqId, contractDescriptions));
    }

	@Override
	public void historicalDataEnd(int reqId, String startDateStr, String endDateStr) {
		System.out.println(EWrapperMsgGenerator.historicalDataEnd( reqId, startDateStr, endDateStr));
	}

	@Override
	public void mktDepthExchanges(DepthMktDataDescription[] depthMktDataDescriptions) {
		System.out.println(EWrapperMsgGenerator.mktDepthExchanges(depthMktDataDescriptions));
	}

	@Override
	public void tickNews(int tickerId, long timeStamp, String providerCode, String articleId, String headline,
			String extraData) {
		System.out.println(EWrapperMsgGenerator.tickNews(tickerId, timeStamp, providerCode, articleId, headline, extraData));
	}

	@Override
	public void smartComponents(int reqId, Map<Integer, SimpleEntry<String, Character>> theMap) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void tickReqParams(int tickerId, double minTick, String bboExchange, int snapshotPermissions) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void newsProviders(NewsProvider[] newsProviders) {
		System.out.println(EWrapperMsgGenerator.newsProviders(newsProviders));
	}

	@Override
	public void newsArticle(int requestId, int articleType, String articleText) {
		System.out.println(EWrapperMsgGenerator.newsArticle(requestId, articleType, articleText));
	}

	@Override
	public void historicalNews(int requestId, String time, String providerCode, String articleId, String headline) {
		System.out.println(EWrapperMsgGenerator.historicalNews(requestId, time, providerCode, articleId, headline));
	}

	@Override
	public void historicalNewsEnd(int requestId, boolean hasMore) {
		System.out.println(EWrapperMsgGenerator.historicalNewsEnd(requestId, hasMore));
	}
}
