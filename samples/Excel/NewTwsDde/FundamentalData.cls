VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FundamentalData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long
Dim contractColumnsArray() As Variant

' constants
Const STR_SHEET_NAME = "FundamentalData"
Const STR_REQ_FUNDAMENTAL_DATA = "reqFundamentalData"
Const STR_CANCEL_FUNDAMENTAL_DATA = "cancelFundamentalData"
Const STR_FUNDAMENTAL_DATA_TICK = "fundamentalDataTick"

Const STR_ID = "id"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name

' columns
Const startOfContractColumns = 1 ' contract first column index (symbol)
Const reportTypeColumnIndex = 8 ' index of "report type" column
Const sheetNameColumnIndex = 9 ' index of "page name" column
Const activateSheetColumnIndex = 10 ' index of "activate page" column
Const idColumnIndex = 11 ' index of "id" column
Const statusColumnIndex = 12 ' index of "status" column
Const errorColumnIndex = 13 ' index of "error" column

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

    contractColumnsArray = Array("SYMBOL", "SECTYPE", "EXCH", "PRIMEXCH", "CURRENCY", "LOCALSYMBOL", "CONID")

getContractColumnsEnd:
    getContractColumns = contractColumnsArray
End Function

' ========================================================
' sends fundamental data cancel when button is pressed
' ========================================================
Sub cancelFundamentalData()
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

        util.sendRequest server, STR_CANCEL_FUNDAMENTAL_DATA, id

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request fundamental data for active row
' ========================================================
Sub requestFundamentalData()
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        If .Cells(ActiveCell.row, idColumnIndex).value <> STR_EMPTY Then Exit Sub
        If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, ActiveCell, startOfContractColumns, getContractColumns()) Then Exit Sub

        ' get id
        Dim id As String
        id = util.getIDpost(genId, util.ID_REQ_FUNDAMENTAL_DATA)
        .Cells(ActiveCell.row, idColumnIndex).value = id

        ' fill status column with formula
        .Cells(ActiveCell.row, statusColumnIndex).Formula = util.composeLink(server, STR_FUNDAMENTAL_DATA_TICK, id, util.STR_STATUS)

        If util.cleanOnError(.Cells(ActiveCell.row, statusColumnIndex)) Then
            .Cells(ActiveCell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(ActiveCell.row, statusColumnIndex).value = util.STR_EMPTY
            .Cells(ActiveCell.row, errorColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If

        ' range to poke
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(ActiveCell.row, startOfContractColumns), .Cells(ActiveCell.row, reportTypeColumnIndex))

        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_FUNDAMENTAL_DATA, id, rangeToPoke
        
        ' fill error column with formula
        .Cells(ActiveCell.row, errorColumnIndex).Formula = util.composeLink(server, STR_FUNDAMENTAL_DATA_TICK, id, util.STR_ERROR)

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub


' ========================================================
' Requests fundamental data table/array
' Called when value in CELL_STATUS changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String
    Dim i As Integer, j As Integer

    With Worksheets(STR_SHEET_NAME)

        For j = dataStartRowIndex To dataEndRowIndex
            If CStr(.Cells(j, statusColumnIndex).value) = util.STR_RECEIVED Then
                Dim fundamentalDataArray() As Variant
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub

                id = .Cells(j, idColumnIndex).value

                ' send request and receive fundamental data table/array
                fundamentalDataArray = util.sendRequest(server, STR_REQ_FUNDAMENTAL_DATA, id)

                ' update sheet
                util.updateSheetWithArray _
                    CStr(.Cells(j, sheetNameColumnIndex).value), _
                    fundamentalDataArray, _
                    .Cells(j, activateSheetColumnIndex).value, _
                    "Fundamental Data", _
                    util.getHeaderColumnsForXML(), _
                    True, _
                    False, _
                    0, _
                    False
            End If
        Next j
    End With
End Sub






