VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SecDefOptParams"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long
Dim clearTable As Boolean

' constants
Const STR_SHEET_NAME = "SecDefOptParams"
Const STR_REQ_SEC_DEF_OPT_PARAMS = "reqSecDefOptParams"
Const STR_CANCEL_SEC_DEF_OPT_PARAMS = "cancelSecDefOptParams"
Const STR_REQ_SEC_DEF_OPT_PARAMS_TICK = "secDefOptParamsTick"

Const STR_ID = "id"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name

' columns
Const startOfRequestColumns = 1 ' contract first column index (symbol)
Const underlyingConIdColumn = 4 ' index of "underlying conid" column
Const sheetNameColumnIndex = 5 ' index of "page name" column
Const activateSheetColumnIndex = 6 ' index of "activate page" column
Const idColumnIndex = 7 ' index of "id" column
Const statusColumnIndex = 8 ' index of "status" column
Const errorColumnIndex = 9 ' index of "error" column

' rows
Const dataStartRowIndex = 10 ' starting row of data
Const dataEndRowIndex = util.maxRowsToFormat ' ending row of data

' ========================================================
' header columns
' ========================================================
Private Function getHeaderColumns() As Variant()
    getHeaderColumns = Array("Exchange", "UnderlyingConId", "TradingClass", "Multiplier", "Expirations", "Strikes")
End Function

' ========================================================
' sends security definition option parameters cancel when button is pressed
' ========================================================
Sub cancelSecDefOptParams()

    Dim server As String, id As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)

        If .Cells(ActiveCell.row, idColumnIndex).value = STR_EMPTY Then Exit Sub
        If Not util.hasRequestData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, ActiveCell, underlyingConIdColumn) Then Exit Sub

        id = .Cells(ActiveCell.row, idColumnIndex).value
        .Cells(ActiveCell.row, idColumnIndex).value = util.STR_EMPTY

        ' status column
        .Cells(ActiveCell.row, statusColumnIndex).ClearContents
        ' error column
        .Cells(ActiveCell.row, errorColumnIndex).ClearContents

        util.sendRequest server, STR_CANCEL_SEC_DEF_OPT_PARAMS, id

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request security definition option parameters for active row
' ========================================================
Sub requestSecDefOptParams()
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)

        If .Cells(ActiveCell.row, idColumnIndex).value <> STR_EMPTY Then Exit Sub
        If Not util.hasRequestData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, ActiveCell, underlyingConIdColumn) Then Exit Sub

        sendSecDefOptParamsRequest server, ActiveCell

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' sends security definition option parameters request for cell
' ========================================================
Sub sendSecDefOptParamsRequest(server As String, cell As range)

    ' get id
    Dim id As String
    id = util.getIDpost(genId, util.ID_REQ_SEC_DEF_OPT_PARAMS)

    With Worksheets(STR_SHEET_NAME)

        .Cells(cell.row, idColumnIndex).value = id

        ' range to poke
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(cell.row, startOfRequestColumns), .Cells(cell.row, sheetNameColumnIndex - 1))

        ' fill status column with formula
        .Cells(cell.row, statusColumnIndex).Formula = util.composeLink(server, STR_REQ_SEC_DEF_OPT_PARAMS_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(cell.row, statusColumnIndex)) Then
            .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, errorColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If

        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_SEC_DEF_OPT_PARAMS, id, rangeToPoke

        ' fill error column with formula
        .Cells(cell.row, errorColumnIndex).Formula = util.composeLink(server, STR_REQ_SEC_DEF_OPT_PARAMS_TICK, id, util.STR_ERROR)
    End With

End Sub


' ========================================================
' Requests security definition option parameters table/array
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
                Dim secDefOptParamsArray() As Variant
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub

                id = .Cells(j, idColumnIndex).value

                ' send request and receive security definition option parameters table/array
                secDefOptParamsArray = util.sendRequest(server, STR_REQ_SEC_DEF_OPT_PARAMS, id)

                ' update sheet
                util.updateSheetWithArray _
                    CStr(.Cells(j, sheetNameColumnIndex).value), _
                    secDefOptParamsArray, _
                    .Cells(j, activateSheetColumnIndex).value, _
                    "Security Definition Option Parameters", _
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




