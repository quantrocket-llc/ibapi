VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TickByTickExt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long

Dim contractColumnsArray() As Variant

' constants
Const STR_SHEET_NAME = "TickByTickExt"
Const STR_REQ_TICK_BY_TICK_DATA = "reqTickByTickDataExt"
Const STR_CANCEL_TICK_BY_TICK_DATA = "cancelTickByTickDataExt"
Const STR_TICK_BY_TICK_DATA_TICK = "tickByTickDataTickExt"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_NUM_OF_ROWS = "E5" ' cell with number of rows

' columns
Const startOfContractColumns = 1 ' contract first column index (symbol)
Const ignoreSizeColumnIndex = 13 ' index of ignoreSize column
Const statusColumnIndex = 14 ' index of "status" column
Const idColumnIndex = 15 ' index of "id" column
Const errorColumnIndex = 16 ' index of "error" column
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
' cancel tick-by-tick data for active row when button is pressed
' ========================================================
Sub cancelTickByTickData()
    Dim server As String, id As String, numOfRows As String, row As range

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        For Each row In Selection.rows
            If .Cells(row.row, idColumnIndex).value = STR_EMPTY Then GoTo Continue
            If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, row, startOfContractColumns, getContractColumns()) Then GoTo Continue
    
            id = .Cells(row.row, idColumnIndex).value
            .Cells(row.row, idColumnIndex).value = util.STR_EMPTY
    
            util.sendRequest server, STR_CANCEL_TICK_BY_TICK_DATA, id
    
            numOfRows = .range(CELL_NUM_OF_ROWS).value
            
            clearTickByTickDataColumns CInt(numOfRows), row
Continue:
        Next row
            
    End With
    
    
End Sub

' ========================================================
' clears tick-by-tick data cells
' ========================================================
Sub clearTickByTickDataColumns(numOfRows As Integer, cell As range)
    Dim i As Integer, j As Integer
    With Worksheets(STR_SHEET_NAME)
        .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
        .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
        .Cells(cell.row, errorColumnIndex).value = util.STR_EMPTY
        ' clear tick-by-tick data columns
        For i = 0 To numOfRows - 1
            For j = 0 To 12
                .Cells(cell.row + i, startOfTickByTickDataColumns + j).ClearContents
            Next j
        Next i
    End With
End Sub

' ========================================================
' request tick-by-tick data for active row when button is pressed
' ========================================================
Sub requestTickByTickData()
    Dim server As String, row As range

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub

    For Each row In Selection.rows
        If Worksheets(STR_SHEET_NAME).Cells(row.row, idColumnIndex).value <> STR_EMPTY Then GoTo Continue
        If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, row, startOfContractColumns, getContractColumns()) Then GoTo Continue
    
        sendTickByTickDataRequest server, row
Continue:
    Next row

End Sub

' ========================================================
' request tick-by-tick data for row
' ========================================================
Sub sendTickByTickDataRequest(server As String, cell As range)

    ' get id
    Dim id As String, ignoreSize As String, numOfRows As String
    id = util.getIDpost(genId, util.ID_REQ_TICK_BY_TICK_DATA_EXT)

    With Worksheets(STR_SHEET_NAME)
        .Cells(cell.row, idColumnIndex).value = id

        ignoreSize = .Cells(cell.row, ignoreSizeColumnIndex).value
        numOfRows = .range(CELL_NUM_OF_ROWS).value

        ' fill status column with formula
        .Cells(cell.row, statusColumnIndex).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(cell.row, statusColumnIndex)) Then
            clearTickByTickDataColumns CInt(numOfRows), cell
            Exit Sub
        End If

        ' send request
        util.sendPoke Worksheets(STR_SHEET_NAME), server, STR_REQ_TICK_BY_TICK_DATA, id & util.QMARK & ignoreSize & util.QMARK & numOfRows, cell, startOfContractColumns, getContractColumns(), 0, idColumnIndex, 0, 0, 0, 0

        ' fill error column with formula
        .Cells(cell.row, errorColumnIndex).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, util.STR_ERROR)

        ' fill tick-by-tick data columns with formulas
        Dim i As Integer
        For i = 0 To numOfRows - 1
            .Cells(cell.row + i, startOfTickByTickDataColumns).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "time")
            .Cells(cell.row + i, startOfTickByTickDataColumns + 1).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "price")
            .Cells(cell.row + i, startOfTickByTickDataColumns + 2).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "size")
            .Cells(cell.row + i, startOfTickByTickDataColumns + 3).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "exchange")
            .Cells(cell.row + i, startOfTickByTickDataColumns + 4).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "specCond")
            .Cells(cell.row + i, startOfTickByTickDataColumns + 5).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "pastLimit")
            .Cells(cell.row + i, startOfTickByTickDataColumns + 6).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "unreported")
            .Cells(cell.row + i, startOfTickByTickDataColumns + 7).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "bidSize")
            .Cells(cell.row + i, startOfTickByTickDataColumns + 8).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "bidPrice")
            .Cells(cell.row + i, startOfTickByTickDataColumns + 9).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "askPrice")
            .Cells(cell.row + i, startOfTickByTickDataColumns + 10).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "askSize")
            .Cells(cell.row + i, startOfTickByTickDataColumns + 11).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "bidPastLow")
            .Cells(cell.row + i, startOfTickByTickDataColumns + 12).Formula = util.composeLink(server, STR_TICK_BY_TICK_DATA_TICK, id, i & util.UNDERSCORE & "askPastHigh")
        Next i
    End With

End Sub

' ========================================================
' cancel all tick-by-tick data for all rows (called when workbook is closed)
' ========================================================
Sub cancelAllTickByTickData()
    Dim rng As range, row As range, cell As range
    Dim server As String

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



