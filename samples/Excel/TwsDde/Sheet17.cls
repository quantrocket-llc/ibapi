VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet17"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim lastRow As Long
Dim orderId As Integer

Const serverCell = "orderServer"
Const OPEN_ACTION = "open"
Const topic = "ord"
Const START_INDICATOR = "Open Orders"
Const errorRange = "orderErrorPosition"
Const orderStatuses = "advancedOrdersCells"
Const openOrdContracts = "openOrdContracts"
Const openOrdOrders = "openOrdOrders"
Const openOrdStatuses = "openOrdStatuses"
Const descOffset = 12
Const statusOffset = 17
Const extAttribColumn = 26
Const firstContractCell = "A"
Const lastContractCell = "L"
Const firstStatusCell = "R"
Const lastStatusCell = "Y"

Sub placeOrder()
Attribute placeOrder.VB_ProcData.VB_Invoke_Func = "P\n14"
    Call OrderFunctions.order2(Selection.rows, serverCell, extAttribColumn, True)
End Sub

Sub cancelOrder()
    Call OrderFunctions.cancelOrder(Selection.rows, serverCell)
End Sub

Sub applyTemplate()
    Call OrderFunctions.applyTemplate(Selection.rows, extAttribColumn)
End Sub

Public Sub reqOpenOrder()
    Dim server As String, pos As String, addr As String, id As String, descRangeName As String, _
        descEndName As String, statusRangeName As String, statusEndName As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    Dim row As Integer
    row = CStr(util.getNextAvailableRow(lastRow, START_INDICATOR))
    descRangeName = firstContractCell & row
    descEndName = lastContractCell & row
    statusRangeName = firstStatusCell & row
    statusEndName = lastStatusCell & row
    Dim theRange As Excel.Range
    Set theRange = Range(descRangeName)
    Range(descRangeName & ":" & descEndName).Select
    With Selection.Interior
        .colorIndex = util.lavendarColorIndex
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
    End With
   
    Range(statusRangeName & ":" & statusEndName).Select
    With Selection.Interior
        .colorIndex = util.lavendarColorIndex
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
    End With
   
    id = util.getIDpre(orderId)
    theRange.offset(0, 0).value = util.composeLink(server, topic, id, "symbol")
    theRange.offset(0, 1).value = util.composeLink(server, topic, id, "secType")
    theRange.offset(0, 2).value = util.composeLink(server, topic, id, "expiry")
    theRange.offset(0, 3).value = util.composeLink(server, topic, id, "strike")
    theRange.offset(0, 4).value = util.composeLink(server, topic, id, "right")
    theRange.offset(0, 5).value = util.composeLink(server, topic, id, "exchange")
    theRange.offset(0, 6).value = util.composeLink(server, topic, id, "currency")
    theRange.offset(0, descOffset).value = util.composeLink(server, topic, id, "side")
    theRange.offset(0, descOffset + 1).value = util.composeLink(server, topic, id, "size")
    theRange.offset(0, descOffset + 2).value = util.composeLink(server, topic, id, "orderType")
    theRange.offset(0, descOffset + 3).value = util.composeLink(server, topic, id, "limitPrice")
    theRange.offset(0, descOffset + 4).value = util.composeLink(server, topic, id, "auxPrice")
    theRange.offset(0, statusOffset).value = util.composeLink(server, topic, id, OPEN_ACTION)
    theRange.offset(0, statusOffset + 1).value = id
    theRange.offset(0, statusOffset + 2).value = util.composeLink(server, topic, id, "status")
    theRange.offset(0, statusOffset + 3).value = util.composeLink(server, topic, id, "filled")
    theRange.offset(0, statusOffset + 4).value = util.composeLink(server, topic, id, "remaining")
    theRange.offset(0, statusOffset + 5).value = util.composeLink(server, topic, id, "price")
    theRange.offset(0, statusOffset + 6).value = util.composeLink(server, topic, id, "lastFillPrice")
    theRange.offset(0, statusOffset + 7).value = util.composeLink(server, topic, id, "parentId")
 End Sub
Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub

Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call util.clearRange(orderStatuses, util.tanColorIndex)
End Sub

