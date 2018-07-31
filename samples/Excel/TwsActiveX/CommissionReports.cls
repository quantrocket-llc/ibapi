VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CommissionReports"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum CommissionReportColumns
    Col_EXECID = 1
    Col_COMMISSION
    Col_CURRENCY
    Col_REALIZEDPNL
    Col_YIELD
    Col_YIELDREDEMPTIONDATE
End Enum

' local variables
Private rowId As Long

Private commissionReportsTable As Range

'=================
' private methods
'=================
' clear executions table
Private Sub clearCommissionReports_Click()
Clear
End Sub

Private Sub Clear()
    commissionReportsTable.ClearContents
    rowId = 1
End Sub


'=================
' public methods
'=================
' update commission reports table
Public Sub UpdateCommissionReports(ByVal commissionReport As TWSLib.ICommissionReport)
    If rowId <= commissionReportsTable.Rows.Count Then
        ' commission report
        With commissionReport
            commissionReportsTable(rowId, Col_EXECID).value = .execId
            commissionReportsTable(rowId, Col_COMMISSION).value = Util.DblMaxStr(.commission)
            commissionReportsTable(rowId, Col_CURRENCY).value = .currency
            commissionReportsTable(rowId, Col_REALIZEDPNL).value = Util.DblMaxStr(.realizedPNL)
            commissionReportsTable(rowId, Col_YIELD).value = Util.DblMaxStr(.yield)
            commissionReportsTable(rowId, Col_YIELDREDEMPTIONDATE).value = Util.IntMaxStr(.yieldRedemptionDate)
        End With
    
        rowId = rowId + 1
    End If

End Sub

Public Sub Initialise()
    Set commissionReportsTable = Me.Range("$A$7:$F$103")
    Clear
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
    If commissionReportsTable Is Nothing Then
        Set commissionReportsTable = Me.Range("$A$7:$F$103")
        Clear
    End If
End Sub


