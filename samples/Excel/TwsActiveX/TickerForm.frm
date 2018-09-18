VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} TickerForm 
   Caption         =   "Create Ticker"
   ClientHeight    =   5415
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4710
   OleObjectBlob   =   "TickerForm.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "TickerForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mContractTable As Range
Private mIndex As Long

'=================
' methods
'=================
Private Sub buttonCancel_Click()
    TickerForm.Hide
End Sub

Private Sub buttonOK_Click()
    mContractTable(mIndex, Col_SYMBOL).value = tickerSymbol.text
    mContractTable(mIndex, Col_SECTYPE).value = tickerType.text
    
    If tickerType.text = Util.SECTYPE_OPT Or tickerType.text = Util.SECTYPE_FOP Or tickerType.text = Util.SECTYPE_FUT Then
        mContractTable(mIndex, Col_STRIKE).value = tickerStrike.text
        mContractTable(mIndex, Col_RIGHT).value = tickerRight.text
        mContractTable(mIndex, Col_LASTTRADEDATE).value = tickerExpiry.text
        mContractTable(mIndex, Col_MULTIPLIER).value = tickerMultiplier.text
    End If
    
    mContractTable(mIndex, Col_EXCH).value = tickerExchange.text
    mContractTable(mIndex, Col_PRIMEXCH).value = tickerPrimaryExchange.text
    mContractTable(mIndex, Col_CURRENCY).value = tickerCurrency.text
    
    TickerForm.Hide

End Sub

Private Sub Init()
    tickerSymbol.text = STR_EMPTY
    tickerType.text = STR_EMPTY
    tickerStrike.text = STR_EMPTY
    tickerRight.text = STR_EMPTY
    tickerExpiry.text = STR_EMPTY
    tickerMultiplier.text = STR_EMPTY
    tickerExchange.text = STR_EMPTY
    tickerPrimaryExchange.text = STR_EMPTY
    tickerCurrency.text = STR_EMPTY
    
    tickerSymbol.text = mContractTable(mIndex, Col_SYMBOL).value
    tickerType.text = mContractTable(mIndex, Col_SECTYPE).value
    
    If mContractTable(mIndex, Col_SECTYPE).value = Util.SECTYPE_OPT Or _
       mContractTable(mIndex, Col_SECTYPE).value = Util.SECTYPE_FOP Or _
       mContractTable(mIndex, Col_SECTYPE).value = Util.SECTYPE_FUT Then
        tickerStrike.text = mContractTable(mIndex, Col_STRIKE).value
        tickerRight.text = mContractTable(mIndex, Col_RIGHT).value
        tickerExpiry.text = mContractTable(mIndex, Col_LASTTRADEDATE).value
        tickerMultiplier.text = mContractTable(mIndex, Col_MULTIPLIER).value
    End If
    
    tickerExchange.text = mContractTable(mIndex, Col_EXCH).value
    tickerPrimaryExchange.text = mContractTable(mIndex, Col_PRIMEXCH).value
    tickerCurrency.text = mContractTable(mIndex, Col_CURRENCY).value

End Sub

Private Sub UserForm_Initialize()
    tickerType.AddItem SECTYPE_STK
    tickerType.AddItem SECTYPE_OPT
    tickerType.AddItem SECTYPE_FUT
    tickerType.AddItem SECTYPE_FOP
    tickerType.AddItem SECTYPE_IND
    tickerType.AddItem SECTYPE_BAG
    tickerType.AddItem SECTYPE_CASH
    
    tickerRight.AddItem RIGHT_CALL
    tickerRight.AddItem RIGHT_PUT
End Sub

Public Sub ShowForm(contractTable As Range)
Set mContractTable = contractTable
mIndex = ActiveCell.row - mContractTable.Rows(1).row + 1
Init
TickerForm.Show
End Sub

