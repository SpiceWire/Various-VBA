'This VBA code was attached to a particular document for service transition. The code automated some completion of fields,
'checked fields for omission or errors, generated a filename of Last.First.ServiceProgram.Transition.TransitionDate,
'saved the file in the correct location, generated an email in Outlook (with address list, topic and message)
'and attached the document to the email. 
'Most of the subs were triggered from tabbing in or out of a form field in Word.

Public Sub InsertTodaysDate(ByRef FieldChoice As Integer)


Dim Response As String
Dim TodaysDate As Date

TodaysDate = Format(Now, "mm/dd/yyyy")



Response = MsgBox("Insert today's date?", vbYesNoCancel, "A little help here?")

If Response = vbYes Then
    If FieldChoice = 1 Then
        ActiveDocument.FormFields("FldTsnDate").Result = TodaysDate
        Exit Sub
    End If
    
    If FieldChoice = 2 Then
        ActiveDocument.FormFields("LastDOSFld").Result = TodaysDate
        Exit Sub
    End If
End If

End Sub

Public Sub TsnDateFieldFill()
'Calls sub to insert today's date into a field.

Dim FieldChoice1 As Integer

If ActiveDocument.FormFields("FldTsnDate").Result = "" Then
    FieldChoice1 = 1
    Call InsertTodaysDate(FieldChoice1)
End If

End Sub

Public Sub LDOSDateFieldFill()
'Calls sub to insert today's date into a field.

Dim FieldChoice1 As Integer

If ActiveDocument.FormFields("LastDOSFld").Result = "" Then
    FieldChoice1 = 2
    Call InsertTodaysDate(FieldChoice1)
Else
    Exit Sub
End If

End Sub

Public Sub SendTsnForm()

'This macro sends a transition summary as an email attachment.
'User should edit the email list before sending.
'Only set up for this program at the moment.
'updated:
    'final saved filename is a docx document rather than docm
    'program name extractor added

Dim oOutlookApp As Outlook.Application
Dim oMsg As Outlook.MailItem
Dim bStarted As Boolean
Dim NameofDoc As String
Dim BtnFldEmailForm As FormField
Dim FldCtFirstName As FormField
Dim FldCtLastName As FormField
Dim FldTsnDate As FormField
Dim FldCtLastNameInfo As String
Dim FldCtFirstNameInfo As String
Dim CtFullName As String
Dim TsnFileName As String
Dim FldTsnDateInfo As String
Dim LastChance As String
Dim ProgramName As FormField
Dim ProgramNameInfo As String
Dim DDCloseCode As DropDown
Dim MailSubjectInfo As String
Dim FieldySingle As FormField
Dim NumOfCheckedBoxes As Long
Dim Response4 As Variant
Dim ProgramAcronym As String
Dim Test1Chars As String
Dim Test2Chars As String
Dim Test3Chars As String
Dim Test4Chars As String
Dim StringLength As Integer
Dim CounterNo As Long
Dim LeftPosition As Integer
Dim AcroLength As Integer

LastChance = MsgBox("This will save the file in the correct folder using the correct filename, then send the transition summary to all required recipients.", vbOKCancel, "It's a package deal.")

If LastChance = vbCancel Then
    Exit Sub
End If


'pull the client's name from the file to use it as document name

If ActiveDocument.FormFields("FldCtFirstName").Result = "" Then
    GoTo errormessage
End If
If ActiveDocument.FormFields("FldCtLastName").Result = "" Then
    GoTo errormessage
End If
If ActiveDocument.FormFields("FldCtFirstName").Result = "First" Then
    GoTo errormessage
End If
If ActiveDocument.FormFields("FldCtLastName").Result = "Last" Then
    GoTo errormessage
End If
If ActiveDocument.FormFields("FldTsnDate").Result = "" Then
    GoTo errormessage
End If
If ActiveDocument.FormFields("ProgramName").Result = "" Then
    GoTo errormessage
End If
If ActiveDocument.FormFields("LastDOSFld").Result = "" Then
    GoTo errormessage
End If
If ActiveDocument.FormFields("DDCloseCode").Result = "Select close code" Then
    GoTo errormessage2
End If
If ActiveDocument.FormFields("LastDOSFld").Result > ActiveDocument.FormFields("FldTsnDate").Result Then
    Response4 = MsgBox("Your last day of service is after the Transition Date. Are you sure this is correct?", vbYesNoCancel)
End If
If Response4 = vbNo Then
    Exit Sub
End If
If Response4 = vbCancel Then
    Exit Sub
End If

'extract program acronym
ProgramNameInfo = ActiveDocument.FormFields("ProgramName").Result
StringLength = Len(ProgramNameInfo)
StringLength = StringLength - 3
AcroLength = 0

For CounterNo = 1 To StringLength
    Test1Chars = Mid(ProgramNameInfo, CounterNo, 1)
    Test2Chars = Mid(ProgramNameInfo, CounterNo + 1, 1)
    Test3Chars = Mid(ProgramNameInfo, CounterNo + 2, 1)
    Test4Chars = Mid(ProgramNameInfo, CounterNo + 3, 1)


    Select Case Asc(Test1Chars)
         Case 65 To 90 ' ' It's the first capital letter.
            Select Case Asc(Test2Chars)
                Case 65 To 90 ' It's the second capital letter in a row
                        Select Case Asc(Test3Chars)
                            Case 65 To 90 ' It's the third capital letter in a row
                                LeftPosition = CounterNo
                                AcroLength = 3
                                Select Case Asc(Test4Chars)
                                    Case 65 To 90 ' It's the fourth capital letter in a row
                                        LeftPosition = CounterNo
                                        AcroLength = 4
                                        GoTo AcroFound
                                    Case 49 To 50 ' It's one of the others
                                        LeftPosition = CounterNo
                                        AcroLength = 4
                                        GoTo AcroFound
                                End Select
                        End Select
            End Select
            Case Else
    End Select

Next CounterNo


If AcroLength = 0 Then
    MsgBox "There was no program acronym in the Program field. File name could not be created properly."
    ErrorCounter = ErrorCounter + 1
    Exit Sub
End If

AcroFound:
ProgramAcronym = Mid(ProgramNameInfo, LeftPosition, AcroLength)
    
FldCtFirstNameInfo = ActiveDocument.FormFields("FldCtFirstName").Result
FldCtLastNameInfo = ActiveDocument.FormFields("FldCtLastName").Result
CtFullName = FldCtFirstNameInfo & " " & FldCtLastNameInfo
FldTsnDateInfo = ActiveDocument.FormFields("FldTsnDate").Result
FldTsnDateInfo = Format(FldTsnDateInfo, "yyyy_mm_dd")
MailSubjectInfo = "Transition Form for " & CtFullName & " Attached"
'building the filename...
TsnFileName = FldCtLastNameInfo & "_" & FldCtFirstNameInfo & "_" & ProgramAcronym
TsnFileName = TsnFileName & "_Trans_Form_" & "_" & FldTsnDateInfo
TsnFileName = TsnFileName & ".docx"
TsnFileName = "<deletedforprivacy>" & TsnFileName

'error check boxes
NumOfCheckedBoxes = 0

For Each FieldySingle In ActiveDocument.FormFields
    If FieldySingle.Type = wdFieldFormCheckBox Then
        If ActiveDocument.FormFields(FieldySingle.Name).CheckBox.Value = True Then
            NumOfCheckedBoxes = NumOfCheckedBoxes + 1
        End If
    End If
Next

If NumOfCheckedBoxes < 7 Then
    MsgBox "You forgot to check a box somewhere. Look at them again."
    Exit Sub
End If

If NumOfCheckedBoxes > 7 Then
    MsgBox "You checked too many boxes. Just check one in each section, and four boxes in last section. Look at them again."
    Exit Sub
End If

'It passed error checks, so get rid of the button field trigger
ActiveDocument.Unprotect
ActiveDocument.FormFields("BtnFldEmailForm").Select
Selection.Delete
ActiveDocument.Protect Type:=wdAllowOnlyFormFields, NoReset:=True


'save in correct location.
ActiveDocument.SaveAs FileName:=TsnFileName, FileFormat:=wdFormatXMLDocument

    
MsgBox "File saved successfully in  Transition Reports folder."

GoTo FakeDatapoint
MsgBox "did not work"
Exit Sub
On Error Resume Next
'Use Outlook if it is running
Set oOutlookApp = GetObject(, "Outlook.Application")
If Err <> 0 Then
    'Outlook was not running. Open it.
    Set oOutlookApp = CreateObject("Outlook.Application")
    'the next line is to track that the macro started Outlook
     bStarted = True
End If
'ends error capure
On Error GoTo 0

'adapted from Source: http://word.mvps.org/faqs/interdev/sendmail.htm

Set oMsg = oOutlookApp.CreateItem(0)
With oMsg
    .To = "<deletedforprivacy"
    .Subject = MailSubjectInfo 'Transition form for First Last attached
    .Body = "Thanks!"
        'Add the document as an attachment, you can use the .displayname property
        'to set the description that's used in the message
    .Attachments.Add Source:=ActiveDocument.FullName, Type:=olByValue, DisplayName:="Document as attachment"
    '.Attachments.Add Me.Path + "\" + Me.Name
    .Send
End With
FakeDatapoint:
MsgBox "The document was sent by Outlook successfully to the recipient list."

'Tidy things up
'If the macro started Outlook, stop it again.
If bStarted = True Then
    oOutlookApp.Quit
End If

Set oMsg = Nothing
Set oOutlookApp = Nothing
bStarted = False

'save in place
ActiveDocument.Save

Exit Sub
errormessage:
    MsgBox "You did not fill out all fields needed for filename. Check client name, program, transition date, last date of service."
Exit Sub

errormessage2:
    MsgBox "You forgot the closing code. Try again."
Exit Sub

 
End Sub
