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
    If util.sheetExists("Errors") Then
        Errors.cancelSubscriptionOnExit
    End If
    If util.sheetExists("Positions") Then
        Positions.cancelPositionsSubscriptionOnExit
    End If
    If util.sheetExists("PositionsMulti") Then
        PositionsMulti.cancelPositionsMultiSubscriptionOnExit
    End If
    If util.sheetExists("Executions") Then
        Executions.cancelExecutionsSubscriptionOnExit
    End If
    If util.sheetExists("AccountUpdatesMulti") Then
        AccountUpdatesMulti.cancelAccountUpdatesMultiSubscriptionOnExit
    End If
    If util.sheetExists("AccountSummary") Then
        AccountSummary.cancelAccountSummarySubscriptionOnExit
    End If
    If util.sheetExists("MarketDepth") Then
        MarketDepth.cancelAllMktDepth
    End If
    If util.sheetExists("MarketScanner") Then
        MarketScanner.cancelAllScannerSubscriptions
    End If
    If util.sheetExists("AccountPortfolio") Then
        AccountPortfolio.cancelAccountPortfolioSubscriptionOnExit
    End If
    If util.sheetExists("HistoricalData") Then
        HistoricalData.cancelAllHistoricalData
    End If
    If util.sheetExists("OpenOrders") Then
        OpenOrders.cancelOpenOrdersSubscriptionOnExit
    End If
    If util.sheetExists("Tickers") Then
        Tickers.cancelAllMktData
    End If
    If util.sheetExists("RealTimeBars") Then
        RealTimeBars.cancelAllRealTimeBars
    End If
    If util.sheetExists("TickByTick") Then
        TickByTick.cancelAllTickByTickData
    End If
    If util.sheetExists("TickByTickExt") Then
        TickByTickExt.cancelAllTickByTickData
    End If
    If util.sheetExists("TickNews") Then
        TickNews.cancelAllNewsTicks
    End If
    If util.sheetExists("HistoricalNews") Then
        HistoricalNews.cancelNewsBulletinsSubscriptionOnExit
    End If
    If util.sheetExists("PnL") Then
        PnL.cancelAllPnL
    End If
    If util.sheetExists("ImplVolOptPrice") Then
        ImplVolOptPrice.cancelAllCalculateRequestsOnExit
    End If
    If util.sheetExists("AccountPortfolio") Then
        AccountPortfolio.clearExerciseOptionsOnExit
    End If
  
    
End Sub
