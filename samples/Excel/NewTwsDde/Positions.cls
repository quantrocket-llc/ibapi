VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Positions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' constants
Const STR_SHEET_NAME = "Positions"
Const STR_REQ_POSITIONS = "reqPositions"
Const STR_CANCEL_POSITIONS = "cancelPositions"
Const STR_POSITIONS = "positions"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_SUBSCRIPTION_CONTROL = "M5" ' cell with subscription control

' rows
Const POSITIONS_START_ROW = 10
Const POSITIONS_END_ROW = 200

' columns
Const COLUMN_CONID = 11
Const COLUMN_ACCOUNT = 12

'range
Const POSITIONS_TABLE_RANGE = "A" & POSITIONS_START_ROW & ":N" & POSITIONS_END_ROW

' ========================================================
' Subscribes to positions when button is pressed
' ========================================================
Sub subscribePositions()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        requestPositions
    End If
End Sub

' ========================================================
' Re-subscribes to positions when workbook is opened
' ========================================================
Sub resubscribePositions()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_CANCELLED Then ' re-subscribe only if cancelled
        requestPositions
    End If
End Sub

' ========================================================
' Sends positions request
' ========================================================
Sub requestPositions()
    clearPositionsTable

    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub
    
    With Worksheets(STR_SHEET_NAME)
        .range(CELL_SUBSCRIPTION_CONTROL).Formula = util.composeLink(server, STR_REQ_POSITIONS, util.IDENTIFIER_ZERO, STR_POSITIONS) ' subscription control
        
        util.cleanOnError (.range(CELL_SUBSCRIPTION_CONTROL))
    End With
    
End Sub


' ========================================================
' Clear positions table
' ========================================================
Sub clearPositionsTable()
    ' clear positions table
    Worksheets(STR_SHEET_NAME).range(POSITIONS_TABLE_RANGE).ClearContents
End Sub

' ========================================================
' Cancel positions subscription when button is pressed
' ========================================================
Sub cancelPositionsSubscription()
    cancelPositions (util.STR_EMPTY)
End Sub

' ========================================================
' Cancel positions subscription when workbook is closed
' ========================================================
Sub cancelPositionsSubscriptionOnExit()
    cancelPositions (util.STR_CANCELLED)
End Sub

' ========================================================
' Sends cancel positions request
' ========================================================
Sub cancelPositions(controlValue As String)
    With Worksheets(STR_SHEET_NAME)
        If .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Then
            Dim server As String
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
        
            .range(CELL_SUBSCRIPTION_CONTROL).value = controlValue ' subscription control
            util.sendRequest server, STR_CANCEL_POSITIONS, util.IDENTIFIER_ZERO
        End If
    End With
End Sub

' ========================================================
' Requests positions table/array
' Called when value in CELL_SUBSCRIPTION_CONTROL changes
' ========================================================
Private Sub Worksheet_Calculate()
    With Worksheets(STR_SHEET_NAME)
    
        If CStr(.range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_RECEIVED Then
            Dim server As String, id As String
            Dim positionsArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
    
            ' send request and receive positions table/array
            positionsArray = util.sendRequest(server, STR_REQ_POSITIONS, util.IDENTIFIER_ZERO & util.QMARK & STR_POSITIONS) ' returned array can be 1-Dimension or 2-Dimension
    
            Dim dimension As Integer, i As Integer
            Dim rowNumber As Integer
            Dim conid As String, account As String
            dimension = util.getDimension(positionsArray)
            If dimension = 2 Then
                ' several positions received (2d array)
                For i = 1 To UBound(positionsArray, 1) - LBound(positionsArray, 1) + 1
                    conid = positionsArray(i, COLUMN_CONID)
                    account = positionsArray(i, COLUMN_ACCOUNT)
                    rowNumber = findPositionRow(conid, account)
                    For j = 1 To UBound(positionsArray, 2) - LBound(positionsArray, 2) + 1
                        If positionsArray(i, j) <> util.STR_EMPTY Then
                            .Cells(rowNumber, j).value = positionsArray(i, j)
                        End If
                    Next j
                Next i
            ElseIf dimension = 1 Then
                ' single position received (1d array)
                conid = positionsArray(COLUMN_CONID)
                account = positionsArray(COLUMN_ACCOUNT)
                rowNumber = findPositionRow(conid, account)
                For i = 1 To UBound(positionsArray) - LBound(positionsArray) + 1
                    If positionsArray(i) <> util.STR_EMPTY Then
                        .Cells(rowNumber, i).value = positionsArray(i)
                    End If
                Next i
            End If
    
        End If
    End With
End Sub

Private Function findPositionRow(conid As String, account As String) As Integer
    Dim row As Integer, i As Integer
    Dim arr1 As Variant, arr2 As Variant
    With Worksheets(STR_SHEET_NAME)
        arr1 = .range(.Cells(POSITIONS_START_ROW, COLUMN_CONID), .Cells(POSITIONS_END_ROW, COLUMN_CONID)).value
        arr2 = .range(.Cells(POSITIONS_START_ROW, COLUMN_ACCOUNT), .Cells(POSITIONS_END_ROW, COLUMN_ACCOUNT)).value
        
        For i = 1 To POSITIONS_END_ROW - POSITIONS_START_ROW + 1
            If CStr(arr1(i, 1)) = util.STR_EMPTY And CStr(arr2(i, 1)) = util.STR_EMPTY Or _
                CStr(arr1(i, 1)) = conid And CStr(arr2(i, 1)) = account Then
                row = i + POSITIONS_START_ROW - 1
                GoTo FindPositionEnd
            End If
        Next i
    End With

FindPositionEnd:
    findPositionRow = row
End Function
