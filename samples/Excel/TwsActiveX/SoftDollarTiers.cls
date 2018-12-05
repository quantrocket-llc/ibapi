VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SoftDollarTiers"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum SoftDollarTiersColumns
    Col_MSG_ID = 1
    Col_NAME
    Col_DISPLAY_NAME
    Col_VALUE
End Enum

Const CELL_SUBSCRIPTION_STATUS = "C4"

Private softDollarTiersTable As Range

'=================
' methods
'=================
' clear soft dollar tiers table
Private Sub ClearSoftDollarTiers_Click()
    softDollarTiersTable.ClearContents
    
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_EMPTY
End Sub



' request soft dollar tiers subscription
Private Sub RequestSoftDollarTiers_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Long
    
    id = Util.IncrementSheetRowId(ActiveSheet)
    
    Api.Tws.reqSoftDollarTiers id
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_SUBSCRIBED
End Sub

' update soft dollar tiers table
Sub UpdateSoftDollarTiers(msgId As Long, name As String, displayName As String, value As String)
    Dim rowId As Long
    
    For rowId = 1 To softDollarTiersTable.Rows.Count
        If softDollarTiersTable(rowId, 1) = STR_EMPTY Then
            Exit For
        End If
    Next

    softDollarTiersTable(rowId, Col_MSG_ID).value = msgId
    softDollarTiersTable(rowId, Col_NAME).value = name
    softDollarTiersTable(rowId, Col_DISPLAY_NAME).value = displayName
    softDollarTiersTable(rowId, Col_VALUE).value = value
End Sub

Public Sub Initialise()
    Set softDollarTiersTable = SoftDollarTiers.Range("$A$8:$D$40")
    Util.InitialiseSheetRowId ActiveSheet, ID_SOFT_DOLLAR_TIER
End Sub


Private Sub Worksheet_Activate()
    Main.Initialise
End Sub


