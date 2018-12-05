VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet14"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Const serverCell = "acctsServer"
Const topic = "accts"
Const acctsControl = "acctsControl"
Const acctsCode = "acctsCode"
Const acctsTime = "acctsTime"
Const errorRange = "acctsErrorPosition"
Const acctsSubColumn = "acctsSubColumn"
Const acctsDataRange = "acctsDataRange"
Const subFAAcctCtrl = "subFAAcctCtrl"
Const subFAAcctValue = "subFAAcctValue"

Const NUM_RANGES = 4

Const KEY_COLUMN = 1
Const VALUE_COLUMN = 4
Const CURRENCY_COLUMN = 7
Const ACCOUNT_COLUMN = 10

Const KEY_COLUMN_WIDTH = VALUE_COLUMN - KEY_COLUMN
Const VALUE_COLUMN_WIDTH = CURRENCY_COLUMN - VALUE_COLUMN
Const CURRENCY_COLUMN_WIDTH = ACCOUNT_COLUMN - CURRENCY_COLUMN
Const ACCOUNT_COLUMN_WIDTH = 1

Const KEY_DATA_POSITION = KEY_COLUMN
Const VALUE_DATA_POSITION = VALUE_COLUMN + 1
Const CURRENCY_DATA_POSITION = CURRENCY_COLUMN + 1
Const ACCOUNT_DATA_POSITION = ACCOUNT_COLUMN

Const ARRAY_KEY_COLUMN = 1
Const ARRAY_VALUE_COLUMN = 2
Const ARRAY_CURRENCY_COLUMN = 3
Const ARRAY_ACCOUNT_COLUMN = 4

Const ACCOUNT_COLUMN_ROWS = 200

Const baseX = KEY_COLUMN
Const baseY = 8
Dim theKeyRange As Range, theCurrencyRange As Range, theValueRange As Range, theAccountRange As Range

Sub Worksheet_Calculate()
    On Error Resume Next
    Dim controlValue As String
    controlValue = controlCellValue()
    If controlValue = ArrayQueries.RECEIVED Then
        Dim server As String, id As String, request As String, TheArray() As Variant, colArray() As Variant, ctr As Integer, aColumn() As Variant, updatePreviousResult As Boolean, acctIsOk As Boolean
        server = util.getServerVal(serverCell)
        If server = "" Then Exit Sub
        id = ArrayQueries.extractid(Range(acctsControl).Formula)
        request = ArrayQueries.idToRequest(id)
        TheArray = ArrayQueries.doRequestForce2D(server, topic, request)
        updatePreviousResult = util.rangeNameExistsWithWidth(acctsDataRange & 1, 1)
        acctIsOk = (accountCodeValue() = "") Or (accountCodeValue() = TheArray(1, ARRAY_ACCOUNT_COLUMN))
        If updatePreviousResult And acctIsOk Then
            Call handleAcctsUpdateArray(TheArray)
        Else
            colArray = Array(0, KEY_DATA_POSITION, VALUE_DATA_POSITION, CURRENCY_DATA_POSITION, ACCOUNT_DATA_POSITION)
            For ctr = 1 To NUM_RANGES
                aColumn = Application.index(TheArray, 0, ctr)
                Call populatePage(Me.name, acctsDataRange & ctr, aColumn, colArray(ctr), baseY)
            Next
        End If
    End If
End Sub

Sub handleAcctsUpdateArray(ByRef TheArray() As Variant)
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
    dataRowsInWorksheet = Range(acctsDataRange & 1).rows.Count
End Function

Sub doInsert(ByRef arrayRow() As Variant)
    Dim originalFinalRow As Integer
    originalFinalRow = dataRowsInWorksheet()
    Call util.createName(Me.name, acctsDataRange & 1, KEY_DATA_POSITION, baseY, KEY_DATA_POSITION, baseY + originalFinalRow)
    Call util.createName(Me.name, acctsDataRange & 2, VALUE_DATA_POSITION, baseY, VALUE_DATA_POSITION, baseY + originalFinalRow)
    Call util.createName(Me.name, acctsDataRange & 3, CURRENCY_DATA_POSITION, baseY, CURRENCY_DATA_POSITION, baseY + originalFinalRow)
    Call util.createName(Me.name, acctsDataRange & 4, ACCOUNT_DATA_POSITION, baseY, ACCOUNT_DATA_POSITION, baseY + originalFinalRow)
    Call populateRow(originalFinalRow + 1, arrayRow)
End Sub

Sub populateRow(ByVal rowNum As Integer, ByRef arrayRow() As Variant)
    Dim colCtr As Integer
    For colCtr = 1 To NUM_RANGES
        Range(acctsDataRange & colCtr).Cells(rowNum, 1) = arrayRow(colCtr)
    Next
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
    Dim existingKey As String, existingCurrency As String, arrayKey As String, arrayCurrency As String
    existingKey = Range(acctsDataRange & 1).Cells(rowNum, 1)
    existingCurrency = Range(acctsDataRange & 3).Cells(rowNum, 1)
    arrayKey = arrayRow(ARRAY_KEY_COLUMN)
    arrayCurrency = arrayRow(ARRAY_CURRENCY_COLUMN)
    rowEquals = (existingKey = arrayKey) And (existingCurrency = arrayCurrency)
End Function

Sub testAcctsUpdates() ' ONLY FOR TESTING: run this manually after subscription data present.
    Dim TheArray2(1 To 1, 1 To NUM_RANGES)
    TheArray2(1, 4) = accountCodeValue()
        
    TheArray2(1, 1) = "AccountCode"
    TheArray2(1, 2) = "Insert test"
    TheArray2(1, 3) = "JAY"
    Call handleAcctsUpdateArray(TheArray2)
    TheArray2(1, 1) = "ZZZZZ"
    TheArray2(1, 2) = "Insert test2"
    TheArray2(1, 3) = "ZCURRENCY"
    Call handleAcctsUpdateArray(TheArray2)
    TheArray2(1, 1) = "NetLiquidationByCurrency"
    TheArray2(1, 2) = "Match test at CHF"
    TheArray2(1, 3) = "CHF"
    Call handleAcctsUpdateArray(TheArray2)
    TheArray2(1, 1) = "NetLiquidationByCurrency"
    TheArray2(1, 2) = "Insert test3"
    TheArray2(1, 3) = "CHACURRENCY"
    Call handleAcctsUpdateArray(TheArray2)
    TheArray2(1, 1) = "InsertNewInsert"
    TheArray2(1, 2) = "Insert test4"
    TheArray2(1, 3) = "NEWCURRENCY"
    Call handleAcctsUpdateArray(TheArray2)
    TheArray2(1, 1) = "MaintMarginReq"
    TheArray2(1, 2) = "Match test1"
    TheArray2(1, 3) = "USD"
    Call handleAcctsUpdateArray(TheArray2)
    TheArray2(1, 1) = "Cushion"
    TheArray2(1, 2) = "Match test2"
    TheArray2(1, 3) = ""
    Call handleAcctsUpdateArray(TheArray2)
End Sub

Function accountCodeValue() As String
    accountCodeValue = Range(acctsCode).value
End Function

Sub cancelAcctsSubscription()
    Range(acctsControl).Formula = "" ' To cancel account subscription simply remove the control cell
    Call freezeAcctsTime
End Sub

Sub freezeAcctsTime()
    Range(acctsTime).Formula = Range(acctsTime).value
End Sub

Sub clearAcctsTime()
    Range(acctsTime).Formula = ""
End Sub

Sub subscribeToAccts()
    If controlCellValue() = ArrayQueries.RECEIVED Or controlCellValue() = ArrayQueries.SUBSCRIBED Then
        MsgBox "Can't do this while already subscribed."
    Else
        Dim server As String, req As String, reqType As String, id As String
        server = util.getServerStr(serverCell)
        If server = "" Then Exit Sub
        Range(acctsControl).Formula = ""
        Call removeAccountRanges
        Call restoreAccountColumns
        Call util.setupAcctTimeLink(server, acctsTime)
        Range(acctsControl).Formula = util.composeControlLink(server, topic, util.ID_ZERO, util.FULL_CONTRACT_REQ, accountCodeValue())
    End If
End Sub

Public Sub requestManagedAccts()
    Dim server As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    Range(subFAAcctCtrl).Formula = util.composeLink(server, faAcctTopic, util.GENERIC_IDENTIFIER, "req")
    Range(subFAAcctValue).Formula = util.composeLink(server, faAcctTopic, util.GENERIC_IDENTIFIER, "value")
End Sub

Sub restoreAccountColumns()
    Dim colPosArray As Variant, colWidthArray As Variant
    colPosArray = Array(0, KEY_COLUMN, VALUE_COLUMN, CURRENCY_COLUMN, ACCOUNT_COLUMN)
    colWidthArray = Array(0, KEY_COLUMN_WIDTH, VALUE_COLUMN_WIDTH, CURRENCY_COLUMN_WIDTH, ACCOUNT_COLUMN_WIDTH)
    Dim ctr As Integer, rangeName As String
    For ctr = 1 To NUM_RANGES
        If util.rangeNameExists(acctsSubColumn & ctr) Then
            Range(acctsSubColumn & ctr).Formula = ""
        End If
        Call util.createRange(Me.name, acctsSubColumn & ctr, baseY, colPosArray(ctr), ACCOUNT_COLUMN_ROWS, colWidthArray(ctr))
    Next
End Sub

Sub removeAccountRanges()
    Dim ctr As Integer
    For ctr = 1 To NUM_RANGES
        If util.rangeNameExists(acctsDataRange & ctr) Then
            ActiveWorkbook.Names(acctsDataRange & ctr).Delete
        End If
    Next
End Sub

Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub

Function controlCellValue() As String
    controlCellValue = Range(acctsControl).value
End Function

Sub clearAccts() ' button click calls this
    If controlCellValue() = ArrayQueries.RECEIVED Or controlCellValue() = ArrayQueries.SUBSCRIBED Then
        MsgBox "Can't do this while already subscribed."
    Else
        Call clearAcctsTime
        Dim ctr As Integer
        For ctr = 1 To NUM_RANGES
            If util.rangeNameExists(acctsSubColumn & ctr) Then
                Call util.clearRange(acctsSubColumn & ctr, util.tanColorIndex, xlShiftUp, True, False)
            End If
        Next
        Call removeAccountRanges
    End If
End Sub

Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call cancelAcctsSubscription
    Range(subFAAcctCtrl).Formula = ""
    Range(subFAAcctValue).Formula = ""
End Sub
