VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "OpenOrders"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' constants
Const STR_SHEET_NAME = "OpenOrders"
Const STR_REQ_OPEN_ORDERS = "reqOpenOrders"
Const STR_CANCEL_OPEN_ORDERS = "cancelOpenOrders"
Const STR_REQ_ALL_OPEN_ORDERS = "reqAllOpenOrders"
Const STR_REQ_AUTO_OPEN_ORDERS = "reqAutoOpenOrders"
Const STR_OPEN_ORDERS = "openOrders"
Const STR_CANCELLED = "Cancelled"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_SUBSCRIPTION_CONTROL = "G5" ' cell with subscription control

'rows
Const OPEN_ORDERS_START_ROW = 10
Const OPEN_ORDERS_END_ROW = 200

' columns
Const COLUMN_ORDER_ACTION = 15
Const COLUMN_ORDER_STATUS = 21
Const COLUMN_PERM_ID = 30

'range
Const OPEN_ORDERS_TABLE_RANGE = "A" & OPEN_ORDERS_START_ROW & ":DZ" & OPEN_ORDERS_END_ROW


' ========================================================
' Subscribes to open orders when button is pressed
' ========================================================
Sub subscribeOpenOrders()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        requestOpenOrders
    End If
End Sub

' ========================================================
' Re-subscribes to open orders when workbook is opened
' ========================================================
Sub resubscribeOpenOrders()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_CANCELLED Then ' re-subscribe only if cancelled
        requestOpenOrders
    End If
End Sub

' ========================================================
' Sends open orders request
' ========================================================
Sub requestOpenOrders()
    clearOpenOrdersTable
    
    Dim server As String
    
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub
    Dim request As String
    If cbAllOpenOrders.value = True Then
        request = STR_REQ_ALL_OPEN_ORDERS
    Else
        request = STR_REQ_OPEN_ORDERS
    End If
    
    With Worksheets(STR_SHEET_NAME)
        .range(CELL_SUBSCRIPTION_CONTROL).Formula = util.composeLink(server, request, util.IDENTIFIER_ZERO, STR_OPEN_ORDERS) ' subscription control
            
        If util.cleanOnError(.range(CELL_SUBSCRIPTION_CONTROL)) Then
            .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_EMPTY
            Exit Sub
        End If
    End With

End Sub

' ========================================================
' Clear open order table
' ========================================================
Sub clearOpenOrdersTable()
    ' clear open orders table
    Worksheets(STR_SHEET_NAME).range(OPEN_ORDERS_TABLE_RANGE).ClearContents
End Sub

' ========================================================
' Auto open orders
' ========================================================
Sub autoOpenOrders()
    Dim server As String
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub
    
    util.sendRequest server, STR_REQ_AUTO_OPEN_ORDERS, util.IDENTIFIER_ZERO & util.QMARK & "true"
End Sub

' ========================================================
' Cancel auto open orders
' ========================================================
Sub cancelAutoOpenOrders()
    Dim server As String
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub
    
    util.sendRequest server, STR_REQ_AUTO_OPEN_ORDERS, util.IDENTIFIER_ZERO & util.QMARK & "false"
End Sub

' ========================================================
' Cancel open orders subscription when button is pressed
' ========================================================
Sub cancelOpenOrdersSubscription()
    cancelOpenOrders (util.STR_EMPTY)
End Sub

' ========================================================
' Cancel open orders subscription when workbook is closed
' ========================================================
Sub cancelOpenOrdersSubscriptionOnExit()
    cancelOpenOrders (util.STR_CANCELLED)
End Sub

' ========================================================
' Cancel open orders subscription
' ========================================================
Sub cancelOpenOrders(controlValue As String)
    With Worksheets(STR_SHEET_NAME)
        If .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Then
            Dim server As String
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            
            .range(CELL_SUBSCRIPTION_CONTROL).Formula = controlValue ' subscription control
            util.sendRequest server, STR_CANCEL_OPEN_ORDERS, util.IDENTIFIER_ZERO
        End If
    End With
End Sub

' ========================================================
' Requests open orders table/array
' Called when value in CELL_SUBSCRIPTION_CONTROL changes
' ========================================================
Private Sub Worksheet_Calculate()
    'On Error Resume Next
    With Worksheets(STR_SHEET_NAME)
        If CStr(.range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_RECEIVED Then
            Dim server As String, id As String
            Dim openOrdersArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
    
            Dim request As String
            If cbAllOpenOrders.value = True Then
                request = STR_REQ_ALL_OPEN_ORDERS
            Else
                request = STR_REQ_OPEN_ORDERS
            End If
            ' send request and receive open orders table/array
            openOrdersArray = util.sendRequest(server, request, util.IDENTIFIER_ZERO & util.QMARK) ' returned array can be 1-Dimension or 2-Dimension
    
            Dim dimension As Integer, i As Integer
            Dim rowNumber As Integer
            Dim permId As String
            dimension = util.getDimension(openOrdersArray)
            If dimension = 2 Then
                ' several open orders received (2d array)
                For i = 1 To UBound(openOrdersArray, 1) - LBound(openOrdersArray, 1) + 1
                    permId = openOrdersArray(i, COLUMN_PERM_ID)
                    rowNumber = findOpenOrderRow(permId)
                    If .Cells(rowNumber, COLUMN_ORDER_ACTION).value <> STR_EMPTY Or openOrdersArray(i, COLUMN_ORDER_STATUS) <> STR_CANCELLED Then
                        For j = 1 To UBound(openOrdersArray, 2) - LBound(openOrdersArray, 2) + 1
                            If openOrdersArray(i, j) <> util.STR_EMPTY Then
                                .Cells(rowNumber, j).value = openOrdersArray(i, j)
                            End If
                        Next j
                    End If
                Next i
            ElseIf dimension = 1 Then
                ' single open order received (1d array)
                permId = openOrdersArray(COLUMN_PERM_ID)
                rowNumber = findOpenOrderRow(permId)
                If .Cells(rowNumber, COLUMN_ORDER_ACTION).value <> STR_EMPTY Or openOrdersArray(COLUMN_ORDER_STATUS) <> STR_CANCELLED Then
                    For i = 1 To UBound(openOrdersArray) - LBound(openOrdersArray) + 1
                        If openOrdersArray(i) <> util.STR_EMPTY Then
                            .Cells(rowNumber, i).value = openOrdersArray(i)
                        End If
                    Next i
                End If
            End If
    
        End If
    End With
End Sub

Private Function findOpenOrderRow(permId As String) As Integer
    Dim row As Integer, i As Integer
    Dim arr1 As Variant
    With Worksheets(STR_SHEET_NAME)
        arr1 = .range(.Cells(OPEN_ORDERS_START_ROW, COLUMN_PERM_ID), .Cells(OPEN_ORDERS_END_ROW, COLUMN_PERM_ID)).value
        
        For i = 1 To OPEN_ORDERS_END_ROW - OPEN_ORDERS_START_ROW + 1
            If CStr(arr1(i, 1)) = util.STR_EMPTY Or CStr(arr1(i, 1)) = permId Then
                row = i + OPEN_ORDERS_START_ROW - 1
                GoTo FindOpenOrderEnd
            End If
        Next i
    End With

FindOpenOrderEnd:
    findOpenOrderRow = row
End Function

