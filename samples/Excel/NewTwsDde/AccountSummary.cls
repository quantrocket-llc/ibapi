VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "AccountSummary"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' constants
Const STR_SHEET_NAME = "AccountSummary"
Const STR_REQ_ACCOUNT_SUMMARY = "reqAccountSummary"
Const STR_CANCEL_ACCOUNT_SUMMARY = "cancelAccountSummary"
Const STR_REQ_ACCOUNT_SUMMARY_ERROR = "reqAccountSummaryError"
Const STR_GROUP_ALL = "All"
Const STR_SUMMARY = "summary"


' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_GROUP = "A10" ' cell with group name
Const CELL_TAGS = "B10" ' cell with tags
Const CELL_SUBSCRIPTION_CONTROL = "E6" ' cell with subscription control
Const CELL_ID = "G6" ' cell with id
Const CELL_ERROR = "H6" ' cell with error

' rows
Const ACCOUNT_SUMMARY_START_ROW = 15
Const ACCOUNT_SUMMARY_END_ROW = 501

' columns
Const COLUMN_SUMMARY_ACCOUNT = 1
Const COLUMN_SUMMARY_KEY = 3
Const COLUMN_SUMMARY_VALUE = 7
Const COLUMN_SUMMARY_CURRENCY = 13

' range
Const ACCOUNT_SUMMARY_TABLE_RANGE = "A" & ACCOUNT_SUMMARY_START_ROW & ":N" & ACCOUNT_SUMMARY_END_ROW

' vars
Dim genId As Long

' ========================================================
' Subscribes to account summary when button is pressed
' ========================================================
Sub subscribeAccountSummary()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        requestAccountSummary
    End If
End Sub

' ========================================================
' Re-subscribes to account summary when workbook is opened
' ========================================================
Sub resubscribeAccountSummary()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_CANCELLED Then ' re-subscribe only if cancelled
        requestAccountSummary
    End If
End Sub

' ========================================================
' Sends account summary request
' ========================================================
Sub requestAccountSummary()
    clearAccountSummaryTable

    Dim server As String
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    ' get id
    Dim id As String, group As String
    id = util.getIDpost(genId, util.ID_REQ_ACCOUNT_SUMMARY)
    With Worksheets(STR_SHEET_NAME)
        .range(CELL_ID).value = id
        group = .range(CELL_GROUP).value
        
        Dim rangeToPoke As range
        Set rangeToPoke = getRangeToPoke()
    
        .range(CELL_SUBSCRIPTION_CONTROL).Formula = util.composeLink(server, STR_REQ_ACCOUNT_SUMMARY, id, util.STR_EMPTY) ' subscription control
        If util.cleanOnError(.range(CELL_SUBSCRIPTION_CONTROL)) Then
            .range(CELL_ID).value = util.STR_EMPTY
            Exit Sub
        End If
        
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_ACCOUNT_SUMMARY, id, rangeToPoke
        
        rangeToPoke.ClearContents
    End With
End Sub

' ========================================================
' Clear account summary table
' ========================================================
Sub clearAccountSummaryTable()
    ' clear account summary table
    Worksheets(STR_SHEET_NAME).range(ACCOUNT_SUMMARY_TABLE_RANGE).ClearContents
End Sub

' ========================================================
' Method creates range to send with DDEPoke method
' ========================================================
Function getRangeToPoke() As range
    Dim tagsArray() As String
    With Worksheets(STR_SHEET_NAME)
        tagsArray = splitString(.range(CELL_TAGS).value, util.COMMA_CHAR)
        .Cells(10, 50).value = .range(CELL_GROUP).value ' group
        For i = 0 To UBound(tagsArray)
            .Cells(10, i + 51).value = tagsArray(i) ' tag
        Next i
        Set getRangeToPoke = .range(.Cells(10, 50), .Cells(10, 51 + i))
    End With
End Function

' ========================================================
' Method splits string
' ========================================================
Function splitString(STR As String, delimiter As String) As String()
    STR = Replace(STR, util.STR_SPACE, util.STR_EMPTY) ' remove spaces
    splitString = split(STR, delimiter) ' split by delimiter
End Function

' ========================================================
' Cancel account summary subscription when button is pressed
' ========================================================
Sub cancelAccountSummarySubscription()
    cancelAccountSummary (util.STR_EMPTY)
End Sub

' ========================================================
' Cancel account summary subscription when workbook is closed
' ========================================================
Sub cancelAccountSummarySubscriptionOnExit()
    cancelAccountSummary (util.STR_CANCELLED)
End Sub

' ========================================================
' Sends cancel account summary request
' ========================================================
Sub cancelAccountSummary(controlValue As String)
    With Worksheets(STR_SHEET_NAME)
        If .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Or .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_ERROR_UPPER Then
            Dim id As String
            id = .range(CELL_ID).value
    
            If .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Then
                Dim server As String
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub
    
                util.sendRequest server, STR_CANCEL_ACCOUNT_SUMMARY, id
            End If
    
            .range(CELL_SUBSCRIPTION_CONTROL).value = controlValue ' subscription control
            .range(CELL_ID).value = util.STR_EMPTY
            .range(CELL_ERROR).value = util.STR_EMPTY
    
        End If
    End With
End Sub

' ========================================================
' Requests account summary table/array
' Called when value in CELL_SUBSCRIPTION_CONTROL changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String

    With Worksheets(STR_SHEET_NAME)
        If CStr(.range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_ERROR_UPPER Then
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            id = .range(CELL_ID).value
            .range(CELL_ERROR).Formula = util.composeLink(server, STR_REQ_ACCOUNT_SUMMARY_ERROR, id, util.STR_EMPTY)
        End If
    
        If CStr(.range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_RECEIVED Then
            Dim accountSummaryArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
    
            id = .range(CELL_ID).value
    
            Dim group As String
            group = .range(CELL_GROUP).value
    
            ' send request and receive account summary table/array
            accountSummaryArray = util.sendRequest(server, STR_REQ_ACCOUNT_SUMMARY, id & util.QMARK) ' returned array can be 1-Dimension or 2-Dimension
    
            Dim dimension As Integer, i As Integer
            Dim rowNumber As Integer
            Dim account As String, key As String, curr As String
            dimension = util.getDimension(accountSummaryArray)
            If dimension = 2 Then
                ' several account summaries received (2d array)
                For i = 1 To UBound(accountSummaryArray, 1) - LBound(accountSummaryArray, 1) + 1
                    account = accountSummaryArray(i, 1)
                    key = accountSummaryArray(i, 2)
                    curr = accountSummaryArray(i, 4)
                    rowNumber = findAccountSummaryRow(account, key, curr)
                    If rowNumber >= ACCOUNT_SUMMARY_START_ROW And rowNumber <= ACCOUNT_SUMMARY_END_ROW Then
                        If .Cells(rowNumber, COLUMN_SUMMARY_ACCOUNT).value <> accountSummaryArray(i, 1) Then
                            .Cells(rowNumber, COLUMN_SUMMARY_ACCOUNT).value = accountSummaryArray(i, 1)
                        End If
                        If .Cells(rowNumber, COLUMN_SUMMARY_KEY).value <> accountSummaryArray(i, 2) Then
                            .Cells(rowNumber, COLUMN_SUMMARY_KEY).value = accountSummaryArray(i, 2)
                        End If
                        If .Cells(rowNumber, COLUMN_SUMMARY_VALUE).value <> accountSummaryArray(i, 3) Then
                            .Cells(rowNumber, COLUMN_SUMMARY_VALUE).value = accountSummaryArray(i, 3)
                        End If
                        If .Cells(rowNumber, COLUMN_SUMMARY_CURRENCY).value <> accountSummaryArray(i, 4) Then
                            .Cells(rowNumber, COLUMN_SUMMARY_CURRENCY).value = accountSummaryArray(i, 4)
                        End If
                    End If
                Next i
            ElseIf dimension = 1 Then
                ' single account summary received (1d array)
                account = accountSummaryArray(1)
                key = accountSummaryArray(2)
                curr = accountSummaryArray(4)
                rowNumber = findAccountSummaryRow(account, key, curr)
                If rowNumber >= ACCOUNT_SUMMARY_START_ROW And rowNumber <= ACCOUNT_SUMMARY_END_ROW Then
                    If .Cells(rowNumber, COLUMN_SUMMARY_ACCOUNT).value <> accountSummaryArray(1) Then
                        .Cells(rowNumber, COLUMN_SUMMARY_ACCOUNT).value = accountSummaryArray(1)
                    End If
                    If .Cells(rowNumber, COLUMN_SUMMARY_KEY).value <> accountSummaryArray(2) Then
                        .Cells(rowNumber, COLUMN_SUMMARY_KEY).value = accountSummaryArray(2)
                    End If
                    If .Cells(rowNumber, COLUMN_SUMMARY_VALUE).value <> accountSummaryArray(3) Then
                        .Cells(rowNumber, COLUMN_SUMMARY_VALUE).value = accountSummaryArray(3)
                    End If
                    If .Cells(rowNumber, COLUMN_SUMMARY_CURRENCY).value <> accountSummaryArray(4) Then
                        .Cells(rowNumber, COLUMN_SUMMARY_CURRENCY).value = accountSummaryArray(4)
                    End If
                End If
            End If
    
        End If
    End With
End Sub


Private Function findAccountSummaryRow(account As String, key As String, curr As String) As Integer
    Dim row As Integer, i As Integer
    Dim arr1 As Variant, arr2 As Variant, arr3 As Variant
    With Worksheets(STR_SHEET_NAME)
        arr1 = .range(.Cells(ACCOUNT_SUMMARY_START_ROW, COLUMN_SUMMARY_ACCOUNT), .Cells(ACCOUNT_SUMMARY_END_ROW, COLUMN_SUMMARY_ACCOUNT)).value
        arr2 = .range(.Cells(ACCOUNT_SUMMARY_START_ROW, COLUMN_SUMMARY_KEY), .Cells(ACCOUNT_SUMMARY_END_ROW, COLUMN_SUMMARY_KEY)).value
        arr3 = .range(.Cells(ACCOUNT_SUMMARY_START_ROW, COLUMN_SUMMARY_CURRENCY), .Cells(ACCOUNT_SUMMARY_END_ROW, COLUMN_SUMMARY_CURRENCY)).value
        For i = 1 To ACCOUNT_SUMMARY_END_ROW - ACCOUNT_SUMMARY_START_ROW + 1
            If CStr(arr1(i, 1)) = util.STR_EMPTY And CStr(arr2(i, 1)) = util.STR_EMPTY And CStr(arr3(i, 1)) = util.STR_EMPTY Or _
                CStr(arr1(i, 1)) = account And CStr(arr2(i, 1)) = key And CStr(arr3(i, 1)) = curr Then
                row = i + ACCOUNT_SUMMARY_START_ROW - 1
                GoTo FindAccountSummaryRowEnd
            End If
        Next i
    End With
FindAccountSummaryRowEnd:
    findAccountSummaryRow = row
End Function

