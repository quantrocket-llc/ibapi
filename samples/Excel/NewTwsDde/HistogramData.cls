VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "HistogramData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long
Dim contractColumnsArray() As Variant
Dim clearTable As Boolean

' constants
Const STR_SHEET_NAME = "HistogramData"
Const STR_REQ_HISTOGRAM_DATA = "reqHistogramData"
Const STR_CANCEL_HISTOGRAM_DATA = "cancelHistogramData"
Const STR_REQ_HISTOGRAM_DATA_TICK = "histogramDataTick"

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
' header columns
' ========================================================
Private Function getHeaderColumns() As Variant()
     getHeaderColumns = Array("Price", "Size")
End Function

' ========================================================
' sends histogram data cancel when button is pressed
' ========================================================
Sub cancelHistogramData()
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

        util.sendRequest server, STR_CANCEL_HISTOGRAM_DATA, id

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request histogram data for active row
' ========================================================
Sub requestHistogramData()
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub

    If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, ActiveCell, startOfContractColumns, getContractColumns()) Then Exit Sub

    With Worksheets(STR_SHEET_NAME)

        If .Cells(ActiveCell.row, idColumnIndex).value <> STR_EMPTY Then Exit Sub

        sendHistogramDataRequest server, ActiveCell

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With
End Sub

' ========================================================
' sends histogram data request for cell
' ========================================================
Private Sub sendHistogramDataRequest(server As String, cell As range)

    ' get id
    Dim id As String
    id = util.getIDpost(genId, util.ID_REQ_HISTOGRAM_DATA)

    With Worksheets(STR_SHEET_NAME)

        .Cells(cell.row, idColumnIndex).value = id

        ' range to poke
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(cell.row, startOfContractColumns), .Cells(cell.row, sheetNameColumnIndex - 1))

        ' fill status column with formula
        .Cells(cell.row, statusColumnIndex).Formula = util.composeLink(server, STR_REQ_HISTOGRAM_DATA_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(cell.row, statusColumnIndex)) Then
            .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, errorColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If

        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_HISTOGRAM_DATA, id, rangeToPoke

        ' fill error column with formula
        .Cells(cell.row, errorColumnIndex).Formula = util.composeLink(server, STR_REQ_HISTOGRAM_DATA_TICK, id, util.STR_ERROR)
    End With

End Sub


' ========================================================
' Requests historical data table/array
' Called when value in CELL_STATUS changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String
    Dim j As Integer

    With Worksheets(STR_SHEET_NAME)

        For j = dataStartRowIndex To dataEndRowIndex
            If CStr(.Cells(j, statusColumnIndex).value) = util.STR_REQUESTED Then
                clearTable = True
            End If
            If CStr(.Cells(j, statusColumnIndex).value) = util.STR_RECEIVED Then
                Dim histogramDataArray() As Variant
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub

                id = .Cells(j, idColumnIndex).value

                ' send request and receive histogram data table/array
                histogramDataArray = util.sendRequest(server, STR_REQ_HISTOGRAM_DATA, id) ' returned array can be 1-Dimension or 2-Dimension

                ' update sheet
                util.updateSheetWithArray _
                    CStr(.Cells(j, sheetNameColumnIndex).value), _
                    histogramDataArray, _
                    .Cells(j, activateSheetColumnIndex).value, _
                    "Histogram Data", _
                    getHeaderColumns(), _
                    True, _
                    False, _
                    0, _
                    clearTable

                clearTable = False

            End If
        Next j
    End With
End Sub




