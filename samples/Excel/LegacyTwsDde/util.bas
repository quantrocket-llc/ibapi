Attribute VB_Name = "util"
Option Explicit

Public Const ORIGINAL_CELL_EMPTY = "EMPTY"  ' this was the original empty cell value.  With very OLD TWS must use this
Public Const PREV_CELL_EMPTY = "{}"         ' this must be used with TWS 860 or lower until the very old ones.
Public Const NEW_CELL_EMPTY = "~"           ' this can be used with TWS 861 and higher to shorten DDE link strings
Public Const CELL_EMPTY = NEW_CELL_EMPTY    ' set this with the one you want to use
Public Const FULL_CONTRACT_REQ = "req"
Public Const LOCAL_SYMBOL_REQ = "req2"
Public Const BULLETIN_REQ = "sub"
Public Const ID_ZERO = "id0"
Public Const faAcctTopic = "FAaccts"
Public Const ACCT_TOPIC = "acct"
Public Const ACCT_TIME = "acctTime"
Public Const DO_NOT_SET = "Do_Not_Set"
Public Const USE_ACTIVE_WORKSHEET = ""
Public Const IBEFP = "IBEFP"
Public Const OPT = "OPT"
Public Const FUT = "FUT"
Public Const FOP = "FOP"
Public Const BAG = "BAG"
Public Const STK = "STK"
Public Const IOPT = "IOPT"
Public Const WAR = "WAR"
Public Const CPUT = "P"
Public Const CCALL = "C"
Public Const EXP_POINT = "!"
Public Const QMARK = "?"
Public Const PIPE_CHAR = "|"
Public Const EQUALS_SIGN = "="
Public Const UNDERSCORE = "_"
Public Const SPACE_CHAR = " " ' single space
Public Const COLON_CHAR = ":"
Public Const TICK_CHAR = "'"
Public Const COMMA_CHAR = ","
Public Const DASH_CHAR = "-"
Public Const CONTRACT_DETAILS_SEPARATOR = "/"
Public Const SPACE_REPLACEMENT = "singleSpace"
Public Const COLON_REPLACEMENT = "singleColon"
Public Const UNDERSCORE_REPLACEMENT = "uNdErScOrE"
Public Const IDENTIFIER_PREFIX = "id"
Public Const GENERIC_IDENTIFIER = "id1"
Public Const START_INDICATOR_COLUMN = 1
Public Const darkGreyColorIndex = 15
Public Const tanColorIndex = 36
Public Const lightGreenColorIndex = 35
Public Const yellowIndex = 6
Public Const brightRedColorIndex = 3
Public Const lavendarColorIndex = 39
Public Const COMBO_LEG_COLUMN = 11
Public Const GENERICTICKS_CONST = "GENERICTICKS"
Public Const SERVER_NAME_CHAR = "S"
Const maxRowsToFormat = 200 ' increase this if your spreadsheets go beyond the 200th row
Const maxColsToFormat = 53  ' increase this if your spreadsheets go beyond the 50th column
Const doNotColor = -1
Const doNotDelete = -1
Public Function safeWorksheetName(ByVal worksheetName As String) As String
    safeWorksheetName = "'" & cleanName(worksheetName, False) & "'" ' ' can have spaces in worksheet name
End Function
Public Function fullRange(ByVal worksheetName, ByVal descRangeName) As Excel.Range
    fullRange = Range(fulldescRangeName(worksheetName, descRangeName))
End Function
Public Function fulldescRangeName(ByVal worksheetName, ByVal descRangeName) As String
    fulldescRangeName = safeWorksheetName(worksheetName) & EXP_POINT & descRangeName
End Function
Public Function getServerVal(ByVal descRangeName As String) As String
    Dim server As String
    server = Range(descRangeName).value
    If server = "" Or IsEmpty(server) Then
        MsgBox ("You must enter a valid user name.")
    End If
    getServerVal = SERVER_NAME_CHAR & server
End Function
Public Function getServerStr(ByVal descRangeName As String) As String
    Dim server As String
    server = getServerVal(descRangeName)
    If server <> "" Then
        getServerStr = EQUALS_SIGN & server & PIPE_CHAR
    Else
        getServerStr = ""
    End If
End Function
Sub createComboLegs()
    ComboLegForm.Show
End Sub
Sub createTicker()
    TickerForm.Show
End Sub
Function cleanUnderscore(rawCellContents) As String
    ' Replace underscore with string "uNdErScOrE" as underscore is the DDE delimiter
    cleanUnderscore = Replace(rawCellContents, UNDERSCORE, UNDERSCORE_REPLACEMENT)
End Function
Function cleanName(ByVal rawName As String, Optional ByVal cleanSpaces As Boolean = True) As String
    ' Clean up string to be an Excel range or page name
    If cleanSpaces Then ' can have spaces in worksheet name
        rawName = Replace(rawName, SPACE_CHAR, UNDERSCORE)
    End If
    rawName = Replace(rawName, EXP_POINT, UNDERSCORE)
    rawName = Replace(rawName, QMARK, UNDERSCORE)
    rawName = Replace(rawName, PIPE_CHAR, UNDERSCORE)
    rawName = Replace(rawName, EQUALS_SIGN, UNDERSCORE)
    rawName = Replace(rawName, PIPE_CHAR, UNDERSCORE)
    rawName = Replace(rawName, COLON_CHAR, UNDERSCORE)
    rawName = Replace(rawName, TICK_CHAR, UNDERSCORE)
    rawName = Replace(rawName, COMMA_CHAR, UNDERSCORE)
    cleanName = Replace(rawName, DASH_CHAR, UNDERSCORE)
End Function
Function cleanReq(rawRequest) As String
    Dim req As String
    ' Replace space with string "singleSpace" since dde won't work on empty space
    req = Replace(rawRequest, SPACE_CHAR, SPACE_REPLACEMENT)
    ' Replace colon with string "singleColon" since dde won't work on colon
    cleanReq = Replace(req, COLON_CHAR, COLON_REPLACEMENT)
End Function
Function composeShortLink(server, topic, rawReq) As String
    composeShortLink = server & topic & EXP_POINT & cleanReq(rawReq)
End Function
Function composeLink(server, topic, id, rawReq) As String
    composeLink = server & topic & EXP_POINT & id & QMARK & cleanReq(rawReq)
End Function
Function composeControlLink(server, topic, id, reqType, rawReq) As String
    composeControlLink = composeLink(server, topic, TICK_CHAR & id, reqType & QMARK & rawReq & TICK_CHAR)
End Function
Function composeSubscriptionLink(server, topic, Optional ByVal req As String = FULL_CONTRACT_REQ) As String
    composeSubscriptionLink = server & topic & EXP_POINT & req
End Function
Function isExpDeriv(ByVal secType) As Boolean
    isExpDeriv = False
    If secType = OPT Or secType = FUT Or secType = FOP Or secType = IOPT Or secType = WAR Then
        'returns true if secType = OPT|FUT|FOP|IOPT|WAR
        isExpDeriv = True
    End If
End Function
Function isOptVariant(ByVal secType) As Boolean
    isOptVariant = False
    If secType = OPT Or secType = FOP Or secType = IOPT Or secType = WAR Then
        'returns true if secType = OPT|FOP|IOPT|WAR
        isOptVariant = True
    End If
End Function

Function composeContractReq(ByVal rowFirstCell As Range, ByRef req As String, ByRef reqType As String, _
                            ByVal doComboAndPrimary As Boolean, _
                            Optional ByVal currencyColumn As Integer = 10, _
                            Optional ByVal expiredColumn = -1, _
                            Optional ByVal doPopupOnError As Boolean = True, _
                            Optional ByRef setSecType As String = DO_NOT_SET, _
                            Optional ByRef setExchange As String = DO_NOT_SET) As Boolean
    ' contract description vars
    Dim symbol As String, secType As String, expiry As String, strike As String, _
        right As String, multiplier As String, exchange As String, curency As String, _
        primaryexchange As String, comboLegs As String, expired As String, genericTicks As String, tradingClass As String
        
    
    req = ""
    reqType = ""
    
    ' get contract description
    symbol = UCase(rowFirstCell.offset(0, 0).value)
    secType = UCase(rowFirstCell.offset(0, 1).value)
    expiry = rowFirstCell.offset(0, 2).value
    strike = rowFirstCell.offset(0, 3).value
    right = UCase(rowFirstCell.offset(0, 4).value)
    multiplier = UCase(rowFirstCell.offset(0, 5).value)
    tradingClass = UCase(rowFirstCell.offset(0, 6).value)
    exchange = UCase(rowFirstCell.offset(0, 7).value)
    If setSecType <> DO_NOT_SET Then
        setSecType = secType
    End If
    If setExchange <> DO_NOT_SET Then
        setExchange = exchange
    End If
    curency = UCase(rowFirstCell.offset(0, currencyColumn - 1).value)
    If doComboAndPrimary Then
        primaryexchange = UCase(rowFirstCell.offset(0, 8).value)
        comboLegs = rowFirstCell.offset(0, 10).value
    End If

    ' must have symbol, secType, exchange and currency
    If symbol = "" Or secType = "" Or exchange = "" Or curency = "" Then
        If doPopupOnError Then
            MsgBox ("You must enter at least symbol, security type, exchange, and currency.")
        End If
        composeContractReq = False
    Else
        req = cleanUnderscore(symbol) & UNDERSCORE & secType & UNDERSCORE
        If (isExpDeriv(secType) And expiry = "") Then
            reqType = LOCAL_SYMBOL_REQ
        Else
            reqType = FULL_CONTRACT_REQ
            If isExpDeriv(secType) Then
                req = req & expiry & UNDERSCORE
            End If
            If isOptVariant(secType) Then
                req = req & strike & UNDERSCORE & right & UNDERSCORE
            End If
            If isExpDeriv(secType) Then
                If multiplier <> "" Then
                    req = req & multiplier & UNDERSCORE
                End If
            End If
        End If
    
        req = req & cleanUnderscore(exchange) & UNDERSCORE & curency
    
        If doComboAndPrimary Then
            Call addComboLegsIfApplicable(secType, req, comboLegs)
            req = req & UNDERSCORE & orEmpty(primaryexchange)
        End If
        If expiredColumn <> -1 Then
            expired = UCase(rowFirstCell.offset(0, expiredColumn - 1).value)
            req = req & UNDERSCORE & orEmpty(expired)
        End If
               
        ' tradingClass
        If (isExpDeriv(secType) And (reqType = FULL_CONTRACT_REQ)) Then
            req = req & UNDERSCORE & orEmpty(tradingClass)
        End If
        
        ' contract details separator
        req = req & CONTRACT_DETAILS_SEPARATOR
        
        composeContractReq = True
    End If
End Function
Sub addComboLegsIfApplicable(ByRef secType As String, ByRef req As String, ByRef comboLegs As String)
    If secType = BAG Then
        req = req & UNDERSCORE & comboLegs
    End If
End Sub
Function orEmpty(ByVal contents As String) As String
    If contents = "" Then
        orEmpty = CELL_EMPTY
    Else
        orEmpty = contents
    End If
End Function

Public Function getIDpost(ByRef id As Integer) As String
    getIDpost = IDENTIFIER_PREFIX & CStr(id)
    id = id + 1
End Function

Public Function getIDpre(ByRef id As Integer) As String
    id = id + 1
    getIDpre = IDENTIFIER_PREFIX & CStr(id)
End Function

Sub setupAcctTimeLink(ByVal server As String, ByVal acctCellRange As String)
    Range(acctCellRange).Formula = util.composeLink(server, ACCT_TOPIC, util.GENERIC_IDENTIFIER, ACCT_TIME)
End Sub

Function getNextAvailableRow(ByRef lastRow As Long, ByRef startIndicator As String) As Long
    If lastRow = 0 Then
        ' find out from where to start and clear previous 10 rows
        Dim i As Integer
        For i = 1 To 2000
          ' suppose we have this separate line there
          If Cells(i, START_INDICATOR_COLUMN) = startIndicator Then
              lastRow = i + 2
              Exit For
          End If
        Next i
        ' if we could not find the separator line, use the one user currently selected
        If lastRow = 0 Then
           lastRow = ActiveCell.row
        End If
    End If
    getNextAvailableRow = lastRow
    lastRow = lastRow + 1
End Function

Function rangeNameExists(ByVal rangeName As String) As Boolean
    Dim existingName As name
    rangeNameExists = False
    For Each existingName In ActiveWorkbook.Names
        If existingName.name = rangeName Then
            rangeNameExists = True
            Exit Function
        End If
    Next existingName
End Function

Function rangeNameExistsWithWidth(ByVal rangeName As String, ByVal widthAtLeast As Integer) As Boolean
    rangeNameExistsWithWidth = rangeNameExists(rangeName)
    If rangeNameExistsWithWidth Then
        rangeNameExistsWithWidth = Range(rangeName).columns.Count >= widthAtLeast
    End If
End Function

Sub populateRow(ByRef theRange As Range, ByVal rowNum As Integer, ByRef arrayRow() As Variant)
    Dim colCtr As Integer, theValue As Variant
    For colCtr = 1 To theRange.columns.Count
        If colCtr <= UBound(arrayRow) Then
            theValue = arrayRow(colCtr)
        Else
            theValue = ""
        End If
        theRange.Cells(rowNum, colCtr) = theValue
    Next
End Sub

Sub populateRowFromRow(ByRef theRange As Range, ByVal rowNumDest As Integer, ByVal rowNumSource As Integer)
    Dim colCtr As Integer
    For colCtr = 1 To theRange.columns.Count
        theRange.Cells(rowNumDest, colCtr) = theRange.Cells(rowNumSource, colCtr)
    Next
End Sub

Function findLongMatchFor(ByVal keyValue As Long, ByRef dataRange As Range, Optional ByVal matchColumn As Integer = 1) As Integer
    Dim rowCtr As Integer
    Dim existingValue As Long
    For rowCtr = 1 To dataRange.rows.Count
        existingValue = dataRange.Cells(rowCtr, matchColumn)
        If keyValue = existingValue Then
            findLongMatchFor = rowCtr
            Exit For
        End If
    Next
    If rowCtr = 0 Then
        findLongMatchFor = 0
    End If
End Function

Function findStringMatchFor(ByVal keyValue As String, ByRef dataRange As Range, Optional ByVal matchColumn As Integer = 1) As Integer
    Dim rowCtr As Integer
    Dim existingValue As String
    For rowCtr = 1 To dataRange.rows.Count
        existingValue = dataRange.Cells(rowCtr, matchColumn)
        If keyValue = existingValue Then
            findStringMatchFor = rowCtr
            Exit For
        End If
    Next
    If rowCtr = 0 Then
        findStringMatchFor = 0
    End If
End Function

Sub createName(ByVal worksheetName As String, ByVal rangeName As String, _
               ByVal baseX As Integer, ByVal baseY As Integer, ByVal endX As Integer, _
               ByVal endY As Integer)

On Error GoTo nameDeleted
    ActiveWorkbook.Names(rangeName).Delete
nameDeleted:

Dim refersTo As String
refersTo = "=" & fulldescRangeName(worksheetName, rangeStr(baseX, baseY) & ":" & rangeStr(endX, endY))
' looks like this: "=Scanner!R14C4:R30C5"

ActiveWorkbook.Names.add name:=rangeName, RefersToR1C1:=refersTo
End Sub

Function buildRange(ByVal worksheetName As String, ByVal rangeName As String, _
               ByVal baseX As Integer, ByVal baseY As Integer, ByVal endX As Integer, _
               ByVal endY As Integer) As Range
Call createName(worksheetName, rangeName, baseX, baseY, endX, endY)
Set buildRange = Range(rangeName)
End Function

Function rangeStr(ByVal baseX As Integer, ByVal baseY As Integer) As String
    rangeStr = "R" & baseY & "C" & baseX
End Function

Function arrayDims(ByRef TheArray() As Variant) As Integer

On Error GoTo FINISHED

Dim dimNum, checkVal As Integer
For dimNum = 1 To 10000
    checkVal = LBound(TheArray, dimNum)
Next dimNum

FINISHED:

arrayDims = dimNum - 1

End Function

Function createRange(ByVal worksheetName As String, ByVal rangeName As String, _
                     ByVal theRow As Integer, ByVal theColumn As Integer, _
                     ByVal rows As Integer, ByVal columns As Integer) As Range
    Set createRange = util.buildRange(worksheetName, rangeName, theColumn, theRow, _
                                                          theColumn + columns - 1, theRow + rows - 1)
End Function

Function updateRangeAfterInsertMovesIt(ByVal rangeName As String, ByRef theRange As Range, Optional ByVal numRowsInserted = 1, Optional ByVal maxRows As Integer = -1) As Range
    Dim numRows As Integer
    numRows = theRange.rows.Count + numRowsInserted
    If maxRows > 0 And numRows > maxRows Then
        numRows = maxRows
    End If
    Set updateRangeAfterInsertMovesIt = _
        util.createRange(theRange.Worksheet.name, rangeName, theRange.row - numRowsInserted, theRange.Column, numRows, theRange.columns.Count)
End Function

Function extendRangeToLength(ByVal rangeName As String, ByRef theRange As Range, ByVal numRows As Integer, Optional ByVal maxRows As Integer = -1) As Range
    Dim numRowsToDo As Integer
    If maxRows > 0 And numRows > maxRows Then
        numRowsToDo = maxRows
    Else
        numRowsToDo = numRows
    End If
    Set extendRangeToLength = _
        util.createRange(theRange.Worksheet.name, rangeName, theRange.row, theRange.Column, numRowsToDo, theRange.columns.Count)
End Function

Sub clearRange(ByVal name As String, Optional ByVal colorIndex As Integer = doNotColor, _
               Optional deleteDirection As Integer = doNotDelete, _
               Optional doInteriorHorizontal As Boolean = True, Optional doInteriorVertical As Boolean = True)
On Error GoTo clearRangeDone
    Dim theRange As Range
    Set theRange = Range(name)
    theRange.Clear
    theRange.ClearFormats
    If deleteDirection <> doNotDelete Then
            ' theRange.Cells.Delete (deleteDirection)
    End If
    If colorIndex <> doNotColor Then
        If theRange.rows.Count > maxRowsToFormat Then
            Set theRange = theRange.Resize(maxRowsToFormat, theRange.columns.Count)
        End If
        If theRange.columns.Count > maxColsToFormat Then
            Set theRange = theRange.Resize(theRange.rows, maxColsToFormat)
        End If
        With theRange.Interior
            .colorIndex = colorIndex
            .Pattern = xlSolid
            .PatternColorIndex = xlAutomatic
        End With
        If colorIndex = darkGreyColorIndex Then
            theRange.Font.colorIndex = yellowIndex
        End If
        theRange.Borders(xlDiagonalDown).LineStyle = xlNone
        theRange.Borders(xlDiagonalUp).LineStyle = xlNone
        With theRange.Borders(xlEdgeLeft)
            .LineStyle = xlContinuous
            .Weight = xlThin
            .colorIndex = xlAutomatic
        End With
        With theRange.Borders(xlEdgeTop)
            .LineStyle = xlContinuous
            .Weight = xlThin
            .colorIndex = xlAutomatic
        End With
        With theRange.Borders(xlEdgeBottom)
            .LineStyle = xlContinuous
            .Weight = xlThin
            .colorIndex = xlAutomatic
        End With
        With theRange.Borders(xlEdgeRight)
            .LineStyle = xlContinuous
            .Weight = xlThin
            .colorIndex = xlAutomatic
        End With
        If doInteriorHorizontal Then
            With theRange.Borders(xlInsideHorizontal)
                .LineStyle = xlContinuous
                .Weight = xlThin
                .colorIndex = xlAutomatic
            End With
        End If
        If doInteriorVertical Then
            With theRange.Borders(xlInsideVertical)
                .LineStyle = xlContinuous
                .Weight = xlThin
                .colorIndex = xlAutomatic
            End With
        End If
    End If
clearRangeDone:
End Sub
