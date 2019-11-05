VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "OpenOrders"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private contractTable As Range
Private orderDescriptionTable As Range
Private orderStatusTable As Range
Private ExtendedAttributesTable As Range

'=================
' private methods
'=================
' clear open orders table
Private Sub ClearOpenOrders_Click()
    Clear
End Sub

' request auto open orders
Private Sub CancelAutoOpenOrders_Click()
    If Not CheckConnected Then Exit Sub
    
    Api.Tws.ReqAutoOpenOrders False
End Sub

' request all open orders
Private Sub RequestAllOpenOrders_Click()
    If Not CheckConnected Then Exit Sub
    
    Clear
    Api.Tws.ReqAllOpenOrders
End Sub

' request auto open orders
Private Sub RequestAutoOpenOrders_Click()
    If Not CheckConnected Then Exit Sub
    
    Api.Tws.ReqAutoOpenOrders True
End Sub

' request open orders
Private Sub RequestOpenOrders_Click()
    If Not CheckConnected Then Exit Sub
    
    Clear
    Api.Tws.ReqOpenOrders
End Sub

'=================
' public methods
'=================
' update open orders table with new values
Sub UpdateOpenOrder(orderId As Long, contract As TWSLib.IContract, order As TWSLib.IOrder, orderState As TWSLib.IOrderState)
    
    Dim tempStr As String
    Dim i As Integer
    
    ' find row by orderId
    Dim rowId As Long
    rowId = OrderUtils.FindOrderRowIndexByPermId(order.permId, orderStatusTable)
    
    'if row with order was not found then try to find first empty row
    If rowId = 0 Then
        rowId = OrderUtils.FindFirstEmptyOrderRow(Col_PERMID, orderStatusTable)
    End If
    
    With contract
        contractTable(rowId, Col_SYMBOL).value = .Symbol
        contractTable(rowId, Col_SECTYPE).value = .SecType
        contractTable(rowId, Col_LASTTRADEDATE).value = .lastTradeDateOrContractMonth
        contractTable(rowId, Col_STRIKE).value = .Strike
        contractTable(rowId, Col_RIGHT).value = .Right
        contractTable(rowId, Col_MULTIPLIER).value = .multiplier
        contractTable(rowId, Col_EXCH).value = .exchange
        contractTable(rowId, Col_PRIMEXCH).value = .primaryExchange
        contractTable(rowId, Col_CURRENCY).value = .currency
        contractTable(rowId, Col_LOCALSYMBOL).value = .localSymbol
        contractTable(rowId, Col_CONID).value = .conId
        contractTable(rowId, Col_COMBOLEGS).value = Util.comboLegsToStr(contract)
        contractTable(rowId, Col_DELTANEUTRALCONTRACT).value = Util.deltaNeutralToStr(contract)
    End With
    
    With order
        orderStatusTable(rowId, Col_ORDERID).value = orderId
        orderDescriptionTable(rowId, Col_ACTION).value = .action
        orderDescriptionTable(rowId, Col_TOTALQTY).value = .totalQuantity
        orderDescriptionTable(rowId, Col_CASH_QTY).value = Util.DblMaxStr(.cashQty)
        orderDescriptionTable(rowId, Col_ORDERTYPE).value = .orderType
        orderDescriptionTable(rowId, Col_LMTPRICE).value = Util.DblMaxStr(.lmtPrice)
        orderDescriptionTable(rowId, Col_AUXPRICE).value = Util.DblMaxStr(.auxPrice)
        orderStatusTable(rowId, Col_PERMID).value = .permId


        ' extended order attributes
        ExtendedAttributesTable(rowId, Col_TIMEINFORCE).value = .timeInForce
        ExtendedAttributesTable(rowId, Col_OCAGROUP).value = .ocaGroup
        ExtendedAttributesTable(rowId, Col_ACCOUNT).value = .Account

        If contract.SecType Like SECTYPE_OPT Or contract.SecType Like SECTYPE_FOP Then
            ExtendedAttributesTable(rowId, Col_OPENCLOSE).value = .openClose
        End If

        ExtendedAttributesTable(rowId, Col_ORIGIN).value = .origin
        ExtendedAttributesTable(rowId, Col_ORDERREF).value = .orderRef
        ExtendedAttributesTable(rowId, Col_TRANSMIT).value = .transmit
        ExtendedAttributesTable(rowId, Col_PARENTORDID).value = .parentId
        ExtendedAttributesTable(rowId, Col_BLOCKORDER).value = .blockOrder
        ExtendedAttributesTable(rowId, Col_SWEEPTOFILL).value = .sweepToFill
        ExtendedAttributesTable(rowId, Col_DISPLAYSIZE).value = .displaySize
        ExtendedAttributesTable(rowId, Col_TRIGGERMETHOD).value = .triggerMethod
        ExtendedAttributesTable(rowId, Col_HIDDEN).value = .Hidden
        ExtendedAttributesTable(rowId, Col_DISCRAMOUNT).value = .discretionaryAmt
        ExtendedAttributesTable(rowId, Col_GOODAFTERTIME).value = .goodAfterTime
        ExtendedAttributesTable(rowId, Col_GOODTILLDATE).value = .goodTillDate
        ExtendedAttributesTable(rowId, Col_FAGROUP).value = .faGroup
        ExtendedAttributesTable(rowId, Col_FAMETHOD).value = .faMethod
        ExtendedAttributesTable(rowId, Col_FAPERCENTAGE).value = .faPercentage
        ExtendedAttributesTable(rowId, Col_FAPROFILE).value = .faProfile
        ExtendedAttributesTable(rowId, Col_SHORTSALESLOT).value = .shortSaleSlot
        ExtendedAttributesTable(rowId, Col_DESIGNLOC).value = .designatedLocation
        ExtendedAttributesTable(rowId, Col_EXEMPTCODE).value = .exemptCode
        ExtendedAttributesTable(rowId, Col_OCATYPE).value = .ocaType
        ExtendedAttributesTable(rowId, Col_RULE80A).value = .rule80A
        ExtendedAttributesTable(rowId, Col_SETTLINGFIRM).value = .settlingFirm
        ExtendedAttributesTable(rowId, Col_ALLORNONE).value = .allOrNone
        ExtendedAttributesTable(rowId, Col_MINQTY).value = Util.IntMaxStr(.minQty)
        ExtendedAttributesTable(rowId, Col_PERCENTOFFSET).value = Util.DblMaxStr(.percentOffset)
        ExtendedAttributesTable(rowId, Col_ETRADEONLY).value = .eTradeOnly
        ExtendedAttributesTable(rowId, Col_FIRMQUOTEONLY).value = .firmQuoteOnly
        ExtendedAttributesTable(rowId, Col_NBBOPRICECAP).value = Util.DblMaxStr(.nbboPriceCap)
        ExtendedAttributesTable(rowId, Col_AUCTIONSTRAT).value = .auctionStrategy
        ExtendedAttributesTable(rowId, Col_STARTINGPRICE).value = Util.DblMaxStr(.startingPrice)
        ExtendedAttributesTable(rowId, Col_STOCKREFPRICE).value = Util.DblMaxStr(.stockRefPrice)
        ExtendedAttributesTable(rowId, Col_DELTA).value = Util.DblMaxStr(.delta)
        ExtendedAttributesTable(rowId, Col_STOCKRANGELOWER).value = Util.DblMaxStr(.stockRangeLower)
        ExtendedAttributesTable(rowId, Col_STOCKRANGEUPPER).value = Util.DblMaxStr(.stockRangeUpper)
        ExtendedAttributesTable(rowId, Col_VOLATILITY).value = Util.DblMaxStr(.volatility)
        ExtendedAttributesTable(rowId, Col_VOLATILITYTYPE).value = .volatilityType
        ExtendedAttributesTable(rowId, Col_REFPRICETYPE).value = .referencePriceType
        ExtendedAttributesTable(rowId, Col_DELTANEUORDTYPE).value = .deltaNeutralOrderType
        ExtendedAttributesTable(rowId, Col_CONTUPD).value = .continuousUpdate
        ExtendedAttributesTable(rowId, Col_DELTANEUAUXPRICE).value = Util.DblMaxStr(.deltaNeutralAuxPrice)
        ExtendedAttributesTable(rowId, Col_DELTANEUCONID).value = .deltaNeutralConId
        ExtendedAttributesTable(rowId, Col_DELTANEUSETTLINGFIRM).value = .deltaNeutralSettlingFirm
        ExtendedAttributesTable(rowId, Col_DELTANEUCLEARINGACCOUNT).value = .deltaNeutralClearingAccount
        ExtendedAttributesTable(rowId, Col_DELTANEUCLEARINGINTENT).value = .deltaNeutralClearingIntent
        ExtendedAttributesTable(rowId, Col_DELTANEUOPENCLOSE).value = .deltaNeutralOpenClose
        ExtendedAttributesTable(rowId, Col_DELTANEUSHORTSALE).value = .deltaNeutralShortSale
        ExtendedAttributesTable(rowId, Col_DELTANEUSHORTSALESLOT).value = .deltaNeutralShortSaleSlot
        ExtendedAttributesTable(rowId, Col_DELTANEUDESIGNATEDLOCATION).value = .deltaNeutralDesignatedLocation
        ExtendedAttributesTable(rowId, Col_TRAILSTOPPRICE).value = Util.DblMaxStr(.trailStopPrice)
        ExtendedAttributesTable(rowId, Col_TRAILINGPERCENT).value = Util.DblMaxStr(.trailingPercent)
        ExtendedAttributesTable(rowId, Col_SCALEINITLVLSIZE).value = Util.IntMaxStr(.scaleInitLevelSize)
        ExtendedAttributesTable(rowId, Col_SCALESUBSLVLSIZE).value = Util.IntMaxStr(.scaleSubsLevelSize)
        ExtendedAttributesTable(rowId, Col_SCALEPRICEINCR).value = Util.DblMaxStr(.scalePriceIncrement)
        ExtendedAttributesTable(rowId, Col_SCALEPRICEADJUSTVALUE).value = Util.DblMaxStr(.scalePriceAdjustValue)
        ExtendedAttributesTable(rowId, Col_SCALEPRICEADJUSTINTERVAL).value = Util.IntMaxStr(.scalePriceAdjustInterval)
        ExtendedAttributesTable(rowId, Col_SCALEPROFITOFFSET).value = Util.DblMaxStr(.scaleProfitOffset)
        ExtendedAttributesTable(rowId, Col_SCALEAUTORESET).value = .scaleAutoReset
        ExtendedAttributesTable(rowId, Col_SCALEINITPOSITION).value = Util.IntMaxStr(.scaleInitPosition)
        ExtendedAttributesTable(rowId, Col_SCALEINITFILLQTY).value = Util.IntMaxStr(.scaleInitFillQty)
        ExtendedAttributesTable(rowId, Col_SCALERANDOMPERCENT).value = .scaleRandomPercent
        ExtendedAttributesTable(rowId, Col_OUTSIDERTH).value = .outsideRth
        ExtendedAttributesTable(rowId, Col_OVERRIDEPERCONS).value = .overridePercentageConstraints
        ExtendedAttributesTable(rowId, Col_CLEARACC).value = .clearingAccount
        ExtendedAttributesTable(rowId, Col_CLEARINT).value = .clearingIntent
        ExtendedAttributesTable(rowId, Col_BASISPTS).value = Util.DblMaxStr(.basisPoints)
        ExtendedAttributesTable(rowId, Col_BASISPTSTYPE).value = Util.IntMaxStr(.basisPointsType)
        ExtendedAttributesTable(rowId, Col_OPT_OUT_SMART_ROUTING).value = .optOutSmartRouting
        ExtendedAttributesTable(rowId, Col_SOLICITED).value = .solicited
        ExtendedAttributesTable(rowId, Col_RANDOMIZE_SIZE).value = .randomizeSize
        ExtendedAttributesTable(rowId, Col_RANDOMIZE_PRICE).value = .randomizePrice
        ExtendedAttributesTable(rowId, Col_REFERENCE_CONTRACT_ID).value = .ReferenceContractId
        ExtendedAttributesTable(rowId, Col_REFERENCE_EXCHANGE).value = .ReferenceExchange
        ExtendedAttributesTable(rowId, Col_PEGGED_CHANGE_AMOUNT).value = Util.DblMaxStr(.PeggedChangeAmount)
        ExtendedAttributesTable(rowId, Col_REFERENCE_CHANGE_AMOUNT).value = Util.DblMaxStr(.ReferenceChangeAmount)
        ExtendedAttributesTable(rowId, Col_IS_PEGGED_CHANGE_AMOUNT_DECREASE).value = .IsPeggedChangeAmountDecrease
        ExtendedAttributesTable(rowId, Col_ADJUSTED_ORDER_TYPE).value = .adjustedOrderType
        ExtendedAttributesTable(rowId, Col_TRIGGER_PRICE).value = Util.DblMaxStr(.triggerPrice)
        ExtendedAttributesTable(rowId, Col_ADJUSTED_STOP_PRICE).value = Util.DblMaxStr(.adjustedStopPrice)
        ExtendedAttributesTable(rowId, Col_ADJUSTED_STOP_LIMIT_PRICE).value = Util.DblMaxStr(.adjustedStopLimitPrice)
        ExtendedAttributesTable(rowId, Col_ADJUSTED_TRAILING_AMOUNT).value = Util.DblMaxStr(.adjustedTrailingAmount)
        ExtendedAttributesTable(rowId, Col_ADJUSTABLE_TRAILING_UNIT).value = .adjustableTrailingUnit
        ExtendedAttributesTable(rowId, Col_CONDITIONS).value = Api.Tws.ConditionsToString(.Conditions)
        ExtendedAttributesTable(rowId, Col_CONDITIONS_IGNORE_RTH).value = .conditionsIgnoreRth
        ExtendedAttributesTable(rowId, Col_CONDITIONS_CANCEL_ORDER).value = .conditionsCancelOrder
        ExtendedAttributesTable(rowId, Col_MODELCODE).value = .modelCode
        ExtendedAttributesTable(rowId, Col_EXT_OPERATOR).value = .extOperator
        ExtendedAttributesTable(rowId, Col_SOFT_DOLLAR_TIER).value = .tier.name & ";" & .tier.value
        ExtendedAttributesTable(rowId, Col_IS_OMS_CONTAINER).value = .isOmsContainer
        ExtendedAttributesTable(rowId, Col_RELATIVE_DISCRETIONARY).value = .discretionaryUpToLimitPrice
        ExtendedAttributesTable(rowId, Col_USEPRICEMGMTALGO).value = .usePriceMgmtAlgo
    End With

    If Not order.SmartComboRoutingParams Is Nothing Then
        For i = 0 To order.SmartComboRoutingParams.Count - 1 Step 1
            tempStr = tempStr & order.SmartComboRoutingParams(i).tag & STR_EQUALSSIGN
            tempStr = tempStr & order.SmartComboRoutingParams(i).value & STR_SEMICOLON
        Next i
        ExtendedAttributesTable(rowId, Col_SMART_COMBO_ROUTING_PARAMS).value = tempStr
    End If

    With orderState
        orderStatusTable(rowId, Col_ORDERSTATUS).value = .status
    End With

End Sub

' update order status
Public Sub UpdateOrderStatus(orderId As Long, status As String, filled As Double, remaining As Double, avgFillPrice As Double, parentId As Long, permId As Long, lastFillPrice As Double)
    ' find row to update by using orderId
    Dim id As Long
    id = OrderUtils.FindOrderRowIndexByPermId(permId, orderStatusTable)
    If id <> 0 Then
        orderStatusTable(id, Col_ORDERSTATUS).value = status
        orderStatusTable(id, Col_FILLED).value = filled
        orderStatusTable(id, Col_REMAINING).value = remaining
        orderStatusTable(id, Col_AVGFILLPRICE).value = avgFillPrice
        orderStatusTable(id, Col_LASTFILLPRICE).value = lastFillPrice
        orderStatusTable(id, Col_PARENTID).value = parentId
        orderStatusTable(id, Col_PERMID).value = permId
    End If
End Sub

Private Sub Clear()
    contractTable.ClearContents
    orderDescriptionTable.ClearContents
    orderStatusTable.ClearContents
    ExtendedAttributesTable.ClearContents
End Sub

Public Sub Initialise()
    Set contractTable = Range("$A$7:$M$100")
    Set orderDescriptionTable = Range("$N$7:$S$100")
    Set orderStatusTable = Range("$T$7:$AA$100")
    Set ExtendedAttributesTable = Range("$AB$7:$DR$100")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub


