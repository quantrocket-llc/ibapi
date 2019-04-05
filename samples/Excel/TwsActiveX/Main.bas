Attribute VB_Name = "Main"
Option Explicit

Private mIsInitialised As Boolean

Public Api As Api
Public IsConnected As Boolean

Public Sub Initialise()
    If mIsInitialised Then Exit Sub
    
    Set Api = New Api
    
    Account.Initialise
    AcctUpdMulti.Initialise
    AdvancedOrders.Initialise
    Advisors.Initialise
    BasicOrders.Initialise
    BondContractDetails.Initialise
    Bulletins.Initialise
    CommissionReports.Initialise
    ConditionalOrders.Initialise
    ContractDetails.Initialise
    Executions.Initialise
    ExtendedOrderAttributes.Initialise
    FamilyCodes.Initialise
    Fundamentals.Initialise
    General.Initialise
    HistoricalData.Initialise
    Log.Initialise
    MarketDepth.Initialise
    MarketScanner.Initialise
    News.Initialise
    OpenOrders.Initialise
    Portfolio.Initialise
    PositionsMulti.Initialise
    RealTimeBars.Initialise
    SymbolSamples.Initialise
    Tickers.Initialise
    TickByTick.Initialize
    HeadTimestamp.Initialise
    SoftDollarTiers.Initialise
    Histogram.Initialise
    SmartComponents.Initialise
    SecDefOptParams.Initialise
    CompletedOrders.Initialise
   
    ' clear log
    Log.ClearLog_Click
    
    mIsInitialised = True
End Sub

' delete TWSControl
Sub DeleteTWSControl()
    Set Api = Nothing
End Sub

