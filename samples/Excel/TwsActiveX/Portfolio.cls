VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Portfolio"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum PortfolioColumns
    Col_PORTF_POS = 1
    Col_PORTF_MKTPRICE
    Col_PORTF_MKTVAL
    Col_PORTF_AVGCOST
    Col_PORTF_UNRPNL
    Col_PORTF_REALPNL
    Col_PORTF_ACCT
    Col_PORTF_STATUS
End Enum

Private Enum ExercseOptionsColumns
    Col_OPTIONS_ACTION = 1
    Col_OPTIONS_QTY
    Col_OPTIONS_OVERRIDE
End Enum

Private contractTable As Range
Private portfolioTable As Range
Private exerciseOptionsTable As Range

'=================
' methods
'=================

' exersice options
Private Sub ExerciseOptions_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Long
    id = ActiveCell.row - contractTable.Rows(1).row + 1
    If UCase(contractTable(id, Col_SECTYPE).value) = Util.SECTYPE_OPT Or _
        UCase(contractTable(id, Col_SECTYPE).value) = Util.SECTYPE_FOP Then
        ' sectype is OPT or FOP
        
        ' create contract structure
        Dim lContractInfo As TWSLib.IContract
        Set lContractInfo = Api.Tws.createContract()
        
        With lContractInfo
            .Symbol = UCase(contractTable(id, Col_SYMBOL).value)
            .SecType = UCase(contractTable(id, Col_SECTYPE).value)
            .lastTradeDateOrContractMonth = contractTable(id, Col_LASTTRADEDATE).value
            .Strike = contractTable(id, Col_STRIKE).value
            .Right = UCase(contractTable(id, Col_RIGHT).value)
            .exchange = UCase(contractTable(id, Col_EXCH).value)
            .primaryExchange = UCase(contractTable(id, Col_PRIMEXCH).value)
            .currency = UCase(contractTable(id, Col_CURRENCY).value)
            .multiplier = contractTable(id, Col_MULTIPLIER).value
            .localSymbol = contractTable(id, Col_LOCALSYMBOL).value
            .conId = contractTable(id, Col_CONID).value
            
        End With
        
        Dim exerciseAction As Long
        exerciseAction = exerciseOptionsTable(id, Col_OPTIONS_ACTION).value
        
        Dim exerciseQuantity As Long
        exerciseQuantity = exerciseOptionsTable(id, Col_OPTIONS_QTY).value
        
        Dim override As Long
        override = exerciseOptionsTable(id, Col_OPTIONS_OVERRIDE).value
        
        Dim Account As String
        Account = exerciseOptionsTable(id, Col_PORTF_ACCT).value

        ' exercise options
        Api.Tws.exerciseOptionsEx id + ID_PORTFOLIO, lContractInfo, exerciseAction, exerciseQuantity, Account, override
    
    End If

    ActiveCell.Offset(1, 0).Activate
End Sub

' clear portfolio data table
Public Sub ClearPortfolioData_Click()
    contractTable.ClearContents
    portfolioTable.ClearContents
End Sub
    
' find row in portfolio table by contract id
Private Function FindRowByConId(conId As Long)
    Dim i As Long
    For i = 1 To contractTable.Rows.Count
        If contractTable(i, Col_CONID).value = conId Or contractTable(i, Col_CONID).value = "" Then Exit For
    Next
    FindRowByConId = i
End Function

'=================
' public methods
'=================

' update portfolio
Public Sub UpdatePortfolio(contract As TWSLib.IContract, position As Double, marketPrice As Double, marketValue As Double, averageCost As Double, unrealizedPNL As Double, realizedPNL As Double, accountName As String)
    Dim id As Long
    id = FindRowByConId(contract.conId)
    
    With contract
        contractTable(id, Col_CONID).value = .conId
        contractTable(id, Col_SYMBOL).value = .Symbol
        contractTable(id, Col_SECTYPE).value = .SecType
        contractTable(id, Col_LASTTRADEDATE).value = .lastTradeDateOrContractMonth
        If .Strike > 0 Then
            contractTable(id, Col_STRIKE).value = .Strike
        End If
        If .Right <> STR_ZERO Then
            contractTable(id, Col_RIGHT).value = .Right
        End If
        contractTable(id, Col_CURRENCY).value = .currency
        contractTable(id, Col_LOCALSYMBOL).value = .localSymbol
        contractTable(id, Col_EXCH).value = .exchange
        contractTable(id, Col_PRIMEXCH).value = .primaryExchange
        contractTable(id, Col_MULTIPLIER).value = .multiplier
    End With
     
    portfolioTable(id, Col_PORTF_POS).value = position
    portfolioTable(id, Col_PORTF_MKTPRICE).value = marketPrice
    portfolioTable(id, Col_PORTF_MKTVAL).value = marketValue
    portfolioTable(id, Col_PORTF_AVGCOST).value = averageCost
    portfolioTable(id, Col_PORTF_UNRPNL).value = unrealizedPNL
    portfolioTable(id, Col_PORTF_REALPNL).value = realizedPNL
    portfolioTable(id, Col_PORTF_ACCT).value = accountName
    
End Sub

Public Sub ProcessError(ByVal id As Long, ByVal errorCode As Long, ByVal errorMsg As String)
    
    portfolioTable(id - ID_PORTFOLIO, Col_PORTF_STATUS).value = STR_ERROR + STR_COLON + Str(errorCode) + STR_SPACE + errorMsg
        
End Sub

Public Sub Initialise()
    Set contractTable = Me.Range("$A$6:$K$206")
    Set portfolioTable = Me.Range("$L$6:$S$206")
    Set exerciseOptionsTable = Me.Range("$T$6:$V$206")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub


