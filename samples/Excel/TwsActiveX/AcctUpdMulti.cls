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
Const CELL_CONID = "D6"
Const CELL_SUBSCRIPTION_STATUS = "A9"
Const CELL_PNL_STATUS = "G9"

Private Enum AccountTableColumns
    Col_ACCOUNT_KEY = 1
    Col_ACCOUNT_ID
    Col_MODELCODE
    Col_ACCOUNT_VALUE
    Col_ACCOUNT_CURRENCY
End Enum

Private Enum PnlTableColumns
    Col_DAILY_PNL = 1
    Col_UNREALIZED_PNL
    Col_REALIZED_PNL
    Col_POS
    Col_VALUE
End Enum

Private accountUpdatesTable As Range
Private pnlTable As Range

Private Sub CancelPnL_Click()
    If Not CheckConnected Then Exit Sub
    
    Api.Tws.CancelPnL ID_PNL
    Range(CELL_PNL_STATUS).value = STR_EMPTY
End Sub

Private Sub CancelPnLSingle_Click()
    If Not CheckConnected Then Exit Sub
    
    Api.Tws.CancelPnLSingle ID_PNL_SINGLE
    Range(CELL_PNL_STATUS).value = STR_EMPTY
End Sub

Private Sub ClearPnL_Click()
    If CheckConnected Then
        CancelPnL_Click
        CancelPnLSingle_Click
    End If
    
    pnlTable.ClearContents
End Sub

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

Public Sub UpdatePnL(ByVal reqId As Long, ByVal dailyPnL As Double, ByVal unrealizedPNL As Double, ByVal realizedPNL As Double)
    Dim rowId As Long
    
    rowId = Util.GetSheetRowId(ActiveSheet)
    
    Util.IncrementSheetRowId ActiveSheet
    
    pnlTable(rowId, Col_DAILY_PNL).value = dailyPnL
    pnlTable(rowId, Col_UNREALIZED_PNL).value = unrealizedPNL
    pnlTable(rowId, Col_REALIZED_PNL).value = realizedPNL
    
End Sub

Public Sub UpdatePnLSingle(ByVal reqId As Long, ByVal pos As Long, ByVal dailyPnL As Double, ByVal unrealizedPNL As Double, ByVal realizedPNL As Double, ByVal value As Double)
    Dim rowId As Long
    
    rowId = Util.GetSheetRowId(ActiveSheet)
    
    Util.IncrementSheetRowId ActiveSheet
    
    pnlTable(rowId, Col_DAILY_PNL).value = dailyPnL
    pnlTable(rowId, Col_UNREALIZED_PNL).value = unrealizedPNL
    pnlTable(rowId, Col_REALIZED_PNL).value = realizedPNL
    pnlTable(rowId, Col_POS).value = pos
    pnlTable(rowId, Col_VALUE).value = value
End Sub

Public Sub Initialise()
    Set accountUpdatesTable = Range("$A$13:$E$300")
    Set pnlTable = Range("$G$13:$K$300")
End Sub

Private Sub RequestPnL_Click()
    If Not CheckConnected Then Exit Sub
    
    ClearPnL_Click
    
    Util.InitialiseSheetRowId ActiveSheet, 13
    
    Api.Tws.reqPnL ID_PNL, Range(CELL_ACCOUNT).value, Range(CELL_MODEL_CODE).value
    
    Range(CELL_PNL_STATUS).value = STR_SUBSCRIBED
End Sub

Private Sub RequestPnlSingle_Click()
    If Not CheckConnected Then Exit Sub
    
    ClearPnL_Click
    
    Util.InitialiseSheetRowId ActiveSheet, 13
    
    Api.Tws.reqPnLSingle ID_PNL_SINGLE, Range(CELL_ACCOUNT).value, Range(CELL_MODEL_CODE).value, Range(CELL_CONID).value
    
    Range(CELL_PNL_STATUS).value = STR_SUBSCRIBED
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub

