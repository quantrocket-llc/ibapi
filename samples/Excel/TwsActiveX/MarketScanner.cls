VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "MarketScanner"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum ControlTableColumns
    Col_STATUS = 1
    Col_SHEETNAME
    Col_ACTIVATEPAGE
End Enum

Private Enum SubscriptionTableColumns
    Col_SCANCODE = 1
    Col_INSTRUMENT
    Col_LOCATIONCODE
    Col_STOCKTYPEFILTER
    Col_NUMBEROFROWS
    Col_PRICEABOVE
    Col_PRICEBELOW
    Col_VOLUMEABOVE
    Col_AVGOPTVOLUMEABOVE
    Col_MKTCAPABOVE
    Col_MKTCAPBELOW
    Col_MOODYRATINGABOVE
    Col_MOODYRATINGBELOW
    Col_SPRATINGABOVE
    Col_SPRATINGBELOW
    Col_MATURITYDATEABOVE
    Col_MATURITYDATEBELOW
    Col_COUPONRATEABOVE
    Col_COUPONRATEBELOW
    Col_EXCLUDECONVERTIBLE
    Col_SCANNERSETTINGPAIRS
    Col_SCANNERSUBSCRIPTIONOPTIONS
    COL_SCANNERSUBSCRIPTIONFILTEROPTIONS
End Enum

Const STARTING_ROW = 3

' other constants
Const STR_SCANNER_PARAMETERS = "Scanner Parameters"

Private controlTable As Range
Private subscriptionTable As Range

'=================
' methods
'=================
' request scanner parameters
Private Sub RequestScannerParameters_Click()
    If Not CheckConnected Then Exit Sub
    
    ' call reqScannerParameters method
    Api.Tws.reqScannerParameters
End Sub

' cancel market scanner subscription
Private Sub CancelScannerSubscription_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Long
    id = ActiveCell.row - controlTable.Rows(1).row + 1
    
    ' update status of subscription
    controlTable(id, Col_STATUS).value = STR_EMPTY

    Api.Tws.CancelScannerSubscription id + ID_MARKETSCANNER

    ActiveCell.Offset(1, 0).Activate
End Sub

' request scanner subscriptiion
Public Sub RequestScannerSubscription_Click()
Attribute RequestScannerSubscription_Click.VB_Description = "Request Scanner Subscription"
Attribute RequestScannerSubscription_Click.VB_ProcData.VB_Invoke_Func = "S\n14"
    If Not CheckConnected Then Exit Sub
    
    ' todo
    Dim id As Long
    id = ActiveCell.row - controlTable.Rows(1).row + 1
    Dim lSubscription As TWSLib.IScannerSubscription
    Set lSubscription = Api.Tws.createScannerSubscription()
    
    With lSubscription
        .scanCode = Util.SetNonEmptyValue(subscriptionTable(id, Col_SCANCODE).value, .scanCode)
        .instrument = Util.SetNonEmptyValue(subscriptionTable(id, Col_INSTRUMENT).value, .instrument)
        .locations = Util.SetNonEmptyValue(subscriptionTable(id, Col_LOCATIONCODE).value, .locations)
        .stockTypeFilter = Util.SetNonEmptyValue(subscriptionTable(id, Col_STOCKTYPEFILTER).value, .stockTypeFilter)
        .numberOfRows = Util.SetNonEmptyValue(subscriptionTable(id, Col_NUMBEROFROWS).value, .numberOfRows)
        .priceAbove = Util.SetNonEmptyValue(subscriptionTable(id, Col_PRICEABOVE).value, .priceAbove)
        .priceBelow = Util.SetNonEmptyValue(subscriptionTable(id, Col_PRICEBELOW).value, .priceBelow)
        .volumeAbove = Util.SetNonEmptyValue(subscriptionTable(id, Col_VOLUMEABOVE).value, .volumeAbove)
        .averageOptionVolumeAbove = Util.SetNonEmptyValue(subscriptionTable(id, Col_AVGOPTVOLUMEABOVE).value, .averageOptionVolumeAbove)
        .marketCapAbove = Util.SetNonEmptyValue(subscriptionTable(id, Col_MKTCAPABOVE).value, .marketCapAbove)
        .marketCapBelow = Util.SetNonEmptyValue(subscriptionTable(id, Col_MKTCAPBELOW).value, .marketCapBelow)
        .moodyRatingAbove = Util.SetNonEmptyValue(subscriptionTable(id, Col_MOODYRATINGABOVE).value, .moodyRatingAbove)
        .moodyRatingBelow = Util.SetNonEmptyValue(subscriptionTable(id, Col_MOODYRATINGBELOW).value, .moodyRatingBelow)
        .spRatingAbove = Util.SetNonEmptyValue(subscriptionTable(id, Col_SPRATINGABOVE).value, .spRatingAbove)
        .spRatingBelow = Util.SetNonEmptyValue(subscriptionTable(id, Col_SPRATINGBELOW).value, .spRatingBelow)
        .maturityDateAbove = Util.SetNonEmptyValue(subscriptionTable(id, Col_MATURITYDATEABOVE).value, .maturityDateAbove)
        .maturityDateBelow = Util.SetNonEmptyValue(subscriptionTable(id, Col_MATURITYDATEBELOW).value, .maturityDateBelow)
        .couponRateAbove = Util.SetNonEmptyValue(subscriptionTable(id, Col_COUPONRATEABOVE).value, .couponRateAbove)
        .couponRateBelow = Util.SetNonEmptyValue(subscriptionTable(id, Col_COUPONRATEBELOW).value, .couponRateBelow)
        .excludeConvertible = Util.SetNonEmptyValue(subscriptionTable(id, Col_EXCLUDECONVERTIBLE).value, .excludeConvertible)
        .scannerSettingPairs = Util.SetNonEmptyValue(subscriptionTable(id, Col_SCANNERSETTINGPAIRS).value, .scannerSettingPairs)
    End With
    
    ' scanner subscription options
    Dim scannerSubscriptionOptions As String, scannerSubscriptionFilterOptions As String
    
    scannerSubscriptionOptions = Util.SetNonEmptyValue(subscriptionTable(id, Col_SCANNERSUBSCRIPTIONOPTIONS).value, "")
    scannerSubscriptionFilterOptions = Util.SetNonEmptyValue(subscriptionTable(id, COL_SCANNERSUBSCRIPTIONFILTEROPTIONS).value, "")
        
    Dim sheetName As String
    sheetName = controlTable(id, Col_SHEETNAME).value
    If (sheetName = STR_EMPTY And controlTable(id, Col_ACTIVATEPAGE).value) Or _
        IsNumeric(sheetName) Then
        controlTable(id, Col_SHEETNAME).value = GenerateSheetName(lSubscription)
    End If
    
    ' call reqScannerParameters method
    Api.Tws.reqScannerSubscriptionEx id + ID_MARKETSCANNER, lSubscription, scannerSubscriptionOptions, scannerSubscriptionFilterOptions
    
    controlTable(id, Col_STATUS).value = STR_PROCESSING
    
    ActiveCell.Offset(1, 0).Activate
End Sub

' update scanner parameters
Public Sub UpdateScannerParameters(xml As String)
    ScrollableMsgBox.ShowText xml, STR_SCANNER_PARAMETERS, False, MarketScanner.name
End Sub

' update market scanner data
Public Sub UpdateScannerData(ByVal reqId As Long, ByVal rank As Long, ByVal ContractDetails As TWSLib.IContractDetails, ByVal distance As String, ByVal benchmark As String, ByVal projection As String, ByVal legsStr As String)
    
    reqId = reqId - ID_MARKETSCANNER
    
    Dim sheetName As String
    sheetName = controlTable(reqId, Col_SHEETNAME).value

    If sheetName = STR_EMPTY Or IsNumeric(sheetName) Then Exit Sub
    
    Dim sheet As Worksheet
    Dim needsInitialising As Boolean
    Set sheet = FindOrAddSheet(sheetName, needsInitialising)
    If needsInitialising Then InitialiseSheet sheet
    
    Dim rowId As Long
    rowId = GetSheetRowId(sheet)
    
    ' data
    sheet.Cells(rowId, 1).value = rank + 1
    
    Dim contract As TWSLib.IContract
    Set contract = ContractDetails.contract
    With sheet.Rows(rowId)
        .Cells(2).value = contract.Symbol
        .Cells(3).value = contract.SecType
        .Cells(4).value = contract.lastTradeDateOrContractMonth
        .Cells(5).value = contract.Strike
        .Cells(6).value = contract.Right
        .Cells(7).value = contract.exchange
    
        .Cells(8).value = contract.currency
        .Cells(9).value = contract.localSymbol
        .Cells(10).value = ContractDetails.marketName
        .Cells(11).value = contract.tradingClass
        .Cells(12).value = distance
        .Cells(13).value = benchmark
        .Cells(14).value = projection
        .Cells(15).value = legsStr
    End With
    
    If (rowId - STARTING_ROW + 1) < subscriptionTable(reqId, Col_NUMBEROFROWS).value Then
        IncrementSheetRowId sheet
    Else
        InitialiseSheetRowId sheet, STARTING_ROW
    End If

End Sub

Public Sub ScannerDataEnd(ByVal reqId As Long)
    reqId = reqId - ID_MARKETSCANNER
    
    Dim sheetName As String
    sheetName = controlTable(reqId, Col_SHEETNAME).value
    If sheetName <> STR_EMPTY And Not IsNumeric(sheetName) Then
        Dim sheet As Worksheet
        Set sheet = Worksheets(sheetName)
        ClearSheetRowId sheet
        
        ' update subscription status column
        controlTable(reqId, Col_STATUS).value = STR_SUBSCRIBED
        
        If controlTable(reqId, Col_ACTIVATEPAGE).value Then sheet.Activate
    End If
End Sub


Private Sub InitialiseSheet(sheet As Worksheet)
    sheet.Cells.ClearContents

    InitialiseSheetRowId sheet, STARTING_ROW
    sheet.Cells(2, 1).value = "Rank"
    sheet.Cells(2, 2).value = "Symbol"
    sheet.Cells(2, 3).value = "Type"
    sheet.Cells(2, 4).value = "lastTradeDate"
    sheet.Cells(2, 5).value = "Strike"
    sheet.Cells(2, 6).value = "Right"
    sheet.Cells(2, 7).value = "Exchange"
    sheet.Cells(2, 8).value = "Currency"
    sheet.Cells(2, 9).value = "Local Sym"
    sheet.Cells(2, 10).value = "Mkt Name"
    sheet.Cells(2, 11).value = "Trading Class"
    sheet.Cells(2, 12).value = "Distance"
    sheet.Cells(2, 13).value = "Benchmark"
    sheet.Cells(2, 14).value = "Projection"
    sheet.Cells(2, 15).value = "Legs"

End Sub

Private Function GenerateSheetName(subscriptionInfo As TWSLib.IScannerSubscription)
    Dim s As String
    s = subscriptionInfo.scanCode
    s = s & IIf(subscriptionInfo.instrument <> "", "_" & subscriptionInfo.instrument, "")
    s = s & IIf(subscriptionInfo.locations <> "", "_" & subscriptionInfo.locations, "")
    GenerateSheetName = Left(s, 31)
End Function

Public Sub ProcessError(ByVal id As Long, ByVal errorCode As Long, ByVal errorMsg As String)
    
    ' handle errors
    If errorCode = ERROR_DUPLICATE_TICKER_ID Then
        MsgBox STR_ALREADY_SUBSCRIBED
        controlTable(id - ID_MARKETSCANNER, Col_STATUS).value = STR_SUBSCRIBED
    Else
        controlTable(id - ID_MARKETSCANNER, Col_STATUS).value = STR_ERROR + STR_COLON + Str(errorCode) + STR_SPACE + errorMsg
    End If
        
End Sub

Public Sub Initialise()
    Set controlTable = Range("$A$7:$C$100")
    Set subscriptionTable = Range("$D$7:$X$100")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
    
    Dim macroName As String
    macroName = "MarketScanner.RequestScannerSubscription_Click"
    
    Application.OnKey "+^s", macroName
End Sub

Private Sub Worksheet_Deactivate()
    Application.OnKey "+^s"
End Sub

