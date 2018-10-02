VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SmartComponents"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum SmartComponentsColumns
    Col_MSG_ID = 1
    Col_BIT_NUMBER
    Col_EXCHANGE
    Col_EXCHANGE_LETTER
End Enum

Const CELL_SUBSCRIPTION_STATUS = "C4"
Const CELL_BBO_EXCHANGE = "F3"

Private SmartComponentsTable As Range

'=================
' methods
'=================
' clear soft dollar tiers table
Private Sub ClearSmartComponents_Click()
    SmartComponentsTable.ClearContents
    
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_EMPTY
End Sub



' request soft dollar tiers subscription
Private Sub RequestSmartComponents_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Long
    
    id = Util.IncrementSheetRowId(ActiveSheet)
    
    Api.Tws.reqSmartComponents id, Range(CELL_BBO_EXCHANGE)
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_SUBSCRIBED
End Sub

' update soft dollar tiers table
Sub UpdateSmartComponents(msgId As Long, bitNumber As String, exchange As String, exchangeLetter As String)
    Dim rowId As Long
    
    For rowId = 1 To SmartComponentsTable.Rows.Count
        If SmartComponentsTable(rowId, 1) = STR_EMPTY Then
            Exit For
        End If
    Next

    SmartComponentsTable(rowId, Col_MSG_ID).value = msgId
    SmartComponentsTable(rowId, Col_BIT_NUMBER).value = bitNumber
    SmartComponentsTable(rowId, Col_EXCHANGE).value = exchange
    SmartComponentsTable(rowId, Col_EXCHANGE_LETTER).value = exchangeLetter
End Sub

Public Sub Initialise()
    Set SmartComponentsTable = SmartComponents.Range("$A$8:$D$40")
    Util.InitialiseSheetRowId ActiveSheet, ID_SMART_COMPONENTS
End Sub


Private Sub Worksheet_Activate()
    Main.Initialise
End Sub


