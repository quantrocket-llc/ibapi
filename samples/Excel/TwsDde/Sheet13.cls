VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet13"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Dim genId As Integer

Const reqOffset = 4
Const controlCol = 1
Const pageCol = controlCol + 1
Const activateCol = controlCol + 2
Const baseX = 2
Const baseY = 2
Const topic = "scan"
Const monitorStart = "firstScanRow"
Const monitorEnd = "lastScanRow"
Const serverCell = "scanServer"
Const errorRange = "scanErrorPosition"
Const scanCtrl = "scanCtrl"

Sub Worksheet_Calculate()
    Dim rowMod As Integer, cellStatus As String
    On Error Resume Next
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
            Call ArrayQueries.populatePage(theName, theName, TheArray, baseX, baseY, Cells(rowMod, activateCol).value)
        End If
    Next rowMod
End Sub
Sub requestScannerData()
Attribute requestScannerData.VB_ProcData.VB_Invoke_Func = "S\n14"
    Dim server As String, req As String, reqType As String, id As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    id = util.getIDpost(genId)
    reqType = "req"
   
    ' specify query
    Dim numberOfRows As String, instrument As String, locationCode As String, scanCode As String, _
        abovePrice As String, belowPrice As String, aboveVolume As String, _
        averageOptionVolumeAbove As String, marketCapAbove As String, marketCapBelow As String, _
        moodyRatingAbove As String, moodyRatingBelow As String, _
        spRatingAbove As String, spRatingBelow As String, maturityDateAbove As String, _
        maturityDateBelow As String, couponRateAbove As String, couponRateBelow As String, _
        excludeConvertible As String, scannerSettingPairs As String, stockTypeFilter As String
    
    Dim theRow As Integer
    theRow = ActiveCell.row
    scanCode = UCase(Cells(theRow, reqOffset + 0).value)
    instrument = UCase(Cells(theRow, reqOffset + 1).value)
    locationCode = UCase(Cells(theRow, reqOffset + 2).value)
    stockTypeFilter = UCase(Cells(theRow, reqOffset + 3).value)
    numberOfRows = UCase(Cells(theRow, reqOffset + 4).value)
    abovePrice = UCase(Cells(theRow, reqOffset + 5).value)
    belowPrice = UCase(Cells(theRow, reqOffset + 6).value)
    aboveVolume = UCase(Cells(theRow, reqOffset + 7).value)
    averageOptionVolumeAbove = UCase(Cells(theRow, reqOffset + 8).value)
    marketCapAbove = UCase(Cells(theRow, reqOffset + 9).value)
    marketCapBelow = UCase(Cells(theRow, reqOffset + 10).value)
    moodyRatingAbove = UCase(Cells(theRow, reqOffset + 11).value)
    moodyRatingBelow = UCase(Cells(theRow, reqOffset + 12).value)
    spRatingAbove = UCase(Cells(theRow, reqOffset + 13).value)
    spRatingBelow = UCase(Cells(theRow, reqOffset + 14).value)
    maturityDateAbove = UCase(Cells(theRow, reqOffset + 15).value)
    maturityDateBelow = UCase(Cells(theRow, reqOffset + 16).value)
    couponRateAbove = UCase(Cells(theRow, reqOffset + 17).value)
    couponRateBelow = UCase(Cells(theRow, reqOffset + 18).value)
    excludeConvertible = UCase(Cells(theRow, reqOffset + 19).value)
    scannerSettingPairs = UCase(Cells(theRow, reqOffset + 20).value)
    
    If instrument = "" Or locationCode = "" Or scanCode = "" Then
        MsgBox "You must enter all of scanCode, locationCode, and instrument"
        Exit Sub
    End If

    req = util.cleanUnderscore(scanCode) & util.UNDERSCORE & instrument & util.UNDERSCORE & _
        locationCode & util.UNDERSCORE & util.orEmpty(stockTypeFilter) & util.UNDERSCORE & _
        util.orEmpty(numberOfRows) & util.UNDERSCORE & util.orEmpty(abovePrice) & util.UNDERSCORE & _
        util.orEmpty(belowPrice) & util.UNDERSCORE & util.orEmpty(aboveVolume) & util.UNDERSCORE & _
        util.orEmpty(averageOptionVolumeAbove) & util.UNDERSCORE & util.orEmpty(marketCapAbove) & util.UNDERSCORE & _
        util.orEmpty(marketCapBelow) & util.UNDERSCORE & util.orEmpty(moodyRatingAbove) & util.UNDERSCORE & _
        util.orEmpty(moodyRatingBelow) & util.UNDERSCORE & util.orEmpty(spRatingAbove) & util.UNDERSCORE & _
        util.orEmpty(spRatingBelow) & util.UNDERSCORE & util.orEmpty(maturityDateAbove) & util.UNDERSCORE & _
        util.orEmpty(maturityDateBelow) & util.UNDERSCORE & util.orEmpty(couponRateAbove) & util.UNDERSCORE & _
        util.orEmpty(couponRateBelow) & util.UNDERSCORE & util.orEmpty(excludeConvertible) & util.UNDERSCORE & _
        util.orEmpty(scannerSettingPairs)
    
    ' Place req in spreadsheet
    
    Cells(theRow, controlCol).Formula = util.composeControlLink(server, topic, id, reqType, req)
    ActiveCell.offset(1, 0).Activate ' move cursor down
End Sub
Sub onShowError()
    Call showLastError(serverCell, errorRange)
End Sub
Sub cancelScannerData()
    Cells(ActiveCell.row, controlCol).ClearContents 'To cancel scanner subscription simply remove the control cell
End Sub
Sub clearLinks()
    Call clearErrorDisplay(errorRange)
    Call util.clearRange(scanCtrl, util.darkGreyColorIndex, xlShiftUp)
End Sub

