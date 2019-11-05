VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "AccountPortfolio"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim contractColumnsArray() As Variant

' constants
Const STR_SHEET_NAME = "AccountPortfolio"
Const STR_REQ_ACCOUNT_PORTFOLIO = "reqAccountPortfolio"
Const STR_REQ_PORTFOLIO = "reqPortfolio"
Const STR_CANCEL_ACCOUNT_PORTFOLIO = "cancelAccountPortfolio"
Const STR_REQ_ACCOUNT_PORTFOLIO_ERROR = "reqAccountPortfolioError"
Const STR_REQ_ACCOUNT_UPDATE_TIME = "reqAccountUpdateTime"

Const STR_EXERCISE_OPTIONS = "exerciseOptions"
Const STR_EXERCISE_OPTIONS_TICK = "exerciseOptionsTick"
Const STR_EXERCISE_OPTIONS_ORDER_STATUS_TICK = "orderStatus"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_ACCOUNT = "A9" ' cell with account name
Const CELL_SUBSCRIPTION_CONTROL = "D9" ' cell with subscription control
Const CELL_ERROR = "F9" ' cell with error
Const CELL_ACCOUNT_UPDATE_TIME = "H12" ' cell with account update time

' rows
Const ACCOUNT_UPDATES_START_ROW = 14
Const ACCOUNT_UPDATES_END_ROW = 500

' columns
Const COLUMN_ACCOUNT_ACCOUNT = 1
Const COLUMN_ACCOUNT_KEY = 3
Const COLUMN_ACCOUNT_VALUE = 6
Const COLUMN_ACCOUNT_CURRENCY = 8
Const COLUMN_PORTFOLIO_SYMBOL = 10
Const COLUMN_PORTFOLIO_REALIZED_PNL = 27
Const COLUMN_PORTFOLIO_CONID = 20
Const COLUMN_PORTFOLIO_ACCOUNT = 21
Const EXERCISE_OPTIONS_ACTION = 28
Const EXERCISE_OPTIONS_ID = 31
Const EXERCISE_OPTIONS_STATUS = 32
Const EXERCISE_OPTIONS_ORDER_STATUS = 33
Const EXERCISE_OPTIONS_ERROR = 34

' range
Const ACCOUNT_UPDATES_TABLE_RANGE = "A" & ACCOUNT_UPDATES_START_ROW & ":H" & ACCOUNT_UPDATES_END_ROW
Const PORTFOLIO_TABLE_RANGE = "J" & ACCOUNT_UPDATES_START_ROW & ":AA" & ACCOUNT_UPDATES_END_ROW

' vars
Dim genId As Long

' ========================================================
' contract columns
' ========================================================
Private Function getContractColumns() As Variant()

    If (Not Not contractColumnsArray) <> 0 Then
        ' do not re-initialize array
        GoTo getContractColumnsEnd
    End If

    contractColumnsArray = Array("SYMBOL", "SECTYPE", "LASTTRADEDATE", "STRIKE", "RIGHT", "MULTIPLIER", "TRADINGCLASS", "PRIMEXCH", "CURRENCY", "LOCALSYMBOL", "CONID")
    
getContractColumnsEnd:
    getContractColumns = contractColumnsArray
End Function

' ========================================================
' clear exercise options when workbook is closed
' ========================================================
Sub clearExerciseOptionsOnExit()
    Dim rng As range, row As range, cell As range
    With Worksheets(STR_SHEET_NAME)
        Set rng = .range(.Cells(ACCOUNT_UPDATES_START_ROW, EXERCISE_OPTIONS_ID), .Cells(ACCOUNT_UPDATES_END_ROW, EXERCISE_OPTIONS_ID))
        For Each row In rng.rows
            For Each cell In row.Cells
            If InStr(cell.value, util.IDENTIFIER_PREFIX) <> 0 Then
                clearExerciseOptionsForRow cell
            End If
          Next cell
        Next row
    End With
End Sub

' ========================================================
' clear exercise options
' ========================================================
Sub clearExerciseOptions()
    clearExerciseOptionsForRow ActiveCell
End Sub

' ========================================================
' clear exercise options for row
' ========================================================
Sub clearExerciseOptionsForRow(row As range)
    With Worksheets(STR_SHEET_NAME)
        .Cells(row.row, EXERCISE_OPTIONS_ID).value = util.STR_EMPTY
        .Cells(row.row, EXERCISE_OPTIONS_STATUS).value = util.STR_EMPTY
        .Cells(row.row, EXERCISE_OPTIONS_ORDER_STATUS).value = util.STR_EMPTY
        .Cells(row.row, EXERCISE_OPTIONS_ERROR).value = util.STR_EMPTY
        .Cells(row.row, 1).offset(1, 0).Activate
    End With
End Sub

' ========================================================
' exercise options
' ========================================================
Sub exerciseOptions()
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
        If .Cells(ActiveCell.row, EXERCISE_OPTIONS_ID).value <> STR_EMPTY Then Exit Sub
        If Not util.hasContractData(Worksheets(STR_SHEET_NAME), ACCOUNT_UPDATES_START_ROW, ActiveCell, COLUMN_PORTFOLIO_SYMBOL, getContractColumns()) Then Exit Sub

        ' get id
        Dim id As String
        id = util.getIDpost(genId, util.ID_EXERCISE_OPTIONS)
        .Cells(ActiveCell.row, EXERCISE_OPTIONS_ID).value = id

        ' fill status column with formula
        .Cells(ActiveCell.row, EXERCISE_OPTIONS_STATUS).Formula = util.composeLink(server, STR_EXERCISE_OPTIONS_TICK, id, util.STR_STATUS)

        If util.cleanOnError(.Cells(ActiveCell.row, EXERCISE_OPTIONS_STATUS)) Then
            .Cells(ActiveCell.row, EXERCISE_OPTIONS_ID).value = util.STR_EMPTY
            .Cells(ActiveCell.row, EXERCISE_OPTIONS_ORDER_STATUS).value = util.STR_EMPTY
            .Cells(ActiveCell.row, EXERCISE_OPTIONS_STATUS).value = util.STR_EMPTY
            .Cells(ActiveCell.row, EXERCISE_OPTIONS_ERROR).value = util.STR_EMPTY
            Exit Sub
        End If

        Dim action As String, quantity As String, override As String, account As String
        action = .Cells(ActiveCell.row, EXERCISE_OPTIONS_ACTION).value
        quantity = .Cells(ActiveCell.row, EXERCISE_OPTIONS_ACTION + 1).value
        override = .Cells(ActiveCell.row, EXERCISE_OPTIONS_ACTION + 2).value
        account = .Cells(ActiveCell.row, COLUMN_PORTFOLIO_ACCOUNT).value

        ' range to poke
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(ActiveCell.row, COLUMN_PORTFOLIO_SYMBOL), .Cells(ActiveCell.row, COLUMN_PORTFOLIO_SYMBOL + 10))

        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_EXERCISE_OPTIONS, id & util.QMARK & account & util.UNDERSCORE & action & util.UNDERSCORE & quantity & util.UNDERSCORE & override, rangeToPoke

        ' fill order status column with formula
        .Cells(ActiveCell.row, EXERCISE_OPTIONS_ORDER_STATUS).Formula = util.composeLink(server, STR_EXERCISE_OPTIONS_TICK, id, STR_EXERCISE_OPTIONS_ORDER_STATUS_TICK)

        ' fill error column with formula
        .Cells(ActiveCell.row, EXERCISE_OPTIONS_ERROR).Formula = util.composeLink(server, STR_EXERCISE_OPTIONS_TICK, id, util.STR_ERROR)

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' Subscribes to account + portfolio updates when button is pressed
' ========================================================
Sub subscribeAccountPortfolio()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        requestAccountPortfolio
    End If
End Sub
'
' ========================================================
' Re-subscribes to account + portfolio updates when workbook is opened
' ========================================================
Sub resubscribeAccountPortfolio()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_CANCELLED Then ' re-subscribe only if cancelled
        requestAccountPortfolio
    End If
End Sub

' ========================================================
' Sends account portfolio request
' ========================================================
Sub requestAccountPortfolio()
    clearAccountPortfolioTable

    Dim server As String
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    Dim account As String
    With Worksheets(STR_SHEET_NAME)
        account = .range(CELL_ACCOUNT).value
    
        .range(CELL_SUBSCRIPTION_CONTROL).Formula = util.composeLink(server, STR_REQ_ACCOUNT_PORTFOLIO, util.IDENTIFIER_ZERO, account) ' subscription control
        If util.cleanOnError(.range(CELL_SUBSCRIPTION_CONTROL)) Then
            Exit Sub
        End If
        
        .range(CELL_ACCOUNT_UPDATE_TIME).Formula = util.composeLink(server, STR_REQ_ACCOUNT_UPDATE_TIME, util.IDENTIFIER_ZERO, util.STR_EMPTY)
    End With
End Sub

' ========================================================
' Clear account portfolio table
' ========================================================
Sub clearAccountPortfolioTable()
    ' clear account portfolio table
    With Worksheets(STR_SHEET_NAME)
        .range(ACCOUNT_UPDATES_TABLE_RANGE).ClearContents
        .range(PORTFOLIO_TABLE_RANGE).ClearContents
        .range(CELL_ACCOUNT_UPDATE_TIME).value = util.STR_EMPTY
    End With
End Sub

' ========================================================
' Cancel account + portfolio updates subscription when button is pressed
' ========================================================
Sub cancelAccountPortfolioSubscription()
    cancelAccountPortfolio (util.STR_EMPTY)
End Sub

' ========================================================
' Cancel account + portfolio updates multi subscription when workbook is closed
' ========================================================
Sub cancelAccountPortfolioSubscriptionOnExit()
    cancelAccountPortfolio (util.STR_CANCELLED)
End Sub

' ========================================================
' Sends cancel account updates multi request
' ========================================================
Sub cancelAccountPortfolio(controlValue As String)
    With Worksheets(STR_SHEET_NAME)
        If .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Or .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_ERROR_UPPER Then
            If .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Then
                Dim server As String
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub
    
                util.sendRequest server, STR_CANCEL_ACCOUNT_PORTFOLIO, util.IDENTIFIER_ZERO
            End If
    
            .range(CELL_SUBSCRIPTION_CONTROL).value = controlValue ' subscription control
            .range(CELL_ERROR).value = util.STR_EMPTY
        End If
    End With
End Sub

' ========================================================
' Requests account + portfolio updates table/array
' Called when value in CELL_SUBSCRIPTION_CONTROL changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String
    
    With Worksheets(STR_SHEET_NAME)
        
        If CStr(.range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_ERROR_UPPER Then
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            .range(CELL_ERROR).Formula = util.composeLink(server, STR_REQ_ACCOUNT_PORTFOLIO_ERROR, util.IDENTIFIER_ZERO, util.STR_EMPTY)
        End If
    
        If CStr(.range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_RECEIVED Then
            Dim accountUpdatesArray() As Variant
            Dim portfolioArray() As Variant
            
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
    
            Dim account As String
            account = .range(CELL_ACCOUNT).value
    
            ' send request and receive account updates table/array
            accountUpdatesArray = util.sendRequest(server, STR_REQ_ACCOUNT_PORTFOLIO, util.IDENTIFIER_ZERO & util.QMARK & account) ' returned array can be 1-Dimension or 2-Dimension
            portfolioArray = util.sendRequest(server, STR_REQ_PORTFOLIO, util.IDENTIFIER_ZERO & util.QMARK & account) ' returned array can be 1-Dimension or 2-Dimension
    
            Dim dimension As Integer, i As Integer
            Dim rowNumber As Integer
            Dim key As String, curr As String
            dimension = util.getDimension(accountUpdatesArray)
            If dimension = 2 Then
                ' several account updates received (2d array)
                For i = 1 To UBound(accountUpdatesArray, 1) - LBound(accountUpdatesArray, 1) + 1
                    account = accountUpdatesArray(i, 1)
                    key = accountUpdatesArray(i, 2)
                    curr = accountUpdatesArray(i, 4)
                    rowNumber = findAccountUpdateRow(account, key, curr)
                    If rowNumber >= ACCOUNT_UPDATES_START_ROW And rowNumber <= ACCOUNT_UPDATES_END_ROW Then
                        If .Cells(rowNumber, COLUMN_ACCOUNT_ACCOUNT).value <> accountUpdatesArray(i, 1) Then
                            .Cells(rowNumber, COLUMN_ACCOUNT_ACCOUNT).value = accountUpdatesArray(i, 1)
                        End If
                        If .Cells(rowNumber, COLUMN_ACCOUNT_KEY).value <> accountUpdatesArray(i, 2) Then
                            .Cells(rowNumber, COLUMN_ACCOUNT_KEY).value = accountUpdatesArray(i, 2)
                        End If
                        If .Cells(rowNumber, COLUMN_ACCOUNT_VALUE).value <> accountUpdatesArray(i, 3) Then
                            .Cells(rowNumber, COLUMN_ACCOUNT_VALUE).value = accountUpdatesArray(i, 3)
                        End If
                        If .Cells(rowNumber, COLUMN_ACCOUNT_CURRENCY).value <> accountUpdatesArray(i, 4) Then
                            .Cells(rowNumber, COLUMN_ACCOUNT_CURRENCY).value = accountUpdatesArray(i, 4)
                        End If
                    End If
                Next i
            ElseIf dimension = 1 Then
                ' single account update received (1d array)
                account = accountUpdatesArray(1)
                key = accountUpdatesArray(2)
                curr = accountUpdatesArray(4)
                rowNumber = findAccountUpdateRow(account, key, curr)
                If rowNumber >= ACCOUNT_UPDATES_START_ROW And rowNumber <= ACCOUNT_UPDATES_END_ROW Then
                    If .Cells(rowNumber, COLUMN_ACCOUNT_ACCOUNT).value <> accountUpdatesArray(1) Then
                        .Cells(rowNumber, COLUMN_ACCOUNT_ACCOUNT).value = accountUpdatesArray(1)
                    End If
                    If .Cells(rowNumber, COLUMN_ACCOUNT_KEY).value <> accountUpdatesArray(2) Then
                        .Cells(rowNumber, COLUMN_ACCOUNT_KEY).value = accountUpdatesArray(2)
                    End If
                    If .Cells(rowNumber, COLUMN_ACCOUNT_VALUE).value <> accountUpdatesArray(3) Then
                        .Cells(rowNumber, COLUMN_ACCOUNT_VALUE).value = accountUpdatesArray(3)
                    End If
                    If .Cells(rowNumber, COLUMN_ACCOUNT_CURRENCY).value <> accountUpdatesArray(4) Then
                        .Cells(rowNumber, COLUMN_ACCOUNT_CURRENCY).value = accountUpdatesArray(4)
                    End If
                End If
            End If
    
            Dim conid As String
            Dim j As Integer
            dimension = util.getDimension(portfolioArray)
            If dimension = 2 Then
                ' several portfolio updates received (2d array)
                For i = 1 To UBound(portfolioArray, 1) - LBound(portfolioArray, 1) + 1
                    conid = portfolioArray(i, 11)
                    account = portfolioArray(i, 12)
                    rowNumber = FindPortfolioRow(conid, account)
                    If rowNumber >= ACCOUNT_UPDATES_START_ROW And rowNumber <= ACCOUNT_UPDATES_END_ROW Then
                        For j = COLUMN_PORTFOLIO_SYMBOL To COLUMN_PORTFOLIO_REALIZED_PNL
                            If .Cells(rowNumber, j).value <> portfolioArray(i, j - COLUMN_PORTFOLIO_SYMBOL + 1) Then
                                .Cells(rowNumber, j).value = portfolioArray(i, j - COLUMN_PORTFOLIO_SYMBOL + 1)
                            End If
                        Next j
                    End If
                Next i
            ElseIf dimension = 1 Then
                ' single portfolio update received (1d array)
                conid = portfolioArray(11)
                account = portfolioArray(12)
                rowNumber = FindPortfolioRow(conid, account)
                If rowNumber >= ACCOUNT_UPDATES_START_ROW And rowNumber <= ACCOUNT_UPDATES_END_ROW Then
                    For j = COLUMN_PORTFOLIO_SYMBOL To COLUMN_PORTFOLIO_REALIZED_PNL
                        If .Cells(rowNumber, j).value <> portfolioArray(j - COLUMN_PORTFOLIO_SYMBOL + 1) Then
                            .Cells(rowNumber, j).value = portfolioArray(j - COLUMN_PORTFOLIO_SYMBOL + 1)
                        End If
                    Next j
                End If
            End If
        End If
    End With
End Sub

Private Function findAccountUpdateRow(account As String, key As String, curr As String) As Integer
    Dim row As Integer, i As Integer
    Dim arr1 As Variant, arr2 As Variant, arr3 As Variant
    With Worksheets(STR_SHEET_NAME)
        arr1 = .range(.Cells(ACCOUNT_UPDATES_START_ROW, COLUMN_ACCOUNT_ACCOUNT), .Cells(ACCOUNT_UPDATES_END_ROW, COLUMN_ACCOUNT_ACCOUNT)).value
        arr2 = .range(.Cells(ACCOUNT_UPDATES_START_ROW, COLUMN_ACCOUNT_KEY), .Cells(ACCOUNT_UPDATES_END_ROW, COLUMN_ACCOUNT_KEY)).value
        arr3 = .range(.Cells(ACCOUNT_UPDATES_START_ROW, COLUMN_ACCOUNT_CURRENCY), .Cells(ACCOUNT_UPDATES_END_ROW, COLUMN_ACCOUNT_CURRENCY)).value
        For i = 1 To ACCOUNT_UPDATES_END_ROW - ACCOUNT_UPDATES_START_ROW + 1
            If CStr(arr1(i, 1)) = util.STR_EMPTY And CStr(arr2(i, 1)) = util.STR_EMPTY And CStr(arr3(i, 1)) = util.STR_EMPTY Or _
                CStr(arr1(i, 1)) = account And CStr(arr2(i, 1)) = key And CStr(arr3(i, 1)) = curr Then
                row = i + ACCOUNT_UPDATES_START_ROW - 1
                GoTo FindAccountUpdateRowEnd
            End If
        Next i
    End With
FindAccountUpdateRowEnd:
    findAccountUpdateRow = row
End Function

Private Function FindPortfolioRow(conid As String, account As String) As Integer
    Dim row As Integer, i As Integer
    Dim arr1 As Variant, arr2 As Variant
    With Worksheets(STR_SHEET_NAME)
        arr1 = .range(.Cells(ACCOUNT_UPDATES_START_ROW, COLUMN_PORTFOLIO_CONID), .Cells(ACCOUNT_UPDATES_END_ROW, COLUMN_PORTFOLIO_CONID)).value
        arr2 = .range(.Cells(ACCOUNT_UPDATES_START_ROW, COLUMN_PORTFOLIO_ACCOUNT), .Cells(ACCOUNT_UPDATES_END_ROW, COLUMN_PORTFOLIO_ACCOUNT)).value
        For i = 1 To ACCOUNT_UPDATES_END_ROW - ACCOUNT_UPDATES_START_ROW + 1
            If CStr(arr1(i, 1)) = util.STR_EMPTY And CStr(arr2(i, 1)) = util.STR_EMPTY Or _
                CStr(arr1(i, 1)) = conid And CStr(arr2(i, 1)) = account Then
                row = i + ACCOUNT_UPDATES_START_ROW - 1
                GoTo FindPortfolioRowEnd
            End If
        Next i
    End With
FindPortfolioRowEnd:
    FindPortfolioRow = row
End Function





