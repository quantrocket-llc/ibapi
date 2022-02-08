VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Integer

Const serverCell = "tickerServer"
Const refreshRateCell = "refreshRate"
Const refreshRateLink = "refreshRateLink"
Const processingRateCell = "processingRate"
Const processingRateLink = "processingRateLink"
Const logLevelCell = "logLevel"
Const logLevelResult = "logLevelResult"
Const topic = "tik"
Const topicCalcImplVol = "calcimplvol"
Const topicCalcOptionPrice = "calcoptionprice"
Const topicGenericTicks = "gentik"
Const bulletinTopic = "news"
Const reqOffset = 15
Const errorRange = "tickerErrorPosition"
Const tickerCells = "tickerCells"
Const bulletinCtrl = "bulletinCtrl"
Const bulletinCell = "bulletinCell"
Const bulletinTitle = "bulletinTitle"
Const efpOffset = reqOffset + 29
Const EFP_TICK_NUMBER = 3 ' set to 6 for all
Const calcImplVolColumn = 12

Sub calculateOptionPrice()
    Dim server As String, req As String, reqType As String, id As String, secType As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    Dim setSecType As String, setExchange As String
    If Not util.composeContractReq(ActiveCell, req, reqType, False, , , , setSecType, setExchange) Then Exit Sub
    id = util.getIDpost(genId)

    Dim volatility As String, underPrice As String
    volatility = Cells(ActiveCell.row, calcImplVolColumn + 1)
    underPrice = Cells(ActiveCell.row, calcImplVolColumn + 2)
    reqType = "get"

    req = volatility & util.UNDERSCORE & underPrice & util.UNDERSCORE & req

    If setSecType = util.OPT Or setSecType = util.FOP Then
        ActiveCell.offset(0, reqOffset + 20).Formula = util.composeControlLink(server, topicCalcOptionPrice, id, reqType, req)
    End If
    ActiveCell.offset(1, 0).Activate
End Sub

Sub calculateImpliedVolatility()
    Dim server As String, req As String, reqType As String, id As String, secType As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    Dim setSecType As String, setExchange As String
    If Not util.composeContractReq(ActiveCell, req, reqType, False, , , , setSecType, setExchange) Then Exit Sub
    id = util.getIDpost(genId)
    
    Dim optPrice As String, underPrice As String
    optPrice = Cells(ActiveCell.row, calcImplVolColumn)
    underPrice = Cells(ActiveCell.row, calcImplVolColumn + 2)
    reqType = "get"
    
    req = optPrice & util.UNDERSCORE & underPrice & util.UNDERSCORE & req
    
    If setSecType = util.OPT Or setSecType = util.FOP Then
        ActiveCell.offset(0, reqOffset + 19).Formula = util.composeControlLink(server, topicCalcImplVol, id, reqType, req)
    End If
    
    ActiveCell.offset(1, 0).Activate
End Sub

Sub requestGenericTicks()
    Dim server As String, req As String, reqType As String, id As String, secType As String, genericTicks
    Dim delimiter As String
    Dim i, j As Integer
    Dim genericTicksArray() As String
    Dim genericTicksRequestString As String
    Dim supportedGenericTicksArray(0, 1) As Variant
    supportedGenericTicksArray(0, 0) = 18  ' column offset for lastRthTrade
    supportedGenericTicksArray(0, 1) = "318"  ' lastRthTrade
    
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    Dim setSecType As String, setExchange As String
    If Not util.composeContractReq(ActiveCell, req, reqType, True, , , , setSecType, setExchange) Then Exit Sub
    
    id = util.getIDpost(genId)
    
    ' add generic ticks
    genericTicks = ActiveCell.offset(0, 14).value
    If genericTicks <> "" Then
        delimiter = ","
        
        ' parse generic ticks string into array
        genericTicksArray = VBA.Split(genericTicks, delimiter)
        
        ' check if generic tick is supported
        Dim composeControlLink As Boolean
        composeControlLink = False
        For i = LBound(genericTicksArray) To UBound(genericTicksArray)
            For j = LBound(supportedGenericTicksArray, 1) To UBound(supportedGenericTicksArray, 1)
                If genericTicksArray(i) = supportedGenericTicksArray(j, 1) Then
                    genericTicksRequestString = genericTicksRequestString & genericTicksArray(i) & delimiter
                    ActiveCell.offset(0, reqOffset + supportedGenericTicksArray(j, 0)).Formula = util.composeLink(server, topicGenericTicks, id, supportedGenericTicksArray(j, 1))
                    composeControlLink = True
                End If
            Next
        Next
        If composeControlLink Then
            genericTicksRequestString = Left(genericTicksRequestString, Len(genericTicksRequestString) - 1)
            ActiveCell.offset(0, reqOffset + 1).Formula = util.composeControlLink(server, topicGenericTicks, id, reqType & "?" & genericTicksRequestString, req)
        End If
        
    End If
    
    ActiveCell.offset(1, 0).Activate
    End Sub

Sub requestMarketData()
Attribute requestMarketData.VB_ProcData.VB_Invoke_Func = "R\n14"
    Dim server As String, req As String, reqType As String, id As String, secType As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    Dim setSecType As String, setExchange As String
    If Not util.composeContractReq(ActiveCell, req, reqType, True, , , , setSecType, setExchange) Then Exit Sub
   
    id = util.getIDpost(genId)
    
    ActiveCell.offset(0, reqOffset).Formula = util.composeControlLink(server, topic, id, reqType, req)
    ActiveCell.offset(0, reqOffset + 4).Formula = util.composeLink(server, topic, id, "bidSize")
    ActiveCell.offset(0, reqOffset + 5).Formula = util.composeLink(server, topic, id, "bid")
    ActiveCell.offset(0, reqOffset + 6).Formula = util.composeLink(server, topic, id, "ask")
    ActiveCell.offset(0, reqOffset + 7).Formula = util.composeLink(server, topic, id, "askSize")
    ActiveCell.offset(0, reqOffset + 10).Formula = util.composeLink(server, topic, id, "last")
    ActiveCell.offset(0, reqOffset + 11).Formula = util.composeLink(server, topic, id, "lastSize")
    ActiveCell.offset(0, reqOffset + 14).Formula = util.composeLink(server, topic, id, "high")
    ActiveCell.offset(0, reqOffset + 15).Formula = util.composeLink(server, topic, id, "low")
    ActiveCell.offset(0, reqOffset + 16).Formula = util.composeLink(server, topic, id, "volume")
    ActiveCell.offset(0, reqOffset + 17).Formula = util.composeLink(server, topic, id, "close")
    
    If setSecType = util.OPT Or setSecType = util.FOP Then
        ActiveCell.offset(0, reqOffset + 2).Formula = util.composeLink(server, topic, id, "bidImpliedVol")
        ActiveCell.offset(0, reqOffset + 3).Formula = util.composeLink(server, topic, id, "bidDelta")
        ActiveCell.offset(0, reqOffset + 8).Formula = util.composeLink(server, topic, id, "askImpliedVol")
        ActiveCell.offset(0, reqOffset + 9).Formula = util.composeLink(server, topic, id, "askDelta")
        ActiveCell.offset(0, reqOffset + 12).Formula = util.composeLink(server, topic, id, "lastImpliedVol")
        ActiveCell.offset(0, reqOffset + 13).Formula = util.composeLink(server, topic, id, "lastDelta")
        
        ActiveCell.offset(0, reqOffset + 21).Formula = util.composeLink(server, topic, id, "modelVolatility")
        ActiveCell.offset(0, reqOffset + 22).Formula = util.composeLink(server, topic, id, "modelDelta")
        ActiveCell.offset(0, reqOffset + 23).Formula = util.composeLink(server, topic, id, "modelPrice")
        ActiveCell.offset(0, reqOffset + 24).Formula = util.composeLink(server, topic, id, "pvDividend")
        ActiveCell.offset(0, reqOffset + 25).Formula = util.composeLink(server, topic, id, "modelGamma")
        ActiveCell.offset(0, reqOffset + 26).Formula = util.composeLink(server, topic, id, "modelVega")
        ActiveCell.offset(0, reqOffset + 27).Formula = util.composeLink(server, topic, id, "modelTheta")
        ActiveCell.offset(0, reqOffset + 28).Formula = util.composeLink(server, topic, id, "modelUndPrice")
    End If
    
    Dim efpTickTypes As Variant
    efpTickTypes = Array("BidEFP", "AskEFP", "LastEFP", "OpenEFP", "HighEFP", "LowEFP", "CloseEFP")

    If setSecType = util.BAG Then
        ActiveCell.offset(0, efpOffset).Formula = util.composeLink(server, topic, id, "HoldDays")
        ActiveCell.offset(0, efpOffset + 1).Formula = util.composeLink(server, topic, id, "FuturesExpiry")
        ActiveCell.offset(0, efpOffset + 2).Formula = util.composeLink(server, topic, id, "DividendsToExpiry")
        Dim ctr As Integer
        For ctr = 0 To UBound(efpTickTypes, 1) - 1
            If ctr < EFP_TICK_NUMBER Then
                Call addEFP(3 + (ctr * 4), efpTickTypes(ctr), server, topic, id)
            End If
        Next ctr
    End If
    ActiveCell.offset(1, 0).Activate
End Sub
Sub addEFP(ByVal offset As Integer, ByVal prefix As String, ByRef server As String, ByRef topic As String, ByRef idstr As String)
        ActiveCell.offset(0, efpOffset + offset).Formula = util.composeLink(server, topic, idstr, prefix & "BasisPoints")
        ActiveCell.offset(0, efpOffset + offset + 1).Formula = util.composeLink(server, topic, idstr, prefix & "QuoteForm")
        ActiveCell.offset(0, efpOffset + offset + 2).Formula = util.composeLink(server, topic, idstr, prefix & "ImpliedFuture")
        ActiveCell.offset(0, efpOffset + offset + 3).Formula = util.composeLink(server, topic, idstr, prefix & "DividendImpact")
End Sub
Sub setRefreshRate()
    Dim theRate As String
    theRate = Range(refreshRateCell).value
    If theRate = "" Then
        MsgBox ("You must enter a valid refresh rate.")
        Exit Sub
    End If
    Range(refreshRateLink).value = getServerStr(serverCell) & "refreshRate!millisec?" & theRate
End Sub
Sub setProcessingRate()
    Dim theRate As String
    theRate = Range(processingRateCell).value
    If theRate = "" Then
        MsgBox ("You must enter a valid processing rate.")
        Exit Sub
    End If
    Range(processingRateLink).value = getServerStr(serverCell) & "processRate!millisec?" & theRate
End Sub
Sub newBulletins()
    IBBulletinsForm.Show
End Sub
Sub setLoggingLevel()
    Dim logLevel As String
    logLevel = Range(logLevelCell).value
    If logLevel = "" Then
        MsgBox ("You must enter a valid log level (1-5).")
        Exit Sub
    End If
    Range(logLevelResult).value = getServerStr(serverCell) & "logLevel!'0" & logLevel & "'"
End Sub
Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub
Sub bulletinDeSubscribe()
    doBulletinArea (False)
    IBBulletinsForm.Hide
End Sub
Sub bulletinSubscribe()
    Dim newReqStr, server As String
    
    server = getServerStr(serverCell)
    If server = "" Then Exit Sub
        
    doBulletinArea (True)
    Range(bulletinCell).offset(-1, 0).Select
    Selection.Font.Bold = True
    ActiveCell.FormulaR1C1 = "IB News Bulletins"
    Range(bulletinCtrl).value = util.composeSubscriptionLink(server, bulletinTopic, util.BULLETIN_REQ)
    Range(bulletinCell).value = server & "news!msg"
    ' The following  data is also available if required
    'Cells(Y, X).Value = serverStr & "news!newsId"
    'Cells(Y, X).Value = serverStr & "news!newsType"
    'Cells(Y, X).Value = serverStr & "news!exchange"
    
    IBBulletinsForm.Hide
End Sub
Sub doBulletinArea(ByVal subscribing As Boolean)
    Range(bulletinCell).Select
    With Selection.Interior
        .colorIndex = util.brightRedColorIndex
        .Pattern = xlSolid
    End With
            
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlBottom
        .WrapText = True
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = True
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .colorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .colorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .colorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .colorIndex = xlAutomatic
    End With
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
End Sub
Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call util.clearRange(tickerCells, util.darkGreyColorIndex, xlShiftUp)
    Call util.clearRange(refreshRateLink)
    Call util.clearRange(logLevelResult)
    Call util.clearRange(bulletinCtrl)
    Call util.clearRange(bulletinCell)
    Call util.clearRange(bulletinTitle)
    Call util.clearRange(processingRateLink)
End Sub

