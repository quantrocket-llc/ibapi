VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} ScrollableMsgBox 
   Caption         =   "ScrollabeMsgBox"
   ClientHeight    =   7635
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   9660
   OleObjectBlob   =   "ScrollableMsgBox.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "ScrollableMsgBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim m9_wsName As String

' hide form when OK button was pressed
Private Sub buttonOK_Click()
    ' update with modified text
    If checkBoxModify.value Then
        ThisWorkbook.Sheets(m9_wsName).ReplaceText scrollableTextBox.text
    End If
    
    ' hide form
    ScrollableMsgBox.Hide
End Sub

Private Sub scrollabeTextBox_Change()

End Sub

' set focus and scrolling position during form activation
Private Sub UserForm_Activate()
    scrollableTextBox.SetFocus
    scrollableTextBox.SelStart = 0
End Sub

' set text to display
Public Sub ShowText(textToDisplay As String, captionToDisplay As String, canModify As Boolean, wsName As String)
    scrollableTextBox.text = textToDisplay
    ScrollableMsgBox.Caption = captionToDisplay
    checkBoxModify.Enabled = canModify
    scrollableTextBox.Locked = Not canModify
    m9_wsName = wsName
    
    ' show form
    ScrollableMsgBox.Show
End Sub

