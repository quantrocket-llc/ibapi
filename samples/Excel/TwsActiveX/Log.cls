VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Log"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum LogTableColumns
    Col_MSGID = 1
    Col_MSGCODE
    Col_MSGTIME
    Col_MSGTEXT
End Enum

Private rowId As Long

Private logTable As Range

'=================
' methods
'=================
' log message
Public Sub LogMessage(ByVal id As Long, ByVal errorCode As Long, ByVal errorMsg As String)
    logTable(rowId, Col_MSGID).value = id
    logTable(rowId, Col_MSGCODE).value = errorCode
    logTable(rowId, Col_MSGTEXT).value = errorMsg
    
    ' current time
    logTable(rowId, Col_MSGTIME).value = Now
    
    rowId = rowId + 1
    
    If rowId = logTable.Rows.Count Then rowId = 1
End Sub

Public Sub ClearLog_Click()
    rowId = 1
    logTable.ClearContents
End Sub

Public Sub Initialise()
    Set logTable = Range("$A6:$D65536")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub


