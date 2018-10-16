VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet11"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Const serverCell = "execSubServer"
Const topic = "execs"
Const errorRange = "execSubErrorPosition"
Const execSubContracts = "execSubContracts"
Const execSubDetails = "execSubDetails"
Const execSubControl = "execSubControl"
Const execSubRange = "execSubRange"
Const EXECS_KEY_COLUMN = 10 ' executionId
Const EXECS_ORDER_ID_COLUMN = 17 ' permId
Const EXECS_ORDER_REF_COLUMN = 19
Const EXECS_COLUMN_ROWS = 200
Const EXECS_CONTRACT_COLUMN_WIDTH = 8
Const EXECS_DETAILS_COLUMN_WIDTH = 12
Const EXECS_COLUMN_WIDTH = EXECS_CONTRACT_COLUMN_WIDTH + EXECS_DETAILS_COLUMN_WIDTH
Const execReportOrderID = 1
Const execReportOrderRef = 2
Const execReportVOLOrder = 3
Const execReportStrategy = 4
Const EXECS_VOL_ORDER_REF_START = "Hedge Delta for "
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
        id = ArrayQueries.extractid(Range(execSubControl).Formula)
        request = ArrayQueries.idToRequest(id)
        TheArray = ArrayQueries.doRequestForce2D(server, topic, request)
        thisResultHasData = UBound(TheArray, 2) > EXECS_CONTRACT_COLUMN_WIDTH
        prevResultHadData = subRangeExists()
        If thisResultHasData And prevResultHadData Then
            Call handleExecsUpdateArray(TheArray)
        Else
            If thisResultHasData Then
                theWidth = EXECS_COLUMN_WIDTH
            Else
                theWidth = ArrayQueries.DO_NOT_SPECIFY_WIDTH
            End If
            Call populatePage(Me.name, execSubRange, TheArray, baseX, baseY, False, theWidth)
        End If
    End If
End Sub

Sub handleExecsUpdateArray(ByRef TheArray() As Variant)
    Dim existingIndex As Integer, rowCtr As Integer
    For rowCtr = 1 To UBound(TheArray, 1)
        Dim arrayRow() As Variant
        arrayRow = Application.index(TheArray, rowCtr, 0)
        existingIndex = getMatch(arrayRow)
        If existingIndex = 0 Then
            Call doInsert(arrayRow)
        Else
            Call populateRow(existingIndex, arrayRow)
        End If
    Next
End Sub

Function subRangeExists() As Boolean
    subRangeExists = util.rangeNameExistsWithWidth(execSubRange, EXECS_KEY_COLUMN)
End Function

Function subRange() As Range
    If subRangeExists() Then
        Set subRange = Range(execSubRange)
    End If
End Function

Function dataRowsInWorksheet() As Integer
    dataRowsInWorksheet = subRange().rows.Count
End Function

Sub doInsert(ByRef arrayRow() As Variant)
    Dim originalFinalRow As Integer
    originalFinalRow = dataRowsInWorksheet()
    Call util.createName(Me.name, execSubRange, baseX, baseY, EXECS_COLUMN_WIDTH, baseY + originalFinalRow)
    Call populateRow(originalFinalRow + 1, arrayRow)
End Sub

Sub populateRow(ByVal existingIndex, ByRef arrayRow() As Variant)
    Call util.populateRow(subRange(), existingIndex, arrayRow)
End Sub

Function getMatch(ByRef arrayRow() As Variant) As Integer
    getMatch = util.findStringMatchFor(arrayRow(EXECS_KEY_COLUMN), subRange(), EXECS_KEY_COLUMN)
End Function

Sub cancelExecutionsSubscription()
    Range(execSubControl).Formula = "" 'To cancel subscription simply remove the control cell
End Sub

Sub subscribeToExecutions()
    Dim server As String, req As String, reqType As String, id As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    If controlCellValue() = ArrayQueries.RECEIVED Or controlCellValue() = ArrayQueries.SUBSCRIBED Then
        MsgBox "Can't do this while already subscribed."
    Else
        Range(execSubControl).Formula = ""
        Call removeExecutionRanges
        Call restoreExecutionColumns
        Range(execSubControl).Formula = util.composeLink(server, topic, util.ID_ZERO, util.FULL_CONTRACT_REQ)
    End If
End Sub

Function keyFromRow(ByVal rangeIndex As Integer, ByVal queryType As Integer)
    Dim matchColumn As Integer
    If queryType = execReportOrderID Then
        matchColumn = ORDER_ID_COLUMN
    ElseIf queryType = execReportOrderRef Then
        matchColumn = ORDER_REF_COLUMN
    ElseIf queryType = execReportVOLOrder Then
        matchColumn = ORDER_REF_COLUMN
    End If
    keyFromRow = dataRange.Cells(rangeIndex, matchColumn)
End Function

Function queryExecutions(ByVal queryType As Integer, ByVal queryKey As String) As Variant()
    If subRangeExists() Then
        Dim TheArray3() As Variant, theRange As Range, arrayIndex As Integer
        Set theRange = subRange()
        ReDim TheArray3(1 To EXECS_COLUMN_WIDTH, 1 To 10)
        arrayIndex = 1
        queryExecutions = queryExecutionsPrim(queryType, queryKey, theRange, TheArray3, arrayIndex)
    End If
End Function

Function queryExecutionsPrim(ByVal queryType As Integer, ByVal queryKey As String, _
                             ByRef theRange As Range, ByRef TheArray3() As Variant, ByRef arrayIndex As Integer) As Variant()
    Dim rangeIndex As Integer, colCtr As Integer, existingKey As String, rowMatchesKey As Boolean
    For rangeIndex = 1 To theRange.rows.Count
        If queryType = execReportOrderID Or queryType = execReportVOLOrder Then
            existingKey = theRange.Cells(rangeIndex, EXECS_ORDER_ID_COLUMN).value
            rowMatchesKey = (CLng(queryKey) = CLng(existingKey))
            If (queryType = execReportVOLOrder) And Not rowMatchesKey Then
                existingKey = theRange.Cells(rangeIndex, EXECS_ORDER_REF_COLUMN).value
                rowMatchesKey = ((EXECS_VOL_ORDER_REF_START & queryKey) = existingKey)
            End If
        ElseIf queryType = execReportOrderRef Or queryType = execReportStrategy Then
            existingKey = theRange.Cells(rangeIndex, EXECS_ORDER_REF_COLUMN).value
            rowMatchesKey = (queryKey = existingKey)
        End If
        If rowMatchesKey Then
            If arrayIndex > UBound(TheArray3, 2) Then
                ReDim Preserve TheArray3(1 To EXECS_COLUMN_WIDTH, 1 To UBound(TheArray3, 2) + 10)
            End If
            For colCtr = 1 To EXECS_COLUMN_WIDTH
                TheArray3(colCtr, arrayIndex) = theRange(rangeIndex, colCtr)
            Next colCtr
            arrayIndex = arrayIndex + 1
            If queryType = execReportStrategy Then ' get any VOL order children
                existingKey = EXECS_VOL_ORDER_REF_START & theRange.Cells(rangeIndex, EXECS_ORDER_ID_COLUMN).value
                Call queryExecutionsPrim(execReportOrderRef, existingKey, theRange, TheArray3, arrayIndex)
            End If
        End If
    Next
    If arrayIndex > 1 Then
        ReDim Preserve TheArray3(1 To EXECS_COLUMN_WIDTH, 1 To arrayIndex - 1)
        queryExecutionsPrim = Application.Transpose(TheArray3)
    End If
End Function

Sub testExecsUpdates() ' ' ONLY FOR TESTING: run this manually after subscription data present.
    Dim TheArray2(1 To 1, 1 To EXECS_COLUMN_WIDTH)
    TheArray2(1, EXECS_KEY_COLUMN) = "1"
    TheArray2(1, 1) = "Insert at top test:" & TheArray2(1, EXECS_KEY_COLUMN)
    Call handleExecsUpdateArray(TheArray2)
    TheArray2(1, EXECS_KEY_COLUMN) = "999999999"
    TheArray2(1, 1) = "Insert at end test:" & TheArray2(1, EXECS_KEY_COLUMN)
    Call handleExecsUpdateArray(TheArray2)
    TheArray2(1, EXECS_KEY_COLUMN) = "2"
    TheArray2(1, 1) = "Insert new test:" & TheArray2(1, EXECS_KEY_COLUMN)
    Call handleExecsUpdateArray(TheArray2)
    TheArray2(1, EXECS_KEY_COLUMN) = "2"
    TheArray2(1, 1) = "Match test on unique value:" & TheArray2(1, EXECS_KEY_COLUMN)
    Call handleExecsUpdateArray(TheArray2)
End Sub

Sub restoreExecutionColumns()
    If util.rangeNameExists(execSubContracts) Then
        Range(execSubContracts).Formula = ""
    End If
    Call util.createRange(Me.name, execSubContracts, baseY, baseX, EXECS_COLUMN_ROWS - baseY, EXECS_CONTRACT_COLUMN_WIDTH)
    If util.rangeNameExists(execSubDetails) Then
        Range(execSubDetails).Formula = ""
    End If
    Call util.createRange(Me.name, execSubDetails, baseY, baseX + EXECS_CONTRACT_COLUMN_WIDTH, EXECS_COLUMN_ROWS - baseY, EXECS_DETAILS_COLUMN_WIDTH)
End Sub

Sub removeExecutionRanges()
    If util.rangeNameExists(execSubRange) Then
        ActiveWorkbook.Names(execSubRange).Delete
    End If
End Sub

Function controlCellValue() As String
    controlCellValue = Range(execSubControl).value
End Function

Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub

Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call cancelExecutionsSubscription
End Sub

Sub clearExecutions()
    If controlCellValue() = ArrayQueries.RECEIVED Or controlCellValue() = ArrayQueries.SUBSCRIBED Then
        MsgBox "Can't do this while already subscribed."
    Else
        If util.rangeNameExists(execSubRange) Then
            Range(execSubRange).Formula = ""
            Call removeExecutionRanges
        End If
        Call util.clearRange(execSubContracts, util.tanColorIndex, xlShiftUp)
        Call util.clearRange(execSubDetails, util.darkGreyColorIndex, xlShiftUp)
    End If
End Sub
