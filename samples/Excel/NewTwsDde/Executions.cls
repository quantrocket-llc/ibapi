VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Executions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' constants
Const STR_SHEET_NAME = "Executions"
Const STR_REQ_EXECUTIONS = "reqExecutions"
Const STR_CANCEL_EXECUTIONS = "cancelExecutions"
Const STR_REQ_EXECUTIONS_ERROR = "reqExecutionsError"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_SUBSCRIPTION_CONTROL = "I9" ' cell with subscription control
Const CELL_ID = "K9" ' cell with id
Const CELL_ERROR = "L9" ' cell with error

' columns
Const COLUMN_CLIENTID = 1
Const COLUMN_TIME = 3
Const COLUMN_SIDE = 8
Const COLUMN_CONID = 11

' rows
Const PARAMS_ROW = 9
Const EXECUTIONS_START_ROW = 14
Const EXECUTIONS_END_ROW = 500

' range
Const EXECUTIONS_TABLE_RANGE = "A" & EXECUTIONS_START_ROW & ":AH" & EXECUTIONS_END_ROW

' vars
Dim genId As Long

' ========================================================
' Subscribes to executions when button is pressed
' ========================================================
Sub subscribeExecutions()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        requestExecutions
    End If
End Sub

' ========================================================
' Re-subscribes to executions when workbook is opened
' ========================================================
Sub resubscribeExecutions()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_CANCELLED Then ' re-subscribe only if cancelled
        requestExecutions
    End If
End Sub

' ========================================================
' Sends positions request
' ========================================================
Sub requestExecutions()
    clearExecutionsTable

    Dim server As String
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub
    
    ' collect params
    Dim params As String
    params = getParams()

    ' get id
    Dim id As String
    id = util.getIDpost(genId, util.ID_REQ_EXECUTIONS)
    With Worksheets(STR_SHEET_NAME)
        .range(CELL_ID).value = id
    
        .range(CELL_SUBSCRIPTION_CONTROL).Formula = util.composeLink(server, STR_REQ_EXECUTIONS, id, params) ' subscription control
        
        If util.cleanOnError(.range(CELL_SUBSCRIPTION_CONTROL)) Then
            .range(CELL_ID).value = util.STR_EMPTY
        End If
        
    End With
End Sub

Function getParams() As String
    Dim params As String
    Dim param As String
    params = util.STR_EMPTY
    Dim i As Integer
    With Worksheets(STR_SHEET_NAME)
        For i = COLUMN_CLIENTID To COLUMN_SIDE - 1
            param = .Cells(PARAMS_ROW, i).value
            If i = COLUMN_TIME Then
                param = util.trimSymbol(param, util.MINUS_CHAR)
                param = util.trimSymbol(param, util.COLON_CHAR)
                
            End If
            params = params & param
            If i < COLUMN_SIDE - 1 Then
                params = params & util.UNDERSCORE
            End If
        Next i
    End With
    getParams = params
End Function

' ========================================================
' Clear executions table
' ========================================================
Sub clearExecutionsTable()
    ' clear positions table
    Worksheets(STR_SHEET_NAME).range(EXECUTIONS_TABLE_RANGE).ClearContents
End Sub

' ========================================================
' Cancel executions subscription when button is pressed
' ========================================================
Sub cancelExecutionsSubscription()
    cancelExecutions (util.STR_EMPTY)
End Sub

' ========================================================
' Cancel executions subscription when workbook is closed
' ========================================================
Sub cancelExecutionsSubscriptionOnExit()
    cancelExecutions (util.STR_CANCELLED)
End Sub

' ========================================================
' Sends cancel executions request
' ========================================================
Sub cancelExecutions(controlValue As String)
    With Worksheets(STR_SHEET_NAME)
        If .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Or .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_ERROR_UPPER Then
            Dim id As String
            id = .range(CELL_ID).value
    
            If .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Then
                Dim server As String
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub
    
                util.sendRequest server, STR_CANCEL_EXECUTIONS, id
            End If
    
            .range(CELL_SUBSCRIPTION_CONTROL).value = controlValue ' subscription control
            .range(CELL_ID).value = util.STR_EMPTY
            .range(CELL_ERROR).value = util.STR_EMPTY
    
        End If
    End With
End Sub

' ========================================================
' Requests positions table/array
' Called when value in CELL_SUBSCRIPTION_CONTROL changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String

    With Worksheets(STR_SHEET_NAME)
        If CStr(.range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_ERROR_UPPER Then
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            id = .range(CELL_ID).value
            .range(CELL_ERROR).Formula = util.composeLink(server, STR_REQ_EXECUTIONS_ERROR, id, util.STR_EMPTY)
        End If
    
        If CStr(.range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_RECEIVED Then
            Dim executionsArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
    
            id = .range(CELL_ID).value
    
            Dim params As String
            params = getParams()
    
            ' send request and receive executions table/array
            executionsArray = util.sendRequest(server, STR_REQ_EXECUTIONS, id & util.QMARK & params) ' returned array can be 1-Dimension or 2-Dimension
    
            Dim dimension As Integer, i As Integer
            Dim rowNumber As Integer
            dimension = util.getDimension(executionsArray)
            If dimension = 2 Then
                ' several positions received (2d array)
                For i = 1 To UBound(executionsArray, 1) - LBound(executionsArray, 1) + 1
                    rowNumber = findExecutionRow()
                    If rowNumber >= EXECUTIONS_START_ROW And rowNumber <= EXECUTIONS_END_ROW Then
                        For j = 1 To UBound(executionsArray, 2) - LBound(executionsArray, 2) + 1
                            If executionsArray(i, j) <> util.STR_EMPTY Then
                                .Cells(rowNumber, j).value = executionsArray(i, j)
                            End If
                        Next j
                    End If
                Next i
            ElseIf dimension = 1 Then
                ' single position received (1d array)
                rowNumber = findExecutionRow()
                If rowNumber >= EXECUTIONS_START_ROW And rowNumber <= EXECUTIONS_END_ROW Then
                    For i = 1 To UBound(executionsArray) - LBound(executionsArray) + 1
                        If executionsArray(i) <> util.STR_EMPTY Then
                            .Cells(rowNumber, i).value = executionsArray(i)
                        End If
                    Next i
                End If
            End If
    
        End If
    End With
End Sub

Private Function findExecutionRow() As Integer
    Dim row As Integer, i As Integer
    Dim arr1 As Variant
    With Worksheets(STR_SHEET_NAME)
        arr1 = .range(.Cells(EXECUTIONS_START_ROW, COLUMN_CONID), .Cells(EXECUTIONS_END_ROW, COLUMN_CONID)).value
        For i = 1 To EXECUTIONS_END_ROW - EXECUTIONS_START_ROW + 1
            If CStr(arr1(i, 1)) = util.STR_EMPTY Then
                row = i + EXECUTIONS_START_ROW - 1
                GoTo FindExecutionRowEnd
            End If
        Next i
    End With

FindExecutionRowEnd:
    findExecutionRow = row
End Function
