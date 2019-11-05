VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SecDefOptParams"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum SecDefOptParamsColumns
    Col_MSG_ID = 1
    Col_EXCHANGE
    Col_UNDERLYING_CON_ID
    Col_TRADING_CLASS
    Col_MULTIPLIER
    Col_EXPIRATIONS
    Col_STRIKES = 10
End Enum

Private Enum SecDefOptParamsReqColumns
    Col_UNDERLYING_SYMBOL = 1
    Col_FUT_FOP_EXCHANGE
    Col_UNDERLYING_SEC_TYPE
    Col_UNDERLYING_CON_ID
End Enum

Const CELL_SUBSCRIPTION_STATUS = "C4"

Private SecDefOptParamsTable As Range
Private SecDefOptParamsReqTable As Range


'=================
' methods
'=================
' clear soft dollar tiers table
Private Sub ClearSecDefOptParams_Click()
    SecDefOptParamsTable.ClearContents
    
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_EMPTY
End Sub



' request soft dollar tiers subscription
Private Sub RequestSecDefOptParams_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Long
    
    id = Util.IncrementSheetRowId(ActiveSheet)
    
    Api.Tws.reqSecDefOptParams id, SecDefOptParamsReqTable(1, Col_UNDERLYING_SYMBOL), _
    SecDefOptParamsReqTable(1, Col_FUT_FOP_EXCHANGE), _
    SecDefOptParamsReqTable(1, Col_UNDERLYING_SEC_TYPE), _
    SecDefOptParamsReqTable(1, SecDefOptParamsReqColumns.Col_UNDERLYING_CON_ID)
    
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_SUBSCRIBED
End Sub

' update soft dollar tiers table
Sub UpdateSecDefOptParams(msgId As Long, _
                          exchange As String, _
                          undrlyingConId As Long, _
                          tradingClass As String, _
                          multiplier As String, _
                          expirations As String, _
                          strikes As String)
    Dim rowId As Long
    
    For rowId = 1 To SecDefOptParamsTable.Rows.Count
        If SecDefOptParamsTable(rowId, 1) = STR_EMPTY Then
            Exit For
        End If
    Next

    SecDefOptParamsTable(rowId, Col_MSG_ID).value = msgId
    SecDefOptParamsTable(rowId, Col_EXCHANGE).value = exchange
    SecDefOptParamsTable(rowId, SecDefOptParamsColumns.Col_UNDERLYING_CON_ID).value = undrlyingConId
    SecDefOptParamsTable(rowId, Col_TRADING_CLASS).value = tradingClass
    SecDefOptParamsTable(rowId, Col_MULTIPLIER).value = multiplier
    SecDefOptParamsTable(rowId, Col_EXPIRATIONS).value = expirations
    SecDefOptParamsTable(rowId, Col_STRIKES).value = strikes
End Sub

Public Sub Initialise()
    Set SecDefOptParamsTable = SecDefOptParams.Range("$A$8:$J$40")
    Set SecDefOptParamsReqTable = SecDefOptParams.Range("$F$3:$I$3")
    Util.InitialiseSheetRowId ActiveSheet, ID_SEC_DEF_OPT_PARAMS
End Sub


Private Sub Worksheet_Activate()
    Main.Initialise
End Sub


