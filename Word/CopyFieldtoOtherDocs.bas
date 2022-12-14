Public Sub CopyFieldInfoAllDocs()


'This copies information from one field into the same field of other documents.
'It is intended to be used for DAF's, when family info is similar across DAF's,
'and can be copied into a sib's DAF.
'It copies the active field's info to the same field of another open document.
'Both fields have to be named.
'any number of documents
'It works around the 256 character copy limit for fields.


Dim ChosenFieldName As String
Dim FirstDocumentName As String
Dim WdWin As Window
Dim WdDoc As Document
Dim NoOfWindows As Long
Dim WinCounter As Long


Application.ScreenUpdating = False

'Unprotects all docs
For Each WdDoc In Documents
If ProtectionType = wdAllowOnlyFormFields Then
    Document.Unprotect
End If
Next WdDoc

'counts open windows
NoOfWindows = Windows.Count


'Identifies the name of the active field, based on the bookmark name.
ChosenFieldName = Selection.Bookmarks(Selection.Bookmarks.Count).Name

'checks to make sure other docs are open
If NoOfWindows = 1 Then
    MsgBox "You only have one document open. Open another form of the same type."
    
End If

'cycles through windows, pasting the info.
FirstDocumentName = ActiveDocument.Name
For WinCounter = 1 To NoOfWindows
    Documents(WinCounter).Bookmarks(ChosenFieldName).Range.Fields(1).Result.Text = Documents(FirstDocumentName).FormFields(ChosenFieldName).Result
Next WinCounter

'protects all docs
For Each WdDoc In Documents
    ProtectionType = wdAllowOnlyFormFields ', Noreset:=True
Next WdDoc


Application.ScreenUpdating = True

End Sub
