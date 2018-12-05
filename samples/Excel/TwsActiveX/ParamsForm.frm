VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} ParamsForm 
   Caption         =   "Smart Combo Routing Params"
   ClientHeight    =   4230
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   3825
   OleObjectBlob   =   "ParamsForm.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "ParamsForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'=======================
' local constants
'=======================
Const STR_SMART_COMBO_ROUTING_PARAMS_COLUMN_NOT_FOUND = "Smart Combo Routing Params column not found"
Const STR_SMART_COMBO_ROUTING_PARAMS_COLUMN_NOT_PARSED = "Smart Combo Routing Params string cannot be parsed"

Const NUM_GRDSMARTCOMBO_COLUMNS = 2

'=======================
' variables
'=======================
' column ids

Private mSmartComboRoutingParams As Range

'=======================
' methods
'=======================

' remove parameter button was clicked
Private Sub buttonSmartComboRemove_Click()
    ReDim selectedRows(grdSmartCombo.ListCount - 1) As Boolean
    
    Dim i As Long
    For i = 1 To grdSmartCombo.ListCount - 1
        If grdSmartCombo.Selected(i) Then selectedRows(i) = True
    Next
    
    For i = UBound(selectedRows) To 1 Step -1
        If selectedRows(i) Then grdSmartCombo.RemoveItem i
    Next
End Sub

' OK button was pressed
Private Sub buttonOK_Click()
    ' set the smart combo routing params cell
    If grdSmartCombo.ListCount > 1 Then
       mSmartComboRoutingParams.value = buildSmartComboRoutingParamsFromList()
    Else
       mSmartComboRoutingParams.value = ""
    End If

    ' hide ParamsForm
    ParamsForm.Hide
End Sub

' add parameter button was clicked
Private Sub buttonSmartComboAdd_Click()
    grdSmartCombo.AddItem ""
    grdSmartCombo.column(0, grdSmartCombo.ListCount - 1) = textBoxSmartComboParameter.text
    grdSmartCombo.column(1, grdSmartCombo.ListCount - 1) = textBoxSmartComboValue.text
    textBoxSmartComboParameter.SetFocus
End Sub

Private Sub textBoxSmartComboParameter_Enter()
textBoxSmartComboParameter.SelStart = 0
textBoxSmartComboParameter.SelLength = Len(textBoxSmartComboParameter.text)
End Sub

Private Sub textBoxSmartComboValue_Enter()
textBoxSmartComboValue.SelStart = 0
textBoxSmartComboValue.SelLength = Len(textBoxSmartComboParameter.text)
End Sub

Private Sub UserForm_Initialize()
    ' Add the header titles
    If grdSmartCombo.ListCount = 0 Then
        grdSmartCombo.AddItem ""
        grdSmartCombo.column(0, 0) = "Parameter"
        grdSmartCombo.column(1, 0) = "Value"
    End If
End Sub

Private Function Init() As Boolean
    Init = True
    
    textBoxSmartComboParameter.text = ""
    textBoxSmartComboValue.text = ""
    
    ' clear  table
    Dim i As Long
    For i = grdSmartCombo.ListCount - 1 To 1 Step -1
        grdSmartCombo.RemoveItem i
    Next i
    
    If mSmartComboRoutingParams.value = STR_EMPTY Then Exit Function
    
    ' smart combo routing params column has value, so parse this value and add items to grdSmartCombo table
    
    Dim ar() As String
    ar = Split(mSmartComboRoutingParams.value, STR_SEMICOLON)
    
    Dim numParams As Long
    numParams = CLng(ar(0))
    
    If UBound(ar) <> 2 * (1 + numParams) - 1 Then
        MsgBox STR_SMART_COMBO_ROUTING_PARAMS_COLUMN_NOT_PARSED
        Init = False
        Exit Function
    End If
    
    For i = 1 To numParams
        grdSmartCombo.AddItem ""
        grdSmartCombo.column(0, i) = ar(2 * i - 1)
        grdSmartCombo.column(1, i) = ar(2 * i)
    Next
End Function

' Cancel button was clicked
Private Sub buttonCancel_Click()
    ParamsForm.Hide
End Sub

' create smart combo routing params from grdSmartCombo table
Private Function buildSmartComboRoutingParamsFromList() As String
    Dim smartComboRoutingStr As String
    smartComboRoutingStr = grdSmartCombo.ListCount - 1 & STR_SEMICOLON
    
    Dim i As Long
    For i = 1 To grdSmartCombo.ListCount - 1
        grdSmartCombo.ListIndex = i
        smartComboRoutingStr = smartComboRoutingStr & grdSmartCombo.column(0, i) & STR_SEMICOLON & grdSmartCombo.column(1, i) & STR_SEMICOLON
    Next i
    
    buildSmartComboRoutingParamsFromList = smartComboRoutingStr
End Function


Public Function ShowForm(orderIndex As Long, contractDescriptionTable As Range, extendedAttributeTable As Range)
    Dim SecType As String
    SecType = contractDescriptionTable(orderIndex, ContractColumns.Col_SECTYPE).value
    
    If SecType <> SECTYPE_BAG Then
        MsgBox STR_SMART_COMBO_ROUTING_PARAMS_SECTYPE_NOT_BAG
        Exit Function
    End If
    
    Set mSmartComboRoutingParams = extendedAttributeTable(orderIndex, Col_SMART_COMBO_ROUTING_PARAMS)
    
    If Init Then ParamsForm.Show
End Function






