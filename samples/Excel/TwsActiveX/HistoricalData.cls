VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "HistoricalData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================
' table constants
Const RANGE_HEADER = "A6:N6"

' query specification
Private Enum HistoricalQueryColumns
    Col_INCLUDEEXPIRED = 1
    Col_HIST_STATUS
    Col_STARTDATETIME
    Col_ENDDATETIME
    Col_NUMBEROFTICKS
    Col_DURATION
    Col_BARSIZE
    Col_WHATTOSHOW
    Col_RTHONLY
    Col_DATEFORMAT
End Enum

Private Enum NewPageOptionsColumns
    Col_SHEETNAME = 1
    Col_ACTIVATESHEET
End Enum

Private contractTable As Range
Private queryTable As Range
Private newPageTable As Range

'==============
' methods
'==============
' create ticker
Private Sub CreateTicker_Click()
    TickerForm.ShowForm contractTable
End Sub

' create combo legs
Private Sub ComboLegs_Click()
   ComboLegForm.ShowForm contractTable
End Sub

' cancel historical data
Private Sub CancelHistoricalData_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer
    id = ActiveCell.row - contractTable.Rows(1).row + 1
    Api.Tws.CancelHistoricalData id + ID_HISTDATA
    queryTable(id, Col_HIST_STATUS).value = STR_CANCELLED
    ActiveCell.Offset(1, 0).Activate
End Sub

' request historical ticks click
Private Sub RequestHistoricalTicks_Click()
   ReqHistoricalData 1
   
End Sub

' request historical data click
Public Sub RequestHistoricalData_Click()
   ReqHistoricalData 0
End Sub

' request historical data (reqType: 0 - historical data, 1 - historical ticks)
Private Sub ReqHistoricalData(reqType As Integer)
    If Not CheckConnected Then Exit Sub
    
    Dim id As Long
   
    id = ActiveCell.row - contractTable.Rows(1).row + 1
    
    ' create contract
    Dim lContractInfo As TWSLib.IContract
    Set lContractInfo = Api.Tws.createContract()
    
    ' fill contract structure
    With lContractInfo
        .Symbol = UCase(contractTable(id, Col_SYMBOL).value)
        .SecType = UCase(contractTable(id, Col_SECTYPE).value)
        .lastTradeDateOrContractMonth = contractTable(id, Col_LASTTRADEDATE).value
        .Strike = IIf(contractTable(id, Col_STRIKE).value = "", 0#, contractTable(id, Col_STRIKE).value)
        .Right = UCase(contractTable(id, Col_RIGHT).value)
        .multiplier = UCase(contractTable(id, Col_MULTIPLIER).value)
        .exchange = UCase(contractTable(id, Col_EXCH).value)
        .primaryExchange = UCase(contractTable(id, Col_PRIMEXCH).value)
        .currency = UCase(contractTable(id, Col_CURRENCY).value)
        .localSymbol = UCase(contractTable(id, Col_LOCALSYMBOL).value)
        .conId = IIf(UCase(contractTable(id, Col_CONID).value) = "", 0, UCase(contractTable(id, Col_CONID).value))
        .includeExpired = queryTable(id, Col_INCLUDEEXPIRED).value
    End With
    
    ' combo legs
    If contractTable(id, Col_SECTYPE).value = SECTYPE_BAG And _
    contractTable(id, Col_COMBOLEGS) <> STR_EMPTY Then
        ' create combo leg list
        Set lContractInfo.ComboLegs = Api.Tws.createComboLegList()
        
        ' parse combo legs string
        Util.ParseComboLegsIntoStruct contractTable(id, Col_COMBOLEGS).value, lContractInfo.ComboLegs, Nothing
    End If

    ' under comp
    If contractTable(id, Col_SECTYPE).value = SECTYPE_BAG And _
    contractTable(id, Col_DELTANEUTRALCONTRACT) <> STR_EMPTY Then
        ' create under comp
        Set lContractInfo.deltaNeutralContract = Api.Tws.createDeltaNeutralContract()
        
        ' parse under comp info
        Util.ParseDeltaNeutralContractIntoStruct contractTable(id, Col_DELTANEUTRALCONTRACT).value, lContractInfo.deltaNeutralContract
    End If
    
    
    ' query specification
    Dim startDateTime As String, endDateTime As String, duration As String, barSize As String, whatToShow As String
    Dim useRTH As Long
    Dim formatDate As Long
    Dim keepUpToDate As Boolean
    Dim numberOfTicks As Long
    Dim ignoreSize As Boolean
    startDateTime = STR_EMPTY
    endDateTime = STR_EMPTY
    duration = STR_EMPTY
    barSize = STR_EMPTY
    whatToShow = STR_EMPTY
    useRTH = True
    formatDate = 1
    keepUpToDate = False
    numberOfTicks = 0
    ignoreSize = False
    
    If queryTable(id, Col_STARTDATETIME).value <> STR_EMPTY Then
        startDateTime = UCase(queryTable(id, Col_STARTDATETIME).value)
    End If

    If queryTable(id, Col_ENDDATETIME).value <> STR_EMPTY Then
        endDateTime = UCase(queryTable(id, Col_ENDDATETIME).value)
    End If
    
    duration = UCase(queryTable(id, Col_DURATION).value)
    barSize = queryTable(id, Col_BARSIZE).value
    whatToShow = UCase(queryTable(id, Col_WHATTOSHOW).value)
    useRTH = queryTable(id, Col_RTHONLY).value
    formatDate = queryTable(id, Col_DATEFORMAT).value
    numberOfTicks = queryTable(id, Col_NUMBEROFTICKS).value

    ' chart options
    Dim chartOptions As TWSLib.ITagValueList
    Set chartOptions = Api.Tws.createTagValueList()

    Dim sheetName As String
    sheetName = newPageTable(id, Col_SHEETNAME).value
    If (sheetName = STR_EMPTY And newPageTable(id, Col_ACTIVATESHEET).value) Or _
        IsNumeric(sheetName) Then
        newPageTable(id, Col_SHEETNAME).value = GenerateSheetName(lContractInfo, endDateTime, duration, barSize, whatToShow, useRTH, formatDate)
    End If
    
    If reqType = 0 Then
        ' call reqHistoricalDataEx method
        Api.Tws.reqHistoricalDataEx id + ID_HISTDATA, lContractInfo, endDateTime, duration, barSize, whatToShow, useRTH, formatDate, keepUpToDate, chartOptions
    ElseIf reqType = 1 Then
        ' call reqHistoricalTicks method
        Api.Tws.reqHistoricalTicks id + ID_HISTDATA, lContractInfo, startDateTime, endDateTime, numberOfTicks, whatToShow, useRTH, ignoreSize, chartOptions

    End If
    
    queryTable(id, Col_HIST_STATUS).value = STR_PROCESSING
    
    ActiveCell.Offset(1, 0).Activate
End Sub

' update historical data table
Public Sub UpdateHistoricalData(reqId As Long, histDate As String, histOpen As Double, histHigh As Double, histLow As Double, histClose As Double, histVolume As Long, barCount As Long, WAP As Double, hasGaps As Long)
    
    reqId = reqId - ID_HISTDATA
    
    Dim sheetName As String
    sheetName = newPageTable(reqId, Col_SHEETNAME).value

    If sheetName = STR_EMPTY Or IsNumeric(sheetName) Then Exit Sub
    
    Dim sheet As Worksheet
    Dim needsInitialising As Boolean
    Set sheet = FindOrAddSheet(sheetName, needsInitialising)
    If needsInitialising Then InitialiseSheet sheet
    
    Dim rowId As Long
    rowId = GetSheetRowId(sheet)
    
    With sheet.Rows(rowId)
        .Cells(1).value = histDate
        .Cells(2).value = histOpen
        .Cells(3).value = histHigh
        .Cells(4).value = histLow
        .Cells(5).value = histClose
        .Cells(6).value = histVolume
        .Cells(7).value = barCount
        .Cells(8).value = WAP
        .Cells(9).value = hasGaps
    End With
    
    IncrementSheetRowId sheet
End Sub

Public Sub FinishUpdateHistoricalData(reqId As Long, startDate As String, endDate As String)
    ' finishing
    
    reqId = reqId - ID_HISTDATA
    
    queryTable(reqId, Col_HIST_STATUS).value = STR_FINISHED
    
    Dim sheetName As String
    sheetName = newPageTable(reqId, Col_SHEETNAME).value
    If sheetName <> STR_EMPTY And Not IsNumeric(sheetName) Then
        Dim sheet As Worksheet
        Set sheet = Worksheets(sheetName)
        ClearSheetRowId sheet
        
        If newPageTable(reqId, Col_ACTIVATESHEET).value Then sheet.Activate
    End If
End Sub

Private Sub InitialiseSheet(sheet As Worksheet)
    sheet.Cells.ClearContents

    InitialiseSheetRowId sheet, 3
    sheet.Cells(2, 1).value = "Date/Time"
    sheet.Cells(2, 2).value = "Open"
    sheet.Cells(2, 3).value = "High"
    sheet.Cells(2, 4).value = "Low"
    sheet.Cells(2, 5).value = "Close"
    sheet.Cells(2, 6).value = "Volume"
    sheet.Cells(2, 7).value = "Count"
    sheet.Cells(2, 8).value = "WAP"
    sheet.Cells(2, 9).value = "HasGaps"
End Sub

Private Sub InitialiseHistTicksLastSheet(sheet As Worksheet)
    sheet.Cells.ClearContents

    InitialiseSheetRowId sheet, 3
    sheet.Cells(2, 1).value = "Time"
    sheet.Cells(2, 2).value = "Price"
    sheet.Cells(2, 3).value = "Size"
    sheet.Cells(2, 4).value = "Exchange"
    sheet.Cells(2, 5).value = "Special Conditions"
    sheet.Cells(2, 6).value = "Attribs"
End Sub

Private Sub InitialiseHistTicksBidAskSheet(sheet As Worksheet)
    sheet.Cells.ClearContents

    InitialiseSheetRowId sheet, 3
    sheet.Cells(2, 1).value = "Time"
    sheet.Cells(2, 2).value = "PriceBid"
    sheet.Cells(2, 3).value = "PriceAsk"
    sheet.Cells(2, 4).value = "SizeBid"
    sheet.Cells(2, 5).value = "SizeAsk"
    sheet.Cells(2, 6).value = "Attribs"
End Sub

Private Sub InitialiseHistTicksSheet(sheet As Worksheet)
    sheet.Cells.ClearContents

    InitialiseSheetRowId sheet, 3
    sheet.Cells(2, 1).value = "Time"
    sheet.Cells(2, 2).value = "Price"
    sheet.Cells(2, 3).value = "Size"
End Sub

Private Function GenerateSheetName(contractInfo As TWSLib.IContract, endDateTime As String, duration As String, barSize As String, whatToShow As String, useRTH As Long, formatDate As Long)
    Dim s As String
    s = "Hist" & GenerateContractIdentifier(contractInfo)
    s = s & IIf(endDateTime <> "", "_" & endDateTime, "")
    s = s & IIf(duration <> "", "_" & duration, "")
    s = s & IIf(barSize <> "", "_" & barSize, "")
    s = s & IIf(whatToShow <> "", "_" & whatToShow, "")
    s = s & "_" & useRTH
    s = s & "_" & formatDate
    GenerateSheetName = Left(s, 31)
End Function

Public Sub ProcessError(ByVal id As Long, ByVal errorCode As Long, ByVal errorMsg As String)
    queryTable(id - ID_HISTDATA, Col_HIST_STATUS).value = STR_ERROR + STR_COLON + Str(errorCode) + STR_SPACE + errorMsg
End Sub

Public Sub Initialise()
    Set contractTable = HistoricalData.Range("$A$7:$M$124")
    Set queryTable = HistoricalData.Range("$N$7:$W$124")
    Set newPageTable = HistoricalData.Range("$X$7:$Y$124")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
    
    Dim macroName As String
    macroName = "HistoricalData.RequestHistoricalData_Click"
    
    Application.OnKey "+^h", macroName
End Sub

Private Sub Worksheet_Deactivate()
    Application.OnKey "+^h"
End Sub

Private Function GenerateTickAttribLastString(ByVal tickAttribLast As TWSLib.ComTickAttribLast)
    Dim s As String
    s = ""
    If tickAttribLast.PastLimit Then
        s = s & "pastLimit "
    End If
    If tickAttribLast.unreported Then
        s = s & "unreported "
    End If
    GenerateTickAttribLastString = s
End Function

Private Function GenerateTickAttribBidAskString(ByVal tickAttribBidAsk As TWSLib.ComTickAttribBidAsk)
    Dim s As String
    s = ""
    If tickAttribBidAsk.bidPastLow Then
        s = s & "bidPastLow "
    End If
    If tickAttribBidAsk.askPastHigh Then
        s = s & "askPastHigh "
    End If
    GenerateTickAttribBidAskString = s
End Function
' update historical data table with historical last ticks
Public Sub UpdateHistoricalTicksLast(ByVal reqId As Long, ByVal ticks As TWSLib.IHistoricalTickLastList, ByVal done As Boolean)

    reqId = reqId - ID_HISTDATA
    
    Dim sheetName As String
    sheetName = newPageTable(reqId, Col_SHEETNAME).value

    If sheetName = STR_EMPTY Or IsNumeric(sheetName) Then Exit Sub
    
    Dim sheet As Worksheet
    Dim needsInitialising As Boolean
    Set sheet = FindOrAddSheet(sheetName, needsInitialising)
    If needsInitialising Then InitialiseHistTicksLastSheet sheet
    
    Dim i As Integer
    Dim histTickLast As TWSLib.ComHistoricalTickLast
    For i = 1 To ticks.Count
        Set histTickLast = ticks.Item(i - 1)
    
        Dim rowId As Long
        rowId = GetSheetRowId(sheet)
        With sheet.Rows(rowId)
            .Cells(1).value = histTickLast.time
            .Cells(2).value = histTickLast.price
            .Cells(3).value = histTickLast.size
            .Cells(4).value = histTickLast.exchange
            .Cells(5).value = histTickLast.specialConditions
            .Cells(6).value = GenerateTickAttribLastString(histTickLast.tickAttribLast)
        End With
        IncrementSheetRowId sheet
    Next i
    
    ' finishing
    queryTable(reqId, Col_HIST_STATUS).value = STR_FINISHED
    
    If newPageTable(reqId, Col_ACTIVATESHEET).value Then sheet.Activate
End Sub

' update historical data table with historical bid/ask ticks
Public Sub UpdateHistoricalTicksBidAsk(ByVal reqId As Long, ByVal ticks As TWSLib.IHistoricalTickBidAskList, ByVal done As Boolean)
    reqId = reqId - ID_HISTDATA
    
    Dim sheetName As String
    sheetName = newPageTable(reqId, Col_SHEETNAME).value

    If sheetName = STR_EMPTY Or IsNumeric(sheetName) Then Exit Sub
    
    Dim sheet As Worksheet
    Dim needsInitialising As Boolean
    Set sheet = FindOrAddSheet(sheetName, needsInitialising)
    If needsInitialising Then InitialiseHistTicksBidAskSheet sheet
    
    Dim i As Integer
    Dim histTickBidAsk As TWSLib.ComHistoricalTickBidAsk
    For i = 1 To ticks.Count
        Set histTickBidAsk = ticks.Item(i - 1)
    
        Dim rowId As Long
        rowId = GetSheetRowId(sheet)
        With sheet.Rows(rowId)
            .Cells(1).value = histTickBidAsk.time
            .Cells(2).value = histTickBidAsk.priceBid
            .Cells(3).value = histTickBidAsk.priceAsk
            .Cells(4).value = histTickBidAsk.sizeBid
            .Cells(5).value = histTickBidAsk.sizeAsk
            .Cells(6).value = GenerateTickAttribBidAskString(histTickBidAsk.tickAttribBidAsk)
        End With
        IncrementSheetRowId sheet
    Next i
    
    ' finishing
    queryTable(reqId, Col_HIST_STATUS).value = STR_FINISHED
    
    If newPageTable(reqId, Col_ACTIVATESHEET).value Then sheet.Activate

End Sub

' update historical data table with historical ticks
Public Sub UpdateHistoricalTicks(ByVal reqId As Long, ByVal ticks As TWSLib.IHistoricalTickList, ByVal done As Boolean)
    reqId = reqId - ID_HISTDATA
    
    Dim sheetName As String
    sheetName = newPageTable(reqId, Col_SHEETNAME).value

    If sheetName = STR_EMPTY Or IsNumeric(sheetName) Then Exit Sub
    
    Dim sheet As Worksheet
    Dim needsInitialising As Boolean
    Set sheet = FindOrAddSheet(sheetName, needsInitialising)
    If needsInitialising Then InitialiseHistTicksSheet sheet
    
    Dim i As Integer
    Dim histTick As TWSLib.ComHistoricalTick
    For i = 1 To ticks.Count
        Set histTick = ticks.Item(i - 1)
    
        Dim rowId As Long
        rowId = GetSheetRowId(sheet)
        With sheet.Rows(rowId)
            .Cells(1).value = histTick.time
            .Cells(2).value = histTick.price
            .Cells(3).value = histTick.size
        End With
        IncrementSheetRowId sheet
    Next i
    
    ' finishing
    queryTable(reqId, Col_HIST_STATUS).value = STR_FINISHED
    
    If newPageTable(reqId, Col_ACTIVATESHEET).value Then sheet.Activate
End Sub



