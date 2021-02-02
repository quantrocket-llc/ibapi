VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} TickerForm 
   Caption         =   "Ticker"
   ClientHeight    =   6750
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4890
   OleObjectBlob   =   "TickerForm.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "TickerForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public Sub ShowForm()
    symbol.Text = ActiveCell.offset(0, 0).value
    secType.Text = ActiveCell.offset(0, 1).value
    lastTradeDate.Text = ActiveCell.offset(0, 2).value
    strike.Text = ActiveCell.offset(0, 3).value
    right.Text = ActiveCell.offset(0, 4).value
    multiplier.Text = ActiveCell.offset(0, 5).value
    tradingClass.Text = ActiveCell.offset(0, 6).value
    exchange.Text = ActiveCell.offset(0, 7).value
    primaryexchange.Text = ActiveCell.offset(0, 8).value
    curr.Text = ActiveCell.offset(0, 9).value
    localSymbol.Text = ActiveCell.offset(0, 10).value
    conid.Text = ActiveCell.offset(0, 11).value

    TickerForm.Show
End Sub



Private Sub Ok_Click()
    ActiveCell.offset(0, 0).value = symbol.Text
    ActiveCell.offset(0, 1).value = secType.Text
    ActiveCell.offset(0, 2).value = lastTradeDate.Text
    ActiveCell.offset(0, 3).value = strike.Text
    ActiveCell.offset(0, 4).value = right.Text
    ActiveCell.offset(0, 5).value = multiplier.Text
    ActiveCell.offset(0, 6).value = tradingClass.Text
    ActiveCell.offset(0, 7).value = exchange.Text
    ActiveCell.offset(0, 8).value = primaryexchange.Text
    ActiveCell.offset(0, 9).value = curr.Text
    ActiveCell.offset(0, 10).value = localSymbol.Text
    ActiveCell.offset(0, 11).value = conid.Text

    TickerForm.Hide
End Sub

Private Sub cancel_Click()
    TickerForm.Hide
End Sub


Private Sub UserForm_Initialize()
    secType.AddItem util.STK
    secType.AddItem util.OPT
    secType.AddItem util.FUT
    secType.AddItem util.FOP
    secType.AddItem util.IND
    secType.AddItem util.CASH
    secType.AddItem util.WAR
    secType.AddItem util.IOPT
    secType.AddItem util.BAG
    
    right.AddItem util.CPUT
    right.AddItem util.CCALL

End Sub

