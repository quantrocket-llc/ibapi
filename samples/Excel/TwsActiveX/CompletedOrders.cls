VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CompletedOrders"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private contractTable As Range
Private completedOrderDescriptionTable As Range
Private completedOrderStatusTable As Range
Private ExtendedCompletedOrderAttributesTable As Range

'=================
' local constants
'=================
Private Enum CompletedOrderDescriptionColumns
    Col_ACTION = 1
    Col_TOTALQTY
    Col_CASHQTY
    Col_FILLEDQTY
    Col_ORDERTYPE
    Col_LMTPRICE
    Col_AUXPRICE
End Enum

Private Enum CompletedOrderStatusColumns
    Col_ORDERSTATUS = 1
    Col_COMPLETEDTIME
    Col_COMPLETEDSTATUS
    Col_PERMID
    Col_PARENTPERMID
End Enum

Private Enum ExtendedCompletedOrderAttributesColumns
    Col_TIMEINFORCE = 1
    Col_OCAGROUP
    Col_ACCOUNT
    Col_OPENCLOSE
    Col_ORIGIN
    Col_ORDERREF
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
    Col_CLEARACC
    Col_CLEARINT
    Col_HEDGETYPE
    Col_HEDGEPARAM
    Col_DONTUSEAUTOPRICEFORHEDGE
    Col_ALGOSTRATEGY
    Col_ALGOPARAMS
    Col_SMART_COMBO_ROUTING_PARAMS
    Col_ORDER_COMBO_LEGS
    Col_NOTHELD
    Col_SOLICITED
    Col_RANDOMIZE_SIZE
    Col_RANDOMIZE_PRICE
    Col_REFERENCE_CONTRACT_ID
    Col_REFERENCE_EXCHANGE
    Col_PEGGED_CHANGE_AMOUNT
    Col_REFERENCE_CHANGE_AMOUNT
    Col_IS_PEGGED_CHANGE_AMOUNT_DECREASE
    Col_LIMIT_PRICE_OFFSET
    Col_CONDITIONS
    Col_CONDITIONS_IGNORE_RTH
    Col_CONDITIONS_CANCEL_ORDER
    Col_MODELCODE
    Col_IS_OMS_CONTAINER
    Col_AUTO_CANCEL_DATE
    Col_REF_FUTURES_CONID
    Col_AUTO_CANCEL_PARENT
    Col_SHAREHOLDER
    Col_IMBALANCEE_ONLY
    Col_ROUTE_MARKETABLE_TO_BBO
End Enum

'=================
' private methods
'=================
' clear completed orders table
Private Sub ClearCompletedOrders_Click()
    Clear
  
End Sub


' request all completed orders
Private Sub RequestAllCompletedOrders_Click()
    If Not CheckConnected Then Exit Sub

    Clear
    Api.Tws.reqCompletedOrders False
End Sub

' request completed orders
Private Sub RequestCompletedOrders_Click()
    If Not CheckConnected Then Exit Sub

    Clear
    Api.Tws.reqCompletedOrders True
End Sub

'=================
' public methods
'=================
' update completed orders table with new values
Sub UpdateCompletedOrder(contract As TWSLib.IContract, order As TWSLib.IOrder, orderState As TWSLib.IOrderState)

    ' find row by orderId
    Dim rowId As Long
    rowId = OrderUtils.FindFirstEmptyOrderRow(Col_PERMID, completedOrderStatusTable)

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
        completedOrderDescriptionTable(rowId, Col_ACTION).value = .action
        completedOrderDescriptionTable(rowId, Col_TOTALQTY).value = .totalQuantity
        completedOrderDescriptionTable(rowId, Col_CASH_QTY).value = Util.DblMaxStr(.cashQty)
        completedOrderDescriptionTable(rowId, Col_FILLEDQTY).value = .filledQuantity
        completedOrderDescriptionTable(rowId, Col_ORDERTYPE).value = .orderType
        completedOrderDescriptionTable(rowId, Col_LMTPRICE).value = Util.DblMaxStr(.lmtPrice)
        completedOrderDescriptionTable(rowId, Col_AUXPRICE).value = Util.DblMaxStr(.auxPrice)
    End With

    With orderState
        completedOrderStatusTable(rowId, Col_ORDERSTATUS).value = .status
        completedOrderStatusTable(rowId, Col_COMPLETEDTIME).value = .completedTime
        completedOrderStatusTable(rowId, Col_COMPLETEDSTATUS).value = .completedStatus
    End With
    
    With order
        completedOrderStatusTable(rowId, Col_PERMID).value = .permId
        completedOrderStatusTable(rowId, Col_PARENTPERMID).value = Util.LongMaxStr(.parentPermId)
    End With

    With order
        ' extended order attributes
        ExtendedCompletedOrderAttributesTable(rowId, Columns(Col_TIMEINFORCE).column).value = .timeInForce
        ExtendedCompletedOrderAttributesTable(rowId, Col_OCAGROUP).value = .ocaGroup
        ExtendedCompletedOrderAttributesTable(rowId, Col_ACCOUNT).value = .Account

        If contract.SecType Like SECTYPE_OPT Or contract.SecType Like SECTYPE_FOP Then
            ExtendedCompletedOrderAttributesTable(rowId, Col_OPENCLOSE).value = .openClose
        End If

        ExtendedCompletedOrderAttributesTable(rowId, Col_ORIGIN).value = .origin
        ExtendedCompletedOrderAttributesTable(rowId, Col_ORDERREF).value = .orderRef
        ExtendedCompletedOrderAttributesTable(rowId, Col_SWEEPTOFILL).value = .sweepToFill
        ExtendedCompletedOrderAttributesTable(rowId, Col_DISPLAYSIZE).value = .displaySize
        ExtendedCompletedOrderAttributesTable(rowId, Col_TRIGGERMETHOD).value = .triggerMethod
        ExtendedCompletedOrderAttributesTable(rowId, Col_HIDDEN).value = .Hidden
        ExtendedCompletedOrderAttributesTable(rowId, Col_DISCRAMOUNT).value = .discretionaryAmt
        ExtendedCompletedOrderAttributesTable(rowId, Col_GOODAFTERTIME).value = .goodAfterTime
        ExtendedCompletedOrderAttributesTable(rowId, Col_GOODTILLDATE).value = .goodTillDate
        ExtendedCompletedOrderAttributesTable(rowId, Col_FAGROUP).value = .faGroup
        ExtendedCompletedOrderAttributesTable(rowId, Col_FAMETHOD).value = .faMethod
        ExtendedCompletedOrderAttributesTable(rowId, Col_FAPERCENTAGE).value = .faPercentage
        ExtendedCompletedOrderAttributesTable(rowId, Col_FAPROFILE).value = .faProfile
        ExtendedCompletedOrderAttributesTable(rowId, Col_SHORTSALESLOT).value = .shortSaleSlot
        ExtendedCompletedOrderAttributesTable(rowId, Col_DESIGNLOC).value = .designatedLocation
        ExtendedCompletedOrderAttributesTable(rowId, Col_EXEMPTCODE).value = .exemptCode
        ExtendedCompletedOrderAttributesTable(rowId, Col_OCATYPE).value = .ocaType
        ExtendedCompletedOrderAttributesTable(rowId, Col_RULE80A).value = .rule80A
        ExtendedCompletedOrderAttributesTable(rowId, Col_SETTLINGFIRM).value = .settlingFirm
        ExtendedCompletedOrderAttributesTable(rowId, Col_ALLORNONE).value = .allOrNone
        ExtendedCompletedOrderAttributesTable(rowId, Col_MINQTY).value = Util.IntMaxStr(.minQty)
        ExtendedCompletedOrderAttributesTable(rowId, Col_PERCENTOFFSET).value = Util.DblMaxStr(.percentOffset)
        ExtendedCompletedOrderAttributesTable(rowId, Col_STARTINGPRICE).value = Util.DblMaxStr(.startingPrice)
        ExtendedCompletedOrderAttributesTable(rowId, Col_STOCKREFPRICE).value = Util.DblMaxStr(.stockRefPrice)
        ExtendedCompletedOrderAttributesTable(rowId, Col_DELTA).value = Util.DblMaxStr(.delta)
        ExtendedCompletedOrderAttributesTable(rowId, Col_STOCKRANGELOWER).value = Util.DblMaxStr(.stockRangeLower)
        ExtendedCompletedOrderAttributesTable(rowId, Col_STOCKRANGEUPPER).value = Util.DblMaxStr(.stockRangeUpper)
        ExtendedCompletedOrderAttributesTable(rowId, Col_VOLATILITY).value = Util.DblMaxStr(.volatility)
        ExtendedCompletedOrderAttributesTable(rowId, Col_VOLATILITYTYPE).value = .volatilityType
        ExtendedCompletedOrderAttributesTable(rowId, Col_REFPRICETYPE).value = .referencePriceType
        ExtendedCompletedOrderAttributesTable(rowId, Col_DELTANEUORDTYPE).value = .deltaNeutralOrderType
        ExtendedCompletedOrderAttributesTable(rowId, Col_CONTUPD).value = .continuousUpdate
        ExtendedCompletedOrderAttributesTable(rowId, Col_DELTANEUAUXPRICE).value = Util.DblMaxStr(.deltaNeutralAuxPrice)
        ExtendedCompletedOrderAttributesTable(rowId, Col_DELTANEUCONID).value = .deltaNeutralConId
        ExtendedCompletedOrderAttributesTable(rowId, Col_DELTANEUSHORTSALE).value = .deltaNeutralShortSale
        ExtendedCompletedOrderAttributesTable(rowId, Col_DELTANEUSHORTSALESLOT).value = .deltaNeutralShortSaleSlot
        ExtendedCompletedOrderAttributesTable(rowId, Col_DELTANEUDESIGNATEDLOCATION).value = .deltaNeutralDesignatedLocation
        ExtendedCompletedOrderAttributesTable(rowId, Col_TRAILSTOPPRICE).value = Util.DblMaxStr(.trailStopPrice)
        ExtendedCompletedOrderAttributesTable(rowId, Col_TRAILINGPERCENT).value = Util.DblMaxStr(.trailingPercent)
        ExtendedCompletedOrderAttributesTable(rowId, Col_SCALEINITLVLSIZE).value = Util.IntMaxStr(.scaleInitLevelSize)
        ExtendedCompletedOrderAttributesTable(rowId, Col_SCALESUBSLVLSIZE).value = Util.IntMaxStr(.scaleSubsLevelSize)
        ExtendedCompletedOrderAttributesTable(rowId, Col_SCALEPRICEINCR).value = Util.DblMaxStr(.scalePriceIncrement)
        ExtendedCompletedOrderAttributesTable(rowId, Col_SCALEPRICEADJUSTVALUE).value = Util.DblMaxStr(.scalePriceAdjustValue)
        ExtendedCompletedOrderAttributesTable(rowId, Col_SCALEPRICEADJUSTINTERVAL).value = Util.IntMaxStr(.scalePriceAdjustInterval)
        ExtendedCompletedOrderAttributesTable(rowId, Col_SCALEPROFITOFFSET).value = Util.DblMaxStr(.scaleProfitOffset)
        ExtendedCompletedOrderAttributesTable(rowId, Col_SCALEAUTORESET).value = .scaleAutoReset
        ExtendedCompletedOrderAttributesTable(rowId, Col_SCALEINITPOSITION).value = Util.IntMaxStr(.scaleInitPosition)
        ExtendedCompletedOrderAttributesTable(rowId, Col_SCALEINITFILLQTY).value = Util.IntMaxStr(.scaleInitFillQty)
        ExtendedCompletedOrderAttributesTable(rowId, Col_SCALERANDOMPERCENT).value = .scaleRandomPercent
        ExtendedCompletedOrderAttributesTable(rowId, Col_OUTSIDERTH).value = .outsideRth
        ExtendedCompletedOrderAttributesTable(rowId, Col_CLEARACC).value = .clearingAccount
        ExtendedCompletedOrderAttributesTable(rowId, Col_CLEARINT).value = .clearingIntent
        ExtendedCompletedOrderAttributesTable(rowId, Col_HEDGETYPE).value = .hedgeType
        ExtendedCompletedOrderAttributesTable(rowId, Col_HEDGEPARAM).value = .hedgeParam
        ExtendedCompletedOrderAttributesTable(rowId, Col_DONTUSEAUTOPRICEFORHEDGE).value = .dontUseAutoPriceForHedge
        ExtendedCompletedOrderAttributesTable(rowId, Col_ALGOSTRATEGY).value = .algoStrategy
        ExtendedCompletedOrderAttributesTable(rowId, Col_NOTHELD).value = .notHeld
        ExtendedCompletedOrderAttributesTable(rowId, Col_SOLICITED).value = .solicited
        ExtendedCompletedOrderAttributesTable(rowId, Col_RANDOMIZE_SIZE).value = .randomizeSize
        ExtendedCompletedOrderAttributesTable(rowId, Col_RANDOMIZE_PRICE).value = .randomizePrice
        ExtendedCompletedOrderAttributesTable(rowId, Col_REFERENCE_CONTRACT_ID).value = .ReferenceContractId
        ExtendedCompletedOrderAttributesTable(rowId, Col_REFERENCE_EXCHANGE).value = .ReferenceExchange
        ExtendedCompletedOrderAttributesTable(rowId, Col_PEGGED_CHANGE_AMOUNT).value = Util.DblMaxStr(.PeggedChangeAmount)
        ExtendedCompletedOrderAttributesTable(rowId, Col_REFERENCE_CHANGE_AMOUNT).value = Util.DblMaxStr(.ReferenceChangeAmount)
        ExtendedCompletedOrderAttributesTable(rowId, Col_IS_PEGGED_CHANGE_AMOUNT_DECREASE).value = .IsPeggedChangeAmountDecrease
        ExtendedCompletedOrderAttributesTable(rowId, Col_LIMIT_PRICE_OFFSET).value = Util.DblMaxStr(.lmtPriceOffset)
        ExtendedCompletedOrderAttributesTable(rowId, Col_CONDITIONS).value = Api.Tws.ConditionsToString(.Conditions)
        ExtendedCompletedOrderAttributesTable(rowId, Col_CONDITIONS_IGNORE_RTH).value = .conditionsIgnoreRth
        ExtendedCompletedOrderAttributesTable(rowId, Col_CONDITIONS_CANCEL_ORDER).value = .conditionsCancelOrder
        ExtendedCompletedOrderAttributesTable(rowId, Col_MODELCODE).value = .modelCode
        ExtendedCompletedOrderAttributesTable(rowId, Col_IS_OMS_CONTAINER).value = .isOmsContainer
        ExtendedCompletedOrderAttributesTable(rowId, Col_AUTO_CANCEL_DATE).value = .autoCancelDate
        ExtendedCompletedOrderAttributesTable(rowId, Col_REF_FUTURES_CONID).value = Util.IntMaxStr(.refFuturesConId)
        ExtendedCompletedOrderAttributesTable(rowId, Col_AUTO_CANCEL_PARENT).value = .autoCancelParent
        ExtendedCompletedOrderAttributesTable(rowId, Col_SHAREHOLDER).value = .shareholder
        ExtendedCompletedOrderAttributesTable(rowId, Col_IMBALANCEE_ONLY).value = .imbalanceOnly
        ExtendedCompletedOrderAttributesTable(rowId, Col_ROUTE_MARKETABLE_TO_BBO).value = .routeMarketableToBbo
    End With

    Dim tempStr As String
    Dim i As Integer
    If Not order.SmartComboRoutingParams Is Nothing Then
        For i = 0 To order.SmartComboRoutingParams.Count - 1 Step 1
            tempStr = tempStr & order.SmartComboRoutingParams(i).tag & STR_EQUALSSIGN
            tempStr = tempStr & order.SmartComboRoutingParams(i).value & STR_SEMICOLON
        Next i
        ExtendedCompletedOrderAttributesTable(rowId, Col_SMART_COMBO_ROUTING_PARAMS).value = tempStr
    End If

    tempStr = ""
    If Not order.algoParams Is Nothing Then
        For i = 0 To order.algoParams.Count - 1 Step 1
            tempStr = tempStr & order.algoParams(i).tag & STR_EQUALSSIGN
            tempStr = tempStr & order.algoParams(i).value & STR_SEMICOLON
        Next i
        ExtendedCompletedOrderAttributesTable(rowId, Col_ALGOPARAMS).value = tempStr
    End If
        
    tempStr = ""
    If Not order.orderComboLegs Is Nothing Then
        For i = 0 To order.orderComboLegs.Count - 1 Step 1
            tempStr = tempStr & order.orderComboLegs(i).price & STR_SEMICOLON
        Next i
        ExtendedCompletedOrderAttributesTable(rowId, Col_ORDER_COMBO_LEGS).value = tempStr
    End If

End Sub

Private Sub Clear()
    contractTable.ClearContents
    completedOrderDescriptionTable.ClearContents
    completedOrderStatusTable.ClearContents
    ExtendedCompletedOrderAttributesTable.ClearContents
End Sub

Public Sub Initialise()
    Set contractTable = Range("$A$7:$M$100")
    Set completedOrderDescriptionTable = Range("$N$7:$T$100")
    Set completedOrderStatusTable = Range("$U$7:$Y$100")
    Set ExtendedCompletedOrderAttributesTable = Range("$Z$7:$DE$100")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub



