VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} ComboLegForm 
   Caption         =   "Combination Legs"
   ClientHeight    =   7215
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   10065
   OleObjectBlob   =   "ComboLegForm.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "ComboLegForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'=======================
' local constants
'=======================
' form constants
Const OPENCLOSE_SAME = "Same (0)"
Const OPENCLOSE_OPEN = "Open (1)"
Const OPENCLOSE_CLOSE = "Close (2)"

Const SHORTSALESLOT_UNAPPL = "Unapplicable (0)"
Const SHORTSALESLOT_CLRBRKR = "Clearing Broker (1)"
Const SHORTSALESLOT_THIRDPARTY = "Third Party (2)"

' other constants
'Const COLUMN_NAME_COMBO_LEGS = "Combo Legs"
'Const COLUMN_NAME_SECTYPE = "Type"
'Const COLUMN_NAME_DELTANEUTRALCONTRACT = "Delta-Neutral"
Const STR_COMBO_LEGS_COLUMN_NOT_FOUND = "Combo Legs column is not found in this table"
Const NUM_GRDCOMBOS_COLUMNS = 9

'=======================
' variables
'=======================

Private mComboLegs As Range
Private mDeltaNeutralContract As Range

Private Sub DataGrid1_Click()

End Sub

'=======================
' methods
'=======================
' ShortSaleSlot combo box value was changed
Private Sub legShortSaleSlot_Change()
    If legShortSaleSlot.value = SHORTSALESLOT_THIRDPARTY Then
        legDesignatedLocation.Enabled = True
    Else
        legDesignatedLocation.Enabled = False
    End If
End Sub

' add leg button was clicked
Private Sub buttonAdd_Click()
    Dim entry As String

    ' Add the combo leg
    entry = legConID.text & Chr(9) & legRatio.text & Chr(9) & legSide.value & Chr(9) & legExchange.text & Chr(9)
    
    Select Case legOpenClose.value
        Case OPENCLOSE_SAME
            entry = entry & "0" & Chr(9)
        Case OPENCLOSE_OPEN
            entry = entry & "1" & Chr(9)
        Case OPENCLOSE_CLOSE
            entry = entry & "2" & Chr(9)
    End Select
    
    Select Case legShortSaleSlot.value
        Case SHORTSALESLOT_UNAPPL
            entry = entry & "0" & Chr(9)
        Case SHORTSALESLOT_CLRBRKR
            entry = entry & "1" & Chr(9)
        Case SHORTSALESLOT_THIRDPARTY
            entry = entry & "2" & Chr(9) & legDesignatedLocation.text
    End Select
    
    entry = entry & Chr(9) & legExemptCode.text & Chr(9) & legPrice.text
    
    Dim items() As String
    items = Split(entry, Chr(9))
    
    grdCombos.AddItem items(0)
    
    Dim i As Long
    For i = 1 To UBound(items)
        grdCombos.List(grdCombos.ListCount - 1, i) = items(i)
    Next i
End Sub

' remove leg button was clicked
Private Sub buttonRemove_Click()
    Dim entry As String

    ' get the current row selection if any
    Dim selRowStart As Long
    selRowStart = 1
    
    Dim selRowEnd As Long
    selRowEnd = grdCombos.ListCount - 1

    Dim i As Long
    For i = selRowEnd To selRowStart Step -1
        If grdCombos.Selected(i) Then
            grdCombos.RemoveItem i
        End If
    Next i

End Sub

' OK button was pressed
Private Sub buttonOK_Click()
    ' set the combo legs cell
    If grdCombos.ListCount > 1 Then
        
        mComboLegs.value = buildComboLegsFromList()
        
        ' set the under comp cell
        If deltaNeutralContractConId.text <> STR_ZERO And deltaNeutralContractConId.text <> STR_EMPTY Then
            mDeltaNeutralContract.value = buildDeltaNeutralContractString()
        End If
    Else
        mComboLegs.value = ""
        mDeltaNeutralContract.value = ""
    End If

    ' hide ComboLegForm
    ComboLegForm.Hide
End Sub

Private Sub ListBox1_Click()

End Sub

Private Function Init() As Boolean
    On Error GoTo ComboLegsParserError
    
    legConID.text = STR_ZERO
    legRatio.text = STR_ZERO
    legSide.value = ACTION_BUY
    legExchange.text = STR_EMPTY
    legOpenClose.value = OPENCLOSE_SAME
    legShortSaleSlot.value = SHORTSALESLOT_UNAPPL
    legDesignatedLocation.text = STR_EMPTY
    legExemptCode.text = "-1"
    legPrice.text = STR_EMPTY

    ' under comp
    deltaNeutralContractConId.text = STR_ZERO
    deltaNeutralContractDelta.text = STR_ZERO
    deltaNeutralContractPrice.text = STR_ZERO

    ' clear combo legs table
    Dim i As Long
    For i = grdCombos.ListCount - 1 To 1 Step -1
        grdCombos.RemoveItem i
    Next i
    
    If mComboLegs.value <> STR_EMPTY Then
        ' if Combo Legs column has value then parse this value and add items to grdCombos table
        
        Dim tempStr As String
        Dim numLegs As Long
        Dim strEntry
        
        tempStr = mComboLegs.value
        tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
        ' number of legs
        numLegs = Val(Left(tempStr, 1))
        tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
        
        For i = 1 To numLegs
            Dim j As Long
            For j = 1 To NUM_GRDCOMBOS_COLUMNS
                strEntry = strEntry & Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1) & Chr(9)
                tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
            Next j
            
            Dim items() As String
            items = Split(strEntry, Chr(9))
            grdCombos.AddItem items(0)
            
            Dim iSubItem As Long
            For iSubItem = 1 To UBound(items)
                grdCombos.List(grdCombos.ListCount - 1, iSubItem) = items(iSubItem)
            Next iSubItem
            
            strEntry = STR_EMPTY
        Next i
    
        If mDeltaNeutralContract.value <> STR_EMPTY Then
            ' parse under comp string and fill ComboLegForm with appropriate data
            tempStr = mDeltaNeutralContract.value
            tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
            deltaNeutralContractConId.text = Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1)
            tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
            deltaNeutralContractDelta.text = Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1)
            tempStr = Right(tempStr, Len(tempStr) - InStr(tempStr, STR_UNDERSCORE))
            deltaNeutralContractPrice.text = Left(tempStr, InStr(tempStr, STR_UNDERSCORE) - 1)
        End If
    End If
    
    Init = True
    Exit Function
    
    ' error
ComboLegsParserError:
    MsgBox STR_COMBO_LEGS_STRING_CANNOT_BE_PARSED
    Init = False
End Function

' initializing ComboLegForm
Private Sub UserForm_Initialize()
    
    ' Add the header titles
    If grdCombos.ListCount = 0 Then
        Dim Header()
        
        Header = Array("ConId", "Ratio", "Action", "Exchange", "Open/Close", "Short Sale Slot", "Designated Location", "Exempt Code", "Price")
        
        grdCombos.AddItem Header(0)
        grdCombos.ColumnCount = UBound(Header) + 1
        
        Dim i As Long
        For i = 1 To UBound(Header)
            grdCombos.List(0, i) = Header(i)
        Next i
    End If

    ' initialize combo boxes
    legSide.AddItem ACTION_BUY
    legSide.AddItem ACTION_SELL
    legSide.AddItem ACTION_SSHORT
    
    legOpenClose.AddItem OPENCLOSE_SAME
    legOpenClose.AddItem OPENCLOSE_OPEN
    legOpenClose.AddItem OPENCLOSE_CLOSE
    
    legShortSaleSlot.AddItem SHORTSALESLOT_UNAPPL
    legShortSaleSlot.AddItem SHORTSALESLOT_CLRBRKR
    legShortSaleSlot.AddItem SHORTSALESLOT_THIRDPARTY

End Sub

' Cancel button was clicked
Private Sub buttonCancel_Click()
    ComboLegForm.Hide
End Sub

' create combo legs string from grdCombos table
Private Function buildComboLegsFromList() As String

    Dim comboLegsStr As String
    comboLegsStr = STR_COMBOLEGS & STR_UNDERSCORE
    comboLegsStr = comboLegsStr & (grdCombos.ListCount - 1) & STR_UNDERSCORE
    
    Dim i As Long
    For i = 1 To grdCombos.ListCount - 1
        Dim j As Long
        For j = 0 To grdCombos.ColumnCount - 1
            comboLegsStr = comboLegsStr & grdCombos.List(i, j) & STR_UNDERSCORE
        Next j
    Next i
    
    comboLegsStr = comboLegsStr & STR_COMBOLEGS
    
    buildComboLegsFromList = comboLegsStr
        
End Function

' create under comp string
Private Function buildDeltaNeutralContractString() As String

    Dim deltaNeutralContractStr As String
    deltaNeutralContractStr = STR_DELTANEUTRALCONTRACT & STR_UNDERSCORE
    deltaNeutralContractStr = deltaNeutralContractStr & deltaNeutralContractConId.value & STR_UNDERSCORE
    deltaNeutralContractStr = deltaNeutralContractStr & deltaNeutralContractDelta.value & STR_UNDERSCORE
    deltaNeutralContractStr = deltaNeutralContractStr & deltaNeutralContractPrice.value & STR_UNDERSCORE & STR_DELTANEUTRALCONTRACT
    
    buildDeltaNeutralContractString = deltaNeutralContractStr
        
End Function

Public Function ShowForm(contractsTable As Range)
    Dim index As Long
    index = ActiveCell.row - contractsTable.Rows(1).row + 1
    If contractsTable(index, ContractColumns.Col_SECTYPE).value <> SECTYPE_BAG Then
        MsgBox STR_SMART_COMBO_ROUTING_PARAMS_SECTYPE_NOT_BAG
    Else
        Set mComboLegs = contractsTable(index, ContractColumns.Col_COMBOLEGS)
        Set mDeltaNeutralContract = contractsTable(index, ContractColumns.Col_DELTANEUTRALCONTRACT)
        If Init Then ComboLegForm.Show
    End If
End Function




