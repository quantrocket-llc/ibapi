VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Const serverCell = "condServer"
Const errorRange = "condErrorPosition"
Const conditionalOrderCells = "conditionalOrderCells"
Const firstMonitorRow = "firstMonitorRow"
Const lastMonitorRow = "lastMonitorRow"
Const extAttribColumn = 33

Sub placeConditionalOrder()
    Call OrderFunctions.order2(Selection.rows, serverCell, extAttribColumn, False)
End Sub

Sub cancelConditionalOrder()
    Call OrderFunctions.cancelOrder(Selection.rows, serverCell)
End Sub

Sub applyTemplate()
    Call OrderFunctions.applyTemplate(Selection.rows, extAttribColumn)
End Sub

Sub Worksheet_Calculate()
    On Error Resume Next
    Dim validCond As Boolean
    Dim orderRowFirstCell As Range
    Dim rowMod As Integer
    Dim action As String

    For rowMod = Range(firstMonitorRow).value To Range(lastMonitorRow).value
        Set orderRowFirstCell = Cells(rowMod, 1)
        validCond = Cells(rowMod, 26)
        action = Cells(rowMod, 27)

        ' modify order?
        If action = "MOD" Then
            ' if the order is filled, clear the conditional order
            Dim numFilled As Integer, numRemaining As Integer
            numFilled = Cells(rowMod, 21)
            numRemaining = Cells(rowMod, 22)
            If numFilled <> 0 And numRemaining = 0 Then
                Range(Cells(rowMod, 26), Cells(rowMod, 32)).ClearContents
            Else
                If Err.Number <> 0 Then
                    Err.Clear
                    validCond = False
                End If
                'if condition is met...
                If validCond Then
                    ' copy the conditional order to the real order
                    Range(Cells(rowMod, 13), Cells(rowMod, 17)).value = _
                        Range(Cells(rowMod, 28), Cells(rowMod, 32)).value
                    ' place the order
                    Call order2(orderRowFirstCell, serverCell, extAttribColumn, False)
                End If
            End If
        ' add order?
        ElseIf action = "ADD" Then
            'if condition is met...
            If Err.Number <> 0 Then
                Err.Clear
                validCond = False
            End If
            If validCond Then
                ' copy the conditional order to the real order
                Range(Cells(rowMod, 13), Cells(rowMod, 17)).value = _
                    Range(Cells(rowMod, 28), Cells(rowMod, 32)).value
                ' clear the conditional order
                Range(Cells(rowMod, 26), Cells(rowMod, 32)).ClearContents
                ' place the order
                Call order2(orderRowFirstCell, serverCell, extAttribColumn, False)
            End If
        ElseIf action <> "" Then
            MsgBox ("Invalid value " & action & " in ADD/MOD column")
        End If
    Next rowMod
End Sub
Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub

Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call util.clearRange(conditionalOrderCells, util.tanColorIndex, xlShiftUp)
End Sub

