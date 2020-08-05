Attribute VB_Name = "OrderFunctions"
Option Explicit

Public Const EXTENDED_WORKSHEET = "Extended Order Attributes"
Public Const EXTENDED_ATTRIB_COL = "d"
Public Const FIRST_EXTENDED_ROW = 7
Public Const LAST_EXTENDED_ROW = 62
Public Const BREAK_EXTENDED_ROW = 28

Const topic = "ord"
Const PLACE_ORDER_BY_FULL_CONTRACT = "place"
Const PLACE_ORDER_BY_LOCAL_SYMBOL = "place2"
Const DescripColumn = 13
Const OrderLinkColumn = 18
Const sharesAlloc = util.CELL_EMPTY ' deprecated so send empty
Const CANCEL_ACTION = "cancel?"
Const orderMult = 1000000
Const DAYS_PRIOR_TO_DDE_API = 43151

Dim ongoingID As Long, idsCreated As Long

Sub applyTemplate(ByRef orderRange As Range, ByVal extendedAttribColumn As Integer)
    Dim orderRowCtr As Integer, extRowCtr As Integer, orderCol As Integer
    Dim orderRow As Range
    Dim orderSheet As Worksheet
    For Each orderRow In orderRange.rows
        orderRowCtr = orderRow.row
        For extRowCtr = OrderFunctions.FIRST_EXTENDED_ROW To OrderFunctions.LAST_EXTENDED_ROW
            orderCol = extendedAttribColumn + extRowCtr - OrderFunctions.FIRST_EXTENDED_ROW
            Set orderSheet = orderRow.Worksheet
            If orderSheetCheckFails(orderSheet) Then Exit Sub
            orderSheet.Cells(orderRowCtr, orderCol).value = OrderFunctions.extendedAttrib(Nothing, extendedAttribColumn, extRowCtr)
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

Function orderSheetCheckFails(ByRef orderSheet As Worksheet) As Boolean
    If orderSheet Is Nothing Then
        MsgBox "Range selected for order group operations must be contiguous"
    End If
    orderSheetCheckFails = orderSheet Is Nothing
End Function

Sub cancelOrder(ByVal orderRange As Range, serverCell)
    Dim server As String, id As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    
    Dim orderSheet As Worksheet
    Dim orderRow As Range
    Dim rowCtr As Integer, ctr As Integer
    For Each orderRow In orderRange
        rowCtr = orderRow.row
        Set orderSheet = orderRow.Worksheet
        If orderSheetCheckFails(orderSheet) Then Exit Sub
        id = orderSheet.Cells(rowCtr, OrderLinkColumn + 1).value
        If id <> "" Then
            orderSheet.Cells(rowCtr, OrderLinkColumn).Formula = util.composeLink(server, topic, id, CANCEL_ACTION)
        End If
    Next orderRow
End Sub

Sub order2(ByRef orderRange As Range, ByVal serverCell As String, _
           ByVal extendedAttribColumn As Integer, ByVal fromOrdersPage As Boolean)
    Dim server As String, req As String, reqType As String, id As String, _
        setSecType As String, primaryexchange As String, setExchange As String, addr As String, _
        extended1 As String, extended2 As String
    server = util.getServerStr(serverCell)
    If server = "" Then Exit Sub
    
    Dim lmtOrderTypes, auxOrderTypes As Variant
    lmtOrderTypes = Array("LMT", "STPLMT", "REL", "LIT", "LOC", "PEGMKT", "TRAILLIMIT", "SCALE", "PEGMID", "PEG MID", "PASSV REL", "PPV")
    auxOrderTypes = Array("STP", "STPLMT", "REL", "LIT", "MIT", "PEGMKT", "TRAIL", "TRAILLIMIT", "SCALE", "PEGMID", "PEG MID", "PASSV REL", "PPV")
        
    ' order vars
    Dim side As String, quantity As String, orderType As String, _
        lmtPrice As String, auxPrice As String, placeType As String
    Dim orderRow As Range
    Dim orderSheet As Worksheet
    Dim rowCtr As Integer, ctr As Integer
    Dim doErrorPopup As Boolean
    doErrorPopup = (orderRange.Cells.Count = 1)
    For Each orderRow In orderRange
        rowCtr = orderRow.row
        Set orderSheet = orderRow.Worksheet
        If orderSheetCheckFails(orderSheet) Then Exit Sub
        
        If util.composeContractReq(orderSheet.Cells(rowCtr, 1), req, reqType, True, , , _
                                   doErrorPopup, setSecType, setExchange) Then
    
        ' get order description
        side = orderSheet.Cells(rowCtr, DescripColumn)
        quantity = orderSheet.Cells(rowCtr, DescripColumn + 1)
        orderType = UCase(orderSheet.Cells(rowCtr, DescripColumn + 2))
        lmtPrice = orderSheet.Cells(rowCtr, DescripColumn + 3)
        auxPrice = orderSheet.Cells(rowCtr, DescripColumn + 4)

        ' must have side, quantity, orderType
        If (side = "" Or quantity = "" Or orderType = "") Then
            If doErrorPopup Then
                MsgBox ("You must specify the side, quantity, and order type.")
                Exit Sub
            End If
        Else
    
        req = req & side & util.UNDERSCORE & quantity & util.UNDERSCORE & orderType
    
        If (reqType = util.FULL_CONTRACT_REQ) Then
            placeType = PLACE_ORDER_BY_FULL_CONTRACT
        Else
            placeType = PLACE_ORDER_BY_LOCAL_SYMBOL
        End If
   
        id = orderSheet.Cells(rowCtr, DescripColumn + 6).value
        If id = "" Then ' none exists yet -- is original placement as opposed to modify
            id = makeId()
        End If
    
        ' for relative order with no limit price, set it to 0; TWS will understand
        If orderType = "REL" And lmtPrice = "" Then
            lmtPrice = "0"
        End If
        
        ' for SCALE order with no aux price set it to 0
        If orderType = "SCALE" And auxPrice = "" Then
            auxPrice = "0"
        End If

        ' for PEG MID order with no limit price, set it to 0
        If (orderType = "PEGMID" Or orderType = "PEG MID") And lmtPrice = "" Then
            lmtPrice = "0"
        End If

        ' for PEG MID order with no aux price, set it to 0
        If (orderType = "PEGMID" Or orderType = "PEG MID") And auxPrice = "" Then
            auxPrice = "0"
        End If

        ' for PASSV REL order with no lmt price, set it to 0
        If (orderType = "PASSV REL") And lmtPrice = "" Then
            lmtPrice = "0"
        End If

        Dim doTheAuxPrice As Boolean, doTheLmtPrice As Boolean
        doTheAuxPrice = False
        doTheLmtPrice = False

        If setSecType = util.BAG And setExchange = util.IBEFP Then
            doTheLmtPrice = True
            doTheAuxPrice = (lmtPrice = "")
        Else
            For ctr = LBound(lmtOrderTypes) To UBound(lmtOrderTypes)
                If orderType = lmtOrderTypes(ctr) Then
                    doTheLmtPrice = True
                    Exit For
                End If
            Next ctr
            For ctr = LBound(auxOrderTypes) To UBound(auxOrderTypes)
                If orderType = auxOrderTypes(ctr) Then
                    doTheAuxPrice = True
                    Exit For
                End If
            Next ctr
        End If

        If doTheLmtPrice Then
            req = req & util.UNDERSCORE & util.orEmpty(lmtPrice)
        End If
    
        If doTheAuxPrice Then
            req = req & util.UNDERSCORE & util.orEmpty(auxPrice)
        End If
    
        ' add the deprecated share allocation for FA accounts, extended order attributes, and primary exchange
        primaryexchange = UCase(orderSheet.Cells(rowCtr, 9))
        extended2 = getExtendedOattrib2(orderRow, extendedAttribColumn, True)
        extended1 = getExtendedOattrib1(orderRow, extendedAttribColumn, Len(extended2) = 0 And primaryexchange = "")
        If extended1 <> "" Then ' if it is empty then no extended attribs are necessary and primaryexchange is empty
            req = req & util.UNDERSCORE & sharesAlloc & _
                util.UNDERSCORE & extended1
            If primaryexchange <> "" Or extended2 <> "" Then
                req = req & util.UNDERSCORE & util.orEmpty(primaryexchange)
            End If
            If extended2 <> "" Then
                req = req & util.UNDERSCORE & extended2
            End If
        End If
    
        ' create order
        orderSheet.Cells(rowCtr, OrderLinkColumn).value = util.composeControlLink(server, topic, id, placeType, req)
        orderSheet.Cells(rowCtr, OrderLinkColumn + 1).value = id
        orderSheet.Cells(rowCtr, OrderLinkColumn + 2).value = util.composeLink(server, topic, id, "status")
        orderSheet.Cells(rowCtr, OrderLinkColumn + 3).value = util.composeLink(server, topic, id, "filled")
        orderSheet.Cells(rowCtr, OrderLinkColumn + 4).value = util.composeLink(server, topic, id, "remaining")
        orderSheet.Cells(rowCtr, OrderLinkColumn + 5).value = util.composeLink(server, topic, id, "price")
        orderSheet.Cells(rowCtr, OrderLinkColumn + 6).value = util.composeLink(server, topic, id, "lastFillPrice")
        orderSheet.Cells(rowCtr, OrderLinkColumn + 7).value = util.composeLink(server, topic, id, "parentId")
    
        End If ' must have side, quantity, orderType
        End If ' util.composeContractReq() succeeded

    Next orderRow
End Sub
Function getExtendedOattrib1(ByRef orderRow As Range, ByVal extendedAttribColumn As Integer, ByVal doTrim As Boolean) As String
    getExtendedOattrib1 = getExtendedOattribPrim(orderRow, extendedAttribColumn, FIRST_EXTENDED_ROW, BREAK_EXTENDED_ROW, doTrim)
End Function
Function getExtendedOattrib2(ByRef orderRow As Range, ByVal extendedAttribColumn As Integer, ByVal doTrim As Boolean) As String
    getExtendedOattrib2 = getExtendedOattribPrim(orderRow, extendedAttribColumn, BREAK_EXTENDED_ROW + 1, LAST_EXTENDED_ROW, doTrim)
End Function
Function extendedAttrib(ByRef orderRow As Range, ByVal extendedAttribColumn As Integer, ByVal ctr As Integer)
    Dim orderRangeTIF As String
    If Not orderRow Is Nothing Then
        orderRangeTIF = orderRow.Worksheet.Cells(orderRow.row, extendedAttribColumn)
    End If
    If orderRangeTIF = "" Then
        extendedAttrib = Worksheets(EXTENDED_WORKSHEET).Range(EXTENDED_ATTRIB_COL & CStr(ctr)).value
    Else
        extendedAttrib = orderRow.Worksheet.Cells(orderRow.row, ctr - FIRST_EXTENDED_ROW + extendedAttribColumn)
    End If
End Function
Function getExtendedOattribPrim(ByRef orderRow As Range, ByVal extendedAttribColumn As Integer, _
                                ByVal firstRow As Integer, ByVal lastRow As Integer, ByVal doTrim As Boolean) As String
    Dim str As String, val As String
    Dim lastRowToDo As Integer, ctr As Integer
    If doTrim Then
        lastRowToDo = -1
        For ctr = lastRow To firstRow Step -1
            val = extendedAttrib(orderRow, extendedAttribColumn, ctr)
            If val <> "" Then
                lastRowToDo = ctr
                Exit For
            End If
        Next ctr
    Else
        lastRowToDo = lastRow
    End If
    For ctr = firstRow To lastRowToDo
        val = extendedAttrib(orderRow, extendedAttribColumn, ctr)
        str = str & util.orEmpty(val)
        If ctr <> lastRowToDo Then
            str = str & util.UNDERSCORE
        End If
    Next ctr
    getExtendedOattribPrim = str
End Function
