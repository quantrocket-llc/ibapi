VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} ComboLegForm 
   Caption         =   "Combination Legs"
   ClientHeight    =   4305
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
Dim COMBO_DELIMITER As String

Private Sub grdCombos_DblClick()
    Dim entry As String
    entry = "16916412" & Chr(9) & "1" & Chr(9) & "SELL" & Chr(9) & "0" & Chr(9)
    grdCombos.AddItem entry
    entry = "15910126" & Chr(9) & "1" & Chr(9) & "BUY" & Chr(9) & "0" & Chr(9)
    grdCombos.AddItem entry
End Sub


'================================================================================
' Form Event handlers
'================================================================================

'--------------------------------------------------------------------------------
'
'   Method      : UserForm_Activate()
'   Description : Called when the 'Combination Order Legs' dialog is displayed.
'                 Any existing combo legs are flushed from the list.
'
'--------------------------------------------------------------------------------
Private Sub UserForm_Activate()
    COMBO_DELIMITER = "CMBLGS"
    
    ' Add the header titles
    If grdCombos.rows = 0 Then
        header = "ConId" & Chr(9) & "Ratio" & Chr(9) & "Action" & Chr(9) & "Exchange" & Chr(9) & "Open/Close" & Chr(9)
        grdCombos.AddItem (header)
    End If
    
    ' flush the old combo leg details
    numRows = grdCombos.rows
    For i = 1 To numRows - 1
        grdCombos.RemoveItem 1
    Next i
            
    ' parse the 'Comb Leg' data from current active row
    buildListFromComboLegs (Cells(ActiveCell.row, util.COMBO_LEG_COLUMN).Text)
    
End Sub

'================================================================================
' Button Event handlers
'================================================================================

'--------------------------------------------------------------------------------
'
'   Method      : btnAddLeg_Click()
'   Description : Called when the user presses the 'Add Combo Leg' button.
'                 The combo leg details are stored in the MSFlexGrid control.
'
'--------------------------------------------------------------------------------
Private Sub btnAddLeg_Click()
    Dim entry As String
       
    ' Add the combo leg
    entry = txtConId.Text & Chr(9) & txtRatio.Text & Chr(9) & txtAction.Text & Chr(9) & txtExchange.Text & Chr(9) & txtOpenClose.Text & Chr(9)
    grdCombos.AddItem entry
    
End Sub

'--------------------------------------------------------------------------------
'
'   Method      : btnRemoveLeg_Click()
'   Description : Called when the user presses the 'Remove Combo Leg' button.
'                 The first occurance of a combo leg, contained in the MSFlexGrid
'                 control, that matches the combo leg details is removed.
'
'--------------------------------------------------------------------------------
Private Sub btnRemoveLeg_Click()
    Dim entry As String
        
    ' get the current row selection if any
    selRowStart = grdCombos.row
    selRowEnd = grdCombos.RowSel
    If selRowStart > selRowEnd Then
        temp = selRowStart
        selRowStart = selRowEnd
        selRowEnd = temp
    End If
    
    For i = selRowEnd To selRowStart Step -1
        If Not i = 0 Then
            grdCombos.RemoveItem i
        End If
    Next i
    
End Sub

'--------------------------------------------------------------------------------
'
'   Method      : btnOk_Click()
'   Description : Called when the user presses the 'Remove Combo Leg' button.
'                 The contents of the MSFlexGrid (i.e. combo legs) is serialized
'                 to a string and stored on the current worksheet in the 'Combo Legs'
'                 cell of the active row.
'
'--------------------------------------------------------------------------------
Private Sub btnOk_Click()
    ' Set the combo legs cell
    Cells(ActiveCell.row, util.COMBO_LEG_COLUMN).value = buildComboLegsFromList()
    
    ComboLegForm.Hide
End Sub

'--------------------------------------------------------------------------------
'
'   Method      : btnCancel_Click()
'   Description : Called when the user presses the 'Remove Combo Leg' button.
'
'
'--------------------------------------------------------------------------------
Private Sub btnCancel_Click()
    ComboLegForm.Hide
End Sub

'================================================================================
' Helper Functions
'================================================================================
'--------------------------------------------------------------------------------
'
'   Method      : buildComboLegsString()
'   Description : This helper method serializes the combo legs to a formatted
'                 string. The syntax is:
'                   "identifier_numComboLegs_LegConid_LegRatio_LegAction_"
'                 E.g.
'                   CMBLGS_2_16916412_1_SELL_ISE_15910126_1_BUY_SMART
'
'                 The identifier is required it identify the start of the combo legs
'                 substring within the DDE request.
'
'--------------------------------------------------------------------------------
Private Function buildComboLegsFromList()
    Dim delimiter As String
    Dim comboLegsStr As String
    
    ' Create the identifier and number of combo legs (-1 for header row)
    comboLegsStr = COMBO_DELIMITER & util.UNDERSCORE & grdCombos.rows - 1
    
    ' serialize the contents of the combos list
    For i = 1 To grdCombos.rows - 1
        grdCombos.row = i
        grdCombos.Col = 0
        conId = getTokenValue(grdCombos.Text, False)
        grdCombos.Col = 1
        ratio = getTokenValue(grdCombos.Text, False)
        grdCombos.Col = 2
        action = getTokenValue(grdCombos.Text, False)
        grdCombos.Col = 3
        exchange = getTokenValue(grdCombos.Text, False)
        grdCombos.Col = 4
        openClose = getTokenValue(grdCombos.Text, False)
        
        comboLegsStr = comboLegsStr & util.UNDERSCORE & conId & util.UNDERSCORE & ratio & util.UNDERSCORE & action & util.UNDERSCORE & exchange & util.UNDERSCORE & openClose
    Next i
    
    If grdCombos.rows = 1 Then ' header only, no data
        buildComboLegsFromList = ""
    Else
        buildComboLegsFromList = comboLegsStr + util.UNDERSCORE + COMBO_DELIMITER
    End If
        
End Function

'--------------------------------------------------------------------------------
'
'   Method      : buildComboLegsString()
'   Description : Parses the contents of the 'Combo Leg' cell for the active row,
'                 anding the combo legs to the list (MSFlexGrid).
'
'--------------------------------------------------------------------------------
Private Sub buildListFromComboLegs(comboLegs As String)
    Dim aTokens As Variant
    Dim entry As String
    Dim pos As Integer
    
    ' ensure we have something to parse
    If Not comboLegs = "" Then
        aTokens = Split(comboLegs, util.UNDERSCORE)
        If UBound(aTokens) < 2 Then
            MsgBox ("The combo leg string needs to start with 'CMBLGS_'")
            Exit Sub
        End If
            
        If Not ((UBound(aTokens) - 2) Mod 5 = 0) Then
            MsgBox ("The combo leg string does not have all the required leg data")
            Exit Sub
        End If
        
        ' parse each combo leg and add it to the list
        pos = 2
        For i = 1 To aTokens(1) 'the number of combo legs
            entry = getTokenValue(aTokens(pos), True) & Chr(9)
            entry = entry & getTokenValue(aTokens(pos + 1), True) & Chr(9)
            entry = entry & getTokenValue(aTokens(pos + 2), True) & Chr(9)
            entry = entry & getTokenValue(aTokens(pos + 3), True) & Chr(9)
            entry = entry & getTokenValue(aTokens(pos + 4), True)
            grdCombos.AddItem (entry)
            pos = pos + 5
        Next i
    End If
End Sub

'--------------------------------------------------------------------------------
'
'   Method      : getTokenValue()
'   Description : If the token empty then its replaces with the 'EMPTY' string
'                 as the token place holder
'
'--------------------------------------------------------------------------------
Private Function getTokenValue(ByVal token As String, parseIn As Boolean)
    Dim newVal As String
    
    If parseIn Then
        ' Replace the incomming 'EMPTY' placeholder with ""
        If token = util.ORIGINAL_CELL_EMPTY Or token = util.NEW_CELL_EMPTY Or token = util.PREV_CELL_EMPTY Then
            token = ""
        End If
    Else
        ' Replace the outgoing empty string "" with the 'EMPTY' placeholder
        If token = "" Then
            token = util.ORIGINAL_CELL_EMPTY
        End If
    End If
    
    getTokenValue = token
End Function

