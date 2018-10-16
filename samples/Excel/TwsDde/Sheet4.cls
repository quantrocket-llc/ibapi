VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet4"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim lastAcctValueId As Integer
Dim lastPortfolioId As Integer
Dim lastAccountCode As String

Const serverCell = "acctServer"
Const acctTime = "acctTime"
Const acctCode = "acctCode"
Const topic = util.ACCT_TOPIC ' "acct"
Const faAcctCtrl = "faAcctCtrl"
Const faAcctValue = "faAcctValue"
Const errorRange = "acctErrorPosition"
Const accountValues = "accountValues"
Const portfolioValues = "portfolioValues"

Public Sub reqAcctUpdate()
    Dim server As String, row As String, id As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
   
   ' check if we need to reload the portfolio (i.e. the account changed)
   reloadPortFolio
   
   'Only allow 25 account rows (reuse the last row to request a different account)
   If lastAcctValueId > 24 Then
        lastAcctValueId = 24
   End If
   
   Call checkAndSetAcctTime(lastAcctValueId, server)
   
   id = util.getIDpre(lastAcctValueId)
   row = getNextAcctValueRow()
   
   'req acct value data
   Range("J" & row).value = util.composeControlLink(server, topic, id, "acctv", getAccountCode())
   Range("A" & row).value = util.composeLink(server, topic, id, "key")
   Range("D" & row).value = util.composeLink(server, topic, id, "value")
   Range("G" & row).value = util.composeLink(server, topic, id, "keyCurrency")
   Range("A" & row).Select
End Sub

Public Sub requestPortfolio()
    Dim server As String, row As String, id As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
   
   ' check if we need to reload the portfolio (i.e. the account changed)
   reloadPortFolio
   
   id = getAcctPortfolioId()
   Dim cur As Long
      
   cur = getNextPortfolioRow()
   row = CStr(cur)
   
   Call checkAndSetAcctTime(lastPortfolioId, server)
   'req acct value data
   Range("N" & row).value = util.composeControlLink(server, topic, id, "acctp", getAccountCode())
   Range("A" & row).value = util.composeLink(server, topic, id, "symbol")
   Range("B" & row).value = util.composeLink(server, topic, id, "secType")
   Range("C" & row).value = util.composeLink(server, topic, id, "expiry")
   Range("D" & row).value = util.composeLink(server, topic, id, "strike")
   Range("E" & row).value = util.composeLink(server, topic, id, "right")
   Range("F" & row).value = util.composeLink(server, topic, id, "currency")
   Range("G" & row).value = util.composeLink(server, topic, id, "localSymbol")
   Range("H" & row).value = util.composeLink(server, topic, id, "position")
   Range("I" & row).value = util.composeLink(server, topic, id, "marketPrice")
   Range("J" & row).value = util.composeLink(server, topic, id, "marketValue")
   Range("K" & row).value = util.composeLink(server, topic, id, "avgCost")
   Range("L" & row).value = util.composeLink(server, topic, id, "unrealizedPNL")
   Range("M" & row).value = util.composeLink(server, topic, id, "realizedPNL")
   
   ' select current row
   Range("A" & row).Select
End Sub

Public Sub requestManagedAccts()
    Dim server As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    Range(faAcctCtrl).Formula = util.composeLink(server, util.faAcctTopic, util.GENERIC_IDENTIFIER, "req")
    Range(faAcctValue).Formula = util.composeLink(server, util.faAcctTopic, util.GENERIC_IDENTIFIER, "value")
End Sub

Sub checkAndSetAcctTime(ByVal lastId As Long, ByVal server As String)
    If lastId = 1 Then ' set up account time cell on first one
        Call util.setupAcctTimeLink(server, acctTime)
    End If
End Sub

Function getAccountCode() As String
    getAccountCode = Range(acctCode).value
End Function

Function getNextAcctValueRow() As Long
    getNextAcctValueRow = lastAcctValueId + 7
End Function

Public Function getNextPortfolioRow() As Long
   Dim startLine As Integer, i As Integer
   startLine = 34
   For i = 6 To 200
     ' assume we have this title line there
     If Cells(i, 1) = "Symbol" Then
        startLine = i
        Exit For
     End If
   Next i
         
   getNextPortfolioRow = lastPortfolioId + startLine
End Function

Public Function getAcctPortfolioId() As String
    lastPortfolioId = lastPortfolioId + 1
    getAcctPortfolioId = util.IDENTIFIER_PREFIX & CStr(lastPortfolioId)
End Function

Sub reloadPortFolio()
    If Not lastAccountCode = getAccountCode() Then
        Dim val As String
        Dim r As Integer, c As Integer
        For r = 35 To 500
            ' check if no more portfolio entries
            If IsEmpty(Cells(r, 1)) Or Cells(r, 1).value() = "" Then
                Exit For
            End If
            
            For c = 1 To 14
                Cells(r, c).value = ""
            Next c
        Next r
        
        ' Reset the portfolio row id so the entries are reloaded
        lastPortfolioId = 0
   End If
   lastAccountCode = getAccountCode()
End Sub
Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub

Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call util.clearRange(accountValues, util.tanColorIndex, xlShiftToLeft)
    Call util.clearRange(portfolioValues, util.lightGreenColorIndex, xlShiftUp)
    Range(acctTime).Formula = ""
    Range(faAcctCtrl).Formula = ""
    Range(faAcctValue).Formula = ""
End Sub


