VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "PositionsMulti"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' constants
Const STR_SHEET_NAME = "PositionsMulti"
Const STR_REQ_POSITIONS_MULTI = "reqPositionsMulti"
Const STR_CANCEL_POSITIONS_MULTI = "cancelPositionsMulti"
Const STR_REQ_POSITIONS_MULTI_ERROR = "reqPositionsMultiError"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_ACCOUNT = "A9" ' cell with account name
Const CELL_MODEL_CODE = "B9" ' cell with model name
Const CELL_SUBSCRIPTION_CONTROL = "D9" ' cell with subscription control
Const CELL_ID = "F9" ' cell with id
Const CELL_ERROR = "G9" ' cell with error

' rows
Const POSITIONS_START_ROW = 14
Const POSITIONS_END_ROW = 500

' columns
Const COLUMN_CONID = 11
Const COLUMN_ACCOUNT = 12
Const COLUMN_MODEL_CODE = 13

' range
Const POSITIONS_TABLE_RANGE = "A" & POSITIONS_START_ROW & ":O" & POSITIONS_END_ROW

' vars
Dim genId As Long

'
' ========================================================
' Subscribes to positions multi when button is pressed
' ========================================================
Sub subscribePositionsMulti()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        requestPositionsMulti
    End If
End Sub

' ========================================================
' Re-subscribes to positions multi when workbook is opened
' ========================================================
Sub resubscribePositionsMulti()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_CANCELLED Then ' re-subscribe only if cancelled
        requestPositionsMulti
    End If
End Sub

' ========================================================
' Sends positions multi request
' ========================================================
Sub requestPositionsMulti()
    clearPositionsMultiTable

    Dim server As String
    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub
    
    ' get id
    Dim id As String, account As String, model As String
    id = util.getIDpost(genId, util.ID_REQ_POSITIONS_MULTI)
    With Worksheets(STR_SHEET_NAME)
        .range(CELL_ID).value = id
        account = .range(CELL_ACCOUNT).value
        model = .range(CELL_MODEL_CODE).value
        
        .range(CELL_SUBSCRIPTION_CONTROL).Formula = util.composeLink(server, STR_REQ_POSITIONS_MULTI, id, account & util.UNDERSCORE & model) ' subscription control
        If util.cleanOnError(.range(CELL_SUBSCRIPTION_CONTROL)) Then
            .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_EMPTY
            .range(CELL_ID).value = util.STR_EMPTY
        End If
    End With
End Sub
'
' ========================================================
' Clear positions multi table
' ========================================================
Sub clearPositionsMultiTable()
    ' clear positions table
    Worksheets(STR_SHEET_NAME).range(POSITIONS_TABLE_RANGE).ClearContents
End Sub

' ========================================================
' Cancel positions multi subscription when button is pressed
' ========================================================
Sub cancelPositionsMultiSubscription()
    cancelPositionsMulti (util.STR_EMPTY)
End Sub

' ========================================================
' Cancel positions multi subscription when workbook is closed
' ========================================================
Sub cancelPositionsMultiSubscriptionOnExit()
    cancelPositionsMulti (util.STR_CANCELLED)
End Sub

' ========================================================
' Sends cancel positions multi request
' ========================================================
Sub cancelPositionsMulti(controlValue As String)
    With Worksheets(STR_SHEET_NAME)
        If .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Or .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_ERROR_UPPER Then
            Dim id As String
            id = .range(CELL_ID).value
    
            If .range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Then
                Dim server As String
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub
                
                util.sendRequest server, STR_CANCEL_POSITIONS_MULTI, id
            End If
            
            .range(CELL_SUBSCRIPTION_CONTROL).value = controlValue ' subscription control
            .range(CELL_ID).value = util.STR_EMPTY
            .range(CELL_ERROR).value = util.STR_EMPTY
    
        End If
    End With
End Sub

' ========================================================
' Requests positions multi table/array
' Called when value in CELL_SUBSCRIPTION_CONTROL changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String
    
    With Worksheets(STR_SHEET_NAME)
    
        If CStr(.range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_ERROR_UPPER And CStr(.range(CELL_ERROR).value) = util.STR_EMPTY Then
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            id = .range(CELL_ID).value
            .range(CELL_ERROR).Formula = util.composeLink(server, STR_REQ_POSITIONS_MULTI_ERROR, id, util.STR_EMPTY)
        End If
        
        If CStr(.range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_RECEIVED Then
            Dim positionsMultiArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            
            id = .range(CELL_ID).value
    
            Dim account As String, modelCode As String
            account = .range(CELL_ACCOUNT).value
            modelCode = .range(CELL_MODEL_CODE).value
    
            ' send request and receive positions multi table/array
            positionsMultiArray = util.sendRequest(server, STR_REQ_POSITIONS_MULTI, id & util.QMARK & account & util.UNDERSCORE & modelCode) ' returned array can be 1-Dimension or 2-Dimension
    
            Dim dimension As Integer, i As Integer
            Dim rowNumber As Integer
            Dim conid As String
            dimension = util.getDimension(positionsMultiArray)
            If dimension = 2 Then
                ' several positions received (2d array)
                For i = 1 To UBound(positionsMultiArray, 1) - LBound(positionsMultiArray, 1) + 1
                    conid = positionsMultiArray(i, COLUMN_CONID)
                    account = positionsMultiArray(i, COLUMN_ACCOUNT)
                    modelCode = positionsMultiArray(i, COLUMN_MODEL_CODE)
                    rowNumber = findPositionRow(conid, account, modelCode)
                    If rowNumber >= POSITIONS_START_ROW And rowNumber <= POSITIONS_END_ROW Then
                        For j = 1 To UBound(positionsMultiArray, 2) - LBound(positionsMultiArray, 2) + 1
                            If positionsMultiArray(i, j) <> util.STR_EMPTY Then
                                .Cells(rowNumber, j).value = positionsMultiArray(i, j)
                            End If
                        Next j
                    End If
                Next i
            ElseIf dimension = 1 Then
                ' single position received (1d array)
                conid = positionsMultiArray(COLUMN_CONID)
                account = positionsMultiArray(COLUMN_ACCOUNT)
                modelCode = positionsMultiArray(COLUMN_MODEL_CODE)
                rowNumber = findPositionRow(conid, account, modelCode)
                If rowNumber >= POSITIONS_START_ROW And rowNumber <= POSITIONS_END_ROW Then
                    For i = 1 To UBound(positionsMultiArray) - LBound(positionsMultiArray) + 1
                        If positionsMultiArray(i) <> util.STR_EMPTY Then
                            .Cells(rowNumber, i).value = positionsMultiArray(i)
                        End If
                    Next i
                End If
            End If
    
        End If
    End With
End Sub

Private Function findPositionRow(conid As String, account As String, modelCode As String) As Integer
    Dim row As Integer, i As Integer
    Dim arr1 As Variant, arr2 As Variant, arr3 As Variant
    With Worksheets(STR_SHEET_NAME)
        arr1 = .range(.Cells(POSITIONS_START_ROW, COLUMN_CONID), .Cells(POSITIONS_END_ROW, COLUMN_CONID)).value
        arr2 = .range(.Cells(POSITIONS_START_ROW, COLUMN_ACCOUNT), .Cells(POSITIONS_END_ROW, COLUMN_ACCOUNT)).value
        arr3 = .range(.Cells(POSITIONS_START_ROW, COLUMN_MODEL_CODE), .Cells(POSITIONS_END_ROW, COLUMN_MODEL_CODE)).value
        
        For i = 1 To POSITIONS_END_ROW - POSITIONS_START_ROW + 1
            If CStr(arr1(i, 1)) = util.STR_EMPTY And CStr(arr2(i, 1)) = util.STR_EMPTY And CStr(arr3(i, 1)) = util.STR_EMPTY Or _
                CStr(arr1(i, 1)) = conid And CStr(arr2(i, 1)) = account And CStr(arr3(i, 1)) = modelCode Then
                row = i + POSITIONS_START_ROW - 1
                GoTo FindPositionEnd
            End If
        Next i
    End With

FindPositionEnd:
    findPositionRow = row
End Function

