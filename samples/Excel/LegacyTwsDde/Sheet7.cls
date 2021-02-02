VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet7"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Integer
Dim numDisplayRows As Integer

Const serverCell = "mktdServer"
Const DDEoffset = 9
Const topic = "mktDepth"
Const price1 = "K"
Const size1 = "L"
Const cum1 = "M"
Const prod1 = "V"
Const price2 = "Q"
Const size2 = "R"
Const cum2 = "S"
Const prod2 = "W"
Const refreshRateCell = "mktdRefreshRate"
Const mktdRefreshLink = "mktdRefreshLink"
Const errorRange = "mktdErrorPosition"
Const mktDepthBid = "mktDepthBid"
Const mktDepthAsk = "mktDepthAsk"
Const maxRows = 10

Sub setRefreshRate()
    Dim refreshRate As String
    refreshRate = Range(refreshRateCell).value
    If refreshRate = "" Then
        MsgBox ("You must enter a valid refresh rate.")
        Exit Sub
    End If
    Range(refreshRateCell).offset(1, 0).value = _
        getServerStr(serverCell) & "refreshRate!millisec?" & refreshRate
End Sub

Sub cancelMktDepth()
    ActiveCell.offset(0, 20).Formula = "" 'To cancel market depth simply remove the control cell
End Sub

Sub reqMktDepth()
    Dim server As String, req As String, reqType As String, id As String, cumSizeFn As String, avgPriceFn As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    If Not util.composeContractReq(ActiveCell, req, reqType, False, 9) Then Exit Sub
    
    id = util.getIDpost(genId)
    
    'ActiveCell.offset(0, DDEoffset).Formula = util.composeControlLink(server, topic, id, reqType, req)
    ' Set the control cell
    Dim startRow As Integer, currRow As Integer, i As Integer
    ActiveCell.offset(0, DDEoffset + 11).Formula = _
        util.composeControlLink(server, topic, id, reqType, req & util.QMARK & numDisplayRows)
       
    startRow = ActiveCell.row
    currRow = startRow
    For i = 0 To maxRows - 1 ' substract 1 as we have a 0 offset
        currRow = startRow + i
 
        ActiveCell.offset(i, DDEoffset).Formula = util.composeControlLink(server, topic, id, "mktMaker", i & "_BID")
        ActiveCell.offset(i, DDEoffset + 1).Formula = util.composeControlLink(server, topic, id, "price", i & "_BID")
        ActiveCell.offset(i, DDEoffset + 2).Formula = util.composeControlLink(server, topic, id, "size", i & "_BID")
        
        'Calculate the cumulative size       "=IF(SIZE1x=0, 0, SUM(SIZE1x:SIZE1y))"
        cumSizeFn = "=IF(" & size1 & currRow & "=0, 0 ," & "SUM(" & size1 & startRow & ":" & size1 & currRow & "))"
        ActiveCell.offset(i, DDEoffset + 3).value = cumSizeFn
        
        'Calculate the average price        "=IF(I11=0, 0,SUM(T11:T11)/K11)"
        ActiveCell.offset(i, DDEoffset + 12).value = "=(" & price1 & currRow & "*" & size1 & currRow & ")"
        avgPriceFn = "=IF(" & price1 & currRow & "=0, 0," & " SUM(" & prod1 & startRow & ":" & prod1 & currRow & ")/" & cum1 & currRow & ")"
        ActiveCell.offset(i, DDEoffset + 4).value = avgPriceFn
        
        ActiveCell.offset(i, DDEoffset + 6).Formula = util.composeControlLink(server, topic, id, "mktMaker", i & "_ASK")
        ActiveCell.offset(i, DDEoffset + 7).Formula = util.composeControlLink(server, topic, id, "price", i & "_ASK")
        ActiveCell.offset(i, DDEoffset + 8).Formula = util.composeControlLink(server, topic, id, "size", i & "_ASK")
        
        'Calculate the cumulative size     "=IF(Jx=0, 0, SUM(Jx:Jy))"
        cumSizeFn = "=IF(" & size2 & currRow & "=0, 0 ," & "SUM(" & size2 & startRow & ":" & size2 & currRow & "))"
        ActiveCell.offset(i, DDEoffset + 9).value = cumSizeFn
        
        'Calculate the average price        "=IF(I11=0, 0,SUM(T11:T11)/K11)"
        ActiveCell.offset(i, DDEoffset + 13).value = "=(" & price2 & currRow & "*" & size2 & currRow & ")"
        avgPriceFn = "=IF(" & price2 & currRow & "=0, 0," & " SUM(" & prod2 & startRow & ":" & prod2 & currRow & ")/" & cum2 & currRow & ")"
        ActiveCell.offset(i, DDEoffset + 10).value = avgPriceFn

    Next i
    ActiveCell.offset(1, 0).Activate
End Sub
Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub

Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call util.clearRange(mktdRefreshLink)
    Call util.clearRange(mktDepthBid, util.darkGreyColorIndex, xlShiftUp)
    Call util.clearRange(mktDepthAsk, util.darkGreyColorIndex, xlShiftUp)
End Sub
