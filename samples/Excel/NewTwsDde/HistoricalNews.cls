VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "HistoricalNews"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' constants
Const STR_SHEET_NAME = "HistoricalNews"
Const STR_REQ_NEWS_PROVIDERS = "reqNewsProviders"
Const STR_REQ_HISTORICAL_NEWS = "reqHistoricalNews"
Const STR_CANCEL_HISTORICAL_NEWS = "cancelHistoricalNews"
Const STR_HISTORICAL_NEWS_TICK = "historicalNewsTick"
Const STR_REQ_NEWS_BULLETINS = "reqNewsBulletins"
Const STR_CANCEL_NEWS_BULLETRINS = "cancelNewsBulletins"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name
Const CELL_NEWS_PROVIDERS_REQUEST_CONTROL = "A9" ' cell with news providers request
Const CELL_NEWS_BULLETINS_SUBSCRIPTION_CONTROL = "O9" ' cell with news bulletins subscription control
Const CELL_NEWS_BULLETINS_ALL_MESSAGES = "Q5" ' cell with "all messages" parameters for news bulletins request

' rows
Const dataStartRowIndex = 14 ' starting row of data
Const dataEndRowIndex = util.maxRowsToFormat ' ending row of data

' columns
Const newsProviderCodeColumnIndex = 1 ' index of "news provider code" column
Const conIdColumnIndex = 4 ' index of :con id" column
Const sheetNameColumnIndex = 9 ' index of "page name" column
Const activateSheetColumnIndex = 10 ' index of "activate page" column
Const idColumnIndex = 11 ' index of "id" column
Const statusColumnIndex = 12 ' index of "status" column
Const errorColumnIndex = 13 ' index of "error" column
Const newsBulletinsMsgIdColumnIndex = 15 ' index of news bulletins "msg id" column

' range
Const NEWS_PROVIDERS_TABLE_RANGE = "A" & dataStartRowIndex & ":B" & dataEndRowIndex
Const NEWS_BULLETINS_TABLE_RANGE = "O" & dataStartRowIndex & ":R" & dataEndRowIndex

' vars
Dim genId As Long
Dim clearTable As Boolean

' ========================================================
' header columns
' ========================================================
Private Function getHeaderColumns() As Variant()
    getHeaderColumns = Array("Time", "Provider Code", "Article Id", "Headline")
End Function

' ========================================================
' checks that row has request data for historical news request
' ========================================================
Public Function hasRequestData(cell As range) As Boolean
    Dim ret As Boolean
    ret = False

    If cell.row < dataStartRowIndex Then
        ret = False
        GoTo hasRequestDataEnd
    End If
    
    With Worksheets(STR_SHEET_NAME)
        If .Cells(cell.row, conIdColumnIndex).value <> STR_EMPTY Then
            ret = True
        End If
    End With
    
hasRequestDataEnd:
    hasRequestData = ret
End Function

' ========================================================
' Re-subscribes to news bulletins when workbook is opened
' ========================================================
Sub resubscribeNewsBulletins()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_NEWS_BULLETINS_SUBSCRIPTION_CONTROL).value) = util.STR_CANCELLED Then ' re-subscribe only if cancelled
        requestNewsBulletins
    End If
End Sub

' ========================================================
' Subscribes to newsBulletins when button is pressed
' ========================================================
Sub subscribeNewsBulletins()
    If CStr(Worksheets(STR_SHEET_NAME).range(CELL_NEWS_BULLETINS_SUBSCRIPTION_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed
        requestNewsBulletins
    End If
End Sub

' ========================================================
' Cancel news bulletins subscription when button is pressed
' ========================================================
Sub cancelNewsBulletinsSubscription()
    cancelNewsBulletins (util.STR_EMPTY)
End Sub

' ========================================================
' Cancel news bulletins subscription when workbook is closed
' ========================================================
Sub cancelNewsBulletinsSubscriptionOnExit()
    cancelNewsBulletins (util.STR_CANCELLED)
End Sub

' ========================================================
' Cancel news bulletins
' ========================================================
Sub cancelNewsBulletins(controlValue As String)
    With Worksheets(STR_SHEET_NAME)
        If .range(CELL_NEWS_BULLETINS_SUBSCRIPTION_CONTROL).value = util.STR_SUBSCRIBED Or .range(CELL_NEWS_BULLETINS_SUBSCRIPTION_CONTROL).value = util.STR_ERROR_UPPER Then
            Worksheets(STR_SHEET_NAME).range(CELL_NEWS_BULLETINS_SUBSCRIPTION_CONTROL).value = controlValue
        End If
    End With
End Sub

' ========================================================
' Requests news bulletins when button is pressed
' ========================================================
Sub requestNewsBulletins()
    With Worksheets(STR_SHEET_NAME)
        clearNewsBulletinsTable

        Dim server As String
        server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
        If server = util.STR_EMPTY Then Exit Sub
        Dim allMessages As Boolean
        allMessages = .range(CELL_NEWS_BULLETINS_ALL_MESSAGES).value

        .range(CELL_NEWS_BULLETINS_SUBSCRIPTION_CONTROL).Formula = util.composeLink(server, STR_REQ_NEWS_BULLETINS, util.IDENTIFIER_ZERO, allMessages) ' subscription control
        If util.cleanOnError(.range(CELL_NEWS_BULLETINS_SUBSCRIPTION_CONTROL)) Then
            Exit Sub
        End If
    End With
End Sub

' ========================================================
' Clear news bulletins table
' ========================================================
Sub clearNewsBulletinsTable()
    ' clear news bulletins table
    Worksheets(STR_SHEET_NAME).range(NEWS_BULLETINS_TABLE_RANGE).ClearContents
End Sub


' ========================================================
' Cancel news providers when button is pressed
' ========================================================
Sub cancelNewsProviders()
    Worksheets(STR_SHEET_NAME).range(CELL_NEWS_PROVIDERS_REQUEST_CONTROL).value = ""
    clearNewsProvidersTable
End Sub

' ========================================================
' Requests news providers when button is pressed
' ========================================================
Sub requestNewsProviders()
    With Worksheets(STR_SHEET_NAME)
        If CStr(.range(CELL_NEWS_PROVIDERS_REQUEST_CONTROL).value) = util.STR_EMPTY Then ' only if not subscribed

        clearNewsProvidersTable

        Dim server As String
        server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
        If server = util.STR_EMPTY Then Exit Sub

            .range(CELL_NEWS_PROVIDERS_REQUEST_CONTROL).Formula = util.composeLink(server, STR_REQ_NEWS_PROVIDERS, util.IDENTIFIER_ZERO, util.STR_EMPTY) ' subscription control
            If util.cleanOnError(.range(CELL_NEWS_PROVIDERS_REQUEST_CONTROL)) Then
                Exit Sub
            End If

        End If
    End With
End Sub

' ========================================================
' Clear news providers table
' ========================================================
Sub clearNewsProvidersTable()
    ' clear news providers table
    Worksheets(STR_SHEET_NAME).range(NEWS_PROVIDERS_TABLE_RANGE).ClearContents
End Sub


' ========================================================
' request historical news for active row
' ========================================================
Sub requestHistoricalNews()
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub
    If Not hasRequestData(ActiveCell) Then Exit Sub
    
    With Worksheets(STR_SHEET_NAME)
        
        If .Cells(ActiveCell.row, idColumnIndex).value <> STR_EMPTY Then Exit Sub
        
        sendHistoricalNewsRequest server, ActiveCell
        
        .Cells(ActiveCell.row, 4).offset(1, 0).Activate
    End With
    
End Sub

' ========================================================
' sends historical news request for cell
' ========================================================
Sub sendHistoricalNewsRequest(server As String, cell As range)

    If Not hasRequestData(cell) Then Exit Sub

    ' get id
    Dim id As String
    id = util.getIDpost(genId, util.ID_REQ_HISTORICAL_NEWS)
    
    With Worksheets(STR_SHEET_NAME)
    
        .Cells(cell.row, idColumnIndex).value = id
    
        ' range to poke
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(cell.row, conIdColumnIndex), .Cells(cell.row, sheetNameColumnIndex - 1))
    
        ' fill status column with formula
        .Cells(cell.row, statusColumnIndex).Formula = util.composeLink(server, STR_HISTORICAL_NEWS_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(cell.row, statusColumnIndex)) Then
            .Cells(cell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, statusColumnIndex).value = util.STR_EMPTY
            .Cells(cell.row, errorColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If
    
        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_HISTORICAL_NEWS, id, rangeToPoke
    
        ' fill error column with formula
        .Cells(cell.row, errorColumnIndex).Formula = util.composeLink(server, STR_HISTORICAL_NEWS_TICK, id, util.STR_ERROR)
    End With

End Sub

' ========================================================
' sends historical news cancel when button is pressed
' ========================================================
Sub cancelHistoricalNews()
    Dim server As String, id As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = util.STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)
    
        If .Cells(ActiveCell.row, idColumnIndex).value = STR_EMPTY Then Exit Sub
        If Not hasRequestData(ActiveCell) Then Exit Sub
    
        id = .Cells(ActiveCell.row, idColumnIndex).value
        .Cells(ActiveCell.row, idColumnIndex).value = util.STR_EMPTY
    
        ' status column
        .Cells(ActiveCell.row, statusColumnIndex).ClearContents
        ' error column
        .Cells(ActiveCell.row, errorColumnIndex).ClearContents
    
        util.sendRequest server, STR_CANCEL_HISTORICAL_NEWS, id
    
        .Cells(ActiveCell.row, 4).offset(1, 0).Activate
    End With
End Sub

' ========================================================
' Called when value in CELL_SUBSCRIPTION_CONTROL changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim server As String, id As String
    Dim dimension As Integer
    Dim i As Integer, j As Integer

    With Worksheets(STR_SHEET_NAME)

        ' news bulletins
        If CStr(.range(CELL_NEWS_BULLETINS_SUBSCRIPTION_CONTROL).value) = util.STR_RECEIVED Then
            Dim newsBulletinsArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub

            ' send request and receive news providers table/array
            newsBulletinsArray = util.sendRequest(server, STR_REQ_NEWS_BULLETINS, util.IDENTIFIER_ZERO) ' returned array can be 1-Dimension or 2-Dimension

            dimension = util.getDimension(newsBulletinsArray)
            
            Dim rowNumber As Long
            If dimension = 2 Then
                ' several news bulletins received (2d array)
                For i = 1 To UBound(newsBulletinsArray, 1) - LBound(newsBulletinsArray, 1) + 1
                    rowNumber = findNewsBulletinRow()

                    Dim subArray As Variant
                    n = UBound(newsBulletinsArray, 2) - 1
                    ReDim subArray(n)
                    For j = 1 To UBound(newsBulletinsArray, 2) - LBound(newsBulletinsArray, 2) + 1
                        subArray(j - 1) = newsBulletinsArray(i, j)
                    Next j

                    util.updateSheetWithLine Worksheets(STR_SHEET_NAME), subArray, rowNumber - 1 + i, newsBulletinsMsgIdColumnIndex, "@", "General"
                Next i
            ElseIf dimension = 1 Then
                ' single news bulletin received (1d array)
                rowNumber = findNewsBulletinRow()
                util.updateSheetWithLine Worksheets(STR_SHEET_NAME), newsBulletinsArray, rowNumber, newsBulletinsMsgIdColumnIndex, "@", "General"
            End If
        End If
        
        ' news providers
        If CStr(.range(CELL_NEWS_PROVIDERS_REQUEST_CONTROL).value) = util.STR_RECEIVED Then
            Dim newsProvidersArray() As Variant
            server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
            If server = util.STR_EMPTY Then Exit Sub

            ' send request and receive news providers table/array
            newsProvidersArray = util.sendRequest(server, STR_REQ_NEWS_PROVIDERS, util.IDENTIFIER_ZERO) ' returned array can be 1-Dimension or 2-Dimension

            dimension = util.getDimension(newsProvidersArray)
            If dimension = 2 Then
                ' several news providers received (2d array)
                For i = 1 To UBound(newsProvidersArray, 1) - LBound(newsProvidersArray, 1) + 1
                    If newsProvidersArray(i, 1) <> util.STR_EMPTY Then
                        .Cells(dataStartRowIndex + i - 1, newsProviderCodeColumnIndex).value = newsProvidersArray(i, 1)
                    End If
                    If newsProvidersArray(i, 2) <> util.STR_EMPTY Then
                        .Cells(dataStartRowIndex + i - 1, newsProviderCodeColumnIndex + 1).value = newsProvidersArray(i, 2)
                    End If
                Next i
            ElseIf dimension = 1 Then
                ' single news provider received (1d array)
                If newsProvidersArray(1) <> util.STR_EMPTY Then
                    .Cells(dataStartRowIndex, newsProviderCodeColumnIndex).value = newsProvidersArray(1)
                End If
                If newsProvidersArray(2) <> util.STR_EMPTY Then
                    .Cells(dataStartRowIndex, newsProviderCodeColumnIndex + 1).value = newsProvidersArray(2)
                End If
            End If
        End If
        
        ' historical news
        For j = dataStartRowIndex To dataEndRowIndex
            If CStr(.Cells(j, statusColumnIndex).value) = util.STR_REQUESTED Then
                clearTable = True
            End If
            If CStr(.Cells(j, statusColumnIndex).value) = util.STR_RECEIVED Then
                Dim historicalNewsArray() As Variant
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub
    
                id = .Cells(j, idColumnIndex).value
    
                ' send request and receive historical data table/array
                historicalNewsArray = util.sendRequest(server, STR_REQ_HISTORICAL_NEWS, id) ' returned array can be 1-Dimension or 2-Dimension
    
                ' update sheet
                util.updateSheetWithArray _
                    CStr(.Cells(j, sheetNameColumnIndex).value), _
                    historicalNewsArray, _
                    .Cells(j, activateSheetColumnIndex).value, _
                    "Historical News", _
                    getHeaderColumns(), _
                    True, _
                    True, _
                    0, _
                    clearTable
                
                clearTable = False
                
            End If
        Next j

    End With
End Sub

Private Function findNewsBulletinRow() As Integer
    Dim row As Long, i As Long
    Dim arr1 As Variant
    With Worksheets(STR_SHEET_NAME)
        arr1 = .range(.Cells(dataStartRowIndex, newsBulletinsMsgIdColumnIndex), .Cells(dataEndRowIndex, newsBulletinsMsgIdColumnIndex)).value
        For i = 1 To dataEndRowIndex - dataStartRowIndex + 1
            If CStr(arr1(i, 1)) = util.STR_EMPTY Then
                row = i + dataStartRowIndex - 1
                GoTo FindNewsBulletinRowEnd
            End If
        Next i
    End With

FindNewsBulletinRowEnd:
    findNewsBulletinRow = row
End Function



