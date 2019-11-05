VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CompletedOrders"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' constants
Const STR_SHEET_NAME = "CompletedOrders"
Const STR_REQ_COMPLETED_ORDERS = "reqCompletedOrders"
Const STR_COMPLETED_ORDERS = "completedOrder"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_REQUEST_CONTROL = "G5" ' cell with subscription control

'rows
Const COMPLETED_ORDERS_START_ROW = 10
Const COMPLETED_ORDERS_END_ROW = 200

'range
Const COMPLETED_ORDERS_TABLE_RANGE = "A" & COMPLETED_ORDERS_START_ROW & ":DF" & COMPLETED_ORDERS_END_ROW


' ========================================================
' Request completed orders when button is pressed
' ========================================================
Sub requestCompletedOrders()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_REQUEST_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        sendCompletedOrdersRequest True
    End If
End Sub

' ========================================================
' Request all completed orders when button is pressed
' ========================================================
Sub requestAllCompletedOrders()

    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_REQUEST_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        sendCompletedOrdersRequest False
    End If
End Sub


' ========================================================
' Sends completed orders request
' ========================================================
Sub sendCompletedOrdersRequest(apiOnly As Boolean)
    clearCompletedOrdersTable

    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub
    
    With Worksheets(STR_SHEET_NAME)
        .range(CELL_REQUEST_CONTROL).Formula = util.composeLink(server, STR_REQ_COMPLETED_ORDERS, util.IDENTIFIER_ZERO, apiOnly) ' request control

        If util.cleanOnError(.range(CELL_REQUEST_CONTROL)) Then
            .range(CELL_REQUEST_CONTROL).value = util.STR_EMPTY
            Exit Sub
        End If
    End With

End Sub

' ========================================================
' Clear completed orders table
' ========================================================
Sub clearCompletedOrdersTable()
    ' clear completed orders table
    With Worksheets(STR_SHEET_NAME)
        .range(COMPLETED_ORDERS_TABLE_RANGE).ClearContents
        .range(CELL_REQUEST_CONTROL).Formula = ""
    End With
End Sub

' ========================================================
' Requests completed orders table/array
' Called when value in CELL_SUBSCRIPTION_CONTROL changes
' ========================================================
Private Sub Worksheet_Calculate()
    'On Error Resume Next
    With Worksheets(STR_SHEET_NAME)
       If CStr(.range(CELL_REQUEST_CONTROL).value) = util.STR_RECEIVED Then
            Dim server As String, id As String
            Dim completedOrdersArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub

            ' send request and receive completed orders table/array
            completedOrdersArray = util.sendRequest(server, STR_REQ_COMPLETED_ORDERS, util.IDENTIFIER_ZERO & util.QMARK) ' returned array can be 1-Dimension or 2-Dimension

            Dim dimension As Integer, i As Integer
            Dim rowNumber As Integer
            Dim permId As String
            dimension = util.getDimension(completedOrdersArray)
            If dimension = 2 Then
                ' several completed orders received (2d array)
                For i = 1 To UBound(completedOrdersArray, 1) - LBound(completedOrdersArray, 1) + 1
                    For j = 1 To UBound(completedOrdersArray, 2) - LBound(completedOrdersArray, 2) + 1
                        If completedOrdersArray(i, j) <> util.STR_EMPTY Then
                            .Cells(COMPLETED_ORDERS_START_ROW - 1 + i, j).value = completedOrdersArray(i, j)
                        End If
                    Next j
                Next i
            ElseIf dimension = 1 Then
                ' single completed order received (1d array)
                For i = 1 To UBound(completedOrdersArray) - LBound(completedOrdersArray) + 1
                    If completedOrdersArray(i) <> util.STR_EMPTY Then
                        .Cells(COMPLETED_ORDERS_START_ROW, i).value = completedOrdersArray(i)
                    End If
                Next i
            End If

        End If
    End With
End Sub


