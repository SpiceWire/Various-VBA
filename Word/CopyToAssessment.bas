'This VBA copies information from a database and inserts the information into an assessment tool. 
'It eliminates the time and errors that might result from manual typing.
'It alerts the user if needed info was not present in the database. 

Public Sub PutOTISInfoIntoAssmt(AssessmentType As Integer)

Dim OTISFirstName As String
Dim OTISLastName As String
Dim CtFullishName As String
Dim OTISAlias As String
Dim OTISDOB As String
Dim OTISSSN As String
Dim OTISMale As Boolean
Dim OTISFemale As Boolean
Dim OTISCurrentAge As String ' won't use b/c OTIS age might not = age of ct at assmt.
Dim CtEthnicity As String 'lable of ct's ethnicity as determined by string search in OTIS
Dim StartChar As Integer 'location of T in TRUE for ethnicity
Dim EthnicityTrue As String 'list of truth values for ethnicity
Dim CtReligion As String 'Client's religion.
Dim StartChar2 As Integer 'location of T in True for Religion
Dim ReligionTrue As String 'list of truth values for Religion
Dim InitialUniNumber As String 'ct's Insurance number with extra info i don't need
Dim CtUniNumber As String 'Client's acutal insurance number
Dim InitialIntakeDate As String 'ct's intake date, perhaps, with extra info
Dim IntakeStringLength As Long 'length of intake date string initally
Dim OTISIntakeDate As String 'Client's intake date, minus extra info
Dim UniLength As Long 'length of insurance number before extra stuff stripped
Dim EthnicityStmt As String


OTISFirstName = ThisDocument.DefaultOcxName.Value ' first name
'ThisDocument.DefaultOcxName1.Value ' middle name
OTISLastName = ThisDocument.DefaultOcxName2.Value ' last name
OTISAlias = ThisDocument.DefaultOcxName3.Value ' Alias
OTISDOB = ThisDocument.DefaultOcxName4.Value 'DOB
OTISSSN = ThisDocument.DefaultOcxName5.Value 'SSN
OTISSSN = Format(OTISSSN, "###-##-####")
'ThisDocument.DefaultOcxName6.Value 'UCI
OTISMale = DefaultOcxName7.Checked 'male if true
OTISFemale = ThisDocument.DefaultOcxName8.Checked 'female if true
'ThisDocument.DefaultOcxName9.selection 'religion
CtFullishName = OTISLastName & ", " & OTISFirstName
'extract ct's ethnicity
EthnicityTrue = ThisDocument.DefaultOcxName9.Selected ' selects the truefalse list of ethnicity
'looks for the T in true. When found, character location determines ethnicity from list
StartChar = InStr(1, EthnicityTrue, "T", vbTextCompare)


If StartChar = Null Then
    MsgBox "OTIS had no information about client's ethnicity."
    GoTo CompletedEthnicityIdentification
End If

If StartChar = 0 Then
    MsgBox "OTIS had no information about client's ethnicity."
    GoTo CompletedEthnicityIdentification
End If

If StartChar = 1 Then
    CtEthnicity = "African-American"
    GoTo CompletedEthnicityIdentification
End If
If StartChar = 7 Then
    CtEthnicity = "Alaska Native"
    GoTo CompletedEthnicityIdentification
End If
If StartChar = 13 Then
    CtEthnicity = "Asian"
    GoTo CompletedEthnicityIdentification
End If
If StartChar = 19 Then
    CtEthnicity = "Caucasian"
    GoTo CompletedEthnicityIdentification
End If
If StartChar = 25 Then
    CtEthnicity = "Hispanic"
    GoTo CompletedEthnicityIdentification
End If
If StartChar = 31 Then
    CtEthnicity = "multi-racial"
    GoTo CompletedEthnicityIdentification
End If
If StartChar = 37 Then
    CtEthnicity = "Native Hawiian"
    GoTo CompletedEthnicityIdentification
End If
If StartChar = 43 Then
    CtEthnicity = "Native American"
    GoTo CompletedEthnicityIdentification
End If
If StartChar = 49 Then
    CtEthnicity = "other"
    GoTo CompletedEthnicityIdentification
End If
If StartChar = 55 Then
    CtEthnicity = "unknown"
End If

MsgBox "Client's ethnicity was not identified from OTIS info."

CompletedEthnicityIdentification:

EthnicityStmt = "Client is of " & CtEthnicity & " decent."

'extract ct's religion
ReligionTrue = ThisDocument.DefaultOcxName10.Selected 'trueFalse list from Religion box

StartChar2 = InStr(1, ReligionTrue, "T", vbTextCompare)

If StartChar2 = Null Then
    CtReligion = "Information was not available regarding client's religion."
    MsgBox "Client's religion could not be determined from OTIS information."
    GoTo CompletedRelgionIdentification
End If

If StartChar2 = 0 Then
    CtReligion = "Information was not available regarding client's religion."
    MsgBox "Client's religion could not be determined from OTIS information."
    GoTo CompletedRelgionIdentification
End If

If StartChar2 = 1 Then
    CtReligion = "Client's identified religion is Baptist."
    GoTo CompletedRelgionIdentification
End If

If StartChar2 = 7 Then
    CtReligion = "Client's identified religion is Catholic."
    GoTo CompletedRelgionIdentification
End If
If StartChar2 = 13 Then
    CtReligion = "Client's identified religion is Christian."
    GoTo CompletedRelgionIdentification
End If
If StartChar2 = 19 Then
    CtReligion = "Client's identified religion is Jehovah's Witness."
    GoTo CompletedRelgionIdentification
End If
If StartChar2 = 25 Then
    CtReligion = "Client's identified religion is Jewish."
    GoTo CompletedRelgionIdentification
End If
If StartChar2 = 31 Then
    CtReligion = "Client's identified religion is Mormon."
    GoTo CompletedRelgionIdentification
End If
If StartChar2 = 37 Then
    CtReligion = "Client's identified religion is Muslim."
    GoTo CompletedRelgionIdentification
End If
If StartChar2 = 43 Then
    CtReligion = "None Reported"
    GoTo CompletedRelgionIdentification
End If
If StartChar2 = 49 Then
    CtReligion = "Client's identified religion is Non-denominational."
    GoTo CompletedRelgionIdentification
End If
If StartChar2 = 55 Then
    CtReligion = "Client did not identify with predominant religious groups."
    GoTo CompletedRelgionIdentification
End If
If StartChar2 = 61 Then
    CtReligion = "Client's identified religion is Protestant."
    GoTo CompletedRelgionIdentification
End If
If StartChar2 = 67 Then
    CtReligion = "Client did not identify with any particular religion."
    GoTo CompletedRelgionIdentification
End If


MsgBox "Client's religion could not be determined from OTIS information."

CompletedRelgionIdentification:


'Extract insurance number
If ThisDocument.Tables.Count >= 1 Then
    InitialUniNumber = ThisDocument.Tables(1).Rows(1).Cells(2).Range.Text
    InitialIntakeDate = ThisDocument.Tables(1).Rows(3).Cells(2).Range.Text
End If

UniLength = Len(InitialUniNumber) 'the length of the string including extra info
CtUniNumber = Left(InitialUniNumber, UniLength - 1) 'the string minus extra info
IntakeStringLength = Len(InitialIntakeDate)
OTISIntakeDate = Left(InitialIntakeDate, IntakeStringLength - 1) 'Probable date of entry into program

'Assigning values to fields:
'DAF Update
If AssessmentType = 2 Then 'it's a DAF Update

    Documents.Open FileName:="<deleted for privacy>"
   
    ActiveDocument.FormFields("DAFUCtFirstName").Result = OTISFirstName
    ActiveDocument.FormFields("DAFUCtLastName").Result = OTISLastName
    ActiveDocument.FormFields("DAFUinsurance").Result = CtUniNumber
    ActiveDocument.FormFields("DAFUCtDOB").Result = OTISDOB
    'ActiveDocument.Protect (wdAllowOnlyFormFields)
    MsgBox "Client's name, DOB, insurance # were copied to the DAF Update."
    
End If


If AssessmentType = 1 Then 'it's a DAF
    Documents.Open FileName:="<deleted for privacy>"
    
    ActiveDocument.FormFields("ClientFirstNameDAF").Result = OTISFirstName
    ActiveDocument.FormFields("ClientLastNameDAF").Result = OTISLastName
    ActiveDocument.FormFields("insuranceIDNumber").Result = CtUniNumber
    ActiveDocument.FormFields("ClientDOBDAF").Result = OTISDOB
    ActiveDocument.FormFields("ClientSSNDAF").Result = OTISSSN
    ActiveDocument.FormFields("ClientRaceEthnicity").Result = EthnicityStmt
    ActiveDocument.FormFields("TextSpirituality").Result = CtReligion
    ActiveDocument.FormFields("ClientAdmissionDate").Result = OTISIntakeDate
    If OTISMale = True Then
        ActiveDocument.FormFields("CltGenderMYes").CheckBox.Value = True
    End If
    If OTISFemale = True Then
        ActiveDocument.FormFields("CltGenderFYes").CheckBox.Value = True
    End If
    
    AllDoneForm.Show
   
    ThisDocument.Close SaveChanges:=wdDoNotSaveChanges
   
End If


End Sub

Private Sub CommandButton1_Click()
'Pastes insurance info.
'From within a sub, this pasted too fast for it to read. I had to make it a separate sub.

ThisDocument.Unprotect

Selection.EndKey Unit:=wdStory
SendKeys "(ENTER)"
SendKeys "(ENTER)"
SendKeys "(ENTER)"

Selection.PasteSpecial DataType:=wdPasteHTML

ThisDocument.Protect (wdAllowOnlyFormFields)

End Sub

Private Sub CopyOTISInfoToDAFUpdate_Click()


Call PutOTISInfoIntoAssmt(2)

End Sub

Private Sub CopyOTISInfoToNewDAF_Click()

Call PutOTISInfoIntoAssmt(1)

End Sub
