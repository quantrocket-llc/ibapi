VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet5"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Integer

Const serverCell = "contServer"
Const topic = "contract"
Const responseOffset = 10
Const errorRange = "contErrorPosition"
Const contractDetails = "contractDetails"

Sub reqContractDetails()
Attribute reqContractDetails.VB_ProcData.VB_Invoke_Func = "C\n14"
    Dim server As String, req As String, reqType As String, id As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    If Not util.composeContractReq(ActiveCell, req, reqType, False, 9, 10) Then Exit Sub
    
    id = util.getIDpost(genId)
    
    ActiveCell.offset(0, responseOffset).Formula = util.composeControlLink(server, topic, id, reqType, req)
    ActiveCell.offset(0, responseOffset + 1).Formula = util.composeLink(server, topic, id, "orderTypes")
    ActiveCell.offset(0, responseOffset + 2).Formula = util.composeLink(server, topic, id, "validExchanges")
    ActiveCell.offset(0, responseOffset + 3).Formula = util.composeLink(server, topic, id, "conid")
    ActiveCell.offset(0, responseOffset + 4).Formula = util.composeLink(server, topic, id, "minTick")
    ActiveCell.offset(0, responseOffset + 5).Formula = util.composeLink(server, topic, id, "multiplier")
    ActiveCell.offset(0, responseOffset + 6).Formula = util.composeLink(server, topic, id, "marketName")
    ActiveCell.offset(0, responseOffset + 7).Formula = util.composeLink(server, topic, id, "tradingClass")
    ActiveCell.offset(1, 0).Activate
End Sub
Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub
Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call util.clearRange(contractDetails, util.darkGreyColorIndex, xlShiftUp)
End Sub

