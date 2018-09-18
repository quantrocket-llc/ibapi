VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "AcctUpdMulti"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Const CELL_ACCOUNT = "A6"
Const CELL_MODEL_CODE = "B6"
Const CELL_SUBSCRIPTION_STATUS = "A9"

Private Enum AccountTableColumns
    Col_ACCOUNT_KEY = 1
    Col_ACCOUNT_ID
    Col_MODELCODE
    Col_ACCOUNT_VALUE
    Col_ACCOUNT_CURRENCY
End Enum

Private accountUpdatesTable As Range

'=================
' private methods
'=================
' request account updates multi
Private Sub RequestAccountUpdatesMulti_Click()
    If Not CheckConnected Then Exit Sub
    
    ' clear account values
    accountUpdatesTable.ClearContents
    
    ' update subscription status
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_SUBSCRIBED

    Api.Tws.reqAccountUpdatesMulti ID_ACCOUNT_UPDATES_MULTI, Range(CELL_ACCOUNT).value, Range(CELL_MODEL_CODE).value, cbLedgerAndNLV.value
End Sub

' cancel account updates multi
Private Sub CancelAccountUpdatesMulti_Click()
    If Not CheckConnected Then Exit Sub
    
    ' update subscription status
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_EMPTY
    
    Api.Tws.CancelAccountUpdatesMulti ID_ACCOUNT_UPDATES_MULTI
End Sub

' clear account updates multi table
Private Sub ClearAccountUpdatesMulti_Click()
    If IsConnected Then CancelAccountUpdatesMulti_Click
    accountUpdatesTable.ClearContents
End Sub

' find row in account table by key and currency
Private Function FindRowByKeyAndCurency(key As String, curency As String)
    Dim i As Long
    For i = 1 To accountUpdatesTable.Rows.Count
        If (accountUpdatesTable(i, Col_ACCOUNT_KEY).value Like key And _
                accountUpdatesTable(i, Col_ACCOUNT_CURRENCY).value Like curency) Or _
            accountUpdatesTable(i, Col_ACCOUNT_KEY).value = STR_EMPTY _
        Then
            Exit For
        End If
    Next
    FindRowByKeyAndCurency = i
End Function

'=================
' public methods
'=================
' account update multi
Public Sub AccountUpdateMulti(ByVal requestId As Long, ByVal Account As String, ByVal modelCode As String, ByVal key As String, ByVal value As String, ByVal curency As String)
    Dim rowId As Long
    rowId = FindRowByKeyAndCurency(key, curency)
    
    accountUpdatesTable(rowId, Col_ACCOUNT_KEY).value = key
    accountUpdatesTable(rowId, Col_ACCOUNT_ID).value = Account
    accountUpdatesTable(rowId, Col_MODELCODE).value = modelCode
    accountUpdatesTable(rowId, Col_ACCOUNT_VALUE).value = value
    accountUpdatesTable(rowId, Col_ACCOUNT_CURRENCY).value = curency
    
End Sub

Public Sub Initialise()
    Set accountUpdatesTable = Range("$A$13:$E$300")
End Sub

Private Sub Worksheet_Activate()
Main.Initialise
End Sub

