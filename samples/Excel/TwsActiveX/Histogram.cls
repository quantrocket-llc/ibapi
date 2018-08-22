VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Histogram"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum HistogramDataColumns
    Col_MSG_ID = 1
    Col_PRICE
    Col_SIZE
End Enum

Const CELL_SUBSCRIPTION_STATUS = "C4"
Const CELL_USE_RTH = "Q3"
Const CELL_PERIOD = "R3"

Private histogramDataTable As Range
Private contractTable As Range

'=================
' methods
'=================
' clear soft dollar tiers table
Private Sub ClearHistogramData_Click()
    histogramDataTable.ClearContents
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_EMPTY
End Sub



' request soft dollar tiers subscription
Private Sub RequestHistogramData_Click()
    If Not CheckConnected Then Exit Sub
    
    Dim id As Long
    
    id = Util.IncrementSheetRowId(ActiveSheet)
    
    Dim lContractInfo As TWSLib.IContract
    Set lContractInfo = Api.Tws.createContract()
    
    ' fill contract structure
    Util.FillContractObject lContractInfo, contractTable, 1
    
    Api.Tws.reqHistogramData id, lContractInfo, Range(CELL_USE_RTH), Range(CELL_PERIOD)
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_SUBSCRIBED
End Sub

' update soft dollar tiers table
Sub UpdateHistogramData(msgId As Long, price As Double, size As Long)
    Dim rowId As Long
    
    For rowId = 1 To histogramDataTable.Rows.Count
        If histogramDataTable(rowId, 1) = STR_EMPTY Then
            Exit For
        End If
    Next

    histogramDataTable(rowId, Col_MSG_ID).value = msgId
    histogramDataTable(rowId, Col_PRICE).value = price
    histogramDataTable(rowId, Col_SIZE).value = size
End Sub

Public Sub Initialise()
    Set histogramDataTable = Histogram.Range("$A$8:$C$4008")
    Set contractTable = Histogram.Range("$E$3:$O$3")
    
    Util.InitialiseSheetRowId ActiveSheet, ID_HISTOGRAM_DATA
End Sub


Private Sub CancelHistogramData_Click()
    Dim id As Long
    
    id = Util.GetSheetRowId(ActiveSheet)
    
    Api.Tws.CancelHistogramData id
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_CANCELLED
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub


