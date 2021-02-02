Attribute VB_Name = "ErrorDisplay"
Option Explicit

Const topic = "err"

Sub clearErrorDisplay(ByVal positionRange As String)
    Dim theRange As Range
    Set theRange = Range(Range(positionRange), Range(positionRange).offset(2, 2))
    theRange.Clear
    theRange.ClearFormats
End Sub
Sub showLastError(ByVal serverName As String, ByVal positionRange As String)
Attribute showLastError.VB_Description = "Macro recorded 8/23/2002 by abozkurt"
Attribute showLastError.VB_ProcData.VB_Invoke_Func = " \n14"
    Dim server As String, req As String, reqType As String, id As String, secType As String
    server = util.getServerStr(serverName)
    If server = "" Then Exit Sub
    
    Dim theRange As Range
    Set theRange = Range(positionRange)
    theRange.FormulaR1C1 = "Last Error"
    With theRange.Interior
        .colorIndex = 11
        .Pattern = xlSolid
    End With
    theRange.Font.colorIndex = 2
    theRange.Font.Bold = True
    
    Set theRange = Range(positionRange).offset(0, 1)
    With theRange.Interior
        .colorIndex = 11
        .Pattern = xlSolid
    End With
    ' ActiveWindow.ScrollColumn = 8
    
    Set theRange = Range(positionRange).offset(0, 2)
    With theRange.Interior
        .colorIndex = 11
        .Pattern = xlSolid
    End With
    
    Set theRange = Range(positionRange).offset(1, 0)
    theRange.FormulaR1C1 = "Id"
    ' Columns("R:R").ColumnWidth = 10
    With theRange.Interior
        .colorIndex = 36
        .Pattern = xlSolid
    End With
    
    Set theRange = Range(positionRange).offset(1, 1)
    theRange.FormulaR1C1 = "Code"
    
    Set theRange = Range(positionRange).offset(1, 2)
    theRange.FormulaR1C1 = "Message"
    With theRange.Interior
        .colorIndex = 36
        .Pattern = xlSolid
    End With
    
    Range(positionRange).offset(2, 0).Formula = util.composeShortLink(server, topic, util.IDENTIFIER_PREFIX)
    Range(positionRange).offset(2, 1).Formula = util.composeShortLink(server, topic, "errorCode")
    Range(positionRange).offset(2, 2).Formula = util.composeShortLink(server, topic, "errorMsg")
    
    Set theRange = Range(Range(positionRange), Range(positionRange).offset(2, 2))
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
    theRange.Borders(xlInsideVertical).LineStyle = xlNone
    theRange.Borders(xlInsideHorizontal).LineStyle = xlNone

    
End Sub
