VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "PositionsMulti"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================
' table constants

Const CELL_ACCOUNT = "A6"
Const CELL_MODEL_CODE = "B6"
Const CELL_SUBSCRIPTION_STATUS = "A9"

Private Enum PositionsMultiColumns
    Col_POSITIONS_CONID = 1
    Col_ACCOUNT
    Col_MODELCODE
    Col_POSITIONS_POSITION
    Col_POSITIONS_AVGCOST
End Enum

Private dataTable As Range

'=================
' private methods
'=================
' request positions multi
Private Sub RequestPositionsMulti_Click()
    If Not CheckConnected Then Exit Sub
    
    ' clear positions
    dataTable.ClearContents
    
    ' update subscription status
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_SUBSCRIBED

    Api.Tws.ReqPositionsMulti ID_POSITIONS_MULTI, Range(CELL_ACCOUNT).value, Range(CELL_MODEL_CODE).value
End Sub

' cancel positions multi
Private Sub CancelPositionsMulti_Click()
    If Not CheckConnected Then Exit Sub
    
    ' update subscription status
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_EMPTY
    
    Api.Tws.CancelPositionsMulti ID_POSITIONS_MULTI
End Sub

' clear positions multi table
Private Sub ClearPositionsMulti_Click()
    If IsConnected Then CancelPositionsMulti_Click
    dataTable.ClearContents
End Sub

' find row in positions table by conId
Private Function FindRowByConId(conId As String, Account As String, modelCode As String)
    Dim i As Long
    i = 1
    Do While (Not (dataTable(i, Col_POSITIONS_CONID).value Like conId And _
                   dataTable(i, Col_ACCOUNT).value Like Account And _
                   dataTable(i, Col_MODELCODE).value Like modelCode) And _
            dataTable(i, Col_POSITIONS_CONID).value <> STR_EMPTY And _
        i <= dataTable.Rows.Count)
        i = i + 1
    Loop
    FindRowByConId = i
End Function

'=================
' public methods
'=================
' position multi
Public Sub PositionMulti(ByVal requestId As Long, ByVal Account As String, ByVal modelCode As String, ByVal contract As TWSLib.IContract, ByVal position As Double, ByVal avgCost As Double)
    Dim rowId As Long
    Dim conId As String
    conId = CStr(contract.conId)
    rowId = FindRowByConId(conId, Account, modelCode)
    
    dataTable(rowId, Col_POSITIONS_CONID).value = conId
    dataTable(rowId, Col_ACCOUNT).value = Account
    dataTable(rowId, Col_MODELCODE).value = modelCode
    dataTable(rowId, Col_POSITIONS_POSITION).value = position
    dataTable(rowId, Col_POSITIONS_AVGCOST).value = avgCost
End Sub

Public Sub Initialise()
    Set dataTable = PositionsMulti.Range("$A$13:$E$298")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub


