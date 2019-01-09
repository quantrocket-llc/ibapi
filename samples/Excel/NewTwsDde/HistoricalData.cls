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

Dim genId As Long
Dim contractColumnsArray() As Variant
Dim clearTable As Boolean

' constants
Const STR_SHEET_NAME = "HistoricalData"
Const STR_REQ_HISTORICAL_DATA = "reqHistoricalData"
Const STR_CANCEL_HISTORICAL_DATA = "cancelHistoricalData"
Const STR_HISTORICAL_DATA_TICK = "historicalDataTick"

Const STR_ID = "id"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name

' columns
Const startOfContractColumns = 1 ' contract first column index (symbol)
Const includeExpiredColumnIndex = 14 ' index of "include expired" column
Const keepUpToDateColumnIndex = 21 ' index of "keep up to date columne" column
Const sheetNameColumnIndex = 22 ' index of "page name" column
Const activateSheetColumnIndex = 23 ' index of "activate page" column
Const idColumnIndex = 24 ' index of "id" column
Const statusColumnIndex = 25 ' index of "status" column
Const errorColumnIndex = 26 ' index of "error" column


Const timeColumnIndex = 1 ' index of time column in new sheet

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

    contractColumnsArray = Array("SYMBOL", "SECTYPE", "LASTTRADEDATE", "STRIKE", "RIGHT", "MULTIPLIER", "TRADINGCLASS", "EXCH", "PRIMEXCH", "CURRENCY", "LOCALSYMBOL", "CONID", "COMBOLEGS", "INCLUDEEXPIRED")

getContractColumnsEnd:
    getContractColumns = contractColumnsArray
End Function

' ========================================================
' header columns
' ========================================================
Private Function getHeaderColumns() As Variant()
    getHeaderColumns = Array("Time", "Open", "High", "Low", "Close", "Volume", "Count", "Wap")
End Function

' ========================================================
' re-request all historical data for all rows (called when workbook is opened)
' ========================================================
Sub requestAllHistoricalData()
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
                sendHistoricalDataRequest server, cell
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' cancel all historical data for all rows (called when workbook is closed)
' ========================================================
Sub cancelAllHistoricalData()
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
                If .Cells(row.row, statusColumnIndex).value = util.STR_SUBSCRIBED Or .Cells(row.row, statusColumnIndex).value = util.STR_RECEIVED Then
                    util.sendRequest server, STR_CANCEL_HISTORICAL_DATA, cell.value
                End If
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' sends historical data cancel when button is pressed
' ========================================================
Sub cancelHistoricalData()
    Dim server As String, id As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
    
        If .Cells(ActiveCell.row, idColumnIndex).value = STR_EMPTY Then Exit Sub
        If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, ActiveCell, startOfContractColumns, getContractColumns()) Then Exit Sub
    
        id = .Cells(ActiveCell.row, idColumnIndex).value
        .Cells(ActiveCell.row, idColumnIndex).value = util.STR_EMPTY
    
        ' status column
        .Cells(ActiveCell.row, statusColumnIndex).ClearContents
        ' error column
        .Cells(ActiveCell.row, errorColumnIndex).ClearContents
    
        util.sendRequest server, STR_CANCEL_HISTORICAL_DATA, id
    
        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request historical data for active row
' ========================================================
Sub requestHistoricalData()
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub
    
    With Worksheets(STR_SHEET_NAME)
        
        If .Cells(ActiveCell.row, idColumnIndex).value <> STR_EMPTY Then Exit Sub
        
        sendHistoricalDataRequest server, ActiveCell
        
        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With
    
End Sub

' ========================================================
' sends historical data request for cell
' ========================================================
Sub sendHistoricalDataRequest(server As String, cell As range)

    If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, cell, startOfContractColumns, getContractColumns()) Then Exit Sub

    ' get id
    Dim id As String
    id = util.getIDpost(genId, util.ID_REQ_HISTORICAL_DATA)
    
    With Worksheets(STR_SHEET_NAME)
    
        .Cells(cell.row, idColumnIndex).value = id
    
        ' range to poke
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(cell.row, startOfContractColumns), .Cells(cell.row, sheetNameColumnIndex - 1))
    
        ' fill status column with formula
        .Cells(cell.row, statusColumnIndex).Formula = util.composeLink(server, STR_HISTORICAL_DATA_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(cell.row, statusColumnIndex)) Then
            .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, errorColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If
    
        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_HISTORICAL_DATA, id, rangeToPoke
    
        ' fill error column with formula
        .Cells(cell.row, errorColumnIndex).Formula = util.composeLink(server, STR_HISTORICAL_DATA_TICK, id, util.STR_ERROR)
    End With

End Sub


' ========================================================
' Requests historical data table/array
' Called when value in CELL_STATUS changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String
    Dim i As Integer, j As Integer
    
    With Worksheets(STR_SHEET_NAME)
        
        For j = dataStartRowIndex To dataEndRowIndex
            If CStr(.Cells(j, statusColumnIndex).value) = util.STR_REQUESTED Then
                clearTable = True
            End If
            If CStr(.Cells(j, statusColumnIndex).value) = util.STR_RECEIVED Then
                Dim historicalDataArray() As Variant
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub
    
                id = .Cells(j, idColumnIndex).value
    
                ' send request and receive historical data table/array
                historicalDataArray = util.sendRequest(server, STR_REQ_HISTORICAL_DATA, id) ' returned array can be 1-Dimension or 2-Dimension
    
                ' update sheet
                util.updateSheetWithArray _
                    CStr(.Cells(j, sheetNameColumnIndex).value), _
                    historicalDataArray, _
                    .Cells(j, activateSheetColumnIndex).value, _
                    "Historical Data", _
                    getHeaderColumns(), _
                    True, _
                    True, _
                    timeColumnIndex, _
                    clearTable
                
                clearTable = False
                
            End If
        Next j
    End With
End Sub
