VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "MarketDepth"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long

Dim contractColumnsArray() As Variant

' constants
Const STR_SHEET_NAME = "MarketDepth"
Const STR_MKT_DEPTH_TICK = "mktDepthTick"
Const STR_REQMKTDEPTH = "reqMktDepth"
Const STR_CANCELMKTDEPTH = "cancelMktDepth"
Const STR_REQ_MKT_DEPTH_EXCHANGES = "reqMktDepthExchanges"
Const STR_ID = "id"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_MKT_DEPTH_EXCHANGES_CONTROL = "AA5"  ' cell with market depth exchanges control

' columns
Const startOfContractColumns = 1 ' contract first column index (symbol)
Const isSmartDepthColumnIndex = 13 ' index of smart depth column
Const statusColumnIndex = 14 ' index of "status" column
Const idColumnIndex = 15 ' index of "id" column
Const errorColumnIndex = 16 ' index of "error" column
Const startOfMarketDepthBidColumns = 17 ' market depth bid first column index
Const startOfMarketDepthAskColumns = 21 ' market depth ask first column index
Const startOfMarketDepthExchangesColumns = 25 ' market depth exchanges start column index

' num of rows
Const numOfRows = 15

' rows
Const dataStartRowIndex = 10 ' starting row of data
Const dataEndRowIndex = 500 ' ending row of data

' range
Const MKT_DEPTH_EXCHANGES_TABLE_RANGE = "Y" & dataStartRowIndex & ":AC" & dataEndRowIndex

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
' request market depth exchanges
' ========================================================
Sub requestMktDepthExchanges()

    clearMktDepthExchanges

    Dim server As String
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        .range(CELL_MKT_DEPTH_EXCHANGES_CONTROL).Formula = util.composeLink(server, STR_REQ_MKT_DEPTH_EXCHANGES, util.IDENTIFIER_ZERO, util.STR_EMPTY) ' subscription control
        If util.cleanOnError(.range(CELL_MKT_DEPTH_EXCHANGES_CONTROL)) Then
            .range(CELL_MKT_DEPTH_EXCHANGES_CONTROL).value = util.STR_EMPTY
            Exit Sub
        End If
    End With
 
End Sub

' ========================================================
' cancel market depth exchanges
' ========================================================
Sub cancelMktDepthExchanges()
    Worksheets(STR_SHEET_NAME).range(CELL_MKT_DEPTH_EXCHANGES_CONTROL).Formula = util.STR_EMPTY
    clearMktDepthExchanges
End Sub

' ========================================================
' clear market depth exchanges
' ========================================================
Sub clearMktDepthExchanges()
    Worksheets(STR_SHEET_NAME).range(MKT_DEPTH_EXCHANGES_TABLE_RANGE).ClearContents
End Sub

' ========================================================
' cancel market depth for active row when button is pressed
' ========================================================
Sub cancelMarketDepth()
    Dim server As String, id As String, i As Integer, isSmartDepth As String, row As range

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        For Each row In Selection.rows
         
            If .Cells(row.row, idColumnIndex).value = STR_EMPTY Then GoTo Continue
            If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, row, startOfContractColumns, getContractColumns()) Then GoTo Continue
        
            id = .Cells(row.row, idColumnIndex).value
            .Cells(row.row, idColumnIndex).value = util.STR_EMPTY
            isSmartDepth = .Cells(row.row, isSmartDepthColumnIndex).value
        
            ' status column
            .Cells(row.row, statusColumnIndex).ClearContents
            .Cells(row.row, errorColumnIndex).ClearContents
        
            util.sendRequest server, STR_CANCELMKTDEPTH, id & util.QMARK & isSmartDepth
            
            clearMarketDepthColumns numOfRows, row
Continue:
        Next row

    End With
End Sub

Sub clearMarketDepthColumns(numOfRows As Integer, cell As range)
    Dim i As Integer
    
    With Worksheets(STR_SHEET_NAME)
        .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
        .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
        .Cells(cell.row, errorColumnIndex).value = util.STR_EMPTY
    
    ' clear market depth columns
        For i = 0 To numOfRows - 1
            .Cells(cell.row + i, startOfMarketDepthBidColumns).ClearContents
            .Cells(cell.row + i, startOfMarketDepthBidColumns + 1).ClearContents
            .Cells(cell.row + i, startOfMarketDepthBidColumns + 2).ClearContents
            .Cells(cell.row + i, startOfMarketDepthAskColumns).ClearContents
            .Cells(cell.row + i, startOfMarketDepthAskColumns + 1).ClearContents
            .Cells(cell.row + i, startOfMarketDepthAskColumns + 2).ClearContents
        Next i
    End With
End Sub

' ========================================================
' request market depth for active row when button is pressed
' ========================================================
Sub requestMarketDepth()
    Dim row As range, server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub
     
    For Each row In Selection.rows
     
        If Worksheets(STR_SHEET_NAME).Cells(row.row, idColumnIndex).value <> STR_EMPTY Then GoTo Continue
        If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, row, startOfContractColumns, getContractColumns()) Then GoTo Continue
        
        sendMarketDepthRequest server, row
Continue:
    Next row

End Sub

' ========================================================
' request market depth for row
' ========================================================
Sub sendMarketDepthRequest(server As String, cell As range)

    ' get id
    Dim id As String, isSmartDepth As String
    id = util.getIDpost(genId, util.ID_REQ_MARKET_DEPTH)
    
    With Worksheets(STR_SHEET_NAME)
        .Cells(cell.row, idColumnIndex).value = id
    
        isSmartDepth = .Cells(cell.row, isSmartDepthColumnIndex).value
    
        ' fill status column with formula
        .Cells(cell.row, statusColumnIndex).Formula = util.composeLink(server, STR_MKT_DEPTH_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(cell.row, statusColumnIndex)) Then
            clearMarketDepthColumns numOfRows, cell
            Exit Sub
        End If
    
        ' send request
        util.sendPoke Worksheets(STR_SHEET_NAME), server, STR_REQMKTDEPTH, id & util.QMARK & isSmartDepth, cell, startOfContractColumns, getContractColumns(), 0, idColumnIndex, 0, 0, 0, 0
    
        ' fill error column with formula
        .Cells(cell.row, errorColumnIndex).Formula = util.composeLink(server, STR_MKT_DEPTH_TICK, id, util.STR_ERROR)
    
        ' fill market depth columns with formulas
        Dim i As Integer
        For i = 0 To numOfRows - 1
            .Cells(cell.row + i, startOfMarketDepthBidColumns).Formula = util.composeLink(server, STR_MKT_DEPTH_TICK, id, i & util.UNDERSCORE & "BID" & UNDERSCORE & "mktMaker")
            .Cells(cell.row + i, startOfMarketDepthBidColumns + 1).Formula = util.composeLink(server, STR_MKT_DEPTH_TICK, id, i & util.UNDERSCORE & "BID" & UNDERSCORE & "price")
            .Cells(cell.row + i, startOfMarketDepthBidColumns + 2).Formula = util.composeLink(server, STR_MKT_DEPTH_TICK, id, i & util.UNDERSCORE & "BID" & UNDERSCORE & "size")
            .Cells(cell.row + i, startOfMarketDepthAskColumns).Formula = util.composeLink(server, STR_MKT_DEPTH_TICK, id, i & util.UNDERSCORE & "ASK" & UNDERSCORE & "mktMaker")
            .Cells(cell.row + i, startOfMarketDepthAskColumns + 1).Formula = util.composeLink(server, STR_MKT_DEPTH_TICK, id, i & util.UNDERSCORE & "ASK" & UNDERSCORE & "price")
            .Cells(cell.row + i, startOfMarketDepthAskColumns + 2).Formula = util.composeLink(server, STR_MKT_DEPTH_TICK, id, i & util.UNDERSCORE & "ASK" & UNDERSCORE & "size")
        Next i
    End With

End Sub

' ========================================================
' cancel all market depth for all rows (called when workbook is closed)
' ========================================================
Sub cancelAllMktDepth()
    Dim rng As range, row As range, cell As range
    Dim server As String
    Dim isSmartDepth As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        Set rng = .range(.Cells(dataStartRowIndex, idColumnIndex), .Cells(dataEndRowIndex, idColumnIndex))
        For Each row In rng.rows
            For Each cell In row.Cells
            If InStr(cell.value, STR_ID) <> 0 Then
                isSmartDepth = .Cells(row.row, isSmartDepthColumnIndex).value
                util.sendRequest server, STR_CANCELMKTDEPTH, cell.value & util.QMARK & isSmartDepth
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' re-request all market depth for all rows (called when workbook is opened)
' ========================================================
Sub requestAllMktDepth()
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
                sendMarketDepthRequest server, cell
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' Requests market depth exchanges table/array
' Called when value in CELL_STATUS changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String
    Dim i As Integer, j As Integer
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
    
        If CStr(.range(CELL_MKT_DEPTH_EXCHANGES_CONTROL)) = util.STR_RECEIVED Then
            Dim mktDepthExchangesArray() As Variant, dimension As Integer
            mktDepthExchangesArray = util.sendRequest(server, STR_REQ_MKT_DEPTH_EXCHANGES, util.IDENTIFIER_ZERO) ' returned array can be 1-Dimension or 2-Dimension
                
            dimension = util.getDimension(mktDepthExchangesArray)
            If dimension = 2 Then
                ' several mkt depth exchanges received (2d array)
                For i = 1 To UBound(mktDepthExchangesArray, 1) - LBound(mktDepthExchangesArray, 1) + 1
                    For j = 1 To UBound(mktDepthExchangesArray, 2) - LBound(mktDepthExchangesArray, 2) + 1
                        If CStr(mktDepthExchangesArray(i, j)) <> util.STR_EMPTY Then
                            .Cells(dataStartRowIndex + i - 1, startOfMarketDepthExchangesColumns + j - 1).value = CStr(mktDepthExchangesArray(i, j))
                        End If
                    Next j
                Next i
            ElseIf dimension = 1 Then
                For j = 1 To UBound(mktDepthExchangesArray, 1) - LBound(mktDepthExchangesArray, 1) + 1
                    If CStr(mktDepthExchangesArray(j)) <> util.STR_EMPTY Then
                        .Cells(dataStartRowIndex, startOfMarketDepthExchangesColumns + j - 1).value = mktDepthExchangesArray(j)
                    End If
                Next j
            End If
        End If
    

    End With
End Sub
           

