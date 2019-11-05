VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TickByTick"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum QuerySpecificationColumns
    Col_TICKBYTICKTYPE = 1
    Col_STATUS
End Enum

Private Enum TickByTickColumns
    Col_TIME = 1
    Col_PRICE
    Col_SIZE
    Col_BIDPRICE
    Col_ASKPRICE
    Col_BIDSIZE
    Col_ASKSIZE
    Col_EXCHANGE
    Col_SPECIALCONDITIONS
    Col_PASTLIMIT
    Col_UNREPORTED
    Col_BIDPASTLOW
    Col_ASKPASTHIGH
    Col_MIDPOINT
End Enum

Private contractTable As Range
Private querySpecificationTable As Range
Private tickByTickTable As Range

'==================
' methods
'==================
' init
Public Sub Initialize()
    Set contractTable = Range("$A$8:$K$11")
    Set querySpecificationTable = Range("$L$8:$N$11")
    Set tickByTickTable = Range("$N$8:$AA$11")

End Sub

' cancel tick-by-tick data
Private Sub cancelTickByTickData_Click()
    cancelTickByTickData1 Selection
    
    ActiveCell.Offset(1, 0).Activate
End Sub

Private Sub cancelTickByTickData1(sel As Range)
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer

    Dim row As Object
    For Each row In sel.Rows
        id = row.row - contractTable.Rows(1).row + 1
    
        ' cancel only "subscribed"
        If querySpecificationTable(id, Col_STATUS).value = STR_SUBSCRIBED Then

            ' update subscription status column
            querySpecificationTable(id, Col_STATUS).value = STR_EMPTY
        
            Api.Tws.cancelTickByTickData id + ID_TICKBYTICKDATA
        End If
        
    Next

End Sub

Private Sub clearTickByTickData_Click()
    tickByTickTable.ClearContents
End Sub

' request tick-by-tick data
Private Sub reqTickByTickData_Click()
    
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer
    Dim row As Object
    For Each row In Selection.Rows
        id = row.row - contractTable.Rows(1).row + 1

        If contractTable(id, Col_SECTYPE).value <> STR_EMPTY Then

            ' create contract
            Dim lContractInfo As TWSLib.IContract
            Set lContractInfo = Api.Tws.createContract()
    
            ' fill contract structure
            With lContractInfo
                .Symbol = UCase(contractTable(id, Col_SYMBOL).value)
                .SecType = UCase(contractTable(id, Col_SECTYPE).value)
                .lastTradeDateOrContractMonth = contractTable(id, Col_LASTTRADEDATE).value
                .Strike = contractTable(id, Col_STRIKE).value
                .Right = IIf(UCase(contractTable(id, Col_RIGHT).value) = "", 0#, UCase(contractTable(id, Col_RIGHT).value))
                .multiplier = UCase(contractTable(id, Col_MULTIPLIER).value)
                .exchange = UCase(contractTable(id, Col_EXCH).value)
                .primaryExchange = UCase(contractTable(id, Col_PRIMEXCH).value)
                .currency = UCase(contractTable(id, Col_CURRENCY).value)
                .localSymbol = UCase(contractTable(id, Col_LOCALSYMBOL).value)
                .conId = IIf(UCase(contractTable(id, Col_CONID).value) = "", 0, UCase(contractTable(id, Col_CONID).value))
            End With
    
            ' tick-by-tick type
            Dim tickByTickType As String
            tickByTickType = STR_EMPTY
    
            tickByTickType = querySpecificationTable(id, Col_TICKBYTICKTYPE).value
    
            ' update subscription status column
            querySpecificationTable(id, Col_STATUS).value = STR_SUBSCRIBED
            
            ' call reqTickByTickData method
            Api.Tws.reqTickByTickData id + ID_TICKBYTICKDATA, lContractInfo, tickByTickType, 0, True
            
        End If
    Next
    
    ActiveCell.Offset(1, 0).Activate
End Sub

Public Sub TickByTickAllLast(ByVal reqId As Long, ByVal tickType As Long, ByVal time As String, ByVal price As Double, ByVal size As Long, ByVal tickAttribLast As TWSLib.ITickAttribLast, ByVal exchange As String, ByVal specialConditions As String)
    reqId = reqId - ID_TICKBYTICKDATA
    tickByTickTable(reqId, Col_TIME).value = Format(DateAdd("s", CLng(time), "01/01/1970"), "yyyy-mm-dd Hh:Nn:Ss")
    tickByTickTable(reqId, Col_PRICE).value = price
    tickByTickTable(reqId, Col_SIZE).value = size
    tickByTickTable(reqId, Col_BIDPRICE).value = STR_EMPTY
    tickByTickTable(reqId, Col_ASKPRICE).value = STR_EMPTY
    tickByTickTable(reqId, Col_BIDSIZE).value = STR_EMPTY
    tickByTickTable(reqId, Col_ASKSIZE).value = STR_EMPTY
    tickByTickTable(reqId, Col_EXCHANGE).value = exchange
    tickByTickTable(reqId, Col_SPECIALCONDITIONS).value = specialConditions
    tickByTickTable(reqId, Col_PASTLIMIT).value = tickAttribLast.PastLimit
    If tickType = 2 Then
        tickByTickTable(reqId, Col_UNREPORTED).value = tickAttribLast.unreported
    Else
        tickByTickTable(reqId, Col_UNREPORTED).value = STR_EMPTY
    End If
    tickByTickTable(reqId, Col_BIDPASTLOW).value = STR_EMPTY
    tickByTickTable(reqId, Col_ASKPASTHIGH).value = STR_EMPTY
    tickByTickTable(reqId, Col_MIDPOINT).value = STR_EMPTY
End Sub

Public Sub TickByTickBidAsk(ByVal reqId As Long, ByVal time As String, ByVal bidPrice As Double, ByVal askPrice As Double, ByVal bidSize As Long, ByVal askSize As Long, ByVal tickAttribBidAsk As TWSLib.ITickAttribBidAsk)
    reqId = reqId - ID_TICKBYTICKDATA
    tickByTickTable(reqId, Col_TIME).value = Format(DateAdd("s", CLng(time), "01/01/1970"), "yyyy-mm-dd Hh:Nn:Ss")
    tickByTickTable(reqId, Col_PRICE).value = STR_EMPTY
    tickByTickTable(reqId, Col_SIZE).value = STR_EMPTY
    tickByTickTable(reqId, Col_BIDPRICE).value = bidPrice
    tickByTickTable(reqId, Col_ASKPRICE).value = askPrice
    tickByTickTable(reqId, Col_BIDSIZE).value = bidSize
    tickByTickTable(reqId, Col_ASKSIZE).value = askSize
    tickByTickTable(reqId, Col_EXCHANGE).value = STR_EMPTY
    tickByTickTable(reqId, Col_SPECIALCONDITIONS).value = STR_EMPTY
    tickByTickTable(reqId, Col_PASTLIMIT).value = STR_EMPTY
    tickByTickTable(reqId, Col_UNREPORTED).value = STR_EMPTY
    tickByTickTable(reqId, Col_BIDPASTLOW).value = tickAttribBidAsk.bidPastLow
    tickByTickTable(reqId, Col_ASKPASTHIGH).value = tickAttribBidAsk.askPastHigh
    tickByTickTable(reqId, Col_MIDPOINT).value = STR_EMPTY
End Sub

Public Sub TickByTickMidPoint(ByVal reqId As Long, ByVal time As String, ByVal midPoint As Double)
    reqId = reqId - ID_TICKBYTICKDATA
    tickByTickTable(reqId, Col_TIME).value = Format(DateAdd("s", CLng(time), "01/01/1970"), "yyyy-mm-dd Hh:Nn:Ss")
    tickByTickTable(reqId, Col_PRICE).value = STR_EMPTY
    tickByTickTable(reqId, Col_SIZE).value = STR_EMPTY
    tickByTickTable(reqId, Col_BIDPRICE).value = STR_EMPTY
    tickByTickTable(reqId, Col_ASKPRICE).value = STR_EMPTY
    tickByTickTable(reqId, Col_BIDSIZE).value = STR_EMPTY
    tickByTickTable(reqId, Col_ASKSIZE).value = STR_EMPTY
    tickByTickTable(reqId, Col_EXCHANGE).value = STR_EMPTY
    tickByTickTable(reqId, Col_SPECIALCONDITIONS).value = STR_EMPTY
    tickByTickTable(reqId, Col_PASTLIMIT).value = STR_EMPTY
    tickByTickTable(reqId, Col_UNREPORTED).value = STR_EMPTY
    tickByTickTable(reqId, Col_BIDPASTLOW).value = STR_EMPTY
    tickByTickTable(reqId, Col_ASKPASTHIGH).value = STR_EMPTY
    tickByTickTable(reqId, Col_MIDPOINT).value = midPoint
End Sub

Public Sub ProcessError(ByVal id As Long, ByVal errorCode As Long, ByVal errorMsg As String)
    querySpecificationTable(id - ID_TICKBYTICKDATA, Col_STATUS).value = STR_ERROR + STR_COLON + Str(errorCode) + STR_SPACE + errorMsg
End Sub



