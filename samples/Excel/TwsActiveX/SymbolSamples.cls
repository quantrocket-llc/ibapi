VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SymbolSamples"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

'=================
' local constants
'=================

Const CELL_PATTERN = "A6"

Private Enum SymbolSamplesTableColumns
    Col_SYMBOL_SAMPLES_CONID = 1
    Col_SYMBOL_SAMPLES_SYMBOL
    Col_SYMBOL_SAMPLES_SECTYPE
    Col_SYMBOL_SAMPLES_PRIMARYEXCHANGE
    Col_SYMBOL_SAMPLES_CURRENCY
    Col_SYMBOL_SAMPLES_DERIVATIVESECTYPES
    Col_SYMBOL_SAMPLES_DESCRIPTION
    Col_SYMBOL_SAMPLES_ISSUERID
End Enum

Private activeReqId As Long

Private symbolSamplesTable As Range

'=================
' private methods
'=================

Public Sub Initialise()
    Set symbolSamplesTable = Range("$A$10:$H$50")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
    activeReqId = 0
End Sub

' request matching symbols
Private Sub reqMatchingSymbolsButton_Click()
    If Not CheckConnected Then Exit Sub
    
    ' clear symbol samples table
    symbolSamplesTable.ClearContents
    activeReqId = activeReqId + 1
    Api.Tws.reqMatchingSymbols activeReqId, Range(CELL_PATTERN).value
End Sub

' clear symbol samples table
Private Sub clearSymbolSamplesButton_Click()
    symbolSamplesTable.ClearContents
End Sub

'=================
' public methods
'=================
' symbol samples
Public Sub SymbolSamples(ByVal reqId As Long, ByVal contractDescriptions As TWSLib.IContractDescriptionList)
    If activeReqId = reqId Then
        Dim cd As TWSLib.ComContractDescription
        Dim derivativeSecTypesStr As String
        
        Dim i As Long
        For i = 0 To contractDescriptions.Count
            Set cd = contractDescriptions.Item(i)
            symbolSamplesTable(i + 1, Col_SYMBOL_SAMPLES_CONID).value = cd.contract.conId
            symbolSamplesTable(i + 1, Col_SYMBOL_SAMPLES_SYMBOL).value = cd.contract.Symbol
            symbolSamplesTable(i + 1, Col_SYMBOL_SAMPLES_SECTYPE).value = cd.contract.SecType
            symbolSamplesTable(i + 1, Col_SYMBOL_SAMPLES_PRIMARYEXCHANGE).value = cd.contract.primaryExchange
            symbolSamplesTable(i + 1, Col_SYMBOL_SAMPLES_CURRENCY).value = cd.contract.currency
            
            derivativeSecTypesStr = ""
            
            Dim j As Long
            For j = 0 To cd.derivativeSecTypes.Count - 1
                derivativeSecTypesStr = derivativeSecTypesStr & cd.derivativeSecTypes.Item(j) & Space(1)
            Next
            symbolSamplesTable(i + 1, Col_SYMBOL_SAMPLES_DERIVATIVESECTYPES).value = derivativeSecTypesStr
            symbolSamplesTable(i + 1, Col_SYMBOL_SAMPLES_DESCRIPTION).value = cd.contract.Description
            symbolSamplesTable(i + 1, Col_SYMBOL_SAMPLES_ISSUERID).value = cd.contract.issuerId
        Next
        
    End If
End Sub

