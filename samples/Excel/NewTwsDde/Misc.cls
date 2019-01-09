VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Misc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' constants
Const STR_SHEET_NAME = "Misc"
Const STR_REQ_SMART_COMPONENTS = "reqSmartComponents"
Const STR_REQ_SMART_COMPONENTS_ERROR = "reqSmartComponentsError"
Const STR_REQ_SOFT_DOLLAR_TIERS = "reqSoftDollarTiers"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_SMART_COMPONENTS_BBO_EXCHANGE = "A9" ' cell with smart components BBO exchange
Const CELL_SMART_COMPONENTS_REQUEST_CONTROL = "B9" ' cell with smart components subscription control
Const CELL_SMART_COMPONENTS_ID = "C9" ' cell with smart components request id
Const CELL_SMART_COMPONENTS_ERROR = "D9" ' cell with smart components request error

Const CELL_SOFT_DOLLAR_TIERS_REQUEST_CONTROL = "F9" ' cell with soft dollar tiers request control

' rows
Const SMART_COMPONENTS_START_ROW = 14
Const SMART_COMPONENTS_END_ROW = 200

' columns
Const COLUMN_SMART_COMPONENTS_BIT_NUMBER = 1
Const COLUMN_SMART_COMPONENTS_EXCHANGE = 2
Const COLUMN_SMART_COMPONENTS_EXCHANGE_LETTER = 4
Const SOFT_DOLLAR_TIERS_NAME = 6
Const SOFT_DOLLAR_TIERS_VALUE = 7
Const SOFT_DOLLAR_TIERS_DISPLAY_NAME = 8

' range
Const SMART_COMPONENTS_TABLE_RANGE = "A" & SMART_COMPONENTS_START_ROW & ":D" & SMART_COMPONENTS_END_ROW
Const SOFT_DOLLAR_TIERS_TABLE_RANGE = "F" & SMART_COMPONENTS_START_ROW & ":H" & SMART_COMPONENTS_END_ROW

' vars
Dim genId As Long

' ========================================================
' Request soft dollar tiers when button is pressed
' ========================================================
Sub requestSoftDollarTiers()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SOFT_DOLLAR_TIERS_REQUEST_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        clearSoftDollarTiersTable

        Dim server As String
        server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
        If server = util.STR_EMPTY Then Exit Sub

        ' get id
        With Worksheets(STR_SHEET_NAME)
            .range(CELL_SOFT_DOLLAR_TIERS_REQUEST_CONTROL).Formula = util.composeLink(server, STR_REQ_SOFT_DOLLAR_TIERS, util.IDENTIFIER_ZERO, util.STR_EMPTY) ' subscription control
            If util.cleanOnError(.range(CELL_SOFT_DOLLAR_TIERS_REQUEST_CONTROL)) Then
                clearSoftDollarTiersTable
                Exit Sub
            End If
        End With
    End If
End Sub

' ========================================================
' Cancel soft dollar tiers when button is pressed
' ========================================================
Sub cancelSoftDollarTiers()
    clearSoftDollarTiersTable
End Sub

' ========================================================
' Clear soft dollar tiers table
' ========================================================
Sub clearSoftDollarTiersTable()
    ' clear soft dollar tiers table
    With Worksheets(STR_SHEET_NAME)
        .range(SOFT_DOLLAR_TIERS_TABLE_RANGE).ClearContents
        .range(CELL_SOFT_DOLLAR_TIERS_REQUEST_CONTROL).value = util.STR_EMPTY
    End With
End Sub

' ========================================================
' Request smart components when button is pressed
' ========================================================
Sub requestSmartComponents()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_SMART_COMPONENTS_REQUEST_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        clearSmartComponentsTable

        Dim server As String
        server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
        If server = util.STR_EMPTY Then Exit Sub

        ' get id
        Dim id As String, bboExchange As String
        id = util.getIDpost(genId, util.ID_REQ_SMART_COMPONENTS)
        With Worksheets(STR_SHEET_NAME)
            .range(CELL_SMART_COMPONENTS_ID).value = id
            bboExchange = .range(CELL_SMART_COMPONENTS_BBO_EXCHANGE).value

            .range(CELL_SMART_COMPONENTS_REQUEST_CONTROL).Formula = util.composeLink(server, STR_REQ_SMART_COMPONENTS, id, bboExchange) ' subscription control
            If util.cleanOnError(.range(CELL_SMART_COMPONENTS_REQUEST_CONTROL)) Then
                clearSmartComponentsTable
                Exit Sub
            End If
        End With
    End If
End Sub

' ========================================================
' Clear smart components table
' ========================================================
Sub clearSmartComponentsTable()
    ' clear smart components table
    With Worksheets(STR_SHEET_NAME)
        .range(SMART_COMPONENTS_TABLE_RANGE).ClearContents
        .range(CELL_SMART_COMPONENTS_REQUEST_CONTROL).value = util.STR_EMPTY
        .range(CELL_SMART_COMPONENTS_ID).value = util.STR_EMPTY
        .range(CELL_SMART_COMPONENTS_ERROR).value = util.STR_EMPTY
    End With
End Sub


' ========================================================
' Cancel smart components when button is pressed
' ========================================================
Sub cancelSmartComponents()
    clearSmartComponentsTable
End Sub

' ========================================================
' Requests smart components table/array
' Requests soft dollar tiers table/array
' Called when value in CELL_SMART_COMPONENTS_REQUEST_CONTROL or
' CELL_SOFT_DOLLAR_TIERS_REQUEST_CONTROL changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String
    Dim dimension As Integer
    Dim i As Integer

    With Worksheets(STR_SHEET_NAME)

        ' error
        If CStr(.range(CELL_SMART_COMPONENTS_REQUEST_CONTROL).value) = util.STR_ERROR_UPPER And CStr(.range(CELL_SMART_COMPONENTS_ERROR).value) = util.STR_EMPTY Then
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub
            id = .range(CELL_SMART_COMPONENTS_ID).value
            .range(CELL_SMART_COMPONENTS_ERROR).Formula = util.composeLink(server, STR_REQ_SMART_COMPONENTS_ERROR, id, util.STR_EMPTY)
        End If

        ' smart components
        If CStr(.range(CELL_SMART_COMPONENTS_REQUEST_CONTROL).value) = util.STR_RECEIVED Then
            Dim smartComponentsArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub

            id = .range(CELL_SMART_COMPONENTS_ID).value
            
            Dim bboExchange As String
            bboExchange = .range(CELL_SMART_COMPONENTS_BBO_EXCHANGE).value

            ' send request and receive smart components table/array
            smartComponentsArray = util.sendRequest(server, STR_REQ_SMART_COMPONENTS, id & util.QMARK & bboExchange) ' returned array can be 1-Dimension or 2-Dimension

            dimension = util.getDimension(smartComponentsArray)
            If dimension = 2 Then
                ' several smart components received (2d array)
                For i = 1 To UBound(smartComponentsArray, 1) - LBound(smartComponentsArray, 1) + 1
                    .Cells(SMART_COMPONENTS_START_ROW + i - 1, COLUMN_SMART_COMPONENTS_BIT_NUMBER).value = smartComponentsArray(i, 1)
                    .Cells(SMART_COMPONENTS_START_ROW + i - 1, COLUMN_SMART_COMPONENTS_EXCHANGE).value = smartComponentsArray(i, 2)
                    .Cells(SMART_COMPONENTS_START_ROW + i - 1, COLUMN_SMART_COMPONENTS_EXCHANGE_LETTER).value = smartComponentsArray(i, 3)
                Next i
            ElseIf dimension = 1 Then
                ' single smart component received (1d array)
                .Cells(SMART_COMPONENTS_START_ROW, COLUMN_SMART_COMPONENTS_BIT_NUMBER).value = smartComponentsArray(1)
                .Cells(SMART_COMPONENTS_START_ROW, COLUMN_SMART_COMPONENTS_EXCHANGE).value = smartComponentsArray(2)
                .Cells(SMART_COMPONENTS_START_ROW, COLUMN_SMART_COMPONENTS_EXCHANGE_LETTER).value = smartComponentsArray(3)
            End If

        End If
        
        ' soft dollar tiers
        If CStr(.range(CELL_SOFT_DOLLAR_TIERS_REQUEST_CONTROL).value) = util.STR_RECEIVED Then
            Dim softDollarTiersArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub

            ' send request and receive smart components table/array
            softDollarTiersArray = util.sendRequest(server, STR_REQ_SOFT_DOLLAR_TIERS, util.IDENTIFIER_ZERO) ' returned array can be 1-Dimension or 2-Dimension

            dimension = util.getDimension(softDollarTiersArray)
            If dimension = 2 Then
                ' several soft dollar tiers received (2d array)
                For i = 1 To UBound(softDollarTiersArray, 1) - LBound(softDollarTiersArray, 1) + 1
                    .Cells(SMART_COMPONENTS_START_ROW + i - 1, SOFT_DOLLAR_TIERS_NAME).value = softDollarTiersArray(i, 1)
                    .Cells(SMART_COMPONENTS_START_ROW + i - 1, SOFT_DOLLAR_TIERS_VALUE).value = softDollarTiersArray(i, 2)
                    .Cells(SMART_COMPONENTS_START_ROW + i - 1, SOFT_DOLLAR_TIERS_DISPLAY_NAME).value = softDollarTiersArray(i, 3)
                Next i
            ElseIf dimension = 1 Then
                ' single soft dollar tier received (1d array)
                 .Cells(SMART_COMPONENTS_START_ROW, SOFT_DOLLAR_TIERS_NAME).value = softDollarTiersArray(1)
                 .Cells(SMART_COMPONENTS_START_ROW, SOFT_DOLLAR_TIERS_VALUE).value = softDollarTiersArray(2)
                 .Cells(SMART_COMPONENTS_START_ROW, SOFT_DOLLAR_TIERS_DISPLAY_NAME).value = softDollarTiersArray(3)
            End If
        End If
    End With
End Sub
