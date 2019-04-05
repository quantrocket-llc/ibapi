VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "RealTimeBars"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Private Enum QuerySpecificationColumns
    Col_WHATTOSHOW = 1
    Col_RTHONLY
    Col_STATUS
End Enum

Private Enum RealtimeBarsColumns
    Col_TIME = 1
    Col_OPEN
    Col_HIGH
    Col_LOW
    Col_CLOSE
    Col_VOLUME
    Col_WAP
    Col_COUNT
End Enum

Private contractTable As Range
Private querySpecificationTable As Range
Private realtimeBarsTable As Range

'==================
' methods
'==================
' cancel real time bars subscription
Private Sub CancelRealTimeBars_Click()
    CancelRealTimeBarsSubscription Selection
    
    ActiveCell.Offset(1, 0).Activate
End Sub

Private Sub CancelRealTimeBarsSubscription(sel As Range)
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer

    Dim row As Object
    For Each row In sel.Rows
        id = row.row - contractTable.Rows(1).row + 1
    
        ' cancel only "subscribed"
        If querySpecificationTable(id, Col_STATUS).value = STR_SUBSCRIBED Then

            ' update subscription status column
            querySpecificationTable(id, Col_STATUS).value = STR_EMPTY
        
            Api.Tws.CancelRealTimeBars id + ID_REALTIMEBARS
        End If
        
    Next
End Sub


' clear real time bars table
Private Sub ClearRealTimeBarsTable_Click()
    If IsConnected Then CancelRealTimeBarsSubscription contractTable
    realtimeBarsTable.ClearContents
End Sub

' create ticker
Private Sub CreateTicker_Click()
    TickerForm.ShowForm contractTable
End Sub

' request real time bars
Public Sub RequestRealTimeBars_Click()
Attribute RequestRealTimeBars_Click.VB_Description = "Request Real Time Bars"
Attribute RequestRealTimeBars_Click.VB_ProcData.VB_Invoke_Func = "T\n14"
    If Not CheckConnected Then Exit Sub
    
    Dim id As Integer

    Dim row As Object
    For Each row In Selection.Rows
        id = row.row - contractTable.Rows(1).row + 1

        If contractTable(id, Col_SECTYPE).value <> STR_EMPTY Then

            ' create contract
            Dim lContractInfo As TWSLib.IContract
            Set lContractInfo = Api.Tws.createContract()
    
            ' fill contract structure
            With lContractInfo
                .Symbol = UCase(contractTable(id, Col_SYMBOL).value)
                .SecType = UCase(contractTable(id, Col_SECTYPE).value)
                .lastTradeDateOrContractMonth = contractTable(id, Col_LASTTRADEDATE).value
                .Strike = contractTable(id, Col_STRIKE).value
                .Right = IIf(UCase(contractTable(id, Col_RIGHT).value) = "", 0#, UCase(contractTable(id, Col_RIGHT).value))
                .multiplier = UCase(contractTable(id, Col_MULTIPLIER).value)
                .exchange = UCase(contractTable(id, Col_EXCH).value)
                .primaryExchange = UCase(contractTable(id, Col_PRIMEXCH).value)
                .currency = UCase(contractTable(id, Col_CURRENCY).value)
                .localSymbol = UCase(contractTable(id, Col_LOCALSYMBOL).value)
                .conId = IIf(UCase(contractTable(id, Col_CONID).value) = "", 0, UCase(contractTable(id, Col_CONID).value))
            End With
    
            ' query specification
            Dim whatToShow As String
            Dim barSize As Long
            Dim useRTH As Long
            barSize = 5
            whatToShow = STR_EMPTY
            useRTH = True
    
            whatToShow = UCase(querySpecificationTable(id, Col_WHATTOSHOW).value)
            useRTH = querySpecificationTable(id, Col_RTHONLY).value
    
            ' real time bars options
            Dim realTimeBarsOptions As TWSLib.ITagValueList
            Set realTimeBarsOptions = Api.Tws.createTagValueList()
    
            ' update subscription status column
            querySpecificationTable(id, Col_STATUS).value = STR_SUBSCRIBED
            
            ' call reqRealTimeBarsEx method
            Api.Tws.reqRealTimeBarsEx id + ID_REALTIMEBARS, lContractInfo, barSize, whatToShow, useRTH, realTimeBarsOptions
        End If
    Next
    
    ActiveCell.Offset(1, 0).Activate
End Sub

' update table with new data
Public Sub UpdateRealTimeBars(ByVal tickerId As Long, ByVal rtbTime As Long, ByVal rtbOpen As Double, ByVal rtbHigh As Double, ByVal rtbLow As Double, ByVal rtbClose As Double, ByVal rtbVolume As Long, ByVal rtbWAP As Double, ByVal rtbCount As Long)
    
    tickerId = tickerId - ID_REALTIMEBARS
    realtimeBarsTable(tickerId, Col_TIME).value = Util.ConvertLongToDateStr(rtbTime)
    realtimeBarsTable(tickerId, Col_OPEN).value = rtbOpen
    realtimeBarsTable(tickerId, Col_HIGH).value = rtbHigh
    realtimeBarsTable(tickerId, Col_LOW).value = rtbLow
    realtimeBarsTable(tickerId, Col_CLOSE).value = rtbClose
    realtimeBarsTable(tickerId, Col_VOLUME).value = rtbVolume
    realtimeBarsTable(tickerId, Col_WAP).value = rtbWAP
    realtimeBarsTable(tickerId, Col_COUNT).value = rtbCount

End Sub

Public Sub ProcessError(ByVal id As Long, ByVal errorCode As Long, ByVal errorMsg As String)
    
    querySpecificationTable(id - ID_REALTIMEBARS, Col_STATUS).value = STR_ERROR + STR_COLON + Str(errorCode) + STR_SPACE + errorMsg
        
End Sub

Public Sub Initialise()
    Set contractTable = Range("$A$7:$K$130")
    Set querySpecificationTable = Range("$L$7:$N$130")
    Set realtimeBarsTable = Range("$O$7:$V$130")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
    
    Dim macroName As String
    macroName = "RealTimeBars.RequestRealTimeBars_Click"
    
    Application.OnKey "+^t", macroName
End Sub

Private Sub Worksheet_Deactivate()
    Application.OnKey "+^t"
End Sub


