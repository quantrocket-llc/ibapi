VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet9"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Integer

Const serverCell = "bondServer"
Const topic = "contract"
Const responseOffset = 6
Const errorRange = "bondErrorPosition"
Const bondContractDetails = "bondContractDetails"

Sub reqBondContractDetails()
Attribute reqBondContractDetails.VB_ProcData.VB_Invoke_Func = "B\n14"
    Dim server As String, req As String, id As String, cumSizeFn As String, avgPriceFn As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    id = util.getIDpost(genId)
    
    ' get contract description
    Dim cusip As String, secType As String, exchange As String, curency As String
    cusip = UCase(ActiveCell.offset(0, 0).value)
    secType = UCase(ActiveCell.offset(0, 1).value)
    exchange = ActiveCell.offset(0, 2).value
    curency = ActiveCell.offset(0, 3).value
    
    If cusip = "" Or secType = "" Or exchange = "" Or curency = "" Then
        MsgBox ("You must enter cusip, security type, exchange, and curency.")
        Exit Sub
    End If
    
    req = cusip & util.UNDERSCORE & secType & util.UNDERSCORE & exchange & util.UNDERSCORE & curency
    
    ActiveCell.offset(0, responseOffset - 1).Formula = util.composeControlLink(server, topic, id, "req", req)
    ActiveCell.offset(0, responseOffset + 0).Formula = util.composeLink(server, topic, id, "symbol")
    ActiveCell.offset(0, responseOffset + 1).Formula = util.composeLink(server, topic, id, "coupon")
    ActiveCell.offset(0, responseOffset + 2).Formula = util.composeLink(server, topic, id, "maturity")
    ActiveCell.offset(0, responseOffset + 3).Formula = util.composeLink(server, topic, id, "issueDate")
    ActiveCell.offset(0, responseOffset + 4).Formula = util.composeLink(server, topic, id, "ratings")
    ActiveCell.offset(0, responseOffset + 5).Formula = util.composeLink(server, topic, id, "bondType")
    ActiveCell.offset(0, responseOffset + 6).Formula = util.composeLink(server, topic, id, "couponType")
    ActiveCell.offset(0, responseOffset + 7).Formula = util.composeLink(server, topic, id, "convertible")
    ActiveCell.offset(0, responseOffset + 8).Formula = util.composeLink(server, topic, id, "callable")
    ActiveCell.offset(0, responseOffset + 9).Formula = util.composeLink(server, topic, id, "putable")
    ActiveCell.offset(0, responseOffset + 10).Formula = util.composeLink(server, topic, id, "descAppend")
    ActiveCell.offset(0, responseOffset + 11).Formula = util.composeLink(server, topic, id, "marketName")
    ActiveCell.offset(0, responseOffset + 12).Formula = util.composeLink(server, topic, id, "tradingClass")
    ActiveCell.offset(0, responseOffset + 13).Formula = util.composeLink(server, topic, id, "conid")
    ActiveCell.offset(0, responseOffset + 14).Formula = util.composeLink(server, topic, id, "minTick")
    ActiveCell.offset(0, responseOffset + 15).Formula = util.composeLink(server, topic, id, "orderTypes")
    ActiveCell.offset(0, responseOffset + 16).Formula = util.composeLink(server, topic, id, "validExchanges")
    ActiveCell.offset(0, responseOffset + 17).Formula = util.composeLink(server, topic, id, "nextOptionDate")
    ActiveCell.offset(0, responseOffset + 18).Formula = util.composeLink(server, topic, id, "nextOptionType")
    ActiveCell.offset(0, responseOffset + 19).Formula = util.composeLink(server, topic, id, "nextOptionPartial")
    ActiveCell.offset(0, responseOffset + 20).Formula = util.composeLink(server, topic, id, "notes")
    ActiveCell.offset(1, 0).Activate
End Sub
Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub
Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call util.clearRange(bondContractDetails, util.darkGreyColorIndex, xlShiftUp)
End Sub

