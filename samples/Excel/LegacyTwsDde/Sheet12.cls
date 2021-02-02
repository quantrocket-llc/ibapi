VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet12"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Integer

Const reqOffset = 11
Const controlCol = 12
Const pageCol = 19
Const baseX = 2
Const baseY = 2
Const topic = "hist"
Const monitorStart = "firstHistRow"
Const monitorEnd = "lastHistRow"
Const serverCell = "histServer"
Const errorRange = "histErrorPosition"
Const histCtrl = "histCtrl"

Sub Worksheet_Calculate()
    On Error Resume Next
    Dim cellStatus As String, rowMod As Integer
    For rowMod = Range(monitorStart).value To Range(monitorEnd).value
        cellStatus = Cells(rowMod, controlCol).value
        If cellStatus = ArrayQueries.RECEIVED Then
            Dim server As String, id As String, request As String, theName As String, TheArray() As Variant
            server = util.getServerVal(serverCell)
            If server = "" Then Exit Sub
            id = ArrayQueries.extractid(Cells(rowMod, controlCol).Formula)
            request = ArrayQueries.idToRequest(id)
            TheArray = ArrayQueries.doRequest(server, topic, request)
            theName = ArrayQueries.composeName(Cells(rowMod, pageCol).value, id, topic)
            Call populatePage(theName, theName, TheArray, baseX, baseY, True)
        End If
    Next rowMod
End Sub
Sub cancelHistoricalData()
    Cells(ActiveCell.row, controlCol).Formula = "" 'To cancel historical data request simply remove the control cell
End Sub
Sub requestHistoricalData()
Attribute requestHistoricalData.VB_ProcData.VB_Invoke_Func = "H\n14"
    Dim server As String, req As String, reqType As String, id As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    If Not util.composeContractReq(ActiveCell, req, reqType, True) Then Exit Sub
    id = util.getIDpost(genId)
    
    Dim endDateTime As String, duration As String, barSize As String, whatToShow As String, _
        rthOnly As String, dateFormatStyle As String, allowExpired As String
    endDateTime = UCase(ActiveCell.offset(0, reqOffset + 1).value)
    duration = UCase(ActiveCell.offset(0, reqOffset + 2).value)
    barSize = UCase(ActiveCell.offset(0, reqOffset + 3).value)
    whatToShow = UCase(ActiveCell.offset(0, reqOffset + 4).value)
    rthOnly = UCase(ActiveCell.offset(0, reqOffset + 5).value)
    dateFormatStyle = UCase(ActiveCell.offset(0, reqOffset + 6).value)
    allowExpired = UCase(ActiveCell.offset(0, reqOffset + 8).value)
    If allowExpired <> "" Then
        allowExpired = util.UNDERSCORE & allowExpired
    End If
    
    If endDateTime = "" Or duration = "" Or barSize = "" Or whatToShow = "" Or rthOnly = "" Or dateFormatStyle = "" Then
        MsgBox ("You must enter all of endDateTime, duration type, barSize, whatToShow, rthOnly, and dateFormatStyle.")
        Exit Sub
    End If
    
    req = req & endDateTime & util.UNDERSCORE & duration & util.UNDERSCORE & _
        barSize & util.UNDERSCORE & whatToShow & util.UNDERSCORE & rthOnly & util.UNDERSCORE & _
        dateFormatStyle & allowExpired

    Cells(ActiveCell.row, controlCol).Formula = util.composeControlLink(server, topic, id, reqType, req)
    ActiveCell.offset(1, 0).Activate ' move cursor down
End Sub
Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub
Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call util.clearRange(histCtrl, util.darkGreyColorIndex, xlShiftUp)
End Sub
