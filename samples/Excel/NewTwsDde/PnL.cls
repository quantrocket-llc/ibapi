VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "PnL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long

Dim pnlColumnsArray() As Variant

' constants
Const STR_SHEET_NAME = "PnL"
Const STR_REQ_PNL = "reqPnL"
Const STR_CANCEL_PNL = "cancelPnL"
Const STR_PNL_TICK = "PnLTick"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name

' columns
Const startOfRequestColumns = 1 ' request first column index (account)
Const statusColumnIndex = 4 ' index of "status" column
Const idColumnIndex = 5 ' index of "id" column
Const startOfPnLColumns = 6 ' PnL first column index

' rows
Const dataStartRowIndex = 10 ' starting row of data
Const dataEndRowIndex = util.maxRowsToFormat ' ending row of data

' ========================================================
' tick-by-tick data columns
' ========================================================
Private Function getPnLColumns() As Variant()

    If (Not Not pnlColumnsArray) <> 0 Then
        ' do not re-initialize array
        GoTo getPnLColumnsEnd
    End If

    pnlColumnsArray = Array("error", "position", "dailyPnL", "unrealizedPnL", "realizedPnL", "value")

getPnLColumnsEnd:
    getPnLColumns = pnlColumnsArray
End Function

' ========================================================
' checks that row has request data for PnL request
' ========================================================
Public Function hasRequestData(cell As range) As Boolean
    Dim ret As Boolean
    ret = False

    If cell.row < dataStartRowIndex Then
        ret = False
        GoTo hasRequestDataEnd
    End If
    
    With Worksheets(STR_SHEET_NAME)
        If .Cells(cell.row, startOfRequestColumns).value <> STR_EMPTY Then
            ret = True
        End If
    End With
    
hasRequestDataEnd:
    hasRequestData = ret
End Function

' ========================================================
' cancel PnL for active row when button is pressed
' ========================================================
Sub cancelPnL()

    Dim server As String, id As String, i As Integer, j As Integer, lastRowIndex As Integer, row As range

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    If Not hasRequestData(ActiveCell) Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        For Each row In Selection.rows
            lastRowIndex = row.row

            If .Cells(row.row, idColumnIndex).value = STR_EMPTY Then GoTo Continue
        
            id = .Cells(row.row, idColumnIndex).value
            .Cells(row.row, idColumnIndex).value = util.STR_EMPTY
        
            clearPnLColumns row
        
            util.sendRequest server, STR_CANCEL_PNL, id
            
Continue:
        Next row
            
        .Cells(lastRowIndex, 1).offset(1, 0).Activate
    End With
End Sub

' ========================================================
' clears PnL cells
' ========================================================
Sub clearPnLColumns(cell As range)
    Dim i As Integer
    ' PnL columns
    pnlColumnsArray = getPnLColumns()
    With Worksheets(STR_SHEET_NAME)
        .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
        .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
        For i = 0 To UBound(pnlColumnsArray) - LBound(pnlColumnsArray)
            .Cells(cell.row, startOfPnLColumns + i).ClearContents
        Next i
    End With
End Sub

' ========================================================
' request PnL for active row when button is pressed
' ========================================================
Sub requestPnL()
    Dim server As String, lastRowIndex As Integer, row As range

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub

    If Not hasRequestData(ActiveCell) Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        For Each row In Selection.rows
            lastRowIndex = row.row
    
            If .Cells(row.row, idColumnIndex).value <> STR_EMPTY Then GoTo Continue
            sendPnLRequest server, row
            .Cells(lastRowIndex, 1).offset(1, 0).Activate
Continue:
        Next row
            
    End With

End Sub

' ========================================================
' request PnL for row
' ========================================================
Sub sendPnLRequest(server As String, cell As range)

    ' get id
    Dim id As String
    id = util.getIDpost(genId, util.ID_REQ_PNL)

    With Worksheets(STR_SHEET_NAME)
        .Cells(cell.row, idColumnIndex).value = id
        
        ' range to poke
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(cell.row, startOfRequestColumns), .Cells(cell.row, startOfRequestColumns + 2))
    
        ' fill status column with formula
        .Cells(cell.row, statusColumnIndex).Formula = util.composeLink(server, STR_PNL_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(cell.row, statusColumnIndex)) Then
            .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If
    
        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_PNL, id, rangeToPoke
    
        ' fill PnL columns with formulas
        Dim i As Integer
        pnlColumnsArray = getPnLColumns()
        For i = 0 To UBound(pnlColumnsArray) - LBound(pnlColumnsArray)
            .Cells(cell.row, startOfPnLColumns + i).Formula = util.composeLink(server, STR_PNL_TICK, id, pnlColumnsArray(i))
        Next i

    End With

End Sub

' ========================================================
' cancel all PnL for all rows (called when workbook is closed)
' ========================================================
Sub cancelAllPnL()
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
                util.sendRequest server, STR_CANCEL_PNL, cell.value
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' re-request all PnL for all rows (called when workbook is opened)
' ========================================================
Sub requestAllPnL()
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
                sendPnLRequest server, cell
            End If
          Next cell
        Next row
    End With
End Sub


