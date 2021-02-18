VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} IBBulletinsForm 
   Caption         =   "IB News Bulletins"
   ClientHeight    =   1500
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6135
   OleObjectBlob   =   "IBBulletinsForm.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "IBBulletinsForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub btnSubscribe_Click()
    Call Sheet1.bulletinSubscribe
End Sub
Private Sub bntUnSubscribe_Click()
    Call Sheet1.bulletinSubscribe
End Sub
Private Sub btnCancel_Click()
    IBBulletinsForm.Hide
End Sub
