VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ExtendedOrderAttributes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Public Enum ExtendedAttributesColumns
    Col_ATTRIBUTE_NAME = 1
    Col_ATTRIBUTE_VALUE = 4
    Col_ATTRBUTE_NOTE = 5
End Enum

Public ExtendedAttributesTable As Range

Public Sub Initialise()
    Set ExtendedAttributesTable = ExtendedOrderAttributes.Range("$A$7:$J$101")
End Sub

Private Sub Worksheet_Activate()
    Main.Initialise
End Sub


