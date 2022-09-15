VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BondContractDetails"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum BondContractColumns
    Col_CUSIP = 1
    Col_SECTYPE
    Col_EXCH
    Col_CURRENCY
    Col_ISSUERID
    Col_STATUS
End Enum

Private Enum NewPageOptionsColumns
    Col_SHEETNAME = 1
    Col_SHEETACTIVATE
End Enum

Private contractTable As Range
Private newPageTable As Range


'=================
' methods
'=================

' request bond contract details
Public Sub RequestBondContractDetails_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer
    
    ' create contract structure
    Dim lContractInfo As TWSLib.IContract
    Set lContractInfo = Api.Tws.createContract()
    
    id = ActiveCell.row - contractTable.Rows(1).row + 1
    With lContractInfo
        .Symbol = UCase(contractTable(id, Col_CUSIP).value)
        .SecType = UCase(contractTable(id, Col_SECTYPE).value)
        .Exchange = UCase(contractTable(id, Col_EXCH).value)
        .currency = UCase(contractTable(id, Col_CURRENCY).value)
        .issuerId = contractTable(id, Col_ISSUERID).value
    End With

    Dim sheetName As String
    sheetName = newPageTable(id, Col_SHEETNAME).value
    If (sheetName = STR_EMPTY And newPageTable(id, Col_SHEETACTIVATE).value) Or _
        IsNumeric(sheetName) Then
        newPageTable(id, Col_SHEETNAME).value = GenerateSheetName(lContractInfo)
    End If
    
    Api.Tws.ReqContractDetailsEx id + ID_BONDCONTRACTDETAILS, lContractInfo
    
    contractTable(id, Col_STATUS).value = STR_PROCESSING
    
    ActiveCell.Offset(1, 0).Activate
End Sub

' update bond contract details
Public Sub UpdateBondContractDetails(ByVal reqId As Long, ByVal ContractDetails As TWSLib.IContractDetails)
    
    reqId = reqId - ID_BONDCONTRACTDETAILS
    
    Dim sheetName As String
    sheetName = newPageTable(reqId, Col_SHEETNAME).value

    If sheetName = STR_EMPTY Or IsNumeric(sheetName) Then Exit Sub
    
    Dim sheet As Worksheet
    Dim needsInitialising As Boolean
    Set sheet = FindOrAddSheet(sheetName, needsInitialising)
    If needsInitialising Then InitialiseSheet sheet
    
    Dim rowId As Long
    rowId = GetSheetRowId(sheet)

    Dim contract As TWSLib.IContract
    Set contract = ContractDetails.contract
    With sheet.Rows(rowId)
        .Cells(1).value = contract.Symbol
        .Cells(2).value = contract.SecType
        .Cells(3).value = ContractDetails.cusip
        .Cells(4).value = ContractDetails.coupon
        .Cells(5).value = ContractDetails.maturity
        .Cells(6).value = ContractDetails.issueDate
        .Cells(7).value = ContractDetails.ratings
        .Cells(8).value = ContractDetails.bondType
        .Cells(9).value = ContractDetails.couponType
        .Cells(10).value = ContractDetails.convertible
        .Cells(11).value = ContractDetails.callable
        .Cells(12).value = ContractDetails.putable
        .Cells(13).value = ContractDetails.descAppend
        .Cells(14).value = contract.Exchange
        .Cells(15).value = contract.currency
        .Cells(16).value = ContractDetails.marketName
        .Cells(17).value = contract.tradingClass
        .Cells(18).value = contract.conId
        .Cells(19).value = ContractDetails.minTick
        .Cells(20).value = ContractDetails.orderTypes
        .Cells(21).value = ContractDetails.validExchanges
        .Cells(22).value = ContractDetails.nextOptionDate
        .Cells(23).value = ContractDetails.nextOptionType
        .Cells(24).value = ContractDetails.nextOptionPartial
        .Cells(25).value = ContractDetails.Notes
        .Cells(26).value = ContractDetails.longName
        .Cells(27).value = ContractDetails.evRule
        .Cells(28).value = ContractDetails.evMultiplier
        .Cells(29).value = ContractDetails.aggGroup
        .Cells(30).value = ContractDetails.priceMagnifier
        .Cells(31).value = ContractDetails.minSize
        .Cells(32).value = ContractDetails.sizeIncrement
        .Cells(33).value = ContractDetails.suggestedSizeIncrement
    End With

    IncrementSheetRowId sheet

End Sub

Private Sub InitialiseSheet(sheet As Worksheet)
    sheet.Cells.ClearContents

    InitialiseSheetRowId sheet, 3
    
    sheet.Cells(2, 1).value = "Symbol"
    sheet.Cells(2, 2).value = "SecType"
    sheet.Cells(2, 3).value = "CUSIP"
    sheet.Cells(2, 4).value = "Coupon"
    sheet.Cells(2, 5).value = "Maturity"
    sheet.Cells(2, 6).value = "Issue Date"
    sheet.Cells(2, 7).value = "Ratings"
    sheet.Cells(2, 8).value = "Bond Type"
    sheet.Cells(2, 9).value = "Coupon Type"
    sheet.Cells(2, 10).value = "Convertible"
    sheet.Cells(2, 11).value = "Callable"
    sheet.Cells(2, 12).value = "Putable"
    sheet.Cells(2, 13).value = "Desc Append"
    sheet.Cells(2, 14).value = "Exchange"
    sheet.Cells(2, 15).value = "Currency"
    sheet.Cells(2, 16).value = "Market Name"
    sheet.Cells(2, 17).value = "Trading Class"
    sheet.Cells(2, 18).value = "ConId"
    sheet.Cells(2, 19).value = "Min Tick"
    sheet.Cells(2, 20).value = "Order Types"
    sheet.Cells(2, 21).value = "Valid Exchanges"
    sheet.Cells(2, 22).value = "Next Option Date"
    sheet.Cells(2, 23).value = "Next Option Type"
    sheet.Cells(2, 24).value = "Next Option Partial"
    sheet.Cells(2, 25).value = "Notes"
    sheet.Cells(2, 26).value = "Long Name"
    sheet.Cells(2, 27).value = "EvRule"
    sheet.Cells(2, 28).value = "EvMultiplier"
    sheet.Cells(2, 29).value = "Agg Group"
    sheet.Cells(2, 30).value = "Price Magnifier"
    sheet.Cells(2, 31).value = "Min Size"
    sheet.Cells(2, 32).value = "Size Incr"
    sheet.Cells(2, 33).value = "Sugg Size Incr"
    
End Sub

Public Sub ContractDetailsEnd(ByVal reqId As Long)
    ' finishing
    reqId = reqId - ID_BONDCONTRACTDETAILS
    
    contractTable(reqId, Col_STATUS).value = STR_FINISHED
    
    Dim sheetName As String
    sheetName = newPageTable(reqId, Col_SHEETNAME).value
    If sheetName <> STR_EMPTY And Not IsNumeric(sheetName) Then
        Dim sheet As Worksheet
        Set sheet = Worksheets(sheetName)
        ClearSheetRowId sheet
        
        If newPageTable(reqId, Col_SHEETACTIVATE).value Then sheet.Activate
    End If
End Sub

Public Sub ProcessError(ByVal id As Long, ByVal errorCode As Long, ByVal errorMsg As String)
    
    contractTable(id - ID_BONDCONTRACTDETAILS, Col_STATUS).value = STR_ERROR + STR_COLON + str(errorCode) + STR_SPACE + errorMsg
        
End Sub

Private Function GenerateSheetName(contractInfo As TWSLib.IContract)
    Dim s As String
    s = "Details"
    s = s & IIf(contractInfo.Symbol <> "", "_" & contractInfo.Symbol, "")
    s = s & IIf(contractInfo.SecType <> "", "_" & contractInfo.SecType, "")
    s = s & IIf(contractInfo.Exchange <> "", "_" & contractInfo.Exchange, "")
    s = s & IIf(contractInfo.currency <> "", "_" & contractInfo.currency, "")
    GenerateSheetName = Left(s, 31)
End Function

Public Sub Initialise()
    Set contractTable = Range("$A$7:$F$50")
    Set newPageTable = Range("$G$7:$H$130")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
    
    Dim macroName As String
    macroName = "BondContractDetails.RequestBondContractDetails_Click"
    Application.OnKey "+^b", macroName
End Sub

Private Sub Worksheet_Deactivate()
    Application.OnKey "+^b"
End Sub



