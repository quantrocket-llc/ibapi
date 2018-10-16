Attribute VB_Name = "ArrayQueries"
Option Explicit

Public Const FINISHED = "FINISHED"
Public Const SUBSCRIBED = "SUBSCRIBED"
Public Const RECEIVED = "RECEIVED"
Public Const QRESULT = "?result"
Public Const DO_NOT_SPECIFY_WIDTH = -1
Function doRequest(serverName, topic, request) As Variant()
    Dim chan As Integer
    chan = Application.DDEInitiate(serverName, topic)
    doRequest = Application.DDERequest(chan, request)
    Application.DDETerminate chan
End Function
Function doRequestForce2D(serverName, topic, request) As Variant()
    Dim result() As Variant
    result = doRequest(serverName, topic, request)
    If util.arrayDims(result) = 1 Then
        Dim TwoDArray() As Variant, ctr As Integer
        ReDim Preserve TwoDArray(1 To 1, 1 To UBound(result))
        For ctr = 1 To UBound(result)
            TwoDArray(1, ctr) = result(ctr)
        Next
        doRequestForce2D = TwoDArray
    Else
        doRequestForce2D = result
    End If
End Function
Function extractRequest(server, topic, reqStr)
    extractRequest = idToRequest(extractid(server, topic, reqStr))
End Function
Function idToRequest(theId)
    idToRequest = theId & QRESULT
End Function
Function extractid(reqStr)
    Dim idStart As Integer, idEnd As Integer
    Dim cleanedReq As String
    cleanedReq = Replace(reqStr, util.TICK_CHAR, "")
    idStart = InStr(cleanedReq, "!id") + 1
    idEnd = InStr(cleanedReq, "?")
    extractid = Mid(cleanedReq, idStart, idEnd - idStart)
End Function
Function composeName(suppliedName, id, topic)
    If suppliedName = "" Then
        composeName = topic + id
    Else
        composeName = suppliedName
    End If
End Function
Sub populatePage(ByVal worksheetName As String, ByVal descRangeName As String, ByRef TheArray() As Variant, _
                 ByVal baseX As Integer, ByVal baseY As Integer, Optional ByVal activatePage As Boolean = False, _
                 Optional widthToUse As Integer = DO_NOT_SPECIFY_WIDTH)
                 
Dim theWorksheet As Worksheet

descRangeName = util.cleanName(descRangeName)

On Error GoTo worksheetCheckDone

If worksheetName = util.USE_ACTIVE_WORKSHEET Then
    Set theWorksheet = ActiveSheet
    worksheetName = theWorksheet.name
Else
    Set theWorksheet = Sheets(worksheetName)
End If

worksheetCheckDone:

If theWorksheet Is Nothing Then
    Dim currentWorksheet As Worksheet
    Set currentWorksheet = ActiveSheet
    Set theWorksheet = ActiveWorkbook.Sheets.add(, Sheets(Worksheets.Count))
    theWorksheet.name = worksheetName
    If Not activatePage Then
        currentWorksheet.Activate
    End If
Else
    On Error GoTo rangeCleared
   
    Dim theRange As Range
    Set theRange = theWorksheet.Range(descRangeName)
    theRange.Formula = ""
    ActiveWorkbook.Names(descRangeName).Delete
    If activatePage Then
        theWorksheet.Activate
    End If
rangeCleared:

End If

Dim xSize As Integer, ySize As Integer, endX As Integer, endY As Integer
If util.arrayDims(TheArray) = 1 Then
    ySize = 1
    xSize = UBound(TheArray, 1)
Else
    ySize = UBound(TheArray, 1)
    xSize = UBound(TheArray, 2)
End If
    
endY = baseY + ySize - 1
endX = baseX + xSize - 1

Dim builtRange As Range
Set builtRange = util.buildRange(worksheetName, descRangeName, baseX, baseY, endX, endY)
builtRange.FormulaArray = TheArray
If xSize < widthToUse Then
    endX = baseX + widthToUse - 1
    Call util.buildRange(worksheetName, descRangeName, baseX, baseY, endX, endY)
End If

End Sub

Sub testPopulatePage()
Const arHeight = 5
Const arWidth = 8

Dim TheArray2(arHeight, arWidth)

For ctrY = 0 To arHeight - 1

For ctrX = 0 To arWidth - 1

TheArray2(ctrY, ctrX) = ctrY * 1000 + ctrX

Next ctrX

Next ctrY

Call populatePage("Stock2", "PopulateMe", TheArray2, 2, 2)

Const arLength = 12

Dim TheArray3(arLength)

For ctr3 = 0 To arLength - 1
    TheArray3(ctr3) = ctr3 * ctr3 * ctr3
Next

Call populatePage("Stock2", "PopulateMe2", TheArray3, 2, 20)

End Sub
