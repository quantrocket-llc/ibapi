VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "MarketDepth"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Const CELL_REFRESH_RATE = "F4"

Private Enum MarketDepthColumns
    Col_STATUS = 1

    Col_BIDMM
    Col_BIDPRICE
    Col_BIDSIZE
    Col_BIDCUMQTY
    Col_BIDAVGPRICE
    Col_Empty

    Col_ASKMM
    Col_ASKPRICE
    Col_ASKSIZE
    Col_ASKCUMQTY
    Col_ASKAVGPRICE
End Enum

Private Enum ExchangesColumns
    Col_DEPTHMKTDATADESCRIPTION_EXCHANGE = 1
    Col_DEPTHMKTDATADESCRIPTION_SECTYPE
    Col_DEPTHMKTDATADESCRIPTION_LISTINGEXCH
    Col_DEPTHMKTDATADESCRIPTION_SERVICEDATATYPE
    Col_DEPTHMKTDATADESCRIPTION_AGGGROUP
End Enum

'other constants
Const MKT_DEPTH_NUM_ROWS = 10
Const MKT_DEPTH_SIDE_ASK = 0
Const MKT_DEPTH_SIDE_BID = 1
Const MKT_DEPTH_OPER_INS = 0
Const MKT_DEPTH_OPER_UPD = 1
Const MKT_DEPTH_OPER_DEL = 2

' MktDepthRecord type
Private Type MktDepthRecord
    BidMM As String
    bidPrice As Double
    bidSize As Long
    BidCumSize As Long
    BidAvgPrice As Double
    AskMM As String
    askPrice As Double
    askSize As Long
    AskCumSize As Long
    AskAvgPrice As Double
End Type

' variables
' timer
Public RunWhen As Double
Public RunWhat As String
Public timerIsOn As Boolean

' array to keep data
Dim arMktDepth() As MktDepthRecord

Private contractTable As Range
Private dataTable As Range
Private exchangesTable As Range

'=================
' methods
'=================

Public Sub Initialise()
    Set contractTable = MarketDepth.Range("$A$10:$J$200")
    Set dataTable = MarketDepth.Range("$K$10:$V$200")
    Set exchangesTable = MarketDepth.Range("$W$10:$AA$200")
End Sub

Private Sub Worksheet_Activate()
    On Error GoTo Err
    
    Main.Initialise
    
    Dim ub As Long
    ub = UBound(arMktDepth)
    
    If CanStartTimer() Then
        StartTimer
    End If
    Exit Sub

Err:
    If Err.Number = 9 Then
         ReDim arMktDepth(dataTable.Rows.Count) As MktDepthRecord
         Resume Next
    End If
End Sub

Private Sub Worksheet_Deactivate()
    If timerIsOn Then
        StopTimer
    End If
End Sub

' start timer
Public Sub StartTimer()
    If (Range(CELL_REFRESH_RATE).value >= 1 And Range(CELL_REFRESH_RATE).value <= 9) Then
        timerIsOn = True
        
        RunWhen = Now + TimeValue("00:00:0" & Range(CELL_REFRESH_RATE).value)
        RunWhat = "MarketDepth.RepaintMktDepthTable"
    
        Application.OnTime RunWhen, RunWhat, , True
    End If
End Sub

' stop timer
Public Sub StopTimer()
    timerIsOn = False
    RunWhat = "MarketDepth.RepaintMktDepthTable"
    On Error Resume Next
    Application.OnTime RunWhen, RunWhat, , False
End Sub

' repaint market depth table
Public Sub RepaintMktDepthTable()

    Dim i As Integer
    
    ' display records with "subscribed" status
    For i = 1 To dataTable.Rows.Count Step MKT_DEPTH_NUM_ROWS + 1
        
        If dataTable(i, Col_STATUS).value = STR_SUBSCRIBED Then
            
            ' calculate CumQty and AvgPrice
            CalculateCumSizeAvgPrice i
            
            Dim j As Long
            For j = 0 To MKT_DEPTH_NUM_ROWS - 1 Step 1
                
                With arMktDepth(i - 1 + j)
                    dataTable(i + j, Col_BIDMM).value = .BidMM

                    If .bidPrice > 0 Then
                        dataTable(i + j, Col_BIDPRICE).value = .bidPrice
                    Else
                        dataTable(i + j, Col_BIDPRICE).value = STR_EMPTY
                    End If
        
                    If .bidSize > 0 Then
                        dataTable(i + j, Col_BIDSIZE).value = .bidSize
                    Else
                        dataTable(i + j, Col_BIDSIZE).value = STR_EMPTY
                    End If
        
                    If .BidCumSize > 0 Then
                        dataTable(i + j, Col_BIDCUMQTY).value = .BidCumSize
                    Else
                        dataTable(i + j, Col_BIDCUMQTY).value = STR_EMPTY
                    End If
        
                    If .BidAvgPrice > 0 Then
                        dataTable(i + j, Col_BIDAVGPRICE).value = .BidAvgPrice
                    Else
                        dataTable(i + j, Col_BIDAVGPRICE).value = STR_EMPTY
                    End If
                    
                    dataTable(i + j, Col_ASKMM).value = .AskMM
        
                    If .askPrice > 0 Then
                        dataTable(i + j, Col_ASKPRICE).value = .askPrice
                    Else
                        dataTable(i + j, Col_ASKPRICE).value = STR_EMPTY
                    End If
        
                    If .askSize > 0 Then
                        dataTable(i + j, Col_ASKSIZE).value = .askSize
                    Else
                        dataTable(i + j, Col_ASKSIZE).value = STR_EMPTY
                    End If
        
                    If .AskCumSize > 0 Then
                        dataTable(i + j, Col_ASKCUMQTY).value = .AskCumSize
                    Else
                        dataTable(i + j, Col_ASKCUMQTY).value = STR_EMPTY
                    End If
        
                    If .AskAvgPrice > 0 Then
                        dataTable(i + j, Col_ASKAVGPRICE).value = .AskAvgPrice
                    Else
                        dataTable(i + j, Col_ASKAVGPRICE).value = STR_EMPTY
                    End If

                End With
            Next j
        End If
    Next i
    
    If CanStartTimer() Then
        StartTimer
    Else
        StopTimer
    End If
    
End Sub

' Cancel Market Depth
Private Sub CancelMarketDepth_Click()
    CancelMarketDepthSubscription Range(ActiveCell, ActiveCell)
    ActiveCell.Offset(MKT_DEPTH_NUM_ROWS + 1, 0).Activate
End Sub

Private Sub CancelMarketDepthSubscription(sel As Range)
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer
    
    Dim row As Object
    For Each row In sel.Rows
        id = row.row - dataTable.Rows(1).row + 1
        
        If dataTable(id, Col_STATUS).value = STR_SUBSCRIBED Then
    
            ' update subscription status column
            dataTable(id, Col_STATUS).value = STR_EMPTY

            ' clear appropriate parts of arrays
            Dim i As Long
            For i = id To id + MKT_DEPTH_NUM_ROWS - 1
                With arMktDepth(i)
                    .BidMM = STR_EMPTY
                    .bidPrice = 0
                    .bidSize = 0
                    .BidCumSize = 0
                    .BidAvgPrice = 0
                    .AskMM = STR_EMPTY
                    .askPrice = 0
                    .askSize = 0
                    .AskCumSize = 0
                    .AskAvgPrice = 0
                End With
            Next i
            
            ' cancel market depth
            Api.Tws.CancelMktDepth id + ID_MKTDEPTH, checkBoxSmartDepth.value
            
        End If
    Next
End Sub

' Clear Market Depth table
Private Sub ClearMarketDepth_Click()

    If IsConnected Then CancelMarketDepthSubscription dataTable
    
    dataTable.ClearContents
End Sub

' Request Market Depth
Private Sub RequestMarketDepth_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer
    id = ActiveCell.row - dataTable.Rows(1).row + 1
    
    If contractTable(id, Col_SECTYPE).value <> STR_EMPTY Then
    
        ' create contract structure
        Dim lContractInfo As TWSLib.IContract
        Set lContractInfo = Api.Tws.createContract()

        With lContractInfo
            .Symbol = UCase(contractTable(id, Col_SYMBOL).value)
            .SecType = UCase(contractTable(id, Col_SECTYPE).value)
            .lastTradeDateOrContractMonth = contractTable(id, Col_LASTTRADEDATE).value
            .Strike = contractTable(id, Col_STRIKE).value
            .Right = UCase(contractTable(id, Col_RIGHT).value)
            .multiplier = UCase(contractTable(id, Col_MULTIPLIER).value)
            .exchange = UCase(contractTable(id, Col_EXCH).value)
            .primaryExchange = UCase(contractTable(id, Col_PRIMEXCH).value)
            .currency = UCase(contractTable(id, Col_CURRENCY).value)
            .localSymbol = UCase(contractTable(id, Col_LOCALSYMBOL).value)
        End With

        ' update subscription status column
        dataTable(id, Col_STATUS).value = STR_SUBSCRIBED
        
        ' start timer to begin updating of sheet
        If Not timerIsOn Then
             StartTimer
        End If
        
        ' mkt depth options
        Dim mktDepthOptions As TWSLib.ITagValueList
        Set mktDepthOptions = Api.Tws.createTagValueList()
        
        Api.Tws.ReqMktDepthEx id + ID_MKTDEPTH, lContractInfo, MKT_DEPTH_NUM_ROWS, checkBoxSmartDepth.value, mktDepthOptions
        
        ActiveCell.Offset(MKT_DEPTH_NUM_ROWS + 1, 0).Activate
    End If
End Sub

' calculation of cumQty and avgPrice
Private Sub CalculateCumSizeAvgPrice(id As Integer)
    Dim bidCumQty As Long
    Dim askCumQty As Long
    Dim bidTotalPrice As Double
    Dim askTotalPrice As Double
    
    bidCumQty = 0
    askCumQty = 0
    bidTotalPrice = 0
    askTotalPrice = 0
                
    Dim i As Long
    For i = 0 To MKT_DEPTH_NUM_ROWS - 1
        With arMktDepth(i + id - 1)
            If .bidPrice > 0 And .bidSize > 0 Then
                bidCumQty = bidCumQty + .bidSize
                bidTotalPrice = bidTotalPrice + .bidPrice * .bidSize
                .BidCumSize = bidCumQty
                .BidAvgPrice = bidTotalPrice / bidCumQty
            Else
                .BidCumSize = 0
                .BidAvgPrice = 0
            End If
            
            If .askPrice > 0 And .askSize > 0 Then
            
                askCumQty = askCumQty + .askSize
                askTotalPrice = askTotalPrice + .askPrice * .askSize
                .AskCumSize = askCumQty
                .AskAvgPrice = askTotalPrice / askCumQty
            Else
                .AskCumSize = 0
                .AskAvgPrice = 0
            End If
        
        End With
    Next i
    
End Sub

' update market depth table
Sub UpdateMarketDepth(id As Long, position As Long, marketMaker As String, operation As Long, side As Long, price As Double, size As Long)
    
    id = id - ID_MKTDEPTH - 1

    If position < MKT_DEPTH_NUM_ROWS Then
    
        Select Case operation
            Case MKT_DEPTH_OPER_INS
                
                If side = MKT_DEPTH_SIDE_BID Then
                    Dim i As Long
                    For i = MKT_DEPTH_NUM_ROWS - 2 To position Step -1
                        arMktDepth(id + i + 1).BidMM = arMktDepth(id + i).BidMM
                        arMktDepth(id + i + 1).bidPrice = arMktDepth(id + i).bidPrice
                        arMktDepth(id + i + 1).bidSize = arMktDepth(id + i).bidSize
                    Next i
                    With arMktDepth(id + position)
                        .BidMM = marketMaker
                        .bidPrice = price
                        .bidSize = size
                    End With
                
                ElseIf side = MKT_DEPTH_SIDE_ASK Then
                    For i = MKT_DEPTH_NUM_ROWS - 2 To position Step -1
                        arMktDepth(id + i + 1).AskMM = arMktDepth(id + i).AskMM
                        arMktDepth(id + i + 1).askPrice = arMktDepth(id + i).askPrice
                        arMktDepth(id + i + 1).askSize = arMktDepth(id + i).askSize
                    Next i
                    With arMktDepth(id + position)
                        .AskMM = marketMaker
                        .askPrice = price
                        .askSize = size
                    End With
                End If
 
            Case MKT_DEPTH_OPER_UPD
                If side = MKT_DEPTH_SIDE_BID Then
                    With arMktDepth(id + position)
                        .BidMM = marketMaker
                        .bidPrice = price
                        .bidSize = size
                    End With
                ElseIf side = MKT_DEPTH_SIDE_ASK Then
                    With arMktDepth(id + position)
                        .AskMM = marketMaker
                        .askPrice = price
                        .askSize = size
                    End With
                End If
           
            Case MKT_DEPTH_OPER_DEL
                If side = MKT_DEPTH_SIDE_BID Then
                    For i = position To MKT_DEPTH_NUM_ROWS - 2
                        arMktDepth(id + i).BidMM = arMktDepth(id + i + 1).BidMM
                        arMktDepth(id + i).bidPrice = arMktDepth(id + i + 1).bidPrice
                        arMktDepth(id + i).bidSize = arMktDepth(id + i + 1).bidSize
                    Next i
                    With arMktDepth(id + MKT_DEPTH_NUM_ROWS - 1)
                        .BidMM = STR_EMPTY
                        .bidPrice = 0
                        .bidSize = 0
                    End With
                
                ElseIf side = MKT_DEPTH_SIDE_ASK Then
                    For i = position To MKT_DEPTH_NUM_ROWS - 2
                        arMktDepth(id + i).AskMM = arMktDepth(id + i + 1).AskMM
                        arMktDepth(id + i).askPrice = arMktDepth(id + i + 1).askPrice
                        arMktDepth(id + i).askSize = arMktDepth(id + i + 1).askSize
                    Next i
                    With arMktDepth(id + MKT_DEPTH_NUM_ROWS - 1)
                        .AskMM = STR_EMPTY
                        .askPrice = 0
                        .askSize = 0
                    End With
                
                End If
        
        End Select

    End If

End Sub

' process error
Public Sub ProcessError(ByVal id As Long, ByVal errorCode As Long, ByVal errorMsg As String)

    ' handle errors
    If errorCode = ERROR_DUPLICATE_TICKER_ID Then
        MsgBox STR_ALREADY_SUBSCRIBED
    Else
        dataTable(id - ID_MKTDEPTH, Col_STATUS).value = STR_ERROR + STR_COLON + Str(errorCode) + STR_SPACE + errorMsg
    End If

End Sub

Private Function CanStartTimer() As Boolean
    CanStartTimer = False
    Dim i As Long
    For i = 1 To dataTable.Rows.Count Step 1
        If dataTable(i, Col_STATUS).value = STR_SUBSCRIBED Then
            CanStartTimer = True
            Exit For
        End If
    Next i
End Function

' Request Market Depth Exchanges
Private Sub ReqMktDepthExchanges_Click()
    If Not CheckConnected Then Exit Sub
    
    Api.Tws.ReqMktDepthExchanges
End Sub

' Clear Market Depth Exchanges
Private Sub ClearMktDepthExchanges_Click()
    exchangesTable.ClearContents
End Sub

Sub MktDepthExchanges(ByVal depthMktDataDescriptions As TWSLib.IDepthMktDataDescriptionList)
    exchangesTable.ClearContents
    Dim depthMktDataDescription As TWSLib.ComDepthMktDataDescription
    
    Dim i As Long
    For i = 1 To depthMktDataDescriptions.Count
        Set depthMktDataDescription = depthMktDataDescriptions.Item(i)
        exchangesTable(i, Col_DEPTHMKTDATADESCRIPTION_EXCHANGE).value = depthMktDataDescription.exchange
        exchangesTable(i, Col_DEPTHMKTDATADESCRIPTION_SECTYPE).value = depthMktDataDescription.SecType
        exchangesTable(i, Col_DEPTHMKTDATADESCRIPTION_LISTINGEXCH).value = depthMktDataDescription.listingExch
        exchangesTable(i, Col_DEPTHMKTDATADESCRIPTION_SERVICEDATATYPE).value = depthMktDataDescription.serviceDataType
        If depthMktDataDescription.aggGroup <> 2147483647 Then
            exchangesTable(i, Col_DEPTHMKTDATADESCRIPTION_AGGGROUP).value = depthMktDataDescription.aggGroup
        End If
    Next
End Sub

