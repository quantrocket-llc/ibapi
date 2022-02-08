VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} ComboLegForm 
   Caption         =   "Combination Legs"
   ClientHeight    =   7065
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8415
   OleObjectBlob   =   "ComboLegForm.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "ComboLegForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Const SEPARATOR = util.UNDERSCORE
Private Const CELL_EMPTY = util.STR_EMPTY

Private Sub UserForm_Activate()
    comboList.Clear
    comboList.AddItem ("ConId" & SEPARATOR & "Ratio" & SEPARATOR & "Action" & SEPARATOR & "Exchange" & SEPARATOR & "Open/Close" & SEPARATOR _
        & "Short Sale Slot" & SEPARATOR & "Designated Location" & SEPARATOR & "Exempt Code") 'header
    buildListFromComboLegs (Cells(ActiveCell.row, util.COMBO_LEG_COLUMN).Text)
    fillDeltaNeutralFromString (Cells(ActiveCell.row, util.DELTA_NEUTRAL_COLUMN).Text)
End Sub

Private Function getValue(value As String) As String
    If value = util.STR_EMPTY Then
        getValue = CELL_EMPTY
    Else
        getValue = value
    End If
End Function

Private Sub btnAddLeg_Click()
    Dim entry As String
    entry = getValue(txtConId.Text) & SEPARATOR & getValue(txtRatio.Text) & SEPARATOR & getValue(txtAction.Text) & SEPARATOR & getValue(txtExchange.Text) _
        & SEPARATOR & getValue(txtOpenClose.Text) & SEPARATOR & getValue(txtShortSaleSlot.Text) & SEPARATOR & getValue(txtDesignatedLocation.Text) & SEPARATOR & getValue(txtExemptCode)
    comboList.AddItem (entry)
End Sub

Private Sub btnRemoveLeg_Click()
    If comboList.ListIndex > 0 Then 'do not remove header
        comboList.RemoveItem comboList.ListIndex
    End If
End Sub

Private Sub btnOk_Click()
    Cells(ActiveCell.row, util.COMBO_LEG_COLUMN).value = buildComboLegsFromList()
    Cells(ActiveCell.row, util.DELTA_NEUTRAL_COLUMN).value = buildDeltaNeutralString()
    ComboLegForm.Hide
End Sub

Private Sub btnCancel_Click()
    ComboLegForm.Hide
End Sub

Private Function buildComboLegsFromList()
    Dim comboLegsStr As String
    comboLegsStr = comboList.ListCount - 1
    
    For i = 1 To comboList.ListCount - 1
        comboLegsStr = comboLegsStr & util.UNDERSCORE & comboList.List(i)
    Next i
    
    If comboList.ListCount = 1 Then
        buildComboLegsFromList = ""
    Else
        buildComboLegsFromList = comboLegsStr
    End If
        
End Function

Private Sub buildListFromComboLegs(comboLegs As String)
    Dim aTokens As Variant
    Dim entry As String
    Dim pos As Integer
    
    If Not comboLegs = "" Then
        aTokens = split(comboLegs, util.UNDERSCORE)
            
        If Not (UBound(aTokens) Mod 8 = 0) Then
            MsgBox ("The combo leg string does not have all the required leg data")
            Exit Sub
        End If
        
        pos = 1
        For i = 1 To aTokens(0) ' number of combo legs
            entry = aTokens(pos) & SEPARATOR
            entry = entry & aTokens(pos + 1) & SEPARATOR
            entry = entry & aTokens(pos + 2) & SEPARATOR
            entry = entry & aTokens(pos + 3) & SEPARATOR
            entry = entry & aTokens(pos + 4) & SEPARATOR
            entry = entry & aTokens(pos + 5) & SEPARATOR
            entry = entry & aTokens(pos + 6) & SEPARATOR
            entry = entry & aTokens(pos + 7)
            comboList.AddItem (entry)
            pos = pos + 8
        Next i
    End If
End Sub

Private Sub fillDeltaNeutralFromString(deltaNeutral As String)
    Dim aTokens As Variant
    If Not deltaNeutral = "" Then
        aTokens = split(deltaNeutral, util.UNDERSCORE)
            
        txtDnConId.Text = aTokens(0)
        txtDnDelta.Text = aTokens(1)
        txtDnPrice.Text = aTokens(2)
    End If
End Sub

Private Function buildDeltaNeutralString()
    Dim deltaNeutralStr As String
    deltaNeutralStr = ""
    
    If txtDnConId.Text <> "" Then
        deltaNeutralStr = deltaNeutralStr & txtDnConId.Text & util.UNDERSCORE
    End If
    If txtDnDelta.Text <> "" Then
        deltaNeutralStr = deltaNeutralStr & txtDnDelta.Text & util.UNDERSCORE
    End If
    If txtDnPrice.Text <> "" Then
        deltaNeutralStr = deltaNeutralStr & txtDnPrice.Text
    End If
    
    buildDeltaNeutralString = deltaNeutralStr
End Function

