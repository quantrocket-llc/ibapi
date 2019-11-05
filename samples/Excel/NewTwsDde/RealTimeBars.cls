VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "RealTimeBars"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long
Dim contractColumnsArray() As Variant
Dim clearTable As Boolean

' constants
Const STR_SHEET_NAME = "RealTimeBars"
Const STR_REQ_REAL_TIME_BARS = "reqRealTimeBars"
Const STR_CANCEL_REAL_TIME_BARS = "cancelRealTimeBars"
Const STR_REQ_REAL_TIME_BARS_TICK = "realTimeBarsTick"

Const STR_ID = "id"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name

' columns
Const startOfContractColumns = 1 ' contract first column index (symbol)
Const sheetNameColumnIndex = 16 ' index of "page name" column
Const activateSheetColumnIndex = 17 ' index of "activate page" column
Const idColumnIndex = 18 ' index of "id" column
Const statusColumnIndex = 19 ' index of "status" column
Const errorColumnIndex = 20 ' index of "error" column
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

    contractColumnsArray = Array("SYMBOL", "SECTYPE", "LASTTRADEDATE", "STRIKE", "RIGHT", "MULTIPLIER", "TRADINGCLASS", "EXCH", "PRIMEXCH", "CURRENCY", "LOCALSYMBOL", "CONID")

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
' re-request all real time bars for all rows (called when workbook is opened)
' ========================================================
Sub requestAllRealTimeBars()
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
                sendRealTimeBarsRequest server, cell
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' cancel all real time bars for all rows (called when workbook is closed)
' ========================================================
Sub cancelAllRealTimeBars()
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
                If .Cells(row.row, statusColumnIndex).value = util.STR_SUBSCRIBED Or _
                        .Cells(row.row, statusColumnIndex).value = util.STR_RECEIVED Or _
                        .Cells(row.row, statusColumnIndex).value = util.STR_REQUESTED Then
                    util.sendRequest server, STR_CANCEL_REAL_TIME_BARS, cell.value
                End If
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' sends real time bars cancel when button is pressed
' ========================================================
Sub cancelRealTimeBars()
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

        util.sendRequest server, STR_CANCEL_REAL_TIME_BARS, id

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request real time bars for active row
' ========================================================
Sub requestRealTimeBars()
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)

        If .Cells(ActiveCell.row, idColumnIndex).value <> STR_EMPTY Then Exit Sub

        sendRealTimeBarsRequest server, ActiveCell

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' sends real time bars request for cell
' ========================================================
Sub sendRealTimeBarsRequest(server As String, cell As range)

    If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, cell, startOfContractColumns, getContractColumns()) Then Exit Sub

    ' get id
    Dim id As String
    id = util.getIDpost(genId, util.ID_REQ_REAL_TIME_BARS)

    With Worksheets(STR_SHEET_NAME)

        .Cells(cell.row, idColumnIndex).value = id

        ' range to poke
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(cell.row, startOfContractColumns), .Cells(cell.row, sheetNameColumnIndex - 1))

        ' fill status column with formula
        .Cells(cell.row, statusColumnIndex).Formula = util.composeLink(server, STR_REQ_REAL_TIME_BARS_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(cell.row, statusColumnIndex)) Then
            .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, errorColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If


        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_REAL_TIME_BARS, id, rangeToPoke

        ' fill error column with formula
        .Cells(cell.row, errorColumnIndex).Formula = util.composeLink(server, STR_REQ_REAL_TIME_BARS_TICK, id, util.STR_ERROR)
    End With

End Sub


' ========================================================
' Requests real time bars table/array
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
                Dim realTimeBarsArray() As Variant
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub

                id = .Cells(j, idColumnIndex).value

                ' send request and receive real time bars table/array
                realTimeBarsArray = util.sendRequest(server, STR_REQ_REAL_TIME_BARS, id) ' returned array can be 1-Dimension or 2-Dimension

                ' update sheet
                util.updateSheetWithArray _
                    CStr(.Cells(j, sheetNameColumnIndex).value), _
                    realTimeBarsArray, _
                    .Cells(j, activateSheetColumnIndex).value, _
                    "Real Time Bars", _
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


