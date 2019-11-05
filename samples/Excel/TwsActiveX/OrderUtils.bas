Attribute VB_Name = "OrderUtils"
Option Explicit

Private Enum ExtendedOrderAttributesDefinitionColumns
    Col_ATTRIBUTE_NAME = 1
    Col_ATTRIBUTE_VALUE = 4
    Col_ATTRIBUTE_NOTES = 5
End Enum

Public Enum OrderDescriptionColumns
    Col_ACTION = 1
    Col_TOTALQTY
    Col_CASH_QTY
    Col_ORDERTYPE
    Col_LMTPRICE
    Col_AUXPRICE
End Enum

Public Enum OrderStatusColumns
    Col_ORDERID = 1
    Col_ORDERSTATUS
    Col_FILLED
    Col_REMAINING
    Col_AVGFILLPRICE
    Col_LASTFILLPRICE
    Col_PARENTID
    Col_PERMID
End Enum

Public Enum CommissionMarginColumns
' Pre-trade commissions and margin information (WhatIf)
    Col_COMMISSION = 1
    Col_COMMISSIONCURRENCY
    Col_EQUITYWITHLOANBEFORE
    Col_INITMARGINBEFORE
    Col_MAINTMARGINBEFORE
    Col_EQUITYWITHLOANCHANGE
    Col_INITMARGINCHANGE
    Col_MAINTMARGINCHANGE
    Col_EQUITYWITHLOANAFTER
    Col_INITMARGINAFTER
    Col_MAINTMARGINAFTER
End Enum

Public Enum ExtendedOrderAttributesColumns
    Col_TIMEINFORCE = 1
    Col_OCAGROUP
    Col_ACCOUNT
    Col_OPENCLOSE
    Col_ORIGIN
    Col_ORDERREF
    Col_TRANSMIT
    Col_PARENTORDID
    Col_BLOCKORDER
    Col_SWEEPTOFILL
    Col_DISPLAYSIZE
    Col_TRIGGERMETHOD
    Col_HIDDEN
    Col_DISCRAMOUNT
    Col_GOODAFTERTIME
    Col_GOODTILLDATE
    Col_FAGROUP
    Col_FAMETHOD
    Col_FAPERCENTAGE
    Col_FAPROFILE
    Col_SHORTSALESLOT
    Col_DESIGNLOC
    Col_EXEMPTCODE
    Col_OCATYPE
    Col_RULE80A
    Col_SETTLINGFIRM
    Col_ALLORNONE
    Col_MINQTY
    Col_PERCENTOFFSET
    Col_ETRADEONLY
    Col_FIRMQUOTEONLY
    Col_NBBOPRICECAP
    Col_OPT_OUT_SMART_ROUTING
    Col_AUCTIONSTRAT
    Col_STARTINGPRICE
    Col_STOCKREFPRICE
    Col_DELTA
    Col_STOCKRANGELOWER
    Col_STOCKRANGEUPPER
    Col_VOLATILITY
    Col_VOLATILITYTYPE
    Col_REFPRICETYPE
    Col_DELTANEUORDTYPE
    Col_CONTUPD
    Col_DELTANEUAUXPRICE
    Col_DELTANEUCONID
    Col_DELTANEUSETTLINGFIRM
    Col_DELTANEUCLEARINGACCOUNT
    Col_DELTANEUCLEARINGINTENT
    Col_DELTANEUOPENCLOSE
    Col_DELTANEUSHORTSALE
    Col_DELTANEUSHORTSALESLOT
    Col_DELTANEUDESIGNATEDLOCATION
    Col_TRAILSTOPPRICE
    Col_TRAILINGPERCENT
    Col_SCALEINITLVLSIZE
    Col_SCALESUBSLVLSIZE
    Col_SCALEPRICEINCR
    Col_SCALEPRICEADJUSTVALUE
    Col_SCALEPRICEADJUSTINTERVAL
    Col_SCALEPROFITOFFSET
    Col_SCALEAUTORESET
    Col_SCALEINITPOSITION
    Col_SCALEINITFILLQTY
    Col_SCALERANDOMPERCENT
    Col_OUTSIDERTH
    Col_OVERRIDEPERCONS
    Col_CLEARACC
    Col_CLEARINT
    Col_BASISPTS
    Col_BASISPTSTYPE
    Col_SMART_COMBO_ROUTING_PARAMS
    Col_SOLICITED
    Col_RANDOMIZE_SIZE
    Col_RANDOMIZE_PRICE
    Col_REFERENCE_CONTRACT_ID
    Col_REFERENCE_EXCHANGE
    Col_PEGGED_CHANGE_AMOUNT
    Col_REFERENCE_CHANGE_AMOUNT
    Col_IS_PEGGED_CHANGE_AMOUNT_DECREASE
    Col_ADJUSTED_ORDER_TYPE
    Col_TRIGGER_PRICE
    Col_ADJUSTED_STOP_PRICE
    Col_ADJUSTED_STOP_LIMIT_PRICE
    Col_ADJUSTED_TRAILING_AMOUNT
    Col_ADJUSTABLE_TRAILING_UNIT
    Col_CONDITIONS
    Col_CONDITIONS_IGNORE_RTH
    Col_CONDITIONS_CANCEL_ORDER
    Col_MODELCODE
    Col_EXT_OPERATOR
    Col_SOFT_DOLLAR_TIER
    Col_IS_OMS_CONTAINER
    Col_RELATIVE_DISCRETIONARY
    Col_USEPRICEMGMTALGO
End Enum

' other constants
Public Const STR_ORDER_CANCELLED = "Cancelled"
Public Const STR_ORDER_SENTTOTWS = "Sent to TWS"
Public Const STR_ORDER_WHATIF = "WhatIf"

Public Sub ApplyExtendedTemplate(orderIndex As Long, extendedOrderAttributesTable As Range)
    Dim i As Long
    For i = 1 To ExtendedOrderAttributes.ExtendedAttributesTable.Rows.Count
        extendedOrderAttributesTable(orderIndex, i).value = ExtendedOrderAttributes.ExtendedAttributesTable(i, Col_ATTRIBUTE_VALUE).value
    Next i
End Sub

Public Sub CancelOrders(orderStatusTable As Range)
    If Not CheckConnected Then Exit Sub
    
    Dim i As Long
    Dim row As Object
    For Each row In Selection.Rows
        i = row.row - orderStatusTable.Rows(1).row + 1
        If orderStatusTable(i, Col_ORDERSTATUS).value <> "" Then
            Api.Tws.CancelOrder orderStatusTable(i, Col_ORDERID).value

            orderStatusTable(i, Col_ORDERSTATUS).value = STR_ORDER_CANCELLED
        End If
    Next
End Sub

' find empty row for order
Public Function FindFirstEmptyOrderRow(column As Long, orderStatusTable As Range) As Long
    Dim i As Long
    For i = 1 To orderStatusTable.Rows.Count
        If orderStatusTable(i, column).value = STR_EMPTY Then
            FindFirstEmptyOrderRow = i
            Exit Function
        End If
    Next

    FindFirstEmptyOrderRow = 0
End Function

Public Function FindOrderRowIndex(orderId As Long, orderStatusTable As Range) As Long
    Dim i As Long
    For i = 1 To orderStatusTable.Rows.Count
        If CLng(orderStatusTable(i, OrderStatusColumns.Col_ORDERID)) = orderId Then
            FindOrderRowIndex = i
            Exit Function
        End If
    Next
    
    FindOrderRowIndex = 0
End Function

Public Function FindOrderRowIndexByPermId(permId As Long, orderStatusTable As Range) As Long
    Dim i As Long
    For i = 1 To orderStatusTable.Rows.Count
        If CLng(orderStatusTable(i, OrderStatusColumns.Col_PERMID)) = permId Then
            FindOrderRowIndexByPermId = i
            Exit Function
        End If
    Next
    
    FindOrderRowIndexByPermId = 0
End Function

Public Sub PlaceModifyOrders( _
                ByVal contractDescriptionTable As Range, _
                ByVal orderDescriptionTable As Range, _
                ByVal orderStatusTable As Range, _
                ByVal extendedAttributeTable As Range, _
                ByVal WhatIf As Boolean)
    If Not CheckConnected Then Exit Sub
    
    Dim orderIndex As Long
    
    Dim row As Object
    For Each row In Selection.Rows
        orderIndex = row.row - contractDescriptionTable.Rows(1).row + 1

        PlaceModifyOrder orderIndex, _
                        contractDescriptionTable, _
                        orderDescriptionTable, _
                        orderStatusTable, _
                        extendedAttributeTable, _
                        WhatIf

    Next
    
    ActiveCell.Offset(1, 0).Activate
End Sub

' place / modify order
Private Sub PlaceModifyOrder( _
                ByVal orderIndex As Long, _
                ByVal contractDescriptionTable As Range, _
                ByVal orderDescriptionTable As Range, _
                ByVal orderStatusTable As Range, _
                ByVal extendedAttributeTable As Range, _
                ByVal WhatIf As Boolean)
    If Not CheckConnected Then Exit Sub
    
    Dim orderId As Long
    
    ' create contract structure
    Dim lContractInfo As TWSLib.IContract
    Set lContractInfo = Api.Tws.createContract()
    
    ' create order structure
    Dim lOrderInfo As TWSLib.IOrder
    Set lOrderInfo = Api.Tws.createOrder()
    
    ' orderIndex - place or modify order
    If orderStatusTable(orderIndex, Col_ORDERID).value <> STR_EMPTY Then
        orderId = Val(orderStatusTable(orderIndex, Col_ORDERID).value)
    Else
        orderId = Api.NextOrderId
    End If
    
    ' contract info
    With lContractInfo
        .Symbol = UCase(contractDescriptionTable(orderIndex, Col_SYMBOL).value)
        .SecType = UCase(contractDescriptionTable(orderIndex, Col_SECTYPE).value)
        .lastTradeDateOrContractMonth = contractDescriptionTable(orderIndex, Col_LASTTRADEDATE).value
        .Strike = contractDescriptionTable(orderIndex, Col_STRIKE).value
        .Right = UCase(contractDescriptionTable(orderIndex, Col_RIGHT).value)
        .multiplier = UCase(contractDescriptionTable(orderIndex, Col_MULTIPLIER).value)
        .exchange = UCase(contractDescriptionTable(orderIndex, Col_EXCH).value)
        .primaryExchange = UCase(contractDescriptionTable(orderIndex, Col_PRIMEXCH).value)
        .currency = UCase(contractDescriptionTable(orderIndex, Col_CURRENCY).value)
        .localSymbol = UCase(contractDescriptionTable(orderIndex, Col_LOCALSYMBOL).value)
        .conId = contractDescriptionTable(orderIndex, Col_CONID).value
    End With

    ' order info
    With lOrderInfo
        .action = UCase(orderDescriptionTable(orderIndex, Col_ACTION).value)    ' BUY, SELL, SSHORT
        .totalQuantity = UCase(orderDescriptionTable(orderIndex, Col_TOTALQTY).value)    ' the order quantity
        .cashQty = Util.SetNonEmptyValue(orderDescriptionTable(orderIndex, Col_CASH_QTY).value, .cashQty) ' the order cash quantity
        .orderType = UCase(orderDescriptionTable(orderIndex, Col_ORDERTYPE).value) ' MKT, MKTCLS, LMT, LMTCLS, PEGMKT, SCALE, STP, STPLMT, TRAIL, REL, VWAP, TRAILLIMIT
        .lmtPrice = orderDescriptionTable(orderIndex, Col_LMTPRICE).value         ' limit price
        .auxPrice = orderDescriptionTable(orderIndex, Col_AUXPRICE).value         ' stop price
        
        ' extended order attributes
        .timeInForce = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_TIMEINFORCE).value, .timeInForce)
        .ocaGroup = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_OCAGROUP).value, .ocaGroup)
        .Account = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_ACCOUNT).value, .Account)
        .openClose = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_OPENCLOSE).value, .openClose)
        .origin = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_ORIGIN).value, .origin)
        .orderRef = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_ORDERREF).value, .orderRef)
        .transmit = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_TRANSMIT).value, .transmit)
        .parentId = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_PARENTORDID).value, .parentId)
        .blockOrder = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_BLOCKORDER).value, .blockOrder)
        .sweepToFill = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SWEEPTOFILL).value, .sweepToFill)
        .displaySize = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DISPLAYSIZE).value, .displaySize)
        .triggerMethod = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_TRIGGERMETHOD).value, .triggerMethod)
        .Hidden = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_HIDDEN).value, .Hidden)
        .discretionaryAmt = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DISCRAMOUNT).value, .discretionaryAmt)
        .goodAfterTime = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_GOODAFTERTIME).value, .goodAfterTime)
        .goodTillDate = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_GOODTILLDATE).value, .goodTillDate)
        .faGroup = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_FAGROUP).value, .faGroup)
        .faMethod = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_FAMETHOD).value, .faMethod)
        .faPercentage = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_FAPERCENTAGE).value, .faPercentage)
        .faProfile = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_FAPROFILE).value, .faProfile)
        .shortSaleSlot = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SHORTSALESLOT).value, .shortSaleSlot)
        .designatedLocation = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DESIGNLOC).value, .designatedLocation)
        .exemptCode = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_EXEMPTCODE).value, .exemptCode)
        .ocaType = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_OCATYPE).value, .ocaType)
        .rule80A = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_RULE80A).value, .rule80A)
        .settlingFirm = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SETTLINGFIRM).value, .settlingFirm)
        .allOrNone = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_ALLORNONE).value, .allOrNone)
        .minQty = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_MINQTY).value, .minQty)
        .percentOffset = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_PERCENTOFFSET).value, .percentOffset)
        .eTradeOnly = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_ETRADEONLY).value, .eTradeOnly)
        .firmQuoteOnly = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_FIRMQUOTEONLY).value, .firmQuoteOnly)
        .nbboPriceCap = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_NBBOPRICECAP).value, .nbboPriceCap)
        .auctionStrategy = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_AUCTIONSTRAT).value, .auctionStrategy)
        .startingPrice = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_STARTINGPRICE).value, .startingPrice)
        .stockRefPrice = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_STOCKREFPRICE).value, .stockRefPrice)
        .delta = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DELTA).value, .delta)
        .stockRangeLower = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_STOCKRANGELOWER).value, .stockRangeLower)
        .stockRangeUpper = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_STOCKRANGEUPPER).value, .stockRangeUpper)
        .volatility = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_VOLATILITY).value, .volatility)
        .volatilityType = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_VOLATILITYTYPE).value, .volatilityType)
        .referencePriceType = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_REFPRICETYPE).value, .referencePriceType)
        .deltaNeutralOrderType = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DELTANEUORDTYPE).value, .deltaNeutralOrderType)
        .continuousUpdate = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_CONTUPD).value, .continuousUpdate)
        .deltaNeutralAuxPrice = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DELTANEUAUXPRICE).value, .deltaNeutralAuxPrice)
        .deltaNeutralConId = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DELTANEUCONID).value, .deltaNeutralConId)
        .deltaNeutralSettlingFirm = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DELTANEUSETTLINGFIRM).value, .deltaNeutralSettlingFirm)
        .deltaNeutralClearingAccount = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DELTANEUCLEARINGACCOUNT).value, .deltaNeutralClearingAccount)
        .deltaNeutralClearingIntent = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DELTANEUCLEARINGINTENT).value, .deltaNeutralClearingIntent)
        .deltaNeutralOpenClose = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DELTANEUOPENCLOSE).value, .deltaNeutralOpenClose)
        .deltaNeutralShortSale = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DELTANEUSHORTSALE).value, .deltaNeutralShortSale)
        .deltaNeutralShortSaleSlot = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DELTANEUSHORTSALESLOT).value, .deltaNeutralShortSaleSlot)
        .deltaNeutralDesignatedLocation = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_DELTANEUDESIGNATEDLOCATION).value, .deltaNeutralDesignatedLocation)
        .trailStopPrice = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_TRAILSTOPPRICE).value, .trailStopPrice)
        .trailingPercent = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_TRAILINGPERCENT).value, .trailingPercent)
        .scaleInitLevelSize = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SCALEINITLVLSIZE).value, .scaleInitLevelSize)
        .scaleSubsLevelSize = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SCALESUBSLVLSIZE).value, .scaleSubsLevelSize)
        .scalePriceIncrement = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SCALEPRICEINCR).value, .scalePriceIncrement)
        .scalePriceAdjustValue = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SCALEPRICEADJUSTVALUE).value, .scalePriceAdjustValue)
        .scalePriceAdjustInterval = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SCALEPRICEADJUSTINTERVAL).value, .scalePriceAdjustInterval)
        .scaleProfitOffset = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SCALEPROFITOFFSET).value, .scaleProfitOffset)
        .scaleAutoReset = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SCALEAUTORESET).value, .scaleAutoReset)
        .scaleInitPosition = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SCALEINITPOSITION).value, .scaleInitPosition)
        .scaleInitFillQty = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SCALEINITFILLQTY).value, .scaleInitFillQty)
        .scaleRandomPercent = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SCALERANDOMPERCENT).value, .scaleRandomPercent)
        .outsideRth = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_OUTSIDERTH).value, .outsideRth)
        .overridePercentageConstraints = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_OVERRIDEPERCONS).value, .overridePercentageConstraints)
        .clearingAccount = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_CLEARACC).value, .clearingAccount)
        .clearingIntent = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_CLEARINT).value, .clearingIntent)
        .basisPoints = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_BASISPTS).value, .basisPoints)
        .basisPointsType = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_BASISPTSTYPE).value, .basisPointsType)
        .optOutSmartRouting = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_OPT_OUT_SMART_ROUTING).value, .optOutSmartRouting)
        .WhatIf = WhatIf
        .solicited = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SOLICITED).value, .solicited)
        .randomizeSize = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_RANDOMIZE_SIZE).value, .randomizeSize)
        .randomizePrice = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_RANDOMIZE_PRICE).value, .randomizePrice)
        .ReferenceContractId = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_REFERENCE_CONTRACT_ID).value, .ReferenceContractId)
        .ReferenceExchange = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_REFERENCE_EXCHANGE).value, .ReferenceExchange)
        .PeggedChangeAmount = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_PEGGED_CHANGE_AMOUNT).value, .PeggedChangeAmount)
        .ReferenceChangeAmount = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_REFERENCE_CHANGE_AMOUNT).value, .ReferenceChangeAmount)
        .IsPeggedChangeAmountDecrease = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_IS_PEGGED_CHANGE_AMOUNT_DECREASE).value, .IsPeggedChangeAmountDecrease)
        .adjustedOrderType = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_ADJUSTED_ORDER_TYPE).value, .adjustedOrderType)
        .triggerPrice = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_TRIGGER_PRICE).value, .triggerPrice)
        .adjustedStopPrice = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_ADJUSTED_STOP_PRICE).value, .adjustedStopPrice)
        .adjustedStopLimitPrice = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_ADJUSTED_STOP_LIMIT_PRICE).value, .adjustedStopLimitPrice)
        .adjustedTrailingAmount = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_ADJUSTED_TRAILING_AMOUNT).value, .adjustedTrailingAmount)
        .adjustableTrailingUnit = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_ADJUSTABLE_TRAILING_UNIT).value, .adjustableTrailingUnit)
        Set .Conditions = Api.Tws.ParseConditions(extendedAttributeTable(orderIndex, Col_CONDITIONS).value)
        .conditionsIgnoreRth = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_CONDITIONS_IGNORE_RTH).value, .conditionsIgnoreRth)
        .conditionsCancelOrder = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_CONDITIONS_CANCEL_ORDER).value, .conditionsCancelOrder)
        .modelCode = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_MODELCODE).value, .modelCode)
        .extOperator = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_EXT_OPERATOR).value, .extOperator)
        Dim strTier As String
        strTier = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_SOFT_DOLLAR_TIER).value, .tier.name & ";" & .tier.value)
        .tier.name = Mid$(strTier, 1, InStr(1, strTier, ";") - 1)
        .tier.value = Mid$(strTier, InStr(1, strTier, ";") + 1)
        .isOmsContainer = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_IS_OMS_CONTAINER).value, .isOmsContainer)
        .discretionaryUpToLimitPrice = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_RELATIVE_DISCRETIONARY).value, .discretionaryUpToLimitPrice)
        .usePriceMgmtAlgo = Util.SetNonEmptyValue(extendedAttributeTable(orderIndex, Col_USEPRICEMGMTALGO).value, .usePriceMgmtAlgo)
    End With

    ' combo legs
    If contractDescriptionTable(orderIndex, Col_SECTYPE).value = SECTYPE_BAG And _
    contractDescriptionTable(orderIndex, Col_COMBOLEGS).value <> STR_EMPTY Then
        ' create combo leg list
        Set lContractInfo.ComboLegs = Api.Tws.createComboLegList()
        
        ' create order combo leg list
        Set lOrderInfo.orderComboLegs = Api.Tws.createOrderComboLegList()
        
        ' parse combo legs string
        Util.ParseComboLegsIntoStruct contractDescriptionTable(orderIndex, Col_COMBOLEGS).value, lContractInfo.ComboLegs, lOrderInfo.orderComboLegs
    End If

    ' under comp
    If contractDescriptionTable(orderIndex, Col_SECTYPE).value = SECTYPE_BAG And _
        contractDescriptionTable(orderIndex, Col_DELTANEUTRALCONTRACT).value <> STR_EMPTY Then
        ' create under comp
        Set lContractInfo.deltaNeutralContract = Api.Tws.createDeltaNeutralContract()
        
        ' parse under comp info
        Util.ParseDeltaNeutralContractIntoStruct contractDescriptionTable(orderIndex, Col_DELTANEUTRALCONTRACT).value, lContractInfo.deltaNeutralContract
    End If

    ' smart combo routing params
    If contractDescriptionTable(orderIndex, Col_SECTYPE).value = SECTYPE_BAG And _
        extendedAttributeTable(orderIndex, Col_SMART_COMBO_ROUTING_PARAMS).value <> STR_EMPTY Then

        ' create smart combo routing params
        Set lOrderInfo.SmartComboRoutingParams = Api.Tws.createTagValueList()

        ' parse smart combo routing params
        Util.ParseSmartComboRoutingParamsIntoStruct extendedAttributeTable(orderIndex, Col_SMART_COMBO_ROUTING_PARAMS).value, lOrderInfo.SmartComboRoutingParams
    End If
    
    ' order misc options
    Set lOrderInfo.orderMiscOptions = Api.Tws.createTagValueList()

    'place order
    Api.Tws.PlaceOrderEx orderId, lContractInfo, lOrderInfo
    
    ' requesting next valid orderIndex
    If orderStatusTable(orderIndex, Col_ORDERID).value = STR_EMPTY Then
        Api.Tws.reqIds 1
    End If
    
    ' update order orderIndex in table
    If WhatIf Then
        orderStatusTable(orderIndex, Col_ORDERID).value = orderId
        orderStatusTable(orderIndex, Col_ORDERSTATUS).value = STR_ORDER_WHATIF
    Else
        orderStatusTable(orderIndex, Col_ORDERID).value = orderId
        orderStatusTable(orderIndex, Col_ORDERSTATUS).value = STR_ORDER_SENTTOTWS
        orderStatusTable(orderIndex, Col_FILLED).value = 0
        orderStatusTable(orderIndex, Col_REMAINING).value = lOrderInfo.totalQuantity
        orderStatusTable(orderIndex, Col_AVGFILLPRICE).value = 0
        orderStatusTable(orderIndex, Col_LASTFILLPRICE).value = 0
        orderStatusTable(orderIndex, Col_PARENTID).value = 0
    End If
End Sub

Public Sub ProcessError(orderStatusTable As Range, ByVal orderId As Long, ByVal errorCode As Long, ByVal errorMsg As String)
    Dim i As Long
    i = FindOrderRowIndex(orderId, orderStatusTable)
    If i = 0 Then Exit Sub
    
    orderStatusTable(i, Col_ORDERSTATUS).value = STR_ERROR + STR_COLON + Str(errorCode) + STR_SPACE + errorMsg
End Sub

' update order status
Public Sub UpdateOrderStatus(orderStatusTable As Range, orderId As Long, status As String, filled As Double, remaining As Double, avgFillPrice As Double, parentId As Long, lastFillPrice As Double)
    ' find row to update by using orderId
    Dim rowId As Long
    rowId = FindOrderRowIndex(orderId, orderStatusTable)
    If rowId = 0 Then Exit Sub
    
    If rowId <= orderStatusTable.Rows.Count Then
        orderStatusTable(rowId, Col_ORDERSTATUS).value = status
        orderStatusTable(rowId, Col_FILLED).value = filled
        orderStatusTable(rowId, Col_REMAINING).value = remaining
        orderStatusTable(rowId, Col_AVGFILLPRICE).value = avgFillPrice
        orderStatusTable(rowId, Col_LASTFILLPRICE).value = lastFillPrice
        orderStatusTable(rowId, Col_PARENTID).value = parentId
    End If
End Sub

Public Sub UpdateWhatIfInfo(orderStatusTable As Range, commissionMarginTable As Range, orderId As Long, contract As TWSLib.IContract, order As TWSLib.IOrder, orderState As TWSLib.IOrderState)
    ' find row to update by using orderId
    Dim i As Long
    i = FindOrderRowIndex(orderId, orderStatusTable)
    If i = 0 Then Exit Sub
    
    commissionMarginTable(i, Col_COMMISSION).value = orderState.commission
    commissionMarginTable(i, Col_COMMISSIONCURRENCY).value = orderState.commissionCurrency
    commissionMarginTable(i, Col_EQUITYWITHLOANBEFORE).value = orderState.equityWithLoanBefore
    commissionMarginTable(i, Col_INITMARGINBEFORE).value = orderState.initMarginBefore
    commissionMarginTable(i, Col_MAINTMARGINBEFORE).value = orderState.maintMarginBefore
    commissionMarginTable(i, Col_EQUITYWITHLOANCHANGE).value = orderState.equityWithLoanChange
    commissionMarginTable(i, Col_INITMARGINCHANGE).value = orderState.initMarginChange
    commissionMarginTable(i, Col_MAINTMARGINCHANGE).value = orderState.maintMarginChange
    commissionMarginTable(i, Col_EQUITYWITHLOANAFTER).value = orderState.equityWithLoanAfter
    commissionMarginTable(i, Col_INITMARGINAFTER).value = orderState.initMarginAfter
    commissionMarginTable(i, Col_MAINTMARGINAFTER).value = orderState.maintMarginAfter
End Sub





