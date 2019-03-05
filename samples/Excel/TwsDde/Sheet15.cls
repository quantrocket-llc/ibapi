VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet15"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Const serverCell = "portsServer"
Const topic = "ports"
Const portsControl = "portsControl"
Const portsCode = "portsCode"
Const portsTime = "portsTime"
Const errorRange = "portsErrorPosition"
Const portsSubColumn = "portsSubColumn"
Const portsDataRange = "portsDataRange"
Const baseX = 1
Const baseY = 8
Const PORTS_COLUMN_ROWS = 200
Const PORTS_COLUMN_WIDTH = 15
Const PORTS_NUM_KEY_COLUMNS = 5
Const PORTS_KEY_COLUMN = 1
Const PORTS_MAX_ROWS = 300

Sub Worksheet_Calculate()
    On Error Resume Next
    Dim controlValue As String
    controlValue = controlCellValue()
    If controlValue = ArrayQueries.RECEIVED Then
        Dim server As String, id As String, request As String, TheArray() As Variant, updatePreviousResult As Boolean, acctIsOk As Boolean
        server = util.getServerVal(serverCell)
        If server = "" Then Exit Sub
        id = ArrayQueries.extractid(Range(portsControl).Formula)
        request = ArrayQueries.idToRequest(id)
        TheArray = ArrayQueries.doRequestForce2D(server, topic, request)
        updatePreviousResult = util.rangeNameExistsWithWidth(portsDataRange, PORTS_COLUMN_WIDTH)
        acctIsOk = (portsAccountCodeValue() = "") Or (portsAccountCodeValue() = TheArray(1, PORTS_COLUMN_WIDTH))
        If updatePreviousResult And acctIsOk Then
            Call handlePortsUpdateArray(TheArray)
        Else
            Call populatePage(Me.name, portsDataRange, TheArray, baseX, baseY)
        End If
    End If
End Sub

Sub handlePortsUpdateArray(ByRef TheArray() As Variant)
    Dim existingIndex As Integer, rowCtr As Integer, arrayRow() As Variant
    For rowCtr = 1 To UBound(TheArray, 1)
        arrayRow = Application.index(TheArray, rowCtr, 0)
        existingIndex = getMatch(arrayRow)
        If existingIndex = 0 Then
            Call doInsert(arrayRow)
        Else
            Call populateRow(existingIndex, arrayRow)
        End If
    Next
End Sub

Function dataRowsInWorksheet() As Integer
    dataRowsInWorksheet = Range(portsDataRange).rows.Count
End Function

Sub doInsert(ByRef arrayRow() As Variant)
    Dim originalFinalRow As Integer
    originalFinalRow = dataRowsInWorksheet()
    Call util.createName(Me.name, portsDataRange, baseX, baseY, PORTS_COLUMN_WIDTH, baseY + originalFinalRow)
    Call populateRow(originalFinalRow + 1, arrayRow)
End Sub

Sub populateRow(ByVal existingIndex, ByRef arrayRow() As Variant)
    Call util.populateRow(Range(portsDataRange), existingIndex, arrayRow)
End Sub

Function getMatch(ByRef arrayRow() As Variant) As Integer
    Dim retVal As Integer, rowCtr As Integer
    retVal = 0
    For rowCtr = 1 To dataRowsInWorksheet()
        If rowEquals(rowCtr, arrayRow) Then
            retVal = rowCtr
            Exit For
        End If
    Next rowCtr
    getMatch = retVal
End Function

Function rowEquals(ByVal rowNum As Integer, ByRef arrayRow() As Variant) As Boolean
    Dim colCtr As Integer
    For colCtr = PORTS_KEY_COLUMN To PORTS_KEY_COLUMN + PORTS_NUM_KEY_COLUMNS
        
        If CStr(Range(portsDataRange).rows(rowNum).Cells(1, colCtr).value) <> CStr(arrayRow(colCtr)) Then
            rowEquals = False
            Exit Function
        End If
    Next
    rowEquals = True
End Function

Sub testPortsUpdates() ' ' ONLY FOR TESTING: run this manually after subscription data present.
    Dim TheArray2(1 To 1, 1 To PORTS_COLUMN_WIDTH)
    TheArray2(1, 1) = "AAAAA"
    TheArray2(1, 2) = "Insert one test"
    TheArray2(1, 3) = "test1"
    Call handlePortsUpdateArray(TheArray2)
    TheArray2(1, 1) = "ZZZZZ"
    TheArray2(1, 2) = "Insert two test"
    TheArray2(1, 3) = "test2"
    Call handlePortsUpdateArray(TheArray2)
    TheArray2(1, 1) = "NEWSYM"
    TheArray2(1, 2) = "Insert three test"
    TheArray2(1, 3) = "test3"
    Call handlePortsUpdateArray(TheArray2)
    TheArray2(1, 1) = "NEWSYM3"
    TheArray2(1, 2) = "Insert four test"
    TheArray2(1, 3) = "test4"
    Call handlePortsUpdateArray(TheArray2)
    TheArray2(1, 1) = "NEWSYM2"
    TheArray2(1, 2) = "Update test"
    TheArray2(1, 3) = "Update test"
    Call handlePortsUpdateArray(TheArray2)
    TheArray2(1, 1) = "NEWSYM2"
    TheArray2(1, 2) = "Update test"
    TheArray2(1, 3) = "Update test"
    Call handlePortsUpdateArray(TheArray2)
End Sub

Function portsAccountCodeValue() As String
    portsAccountCodeValue = Range(portsCode).value
End Function

Sub cancelPortsSubscription()
    Range(portsControl).Formula = "" ' To cancel subscription simply remove the control cell
    Call freezePortsTime
End Sub

Sub freezePortsTime()
    Range(portsTime).Formula = Range(portsTime).value
End Sub

Sub clearPortsTime()
    Range(portsTime).Formula = ""
End Sub

Sub subscribeToPorts()
    If controlCellValue() = ArrayQueries.RECEIVED Or controlCellValue() = ArrayQueries.SUBSCRIBED Then
        MsgBox "Can't do this while already subscribed."
    Else
        Dim server As String, req As String, reqType As String, id As String
        server = util.getServerStr(serverCell)
        If server = "" Then Exit Sub
        Range(portsControl).Formula = ""
        Call removePortfolioRanges
        Call restorePortfolioColumns
        Call util.setupAcctTimeLink(server, portsTime)
        Range(portsControl).Formula = util.composeControlLink(server, topic, util.ID_ZERO, util.FULL_CONTRACT_REQ, portsAccountCodeValue())
    End If
End Sub

Sub restorePortfolioColumns()
    If util.rangeNameExists(portsSubColumn) Then
        Range(portsSubColumn).Formula = ""
    End If
    Call util.createRange(Me.name, portsSubColumn, baseY, baseX, PORTS_COLUMN_ROWS - baseY, PORTS_COLUMN_WIDTH)
End Sub

Sub removePortfolioRanges()
    If util.rangeNameExists(portsDataRange) Then
        ActiveWorkbook.Names(portsDataRange).Delete
    End If
End Sub

Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub

Function controlCellValue() As String
    controlCellValue = Range(portsControl).value
End Function

Sub clearPorts() ' button click calls this
    If controlCellValue() = ArrayQueries.RECEIVED Or controlCellValue() = ArrayQueries.SUBSCRIBED Then
        MsgBox "Can't do this while already subscribed."
    Else
        Call clearPortsTime
        Call util.clearRange(portsSubColumn, util.lightGreenColorIndex, xlShiftUp, True, True)
        Call removePortfolioRanges
    End If
End Sub

Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call cancelPortsSubscription
End Sub
