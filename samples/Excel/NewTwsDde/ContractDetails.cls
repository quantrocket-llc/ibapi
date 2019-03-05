VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ContractDetails"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long
Dim contractColumnsArray() As Variant

' constants
Const STR_SHEET_NAME = "ContractDetails"
Const STR_REQ_CONTRACT_DETAILS = "reqContractDetails"
Const STR_CANCEL_CONTRACT_DETAILS = "cancelContractDetails"
Const STR_CONTRACT_DETAILS_TICK = "contractDetailsTick"
Const STR_REQ_MARKET_RULE = "reqMarketRule"
Const STR_REQ_MARKET_RULE_ERROR = "reqMarketRuleError"

Const STR_ID = "id"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_MARKET_RULE_ID = "W5" ' cell with market rule id
Const CELL_MARKET_RULE_CONTROL = "V9" ' cell with market rule control
Const CELL_MARKET_RULE_ERROR = "W9" ' cell with market rule error

' columns
Const startOfContractColumns = 1 ' contract first column index (symbol)
Const secTypeColumnIndex = 2 ' index of "sec type" column
Const includeExpiredColumnIndex = 15 ' index of "include expired" column
Const sheetNameColumnIndex = 16 ' index of "page name" column
Const activateSheetColumnIndex = 17 ' index of "activate page" column
Const idColumnIndex = 18 ' index of "id" column
Const statusColumnIndex = 19 ' index of "status" column
Const errorColumnIndex = 20 ' index of "error" column
Const priceIncrementLowEdgeColumnIndex = 22 ' index of "low edge" column of price increments table

' rows
Const dataStartRowIndex = 10 ' starting row of data
Const dataEndRowIndex = util.maxRowsToFormat ' ending row of data
Const priceIncrementStartRowIndex = 14 ' starting market rule row of data

Const PRICE_INCREMENT_TABLE_RANGE = "V" & priceIncrementStartRowIndex & ":W" & dataEndRowIndex

' ========================================================
' contract columns
' ========================================================
Private Function getContractColumns() As Variant()

    If (Not Not contractColumnsArray) <> 0 Then
        ' do not re-initialize array
        GoTo getContractColumnsEnd
    End If

    contractColumnsArray = Array("SYMBOL", "SECTYPE", "LASTTRADEDATE", "STRIKE", "RIGHT", "MULTIPLIER", "TRADINGCLASS", "EXCH", "PRIMEXCH", "CURRENCY", "LOCALSYMBOL", "CONID", _
        "SECIDTYPE", "SECID", "INCLUDEEXPIRED")
    
getContractColumnsEnd:
    getContractColumns = contractColumnsArray
End Function

' ========================================================
' header columns
' ========================================================
Private Function getHeaderColumns() As Variant()
    getHeaderColumns = Array("Symbol", "SecType", "LastTradeDate", "Strike", "Right", "Exchange", "Currency", "LocalSymbol", "MarketName", "TradingClass", "ConId", "MinTick", _
                            "MdSizeMultiplier", "Multiplier", "OrderTypes", "ValidExchanges", "PriceMagnifier", "UnderConId", "LongName", "PrimExchange", "ContractMonth", _
                            "Industry", "Category", "Subcategory", "TimeZoneId", "TradingHours", "LiquidHours", "EvRule", "EvMultiplier", "SecIdList", "AggGroup", _
                            "UnderSymbol", "UnderSecType", "MarketRuleIds", "RealExpirationDate")
End Function

Private Function getHeaderColumnsFixedIncome() As Variant()
    getHeaderColumnsFixedIncome = Array("Symbol", "SecType", "Cusip", "Coupon", "Maturity", "LastTradeTime", "TimeZoneId", "IssueDate", "Ratings", "BondType", "CouponType", "Convertible", _
                            "Callable", "Putable", "DescAppend", "Exchange", "Currency", "MarketName", "TradingClass", "ConId", "MinTick", "MdSizeMultiplier", "OrderTypes", _
                            "ValidExchanges", "NextOptionDate", "NextOptionType", "NextOptionPartial", "Notes", "LongName", "EvRule", "EvMultiplier", "SecIdList", "AggGroup", _
                            "MarketRuleIds")
End Function


' ========================================================
' sends contract details cancel when button is pressed
' ========================================================
Sub cancelContractDetails()
    Dim server As String, id As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub
    
    With Worksheets(STR_SHEET_NAME)
        If .Cells(ActiveCell.row, idColumnIndex).value = STR_EMPTY Then Exit Sub
        If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, ActiveCell, startOfContractColumns, getContractColumns()) Then Exit Sub

        id = .Cells(ActiveCell.row, idColumnIndex).value
        .Cells(ActiveCell.row, idColumnIndex).value = util.STR_EMPTY
    
        ' status column
        .Cells(ActiveCell.row, statusColumnIndex).ClearContents
        ' error column
        .Cells(ActiveCell.row, errorColumnIndex).ClearContents
    
        util.sendRequest server, STR_CANCEL_CONTRACT_DETAILS, id
    
        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request contract details for active row
' ========================================================
Sub requestContractDetails()
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        If .Cells(ActiveCell.row, idColumnIndex).value <> STR_EMPTY Then Exit Sub
        If Not util.hasContractData(Worksheets(STR_SHEET_NAME), dataStartRowIndex, ActiveCell, startOfContractColumns, getContractColumns()) Then Exit Sub
        
        ' get id
        Dim id As String
        id = util.getIDpost(genId, util.ID_REQ_CONTRACT_DETAILS)
        .Cells(ActiveCell.row, idColumnIndex).value = id
        
        ' fill status column with formula
        .Cells(ActiveCell.row, statusColumnIndex).Formula = util.composeLink(server, STR_CONTRACT_DETAILS_TICK, id, util.STR_STATUS)

        If util.cleanOnError(.Cells(ActiveCell.row, statusColumnIndex)) Then
            .Cells(ActiveCell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(ActiveCell.row, statusColumnIndex).value = util.STR_EMPTY
            .Cells(ActiveCell.row, errorColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If

        ' send request
        util.sendPoke Worksheets(STR_SHEET_NAME), server, STR_REQ_CONTRACT_DETAILS, id, ActiveCell, startOfContractColumns, getContractColumns(), 0, idColumnIndex, 0, 0, 0, 0
    
        ' fill error column with formula
        .Cells(ActiveCell.row, errorColumnIndex).Formula = util.composeLink(server, STR_CONTRACT_DETAILS_TICK, id, util.STR_ERROR)
        
        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With
    
End Sub


' ========================================================
' Requests contract details table/array
' Called when value in CELL_STATUS changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String
    Dim i As Integer, j As Integer
    Dim dimension As Integer

    With Worksheets(STR_SHEET_NAME)
    
        ' market rule error
        If CStr(.range(CELL_MARKET_RULE_CONTROL).value) = util.STR_ERROR_UPPER And CStr(.range(CELL_MARKET_RULE_ERROR).value) = util.STR_EMPTY Then
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            .range(CELL_MARKET_RULE_ERROR).Formula = util.composeLink(server, STR_REQ_MARKET_RULE_ERROR, util.IDENTIFIER_ZERO, util.STR_EMPTY)
        End If
    
        ' market rule
        If CStr(.range(CELL_MARKET_RULE_CONTROL).value) = util.STR_RECEIVED Then
            Dim priceIncrementArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub

            ' send request and receive price increment table/array
            priceIncrementArray = util.sendRequest(server, STR_REQ_MARKET_RULE, util.IDENTIFIER_ZERO) ' returned array can be 1-Dimension or 2-Dimension

            dimension = util.getDimension(priceIncrementArray)
            If dimension = 2 Then
                ' several price increments received (2d array)
                For i = 1 To UBound(priceIncrementArray, 1) - LBound(priceIncrementArray, 1) + 1
                    .Cells(priceIncrementStartRowIndex + i - 1, priceIncrementLowEdgeColumnIndex).value = priceIncrementArray(i, 1)
                    .Cells(priceIncrementStartRowIndex + i - 1, priceIncrementLowEdgeColumnIndex).NumberFormat = "General"
                    .Cells(priceIncrementStartRowIndex + i - 1, priceIncrementLowEdgeColumnIndex + 1).value = priceIncrementArray(i, 2)
                    .Cells(priceIncrementStartRowIndex + i - 1, priceIncrementLowEdgeColumnIndex + 1).NumberFormat = "General"
                Next i
            ElseIf dimension = 1 Then
                ' single price increment received (1d array)
                .Cells(priceIncrementStartRowIndex, priceIncrementLowEdgeColumnIndex).value = priceIncrementArray(1)
                .Cells(priceIncrementStartRowIndex, priceIncrementLowEdgeColumnIndex).NumberFormat = "General"
                .Cells(priceIncrementStartRowIndex, priceIncrementLowEdgeColumnIndex + 1).value = priceIncrementArray(2)
                .Cells(priceIncrementStartRowIndex, priceIncrementLowEdgeColumnIndex + 1).NumberFormat = "General"
            End If
        End If
    
        ' contract details
        For j = dataStartRowIndex To dataEndRowIndex
            If CStr(.Cells(j, statusColumnIndex).value) = util.STR_RECEIVED Then
                Dim contractDetailsArray() As Variant
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub
    
                id = .Cells(j, idColumnIndex).value
    
                ' send request and receive contract details table/array
                contractDetailsArray = util.sendRequest(server, STR_REQ_CONTRACT_DETAILS, id) ' returned array can be 1-Dimension or 2-Dimension
    
                If .Cells(j, secTypeColumnIndex).value = util.BOND Or .Cells(j, secTypeColumnIndex).value = util.BILL Or .Cells(j, secTypeColumnIndex).value = util.FIXED Then
                    ' update sheet
                    util.updateSheetWithArray _
                        CStr(.Cells(j, sheetNameColumnIndex).value), _
                        contractDetailsArray, _
                        .Cells(j, activateSheetColumnIndex).value, _
                        "Bond Contract Details", _
                        getHeaderColumnsFixedIncome(), _
                        False, _
                        False, _
                        0, _
                        False
                
                Else
                    ' update sheet
                    util.updateSheetWithArray _
                        CStr(.Cells(j, sheetNameColumnIndex).value), _
                        contractDetailsArray, _
                        .Cells(j, activateSheetColumnIndex).value, _
                        "Contract Details", _
                        getHeaderColumns(), _
                        False, _
                        False, _
                        0, _
                        False
                End If
    
            End If
        Next j
    End With
End Sub

' ========================================================
' Requests market rule when button is pressed
' ========================================================
Sub requestMarketRule()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_MARKET_RULE_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        With Worksheets(STR_SHEET_NAME)
            clearMarketRuleTable
    
            Dim server As String
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            Dim marketRuleId As Integer
            marketRuleId = .range(CELL_MARKET_RULE_ID).value
    
            .range(CELL_MARKET_RULE_CONTROL).Formula = util.composeLink(server, STR_REQ_MARKET_RULE, util.IDENTIFIER_ZERO, marketRuleId) ' subscription control
            If util.cleanOnError(.range(CELL_MARKET_RULE_CONTROL)) Then
                Exit Sub
            End If
        End With
        
    End If
End Sub

' ========================================================
' Clear market rule table
' ========================================================
Sub clearMarketRuleTable()
    ' clear market rule table
    With Worksheets(STR_SHEET_NAME)
        .range(PRICE_INCREMENT_TABLE_RANGE).ClearContents
        .range(CELL_MARKET_RULE_CONTROL).ClearContents
        .range(CELL_MARKET_RULE_ERROR).ClearContents
    End With
End Sub


