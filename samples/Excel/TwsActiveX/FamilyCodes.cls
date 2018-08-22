VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FamilyCodes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum FamilyCodesTableColumns
    Col_FAMILY_CODES_ACCOUNTID = 1
    Col_FAMILY_CODES_FAMILYCODE
End Enum

Private familyCodesTable As Range

'=================
' private methods
'=================
' request family codes
Private Sub requestFamilyCodes_Click()
    If Not CheckConnected Then Exit Sub
    
    ' clear family codes table
    familyCodesTable.ClearContents
    
    Api.Tws.reqFamilyCodes
End Sub

' clear family codes table
Private Sub clearFamilyCodes_Click()
    familyCodesTable.ClearContents
End Sub

'=================
' public methods
'=================
' family codes
Public Sub FamilyCodes(ByVal FamilyCodes As TWSLib.IFamilyCodeList)
    Dim fc As TWSLib.ComFamilyCode
    
    Dim i As Long
    For i = 1 To FamilyCodes.Count
        Set fc = FamilyCodes.Item(i - 1)
        familyCodesTable(i, Col_FAMILY_CODES_ACCOUNTID).value = fc.accountID
        familyCodesTable(i, Col_FAMILY_CODES_FAMILYCODE).value = fc.familyCodeStr
    Next
End Sub

Public Sub Initialise()
    Set familyCodesTable = Range("$A$6:$B$65536")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub


