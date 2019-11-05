VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "HeadTimestamp"
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

Private Enum HeadTimestampColumns
    Col_HEADTIMESTAMP = 1
End Enum

Private contractTable As Range
Private querySpecificationTable As Range
Private headTimestampTable As Range

'==================
' methods
'==================


' clear head timestemp table
Private Sub ClearHeadTimestampTable_Click()
    headTimestampTable.ClearContents
End Sub

' create ticker
Private Sub CreateTicker_Click()
    TickerForm.ShowForm contractTable
End Sub

' request head timestemp
Public Sub RequestHeadTimestamp_Click()
Attribute RequestHeadTimestamp_Click.VB_Description = "Request Real Time Bars"
Attribute RequestHeadTimestamp_Click.VB_ProcData.VB_Invoke_Func = "T\n14"
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
            Dim useRTH As Long
            whatToShow = STR_EMPTY
            useRTH = True
    
            whatToShow = UCase(querySpecificationTable(id, Col_WHATTOSHOW).value)
            useRTH = querySpecificationTable(id, Col_RTHONLY).value
    
            ' update subscription status column
            querySpecificationTable(id, Col_STATUS).value = STR_PROCESSING
            
            ' call reqHeadTimestamp method
            Api.Tws.reqHeadTimestamp id + ID_HEADTIMESTAMP, lContractInfo, whatToShow, useRTH, 1
        End If
    Next
    
    ActiveCell.Offset(1, 0).Activate
End Sub

' update table with new data
Public Sub UpdateHeadTimestamp(ByVal tickerId As Long, ByVal timeStamp As String)
    
    tickerId = tickerId - ID_HEADTIMESTAMP
    headTimestampTable(tickerId, Col_HEADTIMESTAMP).value = timeStamp
    querySpecificationTable(tickerId, Col_STATUS).value = STR_EMPTY
End Sub

Public Sub ProcessError(ByVal id As Long, ByVal errorCode As Long, ByVal errorMsg As String)
    
    querySpecificationTable(id - ID_HEADTIMESTAMP, Col_STATUS).value = STR_ERROR + STR_COLON + Str(errorCode) + STR_SPACE + errorMsg
        
End Sub

Public Sub Initialise()
    Set contractTable = Range("$A$7:$K$130")
    Set querySpecificationTable = Range("$L$7:$N$130")
    Set headTimestampTable = Range("$O$7:$O$130")
End Sub


Private Sub Worksheet_Activate()
    Main.Initialise
    
    Dim macroName As String
    macroName = "HeadTimestamp.RequestHeadTimestamp_Click"
    
    Application.OnKey "+^t", macroName
End Sub

Private Sub Worksheet_Deactivate()
    Application.OnKey "+^t"
End Sub


