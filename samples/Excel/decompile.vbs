'To resolve 'Programmatic access to Visual Basic Project is not trusted' issue, please go to
'File -> Options -> Trust Center -> Trust Center Setttings -> Macro Settings -> Trust Access to the VBA Project object model.
'For more details please refer to https://stackoverflow.com/questions/25638344/programmatic-access-to-visual-basic-project-is-not-trusted
option explicit

Const vbext_ct_ClassModule = 2
Const vbext_ct_Document = 100
Const vbext_ct_MSForm = 3
Const vbext_ct_StdModule = 1

Main

Sub Main
    Dim xl
    Dim fs
    Dim WBook
    Dim VBComp
    Dim Sfx
    Dim ExportFolder
    Dim scriptdir

    If Wscript.Arguments.Count <> 1 Then
        Wscript.Echo "Usage: cscript decompile.vbs <spreadsheetname>" & vbCrLf & vbCrLf & _
"This will create a folder with the name of spreadsheet (without extension)" & vbCrLf & "and put all vbs project files from the spreadsheet to the folder."  & vbCrLf & _
"The excel application will be opened during the decompile process." & vbCrLf & "At the end of the successful script execution it trys to close the excel app."  & vbCrLf & _
"You should reply 'Don't save' to the dialog appears to close the spreadsheet with no changes made to it"
    Else

        Set xl = CreateObject("Excel.Application")
        Set fs = CreateObject("Scripting.FileSystemObject")

        scriptdir = fs.GetParentFolderName(WScript.ScriptFullName)

        xl.Visible = true

        Set WBook = xl.Workbooks.Open(scriptdir & "\" & Trim(wScript.Arguments(0)))

        ExportFolder = WBook.Path & "\" & fs.GetBaseName(WBook.Name)

        If fs.FolderExists(ExportFolder) Then
            fs.DeleteFolder ExportFolder, 1
        End If
        
        fs.CreateFolder(ExportFolder)
        ' fs.CreateFolder(ExportFolder & "\bin")

        For Each VBComp In WBook.VBProject.VBComponents
            Select Case VBComp.Type
                Case vbext_ct_ClassModule, vbext_ct_Document
                    Sfx = ".cls"
                Case vbext_ct_MSForm
                    Sfx = ".frm"
                Case vbext_ct_StdModule
                    Sfx = ".bas"
                Case Else
                    Sfx = ""
            End Select
            If Sfx <> "" Then
                On Error Resume Next
                Err.Clear
                VBComp.Export ExportFolder & "\" & VBComp.Name & Sfx
                If Err.Number <> 0 Then
                    MsgBox "Failed to export " & ExportFolder & "\" & VBComp.Name & Sfx
                End If
                On Error Goto 0
            ' Else
            '     On Error Resume Next
            '     Err.Clear
            '     VBComp.Export ExportFolder & "\bin\" & VBComp.Name
            '     If Err.Number <> 0 Then
            '         MsgBox "Failed to export " & ExportFolder & "\" & VBComp.Name & Sfx
            '     End If
            '     On Error Goto 0
            End If
        Next

        xl.Quit
    End If
End Sub