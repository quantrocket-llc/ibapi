VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} TickerForm 
   Caption         =   "Ticker"
   ClientHeight    =   7035
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
Private Sub Ok_Click()
ActiveCell.Formula = "symbol.Text"


ActiveCell.offset(0, 0).Formula = symbol.Text
ActiveCell.offset(0, 1).Formula = secType.Text
ActiveCell.offset(0, 8).Formula = primaryexchange.Text
ActiveCell.offset(0, 9).Formula = curr.Text
If secType.Text = util.OPT Or secType.Text = util.FUT Then
    ActiveCell.offset(0, 2).Formula = expiry.Text
    ActiveCell.offset(0, 5).Formula = multiplier.Text
    ActiveCell.offset(0, 6).Formula = tradingClass.Text
End If
If secType.Text = util.OPT Then
    ActiveCell.offset(0, 3).Formula = strike.Text
    ActiveCell.offset(0, 4).Formula = right.Text
End If
ActiveCell.offset(0, 7).Formula = exchange.Text
TickerForm.Hide


End Sub

Private Sub cancel_Click()
TickerForm.Hide

End Sub



Private Sub right_Change()

End Sub

Private Sub UserForm_Initialize()

secType.AddItem util.STK
secType.AddItem util.OPT
secType.AddItem util.FUT

right.AddItem util.CPUT
right.AddItem util.CCALL

End Sub

