VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet6"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Integer
Dim lastExeRow As Integer

Const serverCell = "execServer"
Const topic = "exec"
Const errorRange = "execErrorPosition"
Const executionContracts = "executionContracts"
Const execFilterStart = "exec_filter_start"
Const executionDetails = "executionDetails"

Sub reqExecutions()
    Dim server As String, filter As String, id As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    id = util.getIDpost(genId)
    filter = buildExecutionRptsFilter()
    
    If (lastExeRow = 0) Then
        lastExeRow = 10         'This is the first line of the execution report range
    End If
    
    Range("A" & lastExeRow).Select
    ActiveCell.offset(0, 16).Formula = util.composeControlLink(server, topic, id, "req", filter)
    ActiveCell.offset(0, 0).Formula = util.composeLink(server, topic, id, "symbol")
    ActiveCell.offset(0, 1).Formula = util.composeLink(server, topic, id, "secType")
    ActiveCell.offset(0, 2).Formula = util.composeLink(server, topic, id, "expiry")
    ActiveCell.offset(0, 3).Formula = util.composeLink(server, topic, id, "strike")
    ActiveCell.offset(0, 4).Formula = util.composeLink(server, topic, id, "right")
    ActiveCell.offset(0, 5).Formula = util.composeLink(server, topic, id, "exchange")
    ActiveCell.offset(0, 6).Formula = util.composeLink(server, topic, id, "currency")
    ActiveCell.offset(0, 7).Formula = util.composeLink(server, topic, id, "orderId")
    ActiveCell.offset(0, 8).Formula = util.composeLink(server, topic, id, "execId")
    ActiveCell.offset(0, 9).Formula = util.composeLink(server, topic, id, "time")
    ActiveCell.offset(0, 10).Formula = util.composeLink(server, topic, id, "acctNumber")
    ActiveCell.offset(0, 11).Formula = util.composeLink(server, topic, id, "eExchange")
    ActiveCell.offset(0, 12).Formula = util.composeLink(server, topic, id, "side")
    ActiveCell.offset(0, 13).Formula = util.composeLink(server, topic, id, "shares")
    ActiveCell.offset(0, 14).Formula = util.composeLink(server, topic, id, "price")
    ActiveCell.offset(0, 15).Formula = util.composeLink(server, topic, id, "permId")
    lastExeRow = lastExeRow + 1
End Sub

' Build the execution reports filter criteria
Function buildExecutionRptsFilter() As String
    Dim filterStr As String
    Dim value As Variant
    Dim ctr As Integer
    
    For ctr = 0 To 7
        value = Range(execFilterStart).offset(ctr, 0).value
        If value = "" Then
            filterStr = filterStr & util.CELL_EMPTY
        Else
            filterStr = filterStr & value
        End If
    
        If (ctr <> 7) Then
            filterStr = filterStr & util.UNDERSCORE
        End If
    Next ctr
        
    buildExecutionRptsFilter = filterStr
End Function

Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub

Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call util.clearRange(executionContracts, util.darkGreyColorIndex, xlShiftUp)
    Call util.clearRange(executionDetails, util.tanColorIndex, xlShiftUp)
End Sub


