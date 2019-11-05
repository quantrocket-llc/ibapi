VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Fundamentals"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum RequestTableColumns
    Col_REPORTTYPE = 1
    Col_GENERICTICKTYPE
End Enum

Private Enum FundamentalsDataPageTableColumns
    Col_FUND_STATUS = 1
    Col_FUND_SHEETNAME
    Col_FUND_ACTIVATESHEET
End Enum

Private Enum FundamentalsRatiosPageTableColumns
    Col_FUNDRAT_STATUS = 1
    Col_FUNDRAT_SHEETNAME
    Col_FUNDRAT_ACTIVATESHEET
End Enum

' new sheet
Private Enum FundamentalsColumns
    Col_FUNDAMENTALS_PARAMETER = 1
    Col_FUNDAMENTALS_VALUE = 4
End Enum

' other constants
Const STR_REPORTTYPE_FINSTAT = "finstat"
Const STR_REPORTTYPE_ESTIMATES = "estimates"
Const STR_REPORTTYPE_SNAPSHOT = "snapshot"
Const STR_INCORRECT_REPORT_TYPE = "Error: Incorrect  Report Type"

Const ROW_LAST = 65536

Private contractTable As Range
Private requestTable As Range
Private fundamentalsDataTable As Range
Private fundamentalsRatiosTable As Range

'=================
' methods
'=================
'
' cancel fundamental ratios
Private Sub CancelFundamentalRatios_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer
    id = ActiveCell.row - contractTable.Rows(1).row + 1

    Api.Tws.cancelMktData id + ID_FUNDAMENTALRATIOS

    ' update status column
    fundamentalsRatiosTable(id, Col_FUNDRAT_STATUS).value = STR_EMPTY
    ActiveCell.Offset(1, 0).Activate
End Sub

' cancel market data subscription
Private Sub CancelFundamentals_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer
    id = ActiveCell.row - contractTable.Rows(1).row + 1
    Api.Tws.cancelFundamentalData id + ID_FUNDAMENTALS

    ' update status column
    fundamentalsDataTable(id, Col_FUND_STATUS).value = STR_EMPTY
    ActiveCell.Offset(1, 0).Activate
End Sub

' request fundamental ratios
Private Sub FundamentalRatios_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer
    id = ActiveCell.row - contractTable.Rows(1).row + 1

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
    End With

    ' combo legs
    If contractTable(id, Col_SECTYPE).value = SECTYPE_BAG And _
    contractTable(id, Col_COMBOLEGS) <> STR_EMPTY Then
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
    genericTickList = requestTable(id, Col_GENERICTICKTYPE).value

    ' market data options
    Dim mktDataOptions As TWSLib.ITagValueList
    Set mktDataOptions = Api.Tws.createTagValueList()

    Api.Tws.reqMktDataEx id + ID_FUNDAMENTALRATIOS, lContractInfo, genericTickList, False, False, mktDataOptions

    ' update subscription column status
    fundamentalsRatiosTable(id, Col_FUNDRAT_STATUS).value = STR_PROCESSING

    Dim sheetName As String
    sheetName = fundamentalsRatiosTable(id, Col_FUNDRAT_SHEETNAME).value
    If (sheetName = STR_EMPTY And fundamentalsRatiosTable(id, Col_FUNDRAT_ACTIVATESHEET).value) Or _
        IsNumeric(sheetName) Then
        fundamentalsRatiosTable(id, Col_FUNDRAT_SHEETNAME).value = GenerateSheetName(lContractInfo, "FundRat")
    End If
    
    ActiveCell.Offset(1, 0).Activate
End Sub

' request fundamentals
Private Sub RequestFundamentals_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer
    id = ActiveCell.row - contractTable.Rows(1).row + 1

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
    End With

    ' combo legs
    If contractTable(id, Col_SECTYPE).value = SECTYPE_BAG And _
    contractTable(id, Col_COMBOLEGS) <> STR_EMPTY Then
        ' create combo leg list
        Set lContractInfo.ComboLegs = Api.Tws.createComboLegList()

        ' parse combo legs string
        Util.ParseComboLegsIntoStruct contractTable(id, Col_COMBOLEGS).value, lContractInfo.ComboLegs, lContractInfo.ComboLegs
    End If

    ' under comp
    If contractTable(id, Col_SECTYPE).value = SECTYPE_BAG And _
    contractTable(id, Col_DELTANEUTRALCONTRACT) <> STR_EMPTY Then
        ' create under comp
        Set lContractInfo.deltaNeutralContract = Api.Tws.createDeltaNeutralContract()

        ' parse under comp info
        Util.ParseDeltaNeutralContractIntoStruct contractTable(id, Col_DELTANEUTRALCONTRACT).value, lContractInfo.deltaNeutralContract
    End If

    If requestTable(id, Col_REPORTTYPE).value = STR_REPORTTYPE_FINSTAT Or _
        requestTable(id, Col_REPORTTYPE).value = STR_REPORTTYPE_ESTIMATES Or _
        requestTable(id, Col_REPORTTYPE).value = STR_REPORTTYPE_SNAPSHOT Then

        Api.Tws.reqFundamentalData id + ID_FUNDAMENTALS, lContractInfo, requestTable(id, Col_REPORTTYPE).value

        ' update subscription column status
        fundamentalsDataTable(id, Col_FUND_STATUS).value = STR_PROCESSING

        Dim sheetName As String
        sheetName = fundamentalsDataTable(id, Col_FUND_SHEETNAME).value
        If (sheetName = STR_EMPTY And fundamentalsDataTable(id, Col_FUND_ACTIVATESHEET).value) Or _
            IsNumeric(sheetName) Then
            fundamentalsDataTable(id, Col_FUND_SHEETNAME).value = GenerateSheetName(lContractInfo, "Fund")
        End If
        
        ActiveCell.Offset(1, 0).Activate

    Else
        MsgBox STR_INCORRECT_REPORT_TYPE
    End If
End Sub

' update fundamentals data
Public Sub UpdateFundamentalsData(ByVal reqId As Long, ByVal data As String)
    
    reqId = reqId - ID_FUNDAMENTALS
    
    Dim sheetName As String
    sheetName = fundamentalsDataTable(reqId, Col_FUND_SHEETNAME).value

    If sheetName = STR_EMPTY Or IsNumeric(sheetName) Then Exit Sub
    
    Dim sheet As Worksheet
    Dim needsInitialising As Boolean
    Set sheet = FindOrAddSheet(sheetName, needsInitialising)
    If needsInitialising Then InitialiseSheet sheet
    
    ' parse xml string
    Dim xmlDoc As New DOMDocument60
    xmlDoc.LoadXML data
    RecurseChildNodes xmlDoc.childNodes, sheet, 0
    Set xmlDoc = Nothing
    
    ClearSheetRowId sheet

    ' update subscription column status
    fundamentalsDataTable(reqId, Col_FUND_STATUS).value = STR_SUBSCRIBED
    
    ' activate new sheet
    If fundamentalsDataTable(reqId, Col_FUND_ACTIVATESHEET).value Then
        sheet.Activate
    End If

End Sub

' update fundamental ratios
Public Sub UpdateFundamentalRatios(ByVal id As Long, ByVal tickType As Long, ByVal value As String)

    id = id - ID_FUNDAMENTALRATIOS

    Dim rowId As Long: rowId = 4   ' The first row of data
    
    Dim sheetName As String
    sheetName = fundamentalsRatiosTable(id, Col_FUNDRAT_SHEETNAME).value
    
    If sheetName = STR_EMPTY Or IsNumeric(sheetName) Then Exit Sub
    
    Dim sheet As Worksheet
    Dim needsInitialising As Boolean
    Set sheet = FindOrAddSheet(sheetName, needsInitialising)
    If needsInitialising Then InitialiseSheet sheet
    
    ' parse string
    Dim tmpStr As String
    tmpStr = value
    
    Do While Len(tmpStr) > 0
        With sheet.Rows(rowId)
            .Cells(Col_FUNDAMENTALS_PARAMETER).value = Left(tmpStr, InStr(tmpStr, STR_EQUALSSIGN) - 1)
            tmpStr = Right(tmpStr, Len(tmpStr) - InStr(tmpStr, STR_EQUALSSIGN))
    
            If (InStr(tmpStr, STR_SEMICOLON) > 0) Then
                .Cells(Col_FUNDAMENTALS_VALUE).value = Left(tmpStr, InStr(tmpStr, STR_SEMICOLON) - 1)
                tmpStr = Right(tmpStr, Len(tmpStr) - InStr(tmpStr, STR_SEMICOLON))
            Else
                .Cells(Col_FUNDAMENTALS_VALUE).value = tmpStr
                tmpStr = STR_EMPTY
            End If
        End With
        rowId = rowId + 1
    Loop
    
    ' update subscription column status
    fundamentalsRatiosTable(id, Col_FUNDRAT_STATUS).value = STR_SUBSCRIBED

    ' activate new sheet
    If fundamentalsRatiosTable(id, Col_FUNDRAT_ACTIVATESHEET).value Then
        sheet.Activate
    End If
End Sub


Public Sub RecurseChildNodes(nodes As IXMLDOMNodeList, sheet As Worksheet, ByVal recurseCount As Long)
    recurseCount = recurseCount + 1

    Dim i As Long
    For i = 0 To nodes.Length - 1
        If Not processNode(sheet, nodes.Item(i), recurseCount) Then Exit Sub
    Next
End Sub

Private Function processAttribute(sheet As Worksheet, att As IXMLDOMAttribute, recurseCount As Long) As Boolean
    Dim rowId As Long: rowId = IncrementSheetRowId(sheet)

    ' check if end of sheet
    If rowId > ROW_LAST Then Exit Function

    sheet.Cells(rowId, Col_FUNDAMENTALS_PARAMETER).value = String((recurseCount - 1) * 4, " ") & att.BaseName
    sheet.Cells(rowId, Col_FUNDAMENTALS_VALUE).value = att.text
    
    processAttribute = True
End Function

Private Function processAttributes(sheet As Worksheet, node As IXMLDOMNode, recurseCount As Long) As Boolean
    Dim i As Long
    For i = 0 To node.Attributes.Length - 1
        If Not processAttribute(sheet, node.Attributes.Item(i), recurseCount) Then Exit Function
    Next
    processAttributes = True
End Function

Private Function processNode(sheet As Worksheet, node As IXMLDOMNode, recurseCount As Long) As Boolean
    Dim childNodes As IXMLDOMNodeList: Set childNodes = node.childNodes
    If childNodes.Length > 0 Then
        If Not processNodeName(sheet, node, recurseCount) Then Exit Function
        If Not processAttributes(sheet, node, recurseCount) Then Exit Function
        If Not processNodeValue(sheet, node, recurseCount) Then Exit Function
        
        ' call recursively to parse child nodes
        RecurseChildNodes childNodes, sheet, recurseCount

    End If
    processNode = True
End Function

Private Function processNodeName(sheet As Worksheet, node As IXMLDOMNode, recurseCount As Long) As Boolean
    Dim rowId As Long: rowId = GetSheetRowId(sheet)
    
    ' check if end of sheet
    If rowId > ROW_LAST Then Exit Function

    ' node
    sheet.Cells(rowId, Col_FUNDAMENTALS_PARAMETER).value = String((recurseCount - 1) * 2, " ") & node.nodeName
    processNodeName = True
End Function

Private Function processNodeValue(sheet As Worksheet, node As IXMLDOMNode, recurseCount As Long) As Boolean
    Dim rowId As Long: rowId = IncrementSheetRowId(sheet)

    ' check if end of sheet
    If rowId > ROW_LAST Then Exit Function

    If node.childNodes.Item(0).BaseName = STR_EMPTY Then
        sheet.Cells(rowId, Col_FUNDAMENTALS_PARAMETER).value = String((recurseCount - 1) * 4, " ") & "Value"
        sheet.Cells(rowId, Col_FUNDAMENTALS_VALUE).value = node.text

        rowId = IncrementSheetRowId(sheet)
    End If
    processNodeValue = True
End Function

Public Sub ProcessError(ByVal id As Long, ByVal errorCode As Long, ByVal errorMsg As String)

    ' handle errors
    If errorCode = ERROR_DUPLICATE_TICKER_ID Then
        errorMsg = STR_SUBSCRIBED
        MsgBox STR_ALREADY_SUBSCRIBED
    End If
    
    Select Case id
        Case ID_FUNDAMENTALS To ID_FUNDAMENTALS + ID_GAP - 1
            fundamentalsDataTable(id - ID_FUNDAMENTALS, Col_FUND_STATUS).value = errorMsg
        Case ID_FUNDAMENTALRATIOS To ID_FUNDAMENTALRATIOS + ID_GAP - 1
            fundamentalsRatiosTable(id - ID_FUNDAMENTALRATIOS, Col_FUNDRAT_STATUS).value = errorMsg
    End Select
End Sub

Private Sub InitialiseSheet(sheet As Worksheet)
    sheet.Cells.ClearContents
    
    InitialiseSheetRowId sheet, 4

    sheet.Cells(2, 1).value = "Fundamental Data"
    sheet.Cells(3, 1).value = "Parameter"
    sheet.Cells(3, 4).value = "Value"
End Sub

Private Function GenerateSheetName(contractInfo As TWSLib.IContract, ByVal prefix As String)
    Dim s As String
    s = "Fund" & GenerateContractIdentifier(contractInfo)
    GenerateSheetName = Left(s, 31)
End Function

Public Sub Initialise()
    Set contractTable = Range("$A$7:$M$36")
    Set requestTable = Range("$N$7:$O$36")
    Set fundamentalsDataTable = Range("$P$7:$R$36")
    Set fundamentalsRatiosTable = Range("$S$7:$U$36")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub


