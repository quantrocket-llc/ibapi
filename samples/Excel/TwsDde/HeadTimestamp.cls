VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "HeadTimestamp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long
Dim contractColumnsArray() As Variant

' constants
Const STR_SHEET_NAME = "HeadTimestamp"
Const STR_REQ_HEAD_TIMESTAMP = "reqHeadTimestamp"
Const STR_CANCEL_HEAD_TIMESTAMP = "cancelHeadTimestamp"
Const STR_HEAD_TIMESTAMP_TICK = "headTimestampTick"
Const STR_HEAD_TIMESTAMP = "headTimestamp"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name

' columns
Const startOfContractColumns = 1 ' contract first column index (symbol)
Const includeExpiredColumnIndex = 14 ' index of "include expired" column
Const idColumnIndex = 18 ' index of "head timestamp id" column
Const statusColumnIndex = 19 ' index of "head timestamp status" column
Const errorColumnIndex = 20 ' index of "head timestamp error" column
Const headTimestampColumnIndex = 21 ' index of "head timestamp" column

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
' cancels head timestamp when button is pressed
' ========================================================
Sub cancelHeadTimestamp()
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
        ' head timestamp column
        .Cells(ActiveCell.row, headTimestampColumnIndex).ClearContents
    
        util.sendRequest server, STR_CANCEL_HEAD_TIMESTAMP, id
    
        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request head timestamp
' ========================================================
Sub requestHeadTimestamp()
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub
    
    With Worksheets(STR_SHEET_NAME)
        
        If .Cells(ActiveCell.row, idColumnIndex).value <> STR_EMPTY Then Exit Sub
        If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, ActiveCell, startOfContractColumns, getContractColumns()) Then Exit Sub

        ' get id
        Dim id As String
        id = util.getIDpost(genId, util.ID_REQ_HEAD_TIMESTAMP)
        .Cells(ActiveCell.row, idColumnIndex).value = id
    
        ' range to poke
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(ActiveCell.row, startOfContractColumns), .Cells(ActiveCell.row, idColumnIndex - 1))
    
        ' fill status column with formula
        .Cells(ActiveCell.row, statusColumnIndex).Formula = util.composeLink(server, STR_HEAD_TIMESTAMP_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(ActiveCell.row, statusColumnIndex)) Then
            .Cells(ActiveCell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(ActiveCell.row, statusColumnIndex).value = util.STR_EMPTY
            .Cells(ActiveCell.row, errorColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If
    
        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_HEAD_TIMESTAMP, id, rangeToPoke
    
        ' fill error column with formula
        .Cells(ActiveCell.row, errorColumnIndex).Formula = util.composeLink(server, STR_HEAD_TIMESTAMP_TICK, id, util.STR_ERROR)
        ' fill result column with formula
        .Cells(ActiveCell.row, headTimestampColumnIndex).Formula = util.composeLink(server, STR_HEAD_TIMESTAMP_TICK, id, STR_HEAD_TIMESTAMP)
        
        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With
End Sub

