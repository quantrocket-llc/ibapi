VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "News"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================


Const CELL_CON_ID = "A6"
Const CELL_PROVIDER_CODES = "B6"
Const CELL_START_DATETIME = "C6"
Const CELL_END_DATETIME = "D6"
Const CELL_TOTAL_RESULTS = "E6"

Private Enum HistoricalNewsColumns
    Col_HISTORICAL_NEWS_TIME = 1
    Col_HISTORICAL_NEWS_PROVIDER_CODE
    Col_HISTORICAL_NEWS_ARTICLE_ID
    Col_HISTORICAL_NEWS_HEADLINE
End Enum
    

Const CELL_PROVIDER_CODE = "R6"
Const CELL_ARTICLE_ID = "S6"
Const CELL_NEWS_ARTICLE = "R10"

Const CELL_SYMBOL = "I6"
Const CELL_SECTYPE = "J6"
Const CELL_EXCHANGE = "K6"
Const CELL_PRIM_EXCHANGE = "L6"
Const CELL_CURRENCY = "M6"

Private Enum TickNewsTableColumns
    Col_TICK_NEWS_TIME = 1
    Col_TICK_NEWS_PROVIDER_CODE
    Col_TICK_NEWS_ARTICLE_ID
    Col_TICK_NEWS_HEADLINE
    Col_Merged1
    ColMerged2
    ColMerged3
    Col_TICK_NEWS_EXTRA_DATA
End Enum

Private Enum NewsProvidersTableColumns
    Col_NEWS_PROVIDERS_CODE = 1
    Col_NEWS_PROVIDERS_NAME
End Enum


Private historicalNewsActiveReqId As Long
Private tickNewsActiveReqId As Long

Private historicalNewsRow As Long
Private tickNewsRow As Long

Private historicalNewsTable As Range
Private tickNewsTable As Range
Private newsProvidersTable As Range

'=================
' private methods
'=================

Public Sub Initialise()
    Set historicalNewsTable = Range("$A$10:$G$55")
    Set tickNewsTable = Range("$I$10:$P$55")
    Set newsProvidersTable = Range("$R$28:$X$55")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub

' request historical news
Private Sub reqHistoricalNewsButton_Click()
    If Not CheckConnected Then Exit Sub
            
    ' clear historical news table
    historicalNewsRow = 0
    historicalNewsTable.ClearContents
    historicalNewsActiveReqId = historicalNewsActiveReqId + 1
    
    Dim conId As Long, providerCodes As String, startDateTime As String, endDateTime As String, totalResults As Long
    
    conId = Range(CELL_CON_ID).value
    providerCodes = Range(CELL_PROVIDER_CODES).value
    startDateTime = Range(CELL_START_DATETIME).value
    endDateTime = Range(CELL_END_DATETIME).value
    totalResults = Range(CELL_TOTAL_RESULTS).value
    
    Api.Tws.reqHistoricalNews historicalNewsActiveReqId + ID_HISTORICAL_NEWS, conId, providerCodes, startDateTime, endDateTime, totalResults, Nothing
End Sub

' clear historical news table
Private Sub clearHistoricalNewsButton_Click()
    historicalNewsRow = 0
    historicalNewsTable.ClearContents
End Sub

' request news article
Private Sub reqNewsArticle_Click()
    If Not CheckConnected Then Exit Sub
    
    ' clear news article table
    Range(CELL_NEWS_ARTICLE).MergeArea.ClearContents
    historicalNewsActiveReqId = historicalNewsActiveReqId + 1
    Api.Tws.reqNewsArticle historicalNewsActiveReqId + ID_HISTORICAL_NEWS, Range(CELL_PROVIDER_CODE).value, Range(CELL_ARTICLE_ID).value, Nothing
End Sub

' clear news article
Private Sub clearNewsArticle_Click()
    Range(CELL_NEWS_ARTICLE).MergeArea.ClearContents
End Sub

' click in Historical News table
Private Sub Worksheet_SelectionChange(ByVal Target As Range)
    Dim providerCode As String
    Dim articleId As String
    Dim rowId As Long
    If Not Application.Intersect(ActiveCell, historicalNewsTable) Is Nothing Then
        rowId = ActiveCell.row - historicalNewsTable.Rows(1).row + 1
        providerCode = historicalNewsTable(rowId, Col_HISTORICAL_NEWS_PROVIDER_CODE).value
        articleId = historicalNewsTable(rowId, Col_HISTORICAL_NEWS_ARTICLE_ID).value
    ElseIf Not Application.Intersect(ActiveCell, tickNewsTable) Is Nothing Then
        rowId = ActiveCell.row - tickNewsTable.Rows(1).row + 1
        providerCode = tickNewsTable(rowId, Col_TICK_NEWS_PROVIDER_CODE).value
        articleId = tickNewsTable(rowId, Col_TICK_NEWS_ARTICLE_ID).value
    End If
    If providerCode <> "" And articleId <> "" Then
        Range(CELL_PROVIDER_CODE).value = providerCode
        Range(CELL_ARTICLE_ID).value = articleId
    End If
End Sub

' cancel news ticks
Private Sub cancelNewsTicks_Click()
    If Not CheckConnected Then Exit Sub
    Api.Tws.cancelMktData tickNewsActiveReqId + ID_TICK_NEWS
End Sub

' clear news ticks
Private Sub clearNewsTicks_Click()
    tickNewsRow = 0
    tickNewsTable.ClearContents
End Sub

' request news ticks
Private Sub reqNewsTicks_Click()
    If Not CheckConnected Then Exit Sub
            
    ' clear tick news table
    tickNewsRow = 0
    tickNewsTable.ClearContents
    tickNewsActiveReqId = tickNewsActiveReqId + 1
    
    ' create contract
    Dim contractInfo As IContract
    Set contractInfo = Api.Tws.createContract()

    ' fill contract strcuture
    With contractInfo
        .Symbol = UCase(Range(CELL_SYMBOL).value)
        .SecType = UCase(Range(CELL_SECTYPE).value)
        .exchange = UCase(Range(CELL_EXCHANGE).value)
        .primaryExchange = UCase(Range(CELL_PRIM_EXCHANGE).value)
        .currency = UCase(Range(CELL_CURRENCY).value)
    End With
            
    ' mkt data options
    Dim mktDataOptions As TWSLib.ITagValueList
    Set mktDataOptions = Api.Tws.createTagValueList()
            
    Api.Tws.reqMktDataEx tickNewsActiveReqId + ID_TICK_NEWS, contractInfo, "mdoff,292", False, False, mktDataOptions
End Sub

' request news providers
Private Sub reqNewsProviders_Click()
    If Not CheckConnected Then Exit Sub
            
    ' clear news providers table
    newsProvidersTable.ClearContents
    
    Api.Tws.reqNewsProviders
End Sub

' clear news providers
Private Sub clearNewsProviders_Click()
    newsProvidersTable.ClearContents
End Sub

'=================
' public methods
'=================
' historical news
Public Sub HistoricalNews(ByVal requestId As Long, ByVal time As String, ByVal providerCode As String, ByVal articleId As String, ByVal headline As String)
    If historicalNewsActiveReqId = requestId - ID_HISTORICAL_NEWS Then
        historicalNewsRow = historicalNewsRow + 1
        historicalNewsTable(historicalNewsRow, Col_HISTORICAL_NEWS_TIME).value = time
        historicalNewsTable(historicalNewsRow, Col_HISTORICAL_NEWS_PROVIDER_CODE).value = providerCode
        historicalNewsTable(historicalNewsRow, Col_HISTORICAL_NEWS_ARTICLE_ID).value = articleId
        historicalNewsTable(historicalNewsRow, Col_HISTORICAL_NEWS_HEADLINE).value = headline
    End If
End Sub

' historical news end
Public Sub HistoricalNewsEnd(ByVal requestId As Long, ByVal hasMore As Boolean)
    If historicalNewsActiveReqId = requestId - ID_HISTORICAL_NEWS Then
        If hasMore Then
            historicalNewsTable(historicalNewsRow, Col_HISTORICAL_NEWS_HEADLINE).value = "has more ..."
        End If
    End If
End Sub

' news article
Public Sub newsArticle(ByVal requestId As Long, ByVal articleType As Long, ByVal articleText As String)
    If articleType = 1 Then
        Range(CELL_NEWS_ARTICLE).MergeArea.value = "Article body is binary/pdf and cannot be displayed"
    Else
        Range(CELL_NEWS_ARTICLE).MergeArea.value = articleText
    End If
End Sub

' tick news
Public Sub TickNews(ByVal tickerId As Long, ByVal timeStamp As String, ByVal providerCode As String, ByVal articleId As String, ByVal headline As String, ByVal extraData As String)
    If tickNewsActiveReqId = tickerId - ID_TICK_NEWS Then
        tickNewsRow = tickNewsRow + 1
        tickNewsTable(tickNewsRow, Col_TICK_NEWS_TIME).value = Format(DateAdd("s", CLng(Left(timeStamp, Len(timeStamp) - 3)), "01/01/1970"), "yyyy-mm-dd Hh:Nn:Ss")
        tickNewsTable(tickNewsRow, Col_TICK_NEWS_PROVIDER_CODE).value = providerCode
        tickNewsTable(tickNewsRow, Col_TICK_NEWS_ARTICLE_ID).value = articleId
        tickNewsTable(tickNewsRow, Col_TICK_NEWS_HEADLINE).value = headline
        tickNewsTable(tickNewsRow, Col_TICK_NEWS_EXTRA_DATA).value = extraData
    End If
End Sub

' news providers
Public Sub newsProviders(ByVal newsProviders As TWSLib.INewsProviderList)
    Dim np As TWSLib.ComNewsProvider
    Dim i As Long
    For i = 1 To newsProviders.Count
        Set np = newsProviders.Item(i - 1)
        newsProvidersTable(i, Col_NEWS_PROVIDERS_CODE).value = np.providerCode
        newsProvidersTable(i, Col_NEWS_PROVIDERS_NAME).value = np.providerName
    Next
End Sub

