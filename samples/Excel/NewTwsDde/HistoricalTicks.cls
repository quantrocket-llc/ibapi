VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "HistoricalTicks"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long
Dim contractColumnsArray() As Variant
Dim clearTable As Boolean

' constants
Const STR_SHEET_NAME = "HistoricalTicks"
Const STR_REQ_HISTORICAL_TICKS = "reqHistoricalTicks"
Const STR_CANCEL_HISTORICAL_TICKS = "cancelHistoricalTicks"
Const STR_REQ_HISTORICAL_TICKS_TICK = "historicalTicksTick"

Const STR_ID = "id"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name

' columns
Const startOfContractColumns = 1 ' contract first column index (symbol)
Const whatToShowColumnIndex = 17 ' index of "what to show" column
Const sheetNameColumnIndex = 20 ' index of "page name" column
Const activateSheetColumnIndex = 21 ' index of "activate page" column
Const idColumnIndex = 22 ' index of "id" column
Const statusColumnIndex = 23 ' index of "status" column
Const errorColumnIndex = 24 ' index of "error" column

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

    contractColumnsArray = Array("SYMBOL", "SECTYPE", "LASTTRADEDATE", "STRIKE", "RIGHT", "MULTIPLIER", "TRADINGCLASS", "EXCH", "PRIMEXCH", "CURRENCY", "LOCALSYMBOL", "CONID", "INCLUDEEXPIRED")

getContractColumnsEnd:
    getContractColumns = contractColumnsArray
End Function

' ========================================================
' header
' ========================================================
Private Function getHeader(whatToShow As String) As String
    If whatToShow = "BID_ASK" Then
        getHeader = "Historical Ticks Bid/Ask"
    ElseIf whatToShow = "TRADES" Then
        getHeader = "Historical Ticks Last"
    ElseIf whatToShow = "MIDPOINT" Then
        getHeader = "Historical Ticks"
    End If
End Function

' ========================================================
' header columns
' ========================================================
Private Function getHeaderColumns(whatToShow As String) As Variant()
    If whatToShow = "BID_ASK" Then
        getHeaderColumns = Array("Time", "BidPrice", "BidSize", "AskPrice", "AskSize", "BidPastLow", "AskPastHigh")
    ElseIf whatToShow = "TRADES" Then
        getHeaderColumns = Array("Time", "Price", "Size", "PastLimit", "Unreported", "Exchange", "SpecialConditions")
    ElseIf whatToShow = "MIDPOINT" Then
        getHeaderColumns = Array("Time", "Price")
    End If
End Function

' ========================================================
' sends historical ticks cancel when button is pressed
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

        util.sendRequest server, STR_CANCEL_HISTORICAL_TICKS, id

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request historical ticks for active row
' ========================================================
Sub requestHistoricalTicks()
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub

    If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, ActiveCell, startOfContractColumns, getContractColumns()) Then Exit Sub

    With Worksheets(STR_SHEET_NAME)

        If .Cells(ActiveCell.row, idColumnIndex).value <> STR_EMPTY Then Exit Sub

        sendHistoricalTicksRequest server, ActiveCell

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' sends historical ticks request for cell
' ========================================================
Sub sendHistoricalTicksRequest(server As String, cell As range)

    ' get id
    Dim id As String
    id = util.getIDpost(genId, util.ID_REQ_HISTORICAL_TICKS)

    With Worksheets(STR_SHEET_NAME)

        .Cells(cell.row, idColumnIndex).value = id

        ' range to poke
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(cell.row, startOfContractColumns), .Cells(cell.row, sheetNameColumnIndex - 1))

        ' fill status column with formula
        .Cells(cell.row, statusColumnIndex).Formula = util.composeLink(server, STR_REQ_HISTORICAL_TICKS_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(cell.row, statusColumnIndex)) Then
            .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, errorColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If

        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_HISTORICAL_TICKS, id, rangeToPoke

        ' fill error column with formula
        .Cells(cell.row, errorColumnIndex).Formula = util.composeLink(server, STR_REQ_HISTORICAL_TICKS_TICK, id, util.STR_ERROR)
    End With

End Sub


' ========================================================
' Requests historical data table/array
' Called when value in CELL_STATUS changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String, whatToShow As String
    Dim i As Integer, j As Integer

    With Worksheets(STR_SHEET_NAME)

        For j = dataStartRowIndex To dataEndRowIndex
            If CStr(.Cells(j, statusColumnIndex).value) = util.STR_REQUESTED Then
                clearTable = True
            End If
            If CStr(.Cells(j, statusColumnIndex).value) = util.STR_RECEIVED Then
                Dim historicalTicksArray() As Variant
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub

                id = .Cells(j, idColumnIndex).value
                whatToShow = .Cells(j, whatToShowColumnIndex).value

                ' send request and receive historical data table/array
                historicalTicksArray = util.sendRequest(server, STR_REQ_HISTORICAL_TICKS, id) ' returned array can be 1-Dimension or 2-Dimension

                ' update sheet
                util.updateSheetWithArray _
                    CStr(.Cells(j, sheetNameColumnIndex).value), _
                    historicalTicksArray, _
                    .Cells(j, activateSheetColumnIndex).value, _
                    getHeader(whatToShow), _
                    getHeaderColumns(whatToShow), _
                    True, _
                    False, _
                    0, _
                    clearTable

                clearTable = False

            End If
        Next j
    End With
End Sub


