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
    Dim objFile
    Dim cmpComponents
    Dim szImportPath
    Dim scriptdir
    Dim VBProj

    If Wscript.Arguments.Count <> 1 Then
        Wscript.Echo "Usage: cscript compile.vbs <spreadsheetname>" & vbCrLf & vbCrLf & _
"This will update vbs project of the spreadsheet from the folder" & vbCrLf & "with the name of spreadsheet (without extension) located near the script" & vbCrLf & _
"The excel application will be opened during the compile process." & vbCrLf & "At the end of the successful script execution it trys to close the excel app."  & vbCrLf & _
"You should reply 'Cancel' to the dialog appears to review the spreadsheet changes made. Then you can save and close it."
    Else

        Set xl = CreateObject("Excel.Application")
        Set fs = CreateObject("Scripting.FileSystemObject")

        scriptdir = fs.GetParentFolderName(WScript.ScriptFullName)

        xl.Visible = true

        Set WBook = xl.Workbooks.Open(scriptdir & "\" & Trim(wScript.Arguments(0)))
        Set VBProj = WBook.VBProject

        szImportPath = WBook.Path & "\" & fs.GetBaseName(WBook.Name)

        DeleteVBAModulesAndUserForms VBProj
    
        For Each objFile In fs.GetFolder(szImportPath).Files    
            If (fs.GetExtensionName(objFile.Name) = "cls")_
            Or (fs.GetExtensionName(objFile.Name) = "frm")_
            Or (fs.GetExtensionName(objFile.Name) = "bas") Then
                If not ImportVBAModule(fs, VBProj, objFile) Then
                    WBook.VBProject.VBComponents.Import objFile.Path
                End If
            End If        
        Next

        xl.Quit
    End If
End Sub

Sub AddFromFile(fs, CodeModule, objFile)
    Dim ext
    Dim stream
    Dim n, i

    ext = fs.GetExtensionName(objFile.Name)

    If ext = "cls" Then
        n = 9
    ElseIf ext = "frm" Then
        n = 15
    ElseIf ext = "bas" Then
        n = 1
    End If

    set stream = objFile.OpenAsTextStream(1)
        
    For i = 1 To n
        stream.SkipLine
    Next

    While Not stream.AtEndOfStream
        CodeModule.InsertLines CodeModule.CountOfLines + 1, stream.ReadLine
    Wend

    stream.Close
End Sub

Function ImportVBAModule(fs, VBProj, objFile)
        Dim VBComp

        For Each VBComp In VBProj.VBComponents
            If VBComp.Name = fs.GetBaseName(objFile.Name) Then
                VBComp.CodeModule.DeleteLines 1, VBComp.CodeModule.CountOfLines
                AddFromFile fs, VBComp.CodeModule, objFile

                ImportVBAModule = true

                Exit Function
            End If
        Next

        ImportVBAModule = false
End Function

Sub DeleteVBAModulesAndUserForms(VBProj)
        Dim VBComp
        
        For Each VBComp In VBProj.VBComponents
            If VBComp.Type = vbext_ct_Document Then
                'Thisworkbook or worksheet module
                'We do nothing
            Else
                VBProj.VBComponents.Remove(VBComp)
            End If
        Next
End Sub