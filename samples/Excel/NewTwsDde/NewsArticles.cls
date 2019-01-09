VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "NewsArticles"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Long

' constants
Const STR_SHEET_NAME = "NewsArticles"
Const STR_REQ_NEWS_ARTICLE = "reqNewsArticle"
Const STR_CANCEL_NEWS_ARTICLE = "cancelNewsArticle"
Const STR_NEWS_ARTICLE_TICK = "newsArticleTick"
Const STR_NEWS_ARTICLE = "newsArticle"
Const STR_REQ_NEWS_ARTICLE_LONG_VALUE = "reqNewsArticleLongValue"

' cells
Const CELL_SERVER_NAME = "B5" ' cell with server name

' columns
Const startOfRequestColumns = 1 ' contract first column index (provider code)
Const idColumnIndex = 4 ' index of "id" column
Const statusColumnIndex = 5 ' index of "status" column
Const errorColumnIndex = 6 ' index of "error" column
Const newsArticleColumnIndex = 7 ' index of "news article" column

' rows
Const dataStartRowIndex = 10 ' starting row of data
Const dataEndRowIndex = util.maxRowsToFormat ' ending row of data

' ========================================================
' checks that row has request data for news article request
' ========================================================
Public Function hasRequestData(cell As range) As Boolean
    Dim ret As Boolean
    ret = False

    If cell.row < dataStartRowIndex Then
        ret = False
        GoTo hasRequestDataEnd
    End If
    
    With Worksheets(STR_SHEET_NAME)
        If .Cells(cell.row, startOfRequestColumns).value <> STR_EMPTY And .Cells(cell.row, startOfRequestColumns + 1).value <> STR_EMPTY Then
            ret = True
        End If
    End With
    
hasRequestDataEnd:
    hasRequestData = ret
End Function

' ========================================================
' cancels news article
' ========================================================
Sub cancelNewsArticle()
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
        ' news article column
        .Cells(ActiveCell.row, newsArticleColumnIndex).ClearContents

        util.sendRequest server, STR_CANCEL_NEWS_ARTICLE, id

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With

End Sub

' ========================================================
' request news article
' ========================================================
Sub requestNewsArticle()
    Dim server As String

    server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
    If server = STR_EMPTY Then Exit Sub

    With Worksheets(STR_SHEET_NAME)

        If .Cells(ActiveCell.row, idColumnIndex).value <> STR_EMPTY Then Exit Sub
        If Not hasRequestData(ActiveCell) Then Exit Sub

        ' get id
        Dim id As String
        id = util.getIDpost(genId, util.ID_REQ_NEWS_ARTICLE)
        .Cells(ActiveCell.row, idColumnIndex).value = id

        ' range to poke
        Dim rangeToPoke As range
        Set rangeToPoke = .range(.Cells(ActiveCell.row, startOfRequestColumns), .Cells(ActiveCell.row, idColumnIndex - 1))

        ' fill status column with formula
        .Cells(ActiveCell.row, statusColumnIndex).Formula = util.composeLink(server, STR_NEWS_ARTICLE_TICK, id, util.STR_STATUS)
        If util.cleanOnError(.Cells(ActiveCell.row, statusColumnIndex)) Then
            .Cells(ActiveCell.row, idColumnIndex).value = util.STR_EMPTY
            .Cells(ActiveCell.row, statusColumnIndex).value = util.STR_EMPTY
            .Cells(ActiveCell.row, errorColumnIndex).value = util.STR_EMPTY
            Exit Sub
        End If

        ' send request
        util.sendPokeSimple Worksheets(STR_SHEET_NAME), server, STR_REQ_NEWS_ARTICLE, id, rangeToPoke

        ' fill error column with formula
        .Cells(ActiveCell.row, errorColumnIndex).Formula = util.composeLink(server, STR_NEWS_ARTICLE_TICK, id, util.STR_ERROR)
        ' fill result column with formula
        .Cells(ActiveCell.row, newsArticleColumnIndex).Formula = util.composeLink(server, STR_NEWS_ARTICLE_TICK, id, STR_NEWS_ARTICLE)

        .Cells(ActiveCell.row, 1).offset(1, 0).Activate
    End With
End Sub


' ========================================================
' Requests news article long value table/array
' Called when value in CELL_SUBSCRIPTION_CONTROL changes
' ========================================================
Private Sub Worksheet_Calculate()

    Dim i As Integer
    
    With Worksheets(STR_SHEET_NAME)
        For i = dataStartRowIndex To dataEndRowIndex
            If CStr(.Cells(i, newsArticleColumnIndex).value) = util.STR_LONGVALUE Then
                Dim server As String, id As String
                Dim dimension As Integer
                server = util.getServerVal(STR_SHEET_NAME, CELL_SERVER_NAME)
                If server = util.STR_EMPTY Then Exit Sub
    
                id = .Cells(i, idColumnIndex).value
    
                Dim newsArticleArray() As Variant
                ' send request and receive news article table/array
                newsArticleArray = util.sendRequest(server, STR_REQ_NEWS_ARTICLE_LONG_VALUE, id) ' returned array can be 1-Dimension or 2-Dimension
                .Cells(i, newsArticleColumnIndex).value = util.createLongValue(newsArticleArray)
            End If
        Next i
    End With

End Sub
