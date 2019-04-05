VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ConditionalOrders"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum ConditionalColumns
    Col_COND_STATEMENT = 1
    Col_COND_ADDMOD
    Col_COND_ACTION
    Col_COND_TOTALQTY
    Col_COND_CASHQTY
    Col_COND_ORDERTYPE
    Col_COND_LMTPRICE
    Col_COND_AUXPRICE
End Enum

Private contractTable As Range
Private orderTable As Range
Private orderStatusTable As Range
Private extendedAttributeTable As Range
Private conditionTable As Range

'=================
' methods
'=================
' apply template from Extended Order Atributes sheet
Private Sub ApplyExtendedTemplate_Click()
    OrderUtils.ApplyExtendedTemplate getActiveOrderIndex, extendedAttributeTable
End Sub


' cancel order
Private Sub CancelOrder_Click()
    OrderUtils.CancelOrders orderStatusTable
End Sub

' clear order statuses
Private Sub ClearOrderStatuses_Click()
    orderStatusTable.ClearContents
End Sub

' Combo Legs
Private Sub ComboLegs_Click()
   ComboLegForm.ShowForm contractTable
End Sub

Private Sub CreateTicker_Click()
    TickerForm.ShowForm contractTable
End Sub

' place / modify order
Public Sub PlaceModifyOrder_Click()
    If Not CheckConnected Then Exit Sub
    
    OrderUtils.PlaceModifyOrders _
                    contractTable, _
                    orderTable, _
                    orderStatusTable, _
                    extendedAttributeTable, _
                    False
End Sub

Public Sub Initialise()
    Set contractTable = ConditionalOrders.Range("$A$7:$M$125")
    Set orderTable = ConditionalOrders.Range("$N$7:$S$125")
    Set orderStatusTable = ConditionalOrders.Range("$T$7:$Z$125")
    Set conditionTable = ConditionalOrders.Range("$AA$7:$AH$125")
    Set extendedAttributeTable = ConditionalOrders.Range("$AI$7:$DY$125")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub

Sub Worksheet_Calculate()
    On Error Resume Next
    
    Dim i As Long
    For i = 1 To conditionTable.Rows.Count
        If conditionTable(i, Col_COND_STATEMENT).value Then
            ' condition is satisfied!
            processRow i
        End If
    Next
End Sub

Private Sub clearCondition(i As Long)
    conditionTable.Rows(i).ClearContents
End Sub

Private Function orderIsFilled(i As Long) As Boolean
    Dim numFilled As Integer
    numFilled = orderStatusTable(i, Col_FILLED).value
    
    Dim numRemaining As Integer
    numRemaining = orderStatusTable(i, Col_REMAINING).value
    
    If numFilled <> 0 And numRemaining = 0 Then orderIsFilled = True
End Function

Private Sub processRow(i As Long)
    Dim action As String
    action = conditionTable(i, Col_COND_ADDMOD).value

    If action = "" Then
        ' ignore row
    ElseIf action = "ADD" Then
        processOrder i
    ElseIf action <> "MOD" Then
        MsgBox "Invalid value " & action & " in ADD/MOD column"
    ElseIf orderIsFilled(i) Then
        clearCondition i
    Else
        processOrder i
    End If
End Sub

Private Sub processOrder(i As Long)
    ' copy the conditional order to the real order
    orderTable(i, Col_ACTION).value = conditionTable(i, Col_COND_ACTION).value
    orderTable(i, Col_TOTALQTY).value = conditionTable(i, Col_COND_TOTALQTY).value
    orderTable(i, Col_CASH_QTY).value = conditionTable(i, Col_COND_CASHQTY).value
    orderTable(i, Col_ORDERTYPE).value = conditionTable(i, Col_COND_ORDERTYPE).value
    orderTable(i, Col_LMTPRICE).value = conditionTable(i, Col_COND_LMTPRICE).value
    orderTable(i, Col_AUXPRICE).value = conditionTable(i, Col_COND_AUXPRICE).value
    ' clear the conditional order
    clearCondition i
    ' place the order
    contractTable(i, Col_SYMBOL).Activate
    PlaceModifyOrder_Click
End Sub

' update order status
Public Sub UpdateOrderStatus(id As Long, status As String, filled As Double, remaining As Double, avgFillPrice As Double, parentId As Long, lastFillPrice As Double)
    OrderUtils.UpdateOrderStatus orderStatusTable, id, status, filled, remaining, avgFillPrice, parentId, lastFillPrice
End Sub

' process error
Public Sub ProcessError(ByVal id As Long, ByVal errorCode As Long, ByVal errorMsg As String)
    OrderUtils.ProcessError orderStatusTable, id, errorCode, errorMsg
End Sub

Private Sub SmartComboRoutingParams_Click()
    ParamsForm.ShowForm getActiveOrderIndex, contractTable, extendedAttributeTable
End Sub

Private Function getActiveOrderIndex()
    getActiveOrderIndex = ActiveCell.row - orderTable.Rows(1).row + 1
End Function



