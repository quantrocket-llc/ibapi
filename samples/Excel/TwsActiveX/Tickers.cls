VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Tickers"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Const CELL_GENERIC_TICK_LIST = "C4"
Const CELL_REFRESH_RATE = "F6"
Const CELL_MARKET_DATA_TYPE = "Q4"

Public Enum ContractColumns
    Col_SYMBOL = 1
    Col_SECTYPE
    Col_LASTTRADEDATE
    Col_STRIKE
    Col_RIGHT
    Col_MULTIPLIER
    Col_EXCH
    Col_PRIMEXCH
    Col_CURRENCY
    Col_LOCALSYMBOL
    Col_CONID
    Col_COMBOLEGS
    Col_DELTANEUTRALCONTRACT
    Col_OPTPRICE
    Col_OPTVOLATILITY
    Col_UNDERPRICE
End Enum

Public Enum TickerColumns
    Col_TICKER_STATUS = 1
    Col_CALCIMPLVOLSTATUS
    Col_CALCOPTPRICESTATUS
    Col_MARKETDATATYPE
    Col_LASTTIMESTAMP

' main market data
    Col_BIDEXCH
    Col_BIDSIZE
    Col_BIDPRICE
    Col_ASKPRICE
    Col_ASKSIZE
    Col_ASKEXCH
    Col_LASTPRICE
    Col_LASTSIZE
    Col_HIGHPRICE
    Col_LOWPRICE
    Col_VOLUME
    Col_CLOSEPRICE
    Col_OPENPRICE
    Col_MARKPRICE
    Col_AUCTIONPRICE
    Col_AUCTIONVOLUME
    Col_AUCTIONIMBALANCE
    Col_AVGVOLUME
    Col_OPENINTEREST
    Col_INDEXFUTUREPREMIUM
    Col_SHORTABLE
    Col_SHORTABLESHARES
    Col_RTVOLUME
    Col_HALTED
    Col_TRADECOUNT
    Col_TRADERATE
    Col_VOLUMERATE
    Col_LASTRTHTRADE
    Col_BIDCANAUTOEXECUTE
    Col_BIDPASTLIMIT
    Col_PREOPENBID
    Col_ASKCANAUTOEXECUTE
    Col_ASKPASTLIMIT
    Col_PREOPENASK
    Col_AVGOPTVOLUME
    
' historical
    Col_LOW13WEEK
    Col_HIGH13WEEK
    Col_LOW26WEEK
    Col_HIGH26WEEK
    Col_LOW52WEEK
    Col_HIGH52WEEK

' options
    Col_OPTCALLOPENINTEREST
    Col_OPTPUTOPENINTEREST
    Col_OPTCALLVOLUME
    Col_OPTPUTVOLUME
    Col_OPTBIDEXCH
    Col_OPTASKEXCH
    Col_OPTHISTVOLUME
    Col_OPTIMPLVOLUME

' yields
    Col_BIDYIELD
    Col_ASKYIELD
    Col_LASTYIELD

' option computation
    Col_OPTMODIMPLVOL
    Col_OPTMODDELTA
    Col_OPTMODOPTPRICE
    Col_OPTMODPVDIVIDEND
    Col_OPTMODGAMMA
    Col_OPTMODVEGA
    Col_OPTMODTHETA
    Col_OPTMODUNDPRICE

    Col_BIDIMPLVOL
    Col_BIDDELTA
    Col_BIDOPTPRICE
    Col_BIDPVDIVIDEND
    Col_BIDGAMMA
    Col_BIDVEGA
    Col_BIDTHETA
    Col_BIDUNDPRICE

    Col_ASKIMPLVOL
    Col_ASKDELTA
    Col_ASKOPTPRICE
    Col_ASKPVDIVIDEND
    Col_ASKGAMMA
    Col_ASKVEGA
    Col_ASKTHETA
    Col_ASKUNDPRICE

    Col_LASTIMPLVOL
    Col_LASTDELTA
    Col_LASTOPTPRICE
    Col_LASTPVDIVIDEND
    Col_LASTGAMMA
    Col_LASTVEGA
    Col_LASTTHETA
    Col_LASTUNDPRICE

' custom option computation
    Col_CUSTOMIMPLVOL_IV
    Col_CUSTOMDELTA_IV
    Col_CUSTOMOPTPRICE_IV
    Col_CUSTOMPVDIVIDEND_IV
    Col_CUSTOMGAMMA_IV
    Col_CUSTOMVEGA_IV
    Col_CUSTOMTHETA_IV
    Col_CUSTOMUNDPRICE_IV

    Col_CUSTOMIMPLVOL_OP
    Col_CUSTOMDELTA_OP
    Col_CUSTOMOPTPRICE_OP
    Col_CUSTOMPVDIVIDEND_OP
    Col_CUSTOMGAMMA_OP
    Col_CUSTOMVEGA_OP
    Col_CUSTOMTHETA_OP
    Col_CUSTOMUNDPRICE_OP

' EFP columns
    Col_EFPHOLDDAYS
    Col_EFPFUTUREEXPIRY
    Col_EFPDIVIDENDSTOEXPIRY

    Col_EFPBIDBASISPOINTS
    Col_EFPBIDFORMATTEDBASISPOINTS
    Col_EFPBIDTOTALDIVIDENDS
    Col_EFPBIDDIVIDENDIMPACT
    Col_EFPASKBASISPOINTS
    Col_EFPASKFORMATTEDBASISPOINTS
    Col_EFPASKTOTALDIVIDENDS
    Col_EFPASKDIVIDENDIMPACT
    Col_EFPLASTBASISPOINTS
    Col_EFPLASTFORMATTEDBASISPOINTS
    Col_EFPLASTTOTALDIVIDENDS
    Col_EFPLASTDIVIDENDIMPACT
    Col_EFPOPENBASISPOINTS
    Col_EFPOPENFORMATTEDBASISPOINTS
    Col_EFPOPENTOTALDIVIDENDS
    Col_EFPOPENDIVIDENDIMPACT
    Col_EFPHIGHBASISPOINTS
    Col_EFPHIGHFORMATTEDBASISPOINTS
    Col_EFPHIGHTOTALDIVIDENDS
    Col_EFPHIGHDIVIDENDIMPACT
    Col_EFPLOWBASISPOINTS
    Col_EFPLOWFORMATTEDBASISPOINTS
    Col_EFPLOWTOTALDIVIDENDS
    Col_EFPLOWDIVIDENDIMPACT
    Col_EFPCLOSEBASISPOINTS
    Col_EFPCLOSEFORMATTEDBASISPOINTS
    Col_EFPCLOSETOTALDIVIDENDS
    Col_EFPCLOSEDIVIDENDIMPACT
End Enum

' MktDataRecord (tickers)
Private Type MktDataRecord
    
    SecType As String
    
    ' tick price
    bidPrice As Double
    askPrice As Double
    BidAttr As MktDataAttr
    AskAttr As MktDataAttr
    LastPrice As Double
    HighTick As Double
    LowTick As Double
    ClosePrice As Double
    OpenPrice As Double
    Low13Week As Double
    High13Week As Double
    Low26Week As Double
    High26Week As Double
    Low52Week As Double
    High52Week As Double
    MarkPrice As Double
    AuctionPrice As Double
    
    ' tick size
    bidSize As Long
    askSize As Long
    LastSize As Long
    VolumeTick As Long
    AvgVolume As Long
    OptCallOpenInterest As Long
    OptPutOpenInterest As Long
    OptCallVolume As Long
    OptPutVolume As Long
    OpenInterest As Long
    AuctionVolume As Long
    AuctionImbalance As Long
    AvgOptVolume As Long
    
    ' tick string
    LastTimeStamp As String
    BidExch As String
    AskExch As String
    OptBidExch As String
    OptAskExch As String

    ' tick option computation
    OptModelImplVol As Double
    OptModelDelta As Double
    OptModelOptPrice As Double
    OptModelPVDiv As Double
    OptModelGamma As Double
    OptModelVega As Double
    OptModelTheta As Double
    OptModelUndPrice As Double
    
    BidImplVol As Double
    BidDelta As Double
    BidOptPrice As Double
    BidPVDiv As Double
    BidGamma As Double
    BidVega As Double
    BidTheta As Double
    BidUndPrice As Double
    
    AskImplVol As Double
    AskDelta As Double
    AskOptPrice As Double
    AskPVDiv As Double
    AskGamma As Double
    AskVega As Double
    AskTheta As Double
    AskUndPrice As Double

    LastImplVol As Double
    LastDelta As Double
    LastOptPrice As Double
    LastPVDiv As Double
    LastGamma As Double
    LastVega As Double
    LastTheta As Double
    LastUndPrice As Double

    ' tick EFP
    EFPHoldDays As Long
    EFPFutureExpiry As String
    EFPDividendsToExpiry As Double

    EFPBidBasisPoints As Double
    EFPBidFormattedBasisPoints As String
    EFPBidTotalDividends As Double
    EFPBidDividendImpact As Double
    EFPAskBasisPoints As Double
    EFPAskFormattedBasisPoints As String
    EFPAskTotalDividends As Double
    EFPAskDividendImpact As Double
    EFPLastBasisPoints As Double
    EFPLastFormattedBasisPoints As String
    EFPLastTotalDividends As Double
    EFPLastDividendImpact As Double
    
    EFPOpenBasisPoints As Double
    EFPOpenFormattedBasisPoints As String
    EFPOpenTotalDividends As Double
    EFPOpenDividendImpact As Double
    EFPHighBasisPoints As Double
    EFPHighFormattedBasisPoints As String
    EFPHighTotalDividends As Double
    EFPHighDividendImpact As Double
    EFPLowBasisPoints As Double
    EFPLowFormattedBasisPoints As String
    EFPLowTotalDividends As Double
    EFPLowDividendImpact As Double
    EFPCloseBasisPoints As Double
    EFPCloseFormattedBasisPoints As String
    EFPCloseTotalDividends As Double
    EFPCloseDividendImpact As Double

    OptHistVolume As Double
    OptImplVolume As Double
    IndexFuturePremium As Double
    Shortable As Double
    ShortableShares As Long
    RTVolume As String
    Halted As String
    TradeCount As Double
    TradeRate As Double
    VolumeRate As Double
    LastRTHTrade As Double
    
    ' yields
    BidYield As Double
    AskYield As Double
    LastYield As Double
End Type

' variables

Private contractTable As Range
Private tickerDataTable As Range


' timer
Public RunWhen As Double
Public RunWhat As String
Public timerIsArmed As Boolean
Public timerLastArmed As Date

' refresh table when it is inactive
Public refreshWhenInactive As Boolean

' array for data
Private arMktData() As MktDataRecord

'=================
' methods
'=================
Private Sub RefreshInactive_Click()
    refreshWhenInactive = RefreshInactive.value
    'MsgBox refreshWhenInactive
End Sub

Public Sub Initialise()
    Set tickerDataTable = Tickers.Range("$Q$11:$EU$128")
    Set contractTable = Tickers.Range("$A$11:$P$128")
End Sub

Private Sub Worksheet_Activate()
    On Error GoTo Err
    
    Main.Initialise

    Dim ub As Long
    ub = UBound(arMktData)
    
    Dim macroName As String
    macroName = Tickers.CodeName & ".RequestMarketData_Click"
    
    Application.OnKey "+^r", macroName

    refreshWhenInactive = RefreshInactive.value
    If Not timerIsArmed Then
        ArmTimer
    End If
    
    Exit Sub

Err:
    If Err.Number = 9 Then
         ReDim arMktData(tickerDataTable.Rows.Count) As MktDataRecord
         Resume Next
    End If
End Sub

Private Sub Worksheet_Deactivate()
    Application.OnKey "+^r"
End Sub

Private Function MaxDate(date1 As Date, date2 As Date) As Date
    If date1 >= date2 Then
        MaxDate = date1
    Else
        MaxDate = date2
    End If
End Function

' arm timer
Private Sub ArmTimer()
'MsgBox "ArmTimer: " & timerIsArmed
    If Tickers Is ThisWorkbook.ActiveSheet Or refreshWhenInactive Then
        If (Range(CELL_REFRESH_RATE).value >= 1 And Range(CELL_REFRESH_RATE).value <= 9) Then
            timerIsArmed = True
            
            RunWhen = MaxDate(Now, timerLastArmed + TimeValue("00:00:0" & Range(CELL_REFRESH_RATE).value))
            RunWhat = Tickers.CodeName & ".RepaintMktDataTable"
        
            Application.OnTime RunWhen, RunWhat, , True
        End If
    End If
End Sub

Private Sub RepaintMktDataRow(ByVal i As Long)
    With arMktData(i)
        ' all
        
        If tickerDataTable(i, Col_LASTTIMESTAMP).value <> Util.ConvertLongToDateStr(Val(.LastTimeStamp)) Then
            tickerDataTable(i, Col_LASTTIMESTAMP).value = Util.ConvertLongToDateStr(Val(.LastTimeStamp))
        End If
        If tickerDataTable(i, Col_BIDPRICE).value <> .bidPrice Then
            tickerDataTable(i, Col_BIDPRICE).value = .bidPrice
        End If
        If tickerDataTable(i, Col_ASKPRICE).value <> .askPrice Then
            tickerDataTable(i, Col_ASKPRICE).value = .askPrice
        End If
        If tickerDataTable(i, Col_LASTPRICE).value <> .LastPrice Then
            tickerDataTable(i, Col_LASTPRICE).value = .LastPrice
        End If
        If tickerDataTable(i, Col_BIDSIZE).value <> .bidSize Then
            tickerDataTable(i, Col_BIDSIZE).value = .bidSize
        End If
        If tickerDataTable(i, Col_ASKSIZE).value <> .askSize Then
            tickerDataTable(i, Col_ASKSIZE).value = .askSize
        End If
        If tickerDataTable(i, Col_HIGHPRICE).value <> .HighTick Then
            tickerDataTable(i, Col_HIGHPRICE).value = .HighTick
        End If
        If tickerDataTable(i, Col_LOWPRICE).value <> .LowTick Then
            tickerDataTable(i, Col_LOWPRICE).value = .LowTick
        End If
        If tickerDataTable(i, Col_CLOSEPRICE).value <> .ClosePrice Then
            tickerDataTable(i, Col_CLOSEPRICE).value = .ClosePrice
        End If
        If tickerDataTable(i, Col_OPENPRICE).value <> .OpenPrice Then
            tickerDataTable(i, Col_OPENPRICE).value = .OpenPrice
        End If
        If tickerDataTable(i, Col_LASTSIZE).value <> .LastSize Then
            tickerDataTable(i, Col_LASTSIZE).value = .LastSize
        End If
        If tickerDataTable(i, Col_VOLUME).value <> .VolumeTick Then
            tickerDataTable(i, Col_VOLUME).value = .VolumeTick
        End If
        If tickerDataTable(i, Col_LOW13WEEK).value <> .Low13Week Then
            tickerDataTable(i, Col_LOW13WEEK).value = .Low13Week
        End If
        If tickerDataTable(i, Col_LOW26WEEK).value <> .Low26Week Then
            tickerDataTable(i, Col_LOW26WEEK).value = .Low26Week
        End If
        If tickerDataTable(i, Col_LOW52WEEK).value <> .Low52Week Then
            tickerDataTable(i, Col_LOW52WEEK).value = .Low52Week
        End If
        If tickerDataTable(i, Col_HIGH13WEEK).value <> .High13Week Then
            tickerDataTable(i, Col_HIGH13WEEK).value = .High13Week
        End If
        If tickerDataTable(i, Col_HIGH26WEEK).value <> .High26Week Then
            tickerDataTable(i, Col_HIGH26WEEK).value = .High26Week
        End If
        If tickerDataTable(i, Col_HIGH52WEEK).value <> .High52Week Then
            tickerDataTable(i, Col_HIGH52WEEK).value = .High52Week
        End If
        If tickerDataTable(i, Col_MARKPRICE).value <> .MarkPrice Then
            tickerDataTable(i, Col_MARKPRICE).value = .MarkPrice
        End If
        If tickerDataTable(i, Col_AUCTIONPRICE).value <> .AuctionPrice Then
            tickerDataTable(i, Col_AUCTIONPRICE).value = .AuctionPrice
        End If
        If tickerDataTable(i, Col_AVGVOLUME).value <> .AvgVolume Then
            tickerDataTable(i, Col_AVGVOLUME).value = .AvgVolume
        End If
        If tickerDataTable(i, Col_OPENINTEREST).value <> .OpenInterest Then
            tickerDataTable(i, Col_OPENINTEREST).value = .OpenInterest
        End If
        If tickerDataTable(i, Col_AUCTIONVOLUME).value <> .AuctionVolume Then
            tickerDataTable(i, Col_AUCTIONVOLUME).value = .AuctionVolume
        End If
        If tickerDataTable(i, Col_AUCTIONIMBALANCE).value <> .AuctionImbalance Then
            tickerDataTable(i, Col_AUCTIONIMBALANCE).value = .AuctionImbalance
        End If
        If tickerDataTable(i, Col_BIDEXCH).value <> .BidExch Then
            tickerDataTable(i, Col_BIDEXCH).value = .BidExch
        End If
        If tickerDataTable(i, Col_ASKEXCH).value <> .AskExch Then
            tickerDataTable(i, Col_ASKEXCH).value = .AskExch
        End If
        If tickerDataTable(i, Col_INDEXFUTUREPREMIUM).value <> .IndexFuturePremium Then
            tickerDataTable(i, Col_INDEXFUTUREPREMIUM).value = .IndexFuturePremium
        End If
        If tickerDataTable(i, Col_SHORTABLE).value <> .Shortable Then
            tickerDataTable(i, Col_SHORTABLE).value = .Shortable
        End If
        If tickerDataTable(i, Col_SHORTABLESHARES).value <> .ShortableShares Then
            tickerDataTable(i, Col_SHORTABLESHARES).value = .ShortableShares
        End If
        If tickerDataTable(i, Col_RTVOLUME).value <> .RTVolume Then
            tickerDataTable(i, Col_RTVOLUME).value = .RTVolume
        End If
        If tickerDataTable(i, Col_HALTED).value <> .Halted Then
            tickerDataTable(i, Col_HALTED).value = .Halted
        End If
        If tickerDataTable(i, Col_TRADECOUNT).value <> .TradeCount Then
            tickerDataTable(i, Col_TRADECOUNT).value = .TradeCount
        End If
        If tickerDataTable(i, Col_TRADERATE).value <> .TradeRate Then
            tickerDataTable(i, Col_TRADERATE).value = .TradeRate
        End If
        If tickerDataTable(i, Col_VOLUMERATE).value <> .VolumeRate Then
            tickerDataTable(i, Col_VOLUMERATE).value = .VolumeRate
        End If
        If tickerDataTable(i, Col_LASTRTHTRADE).value <> .LastRTHTrade Then
            tickerDataTable(i, Col_LASTRTHTRADE).value = .LastRTHTrade
        End If
        If tickerDataTable(i, Col_BIDCANAUTOEXECUTE).value <> .BidAttr.CanAutoExecute Then
            tickerDataTable(i, Col_BIDCANAUTOEXECUTE).value = .BidAttr.CanAutoExecute
        End If
        If tickerDataTable(i, Col_BIDPASTLIMIT).value <> .BidAttr.PastLimit Then
            tickerDataTable(i, Col_BIDPASTLIMIT).value = .BidAttr.PastLimit
        End If
        If tickerDataTable(i, Col_PREOPENBID).value <> .BidAttr.PreOpen Then
            tickerDataTable(i, Col_PREOPENBID).value = .BidAttr.PreOpen
        End If
        If tickerDataTable(i, Col_ASKCANAUTOEXECUTE).value <> .AskAttr.CanAutoExecute Then
            tickerDataTable(i, Col_ASKCANAUTOEXECUTE).value = .AskAttr.CanAutoExecute
        End If
        If tickerDataTable(i, Col_ASKPASTLIMIT).value <> .AskAttr.PastLimit Then
            tickerDataTable(i, Col_ASKPASTLIMIT).value = .AskAttr.PastLimit
        End If
        If tickerDataTable(i, Col_PREOPENASK).value <> .AskAttr.PreOpen Then
            tickerDataTable(i, Col_PREOPENASK).value = .AskAttr.PreOpen
        End If
        If tickerDataTable(i, Col_AVGOPTVOLUME).value <> .AvgOptVolume Then
            tickerDataTable(i, Col_AVGOPTVOLUME).value = .AvgOptVolume
        End If
        
        
        ' Bonds
        If .SecType = Util.SECTYPE_BOND Or tickerDataTable(i, Col_CONID).value <> STR_EMPTY Then
            'yields
            If tickerDataTable(i, Col_BIDYIELD).value <> .BidYield Then
                tickerDataTable(i, Col_BIDYIELD).value = .BidYield
            End If
            If tickerDataTable(i, Col_ASKYIELD).value <> .AskYield Then
                tickerDataTable(i, Col_ASKYIELD).value = .AskYield
            End If
            If tickerDataTable(i, Col_LASTYIELD).value <> .LastYield Then
                tickerDataTable(i, Col_LASTYIELD).value = .LastYield
            End If
        End If
        
        ' OPT & FOP
        If .SecType = Util.SECTYPE_OPT Or .SecType = Util.SECTYPE_FOP _
            Or tickerDataTable(i, Col_CONID).value <> STR_EMPTY Then
            
            If tickerDataTable(i, Col_OPTCALLOPENINTEREST).value <> .OptCallOpenInterest Then
                tickerDataTable(i, Col_OPTCALLOPENINTEREST).value = .OptCallOpenInterest
            End If
            If tickerDataTable(i, Col_OPTPUTOPENINTEREST).value <> .OptPutOpenInterest Then
                tickerDataTable(i, Col_OPTPUTOPENINTEREST).value = .OptPutOpenInterest
            End If
            If tickerDataTable(i, Col_OPTCALLVOLUME).value <> .OptCallVolume Then
                tickerDataTable(i, Col_OPTCALLVOLUME).value = .OptCallVolume
            End If
            If tickerDataTable(i, Col_OPTPUTVOLUME).value <> .OptPutVolume Then
                tickerDataTable(i, Col_OPTPUTVOLUME).value = .OptPutVolume
            End If
            If tickerDataTable(i, Col_OPTBIDEXCH).value <> .OptBidExch Then
                tickerDataTable(i, Col_OPTBIDEXCH).value = .OptBidExch
            End If
            If tickerDataTable(i, Col_OPTASKEXCH).value <> .OptAskExch Then
                tickerDataTable(i, Col_OPTASKEXCH).value = .OptAskExch
            End If
            If tickerDataTable(i, Col_OPTHISTVOLUME).value <> .OptHistVolume Then
                tickerDataTable(i, Col_OPTHISTVOLUME).value = .OptHistVolume
            End If
            If tickerDataTable(i, Col_OPTIMPLVOLUME).value <> .OptImplVolume Then
                tickerDataTable(i, Col_OPTIMPLVOLUME).value = .OptImplVolume
            End If
            
            ' option model
            If tickerDataTable(i, Col_OPTMODIMPLVOL).value <> .OptModelImplVol Then
                If .OptModelImplVol = MaxDoubleValue Then
                    tickerDataTable(i, Col_OPTMODIMPLVOL).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_OPTMODIMPLVOL).value = .OptModelImplVol
                End If
            End If
            If tickerDataTable(i, Col_OPTMODDELTA).value <> .OptModelDelta Then
                If .OptModelDelta = MaxDoubleValue Then
                    tickerDataTable(i, Col_OPTMODDELTA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_OPTMODDELTA).value = .OptModelDelta
                End If
            End If
            If tickerDataTable(i, Col_OPTMODOPTPRICE).value <> .OptModelOptPrice Then
                If .OptModelOptPrice = MaxDoubleValue Then
                    tickerDataTable(i, Col_OPTMODOPTPRICE).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_OPTMODOPTPRICE).value = .OptModelOptPrice
                End If
            End If
            If tickerDataTable(i, Col_OPTMODPVDIVIDEND).value <> .OptModelPVDiv Then
                If .OptModelPVDiv = MaxDoubleValue Then
                    tickerDataTable(i, Col_OPTMODPVDIVIDEND).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_OPTMODPVDIVIDEND).value = .OptModelPVDiv
                End If
            End If
            If tickerDataTable(i, Col_OPTMODGAMMA).value <> .OptModelGamma Then
                If .OptModelGamma = MaxDoubleValue Then
                    tickerDataTable(i, Col_OPTMODGAMMA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_OPTMODGAMMA).value = .OptModelGamma
                End If
            End If
            If tickerDataTable(i, Col_OPTMODVEGA).value <> .OptModelVega Then
                If .OptModelVega = MaxDoubleValue Then
                    tickerDataTable(i, Col_OPTMODVEGA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_OPTMODVEGA).value = .OptModelVega
                End If
            End If
            If tickerDataTable(i, Col_OPTMODTHETA).value <> .OptModelTheta Then
                If .OptModelTheta = MaxDoubleValue Then
                    tickerDataTable(i, Col_OPTMODTHETA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_OPTMODTHETA).value = .OptModelTheta
                End If
            End If
            If tickerDataTable(i, Col_OPTMODUNDPRICE).value <> .OptModelUndPrice Then
                If .OptModelUndPrice = MaxDoubleValue Then
                    tickerDataTable(i, Col_OPTMODUNDPRICE).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_OPTMODUNDPRICE).value = .OptModelUndPrice
                End If
            End If
            
            ' bid
            If tickerDataTable(i, Col_BIDIMPLVOL).value <> .BidImplVol Then
                If .BidImplVol = MaxDoubleValue Then
                    tickerDataTable(i, Col_BIDIMPLVOL).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_BIDIMPLVOL).value = .BidImplVol
                End If
            End If
            If tickerDataTable(i, Col_BIDDELTA).value <> .BidDelta Then
                If .BidDelta = MaxDoubleValue Then
                    tickerDataTable(i, Col_BIDDELTA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_BIDDELTA).value = .BidDelta
                End If
            End If
            If tickerDataTable(i, Col_BIDOPTPRICE).value <> .BidOptPrice Then
                If .BidOptPrice = MaxDoubleValue Then
                    tickerDataTable(i, Col_BIDOPTPRICE).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_BIDOPTPRICE).value = .BidOptPrice
                End If
            End If
            If tickerDataTable(i, Col_BIDPVDIVIDEND).value <> .BidPVDiv Then
                If .BidPVDiv = MaxDoubleValue Then
                    tickerDataTable(i, Col_BIDPVDIVIDEND).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_BIDPVDIVIDEND).value = .BidPVDiv
                End If
            End If
            If tickerDataTable(i, Col_BIDGAMMA).value <> .BidGamma Then
                If .BidGamma = MaxDoubleValue Then
                    tickerDataTable(i, Col_BIDGAMMA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_BIDGAMMA).value = .BidGamma
                End If
            End If
            If tickerDataTable(i, Col_BIDVEGA).value <> .BidVega Then
                If .BidVega = MaxDoubleValue Then
                    tickerDataTable(i, Col_BIDVEGA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_BIDVEGA).value = .BidVega
                End If
            End If
            If tickerDataTable(i, Col_BIDTHETA).value <> .BidTheta Then
                If .BidTheta = MaxDoubleValue Then
                    tickerDataTable(i, Col_BIDTHETA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_BIDTHETA).value = .BidTheta
                End If
            End If
            If tickerDataTable(i, Col_BIDUNDPRICE).value <> .BidUndPrice Then
                If .BidUndPrice = MaxDoubleValue Then
                    tickerDataTable(i, Col_BIDUNDPRICE).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_BIDUNDPRICE).value = .BidUndPrice
                End If
            End If

            ' ask
            If tickerDataTable(i, Col_ASKIMPLVOL).value <> .AskImplVol Then
                If .AskImplVol = MaxDoubleValue Then
                    tickerDataTable(i, Col_ASKIMPLVOL).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_ASKIMPLVOL).value = .AskImplVol
                End If
            End If
            If tickerDataTable(i, Col_ASKDELTA).value <> .AskDelta Then
                If .AskDelta = MaxDoubleValue Then
                    tickerDataTable(i, Col_ASKDELTA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_ASKDELTA).value = .AskDelta
                End If
            End If
            If tickerDataTable(i, Col_ASKOPTPRICE).value <> .AskOptPrice Then
                If .AskOptPrice = MaxDoubleValue Then
                    tickerDataTable(i, Col_ASKOPTPRICE).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_ASKOPTPRICE).value = .AskOptPrice
                End If
            End If
            If tickerDataTable(i, Col_ASKPVDIVIDEND).value <> .AskPVDiv Then
                If .AskPVDiv = MaxDoubleValue Then
                    tickerDataTable(i, Col_ASKPVDIVIDEND).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_ASKPVDIVIDEND).value = .AskPVDiv
                End If
            End If
            If tickerDataTable(i, Col_ASKGAMMA).value <> .AskGamma Then
                If .AskGamma = MaxDoubleValue Then
                    tickerDataTable(i, Col_ASKGAMMA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_ASKGAMMA).value = .AskGamma
                End If
            End If
            If tickerDataTable(i, Col_ASKVEGA).value <> .AskVega Then
                If .AskVega = MaxDoubleValue Then
                    tickerDataTable(i, Col_ASKVEGA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_ASKVEGA).value = .AskVega
                End If
            End If
            If tickerDataTable(i, Col_ASKTHETA).value <> .AskTheta Then
                If .AskTheta = MaxDoubleValue Then
                    tickerDataTable(i, Col_ASKTHETA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_ASKTHETA).value = .AskTheta
                End If
            End If
            If tickerDataTable(i, Col_ASKUNDPRICE).value <> .AskUndPrice Then
                If .AskUndPrice = MaxDoubleValue Then
                    tickerDataTable(i, Col_ASKUNDPRICE).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_ASKUNDPRICE).value = .AskUndPrice
                End If
            End If

            ' last
            If tickerDataTable(i, Col_LASTIMPLVOL).value <> .LastImplVol Then
                If .LastImplVol = MaxDoubleValue Then
                    tickerDataTable(i, Col_LASTIMPLVOL).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_LASTIMPLVOL).value = .LastImplVol
                End If
            End If
            If tickerDataTable(i, Col_LASTDELTA).value <> .LastDelta Then
                If .LastDelta = MaxDoubleValue Then
                    tickerDataTable(i, Col_LASTDELTA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_LASTDELTA).value = .LastDelta
                End If
            End If
            If tickerDataTable(i, Col_LASTOPTPRICE).value <> .LastOptPrice Then
                If .LastOptPrice = MaxDoubleValue Then
                    tickerDataTable(i, Col_LASTOPTPRICE).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_LASTOPTPRICE).value = .LastOptPrice
                End If
            End If
            If tickerDataTable(i, Col_LASTPVDIVIDEND).value <> .LastPVDiv Then
                If .LastPVDiv = MaxDoubleValue Then
                    tickerDataTable(i, Col_LASTPVDIVIDEND).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_LASTPVDIVIDEND).value = .LastPVDiv
                End If
            End If
            If tickerDataTable(i, Col_LASTGAMMA).value <> .LastGamma Then
                If .LastGamma = MaxDoubleValue Then
                    tickerDataTable(i, Col_LASTGAMMA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_LASTGAMMA).value = .LastGamma
                End If
            End If
            If tickerDataTable(i, Col_LASTVEGA).value <> .LastVega Then
                If .LastVega = MaxDoubleValue Then
                    tickerDataTable(i, Col_LASTVEGA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_LASTVEGA).value = .LastVega
                End If
            End If
            If tickerDataTable(i, Col_LASTTHETA).value <> .LastTheta Then
                If .LastTheta = MaxDoubleValue Then
                    tickerDataTable(i, Col_LASTTHETA).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_LASTTHETA).value = .LastTheta
                End If
            End If
            If tickerDataTable(i, Col_LASTUNDPRICE).value <> .LastUndPrice Then
                If .LastUndPrice = MaxDoubleValue Then
                    tickerDataTable(i, Col_LASTUNDPRICE).value = STR_NOT_AVAILABLE
                Else
                    tickerDataTable(i, Col_LASTUNDPRICE).value = .LastUndPrice
                End If
            End If

        End If
        
        ' EFP
        If .SecType = Util.SECTYPE_BAG Then
            If tickerDataTable(i, Col_EFPHOLDDAYS).value <> .EFPHoldDays Then
                tickerDataTable(i, Col_EFPHOLDDAYS).value = .EFPHoldDays
            End If
            If tickerDataTable(i, Col_EFPFUTUREEXPIRY).value <> .EFPFutureExpiry Then
                tickerDataTable(i, Col_EFPFUTUREEXPIRY).value = .EFPFutureExpiry
            End If
            If tickerDataTable(i, Col_EFPDIVIDENDSTOEXPIRY).value <> .EFPDividendsToExpiry Then
                tickerDataTable(i, Col_EFPDIVIDENDSTOEXPIRY).value = .EFPDividendsToExpiry
            End If
        
            If tickerDataTable(i, Col_EFPBIDBASISPOINTS).value <> .EFPBidBasisPoints Then
                tickerDataTable(i, Col_EFPBIDBASISPOINTS).value = .EFPBidBasisPoints
            End If
            If tickerDataTable(i, Col_EFPBIDFORMATTEDBASISPOINTS).value <> .EFPBidFormattedBasisPoints Then
                tickerDataTable(i, Col_EFPBIDFORMATTEDBASISPOINTS).value = .EFPBidFormattedBasisPoints
            End If
            If tickerDataTable(i, Col_EFPBIDTOTALDIVIDENDS).value <> .EFPBidTotalDividends Then
                tickerDataTable(i, Col_EFPBIDTOTALDIVIDENDS).value = .EFPBidTotalDividends
            End If
            If tickerDataTable(i, Col_EFPBIDDIVIDENDIMPACT).value <> .EFPBidDividendImpact Then
                tickerDataTable(i, Col_EFPBIDDIVIDENDIMPACT).value = .EFPBidDividendImpact
            End If
        
            If tickerDataTable(i, Col_EFPASKBASISPOINTS).value <> .EFPAskBasisPoints Then
                tickerDataTable(i, Col_EFPASKBASISPOINTS).value = .EFPAskBasisPoints
            End If
            If tickerDataTable(i, Col_EFPASKFORMATTEDBASISPOINTS).value <> .EFPAskFormattedBasisPoints Then
                tickerDataTable(i, Col_EFPASKFORMATTEDBASISPOINTS).value = .EFPAskFormattedBasisPoints
            End If
            If tickerDataTable(i, Col_EFPASKTOTALDIVIDENDS).value <> .EFPAskTotalDividends Then
                tickerDataTable(i, Col_EFPASKTOTALDIVIDENDS).value = .EFPAskTotalDividends
            End If
            If tickerDataTable(i, Col_EFPASKDIVIDENDIMPACT).value <> .EFPAskDividendImpact Then
                tickerDataTable(i, Col_EFPASKDIVIDENDIMPACT).value = .EFPAskDividendImpact
            End If
        
            If tickerDataTable(i, Col_EFPLASTBASISPOINTS).value <> .EFPLastBasisPoints Then
                tickerDataTable(i, Col_EFPLASTBASISPOINTS).value = .EFPLastBasisPoints
            End If
            If tickerDataTable(i, Col_EFPLASTFORMATTEDBASISPOINTS).value <> .EFPLastFormattedBasisPoints Then
                tickerDataTable(i, Col_EFPLASTFORMATTEDBASISPOINTS).value = .EFPLastFormattedBasisPoints
            End If
            If tickerDataTable(i, Col_EFPLASTTOTALDIVIDENDS).value <> .EFPLastTotalDividends Then
                tickerDataTable(i, Col_EFPLASTTOTALDIVIDENDS).value = .EFPLastTotalDividends
            End If
            If tickerDataTable(i, Col_EFPLASTDIVIDENDIMPACT).value <> .EFPLastDividendImpact Then
                tickerDataTable(i, Col_EFPLASTDIVIDENDIMPACT).value = .EFPLastDividendImpact
            End If
        
            If tickerDataTable(i, Col_EFPOPENBASISPOINTS).value <> .EFPOpenBasisPoints Then
                tickerDataTable(i, Col_EFPOPENBASISPOINTS).value = .EFPOpenBasisPoints
            End If
            If tickerDataTable(i, Col_EFPOPENFORMATTEDBASISPOINTS).value <> .EFPOpenFormattedBasisPoints Then
                tickerDataTable(i, Col_EFPOPENFORMATTEDBASISPOINTS).value = .EFPOpenFormattedBasisPoints
            End If
            If tickerDataTable(i, Col_EFPOPENTOTALDIVIDENDS).value <> .EFPOpenTotalDividends Then
                tickerDataTable(i, Col_EFPOPENTOTALDIVIDENDS).value = .EFPOpenTotalDividends
            End If
            If tickerDataTable(i, Col_EFPOPENDIVIDENDIMPACT).value <> .EFPOpenDividendImpact Then
                tickerDataTable(i, Col_EFPOPENDIVIDENDIMPACT).value = .EFPOpenDividendImpact
            End If
        
            If tickerDataTable(i, Col_EFPHIGHBASISPOINTS).value <> .EFPHighBasisPoints Then
                tickerDataTable(i, Col_EFPHIGHBASISPOINTS).value = .EFPHighBasisPoints
            End If
            If tickerDataTable(i, Col_EFPHIGHFORMATTEDBASISPOINTS).value <> .EFPHighFormattedBasisPoints Then
                tickerDataTable(i, Col_EFPHIGHFORMATTEDBASISPOINTS).value = .EFPHighFormattedBasisPoints
            End If
            If tickerDataTable(i, Col_EFPHIGHTOTALDIVIDENDS).value <> .EFPHighTotalDividends Then
                tickerDataTable(i, Col_EFPHIGHTOTALDIVIDENDS).value = .EFPHighTotalDividends
            End If
            If tickerDataTable(i, Col_EFPHIGHDIVIDENDIMPACT).value <> .EFPHighDividendImpact Then
                tickerDataTable(i, Col_EFPHIGHDIVIDENDIMPACT).value = .EFPHighDividendImpact
            End If
        
            If tickerDataTable(i, Col_EFPLOWBASISPOINTS).value <> .EFPLowBasisPoints Then
                tickerDataTable(i, Col_EFPLOWBASISPOINTS).value = .EFPLowBasisPoints
            End If
            If tickerDataTable(i, Col_EFPLOWFORMATTEDBASISPOINTS).value <> .EFPLowFormattedBasisPoints Then
                tickerDataTable(i, Col_EFPLOWFORMATTEDBASISPOINTS).value = .EFPLowFormattedBasisPoints
            End If
            If tickerDataTable(i, Col_EFPLOWTOTALDIVIDENDS).value <> .EFPLowTotalDividends Then
                tickerDataTable(i, Col_EFPLOWTOTALDIVIDENDS).value = .EFPLowTotalDividends
            End If
            If tickerDataTable(i, Col_EFPLOWDIVIDENDIMPACT).value <> .EFPLowDividendImpact Then
                tickerDataTable(i, Col_EFPLOWDIVIDENDIMPACT).value = .EFPLowDividendImpact
            End If
        
            If tickerDataTable(i, Col_EFPCLOSEBASISPOINTS).value <> .EFPCloseBasisPoints Then
                tickerDataTable(i, Col_EFPCLOSEBASISPOINTS).value = .EFPCloseBasisPoints
            End If
            If tickerDataTable(i, Col_EFPCLOSEFORMATTEDBASISPOINTS).value <> .EFPCloseFormattedBasisPoints Then
                tickerDataTable(i, Col_EFPCLOSEFORMATTEDBASISPOINTS).value = .EFPCloseFormattedBasisPoints
            End If
            If tickerDataTable(i, Col_EFPCLOSETOTALDIVIDENDS).value <> .EFPCloseTotalDividends Then
                tickerDataTable(i, Col_EFPCLOSETOTALDIVIDENDS).value = .EFPCloseTotalDividends
            End If
            If tickerDataTable(i, Col_EFPCLOSEDIVIDENDIMPACT).value <> .EFPCloseDividendImpact Then
                tickerDataTable(i, Col_EFPCLOSEDIVIDENDIMPACT).value = .EFPCloseDividendImpact
            End If
        End If
    
    End With
End Sub

' refresh market data table
Private Sub RepaintMktDataTable()
    'MsgBox "REPAINT"
   'Application.ScreenUpdating = False
    
    ' display records with "subscribed" status
    Dim i As Integer
    For i = 1 To tickerDataTable.Rows.Count
       ' market data
        If tickerDataTable(i, Col_TICKER_STATUS).value = STR_SUBSCRIBED Or _
            tickerDataTable(i, Col_TICKER_STATUS).value = STR_SNAPSHOT Then
            RepaintMktDataRow i
        End If
    Next
    
  '  Application.ScreenUpdating = True
    
    timerIsArmed = False
    timerLastArmed = Now

End Sub

' calculate implied volatility
Private Sub CalculateImpliedVolatility_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim index As Integer
    Dim optPrice As Double
    Dim underPrice As Double

    Dim row As Object
    For Each row In Selection.Rows
        index = row.row - contractTable.Rows(1).row + 1

        If (contractTable(index, Col_SECTYPE).value = SECTYPE_OPT _
            Or contractTable(index, Col_SECTYPE).value = SECTYPE_FOP _
            Or contractTable(index, Col_CONID).value <> STR_EMPTY) _
            And contractTable(index, Col_CALCIMPLVOLSTATUS).value <> STR_CALCULATED Then
            
            ' create contract
            Dim lContractInfo As TWSLib.IContract
            Set lContractInfo = Api.Tws.createContract()

            ' fill contract structure
            With lContractInfo
                .Symbol = UCase(contractTable(index, Col_SYMBOL).value)
                .SecType = UCase(contractTable(index, Col_SECTYPE).value)
                .lastTradeDateOrContractMonth = contractTable(index, Col_LASTTRADEDATE).value
                .Strike = contractTable(index, Col_STRIKE).value
                .Right = UCase(contractTable(index, Col_RIGHT).value)
                .multiplier = UCase(contractTable(index, Col_MULTIPLIER).value)
                .exchange = UCase(contractTable(index, Col_EXCH).value)
                .primaryExchange = UCase(contractTable(index, Col_PRIMEXCH).value)
                .currency = UCase(contractTable(index, Col_CURRENCY).value)
                .localSymbol = UCase(contractTable(index, Col_LOCALSYMBOL).value)
                .conId = contractTable(index, Col_CONID).value
            End With
            
            'opt Price, under Price
            optPrice = contractTable(index, Col_OPTPRICE).value
            underPrice = contractTable(index, Col_UNDERPRICE).value

            Api.Tws.CalculateImpliedVolatility index + ID_CALC_IMPL_VOL, lContractInfo, optPrice, underPrice
            
            ' update status column
            contractTable(index, Col_CALCIMPLVOLSTATUS).value = STR_CALCULATING

        End If

    Next
    ActiveCell.Offset(1, 0).Activate
End Sub

' calculate option price
Private Sub CalculateOptionPrice_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer
    Dim volatility As Double
    Dim underPrice As Double

    Dim row As Object
    For Each row In Selection.Rows
        id = row.row - contractTable.Rows(1).row + 1

        If (contractTable(id, Col_SECTYPE).value = SECTYPE_OPT _
            Or contractTable(id, Col_SECTYPE).value = SECTYPE_FOP _
            Or contractTable(id, Col_CONID).value <> STR_EMPTY) _
            And contractTable(id, Col_CALCOPTPRICESTATUS).value <> STR_CALCULATED Then

            ' create contract
            Dim lContractInfo As TWSLib.IContract
            Set lContractInfo = Api.Tws.createContract()

            ' fill contract structure
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
                .conId = contractTable(id, Col_CONID).value
            End With
            
            'volatility, under Price
            volatility = contractTable(id, Col_OPTVOLATILITY).value
            underPrice = contractTable(id, Col_UNDERPRICE).value

            ' update status column
            contractTable(id, Col_CALCOPTPRICESTATUS).value = STR_CALCULATING
            
            Api.Tws.CalculateOptionPrice id + ID_CALC_OPTION_PRICE, lContractInfo, volatility, underPrice

        End If

    Next
    ActiveCell.Offset(1, 0).Activate
End Sub

' cancel calculate implied volatility click
Private Sub CancelCalculateImpliedVolatility_Click()

    CancelCalculateImpliedVolatilitySubscription Selection
    
    ActiveCell.Offset(1, 0).Activate
    
End Sub

Private Sub CancelCalculateImpliedVolatilitySubscription(sel As Range)
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer

    Dim row As Object
    For Each row In sel.Rows
        id = row.row - contractTable.Rows(1).row + 1

        If contractTable(id, Col_CALCIMPLVOLSTATUS).value = STR_CALCULATED Or _
            contractTable(id, Col_CALCIMPLVOLSTATUS).value = STR_CALCULATING Then
            Api.Tws.CancelCalculateImpliedVolatility id + ID_CALC_IMPL_VOL
        
            ' clear appropriate cells
            ClearCustomCalculateImpliedVolatilityCells id
            
            ' update status column
            contractTable(id, Col_CALCIMPLVOLSTATUS).value = STR_EMPTY
        End If
    Next
End Sub

Private Sub ClearCustomCalculateImpliedVolatilityCells(row As Integer)
    tickerDataTable(row, Col_CUSTOMIMPLVOL_IV).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMDELTA_IV).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMOPTPRICE_IV).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMPVDIVIDEND_IV).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMGAMMA_IV).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMVEGA_IV).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMTHETA_IV).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMUNDPRICE_IV).value = STR_EMPTY
End Sub

Private Sub ClearCustomCalculateOptionPriceCells(row As Integer)
    tickerDataTable(row, Col_CUSTOMIMPLVOL_OP).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMDELTA_OP).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMOPTPRICE_OP).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMPVDIVIDEND_OP).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMGAMMA_OP).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMVEGA_OP).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMTHETA_OP).value = STR_EMPTY
    tickerDataTable(row, Col_CUSTOMUNDPRICE_OP).value = STR_EMPTY
End Sub

Private Sub ClearMarketDataCells(ByVal row As Integer)
    tickerDataTable(row, Col_LASTTIMESTAMP).value = STR_EMPTY
    tickerDataTable(row, Col_BIDEXCH).value = STR_EMPTY
    tickerDataTable(row, Col_BIDSIZE).value = STR_EMPTY
    tickerDataTable(row, Col_BIDPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_ASKPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_ASKSIZE).value = STR_EMPTY
    tickerDataTable(row, Col_ASKEXCH).value = STR_EMPTY
    tickerDataTable(row, Col_LASTPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_LASTSIZE).value = STR_EMPTY
    tickerDataTable(row, Col_HIGHPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_LOWPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_VOLUME).value = STR_EMPTY
    tickerDataTable(row, Col_CLOSEPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_OPENPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_MARKPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_AUCTIONPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_AUCTIONVOLUME).value = STR_EMPTY
    tickerDataTable(row, Col_AUCTIONIMBALANCE).value = STR_EMPTY
    tickerDataTable(row, Col_AVGVOLUME).value = STR_EMPTY
    tickerDataTable(row, Col_OPENINTEREST).value = STR_EMPTY
    tickerDataTable(row, Col_INDEXFUTUREPREMIUM).value = STR_EMPTY
    tickerDataTable(row, Col_SHORTABLE).value = STR_EMPTY
    tickerDataTable(row, Col_SHORTABLESHARES).value = STR_EMPTY
    tickerDataTable(row, Col_RTVOLUME).value = STR_EMPTY
    tickerDataTable(row, Col_HALTED).value = STR_EMPTY
    tickerDataTable(row, Col_TRADECOUNT).value = STR_EMPTY
    tickerDataTable(row, Col_TRADERATE).value = STR_EMPTY
    tickerDataTable(row, Col_VOLUMERATE).value = STR_EMPTY
    tickerDataTable(row, Col_LASTRTHTRADE).value = STR_EMPTY
    tickerDataTable(row, Col_AVGOPTVOLUME).value = STR_EMPTY
    tickerDataTable(row, Col_LOW13WEEK).value = STR_EMPTY
    tickerDataTable(row, Col_HIGH13WEEK).value = STR_EMPTY
    tickerDataTable(row, Col_LOW26WEEK).value = STR_EMPTY
    tickerDataTable(row, Col_HIGH26WEEK).value = STR_EMPTY
    tickerDataTable(row, Col_LOW52WEEK).value = STR_EMPTY
    tickerDataTable(row, Col_HIGH52WEEK).value = STR_EMPTY
    tickerDataTable(row, Col_OPTCALLOPENINTEREST).value = STR_EMPTY
    tickerDataTable(row, Col_OPTPUTOPENINTEREST).value = STR_EMPTY
    tickerDataTable(row, Col_OPTCALLVOLUME).value = STR_EMPTY
    tickerDataTable(row, Col_OPTPUTVOLUME).value = STR_EMPTY
    tickerDataTable(row, Col_OPTBIDEXCH).value = STR_EMPTY
    tickerDataTable(row, Col_OPTASKEXCH).value = STR_EMPTY
    tickerDataTable(row, Col_OPTHISTVOLUME).value = STR_EMPTY
    tickerDataTable(row, Col_OPTIMPLVOLUME).value = STR_EMPTY
    tickerDataTable(row, Col_BIDYIELD).value = STR_EMPTY
    tickerDataTable(row, Col_ASKYIELD).value = STR_EMPTY
    tickerDataTable(row, Col_LASTYIELD).value = STR_EMPTY
    tickerDataTable(row, Col_OPTMODIMPLVOL).value = STR_EMPTY
    tickerDataTable(row, Col_OPTMODDELTA).value = STR_EMPTY
    tickerDataTable(row, Col_OPTMODOPTPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_OPTMODPVDIVIDEND).value = STR_EMPTY
    tickerDataTable(row, Col_OPTMODGAMMA).value = STR_EMPTY
    tickerDataTable(row, Col_OPTMODVEGA).value = STR_EMPTY
    tickerDataTable(row, Col_OPTMODTHETA).value = STR_EMPTY
    tickerDataTable(row, Col_OPTMODUNDPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_BIDIMPLVOL).value = STR_EMPTY
    tickerDataTable(row, Col_BIDDELTA).value = STR_EMPTY
    tickerDataTable(row, Col_BIDOPTPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_BIDPVDIVIDEND).value = STR_EMPTY
    tickerDataTable(row, Col_BIDGAMMA).value = STR_EMPTY
    tickerDataTable(row, Col_BIDVEGA).value = STR_EMPTY
    tickerDataTable(row, Col_BIDTHETA).value = STR_EMPTY
    tickerDataTable(row, Col_BIDUNDPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_ASKIMPLVOL).value = STR_EMPTY
    tickerDataTable(row, Col_ASKDELTA).value = STR_EMPTY
    tickerDataTable(row, Col_ASKOPTPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_ASKPVDIVIDEND).value = STR_EMPTY
    tickerDataTable(row, Col_ASKGAMMA).value = STR_EMPTY
    tickerDataTable(row, Col_ASKVEGA).value = STR_EMPTY
    tickerDataTable(row, Col_ASKTHETA).value = STR_EMPTY
    tickerDataTable(row, Col_ASKUNDPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_LASTIMPLVOL).value = STR_EMPTY
    tickerDataTable(row, Col_LASTDELTA).value = STR_EMPTY
    tickerDataTable(row, Col_LASTOPTPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_LASTPVDIVIDEND).value = STR_EMPTY
    tickerDataTable(row, Col_LASTGAMMA).value = STR_EMPTY
    tickerDataTable(row, Col_LASTVEGA).value = STR_EMPTY
    tickerDataTable(row, Col_LASTTHETA).value = STR_EMPTY
    tickerDataTable(row, Col_LASTUNDPRICE).value = STR_EMPTY
    tickerDataTable(row, Col_EFPHOLDDAYS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPFUTUREEXPIRY).value = STR_EMPTY
    tickerDataTable(row, Col_EFPDIVIDENDSTOEXPIRY).value = STR_EMPTY
    tickerDataTable(row, Col_EFPBIDBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPBIDFORMATTEDBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPBIDTOTALDIVIDENDS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPBIDDIVIDENDIMPACT).value = STR_EMPTY
    tickerDataTable(row, Col_EFPASKBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPASKFORMATTEDBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPASKTOTALDIVIDENDS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPASKDIVIDENDIMPACT).value = STR_EMPTY
    tickerDataTable(row, Col_EFPLASTBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPLASTFORMATTEDBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPLASTTOTALDIVIDENDS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPLASTDIVIDENDIMPACT).value = STR_EMPTY
    tickerDataTable(row, Col_EFPOPENBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPOPENFORMATTEDBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPOPENTOTALDIVIDENDS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPOPENDIVIDENDIMPACT).value = STR_EMPTY
    tickerDataTable(row, Col_EFPHIGHBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPHIGHFORMATTEDBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPHIGHTOTALDIVIDENDS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPHIGHDIVIDENDIMPACT).value = STR_EMPTY
    tickerDataTable(row, Col_EFPLOWBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPLOWFORMATTEDBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPLOWTOTALDIVIDENDS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPLOWDIVIDENDIMPACT).value = STR_EMPTY
    tickerDataTable(row, Col_EFPCLOSEBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPCLOSEFORMATTEDBASISPOINTS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPCLOSETOTALDIVIDENDS).value = STR_EMPTY
    tickerDataTable(row, Col_EFPCLOSEDIVIDENDIMPACT).value = STR_EMPTY
End Sub

' cancel calculate option price click
Sub CancelCalculateOptionPrice_Click()
    If Not CheckConnected Then Exit Sub

    CancelCalculateOptionPriceSubscription Selection
    
    ActiveCell.Offset(1, 0).Activate
    
End Sub

' cancel calculate option price click
Private Sub CancelCalculateOptionPriceSubscription(sel As Range)
    Dim id As Integer

    Dim row As Object
    For Each row In sel.Rows
        id = row.row - contractTable.Rows(1).row + 1

        If contractTable(id, Col_CALCOPTPRICESTATUS).value = STR_CALCULATED Or _
            contractTable(id, Col_CALCOPTPRICESTATUS).value = STR_CALCULATING Then
            Api.Tws.CancelCalculateOptionPrice id + ID_CALC_OPTION_PRICE
        
            ' clear appropriate cells
            ClearCustomCalculateOptionPriceCells id
            
            ' update status column
            contractTable(id, Col_CALCOPTPRICESTATUS).value = STR_EMPTY
        End If
    Next
End Sub


' clear table from market data
Sub ClearMarketData_Click()

    ' cancel market data
    If IsConnected Then CancelMarketDataSubscriptions contractTable
    
    ' cancel calculate implied volatility
    If IsConnected Then CancelCalculateImpliedVolatilitySubscription contractTable
    
    ' cancel calculate option price
    If IsConnected Then CancelCalculateOptionPriceSubscription contractTable

    tickerDataTable.ClearContents
End Sub

' create Combo Legs using ComboLegForm
Private Sub ComboLegs_Click()
    ComboLegForm.ShowForm contractTable
End Sub

' create Ticker using TickerForm
Private Sub CreateTicker_Click()
    TickerForm.ShowForm contractTable
End Sub

' request market data
Sub RequestMarketData_Click()
Attribute RequestMarketData_Click.VB_Description = "Request Market Data"
Attribute RequestMarketData_Click.VB_ProcData.VB_Invoke_Func = "R\n14"
    If Not CheckConnected Then Exit Sub
    
    Dim row As Object
    For Each row In Selection.Rows
        Dim id As Long
        id = row.row - tickerDataTable.Rows(1).row + 1

        If contractTable(id, Col_SECTYPE).value <> STR_EMPTY Or contractTable(id, Col_CONID).value <> STR_EMPTY Then

            ' create contract
            Dim lContractInfo As TWSLib.IContract
            Set lContractInfo = Api.Tws.createContract()

            ' fill contract structure
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
                .conId = contractTable(id, Col_CONID).value
            End With

            ' combo legs
            If contractTable(id, Col_SECTYPE).value = SECTYPE_BAG And _
            contractTable(id, Col_COMBOLEGS) <> STR_EMPTY Then
                ' create combo leg list
                'lContractInfo.ComboLegs = Api.Tws.createComboLegList()

            ' create combo leg list
            Set lContractInfo.ComboLegs = Api.Tws.createComboLegList()
            
                ' parse combo legs string
                Util.ParseComboLegsIntoStruct contractTable(id, Col_COMBOLEGS).value, lContractInfo.ComboLegs, Nothing
            End If

            ' under comp
            If contractTable(id, Col_SECTYPE).value = SECTYPE_BAG And _
            contractTable(id, Col_DELTANEUTRALCONTRACT) <> STR_EMPTY Then
                ' create under comp
                Set lContractInfo.deltaNeutralContract = Api.Tws.createDeltaNeutralContract()

                ' parse under comp info
                Util.ParseDeltaNeutralContractIntoStruct contractTable(id, Col_DELTANEUTRALCONTRACT).value, lContractInfo.deltaNeutralContract
            End If


            ' generic tick list
            Dim genericTickList As String
            If Snapshot.value Then
                genericTickList = STR_EMPTY
                
                ' update status column
                tickerDataTable(id, Col_TICKER_STATUS).value = STR_SNAPSHOT
            Else
                genericTickList = Range(CELL_GENERIC_TICK_LIST).value
                
                ' update status column
                tickerDataTable(id, Col_TICKER_STATUS).value = STR_SUBSCRIBED
                tickerDataTable(id, Col_MARKETDATATYPE).value = STR_REAL_TIME
            End If

            ' sectype
            With arMktData(id)
                .SecType = lContractInfo.SecType
            End With
            
            ' mkt data options
            Dim mktDataOptions As TWSLib.ITagValueList
            Set mktDataOptions = Api.Tws.createTagValueList()
            
            Api.Tws.reqMktDataEx id + ID_TICKERS, lContractInfo, genericTickList, Snapshot.value, False, mktDataOptions

        End If

    Next
    ActiveCell.Offset(1, 0).Activate
End Sub

' cancel market data subscription
Private Sub CancelMarketData_Click()
    If Not CheckConnected Then Exit Sub

    CancelMarketDataSubscriptions Selection
    
    ActiveCell.Offset(1, 0).Activate
    
End Sub

Private Sub CancelMarketDataSubscriptions(sel As Range)
    If Not CheckConnected Then Exit Sub
    
    Dim id As Long
    
    Dim row As Object
    For Each row In sel.Rows
        id = row.row - tickerDataTable.Rows(1).row + 1
        
        ' cancel only "subscribed" tickers
        If tickerDataTable(id, Col_TICKER_STATUS).value = STR_SUBSCRIBED Then
            CancelMarketDataSubscription id
        End If
    Next
End Sub

Private Sub CancelMarketDataSubscription(ByVal tickerIndex As Long)
    Api.Tws.cancelMktData tickerIndex + ID_TICKERS

    ' update status column
    tickerDataTable(tickerIndex, Col_TICKER_STATUS).value = STR_EMPTY

    ' clear array
    With arMktData(tickerIndex)
        .bidPrice = 0
        .askPrice = 0
        .LastPrice = 0
        .HighTick = 0
        .LowTick = 0
        .ClosePrice = 0
        .OpenPrice = 0
        .Low13Week = 0
        .High13Week = 0
        .Low26Week = 0
        .High26Week = 0
        .Low52Week = 0
        .High52Week = 0
        .MarkPrice = 0
        .AuctionPrice = 0

        .bidSize = 0
        .askSize = 0
        .LastSize = 0
        .VolumeTick = 0
        .AvgVolume = 0
        .OptCallOpenInterest = 0
        .OptPutOpenInterest = 0
        .OptCallVolume = 0
        .OptPutVolume = 0
        .OpenInterest = 0
        .AuctionVolume = 0
        .AuctionImbalance = 0
        .AvgOptVolume = 0

        .LastTimeStamp = STR_EMPTY
        .BidExch = STR_EMPTY
        .AskExch = STR_EMPTY
        .OptBidExch = STR_EMPTY
        .OptAskExch = STR_EMPTY

        .BidYield = 0
        .AskYield = 0
        .LastYield = 0

        .OptModelImplVol = 0
        .OptModelDelta = 0
        .OptModelOptPrice = 0
        .OptModelPVDiv = 0
        .OptModelGamma = 0
        .OptModelVega = 0
        .OptModelTheta = 0
        .OptModelUndPrice = 0

        .BidImplVol = 0
        .BidDelta = 0
        .BidOptPrice = 0
        .BidPVDiv = 0
        .BidGamma = 0
        .BidVega = 0
        .BidTheta = 0
        .BidUndPrice = 0

        .AskImplVol = 0
        .AskDelta = 0
        .AskOptPrice = 0
        .AskPVDiv = 0
        .AskGamma = 0
        .AskVega = 0
        .AskTheta = 0
        .AskUndPrice = 0

        .LastImplVol = 0
        .LastDelta = 0
        .LastOptPrice = 0
        .LastPVDiv = 0
        .LastGamma = 0
        .LastVega = 0
        .LastTheta = 0
        .LastUndPrice = 0

        .EFPHoldDays = 0
        .EFPFutureExpiry = STR_EMPTY
        .EFPDividendsToExpiry = 0

        .EFPBidBasisPoints = 0
        .EFPBidFormattedBasisPoints = STR_EMPTY
        .EFPBidTotalDividends = 0
        .EFPBidDividendImpact = 0
        .EFPAskBasisPoints = 0
        .EFPAskFormattedBasisPoints = STR_EMPTY
        .EFPAskTotalDividends = 0
        .EFPAskDividendImpact = 0
        .EFPLastBasisPoints = 0
        .EFPLastFormattedBasisPoints = 0
        .EFPLastTotalDividends = 0
        .EFPLastDividendImpact = 0

        .EFPOpenBasisPoints = 0
        .EFPOpenFormattedBasisPoints = STR_EMPTY
        .EFPOpenTotalDividends = 0
        .EFPOpenDividendImpact = 0
        .EFPHighBasisPoints = 0
        .EFPHighFormattedBasisPoints = STR_EMPTY
        .EFPHighTotalDividends = 0
        .EFPHighDividendImpact = 0
        .EFPLowBasisPoints = 0
        .EFPLowFormattedBasisPoints = STR_EMPTY
        .EFPLowTotalDividends = 0
        .EFPLowDividendImpact = 0
        .EFPCloseBasisPoints = 0
        .EFPCloseFormattedBasisPoints = STR_EMPTY
        .EFPCloseTotalDividends = 0
        .EFPCloseDividendImpact = 0

        .OptHistVolume = 0
        .OptImplVolume = 0
        .IndexFuturePremium = 0
        .Shortable = 0
        .ShortableShares = 0
        .RTVolume = STR_EMPTY
        .Halted = STR_EMPTY
        .TradeCount = 0
        .TradeRate = 0
        .VolumeRate = 0
        .LastRTHTrade = 0
    End With

    ' clear appropriate cells
    ClearMarketDataCells tickerIndex
End Sub

' request market data type
Private Sub ReqMarketDataType_Click()
    If Not CheckConnected Then Exit Sub
    Api.Tws.ReqMarketDataType Range(CELL_MARKET_DATA_TYPE).value
End Sub

' update tickers sheet with price
Public Sub UpdateTickersSheetWithPrice(id As Long, tickType As Long, price As Double, CanAutoExecute As Boolean, PastLimit As Boolean, PreOpen As Boolean)

    id = id - ID_TICKERS
    
    If tickerDataTable(id, Col_TICKER_STATUS).value = STR_SUBSCRIBED Then
        If tickerDataTable(id, Col_MARKETDATATYPE).value = STR_REAL_TIME Then
            If tickType = DELAYED_BID Or tickType = DELAYED_ASK Or tickType = DELAYED_LAST Or _
                tickType = DELAYED_HIGH Or tickType = DELAYED_LOW Or tickType = DELAYED_OPEN Or tickType = DELAYED_CLOSE Then
                tickerDataTable(id, Col_MARKETDATATYPE).value = STR_DELAYED
            End If
        End If
    End If
   
    
    With arMktData(id)

        Select Case tickType
            Case BID_PRICE
                .bidPrice = price
                .BidAttr.CanAutoExecute = CanAutoExecute
                .BidAttr.PastLimit = PastLimit
                .BidAttr.PreOpen = PreOpen
            Case ASK_PRICE
                .askPrice = price
                .AskAttr.CanAutoExecute = CanAutoExecute
                .AskAttr.PastLimit = PastLimit
                .AskAttr.PreOpen = PreOpen
            Case LAST_PRICE
                .LastPrice = price
            Case HIGH_TICK
                .HighTick = price
            Case LOW_TICK
                .LowTick = price
            Case CLOSE_PRICE
                .ClosePrice = price
            Case OPEN_TICK
                .OpenPrice = price
            Case LOW_13_WEEK
                .Low13Week = price
            Case HIGH_13_WEEK
                .High13Week = price
            Case LOW_26_WEEK
                .Low26Week = price
            Case HIGH_26_WEEK
                .High26Week = price
            Case LOW_52_WEEK
                .Low52Week = price
            Case HIGH_52_WEEK
                .High52Week = price
            Case MARK_PRICE
                .MarkPrice = price
            Case AUCTION_PRICE
                .AuctionPrice = price
            Case BID_YIELD
                .BidYield = price
            Case ASK_YIELD
                .AskYield = price
            Case LAST_YIELD
                .LastYield = price
            Case LAST_RTH_TRADE
                .LastRTHTrade = price
            Case DELAYED_BID
                .bidPrice = price
                .BidAttr.CanAutoExecute = CanAutoExecute
                .BidAttr.PastLimit = PastLimit
                .BidAttr.PreOpen = PreOpen
            Case DELAYED_ASK
                .askPrice = price
                .AskAttr.CanAutoExecute = CanAutoExecute
                .AskAttr.PastLimit = PastLimit
                .AskAttr.PreOpen = PreOpen
            Case DELAYED_LAST
                .LastPrice = price
            Case DELAYED_HIGH
                .HighTick = price
            Case DELAYED_LOW
                .LowTick = price
            Case DELAYED_CLOSE
                .ClosePrice = price
            Case DELAYED_OPEN
                .OpenPrice = price
        End Select
    End With

    If Not timerIsArmed Then
        ArmTimer
    End If
    
End Sub

' update tickers sheet with size
Public Sub UpdateTickersSheetWithSize(id As Long, tickType As Long, size As Long)
    
    id = id - ID_TICKERS

    If tickerDataTable(id, Col_TICKER_STATUS).value = STR_SUBSCRIBED Then
        If tickerDataTable(id, Col_MARKETDATATYPE).value = STR_REAL_TIME Then
            If tickType = DELAYED_BID_SIZE Or tickType = DELAYED_ASK_SIZE Or tickType = DELAYED_LAST_SIZE Or tickType = DELAYED_VOLUME Then
                tickerDataTable(id, Col_MARKETDATATYPE).value = STR_DELAYED
            End If
        End If
    End If

    With arMktData(id)

        Select Case tickType
            Case BID_SIZE
                .bidSize = size
            Case ASK_SIZE
                .askSize = size
            Case LAST_SIZE
                .LastSize = size
            Case VOLUME_TICK
                .VolumeTick = size
            Case AVG_VOLUME
                .AvgVolume = size
            Case OPTION_CALL_OPEN_INTEREST
                .OptCallOpenInterest = size
            Case OPTION_PUT_OPEN_INTEREST
                .OptPutOpenInterest = size
            Case OPTION_CALL_VOLUME
                .OptCallVolume = size
            Case OPTION_PUT_VOLUME
                .OptPutVolume = size
            Case OPEN_INTEREST
                .OpenInterest = size
            Case AUCTION_VOLUME
                .AuctionVolume = size
            Case AUCTION_IMBALANCE
                .AuctionImbalance = size
            Case DELAYED_BID_SIZE
                .bidSize = size
            Case DELAYED_ASK_SIZE
                .askSize = size
            Case DELAYED_LAST_SIZE
                .LastSize = size
            Case DELAYED_VOLUME
                .VolumeTick = size
            Case AVG_OPT_VOLUME
                .AvgOptVolume = size
            Case SHORTABLE_SHARES
                .ShortableShares = size
        End Select
    End With

    If Not timerIsArmed Then
        ArmTimer
    End If
    
End Sub

' update tickers sheet with option data
Public Sub UpdateTickersSheetWithOptionComp(id As Long, tickType As Long, ByVal impliedVol As Double, ByVal delta As Double, ByVal optPrice As Double, ByVal pvDividend As Double, ByVal gamma As Double, ByVal vega As Double, ByVal theta As Double, ByVal undPrice As Double)

    If id >= ID_CALC_OPTION_PRICE Then
        id = id - ID_CALC_OPTION_PRICE
        If impliedVol = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMIMPLVOL_OP).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMIMPLVOL_OP).value = impliedVol
        End If
        If delta = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMDELTA_OP).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMDELTA_OP).value = delta
        End If
        If optPrice = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMOPTPRICE_OP).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMOPTPRICE_OP).value = optPrice
        End If
        If pvDividend = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMPVDIVIDEND_OP).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMPVDIVIDEND_OP).value = pvDividend
        End If
        If gamma = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMGAMMA_OP).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMGAMMA_OP).value = gamma
        End If
        If vega = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMVEGA_OP).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMVEGA_OP).value = vega
        End If
        If theta = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMTHETA_OP).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMTHETA_OP).value = theta
        End If
        If undPrice = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMUNDPRICE_OP).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMUNDPRICE_OP).value = undPrice
        End If
        tickerDataTable(id, Col_CALCOPTPRICESTATUS).value = STR_CALCULATED

    ElseIf id >= ID_CALC_IMPL_VOL And id < ID_CALC_OPTION_PRICE Then
        id = id - ID_CALC_IMPL_VOL
        If impliedVol = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMIMPLVOL_IV).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMIMPLVOL_IV).value = impliedVol
        End If
        If delta = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMDELTA_IV).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMDELTA_IV).value = delta
        End If
        If optPrice = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMOPTPRICE_IV).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMOPTPRICE_IV).value = optPrice
        End If
        If pvDividend = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMPVDIVIDEND_IV).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMPVDIVIDEND_IV).value = pvDividend
        End If
        If gamma = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMGAMMA_IV).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMGAMMA_IV).value = gamma
        End If
        If vega = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMVEGA_IV).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMVEGA_IV).value = vega
        End If
        If theta = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMTHETA_IV).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMTHETA_IV).value = theta
        End If
        If undPrice = MaxDoubleValue Then
            tickerDataTable(id, Col_CUSTOMUNDPRICE_IV).value = STR_NOT_AVAILABLE
        Else
            tickerDataTable(id, Col_CUSTOMUNDPRICE_IV).value = undPrice
        End If
        tickerDataTable(id, Col_CALCIMPLVOLSTATUS).value = STR_CALCULATED

    Else
        id = id - ID_TICKERS
        
        If tickerDataTable(id, Col_TICKER_STATUS).value = STR_SUBSCRIBED Then
            If tickerDataTable(id, Col_MARKETDATATYPE).value = STR_REAL_TIME Then
                If tickType = DELAYED_BID_OPTION Or tickType = DELAYED_ASK_OPTION Or tickType = DELAYED_LAST_OPTION Or tickType = DELAYED_MODEL_OPTION Then
                    tickerDataTable(id, Col_MARKETDATATYPE).value = STR_DELAYED
                End If
            End If
        End If
        
        With arMktData(id)

            Select Case tickType
                Case BID_OPTION_COMPUTATION
                    .BidImplVol = impliedVol
                    .BidDelta = delta
                    .BidOptPrice = optPrice
                    .BidPVDiv = pvDividend
                    .BidGamma = gamma
                    .BidVega = vega
                    .BidTheta = theta
                    .BidUndPrice = undPrice
                Case ASK_OPTION_COMPUTATION
                    .AskImplVol = impliedVol
                    .AskDelta = delta
                    .AskOptPrice = optPrice
                    .AskPVDiv = pvDividend
                    .AskGamma = gamma
                    .AskVega = vega
                    .AskTheta = theta
                    .AskUndPrice = undPrice
                Case LAST_OPTION_COMPUTATION
                    .LastImplVol = impliedVol
                    .LastDelta = delta
                    .LastOptPrice = optPrice
                    .LastPVDiv = pvDividend
                    .LastGamma = gamma
                    .LastVega = vega
                    .LastTheta = theta
                    .LastUndPrice = undPrice
                Case MODEL_OPTION
                    .OptModelImplVol = impliedVol
                    .OptModelDelta = delta
                    .OptModelOptPrice = optPrice
                    .OptModelPVDiv = pvDividend
                    .OptModelGamma = gamma
                    .OptModelVega = vega
                    .OptModelTheta = theta
                    .OptModelUndPrice = undPrice
                Case DELAYED_BID_OPTION
                    .BidImplVol = impliedVol
                    .BidDelta = delta
                    .BidOptPrice = optPrice
                    .BidPVDiv = pvDividend
                    .BidGamma = gamma
                    .BidVega = vega
                    .BidTheta = theta
                    .BidUndPrice = undPrice
                Case DELAYED_ASK_OPTION
                    .AskImplVol = impliedVol
                    .AskDelta = delta
                    .AskOptPrice = optPrice
                    .AskPVDiv = pvDividend
                    .AskGamma = gamma
                    .AskVega = vega
                    .AskTheta = theta
                    .AskUndPrice = undPrice
                Case DELAYED_LAST_OPTION
                    .LastImplVol = impliedVol
                    .LastDelta = delta
                    .LastOptPrice = optPrice
                    .LastPVDiv = pvDividend
                    .LastGamma = gamma
                    .LastVega = vega
                    .LastTheta = theta
                    .LastUndPrice = undPrice
                Case DELAYED_MODEL_OPTION
                    .OptModelImplVol = impliedVol
                    .OptModelDelta = delta
                    .OptModelOptPrice = optPrice
                    .OptModelPVDiv = pvDividend
                    .OptModelGamma = gamma
                    .OptModelVega = vega
                    .OptModelTheta = theta
                    .OptModelUndPrice = undPrice
            End Select
        End With
        End If

    If Not timerIsArmed Then
        ArmTimer
    End If
        
End Sub
    
'update Tickers sheet with new string
Public Sub UpdateTickersSheetWithString(id As Long, tickType As Long, value As String)
    
    id = id - ID_TICKERS

    With arMktData(id)

        Select Case tickType
            Case LAST_TIMESTAMP
                .LastTimeStamp = value
            Case BID_EXCH
                .BidExch = value
            Case ASK_EXCH
                .AskExch = value
            Case OPTION_BID_EXCH
                .OptBidExch = value
            Case OPTION_ASK_EXCH
                .OptAskExch = value
            Case RT_VOLUME
                .RTVolume = value
            Case DELAYED_LAST_TIMESTAMP
                .LastTimeStamp = value
        End Select

    End With

    If Not timerIsArmed Then
        ArmTimer
    End If

End Sub

'update Tickers sheet with tick EFP
Public Sub UpdateTickersSheetWithTickEFP(ByVal tickerId As Long, ByVal field As Long, ByVal basisPoints As Double, ByVal formattedBasisPoints As String, ByVal totalDividends As Double, ByVal holdDays As Long, ByVal futureExpiry As String, ByVal dividendImpact As Double, ByVal dividendsToExpiry As Double)
    
    tickerId = tickerId - ID_TICKERS

    With arMktData(tickerId)
        .EFPHoldDays = holdDays
        .EFPFutureExpiry = futureExpiry
        .EFPDividendsToExpiry = dividendsToExpiry

        Select Case field
            Case BID_EFP_COMPUTATION
                .EFPBidBasisPoints = basisPoints
                .EFPBidFormattedBasisPoints = formattedBasisPoints
                .EFPBidTotalDividends = totalDividends
                .EFPBidDividendImpact = dividendImpact
            Case ASK_EFP_COMPUTATION
                .EFPAskBasisPoints = basisPoints
                .EFPAskFormattedBasisPoints = formattedBasisPoints
                .EFPAskTotalDividends = totalDividends
                .EFPAskDividendImpact = dividendImpact
            Case LAST_EFP_COMPUTATION
                .EFPLastBasisPoints = basisPoints
                .EFPLastFormattedBasisPoints = formattedBasisPoints
                .EFPLastTotalDividends = totalDividends
                .EFPLastDividendImpact = dividendImpact
            Case OPEN_EFP_COMPUTATION
                .EFPOpenBasisPoints = basisPoints
                .EFPOpenFormattedBasisPoints = formattedBasisPoints
                .EFPOpenTotalDividends = totalDividends
                .EFPOpenDividendImpact = dividendImpact
            Case HIGH_EFP_COMPUTATION
                .EFPHighBasisPoints = basisPoints
                .EFPHighFormattedBasisPoints = formattedBasisPoints
                .EFPHighTotalDividends = totalDividends
                .EFPHighDividendImpact = dividendImpact
            Case LOW_EFP_COMPUTATION
                .EFPLowBasisPoints = basisPoints
                .EFPLowFormattedBasisPoints = formattedBasisPoints
                .EFPLowTotalDividends = totalDividends
                .EFPLowDividendImpact = dividendImpact
            Case CLOSE_EFP_COMPUTATION
                .EFPCloseBasisPoints = basisPoints
                .EFPCloseFormattedBasisPoints = formattedBasisPoints
                .EFPCloseTotalDividends = totalDividends
                .EFPCloseDividendImpact = dividendImpact
        End Select
    End With

    If Not timerIsArmed Then
        ArmTimer
    End If
    
End Sub

'update Tickers sheet with tick generic
Public Sub UpdateTickersSheetWithTickGeneric(ByVal id As Long, ByVal tickType As Long, ByVal value As Double)
    
    id = id - ID_TICKERS

    With arMktData(id)
        Select Case tickType
            Case OPTION_HISTORICAL_VOL
                .OptHistVolume = value
            Case OPTION_IMPLIED_VOL
                .OptImplVolume = value
            Case INDEX_FUTURE_PREMIUM
                .IndexFuturePremium = value
            Case Shortable
                .Shortable = value
            Case Halted
                .Halted = value
            Case TRADE_COUNT
                .TradeCount = value
            Case TRADE_RATE
                .TradeRate = value
            Case VOLUME_RATE
                .VolumeRate = value
        End Select
    End With

    If Not timerIsArmed Then
        ArmTimer
    End If
    
End Sub

' process error
Public Sub ProcessError(ByVal id As Long, ByVal errorCode As Long, ByVal errorMsg As String)
    
    ' handle errors
    If errorCode = ERROR_DUPLICATE_TICKER_ID Then
        MsgBox STR_ALREADY_SUBSCRIBED
    ElseIf errorCode = ERROR_PARTIAL_SUBSCRIPTION Then
        MsgBox errorMsg
    ElseIf errorCode = ERROR_NO_SUBSCRIPTION Then
        MsgBox errorMsg
    Else
        If id >= ID_CALC_OPTION_PRICE Then
            id = id - ID_CALC_OPTION_PRICE
            If contractTable(id, Col_SECTYPE).value <> STR_EMPTY Then
                tickerDataTable(id, Col_CALCOPTPRICESTATUS).value = STR_ERROR + STR_COLON + Str(errorCode) + STR_SPACE + errorMsg
            End If
        ElseIf id >= ID_CALC_IMPL_VOL And id < ID_CALC_OPTION_PRICE Then
            id = id - ID_CALC_IMPL_VOL
            If contractTable(id, Col_SECTYPE).value <> STR_EMPTY Then
                tickerDataTable(id, Col_CALCIMPLVOLSTATUS).value = STR_ERROR + STR_COLON + Str(errorCode) + STR_SPACE + errorMsg
            End If
        Else
            id = id - ID_TICKERS
            If contractTable(id, Col_SECTYPE).value <> STR_EMPTY Then
                tickerDataTable(id, Col_TICKER_STATUS).value = STR_ERROR + STR_COLON + Str(errorCode) + STR_SPACE + errorMsg
            End If
        End If
    End If
End Sub

'update market data type
Public Sub UpdateMarketDataType(ByVal id As Long, ByVal marketDataType As Long)
    id = id - ID_TICKERS
    If tickerDataTable(id, Col_TICKER_STATUS).value = STR_SUBSCRIBED Then
        Select Case marketDataType
            Case 1
                tickerDataTable(id, Col_MARKETDATATYPE).value = STR_REAL_TIME
            Case 2
                tickerDataTable(id, Col_MARKETDATATYPE).value = STR_FROZEN
            Case 3
                tickerDataTable(id, Col_MARKETDATATYPE).value = STR_DELAYED
            Case 4
                tickerDataTable(id, Col_MARKETDATATYPE).value = STR_DELAYED_FROZEN
        End Select
    End If
End Sub




