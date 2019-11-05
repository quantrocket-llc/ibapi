Attribute VB_Name = "Util"
Option Explicit

#If Win64 = 1 And VBA7 = 1 Then
    Private Declare PtrSafe Sub GetSystemTime Lib "kernel32" (ByRef lpSystemTime As SYSTEMTIME)
    Private Declare PtrSafe Function GetTimeZoneInformation Lib "kernel32" (lpTimeZoneInformation As TIME_ZONE_INFORMATION) As LongPtr
#Else
    Private Declare Sub GetSystemTime Lib "kernel32" (ByRef lpSystemTime As SYSTEMTIME)
    Private Declare Function GetTimeZoneInformation Lib "kernel32" (lpTimeZoneInformation As TIME_ZONE_INFORMATION) As Long
#End If

Private Type SYSTEMTIME
    wYear           As Integer
    wMonth          As Integer
    wDayOfWeek      As Integer
    wDay            As Integer
    wHour           As Integer
    wMinute         As Integer
    wSecond         As Integer
    wMilliseconds   As Integer
End Type

Private Type TIME_ZONE_INFORMATION
    Bias As Long
    StandardName(31) As Integer
    StandardDate As SYSTEMTIME
    StandardBias As Long
    DaylightName(31) As Integer
    DaylightDate As SYSTEMTIME
    DaylightBias As Long
End Type

Public Const MaxLongValue As Long = &H7FFFFFFF
Public Const MaxLongLongValue As LongLong = 9223372036854775807^
Public Const MaxDoubleValue As Double = (2 - 2 ^ -52) * 2 ^ 1023

' error codes
Public Const ERROR_DUPLICATE_TICKER_ID = 322
Public Const ERROR_PARTIAL_SUBSCRIPTION = 10090
Public Const ERROR_NO_SUBSCRIPTION = 10167

' global string constants
Public Const STR_TWS_CONTROL_ALREADY_CONNECTED = "TWS Control is already connected"
Public Const STR_TWS_CONTROL_NOT_CONNECTED = "TWS Control is not connected"
Public Const STR_COMBO_LEGS_STRING_CANNOT_BE_PARSED = "Error: Combo Legs or DeltaNeutralContract string cannot be parsed"
Public Const STR_SMART_COMBO_ROUTING_PARAMS_SECTYPE_NOT_BAG = "Error: this order does not have sectype = BAG"
Public Const STR_SMART_COMBO_ROUTING_PARAMS_STRING_CANNOT_BE_PARSED = "Error: Smart Combo Routing Params string cannot be parsed"
Public Const STR_TWS_CONTROL_INIT_ERROR = "Cannot initialize TWS Control"
Public Const STR_ALREADY_SUBSCRIBED = "Already subscribed"
Public Const STR_NOT_AVAILABLE = "N/A"
Public Const STR_EMPTY = ""
Public Const STR_FORMAT_NUMBER = "0.0000"
Public Const STR_POINT = "."
Public Const STR_COMMA = ","
Public Const STR_SEMICOLON = ";"
Public Const STR_UNDERSCORE = "_"
Public Const STR_EQUALSSIGN = "="
Public Const STR_COLON = ":"
Public Const STR_SPACE = " "
Public Const STR_COMBOLEGS = "CMBLGS"
Public Const STR_DELTANEUTRALCONTRACT = "DELTANEUTRALCONTRACT"
Public Const STR_PROCESSING = "Processing ..."
Public Const STR_SUBSCRIBED = "Subscribed"
Public Const STR_FINISHED = "Finished"
Public Const STR_CANCELLED = "Cancelled"
Public Const STR_SNAPSHOT = "Snapshot"
Public Const STR_ZERO = "0"
Public Const STR_ERROR = "Error"
Public Const STR_CALCULATING = "Calculating ..."
Public Const STR_CALCULATED = "Calculated"
Public Const STR_REAL_TIME = "Real-Time"
Public Const STR_FROZEN = "Frozen"
Public Const STR_DELAYED = "Delayed"
Public Const STR_DELAYED_FROZEN = "Delayed-Frozen"

' id
Public Const ID_GAP = 100000
Public Const ID_GENERAL = 100000
Public Const ID_TICKERS = 200000
Public Const ID_BULLETINS = 300000
Public Const ID_ACCOUNT = 400000
Public Const ID_PORTFOLIO = 500000
Public Const ID_MKTDEPTH = 600000
Public Const ID_EXTORDATTRS = 700000
Public Const ID_OPENORDERS = 8000000
Public Const ID_EXECUTIONS = 900000
Public Const ID_HISTDATA = 1000000
Public Const ID_CONTRACTDETAILS = 1100000
Public Const ID_BONDCONTRACTDETAILS = 1200000
Public Const ID_REALTIMEBARS = 1300000
Public Const ID_MARKETSCANNER = 1400000
Public Const ID_FUNDAMENTALS = 1500000
Public Const ID_FUNDAMENTALRATIOS = 1600000
Public Const ID_CALC_IMPL_VOL = 1700000
Public Const ID_CALC_OPTION_PRICE = 1800000
Public Const ID_POSITIONS_MULTI = 1900000
Public Const ID_ACCOUNT_UPDATES_MULTI = 2000000
Public Const ID_TICK_NEWS = 2100000
Public Const ID_HISTORICAL_NEWS = 2200000
Public Const ID_TICKBYTICKDATA = 2300000
Public Const ID_HEADTIMESTAMP = 2400000
Public Const ID_PNL = 2500000
Public Const ID_PNL_SINGLE = 2600000
Public Const ID_SOFT_DOLLAR_TIER = 2700000
Public Const ID_HISTOGRAM_DATA = 2800000
Public Const ID_SMART_COMPONENTS = 2900000
Public Const ID_SEC_DEF_OPT_PARAMS = 3000000


' order id base
Public Const ORDER_ID_BASE = &H70000000

' security types
Public Const SECTYPE_OPT = "OPT"
Public Const SECTYPE_FOP = "FOP"
Public Const SECTYPE_FUT = "FUT"
Public Const SECTYPE_STK = "STK"
Public Const SECTYPE_IND = "IND"
Public Const SECTYPE_CASH = "CASH"
Public Const SECTYPE_BOND = "BOND"
Public Const SECTYPE_BAG = "BAG"

' action types
Public Const ACTION_BUY = "BUY"
Public Const ACTION_SELL = "SELL"
Public Const ACTION_SSHORT = "SSHORT"

' right types (call/put)
Public Const RIGHT_CALL = "C"
Public Const RIGHT_PUT = "P"

' tick types
Public Enum tickType
    BID_SIZE = 0
    BID_PRICE
    ASK_PRICE
    ASK_SIZE
    LAST_PRICE
    LAST_SIZE
    HIGH_TICK
    LOW_TICK
    VOLUME_TICK
    CLOSE_PRICE
    BID_OPTION_COMPUTATION
    ASK_OPTION_COMPUTATION
    LAST_OPTION_COMPUTATION
    MODEL_OPTION
    OPEN_TICK
    LOW_13_WEEK
    HIGH_13_WEEK
    LOW_26_WEEK
    HIGH_26_WEEK
    LOW_52_WEEK
    HIGH_52_WEEK
    AVG_VOLUME
    OPEN_INTEREST
    OPTION_HISTORICAL_VOL
    OPTION_IMPLIED_VOL
    OPTION_BID_EXCH
    OPTION_ASK_EXCH
    OPTION_CALL_OPEN_INTEREST
    OPTION_PUT_OPEN_INTEREST
    OPTION_CALL_VOLUME
    OPTION_PUT_VOLUME
    INDEX_FUTURE_PREMIUM
    BID_EXCH
    ASK_EXCH
    AUCTION_VOLUME
    AUCTION_PRICE
    AUCTION_IMBALANCE
    MARK_PRICE
    BID_EFP_COMPUTATION
    ASK_EFP_COMPUTATION
    LAST_EFP_COMPUTATION
    OPEN_EFP_COMPUTATION
    HIGH_EFP_COMPUTATION
    LOW_EFP_COMPUTATION
    CLOSE_EFP_COMPUTATION
    LAST_TIMESTAMP
    Shortable
    FUNDAMENTAL_RATIOS
    RT_VOLUME
    Halted
    BID_YIELD
    ASK_YIELD
    LAST_YIELD
    CUST_OPTION_COMPUTATION
    TRADE_COUNT
    TRADE_RATE
    VOLUME_RATE
    LAST_RTH_TRADE
    RT_HISTORICAL_VOL
    IB_DIVIDENDS
    BOND_FACTOR_MULTIPLIER
    REGULATORY_IMBALANCE
    NEWS_TICK
    SHORT_TERM_VOLUME_3_MIN
    SHORT_TERM_VOLUME_5_MIN
    SHORT_TERM_VOLUME_10_MIN
    DELAYED_BID
    DELAYED_ASK
    DELAYED_LAST
    DELAYED_BID_SIZE
    DELAYED_ASK_SIZE
    DELAYED_LAST_SIZE
    DELAYED_HIGH
    DELAYED_LOW
    DELAYED_VOLUME
    DELAYED_CLOSE
    DELAYED_OPEN
    RT_TRD_VOLUME
    CREDITMAN_MARK_PRICE
    CREDITMAN_SLOW_MARK_PRICE
    DELAYED_BID_OPTION
    DELAYED_ASK_OPTION
    DELAYED_LAST_OPTION
    DELAYED_MODEL_OPTION
    LAST_EXCH
    LAST_REG_TIME
    FUTURES_OPEN_INTEREST
    AVG_OPT_VOLUME
    DELAYED_LAST_TIMESTAMP
    SHORTABLE_SHARES
End Enum

Public Type MktDataAttr
    CanAutoExecute As Boolean
    PastLimit As Boolean
    PreOpen As Boolean
End Type

'===================
' public functions
'===================

Public Function CheckConnected() As Boolean
    If Not IsConnected Then
        MsgBox STR_TWS_CONTROL_NOT_CONNECTED
        CheckConnected = False
    Else
        CheckConnected = True
    End If
End Function

' convert double value to string
Public Function Double2String(doubleValue As Double) As String
    Dim doubleValueStr As String
    doubleValueStr = Format(doubleValue, STR_FORMAT_NUMBER)
    If InStr(1, doubleValueStr, STR_COMMA) > 0 Then
        doubleValueStr = Replace(doubleValueStr, STR_COMMA, STR_POINT)
    End If
    Double2String = doubleValueStr
End Function

' this function finds sheet by name or adds new if sheet was not found
' returns true if a new sheet was added
Public Function FindOrAddSheet(sheetName As String, ByRef needsInitialising As Boolean) As Worksheet
    needsInitialising = True
    
    Dim active As Object
    Set active = ActiveSheet
    
    Dim ws As Worksheet
    For Each ws In Worksheets
        If ws.name = sheetName Then
            ' sheet was found
            needsInitialising = (ws.Cells(1, 1) = 0)
            Exit For
        End If
    Next
    
    If ws Is Nothing Then
        ' sheet was not found
        needsInitialising = True
        Set ws = Sheets.Add(Type:=xlWorksheet)
        
        With ws
            .Move after:=Worksheets(Worksheets.Count)
            .name = sheetName
        End With
    End If
    
    active.Activate
    Set FindOrAddSheet = ws
End Function

' set non-empty value
Public Function SetNonEmptyValue(tableValue As Variant, defaultValue As Variant) As Variant
    If tableValue <> STR_EMPTY Then
        SetNonEmptyValue = tableValue
    Else
        SetNonEmptyValue = defaultValue
    End If
End Function

' convert long value to date
Public Function ConvertLongToDateStr(ByVal lSec As Long) As String
    Dim tz As TIME_ZONE_INFORMATION
    
    If lSec > 0 Then
        ConvertLongToDateStr = Str(DateAdd("s", -(tz.Bias + tz.DaylightBias * IIf(GetTimeZoneInformation(tz) = 2, 1, 0)) * 60, DateAdd("s", lSec, DateSerial(1970, 1, 1))))
    Else
        ConvertLongToDateStr = STR_EMPTY
    End If
End Function

Public Function GenerateContractIdentifier(contractInfo As TWSLib.IContract)
    Dim s As String
    s = IIf(contractInfo.Symbol <> "", "_" & contractInfo.Symbol, "")
    s = s & IIf(contractInfo.SecType <> "", "_" & contractInfo.SecType, "")
    s = s & IIf(contractInfo.lastTradeDateOrContractMonth <> "", "_" & contractInfo.lastTradeDateOrContractMonth, "")
    s = s & IIf(contractInfo.Strike <> 0#, "_" & contractInfo.Strike, "")
    s = s & IIf(contractInfo.Right <> "", "_" & contractInfo.Right, "")
    s = s & IIf(contractInfo.multiplier <> "", "_" & contractInfo.multiplier, "")
    s = s & IIf(contractInfo.exchange <> "", "_" & contractInfo.exchange, "")
    s = s & IIf(contractInfo.primaryExchange <> "", "_" & contractInfo.primaryExchange, "")
    s = s & IIf(contractInfo.currency <> "", "_" & contractInfo.currency, "")
    s = s & IIf(contractInfo.localSymbol <> "", "_" & contractInfo.localSymbol, "")
    s = s & IIf(contractInfo.conId <> 0, "_" & contractInfo.conId, "")
End Function

Public Function ClearSheetRowId(sheet As Worksheet)
sheet.Cells(1, 200) = ""
End Function

Public Function GetSheetRowId(sheet As Worksheet)
GetSheetRowId = sheet.Cells(1, 200)
End Function

Public Function IncrementSheetRowId(sheet As Worksheet)
sheet.Cells(1, 200) = sheet.Cells(1, 200) + 1
IncrementSheetRowId = sheet.Cells(1, 200)
End Function

Public Sub InitialiseSheetRowId(sheet As Worksheet, initialRowId As Long)
sheet.Cells(1, 200) = initialRowId
End Sub

' parse combo legs string and fill combolegs list
Public Sub ParseComboLegsIntoStruct(ByVal tempStr As String, ByRef cmbStruct As TWSLib.IComboLegList, ByRef orderCmbStruct As TWSLib.IOrderComboLegList)
    On Error GoTo ComboLegsParserError
    
    Dim numLegs As Long
    Dim i As Long
    tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
    ' number of legs
    numLegs = Val(Left(tempStr, 1))
    tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
    
    Dim comboLeg As TWSLib.IComboLeg
    Dim orderComboLeg As TWSLib.IOrderComboLeg
    
    ' fill combo legs structure
    For i = 1 To numLegs
        Set comboLeg = cmbStruct.Add()
        
        If Not (orderCmbStruct Is Nothing) Then
            Set orderComboLeg = orderCmbStruct.Add()
        End If
        
        comboLeg.conId = Val(Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1))
        tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
        
        comboLeg.ratio = Val(Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1))
        tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
        
        comboLeg.action = Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1)
        tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
        
        comboLeg.exchange = Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1)
        tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
        
        comboLeg.openClose = Val(Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1))
        tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
        
        comboLeg.shortSaleSlot = Val(Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1))
        tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
        
        comboLeg.designatedLocation = Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1)
        tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
    
        comboLeg.exemptCode = Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1)
        tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
    
        If Not (orderCmbStruct Is Nothing) Then
        
            If (Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1) <> "") Then
                orderComboLeg.price = Val(Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1))
            End If
        End If
        tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
            
    Next i

    Exit Sub
    ' error
ComboLegsParserError:
    MsgBox STR_COMBO_LEGS_STRING_CANNOT_BE_PARSED

End Sub

' parse smart combo routing params
Public Sub ParseSmartComboRoutingParamsIntoStruct(ByVal tempStr As String, ByRef paramsList As TWSLib.ITagValueList)
    On Error GoTo SmartComboRoutingParamsParserError
    
    Dim numParams As Long
    Dim i As Long
    Dim param As TWSLib.ITagValue
    
    numParams = Val(Left(tempStr, InStr(tempStr, STR_SEMICOLON) - 1))
    tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_SEMICOLON))
            
    If numParams > 0 Then
        For i = 0 To numParams - 1
            Dim tag As String
            Dim value As String
            tag = Left(tempStr, InStr(tempStr, STR_SEMICOLON) - 1)
            tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_SEMICOLON))
            value = Left(tempStr, InStr(tempStr, STR_SEMICOLON) - 1)
            tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_SEMICOLON))
        
            Set param = paramsList.Add(tag, value)
        
        Next i
    End If

    Exit Sub
    ' error
SmartComboRoutingParamsParserError:
    MsgBox STR_SMART_COMBO_ROUTING_PARAMS_STRING_CANNOT_BE_PARSED

End Sub

' parse deltaNeutralContract string into struct
Public Sub ParseDeltaNeutralContractIntoStruct(ByVal tempStr As String, ByRef deltaNeutralContractStruct As TWSLib.IDeltaNeutralContract)
    On Error GoTo DeltaNeutralContractParserError
    
    tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
    deltaNeutralContractStruct.conId = Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1)
    tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
    deltaNeutralContractStruct.delta = Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1)
    tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
    deltaNeutralContractStruct.price = Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1)

    Exit Sub
    ' error
DeltaNeutralContractParserError:
    MsgBox STR_COMBO_LEGS_STRING_CANNOT_BE_PARSED

End Sub

Public Function GetStringTimeStamp() As String
    Dim dSysUTC As Date, sysTime As SYSTEMTIME
    GetSystemTime sysTime
    GetStringTimeStamp = sysTime.wYear & sysTime.wMonth & sysTime.wDay & _
                        sysTime.wHour & sysTime.wMinute & sysTime.wSecond & sysTime.wMilliseconds
End Function

Public Function IntMaxStr(intVal As Long) As String
    If intVal = MaxLongValue Then
        IntMaxStr = ""
    Else
        IntMaxStr = CStr(intVal)
    End If
End Function

Public Function DblMaxStr(dblVal As Double) As String
    If dblVal = MaxDoubleValue Then
        DblMaxStr = ""
    Else
        DblMaxStr = CStr(dblVal)
    End If
End Function

Public Function LongMaxStr(longVal As LongLong) As String
    If longVal = MaxLongLongValue Then
        LongMaxStr = ""
    Else
        LongMaxStr = CStr(longVal)
    End If
End Function



Public Sub FillContractObject(lContractInfo As TWSLib.IContract, contractTable As Range, id As Long)
    With lContractInfo
        .Symbol = UCase(contractTable(id, Col_SYMBOL).value)
        .SecType = UCase(contractTable(id, Col_SECTYPE).value)
        .lastTradeDateOrContractMonth = contractTable(id, Col_LASTTRADEDATE).value
        .Strike = IIf(contractTable(id, Col_STRIKE).value = "", 0#, contractTable(id, Col_STRIKE).value)
        .Right = UCase(contractTable(id, Col_RIGHT).value)
        .multiplier = UCase(contractTable(id, Col_MULTIPLIER).value)
        .exchange = UCase(contractTable(id, Col_EXCH).value)
        .primaryExchange = UCase(contractTable(id, Col_PRIMEXCH).value)
        .currency = UCase(contractTable(id, Col_CURRENCY).value)
        .localSymbol = UCase(contractTable(id, Col_LOCALSYMBOL).value)
        .conId = IIf(UCase(contractTable(id, Col_CONID).value) = "", 0, UCase(contractTable(id, Col_CONID).value))
    End With
End Sub

Public Function comboLegsToStr(contract As TWSLib.IContract) As String
    Dim tempStr
    Dim i
    tempStr = ""
    With contract
        If Not .ComboLegs Is Nothing Then
            For i = 0 To .ComboLegs.Count - 1 Step 1
                tempStr = "leg1: "
                tempStr = tempStr & "conId=" & .ComboLegs(i).conId
                tempStr = tempStr & ";action=" & .ComboLegs(i).action
                tempStr = tempStr & ";ratio=" & .ComboLegs(i).ratio
                tempStr = tempStr & ";exch=" & .ComboLegs(i).exchange
                tempStr = tempStr & "; "
            Next i
        End If
    End With
    comboLegsToStr = tempStr
End Function

Public Function deltaNeutralToStr(contract As TWSLib.IContract) As String
    Dim tempStr
    tempStr = ""
    With contract
        If Not .deltaNeutralContract Is Nothing Then
            With .deltaNeutralContract
                If .conId > 0 Then
                    tempStr = "conId=" & .conId
                    tempStr = tempStr & ";price=" & .price
                    tempStr = tempStr & ";delta=" & .delta
                End If
            End With
        End If
    End With
    deltaNeutralToStr = tempStr
End Function

