Attribute VB_Name = "util"
Option Explicit

Public Const STR_EMPTY = ""
Public Const STR_SPACE = " "
Public Const STR_GENERIC_TICKS = "GENERICTICKS"
Public Const STR_SUBSCRIBED = "SUBSCRIBED"
Public Const STR_REQUESTED = "REQUESTED"
Public Const STR_RECEIVED = "RECEIVED"
Public Const STR_CANCELLED = "CANCELLED"
Public Const STR_FINISHED = "FINISHED"
Public Const STR_LONGVALUE = "LONGVALUE"
Public Const STR_ERROR = "error"
Public Const STR_STATUS = "status"
Public Const STR_ERROR_UPPER = "ERROR"
Public Const OPT = "OPT"
Public Const FUT = "FUT"
Public Const FOP = "FOP"
Public Const BAG = "BAG"
Public Const STK = "STK"
Public Const IOPT = "IOPT"
Public Const WAR = "WAR"
Public Const CASH = "CASH"
Public Const BOND = "BOND"
Public Const BILL = "BILL"
Public Const FIXED = "FIXED"
Public Const IND = "IND"
Public Const CPUT = "P"
Public Const CCALL = "C"
Public Const EXP_POINT = "!"
Public Const QMARK = "?"
Public Const PIPE_CHAR = "|"
Public Const EQUALS_SIGN = "="
Public Const UNDERSCORE = "_"
Public Const SPACE_CHAR = " " ' single space
Public Const COLON_CHAR = ":"
Public Const COMMA_CHAR = ","
Public Const MINUS_CHAR = "-"
Public Const IDENTIFIER_PREFIX = "id"
Public Const COMBO_LEG_COLUMN = 13
Public Const DELTA_NEUTRAL_COLUMN = 14
Public Const SERVER_NAME_CHAR = "S"
Public Const maxRowsToFormat = 200 ' increase this if your spreadsheets go beyond the 200th row
Public Const IDENTIFIER_ZERO = "id0"

' request ids
Public Const ID_REQ_MARKET_DATA = 100001
Public Const ID_REQ_POSITIONS_MULTI = 200001
Public Const ID_REQ_EXECUTIONS = 300001
Public Const ID_REQ_ACCOUNT_UPDATES_MULTI = 400001
Public Const ID_REQ_ACCOUNT_SUMMARY = 500001
Public Const ID_REQ_MARKET_DEPTH = 600001
Public Const ID_REQ_SCANNER_SUBSCRIPTION = 700001
Public Const ID_REQ_CONTRACT_DETAILS = 800001
Public Const ID_REQ_HISTORICAL_DATA = 900001
Public Const ID_REQ_REAL_TIME_BARS = 1000001
Public Const ID_REQ_TICK_BY_TICK_DATA = 1100001
Public Const ID_REQ_TICK_BY_TICK_DATA_EXT = 1200001
Public Const ID_REQ_FUNDAMENTAL_DATA = 1300001
Public Const ID_REQ_HISTORICAL_TICKS = 1400001
Public Const ID_REQ_SEC_DEF_OPT_PARAMS = 1500001
Public Const ID_REQ_HEAD_TIMESTAMP = 1600001
Public Const ID_REQ_MATCHING_SYMBOLS = 1700001
Public Const ID_REQ_NEWS_TICKS = 1800001
Public Const ID_REQ_HISTORICAL_NEWS = 1900001
Public Const ID_REQ_NEWS_ARTICLE = 2000001
Public Const ID_REQ_PNL = 2100001
Public Const ID_CALCULATE_IMPLIED_VOLATILITY = 2200001
Public Const ID_CALCULATE_OPTION_PRICE = 2300001
Public Const ID_EXERCISE_OPTIONS = 2400001
Public Const ID_REQ_SMART_COMPONENTS = 2500001
Public Const ID_REQ_HISTOGRAM_DATA = 2600001

Public Function createLongValue(theArray As Variant) As String
    Dim longValue As String
    Dim j As Integer
    For j = LBound(theArray) To UBound(theArray)
        longValue = longValue + theArray(j)
    Next j
    createLongValue = longValue
End Function

Public Function cleanOnError(cell As range) As Boolean
    If (CStr(cell.value) = "Error 2023") Or (CStr(cell.value) = "Error 2015") Then
        cell.value = ""
        cleanOnError = True
    Else
        cleanOnError = False
    End If
End Function

Public Function getServerVal(ByVal sheetName As String, ByVal descRangeName As String) As String
    Dim server As String
    server = Worksheets(sheetName).range(descRangeName).value
    If server = "" Or IsEmpty(server) Then
        MsgBox ("You must enter a valid user name.")
    End If
    getServerVal = SERVER_NAME_CHAR & server
End Function
Sub createComboLegs()
    ComboLegForm.Show
End Sub
Sub createTicker()
    TickerForm.ShowForm
End Sub

Function composeLink(server, topic, id, rawReq) As String
    composeLink = EQUALS_SIGN & server & PIPE_CHAR & topic & EXP_POINT & id & QMARK & rawReq
End Function

Public Function getIDpost(ByRef id As Long, ByVal someConstant As Long) As String
    getIDpost = IDENTIFIER_PREFIX & CStr(id + someConstant)
    id = id + 1
End Function

Public Function IsInArray(stringToBeFound As String, arr As Variant) As Boolean
  IsInArray = (UBound(Filter(arr, stringToBeFound)) > -1)
End Function

Public Function hasContractData(sheet As Worksheet, startingRow As Integer, cell As range, startIndex As Integer, contractColumnsArray As Variant) As Boolean

    Dim ret As Boolean
    ret = False

    If cell.row < startingRow Then
        ret = False
        GoTo hasContractDataEnd
    End If
    
    Dim i As Integer
    For i = 0 To UBound(contractColumnsArray) - LBound(contractColumnsArray)
        If contractColumnsArray(i) = "SECTYPE" And sheet.Cells(cell.row, i + startIndex).value <> STR_EMPTY Then
            ret = True
        End If
        If contractColumnsArray(i) = "CONID" And sheet.Cells(cell.row, i + startIndex).value <> STR_EMPTY Then
            ret = True
        End If
        If contractColumnsArray(i) = "SECIDTYPE" And sheet.Cells(cell.row, i + startIndex).value <> STR_EMPTY Then
            ret = True
        End If
    Next
    
hasContractDataEnd:
    hasContractData = ret
End Function

Public Function hasRequestData(sheet As Worksheet, startingRow As Integer, cell As range, columnIndex As Integer) As Boolean

    Dim ret As Boolean
    ret = False

    If cell.row < startingRow Then
        ret = False
        GoTo hasRequestDataEnd
    End If
    
    If sheet.Cells(cell.row, columnIndex).value <> STR_EMPTY Then
        ret = True
    End If
    
hasRequestDataEnd:
    hasRequestData = ret
End Function
Function trimSymbol(STR As String, symbol As String) As String
    Dim i As Integer
    Dim tempStr As String
    Dim tempSymbol As String
    tempStr = ""
    For i = 1 To Len(STR)
        tempSymbol = Mid(STR, i, 1)
        If tempSymbol <> symbol Then
            tempStr = tempStr & tempSymbol
        End If
    Next i
    trimSymbol = tempStr
End Function

' ========================================================
' send poke
' ========================================================
Sub sendPoke(sheet As Worksheet, serverName As String, topic As String, request As String, cell As range, startOfContractColumns As Integer, contractColumnsArray As Variant, genericTicksColumnIndex As Integer, idColumnIndex As Integer, _
        orderBaseColumnsStart As Integer, orderBaseColumnsEnd As Integer, orderExtColumnsStart As Integer, orderExtColumnsEnd As Integer)
    On Error Resume Next
    
    Dim rangeToPoke As range
    Set rangeToPoke = Nothing
    
    Dim chan As Integer, i As Integer
    chan = Application.DDEInitiate(serverName, topic)
    
    ' change contract values to sent
    If startOfContractColumns > 0 Then
        Dim oldValues() As String
        Dim oldFormats() As String
        
        
        Dim size As Integer
        size = UBound(contractColumnsArray) - LBound(contractColumnsArray)
    
        ReDim oldValues(size)
        ReDim oldFormats(size)

        For i = 0 To size
            If IsNumeric(sheet.Cells(cell.row, i + startOfContractColumns).Value2) Then
                oldFormats(i) = sheet.Cells(cell.row, i + startOfContractColumns).NumberFormat
                oldValues(i) = sheet.Cells(cell.row, i + startOfContractColumns).Value2
                
                sheet.Cells(cell.row, i + startOfContractColumns).NumberFormat = "@"
                sheet.Cells(cell.row, i + startOfContractColumns).Value2 = CStr(sheet.Cells(cell.row, i + startOfContractColumns).Value2)
            End If
        Next

        Set rangeToPoke = sheet.range(sheet.Cells(cell.row, 1), sheet.Cells(cell.row, size + 1))

    End If
    
    ' change generic ticks value to sent
    If genericTicksColumnIndex > 0 Then
        If sheet.Cells(cell.row, genericTicksColumnIndex).value <> util.STR_EMPTY Then
            Dim genericTicksOldStr As String
            Dim genericTicksOldFormat As String
            genericTicksOldStr = sheet.Cells(cell.row, genericTicksColumnIndex).Value2
            genericTicksOldFormat = sheet.Cells(cell.row, genericTicksColumnIndex).NumberFormat
            sheet.Cells(cell.row, genericTicksColumnIndex).NumberFormat = "@"
            sheet.Cells(cell.row, genericTicksColumnIndex).Value2 = CStr(sheet.Cells(cell.row, genericTicksColumnIndex).Value2)
        End If
        
        Set rangeToPoke = Union(rangeToPoke, sheet.range(sheet.Cells(cell.row, genericTicksColumnIndex), sheet.Cells(cell.row, genericTicksColumnIndex)))
    End If
        
    ' change order base values to sent
    If orderBaseColumnsStart > 0 And orderBaseColumnsEnd > 0 And orderBaseColumnsStart <= orderBaseColumnsEnd Then
        Dim oldOrderBaseValues() As String
        Dim oldOrderBaseFormats() As String
        ReDim oldOrderBaseValues(orderBaseColumnsEnd - orderBaseColumnsStart)
        ReDim oldOrderBaseFormats(orderBaseColumnsEnd - orderBaseColumnsStart)
        For i = 0 To orderBaseColumnsEnd - orderBaseColumnsStart
            If IsNumeric(sheet.Cells(cell.row, i + orderBaseColumnsStart).Value2) Then
                oldOrderBaseFormats(i) = sheet.Cells(cell.row, i + orderBaseColumnsStart).NumberFormat
                oldOrderBaseValues(i) = sheet.Cells(cell.row, i + orderBaseColumnsStart).Value2
                
                sheet.Cells(cell.row, i + orderBaseColumnsStart).NumberFormat = "@"
                sheet.Cells(cell.row, i + orderBaseColumnsStart).Value2 = CStr(sheet.Cells(cell.row, i + orderBaseColumnsStart).Value2)
            End If
        Next

        Set rangeToPoke = Union(rangeToPoke, sheet.range(sheet.Cells(cell.row, orderBaseColumnsStart), sheet.Cells(cell.row, orderBaseColumnsEnd)))
    End If
        
    ' change order extended values to sent
    If orderExtColumnsStart > 0 And orderExtColumnsEnd > 0 And orderExtColumnsStart <= orderExtColumnsEnd Then
        Dim oldOrderExtValues() As String
        Dim oldOrderExtFormats() As String
        ReDim oldOrderExtValues(orderExtColumnsEnd - orderExtColumnsStart)
        ReDim oldOrderExtFormats(orderExtColumnsEnd - orderExtColumnsStart)
        For i = 0 To orderExtColumnsEnd - orderExtColumnsStart
            If IsNumeric(sheet.Cells(cell.row, i + orderExtColumnsStart).Value2) Then
                oldOrderExtFormats(i) = sheet.Cells(cell.row, i + orderExtColumnsStart).NumberFormat
                oldOrderExtValues(i) = sheet.Cells(cell.row, i + orderExtColumnsStart).Value2

                sheet.Cells(cell.row, i + orderExtColumnsStart).NumberFormat = "@"
                sheet.Cells(cell.row, i + orderExtColumnsStart).Value2 = CStr(sheet.Cells(cell.row, i + orderExtColumnsStart).Value2)
            End If
        Next

        Set rangeToPoke = Union(rangeToPoke, sheet.range(sheet.Cells(cell.row, orderExtColumnsStart), sheet.Cells(cell.row, orderExtColumnsEnd)))
    End If
    
    ' sent values via DDEPoke
    If Not rangeToPoke Is Nothing Then
        Dim singleArea As range
        For Each singleArea In rangeToPoke.Areas
            Application.DDEPoke chan, request, singleArea
        Next singleArea
    End If
    
    ' restore initial contract values
    If startOfContractColumns > 0 Then
        For i = 0 To size
            If oldValues(i) <> STR_EMPTY Then
                sheet.Cells(cell.row, i + startOfContractColumns).NumberFormat = oldFormats(i)
                sheet.Cells(cell.row, i + startOfContractColumns).Value2 = oldValues(i)
            End If
        Next
    End If

    
    ' restore initial generic ticks value
    If genericTicksColumnIndex > 0 Then
        If genericTicksOldStr <> util.STR_EMPTY Then
            sheet.Cells(cell.row, genericTicksColumnIndex).NumberFormat = genericTicksOldFormat
            sheet.Cells(cell.row, genericTicksColumnIndex).Value2 = genericTicksOldStr
        End If
    End If
    
    ' restore initial order base values
    If orderBaseColumnsStart > 0 And orderBaseColumnsEnd > 0 And orderBaseColumnsStart <= orderBaseColumnsEnd Then
        For i = 0 To orderBaseColumnsEnd - orderBaseColumnsStart
            If oldOrderBaseValues(i) <> STR_EMPTY Then
                sheet.Cells(cell.row, i + orderBaseColumnsStart).NumberFormat = oldOrderBaseFormats(i)
                sheet.Cells(cell.row, i + orderBaseColumnsStart).Value2 = oldOrderBaseValues(i)
            End If
        Next
    End If
    
    ' restore initial order ext values
    If orderExtColumnsStart > 0 And orderExtColumnsEnd > 0 And orderExtColumnsStart <= orderExtColumnsEnd Then
        For i = 0 To orderExtColumnsEnd - orderExtColumnsStart
            If oldOrderExtValues(i) <> STR_EMPTY Then
                sheet.Cells(cell.row, i + orderExtColumnsStart).NumberFormat = oldOrderExtFormats(i)
                sheet.Cells(cell.row, i + orderExtColumnsStart).Value2 = oldOrderExtValues(i)
            End If
        Next
    End If
    
    Application.DDETerminate chan
End Sub

' ========================================================
' send poke simple
' ========================================================
Sub sendPokeSimple(sheet As Worksheet, serverName As String, topic As String, request As String, rangeToPoke)
    On Error Resume Next
    
    Dim oldValues() As String
    Dim oldFormats() As String
    Dim numOfColumns As Integer
    Dim i As Integer
    
    numOfColumns = rangeToPoke.Columns.count
    
    ReDim oldValues(numOfColumns)
    ReDim oldFormats(numOfColumns)

    Dim rowNumber As Integer
    rowNumber = rangeToPoke.row
    Dim columnNumber As Integer
    columnNumber = rangeToPoke.column
    
    For i = 0 To numOfColumns
        If IsNumeric(sheet.Cells(rowNumber, i + columnNumber).Value2) Then
            oldFormats(i) = sheet.Cells(rowNumber, i + columnNumber).NumberFormat
            oldValues(i) = sheet.Cells(rowNumber, i + columnNumber).Value2
            
            sheet.Cells(rowNumber, i + columnNumber).NumberFormat = "@"
            sheet.Cells(rowNumber, i + columnNumber).Value2 = CStr(sheet.Cells(rowNumber, i + columnNumber).Value2)
        End If
    Next i

    Dim chan As Integer
    chan = Application.DDEInitiate(serverName, topic)
    
    ' sent values via DDEPoke
    If Not rangeToPoke Is Nothing Then
        Application.DDEPoke chan, request, rangeToPoke
    End If
    
    Application.DDETerminate chan
    
        ' restore initial contract values
    For i = 0 To numOfColumns
        If oldValues(i) <> STR_EMPTY Then
            sheet.Cells(rowNumber, i + columnNumber).NumberFormat = oldFormats(i)
            sheet.Cells(rowNumber, i + columnNumber).Value2 = oldValues(i)
        End If
    Next

    
End Sub
' ========================================================
' send request
' ========================================================
Function sendRequest(serverName As String, topic As String, request As String) As Variant()
    On Error Resume Next
    Dim arr() As Variant
    Dim chan As Long
    chan = Application.DDEInitiate(serverName, topic)
    arr = Application.DDERequest(chan, request)
    
    Application.DDETerminate chan
    sendRequest = arr
End Function

' ========================================================
' get dimension of array
' ========================================================
Function getDimension(var As Variant) As Integer
    On Error GoTo Err
    Dim i As Long
    Dim tmp As Long
    i = 0
    Do While True
        i = i + 1
        tmp = UBound(var, i)
    Loop
Err:
    getDimension = i - 1
End Function

' ========================================================
' finds empty row in worksheet and returns its number
' ========================================================
Function findEmptyRow(sheet As Worksheet, startRow As Integer, endRow As Integer) As Integer
    Dim i As Integer
    For i = startRow To endRow
        If sheet.Cells(i, 1) = util.STR_EMPTY Then
            GoTo TheEnd
        End If
    Next i
TheEnd:
    findEmptyRow = i
End Function

' ========================================================
' returns current time in milliseconds
' ========================================================
Public Function TimeInMS() As String
    TimeInMS = Strings.Format(Now, "HH:nn:ss") & "." & Strings.right(Strings.Format(Timer, "#0.00"), 2)
End Function

' ========================================================
' this function finds sheet by name or adds new if sheet was not found
' returns new sheet
' ========================================================
Public Function FindOrAddSheet(sheetName As String, ByRef needsInitialising As Boolean) As Worksheet
    needsInitialising = True
    
    Dim active As Object
    Set active = ActiveSheet
    
    Dim ws As Worksheet
    For Each ws In Worksheets
        If ws.name = sheetName Then
            ' sheet was found
            needsInitialising = (ws.Cells(1, 1) = 0)
            Exit For
        End If
    Next
    
    If ws Is Nothing Then
        ' sheet was not found
        needsInitialising = True
        Set ws = Sheets.Add(Type:=xlWorksheet)
        
        With ws
            .Move after:=Worksheets(Worksheets.count)
            .name = sheetName
            ActiveWindow.Zoom = 80
        End With
    End If
    
    active.Activate
    Set FindOrAddSheet = ws
End Function

' ========================================================
' Updates sheet with table/array
' ========================================================
Public Sub updateSheetWithArray(sheetName As String, theArray As Variant, activateSheet As Boolean, headerText As String, headerColumns As Variant, _
        doAutoFit As Boolean, appendNewRows As Boolean, appendNewRowsKeyColumn As Long, clearTable As Boolean)

    If sheetName = util.STR_EMPTY Or IsNumeric(sheetName) Then Exit Sub
    
    Dim dimension As Integer
    dimension = util.getDimension(theArray)
    
    If dimension <= 0 Then Exit Sub
    
    Dim sheet As Worksheet
    Dim needsInitializing As Boolean
    Set sheet = util.FindOrAddSheet(sheetName, needsInitializing)
    
    Dim numOfRows As Long
    Dim numOfColumns As Long
    
    Dim i As Long, j As Long, n As Long
    Dim rowNum As Long
    Dim value As String
    
    If dimension = 2 Then
        numOfRows = UBound(theArray, 1) - LBound(theArray, 1) + 1
        numOfColumns = UBound(headerColumns, 1) - LBound(headerColumns, 1)
        If needsInitializing Then InitializeSheet sheet, numOfRows, headerText, headerColumns
        
        If clearTable Then
            clearSheet sheet
        End If
        
        For i = 1 To UBound(theArray, 1) - LBound(theArray, 1) + 1
            Dim subArray As Variant
            n = UBound(theArray, 2) - 1
            ReDim subArray(n)
            For j = 1 To UBound(theArray, 2) - LBound(theArray, 2) + 1
                subArray(j - 1) = theArray(i, j)
            Next j
            
            value = subArray(0)
            If appendNewRows Then
                rowNum = findLineRow(sheet, appendNewRowsKeyColumn, value)
            Else
                rowNum = i + 2
            End If
            
            InitializeSingleRow sheet, rowNum, headerColumns
            updateSheetWithLine sheet, subArray, rowNum, 1, "General", "General"
        Next i
        resizeColumns numOfRows, numOfColumns, sheet, doAutoFit
    ElseIf dimension = 1 Then
        numOfRows = 1
        numOfColumns = UBound(headerColumns, 1) - LBound(headerColumns, 1)
        If needsInitializing Then InitializeSheet sheet, numOfRows, headerText, headerColumns
        
        If clearTable Then
            clearSheet sheet
        End If
        
        subArray = theArray
        
        value = subArray(1)
        If appendNewRows Then
            rowNum = findLineRow(sheet, appendNewRowsKeyColumn, value)
        Else
            rowNum = 3
        End If
        InitializeSingleRow sheet, rowNum, headerColumns
        updateSheetWithLine sheet, subArray, rowNum, 1, "General", "General"
        resizeColumns numOfRows, numOfColumns, sheet, doAutoFit
    End If
    
    If activateSheet Then
        sheet.Activate
    End If
    
End Sub

' ========================================================
' Resizes columns to autofit
' ========================================================
Private Sub resizeColumns(numOfRows As Long, numOfColumns As Long, sheet As Worksheet, doAutoFit As Boolean)
    Dim i As Long, j As Long
    Dim maxWidthOfColumn As Integer
    If doAutoFit Then
        sheet.Cells.EntireColumn.AutoFit
    Else
        For i = 1 To numOfColumns
            maxWidthOfColumn = 0
            For j = 1 To numOfRows
                If Len(CStr(sheet.Cells(2 + j, i))) > maxWidthOfColumn Then
                    maxWidthOfColumn = Len(CStr(sheet.Cells(2 + j, i)))
                End If
            Next j
            If maxWidthOfColumn <= 10 Then
                sheet.Cells(1, i).EntireColumn.AutoFit
            End If
        Next i
    End If
End Sub

' ========================================================
' Updates sheet with single line (array)
' ========================================================
Public Sub updateSheetWithLine(sheet As Worksheet, subArray As Variant, startLine As Long, startColumn As Long, cellFormat1 As String, cellFormat2 As String)
    
    Dim tableIndex As Long, arrayIndex As Long
        tableIndex = 1
        For arrayIndex = LBound(subArray) To UBound(subArray)
            Dim val As String
            val = getLongValue(subArray, arrayIndex)
            
            If CStr(sheet.Cells(startLine, startColumn + tableIndex)) <> CStr(val) And CStr(val) <> util.STR_EMPTY Then
                sheet.Cells(startLine, startColumn + tableIndex - 1).NumberFormat = cellFormat1
                sheet.Cells(startLine, startColumn + tableIndex - 1).value = CStr(val)
                sheet.Cells(startLine, startColumn + tableIndex - 1).NumberFormat = cellFormat2
            End If
            tableIndex = tableIndex + 1
            
        Next arrayIndex
End Sub

' ========================================================
' Extracts long value from array
' ========================================================
Private Function getLongValue(theArray As Variant, ByRef arrayIndex As Long) As String
            
    Dim k As Long
    Dim val As String
    val = theArray(arrayIndex)

    If InStr(val, "LONGVALUE_") <> 0 Then
        Dim numOfChunks As Long
        numOfChunks = CInt(Mid(val, 11))
        Dim longStr As String
        longStr = ""
        For k = 1 To numOfChunks
            longStr = longStr + theArray(k + arrayIndex)
        Next k
        arrayIndex = arrayIndex + k - 1
        val = longStr
    End If
        
    getLongValue = val

End Function

' ========================================================
' Initializes sheet
' ========================================================
Private Sub InitializeSheet(sheet As Worksheet, numOfRows As Long, headerText As String, headerColumns As Variant)
    sheet.Cells.ClearContents
    
    sheet.Cells(1, 1).value = headerText
    Dim numOfColumns As Long
    numOfColumns = UBound(headerColumns) - LBound(headerColumns) + 1
    
    ' header
    With sheet.range(sheet.Cells(1, 1), sheet.Cells(1, numOfColumns))
        .Interior.Color = RGB(0, 0, 128)
        .Font.Color = RGB(255, 255, 255)
        .Font.Bold = True
        .HorizontalAlignment = xlCenter
        .Merge
        .Borders.LineStyle = xlContinuous
    End With
    Dim i As Long
    ' columns
    For i = 0 To numOfColumns - 1
        With sheet.Cells(2, i + 1)
            .Interior.Color = RGB(181, 181, 181)
            .value = headerColumns(i)
            .Borders.LineStyle = xlContinuous
        End With
    Next i
End Sub

' ========================================================
' Initializes single row
' ========================================================
Private Sub InitializeSingleRow(sheet As Worksheet, numOfRow As Long, headerColumns As Variant)
    Dim j As Long
    Dim numOfColumns As Long
    numOfColumns = UBound(headerColumns) - LBound(headerColumns) + 1
    For j = 1 To numOfColumns
        With sheet.Cells(numOfRow, j)
            .Interior.Color = RGB(69, 69, 69)
            .Font.Color = RGB(255, 255, 16)
            .Borders.LineStyle = xlContinuous
        End With
    Next j

End Sub

' ===================================================================
' Finds row in sheet by value in column, if not found, then "new row"
' ===================================================================
Private Function findLineRow(sheet As Worksheet, column As Long, value As String) As Long
    Dim row As Long, i As Long
    For i = 3 To 65536
        If column = 0 Then
            ' find empty row
            If sheet.Cells(i, 1).value = util.STR_EMPTY Then
                row = i
                GoTo FindLineEnd
            End If
        ElseIf CStr(sheet.Cells(i, column).value) = value Or _
            sheet.Cells(i, column).value = util.STR_EMPTY Then
            ' find empty row or replace existing
            row = i
            GoTo FindLineEnd
        End If
    Next i

FindLineEnd:
    findLineRow = row
End Function

' ===================================================================
' Clears sheet rows
' ===================================================================
Private Sub clearSheet(sheet As Worksheet)
    Dim i As Long
    For i = 3 To 65536
        sheet.rows(i).ClearContents
    Next i
End Sub

' ========================================================
' header columns for XML
' ========================================================
Public Function getHeaderColumnsForXML() As Variant()
    getHeaderColumnsForXML = Array("XML")
End Function



