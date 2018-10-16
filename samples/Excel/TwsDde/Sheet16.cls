VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet16"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Const execsSheetName = "Executions"
Const execReportRange = "execReportRange"
Const execReportType = "execReportType"
Const execReportKey = "execReportKey"
Const baseX = 1
Const baseY = 8

Sub doQuery()
    On Error Resume Next
    Dim TheArray() As Variant, execsControlValue As String, reportType As Integer, reportKey As String
    execsControlValue = Sheet11.controlCellValue()
    If execsControlValue <> ArrayQueries.SUBSCRIBED Then
        MsgBox "Must be subscribed to Executions to do this."
    Else
        reportType = Range(execReportType).value
        reportKey = Range(execReportKey).value
        If reportType = 0 Or reportKey = "" Then
            MsgBox "Must select a report type and enter a key value"
        Else
            TheArray = Sheet11.queryExecutions(reportType, reportKey)
            Call populatePage(Me.name, execReportRange, TheArray, baseX, baseY, False)
        End If
    End If
End Sub

Sub clearReportedExecutions()
    If util.rangeNameExists(execReportRange) Then
        Range(execReportRange).Formula = ""
        ActiveWorkbook.Names(execReportRange).Delete
    End If
End Sub

