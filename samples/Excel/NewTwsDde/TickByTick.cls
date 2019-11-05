VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TickByTick"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long

Dim contractColumnsArray() As Variant
Dim tickByTickDataColumnsArray() As Variant

' constants
Const STR_SHEET_NAME = "TickByTick"
Const STR_REQ_TICK_BY_TICK_DATA = "reqTickByTickData"
Const STR_CANCEL_TICK_BY_TICK_DATA = "cancelTickByTickData"
Const STR_TICK_BY_TICK_DATA_TICK = "tickByTickDataTick"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name

' columns
Const startOfContractColumns = 1 ' contract first column index (symbol)
Const tickTypeColumnIndex = 13 ' index of "tick type" column
Const ignoreSizeColumnIndex = 14 ' index of "ignore size" column
Const statusColumnIndex = 15 ' index of "status" column
Const idColumnIndex = 16 ' index of "id" column
Const startOfTickByTickDataColumns = 17 ' tick-by-tick data first column index

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

    contractColumnsArray = Array("SYMBOL", "SECTYPE", "LASTTRADEDATE", "STRIKE", "RIGHT", "MULTIPLIER", "TRADINGCLASS", "EXCH", "PRIMEXCH", "CURRENCY", "LOCALSYMBOL", "CONID")

getContractColumnsEnd:
    getContractColumns = contractColumnsArray
End Function


' ========================================================
' tick-by-tick data columns
' ========================================================
Private Function getTickByTickDataColumns() As Variant()

    If (Not Not tickByTickDataColumnsArray) <> 0 Then
        ' do not re-initialize array
        GoTo getTickByTickDataColumnsEnd
    End If
    
    tickByTickDataColumnsArray = Array("error", "time", "price", "size", "exchange", "specCond", "bidPrice", "askPrice", "bidSize", "askSize", "midPoint", "pastLimit", "unreported", _
        "bidPastLow", "askPastHigh")
    
getTickByTickDataColumnsEnd:
    getTickByTickDataColumns = tickByTickDataColumnsArray
End Function

' ========================================================
' cancel tick-by-tick data for active row when button is pressed
' ========================================================
Sub cancelTickByTickData()

    Dim server As String, id As String, i As Integer, j As Integer, lastRowIndex As Integer, row As range

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        For Each row In Selection.rows
            lastRowIndex = row.row

            If .Cells(row.row, idColumnIndex).value = STR_EMPTY Then GoTo Continue
            If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, row, startOfContractColumns, getContractColumns()) Then GoTo Continue
            
            id = .Cells(row.row, idColumnIndex).value
            .Cells(row.row, idColumnIndex).value = util.STR_EMPTY
        
            ' status column
            clearTickByTickDataColumns row
            
            util.sendRequest server, STR_CANCEL_TICK_BY_TICK_DATA, id
Continue:
        Next row

        .Cells(lastRowIndex, 1).offset(1, 0).Activate
    End With
End Sub

' ========================================================
' clears tick-by-tick data cells
' ========================================================
Sub clearTickByTickDataColumns(cell As range)
    Dim i As Integer
    ' tick-by-tick data columns
    tickByTickDataColumnsArray = getTickByTickDataColumns()
    With Worksheets(STR_SHEET_NAME)
        .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
        .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
        For i = 0 To UBound(tickByTickDataColumnsArray) - LBound(tickByTickDataColumnsArray)
            .Cells(cell.row, startOfTickByTickDataColumns + i).ClearContents
        Next i
    End With

End Sub

' ========================================================
' request tick-by-tick data for active row when button is pressed
' ========================================================
Sub requestTickByTickData()
    Dim server As String, lastRowIndex As Integer, row As range

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        For Each row In Selection.rows
            lastRowIndex = row.row
            If .Cells(row.row, idColumnIndex).value <> STR_EMPTY Then GoTo Continue
            If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, row, startOfContractColumns, getContractColumns()) Then GoTo Continue
            sendTickByTickDataRequest server, row
Continue:
        Next row
            
        .Cells(lastRowIndex, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request tick-by-tick data for row
' ========================================================
Sub sendTickByTickDataRequest(server As String, cell As range)

    ' get id
    Dim id As String
    id = util.getIDpost(genId, util.ID_REQ_TICK_BY_TICK_DATA)
    
    Dim tickType As String
    Dim ignoreSize As String

    With Worksheets(STR_SHEET_NAME)
        .Cells(cell.row, idColumnIndex).value = id
        
        tickType = .Cells(cell.row, tickTypeColumnIndex).value
        ignoreSize = .Cells(cell.row, ignoreSizeColumnIndex).value

        ' fill status column with formula
        .Cells(cell.row, statusColumnIndex).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, util.STR_STATUS)
        
        If util.cleanOnError(.Cells(cell.row, statusColumnIndex)) Then
            clearTickByTickDataColumns cell
            Exit Sub
        End If

        ' send request
        util.sendPoke Worksheets(STR_SHEET_NAME), server, STR_REQ_TICK_BY_TICK_DATA, id & util.QMARK & tickType & util.QMARK & ignoreSize, cell, startOfContractColumns, getContractColumns(), 0, idColumnIndex, 0, 0, 0, 0


        ' fill tick-by-tick data columns with formulas
        Dim i As Integer, j As Integer
        tickByTickDataColumnsArray = getTickByTickDataColumns()
        For i = 0 To UBound(tickByTickDataColumnsArray) - LBound(tickByTickDataColumnsArray)
            .Cells(cell.row, startOfTickByTickDataColumns + i).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, tickByTickDataColumnsArray(i))
        Next i

    End With

End Sub

' ========================================================
' cancel all tick-by-tick data for all rows (called when workbook is closed)
' ========================================================
Sub cancelAllTickByTickData()
    Dim rng As range, row As range, cell As range
    Dim server As String
    Dim id As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        Set rng = .range(.Cells(dataStartRowIndex, idColumnIndex), .Cells(dataEndRowIndex, idColumnIndex))

        For Each row In rng.rows
            For Each cell In row.Cells
            If InStr(cell.value, util.IDENTIFIER_PREFIX) <> 0 Then
                util.sendRequest server, STR_CANCEL_TICK_BY_TICK_DATA, cell.value
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' re-request all tick-by-tick data for all rows (called when workbook is opened)
' ========================================================
Sub requestAllTickByTickData()
    Dim server As String
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    Dim rng As range

    With Worksheets(STR_SHEET_NAME)
        Set rng = .range(.Cells(dataStartRowIndex, idColumnIndex), .Cells(dataEndRowIndex, idColumnIndex))

        Dim row As range, cell As range
        For Each row In rng.rows
            For Each cell In row.Cells
            If InStr(cell.value, util.IDENTIFIER_PREFIX) <> 0 Then
                sendTickByTickDataRequest server, cell
            End If
          Next cell
        Next row
    End With
End Sub

