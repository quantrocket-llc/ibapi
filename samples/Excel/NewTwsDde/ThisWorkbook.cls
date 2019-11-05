VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub Workbook_Activate()
    Errors.startSubscription
    Positions.resubscribePositions
    PositionsMulti.resubscribePositionsMulti
    Executions.resubscribeExecutions
    AccountUpdatesMulti.resubscribeAccountUpdatesMulti
    AccountSummary.resubscribeAccountSummary
    MarketDepth.requestAllMktDepth
    MarketScanner.requestAllScannerSubscriptions
    AccountPortfolio.resubscribeAccountPortfolio
    HistoricalData.requestAllHistoricalData
    OpenOrders.resubscribeOpenOrders
    Tickers.requestAllMktData
    RealTimeBars.requestAllRealTimeBars
    TickByTick.requestAllTickByTickData
    TickByTickExt.requestAllTickByTickData
    TickNews.requestAllNewsTicks
    HistoricalNews.resubscribeNewsBulletins
    PnL.requestAllPnL
    ImplVolOptPrice.requestAllCalculateRequestsOnStart
    
    
End Sub

Private Sub Workbook_Deactivate()
    Errors.cancelSubscriptionOnExit
    Positions.cancelPositionsSubscriptionOnExit
    PositionsMulti.cancelPositionsMultiSubscriptionOnExit
    Executions.cancelExecutionsSubscriptionOnExit
    AccountUpdatesMulti.cancelAccountUpdatesMultiSubscriptionOnExit
    AccountSummary.cancelAccountSummarySubscriptionOnExit
    MarketDepth.cancelAllMktDepth
    MarketScanner.cancelAllScannerSubscriptions
    AccountPortfolio.cancelAccountPortfolioSubscriptionOnExit
    HistoricalData.cancelAllHistoricalData
    OpenOrders.cancelOpenOrdersSubscriptionOnExit
    Tickers.cancelAllMktData
    RealTimeBars.cancelAllRealTimeBars
    TickByTick.cancelAllTickByTickData
    TickByTickExt.cancelAllTickByTickData
    TickNews.cancelAllNewsTicks
    HistoricalNews.cancelNewsBulletinsSubscriptionOnExit
    PnL.cancelAllPnL
    ImplVolOptPrice.cancelAllCalculateRequestsOnExit
    AccountPortfolio.clearExerciseOptionsOnExit
   
    
End Sub
