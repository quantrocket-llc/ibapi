VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet10"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Const serverCell = "ordersServer"
Const topic = "opens"
Const orderSubControl = "ordersControl"
Const errorRange = "ordersErrorPosition"
Const openSubContracts = "openSubContracts"
Const openSubOrders = "openSubOrders"
Const openSubStatuses = "openSubStatuses"
Const openSubExtended = "openSubExtended"
Const openSubRange = "openSubRange"
Const ORDS_COLUMN_ROWS = 200
Const ORDS_CONTRACT_COLUMN_WIDTH = 11
Const ORDS_DETAILS_COLUMN_WIDTH = 5
Const ORDS_ORDERS_COLUMN_WIDTH = 8
Const ORDS_EXTENDED_COLUMN_WIDTH = 52
Const ORDS_KEY_COLUMN = ORDS_CONTRACT_COLUMN_WIDTH + ORDS_DETAILS_COLUMN_WIDTH + 2 ' permId
Const ORDS_COLUMN_WIDTH = ORDS_CONTRACT_COLUMN_WIDTH + ORDS_DETAILS_COLUMN_WIDTH + ORDS_ORDERS_COLUMN_WIDTH + ORDS_EXTENDED_COLUMN_WIDTH
Const baseX = 1
Const baseY = 10

Sub Worksheet_Calculate()
    On Error Resume Next
    Dim server As String, id As String, request As String, controlValue As String, TheArray() As Variant, theWidth As Integer
    Dim prevResultHadData As Boolean, thisResultHasData As Boolean
    controlValue = controlCellValue()
    If controlValue = ArrayQueries.RECEIVED Then
        server = util.getServerVal(serverCell)
        If server = "" Then Exit Sub
        id = ArrayQueries.extractid(Range(orderSubControl).Formula)
        request = ArrayQueries.idToRequest(id)
        TheArray = ArrayQueries.doRequestForce2D(server, topic, request)
        thisResultHasData = UBound(TheArray, 2) > ORDS_CONTRACT_COLUMN_WIDTH
        prevResultHadData = util.rangeNameExistsWithWidth(openSubRange, ORDS_KEY_COLUMN)
        If thisResultHasData And prevResultHadData Then
            Call handleOpensUpdateArray(TheArray)
        Else
            If thisResultHasData Then
                theWidth = ORDS_COLUMN_WIDTH
            Else
                theWidth = ArrayQueries.DO_NOT_SPECIFY_WIDTH
            End If
            Call populatePage(Me.name, openSubRange, TheArray, baseX, baseY, False, theWidth)
        End If
    End If
End Sub

Sub handleOpensUpdateArray(ByRef TheArray() As Variant)
    Dim isDelete As Boolean, existingIndex As Integer, rowCtr As Integer, arrayRow() As Variant
    For rowCtr = 1 To UBound(TheArray, 1)
        arrayRow = Application.index(TheArray, rowCtr, 0)
        existingIndex = getMatch(arrayRow)
        If getKeyFromArray(arrayRow) < 0 Then ' delete
            Call deleteRowIfExists(existingIndex)
        Else
            If existingIndex = 0 Then
                Call doInsert(arrayRow)
            Else
                Call populateRow(existingIndex, arrayRow)
            End If
        End If
    Next
End Sub

Function dataRowsInWorksheet() As Integer
    dataRowsInWorksheet = Range(openSubRange).rows.Count
End Function

Sub doInsert(ByRef arrayRow() As Variant)
    Dim originalFinalRow As Integer
    originalFinalRow = dataRowsInWorksheet()
    Call util.createName(Me.name, openSubRange, baseX, baseY, ORDS_COLUMN_WIDTH, baseY + originalFinalRow)
    Call populateRow(originalFinalRow + 1, arrayRow)
End Sub

Sub populateRow(ByVal existingIndex, ByRef arrayRow() As Variant)
    Call util.populateRow(Range(openSubRange), existingIndex, arrayRow)
End Sub

Function getMatch(ByRef arrayRow() As Variant) As Integer
    Dim longKey As Long, isDelete As Boolean
    longKey = getKeyFromArray(arrayRow)
    isDelete = (longKey < 0)
    If isDelete Then
        longKey = longKey * -1
    End If
    getMatch = util.findLongMatchFor(longKey, Range(openSubRange), ORDS_KEY_COLUMN)
End Function

Function getKeyFromArray(ByRef arrayRow() As Variant) As String
    getKeyFromArray = arrayRow(ORDS_KEY_COLUMN)
End Function

Function deleteRowIfExists(ByVal rowNum As Integer)
    Dim theRange As Range
    Set theRange = Range(openSubRange)
    Dim totalRows As Integer
    totalRows = theRange.rows.Count
    If rowNum > 0 And rowNum <= totalRows Then
        If rowNum < totalRows Then
            Call populateRowFromRow(Range(openSubRange), rowNum, totalRows)
        End If
        theRange.rows(totalRows).Formula = ""
        Call util.createName(Me.name, openSubRange, baseX, baseY, ORDS_COLUMN_WIDTH, baseY + totalRows - 2)
        deleteRowIfExists = True
    Else
        deleteRowIfExists = False
    End If
End Function

Sub cancelOpenOrderSubscription()
    Range(orderSubControl).Formula = "" 'To cancel open order subscription simply remove the control cell
End Sub

Sub subscribeToOpenOrders()
    Dim server As String, req As String, reqType As String, id As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    If controlCellValue() = ArrayQueries.RECEIVED Or controlCellValue() = ArrayQueries.SUBSCRIBED Then
        MsgBox "Can't do this while already subscribed."
    Else
        Range(orderSubControl).Formula = ""
        Call removeOrdersRanges
        Call restoreOrdersColumns
        Range(orderSubControl).Formula = util.composeLink(server, topic, util.ID_ZERO, util.FULL_CONTRACT_REQ)
    End If
End Sub

Sub testOrdersUpdates() ' ' ONLY FOR TESTING: run this manually after subscription data present.
    Dim TheArray2(1 To 1, 1 To ORDS_CONTRACT_COLUMN_WIDTH + ORDS_DETAILS_COLUMN_WIDTH + ORDS_ORDERS_COLUMN_WIDTH + ORDS_EXTENDED_COLUMN_WIDTH)
    TheArray2(1, ORDS_KEY_COLUMN) = "1"
    TheArray2(1, 1) = "Insert test1"
    Call handleOpensUpdateArray(TheArray2)
    TheArray2(1, ORDS_KEY_COLUMN) = "999999999"
    TheArray2(1, 1) = "Insert test2"
    Call handleOpensUpdateArray(TheArray2)
    TheArray2(1, ORDS_KEY_COLUMN) = "2"
    TheArray2(1, 1) = "Insert new test:" & TheArray2(1, ORDS_KEY_COLUMN)
    Call handleOpensUpdateArray(TheArray2)
    TheArray2(1, ORDS_KEY_COLUMN) = "2"
    TheArray2(1, 1) = "Match test on unique value:" & TheArray2(1, ORDS_KEY_COLUMN)
    Call handleOpensUpdateArray(TheArray2)
End Sub

Sub restoreOrdersColumns()
    If util.rangeNameExists(openSubContracts) Then
        Range(openSubContracts).Formula = ""
    End If
    Call util.createRange(Me.name, openSubContracts, baseY, baseX, ORDS_COLUMN_ROWS - baseY, ORDS_CONTRACT_COLUMN_WIDTH)
    Dim base As Integer
    base = baseX + ORDS_CONTRACT_COLUMN_WIDTH
    If util.rangeNameExists(openSubOrders) Then
        Range(openSubOrders).Formula = ""
    End If
    Call util.createRange(Me.name, openSubOrders, baseY, base, ORDS_COLUMN_ROWS - baseY, ORDS_DETAILS_COLUMN_WIDTH)
    base = baseX + ORDS_CONTRACT_COLUMN_WIDTH + ORDS_DETAILS_COLUMN_WIDTH
    If util.rangeNameExists(openSubStatuses) Then
        Range(openSubStatuses).Formula = ""
    End If
    Call util.createRange(Me.name, openSubStatuses, baseY, base, ORDS_COLUMN_ROWS - baseY, ORDS_ORDERS_COLUMN_WIDTH)
    base = baseX + ORDS_CONTRACT_COLUMN_WIDTH + ORDS_DETAILS_COLUMN_WIDTH + ORDS_ORDERS_COLUMN_WIDTH
    If util.rangeNameExists(openSubExtended) Then
        Range(openSubExtended).Formula = ""
    End If
    Call util.createRange(Me.name, openSubExtended, baseY, base, ORDS_COLUMN_ROWS - baseY, ORDS_EXTENDED_COLUMN_WIDTH)
End Sub

Sub removeOrdersRanges()
    If util.rangeNameExists(openSubRange) Then
        ActiveWorkbook.Names(openSubRange).Delete
    End If
End Sub

Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub

Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call cancelOpenOrderSubscription
End Sub

Function controlCellValue() As String
    controlCellValue = Range(orderSubControl).value
End Function

Sub clearOpenOrders()
    If controlCellValue() = ArrayQueries.RECEIVED Or controlCellValue() = ArrayQueries.SUBSCRIBED Then
        MsgBox "Can't do this while already subscribed."
    Else
On Error GoTo FormulasCleared
        Range(openSubRange).Formula = ""
FormulasCleared:
        Call util.clearRange(openSubContracts, util.tanColorIndex, xlShiftUp)
        Call util.clearRange(openSubOrders, util.darkGreyColorIndex, xlShiftUp)
        Call util.clearRange(openSubStatuses, util.tanColorIndex, xlShiftUp)
        Call util.clearRange(openSubExtended, util.darkGreyColorIndex, xlShiftUp)
    End If
End Sub


