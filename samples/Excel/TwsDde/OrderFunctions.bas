Attribute VB_Name = "OrderFunctions"

' constants
Public Const EXTENDED_WORKSHEET = "ExtendedOrderAttributes"
Public Const EXTENDED_ATTRIB_COL = "d"
Public Const FIRST_EXTENDED_ROW = 7
Public Const LAST_EXTENDED_ROW = 119
Const DAYS_PRIOR_TO_DDE_API = 43151
Const orderMult = 1000000

' variables
Dim ongoingID As Long, idsCreated As Long

Sub applyTemplate(ByRef orderRange As range, ByVal extendedAttribColumn As Integer)
    Dim orderRowCtr As Integer, extRowCtr As Integer, orderCol As Integer
    Dim orderRow As range
    Dim orderSheet As Worksheet
    For Each orderRow In orderRange.rows
        orderRowCtr = orderRow.row
        For extRowCtr = OrderFunctions.FIRST_EXTENDED_ROW To OrderFunctions.LAST_EXTENDED_ROW
            orderCol = extendedAttribColumn + extRowCtr - OrderFunctions.FIRST_EXTENDED_ROW
            If Worksheets(EXTENDED_WORKSHEET).range(EXTENDED_ATTRIB_COL & CStr(extRowCtr)).value <> orderRow.Worksheet.Cells(orderRowCtr, orderCol).value Then
                orderRow.Worksheet.Cells(orderRowCtr, orderCol).value = Worksheets(EXTENDED_WORKSHEET).range(EXTENDED_ATTRIB_COL & CStr(extRowCtr)).value
            End If
        Next extRowCtr
    Next orderRow
End Sub

Function makeId() As String
    Dim newId As Long
    If ongoingID = 0 Then
        Dim datePart As Double, timePart As Double
        datePart = Date - DAYS_PRIOR_TO_DDE_API
        timePart = Time
        ongoingID = Round((datePart + timePart) * orderMult, 0)
    End If
    newId = ongoingID + idsCreated
    idsCreated = idsCreated + 1
    makeId = util.IDENTIFIER_PREFIX & newId
End Function

