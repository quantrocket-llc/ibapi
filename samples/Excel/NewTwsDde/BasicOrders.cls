VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BasicOrders"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

' constants
Const STR_SHEET_NAME = "BasicOrders"
Const STR_PLACEORDER = "placeOrder"
Const STR_CLEARORDER = "clearOrder"
Const STR_CANCELORDER = "cancelOrder"
Const STR_ORDERSTATUS = "orderStatus"
Const STR_GLOBAL_CANCEL = "globalCancel"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name

' columns
Const startOfContractColumns = 1 ' contract first column index (symbol)
Const orderBaseColumnsStart = 17 ' index of first column in Order Description
Const orderBaseColumnsEnd = 21 ' index of last column in Order Description
Const errorColumnIndex = 22 ' index of error column
Const idColumnIndex = 23 ' index of id column
Const orderExtColumnsStart = 34 ' index of first column in Extended Order Attributes
Const orderExtColumnsEnd = 146 ' index of last column in Extended Order Attributes

' rows
Const dataStartRowIndex = 10 ' starting row of data

' variables
Dim orderStatusColumnsArray() As Variant
Dim contractColumnsArray() As Variant

' ========================================================
' contract columns
' ========================================================
Private Function getContractColumns() As Variant()

    If (Not Not contractColumnsArray) <> 0 Then
        ' do not re-initialize array
        GoTo getContractColumnsEnd
    End If

    contractColumnsArray = Array("SYMBOL", "SECTYPE", "LASTTRADEDATE", "STRIKE", "RIGHT", "MULTIPLIER", "TRADINGCLASS", "EXCH", "PRIMEXCH", "CURRENCY", "LOCALSYMBOL", "CONID", _
        "COMBOLEGS", "DELTANEUTRAL", "SECIDTYPE", "SECID")
    
getContractColumnsEnd:
    getContractColumns = contractColumnsArray
End Function

' ========================================================
' order status columns
' ========================================================
Private Function getOrderStatusColumns() As Variant()
    Dim size As Integer

    If (Not Not orderStatusColumnsArray) <> 0 Then
        ' do not re-initialize array
        GoTo getOrderStatusColumnsEnd
    End If
    
    orderStatusColumnsArray = Array("status", "filled", "remaining", "price", "lastFillPrice", "whyHeld", "mktCapPrice", "parentId", "clientId", "permId")

getOrderStatusColumnsEnd:
    getOrderStatusColumns = orderStatusColumnsArray
End Function

' ========================================================
' copies extended order attributes to basic orders page
' ========================================================
Sub applyTemplate()
    Call OrderFunctions.applyTemplate(Selection.rows, orderExtColumnsStart)
End Sub

' ========================================================
' clear order for active row
' ========================================================
Sub clearOrder()
    Dim server As String, id As String, i As Integer, row As range, lastRowIndex As Integer
    
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        For Each row In Selection.rows
            lastRowIndex = row.row
            If .Cells(row.row, idColumnIndex).value = STR_EMPTY Then GoTo Continue
            If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, row, startOfContractColumns, getContractColumns()) Then GoTo Continue
            
            id = .Cells(row.row, idColumnIndex).value
            
            clearOrderStatusColumns row
            
            util.sendRequest server, STR_CLEARORDER, id
            
Continue:
        Next row
    
        .Cells(lastRowIndex, 1).offset(1, 0).Activate
    End With
End Sub

' ========================================================
' clears tick-by-tick data cells
' ========================================================
Sub clearOrderStatusColumns(cell As range)
    Dim i As Integer
    With Worksheets(STR_SHEET_NAME)
        .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
        .Cells(cell.row, errorColumnIndex).value = util.STR_EMPTY
        
        ' order status columns
        orderStatusColumnsArray = getOrderStatusColumns()
        For i = 0 To UBound(orderStatusColumnsArray) - LBound(orderStatusColumnsArray)
            .Cells(cell.row, idColumnIndex + 1 + i).ClearContents
        Next i
    End With
End Sub

' ========================================================
' global cancel
' ========================================================
Sub globalCancel()
    Dim server As String
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub
    util.sendRequest server, STR_GLOBAL_CANCEL, util.IDENTIFIER_ZERO
End Sub

' ========================================================
' cancel order for active row
' ========================================================
Sub cancelOrder()
    Dim server As String, id As String, i As Integer, row As range, lastRowIndex As Integer
    
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        For Each row In Selection.rows
            lastRowIndex = row.row
            If .Cells(row.row, idColumnIndex).value = STR_EMPTY Then GoTo Continue
            If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, row, startOfContractColumns, getContractColumns()) Then GoTo Continue
            
            id = .Cells(row.row, idColumnIndex).value
            util.sendRequest server, STR_CANCELORDER, id
            
Continue:
        Next row
        
        .Cells(lastRowIndex, 1).offset(1, 0).Activate
        
    End With
    
End Sub
' ========================================================
' place order for active row
' ========================================================
Sub placeOrder()
    Dim row As range, server As String, lastRowIndex As Integer
    
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    For Each row In Selection.rows
        lastRowIndex = row.row
        If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, row, startOfContractColumns, getContractColumns()) Then GoTo Continue
        sendPlaceOrder server, row
        
Continue:
    Next row
    
    Worksheets(STR_SHEET_NAME).Cells(lastRowIndex, 1).offset(1, 0).Activate

End Sub

' ========================================================
' sends place order for row
' ========================================================
Sub sendPlaceOrder(server As String, cell As range)

    ' get id
    Dim id As String
    With Worksheets(STR_SHEET_NAME)
        id = .Cells(cell.row, errorColumnIndex + 1).value
        If id = util.STR_EMPTY Then ' none exists yet -- is original placement as opposed to modify
            id = OrderFunctions.makeId()
            ' fill "id" column with id
            .Cells(cell.row, errorColumnIndex + 1).value = id
        End If
        
        ' fill "error" column with formula
        .Cells(cell.row, errorColumnIndex).Formula = util.composeLink(server, STR_ORDERSTATUS, id, util.STR_ERROR)
        If util.cleanOnError(.Cells(cell.row, errorColumnIndex)) Then
            clearOrderStatusColumns cell
            Exit Sub
        End If
        
        ' send request
        util.sendPoke Worksheets(STR_SHEET_NAME), server, STR_PLACEORDER, id, cell, startOfContractColumns, getContractColumns(), 0, idColumnIndex, orderBaseColumnsStart, orderBaseColumnsEnd, orderExtColumnsStart, orderExtColumnsEnd
        
    
        ' fill order status columns with formulas
        Dim i As Integer
        orderStatusColumnsArray = getOrderStatusColumns()
        For i = 0 To UBound(orderStatusColumnsArray) - LBound(orderStatusColumnsArray)
            .Cells(cell.row, idColumnIndex + 1 + i).Formula = util.composeLink(server, STR_ORDERSTATUS, id, orderStatusColumnsArray(i))
        Next i
    End With

End Sub

