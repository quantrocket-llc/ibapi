VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Bulletins"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum BulletinColumns
    Col_MSG_ID = 1
    Col_MSG_TYPE
    Col_MESSAGE
    Col_ORIG_EXCH
End Enum

Const CELL_SUBSCRIPTION_STATUS = "C4"

' other constants
Const MSG_TYPE_STR_REGULAR = "Regular IB news bulletin"
Const MSG_TYPE_STR_EXCH_NA = "Exchange no longer available for trading"
Const MSG_TYPE_STR_EXCH_AVAIL = "Exchange is available for trading"

' msg types
Const MSG_TYPE_REG = 1
Const MSG_TYPE_EXCH_NA = 2
Const MSG_TYPE_EXCH_AVAIL = 3

Private bulletinsTable As Range

'=================
' methods
'=================
' clear bulletins table
Private Sub ClearNewsBulletins_Click()
    If IsConnected Then CancelNewsBulletinsRequest
    
    bulletinsTable.ClearContents
End Sub

' cancel News Bulletins subscription
Private Sub CancelNewsBulletins_Click()
    CancelNewsBulletinsRequest
End Sub

Private Sub CancelNewsBulletinsRequest()
    If Not CheckConnected Then Exit Sub
    
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_EMPTY
    Api.Tws.CancelNewsBulletins
End Sub

' request News Bulletins subscription
Private Sub RequestNewsBulletins_Click()
    If Not CheckConnected Then Exit Sub
    
    Range(CELL_SUBSCRIPTION_STATUS).value = STR_SUBSCRIBED
    Api.Tws.reqNewsBulletins AllDayNews.value
End Sub

' update news bulletins table
Sub updateNewsBulletins(msgId As Integer, msgType As Integer, message As String, origExchange As String)
    Dim rowId As Long
    
    ' find the first empty row
    Dim row As Object
    For Each row In bulletinsTable
        rowId = rowId + 1
        If bulletinsTable(row.row, 1) = STR_EMPTY Then
            Exit For
        End If
    Next
    
    Dim msgTypeStr As String
    
    Select Case msgType
        Case MSG_TYPE_REG
            msgTypeStr = MSG_TYPE_STR_REGULAR
        Case MSG_TYPE_EXCH_NA
            msgTypeStr = MSG_TYPE_STR_EXCH_NA
        Case MSG_TYPE_EXCH_AVAIL
            msgTypeStr = MSG_TYPE_STR_EXCH_AVAIL
    End Select

    bulletinsTable(Col_MSG_ID).value = msgId
    bulletinsTable(Col_MSG_TYPE).value = msgTypeStr
    bulletinsTable(Col_MESSAGE).value = message
    bulletinsTable(Col_ORIG_EXCH).value = origExchange
End Sub

Public Sub Initialise()
    Set bulletinsTable = Bulletins.Range("$A$8:$O$40")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub


