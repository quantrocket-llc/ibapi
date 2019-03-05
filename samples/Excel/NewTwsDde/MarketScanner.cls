VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "MarketScanner"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long

' constants
Const STR_SHEET_NAME = "MarketScanner"
Const STR_REQ_SCANNER_SUBSCRIPTION = "reqScannerSubscription"
Const STR_CANCEL_SCANNER_SUBSCRIPTION = "cancelScannerSubscription"
Const STR_SCANNER_SUBSCRIPTION_TICK = "scannerSubscriptionTick"
Const STR_REQ_SCANNER_PARAMETERS = "reqScannerParameters"

Const STR_ID = "id"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_SCANNER_PARAMETERS_CONTROL = "E5" ' scanner parameters control cell

' columns
Const sheetNameColumnIndex = 1 ' index of "page name" column
Const activateSheetColumnIndex = 2 ' index of "activate page" column
Const idColumnIndex = 3 ' index of "id" column
Const statusColumnIndex = 4 ' index of "status" column
Const errorColumnIndex = 5 ' index of "error" column
Const startOfScannerFilterColumns = 6 ' scanner filter first column index
Const endOfScannerFilterColumns = 27 ' scanner filter last column index

' rows
Const dataStartRowIndex = 10 ' starting row of data
Const dataEndRowIndex = util.maxRowsToFormat ' ending row of data

' ========================================================
' header columns
' ========================================================
Private Function getHeaderColumns() As Variant()
    getHeaderColumns = Array("Rank", "ConId", "Symbol", "SecType", "LastTradeDate", "Strike", "Right", "Exchange", "Currency", "LocalSymbol", "MarketName", "TradingClass", "Distance", "Benchmark", "Projection", "Legs")
End Function

' ========================================================
' cancel scanner subscription for active row when button is pressed
' ========================================================
Sub cancelScannerSubscription()
    Dim server As String, id As String, i As Integer, isSmartDepth As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)

        If .Cells(ActiveCell.row, idColumnIndex).value = STR_EMPTY Then Exit Sub
        If Not util.hasRequestData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, ActiveCell, startOfScannerFilterColumns) Then Exit Sub
    
        id = .Cells(ActiveCell.row, idColumnIndex).value
        .Cells(ActiveCell.row, idColumnIndex).value = util.STR_EMPTY
    
        ' status column
        .Cells(ActiveCell.row, statusColumnIndex).ClearContents
        ' error column
        .Cells(ActiveCell.row, errorColumnIndex).ClearContents
    
        util.sendRequest server, STR_CANCEL_SCANNER_SUBSCRIPTION, id
    
        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request scanner parameters when button is pressed
' ========================================================
Sub requestScannerParameters()
    Dim server As String
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub
    
    With Worksheets(STR_SHEET_NAME)
        .range(CELL_SCANNER_PARAMETERS_CONTROL).Formula = util.composeLink(server, STR_REQ_SCANNER_PARAMETERS, util.IDENTIFIER_ZERO, util.STR_EMPTY) ' subscription control
        If util.cleanOnError(.range(CELL_SCANNER_PARAMETERS_CONTROL)) Then
            .range(CELL_SCANNER_PARAMETERS_CONTROL).value = util.STR_EMPTY
            Exit Sub
        End If
    End With
    
End Sub

' ========================================================
' cancel scanner parameters when button is pressed
' ========================================================
Sub cancelScannerParameters()
    Worksheets(STR_SHEET_NAME).range(CELL_SCANNER_PARAMETERS_CONTROL).Formula = util.STR_EMPTY
End Sub


' ========================================================
' request scanner subscription for active row when button is pressed
' ========================================================
Sub requestScannerSubscription()
    Dim row As range, server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub
    
    If Worksheets(STR_SHEET_NAME).Cells(ActiveCell.row, idColumnIndex).value <> STR_EMPTY Then Exit Sub
    
    sendScannerSubscription server, ActiveCell
    
    Worksheets(STR_SHEET_NAME).Cells(ActiveCell.row, 1).offset(1, 0).Activate

End Sub

' ========================================================
' request scanner subscription for active row when button is pressed
' ========================================================
Sub sendScannerSubscription(server As String, cell As range)
    ' get id
    Dim id As String
    id = util.getIDpost(genId, util.ID_REQ_SCANNER_SUBSCRIPTION)
    With Worksheets(STR_SHEET_NAME)
    
        If Not util.hasRequestData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, ActiveCell, startOfScannerFilterColumns) Then Exit Sub
    
        .Cells(cell.row, idColumnIndex).value = id
        
        ' range to poke
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(cell.row, startOfScannerFilterColumns), .Cells(cell.row, endOfScannerFilterColumns))
    
        ' fill status column with formula
        .Cells(cell.row, statusColumnIndex).Formula = util.composeLink(server, STR_SCANNER_SUBSCRIPTION_TICK, id, util.STR_STATUS)
    
        If util.cleanOnError(.Cells(cell.row, statusColumnIndex)) Then
            .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, errorColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If
    
        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_SCANNER_SUBSCRIPTION, id, rangeToPoke
        
        ' fill error column with formula
        .Cells(cell.row, errorColumnIndex).Formula = util.composeLink(server, STR_SCANNER_SUBSCRIPTION_TICK, id, util.STR_ERROR)
    
    End With

End Sub



' ========================================================
' cancel all scanner subscriptions for all rows (called when workbook is closed)
' ========================================================
Sub cancelAllScannerSubscriptions()
    Dim rng As range, row As range, cell As range
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)

        Set rng = .range(.Cells(dataStartRowIndex, idColumnIndex), .Cells(dataEndRowIndex, idColumnIndex))
    
        For Each row In rng.rows
            For Each cell In row.Cells
            If InStr(cell.value, STR_ID) <> 0 Then
                util.sendRequest server, STR_CANCEL_SCANNER_SUBSCRIPTION, cell.value
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' re-request all scanner subscriptions for all rows (called when workbook is opened)
' ========================================================
Sub requestAllScannerSubscriptions()
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
                sendScannerSubscription server, cell
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' Requests scanner data table/array
' Called when value in CELL_STATUS changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String
    Dim i As Integer, j As Integer
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
    
        If CStr(.range(CELL_SCANNER_PARAMETERS_CONTROL)) = util.STR_RECEIVED Then
                Dim scannerParamsArray() As Variant
                scannerParamsArray = util.sendRequest(server, STR_REQ_SCANNER_PARAMETERS, id & "scanParameters") ' returned array can be 1-Dimension or 2-Dimension
                
                ' update sheet
                util.updateSheetWithArray _
                    "SCANNER_PARAMS", _
                    scannerParamsArray, _
                    True, _
                    "Scanner Parameters", _
                    util.getHeaderColumnsForXML(), _
                    True, _
                    False, _
                    0, _
                    False
        End If
    
        For j = dataStartRowIndex To dataEndRowIndex
    
            If CStr(.Cells(j, statusColumnIndex).value) = util.STR_RECEIVED Then
                Dim scannerDataArray() As Variant
        
                id = .Cells(j, idColumnIndex).value
        
                ' send request and receive scanner data table/array
                scannerDataArray = util.sendRequest(server, STR_REQ_SCANNER_SUBSCRIPTION, id) ' returned array can be 1-Dimension or 2-Dimension
                
                ' update sheet
                util.updateSheetWithArray _
                    CStr(.Cells(j, sheetNameColumnIndex).value), _
                    scannerDataArray, _
                    .Cells(j, activateSheetColumnIndex).value, _
                    "Market Scanner Data", _
                    getHeaderColumns(), _
                    False, _
                    False, _
                    0, _
                    False
                    
                
            End If
        Next j
    End With
End Sub
           

