VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "AccountUpdatesMulti"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' constants
Const STR_SHEET_NAME = "AccountUpdatesMulti"
Const STR_REQ_ACCOUNT_UPDATES_MULTI = "reqAccountUpdatesMulti"
Const STR_CANCEL_ACCOUNT_UPDATES_MULTI = "cancelAccountUpdatesMulti"
Const STR_REQ_ACCOUNT_UPDATES_MULTI_ERROR = "reqAccountUpdatesMultiError"
Const STR_REQ_ACCOUNT_UPDATE_TIME = "reqAccountUpdateTime"
Const STR_REQ_FAMILY_CODES = "reqFamilyCodes"
Const STR_REQ_MANAGED_ACCOUNTS = "reqManagedAccounts"
Const STR_REQ_FA = "reqFA"
Const STR_REQ_FA_ERROR = "reqFAError"
Const STR_REPLACE_FA = "replaceFA"
Const STR_REPLACE_FA_ERROR = "replaceFAError"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_ACCOUNT = "A9" ' cell with account name
Const CELL_MODEL_CODE = "B9" ' cell with model name
Const CELL_LEDGER_AND_NLV = "C9" ' cell with ledgerAndNLV flag
Const CELL_SUBSCRIPTION_CONTROL = "E9" ' cell with subscription control
Const CELL_ID = "G9" ' cell with id
Const CELL_ERROR = "H9" ' cell with error
Const CELL_ACCOUNT_UPDATE_TIME = "O12" ' cell with account update time
Const CELL_FAMILY_CODES_REQUEST_CONTROL = "R12" ' cell with family codes request
Const CELL_MANAGED_ACCOUNTS = "Q5" ' cell with managed accounts

Const CELL_REQ_FA_TYPE = "T6" ' cell with request FA type
Const CELL_REQ_FA_CONTROL = "U6" ' cell with request FA control
Const CELL_REQ_FA_ERROR = "W6" ' cell with request FA error
Const CELL_REPLACE_FA_TYPE = "T9" ' cell with replace FA type
Const CELL_REPLACE_FA_CONTROL = "U9" ' cell with replace FA control
Const CELL_REPLACE_FA_ERROR = "W9" ' cell with replace FA error

' rows
Const ACCOUNT_UPDATES_START_ROW = 14
Const ACCOUNT_UPDATES_END_ROW = 500
Const FA_START_ROW = 11

' columns
Const COLUMN_ACCOUNT_UPDATE = 1
Const COLUMN_MODEL_CODE_UPDATE = 3
Const COLUMN_KEY_UPDATE = 5
Const COLUMN_VALUE_UPDATE = 11
Const COLUMN_CURRENCY_UPDATE = 15
Const COLUMN_ACCOUNT_ID = 17
Const COLUMN_FA = 20


' range
Const ACCOUNT_UPDATES_TABLE_RANGE = "A" & ACCOUNT_UPDATES_START_ROW & ":O" & ACCOUNT_UPDATES_END_ROW
Const FAMILY_CODES_TABLE_RANGE = "Q" & ACCOUNT_UPDATES_START_ROW & ":R" & ACCOUNT_UPDATES_END_ROW
Const FA_TABLE_RANGE = "T" & FA_START_ROW & ":AD" & ACCOUNT_UPDATES_END_ROW

' vars
Dim genId As Long

' ========================================================
' Requests FA
' ========================================================
Sub requestFA()
    With Worksheets(STR_SHEET_NAME)
        Dim server As String, faDataType As String
        server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
        If server = util.STR_EMPTY Then Exit Sub
        
        faDataType = .range(CELL_REQ_FA_TYPE).value

        .range(CELL_REQ_FA_CONTROL).Formula = util.composeLink(server, STR_REQ_FA, util.IDENTIFIER_ZERO, faDataType) ' subscription control
        If util.cleanOnError(.range(CELL_REQ_FA_CONTROL)) Then
            .range(CELL_REQ_FA_CONTROL).value = util.STR_EMPTY
            .range(CELL_REQ_FA_ERROR).value = util.STR_EMPTY
            Exit Sub
        End If
         
    End With
End Sub

' ========================================================
' Clear FA table
' ========================================================
Sub clearFATable()
    ' clear FA table
    With Worksheets(STR_SHEET_NAME)
        .range(CELL_REQ_FA_CONTROL).value = util.STR_EMPTY
        .range(CELL_REQ_FA_ERROR).value = util.STR_EMPTY
        .range(CELL_REPLACE_FA_CONTROL).value = util.STR_EMPTY
        .range(CELL_REPLACE_FA_ERROR).value = util.STR_EMPTY
        .range(FA_TABLE_RANGE).ClearContents
    End With
End Sub

' ========================================================
' Replace FA
' ========================================================
Sub replaceFA()
    With Worksheets(STR_SHEET_NAME)
        Dim server As String, faDataType As String
        server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
        If server = util.STR_EMPTY Then Exit Sub
        
        faDataType = .range(CELL_REPLACE_FA_TYPE).value

        ' range to poke
        Dim endRow As Integer
        For endRow = FA_START_ROW To ACCOUNT_UPDATES_END_ROW
            If .Cells(endRow, COLUMN_FA).value = util.STR_EMPTY Then GoTo EndFor
        Next endRow
EndFor:
        
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(FA_START_ROW, COLUMN_FA), .Cells(endRow, COLUMN_FA))
        
        
        ' fill status column with formula
        .range(CELL_REPLACE_FA_CONTROL).Formula = util.composeLink(server, STR_REPLACE_FA, util.IDENTIFIER_ZERO, "") ' subscription control
        If util.cleanOnError(.range(CELL_REPLACE_FA_CONTROL)) Then
            .range(CELL_REPLACE_FA_CONTROL).value = util.STR_EMPTY
            .range(CELL_REPLACE_FA_ERROR).value = util.STR_EMPTY
            Exit Sub
        End If
    
        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REPLACE_FA, util.IDENTIFIER_ZERO & util.QMARK & faDataType, rangeToPoke
    End With

End Sub

' ========================================================
' Requests managed accounts
' ========================================================
Sub requestManagedAccounts()
    With Worksheets(STR_SHEET_NAME)
        Dim server As String
        server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
        If server = util.STR_EMPTY Then Exit Sub

        .range(CELL_MANAGED_ACCOUNTS).Formula = util.composeLink(server, STR_REQ_MANAGED_ACCOUNTS, util.IDENTIFIER_ZERO, util.STR_EMPTY) ' subscription control
    End With
End Sub

' ========================================================
' Cancel family codes when button is pressed
' ========================================================
Sub cancelFamilyCodes()
    Worksheets(STR_SHEET_NAME).range(CELL_FAMILY_CODES_REQUEST_CONTROL).value = ""
    clearFamilyCodesTable
End Sub

' ========================================================
' Requests family codes when button is pressed
' ========================================================
Sub requestFamilyCodes()
    With Worksheets(STR_SHEET_NAME)
        If CStr(.range(CELL_FAMILY_CODES_REQUEST_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
    
        clearFamilyCodesTable

        Dim server As String
        server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
        If server = util.STR_EMPTY Then Exit Sub

            .range(CELL_FAMILY_CODES_REQUEST_CONTROL).Formula = util.composeLink(server, STR_REQ_FAMILY_CODES, util.IDENTIFIER_ZERO, util.STR_EMPTY) ' subscription control
            If util.cleanOnError(.range(CELL_FAMILY_CODES_REQUEST_CONTROL)) Then
                Exit Sub
            End If

        End If
    End With
End Sub


' ========================================================
' Subscribes to account updates multi when button is pressed
' ========================================================
Sub subscribeAccountUpdatesMulti()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        requestAccountUpdatesMulti
    End If
End Sub

' ========================================================
' Re-subscribes to account updates multi when workbook is opened
' ========================================================
Sub resubscribeAccountUpdatesMulti()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_CANCELLED Then ' re-subscribe only if cancelled
        requestAccountUpdatesMulti
    End If
End Sub

' ========================================================
' Sends account updates multi request
' ========================================================
Sub requestAccountUpdatesMulti()
    clearAccountUpdatesMultiTable

    Dim server As String
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub
    
    ' get id
    Dim id As String, account As String, modelCode As String, ledgerAndNLV As String
    id = util.getIDpost(genId, util.ID_REQ_ACCOUNT_UPDATES_MULTI)
    With Worksheets(STR_SHEET_NAME)
        .range(CELL_ID).value = id
        account = .range(CELL_ACCOUNT).value
        modelCode = .range(CELL_MODEL_CODE).value
        ledgerAndNLV = .range(CELL_LEDGER_AND_NLV).value
        
        .range(CELL_SUBSCRIPTION_CONTROL).Formula = util.composeLink(server, STR_REQ_ACCOUNT_UPDATES_MULTI, id, account & util.UNDERSCORE & modelCode & util.UNDERSCORE & ledgerAndNLV) ' subscription control
        If util.cleanOnError(.range(CELL_SUBSCRIPTION_CONTROL)) Then
            .range(CELL_ID).value = util.STR_EMPTY
            Exit Sub
        End If
        
        .range(CELL_ACCOUNT_UPDATE_TIME).Formula = util.composeLink(server, STR_REQ_ACCOUNT_UPDATE_TIME, util.IDENTIFIER_ZERO, util.STR_EMPTY)
    End With
End Sub

' ========================================================
' Clear family codes table
' ========================================================
Sub clearFamilyCodesTable()
    ' clear family codes table
    Worksheets(STR_SHEET_NAME).range(FAMILY_CODES_TABLE_RANGE).ClearContents
End Sub

' ========================================================
' Clear account updates multi table
' ========================================================
Sub clearAccountUpdatesMultiTable()
    ' clear account updates table
    Worksheets(STR_SHEET_NAME).range(ACCOUNT_UPDATES_TABLE_RANGE).ClearContents
    Worksheets(STR_SHEET_NAME).range(CELL_ACCOUNT_UPDATE_TIME).value = util.STR_EMPTY
End Sub

' ========================================================
' Cancel account updates multi subscription when button is pressed
' ========================================================
Sub cancelAccountUpdatesMultiSubscription()
    cancelAccountUpdatesMulti (util.STR_EMPTY)
End Sub

' ========================================================
' Cancel account updates multi subscription when workbook is closed
' ========================================================
Sub cancelAccountUpdatesMultiSubscriptionOnExit()
    cancelAccountUpdatesMulti (util.STR_CANCELLED)
End Sub

' ========================================================
' Sends cancel account updates multi request
' ========================================================
Sub cancelAccountUpdatesMulti(controlValue As String)
    With Worksheets(STR_SHEET_NAME)
        If .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Or .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_ERROR_UPPER Then
            Dim id As String
            id = .range(CELL_ID).value
    
            If .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Then
                Dim server As String
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub
                
                util.sendRequest server, STR_CANCEL_ACCOUNT_UPDATES_MULTI, id
            End If
            
            .range(CELL_SUBSCRIPTION_CONTROL).value = controlValue ' subscription control
            .range(CELL_ID).value = util.STR_EMPTY
            .range(CELL_ERROR).value = util.STR_EMPTY
    
        End If
    End With
End Sub

' ========================================================
' Requests account updates multi table/array
' Called when value in CELL_SUBSCRIPTION_CONTROL changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String
    Dim dimension As Integer
    Dim i As Integer
    
    With Worksheets(STR_SHEET_NAME)
    
        ' request FA
        If CStr(.range(CELL_REQ_FA_CONTROL).value) = util.STR_RECEIVED Then
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            
            Dim faArray() As Variant
            ' send request and FA table/array
            faArray = util.sendRequest(server, STR_REQ_FA, util.IDENTIFIER_ZERO) ' returned array can be 1-Dimension or 2-Dimension
            For i = 1 To UBound(faArray) - LBound(faArray) + 1
                .Cells(FA_START_ROW + i - 1, COLUMN_FA).value = faArray(i, 1)
            Next i
        End If
        
        ' request FA error
        If CStr(.range(CELL_REQ_FA_CONTROL).value) = util.STR_ERROR_UPPER And CStr(.range(CELL_REQ_FA_ERROR).value) = util.STR_EMPTY Then
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            .range(CELL_REQ_FA_ERROR).Formula = util.composeLink(server, STR_REQ_FA_ERROR, util.IDENTIFIER_ZERO, util.STR_EMPTY)
        End If

        ' replace FA error
        If CStr(.range(CELL_REPLACE_FA_CONTROL).value) = util.STR_ERROR_UPPER And CStr(.range(CELL_REPLACE_FA_ERROR).value) = util.STR_EMPTY Then
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            .range(CELL_REPLACE_FA_ERROR).Formula = util.composeLink(server, STR_REPLACE_FA_ERROR, util.IDENTIFIER_ZERO, util.STR_EMPTY)
        End If

        ' managed accounts
        If CStr(.range(CELL_MANAGED_ACCOUNTS).value) = util.STR_LONGVALUE Then
            ' request long values
            ' some values lengths are longer than 255 symbols, DDE cannot send/receive such values, so we have to split long values into chunks and then merge them
            ' here we request array with splitted long value and then merge and display in cell
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            
            Dim managedAccountsArray() As Variant
            ' send request and receive managed accounts table/array
            managedAccountsArray = util.sendRequest(server, STR_REQ_MANAGED_ACCOUNTS, util.IDENTIFIER_ZERO) ' returned array can be 1-Dimension or 2-Dimension
            .range(CELL_MANAGED_ACCOUNTS).value = util.createLongValue(managedAccountsArray)
        End If
    
        ' family codes
        If CStr(.range(CELL_FAMILY_CODES_REQUEST_CONTROL).value) = util.STR_RECEIVED Then
            Dim familyCodesArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub

            ' send request and receive family codes table/array
            familyCodesArray = util.sendRequest(server, STR_REQ_FAMILY_CODES, util.IDENTIFIER_ZERO) ' returned array can be 1-Dimension or 2-Dimension

            dimension = util.getDimension(familyCodesArray)
            If dimension = 2 Then
                ' several family codes received (2d array)
                For i = 1 To UBound(familyCodesArray, 1) - LBound(familyCodesArray, 1) + 1
                    .Cells(ACCOUNT_UPDATES_START_ROW + i - 1, COLUMN_ACCOUNT_ID).value = familyCodesArray(i, 1)
                    .Cells(ACCOUNT_UPDATES_START_ROW + i - 1, COLUMN_ACCOUNT_ID + 1).value = familyCodesArray(i, 2)
                Next i
            ElseIf dimension = 1 Then
                ' single family code received (1d array)
                .Cells(ACCOUNT_UPDATES_START_ROW, COLUMN_ACCOUNT_ID).value = familyCodesArray(1)
                .Cells(ACCOUNT_UPDATES_START_ROW, COLUMN_ACCOUNT_ID + 1).value = familyCodesArray(2)
            End If
        End If
    
        ' account updates error
        If CStr(.range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_ERROR_UPPER And CStr(.range(CELL_ERROR).value) = util.STR_EMPTY Then
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            id = .range(CELL_ID).value
            .range(CELL_ERROR).Formula = util.composeLink(server, STR_REQ_ACCOUNT_UPDATES_MULTI_ERROR, id, util.STR_EMPTY)
        End If
        
        ' account updates
        If CStr(.range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_RECEIVED Then
            Dim accountUpdatesMultiArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            
            id = .range(CELL_ID).value
    
            Dim account As String, modelCode As String, ledgerAndNLV As String
            account = .range(CELL_ACCOUNT).value
            modelCode = .range(CELL_MODEL_CODE).value
            ledgerAndNLV = .range(CELL_LEDGER_AND_NLV).value
    
            ' send request and receive account updates multi table/array
            accountUpdatesMultiArray = util.sendRequest(server, STR_REQ_ACCOUNT_UPDATES_MULTI, id & util.QMARK & account & util.UNDERSCORE & modelCode & util.UNDERSCORE & ledgerAndNLV) ' returned array can be 1-Dimension or 2-Dimension
    
            Dim rowNumber As Integer
            Dim key As String, curr As String
            dimension = util.getDimension(accountUpdatesMultiArray)
            If dimension = 2 Then
                ' several account updates multi received (2d array)
                For i = 1 To UBound(accountUpdatesMultiArray, 1) - LBound(accountUpdatesMultiArray, 1) + 1
                    account = accountUpdatesMultiArray(i, 1)
                    modelCode = accountUpdatesMultiArray(i, 2)
                    key = accountUpdatesMultiArray(i, 3)
                    curr = accountUpdatesMultiArray(i, 5)
                    rowNumber = findAccountUpdateRow(account, modelCode, key, curr)
                    If rowNumber >= ACCOUNT_UPDATES_START_ROW And rowNumber <= ACCOUNT_UPDATES_END_ROW Then
                        
                        If CStr(.Cells(rowNumber, COLUMN_ACCOUNT_UPDATE).value) <> CStr(accountUpdatesMultiArray(i, 1)) Then
                            .Cells(rowNumber, COLUMN_ACCOUNT_UPDATE).value = accountUpdatesMultiArray(i, 1)
                        End If
                        If CStr(.Cells(rowNumber, COLUMN_MODEL_CODE_UPDATE).value) <> CStr(accountUpdatesMultiArray(i, 2)) Then
                            .Cells(rowNumber, COLUMN_MODEL_CODE_UPDATE).value = accountUpdatesMultiArray(i, 2)
                        End If
                        If CStr(.Cells(rowNumber, COLUMN_KEY_UPDATE).value) <> CStr(accountUpdatesMultiArray(i, 3)) Then
                            .Cells(rowNumber, COLUMN_KEY_UPDATE).value = accountUpdatesMultiArray(i, 3)
                        End If
                        If CStr(.Cells(rowNumber, COLUMN_VALUE_UPDATE).value) <> CStr(accountUpdatesMultiArray(i, 4)) Then
                            .Cells(rowNumber, COLUMN_VALUE_UPDATE).value = accountUpdatesMultiArray(i, 4)
                        End If
                        If CStr(.Cells(rowNumber, COLUMN_CURRENCY_UPDATE).value) <> CStr(accountUpdatesMultiArray(i, 5)) Then
                            .Cells(rowNumber, COLUMN_CURRENCY_UPDATE).value = accountUpdatesMultiArray(i, 5)
                        End If
                    End If
                Next i
            ElseIf dimension = 1 Then
                ' single account update multi received (1d array)
                account = accountUpdatesMultiArray(1)
                modelCode = accountUpdatesMultiArray(2)
                key = accountUpdatesMultiArray(3)
                curr = accountUpdatesMultiArray(5)
                rowNumber = findAccountUpdateRow(account, modelCode, key, curr)
                If rowNumber >= ACCOUNT_UPDATES_START_ROW And rowNumber <= ACCOUNT_UPDATES_END_ROW Then
                    If CStr(.Cells(rowNumber, COLUMN_ACCOUNT_UPDATE).value) <> CStr(accountUpdatesMultiArray(1)) Then
                        .Cells(rowNumber, COLUMN_ACCOUNT_UPDATE).value = accountUpdatesMultiArray(1)
                    End If
                    If CStr(.Cells(rowNumber, COLUMN_MODEL_CODE_UPDATE).value) <> CStr(accountUpdatesMultiArray(2)) Then
                        .Cells(rowNumber, COLUMN_MODEL_CODE_UPDATE).value = accountUpdatesMultiArray(2)
                    End If
                    If CStr(.Cells(rowNumber, COLUMN_KEY_UPDATE).value) <> CStr(accountUpdatesMultiArray(3)) Then
                        .Cells(rowNumber, COLUMN_KEY_UPDATE).value = accountUpdatesMultiArray(3)
                    End If
                    If CStr(.Cells(rowNumber, COLUMN_VALUE_UPDATE).value) <> CStr(accountUpdatesMultiArray(4)) Then
                        .Cells(rowNumber, COLUMN_VALUE_UPDATE).value = accountUpdatesMultiArray(4)
                    End If
                    If CStr(.Cells(rowNumber, COLUMN_CURRENCY_UPDATE).value) <> CStr(accountUpdatesMultiArray(5)) Then
                        .Cells(rowNumber, COLUMN_CURRENCY_UPDATE).value = accountUpdatesMultiArray(5)
                    End If
                
                End If
            End If
    
        End If
    End With
End Sub

Private Function findAccountUpdateRow(account As String, modelCode As String, key As String, curr As String) As Integer
    Dim row As Integer, i As Integer
    Dim arr1 As Variant, arr2 As Variant, arr3 As Variant, arr4 As Variant
    With Worksheets(STR_SHEET_NAME)
        arr1 = .range(.Cells(ACCOUNT_UPDATES_START_ROW, COLUMN_ACCOUNT_UPDATE), .Cells(ACCOUNT_UPDATES_END_ROW, COLUMN_ACCOUNT_UPDATE)).value
        arr2 = .range(.Cells(ACCOUNT_UPDATES_START_ROW, COLUMN_MODEL_CODE_UPDATE), .Cells(ACCOUNT_UPDATES_END_ROW, COLUMN_MODEL_CODE_UPDATE)).value
        arr3 = .range(.Cells(ACCOUNT_UPDATES_START_ROW, COLUMN_KEY_UPDATE), .Cells(ACCOUNT_UPDATES_END_ROW, COLUMN_KEY_UPDATE)).value
        arr4 = .range(.Cells(ACCOUNT_UPDATES_START_ROW, COLUMN_CURRENCY_UPDATE), .Cells(ACCOUNT_UPDATES_END_ROW, COLUMN_CURRENCY_UPDATE)).value
        For i = 1 To ACCOUNT_UPDATES_END_ROW - ACCOUNT_UPDATES_START_ROW + 1
            If CStr(arr1(i, 1)) = util.STR_EMPTY And CStr(arr2(i, 1)) = util.STR_EMPTY And CStr(arr3(i, 1)) = util.STR_EMPTY And CStr(arr4(i, 1)) = util.STR_EMPTY Or _
                CStr(arr1(i, 1)) = account And CStr(arr2(i, 1)) = modelCode And CStr(arr3(i, 1)) = key And CStr(arr4(i, 1)) = curr Then
                row = i + ACCOUNT_UPDATES_START_ROW - 1
                GoTo FindAccountUpdateRowEnd
            End If
        Next i
    End With
FindAccountUpdateRowEnd:
    findAccountUpdateRow = row
End Function



