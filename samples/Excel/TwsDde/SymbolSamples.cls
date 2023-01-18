VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SymbolSamples"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' constants
Const STR_SHEET_NAME = "SymbolSamples"
Const STR_REQ_MATCHING_SYMBOLS = "reqMatchingSymbols"
Const STR_CANCEL_MATCHING_SYMBOLS = "cancelMatchingSymbols"
Const STR_REQ_MATCHING_SYMBOLS_ERROR = "reqMatchingSymbolsError"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_PATTERN = "A9" ' cell with pattern
Const CELL_SUBSCRIPTION_CONTROL = "E9" ' cell with subscription control
Const CELL_ID = "G9" ' cell with id
Const CELL_ERROR = "H9" ' cell with error

' rows
Const SYMBOL_SAMPLES_START_ROW = 14
Const SYMBOL_SAMPLES_END_ROW = 200

' columns
Const COLUMN_CONID = 1
Const COLUMN_SYMBOL = 3
Const COLUMN_SECTYPE = 4
Const COLUMN_PRIMARY_EXCHANGE = 5
Const COLUMN_CURRENCY = 7
Const COLUMN_DERIVATIVE_SECTYPES = 8
Const COLUMN_DESCRIPTION = 12
Const COLUMN_ISSUERID = 18

' range
Const SYMBOL_SAMPLES_TABLE_RANGE = "A" & SYMBOL_SAMPLES_START_ROW & ":S" & SYMBOL_SAMPLES_END_ROW

' vars
Dim genId As Long

' ========================================================
' Requests matching symbols when button is pressed
' ========================================================
Sub requestMatchingSymbols()
    If CStr(Worksheets(STR_SHEET_NAME).Range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        clearSymbolSamplesTable

        Dim server As String
        server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
        If server = util.STR_EMPTY Then Exit Sub

        ' get id
        Dim id As String, pattern As String
        id = util.getIDpost(genId, util.ID_REQ_MATCHING_SYMBOLS)
        With Worksheets(STR_SHEET_NAME)
            .Range(CELL_ID).value = id
            pattern = CStr(.Range(CELL_PATTERN).value)

            .Range(CELL_SUBSCRIPTION_CONTROL).Formula = util.composeLink(server, STR_REQ_MATCHING_SYMBOLS, id, pattern) ' subscription control
            If util.cleanOnError(.Range(CELL_SUBSCRIPTION_CONTROL)) Then
                .Range(CELL_ID).value = util.STR_EMPTY
                Exit Sub
            End If
        End With
    End If
End Sub

' ========================================================
' Clear symbol samples table
' ========================================================
Sub clearSymbolSamplesTable()
    ' clear symbol samples
    Worksheets(STR_SHEET_NAME).Range(SYMBOL_SAMPLES_TABLE_RANGE).ClearContents
End Sub

' ========================================================
' Cancels symbol samples
' ========================================================
Sub cancelSymbolSamples()
    With Worksheets(STR_SHEET_NAME)
        If .Range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_FINISHED Or .Range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_ERROR_UPPER Then
            Dim id As String
            id = .Range(CELL_ID).value

            If .Range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Then
                Dim server As String
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub

                util.sendRequest server, STR_CANCEL_MATCHING_SYMBOLS, id
            End If

            .Range(CELL_SUBSCRIPTION_CONTROL).value = util.STR_EMPTY ' subscription control
            .Range(CELL_ID).value = util.STR_EMPTY
            .Range(CELL_ERROR).value = util.STR_EMPTY

        End If
    End With
End Sub

' ========================================================
' Requests symbol samples table/array
' Called when value in CELL_SUBSCRIPTION_CONTROL changes
' ========================================================
Private Sub Worksheet_Calculate()
    If Not util.sheetExists(STR_SHEET_NAME) Then Exit Sub

    Dim server As String, id As String
    Dim dimension As Integer
    Dim i As Integer
    
    With Worksheets(STR_SHEET_NAME)
    
        ' error
        If CStr(.Range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_ERROR_UPPER And CStr(.Range(CELL_ERROR).value) = util.STR_EMPTY Then
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            id = .Range(CELL_ID).value
            .Range(CELL_ERROR).Formula = util.composeLink(server, STR_REQ_MATCHING_SYMBOLS_ERROR, id, util.STR_EMPTY)
        End If

        ' symbol samples
        If CStr(.Range(CELL_SUBSCRIPTION_CONTROL).value) = util.STR_RECEIVED Then
            Dim symbolSamplesArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub

            id = .Range(CELL_ID).value

            Dim pattern As String
            pattern = .Range(CELL_PATTERN).value

            ' send request and receive symbol samples table/array
            symbolSamplesArray = util.sendRequest(server, STR_REQ_MATCHING_SYMBOLS, id & util.QMARK & pattern) ' returned array can be 1-Dimension or 2-Dimension

            dimension = util.getDimension(symbolSamplesArray)
            If dimension = 2 Then
                ' several symbol samples received (2d array)
                For i = 1 To UBound(symbolSamplesArray, 1) - LBound(symbolSamplesArray, 1) + 1
                    .Cells(SYMBOL_SAMPLES_START_ROW + i - 1, COLUMN_CONID).value = symbolSamplesArray(i, 1)
                    .Cells(SYMBOL_SAMPLES_START_ROW + i - 1, COLUMN_SYMBOL).value = symbolSamplesArray(i, 2)
                    .Cells(SYMBOL_SAMPLES_START_ROW + i - 1, COLUMN_SECTYPE).value = symbolSamplesArray(i, 3)
                    .Cells(SYMBOL_SAMPLES_START_ROW + i - 1, COLUMN_PRIMARY_EXCHANGE).value = symbolSamplesArray(i, 4)
                    .Cells(SYMBOL_SAMPLES_START_ROW + i - 1, COLUMN_CURRENCY).value = symbolSamplesArray(i, 5)
                    .Cells(SYMBOL_SAMPLES_START_ROW + i - 1, COLUMN_DERIVATIVE_SECTYPES).value = symbolSamplesArray(i, 6)
                    .Cells(SYMBOL_SAMPLES_START_ROW + i - 1, COLUMN_DESCRIPTION).value = symbolSamplesArray(i, 7)
                    .Cells(SYMBOL_SAMPLES_START_ROW + i - 1, COLUMN_ISSUERID).value = symbolSamplesArray(i, 8)
                Next i
            ElseIf dimension = 1 Then
                .Cells(SYMBOL_SAMPLES_START_ROW, COLUMN_CONID).value = symbolSamplesArray(1)
                .Cells(SYMBOL_SAMPLES_START_ROW, COLUMN_SYMBOL).value = symbolSamplesArray(2)
                .Cells(SYMBOL_SAMPLES_START_ROW, COLUMN_SECTYPE).value = symbolSamplesArray(3)
                .Cells(SYMBOL_SAMPLES_START_ROW, COLUMN_PRIMARY_EXCHANGE).value = symbolSamplesArray(4)
                .Cells(SYMBOL_SAMPLES_START_ROW, COLUMN_CURRENCY).value = symbolSamplesArray(5)
                .Cells(SYMBOL_SAMPLES_START_ROW, COLUMN_DERIVATIVE_SECTYPES).value = symbolSamplesArray(6)
                .Cells(SYMBOL_SAMPLES_START_ROW, COLUMN_DESCRIPTION).value = symbolSamplesArray(7)
                .Cells(SYMBOL_SAMPLES_START_ROW, COLUMN_ISSUERID).value = symbolSamplesArray(8)
            End If
        End If
    End With
End Sub

