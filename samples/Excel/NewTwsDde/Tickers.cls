VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Tickers"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' user defined types
Private Type MktDataCol
    column As Long
    name As String
End Type
Private Type GenTickCol
    genTick As Integer
    names() As Variant
End Type

Dim genId As Long

Dim contractColumnsArray() As Variant
Dim mktDataColumnsArray() As MktDataCol
Dim tickReqParamsColumnsArray() As Variant
Dim optCompColumnsArray() As Variant
Dim efpCompColumnsArray() As Variant
Dim genTicksColumnsArray() As GenTickCol

' constants
Const STR_SHEET_NAME = "Tickers"
Const STR_TICK = "tick"
Const STR_REQMKTDATA = "reqMktData"
Const STR_CANCELMKTDATA = "cancelMktData"
Const STR_ID = "id"
Const STR_REQMKTDATA_LONG_VALUE = "reqMktDataLongValue"
Const STR_REQ_CURRENT_TIME = "reqCurrentTime"


' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_CURRENT_TIME = "P5" ' cell with current time

' columns
Const startOfContractColumns = 1 ' contract first column index (symbol)
Const genericTicksColumnIndex = 15 ' index of "generic ticks" columns
Const requestEFPCompColumnIndex = 17 ' True if EFP computations should be requested (for EFP combos)
Const requestOptCompColumnIndex = 16 ' True if option computations should be requested (for OPT and FOP)
Const statusColumnIndex = 18 ' index of "status" column
Const idColumnIndex = 19 ' index of "id" column
Const startOfMarketDataColumns = 20 ' market data first column index
Const startOfTickReqParamsColumns = 41 ' tick req params first column index
Const startOfGenericTicksColumns = 44 ' generic ticks first column index
Const startOfOptCompColumns = 81 ' option computations first column index
Const startOfEFPCompColumns = 113 ' efp first column index
Const fundamentalsColumnIndex = 61

' rows
Const dataStartRowIndex = 10 ' starting row of data
Const dataEndRowIndex = util.maxRowsToFormat ' ending row of data

' ========================================================
' contract columns
' ========================================================
Private Function getContractColumns() As Variant()

    If (Not Not contractColumnsArray) <> 0 Then
        ' do not re-initialize array
        GoTo getContractColumnsEnd
    End If

    contractColumnsArray = Array("SYMBOL", "SECTYPE", "LASTTRADEDATE", "STRIKE", "RIGHT", "MULTIPLIER", "TRADINGCLASS", "EXCH", "PRIMEXCH", "CURRENCY", "LOCALSYMBOL", "CONID", _
        "COMBOLEGS", "DELTANEUTRAL")
    
getContractColumnsEnd:
    getContractColumns = contractColumnsArray
End Function

' ========================================================
' Generic ticks:
' To add new generic tick
'   1.Add columns into Tickers sheet
'   2.Correct indices of columns (columns constants)
'   3.Add entry to genTicksColumnsArray with generic tick number and response field names (columns)
' ========================================================
Private Function getGenTicksColumns() As GenTickCol()
    If (Not Not genTicksColumnsArray) <> 0 Then
        ' do not re-initialize array
        GoTo getGenTicksColumnsEnd
    End If
    
    ReDim genTicksColumnsArray(23)
    
    ' genTick=105 (avgOptVolume), response=87
    genTicksColumnsArray(0).genTick = 105
    genTicksColumnsArray(0).names = Array("avgOptVolume")
    
    ' genTick=225 (auction), response=34,35,36,61
    genTicksColumnsArray(1).genTick = 225
    genTicksColumnsArray(1).names = Array("auctionVolume", "auctionPrice", "auctionImbalance", "regulatoryImbalance")

    ' genTick=100 (OptionVolumeauction), response=29,30
    genTicksColumnsArray(2).genTick = 100
    genTicksColumnsArray(2).names = Array("OptionCallVolume", "OptionPutVolume")

    ' genTick=101 (OptionOpenInterest), response=27,28
    genTicksColumnsArray(3).genTick = 101
    genTicksColumnsArray(3).names = Array("OptionCallOpenInterest", "OptionPutOpenInterest")

    ' genTick=232 (PlPrice), response=37
    genTicksColumnsArray(4).genTick = 232
    genTicksColumnsArray(4).names = Array("markPrice")

    ' genTick=221 (creditmanMarkPrice), response=78
    genTicksColumnsArray(5).genTick = 221
    genTicksColumnsArray(5).names = Array("creditmanMarkPrice")

    ' genTick=619 (creaditmanSlowMarkPrice), response=79
    genTicksColumnsArray(6).genTick = 619
    genTicksColumnsArray(6).names = Array("creditmanSlowMarkPrice")

    ' genTick=104 (historicalVolatility), response=23
    genTicksColumnsArray(7).genTick = 104
    genTicksColumnsArray(7).names = Array("OptionHistoricalVolatility")

    ' genTick=411 (historicalVolatility), response=58, FUT only
    genTicksColumnsArray(8).genTick = 411
    genTicksColumnsArray(8).names = Array("RTHistoricalVol")

    ' genTick=106 (optionImpliedVolatility), response=24
    genTicksColumnsArray(9).genTick = 106
    genTicksColumnsArray(9).names = Array("OptionImpliedVolatility")

    ' genTick=162 (indexFuturePremium), response=31, IND only
    genTicksColumnsArray(10).genTick = 162
    genTicksColumnsArray(10).names = Array("IndexFuturePremium")

    ' genTick=236 (shortable), response=46
    genTicksColumnsArray(11).genTick = 236
    genTicksColumnsArray(11).names = Array("shortable")

    ' genTick=258 (fundamentals), response=47
    genTicksColumnsArray(12).genTick = 258
    genTicksColumnsArray(12).names = Array("fundamentals")

    ' genTick=293 (tradeCount), response=54
    genTicksColumnsArray(13).genTick = 293
    genTicksColumnsArray(13).names = Array("tradeCount")

    ' genTick=294 (tradeRate), response=55
    genTicksColumnsArray(14).genTick = 294
    genTicksColumnsArray(14).names = Array("tradeRate")

    ' genTick=295 (volumeRate), response=56
    genTicksColumnsArray(15).genTick = 295
    genTicksColumnsArray(15).names = Array("volumeRate")

    ' genTick=318 (lastRTHTrade), response=57
    genTicksColumnsArray(16).genTick = 318
    genTicksColumnsArray(16).names = Array("lastRTHTrade")

    ' genTick=456 (IBDividends), response=59
    genTicksColumnsArray(17).genTick = 456
    genTicksColumnsArray(17).names = Array("IBDividends")

    ' genTick=460 (bondMultiplier), response=60
    genTicksColumnsArray(18).genTick = 460
    genTicksColumnsArray(18).names = Array("bondFactorMultiplier")

    ' genTick=165 (miscStats), response=21,15,16,17,18,19,20
    genTicksColumnsArray(19).genTick = 165
    genTicksColumnsArray(19).names = Array("AvgVolume", "13WeekLow", "13WeekHigh", "26WeekLow", "26WeekHigh", "52WeekLow", "52WeekHigh")

    ' genTick=595 (shortTermVolume), response=63,64,65
    genTicksColumnsArray(20).genTick = 595
    genTicksColumnsArray(20).names = Array("shortTermVolume3Min", "shortTermVolume5Min", "shortTermVolume10Min")

    ' genTick=588 (futuresOpenInterest), response=86
    genTicksColumnsArray(21).genTick = 588
    genTicksColumnsArray(21).names = Array("futuresOpenInterest")

    ' genTick=233 (rtVolume), response=48
    genTicksColumnsArray(22).genTick = 233
    genTicksColumnsArray(22).names = Array("RTVolume")

    ' genTick=375 (rtTrdVolume), response=77
    genTicksColumnsArray(23).genTick = 375
    genTicksColumnsArray(23).names = Array("rtTrdVolume")

    ' TODO: add generic ticks here
    
getGenTicksColumnsEnd:
    getGenTicksColumns = genTicksColumnsArray
    
End Function

' ========================================================
' EFP computations columns
' ========================================================
Private Function getEFPCompColumns() As Variant()

    If (Not Not efpCompColumnsArray) <> 0 Then
        ' do not re-initialize array
        GoTo getEFPCompColumnsEnd
    End If

    Dim efpCompType() As Variant
    efpCompType = Array("bidEFP", "askEFP", "lastEFP", "openEFP", "highEFP", "lowEFP", "closeEFP")

    Dim efpCompFields() As Variant
    efpCompFields = Array("BasisPoints", "FormattedBasisPoints", "ImpliedFuture", "HoldDays", "FutureExpiry", "DividendImpact", "DividendsToExpiry")
    
    Dim size As Integer

    size = (UBound(efpCompType) - LBound(efpCompType) + 1) * (UBound(efpCompFields) - LBound(efpCompFields) + 1)
    ReDim efpCompColumnsArray(size - 1)

    Dim i As Integer, j As Integer
    Dim count
    For i = 0 To UBound(efpCompType) - LBound(efpCompType)
        For j = 0 To UBound(efpCompFields) - LBound(efpCompFields)
            efpCompColumnsArray(count) = efpCompType(i) & efpCompFields(j)
            count = count + 1
        Next j
    Next i
    
getEFPCompColumnsEnd:
    getEFPCompColumns = efpCompColumnsArray
End Function

' ========================================================
' option computations columns
' ========================================================
Private Function getOptCompColumns() As Variant()

    If (Not Not optCompColumnsArray) <> 0 Then
        ' do not re-initialize array
        GoTo getOptCompColumnsEnd
    End If

    Dim optCompType() As Variant
    optCompType = Array("modelOptComp", "bidOptComp", "askOptComp", "lastOptComp")

    Dim optCompFields() As Variant
    optCompFields = Array("ImpliedVol", "OptPrice", "UndPrice", "PvDividend", "Delta", "Gamma", "Vega", "Theta")
    
    Dim size As Integer

    size = (UBound(optCompType) - LBound(optCompType) + 1) * (UBound(optCompFields) - LBound(optCompFields) + 1)
    ReDim optCompColumnsArray(size - 1)

    Dim i As Integer, j As Integer
    Dim count
    For i = 0 To UBound(optCompType) - LBound(optCompType)
        For j = 0 To UBound(optCompFields) - LBound(optCompFields)
            optCompColumnsArray(count) = optCompType(i) & optCompFields(j)
            count = count + 1
        Next j
    Next i
    
getOptCompColumnsEnd:
    getOptCompColumns = optCompColumnsArray
End Function

' ========================================================
' tick request params columns
' ========================================================
Private Function getTickReqParamsColumns() As Variant()

    If (Not Not tickReqParamsColumnsArray) <> 0 Then
        ' do not re-initialize array
        GoTo getTickReqParamsColumnsEnd
    End If
    
    tickReqParamsColumnsArray = Array("minTick", "bboExchange", "snapshotPermissions")
    
getTickReqParamsColumnsEnd:
    getTickReqParamsColumns = tickReqParamsColumnsArray
End Function

' ========================================================
' market data columns
' ========================================================
Private Function getMktDataColumns() As MktDataCol()
    Dim size As Integer

    If (Not Not mktDataColumnsArray) <> 0 Then
        ' do not re-initialize array
        GoTo getMktDataColumnsEnd
    End If

    Dim i As Integer
    Dim arr() As Variant
    arr = Array("error", "mktDataType", "bidSize", "bidPrice", "askPrice", "askSize", "lastPrice", "lastSize", "high", "low", "volume", "open", "close", _
                "bidExch", "askExch", "lastExchange", "lastTimestamp", "halted", "yieldBid", "yieldAsk", "yieldLast")

    size = UBound(arr) - LBound(arr)
    ReDim mktDataColumnsArray(size)

    For i = 0 To size
        mktDataColumnsArray(i).column = i
        mktDataColumnsArray(i).name = arr(i)
    Next i
    
getMktDataColumnsEnd:
    getMktDataColumns = mktDataColumnsArray
End Function

' ========================================================
' clears data cells
' ========================================================
Sub clearColumns(cell As range)
    Dim i As Integer, j As Integer
    With Worksheets(STR_SHEET_NAME)
        .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
        .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
        
        ' market data columns
        mktDataColumnsArray = getMktDataColumns()
        For i = 0 To UBound(mktDataColumnsArray) - LBound(mktDataColumnsArray)
            .Cells(cell.row, startOfMarketDataColumns + i).ClearContents
        Next i
        
        ' tick request params columns
        tickReqParamsColumnsArray = getTickReqParamsColumns()
        For i = 0 To UBound(tickReqParamsColumnsArray) - LBound(tickReqParamsColumnsArray)
            .Cells(cell.row, startOfTickReqParamsColumns + i).ClearContents
        Next i

        ' option computations columns
        optCompColumnsArray = getOptCompColumns()
        For i = 0 To UBound(optCompColumnsArray) - LBound(optCompColumnsArray)
            .Cells(cell.row, startOfOptCompColumns + i).ClearContents
        Next i
    
        ' efp computations columns
        efpCompColumnsArray = getEFPCompColumns()
        For i = 0 To UBound(efpCompColumnsArray) - LBound(efpCompColumnsArray)
            .Cells(cell.row, startOfEFPCompColumns + i).ClearContents
        Next i
    
        ' generic ticks columns
        Dim count As Integer
        count = 0
        genTicksColumnsArray = getGenTicksColumns()
        For i = 0 To UBound(genTicksColumnsArray) - LBound(genTicksColumnsArray)
            For j = 0 To UBound(genTicksColumnsArray(i).names) - LBound(genTicksColumnsArray(i).names)
                .Cells(cell.row, startOfGenericTicksColumns + count).ClearContents
                count = count + 1
            Next j
        Next i
        
    End With
End Sub

' ========================================================
' cancel market data for active row(s) when button is pressed
' ========================================================
Sub cancelMarketData()
    Dim server As String, id As String, i As Integer, j As Integer, row As range, lastRowIndex As Integer
    
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        For Each row In Selection.rows
            lastRowIndex = row.row
    
            If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, row, startOfContractColumns, getContractColumns()) Then GoTo Continue
    
            If .Cells(row.row, idColumnIndex).value = STR_EMPTY Then GoTo Continue
            
            id = .Cells(row.row, idColumnIndex).value
            .Cells(row.row, idColumnIndex).value = util.STR_EMPTY
            
            ' status column
            .Cells(row.row, statusColumnIndex).ClearContents
            
            clearColumns row
            
            util.sendRequest server, STR_CANCELMKTDATA, id
            
Continue:
        Next row
        
        .Cells(lastRowIndex, 1).offset(1, 0).Activate
    End With
End Sub

' ========================================================
' request current time when button is pressed
' ========================================================
Sub requestCurrentTime()
    Dim server As String
    
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub
    
    With Worksheets(STR_SHEET_NAME)
        util.sendRequest server, STR_REQ_CURRENT_TIME, util.IDENTIFIER_ZERO

        .range(CELL_CURRENT_TIME).Formula = util.composeLink(server, STR_REQ_CURRENT_TIME, util.IDENTIFIER_ZERO, util.STR_EMPTY) ' subscription control
        If util.cleanOnError(.range(CELL_CURRENT_TIME)) Then
            .range(CELL_CURRENT_TIME).value = util.STR_EMPTY
            Exit Sub
        End If
    End With

End Sub

' ========================================================
' request market data for active row(s) when button is pressed
' ========================================================
Sub requestMarketData()
Attribute requestMarketData.VB_Description = "Request market data"
Attribute requestMarketData.VB_ProcData.VB_Invoke_Func = "R\n14"
    Dim row As range, server As String, lastRowIndex As Integer
    
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub
    
    With Worksheets(STR_SHEET_NAME)
        For Each row In Selection.rows
            lastRowIndex = row.row
            If .Cells(row.row, idColumnIndex).value <> STR_EMPTY Then GoTo Continue
            If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, row, startOfContractColumns, getContractColumns()) Then GoTo Continue
            sendMarketDataRequest server, row
            
Continue:
        Next row
        
        .Cells(lastRowIndex, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request market data for row
' ========================================================
Sub sendMarketDataRequest(server As String, cell As range)
Attribute sendMarketDataRequest.VB_ProcData.VB_Invoke_Func = "R\n14"

    ' get id
    Dim id As String
    id = util.getIDpost(genId, util.ID_REQ_MARKET_DATA)
    
    With Worksheets(STR_SHEET_NAME)
        .Cells(cell.row, idColumnIndex).value = id
        
        ' fill status column with formula
        .Cells(cell.row, statusColumnIndex).Formula = util.composeLink(server, STR_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(cell.row, statusColumnIndex)) Then
            clearColumns cell
            Exit Sub
        End If
        
        ' send request
        util.sendPoke Worksheets(STR_SHEET_NAME), server, STR_REQMKTDATA, id, cell, startOfContractColumns, getContractColumns(), genericTicksColumnIndex, idColumnIndex, 0, 0, 0, 0
        
        ' fill market data columns with formulas
        Dim i As Integer, j As Integer
        mktDataColumnsArray = getMktDataColumns()
        For i = 0 To UBound(mktDataColumnsArray) - LBound(mktDataColumnsArray)
            .Cells(cell.row, startOfMarketDataColumns + i).Formula = util.composeLink(server, STR_TICK, id, mktDataColumnsArray(i).name)

        Next i
    
        ' fill tick request params columns with formulas
        tickReqParamsColumnsArray = getTickReqParamsColumns()
        For i = 0 To UBound(tickReqParamsColumnsArray) - LBound(tickReqParamsColumnsArray)
            .Cells(cell.row, startOfTickReqParamsColumns + i).Formula = util.composeLink(server, STR_TICK, id, tickReqParamsColumnsArray(i))
        Next i

        If .Cells(cell.row, requestOptCompColumnIndex) = True Then
            ' fill option computations columns with formulas
            optCompColumnsArray = getOptCompColumns()
            For i = 0 To UBound(optCompColumnsArray) - LBound(optCompColumnsArray)
                .Cells(cell.row, startOfOptCompColumns + i).Formula = util.composeLink(server, STR_TICK, id, optCompColumnsArray(i))
            Next i
        End If
    
        If .Cells(cell.row, requestEFPCompColumnIndex) = True Then
            ' fill EFP computations columns with formulas
            efpCompColumnsArray = getEFPCompColumns()
            For i = 0 To UBound(efpCompColumnsArray) - LBound(efpCompColumnsArray)
                .Cells(cell.row, startOfEFPCompColumns + i).Formula = util.composeLink(server, STR_TICK, id, efpCompColumnsArray(i))
            Next i
        End If
    
        ' fill generic ticks columns with formulas if requested
        Dim genTicksStrArr() As String
        genTicksStrArr = split(.Cells(cell.row, genericTicksColumnIndex).value, util.COMMA_CHAR)
        Dim count As Integer
        Dim genTick As Integer
        count = 0
        genTicksColumnsArray = getGenTicksColumns()
        For i = 0 To UBound(genTicksColumnsArray) - LBound(genTicksColumnsArray)
            'if gentickstring contains
            genTick = genTicksColumnsArray(i).genTick
            For j = 0 To UBound(genTicksColumnsArray(i).names) - LBound(genTicksColumnsArray(i).names)
                If util.IsInArray(CStr(genTick), genTicksStrArr) Then
                    .Cells(cell.row, startOfGenericTicksColumns + count).Formula = util.composeLink(server, STR_TICK, id, genTicksColumnsArray(i).names(j))
                End If
                count = count + 1
            Next j
        Next i
    End With

End Sub

' ========================================================
' cancel all market data for all rows (called when workbook is closed)
' ========================================================
Sub cancelAllMktData()
    Dim rng As range, row As range, cell As range
    Dim server As String
    Dim id As String
    
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub
    
    With Worksheets(STR_SHEET_NAME)
        Set rng = .range(.Cells(dataStartRowIndex, idColumnIndex), .Cells(dataEndRowIndex, idColumnIndex))
    
        For Each row In rng.rows
            For Each cell In row.Cells
            If InStr(cell.value, STR_ID) <> 0 Then
                util.sendRequest server, STR_CANCELMKTDATA, cell.value
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' re-request all market data for all rows (called when workbook is opened)
' ========================================================
Sub requestAllMktData()
    Dim server As String
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    Dim rng As range
    
    With Worksheets(STR_SHEET_NAME)
        Set rng = .range(.Cells(dataStartRowIndex, idColumnIndex), .Cells(dataEndRowIndex, idColumnIndex))
    
        Dim row As range, cell As range
        For Each row In rng.rows
            For Each cell In row.Cells
            If InStr(cell.value, STR_ID) <> 0 Then
                sendMarketDataRequest server, cell
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' Called when some value changes
' ========================================================
Private Sub Worksheet_Calculate()
    Dim i As Integer
    
    With Worksheets(STR_SHEET_NAME)
        For i = dataStartRowIndex To dataEndRowIndex
            If CStr(.Cells(i, fundamentalsColumnIndex).value) = util.STR_LONGVALUE Then
                ' request long values (currently only "fundamentals")
                ' some values lengths are longer than 255 symbols, DDE cannot send/receive such values, so we have to split long values into chunks and then merge them
                ' here we request array with splitted long value and then merge and display in cell
                Dim server As String, id As String
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub
                
                id = .Cells(i, idColumnIndex).value
                
                Dim fundamentalsArray() As Variant
                ' send request and receive fundamentals table/array
                fundamentalsArray = util.sendRequest(server, STR_REQMKTDATA_LONG_VALUE, id & util.QMARK & "fundamentals") ' returned array can be 1-Dimension or 2-Dimension
                .Cells(i, fundamentalsColumnIndex).value = util.createLongValue(fundamentalsArray)
            End If
        Next i
    End With
End Sub
