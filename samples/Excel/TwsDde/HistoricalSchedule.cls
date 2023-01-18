VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "HistoricalSchedule"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long
Dim contractColumnsArray() As Variant

' constants
Const STR_SHEET_NAME = "HistoricalSchedule"
Const STR_REQ_HISTORICAL_SCHEDULE = "reqHistoricalSchedule"
Const STR_CANCEL_HISTORICAL_SCHEDULE = "cancelHistoricalSchedule"
Const STR_HISTORICAL_SCHEDULE_TICK = "historicalScheduleTick"
Const STR_HISTORICAL_SCHEDULE = "historicalSchedule"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name

' columns
Const startOfContractColumns = 1 ' contract first column index (symbol)
Const includeExpiredColumnIndex = 13 ' index of "include expired" column
Const idColumnIndex = 18 ' index of "historical schedule id" column
Const statusColumnIndex = 19 ' index of "historical schedule status" column
Const errorColumnIndex = 20 ' index of "historical schedule error" column
Const historicalScheduleColumnIndex = 21 ' index of "historical schedule" column

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
' cancels historical schedule when button is pressed
' ========================================================
Sub cancelHistoricalSchedule()
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
        ' historical schedule column
        .Cells(ActiveCell.row, historicalScheduleColumnIndex).ClearContents
    
        util.sendRequest server, STR_CANCEL_HISTORICAL_SCHEDULE, id
    
        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request historical schedule
' ========================================================
Sub requestHistoricalSchedule()
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub
    
    With Worksheets(STR_SHEET_NAME)
        
        If .Cells(ActiveCell.row, idColumnIndex).value <> STR_EMPTY Then Exit Sub
        If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, ActiveCell, startOfContractColumns, getContractColumns()) Then Exit Sub

        ' get id
        Dim id As String
        id = util.getIDpost(genId, util.ID_REQ_HISTORICAL_SCHEDULE)
        .Cells(ActiveCell.row, idColumnIndex).value = id
    
        ' range to poke
        Dim rangeToPoke As Range
        Set rangeToPoke = .Range(.Cells(ActiveCell.row, startOfContractColumns), .Cells(ActiveCell.row, idColumnIndex - 1))
    
        ' fill status column with formula
        .Cells(ActiveCell.row, statusColumnIndex).Formula = util.composeLink(server, STR_HISTORICAL_SCHEDULE_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(ActiveCell.row, statusColumnIndex)) Then
            .Cells(ActiveCell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(ActiveCell.row, statusColumnIndex).value = util.STR_EMPTY
            .Cells(ActiveCell.row, errorColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If
    
        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_HISTORICAL_SCHEDULE, id, rangeToPoke
    
        ' fill error column with formula
        .Cells(ActiveCell.row, errorColumnIndex).Formula = util.composeLink(server, STR_HISTORICAL_SCHEDULE_TICK, id, util.STR_ERROR)
        ' fill result column with formula
        .Cells(ActiveCell.row, historicalScheduleColumnIndex).Formula = util.composeLink(server, STR_HISTORICAL_SCHEDULE_TICK, id, STR_HISTORICAL_SCHEDULE)
        
        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With
End Sub
