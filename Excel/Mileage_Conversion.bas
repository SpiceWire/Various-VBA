'This VBA took raw CSV data from an Android milage/productivity app, separated mileage records from notes, prepared a
'mileage form for reimbursement, and created a spreadsheet with billable and nonbillable hours. 

Public Sub FormatRawMileage()

Dim RowLoopVar As Integer
Dim LastRowColA As Integer
Dim LastRowColB As Integer
Dim LastRowColC As Integer
Dim LastRowColD As Integer
Dim LastRowColE As Integer
Dim LastRowColF As Integer
Dim LastRowColG As Integer
Dim LastRowColH As Integer
Dim LastRowColI As Integer
Dim LastRowColJ As Integer
Dim LastRowColK As Integer
Dim LastRowColL As Integer
Dim LastRowColM As Integer
Dim LastRowColN As Integer
Dim LastRowColO As Integer
Dim LastRowColP As Integer
Dim LastRowColQ As Integer
Dim LastRowColR As Integer
Dim LastRowColS As Integer
Dim LastRowColT As Integer
Dim LastRowColU As Integer
Dim LastRowColV As Integer
Dim LastRowColW As Integer
Dim LastRowColX As Integer
Dim LastRowColY As Integer
Dim LastRowColZ As Integer
Dim LastRowColAA As Integer
Dim LastRowColAB As Integer
Dim LastRowColAC As Integer
Dim FirstCellTable As Range
Dim LastCellTable As Range
Dim RowLooper As Integer ' loop for first half of billing note
Dim RowLooper2 As Integer 'loop for second half of billing note.
Dim Infocell As Range 'Trip origination column loop cell
Dim Infocell2 As Range 'determines if trip is Transport, Travel or Mtg.
Dim Infocell3 As Range 'trip destination column loop cell
Dim NotesCell As Range 'First half of billing note
Dim NotesCell2 As Range 'second half of billing note
Dim FileDateInfo As String
Dim FileDate As String
Dim FileNameInfo As String

Worksheets(1).Select
Set FirstCellTable = Range("$A$1")
LastRowColA = Range("A65536").End(xlUp).Row 'Last row in Trip ID column.
LastRowColB = Range("B65536").End(xlUp).Row 'Last row in Vehicle column.
LastRowColC = Range("C65536").End(xlUp).Row 'Last row in Trip Start column.
LastRowColD = Range("D65536").End(xlUp).Row 'Last row in Trip Stop column.
LastRowColE = Range("E65536").End(xlUp).Row 'Last row in Mileage column.
LastRowColF = Range("F65536").End(xlUp).Row 'Last row in Reimbursement Rate column.
LastRowColG = Range("G65536").End(xlUp).Row 'Last row in Fuel Toll column.
LastRowColH = Range("H65536").End(xlUp).Row 'Last row in Reimbursement Value column.
LastRowColI = Range("I65536").End(xlUp).Row 'Last row in Trip Type column.
LastRowColJ = Range("J65536").End(xlUp).Row 'Last row in Account column.
LastRowColK = Range("K65536").End(xlUp).Row 'Last row in Trip Start Date column.
LastRowColL = Range("L65536").End(xlUp).Row 'Last row in Trip Start Time column.
LastRowColM = Range("M65536").End(xlUp).Row 'Last row in Trip Stop Date column.
LastRowColN = Range("N65536").End(xlUp).Row 'Last row in Trip Stop Time column.
LastRowColO = Range("O65536").End(xlUp).Row 'Last row in Payer column.
LastRowColP = Range("P65536").End(xlUp).Row 'Last row in Itinerary column.
LastRowColQ = Range("Q65536").End(xlUp).Row 'Last row in Notes column.
LastRowColR = Range("R65536").End(xlUp).Row 'Last row in Trip Start Date 2 column.
LastRowColT = Range("T65536").End(xlUp).Row 'Last row in Notes2 column.
LastRowColV = Range("V65536").End(xlUp).Row 'Last row in Miles2 column.
LastRowColW = Range("W65536").End(xlUp).Row 'Last row in blank
LastRowColX = Range("X65536").End(xlUp).Row 'Last row in Parkingcost column.
LastRowColY = Range("Y65536").End(xlUp).Row 'Last row in Trip Start Date 3
LastRowColZ = Range("Z65536").End(xlUp).Row 'Last row in start time2 column
LastRowColAA = Range("AA65536").End(xlUp).Row 'Last row in End time2 column.
LastRowColAB = Range("AB65536").End(xlUp).Row 'Last row in BillingNotes column. Col 28
LastRowColAC = Range("AC65536").End(xlUp).Row 'Last row in blank column.
Set LastCellTable = Range(Cells(LastRowColA, 17), Cells(LastRowColA, 17)) ' Selects the last cell in Notes col.


'Copy trip start date, notes and miles into the rightmost cols for easier copying later.

'Trip Start Dates copied:
Worksheets(1).Range(Cells(2, 11), Cells(LastRowColK, 11)).Copy _
    Destination:=Worksheets(1).Range("R2")
Worksheets(1).Range("R1").Value = "Date"
Worksheets(1).Range("S1").Value = "Spacer1"
Worksheets(1).Range("W1").Value = "Spacer2"
Worksheets(1).Range(Cells(2, 11), Cells(LastRowColL, 12)).Copy _
    Destination:=Worksheets(1).Range("Y2:Z2")
Worksheets(1).Range("Y1").Value = "Trip Date"
Worksheets(1).Range("Z1").Value = "Start Time"

'Trip End times copied
Worksheets(1).Range(Cells(2, 14), Cells(LastRowColN, 14)).Copy _
    Destination:=Worksheets(1).Range("AA2")
Worksheets(1).Range("AA1").Value = "End Time"

'Notes Copied:
Worksheets(1).Range(Cells(2, 17), Cells(LastRowColQ, 17)).Copy _
    Destination:=Worksheets(1).Range("T2")
Worksheets(1).Range("T1").Value = "Description"
Worksheets(1).Range("U1").Value = "Blank1"
Worksheets(1).Range("AB1").Value = "BillingNotes"

'Notes corrected
Worksheets(1).Select
    Cells.Replace What:="Ch rec ", Replacement:="C.Hill rec ctr ", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=True, SearchFormat:=False, _
        ReplaceFormat:=False
    Cells.Replace What:="nch", Replacement:="NCH", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=True, SearchFormat:=False, _
        ReplaceFormat:=False
    Cells.Replace What:="Children's home", Replacement:="Children's Home", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=True, SearchFormat:=False, _
        ReplaceFormat:=False
    Cells.Replace What:="walgreens", Replacement:="Walgreens", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=True, SearchFormat:=False, _
        ReplaceFormat:=False
    Cells.Replace What:="ofice", Replacement:="office", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=True, SearchFormat:=False, _
        ReplaceFormat:=False
    Cells.Replace What:="Ofice", Replacement:="Office", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=True, SearchFormat:=False, _
        ReplaceFormat:=False
    Cells.Replace What:=" yo ", Replacement:=" to ", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=True, SearchFormat:=False, _
        ReplaceFormat:=False
 
 'Miles Copied:
Worksheets(1).Range(Cells(2, 5), Cells(LastRowColE, 5)).Copy _
    Destination:=Worksheets(1).Range("V2")
Worksheets(1).Range("V1").Value = "Miles"

'Fuel and Tolls (it is Parking, really) copied

Worksheets(1).Range(Cells(2, 7), Cells(LastRowColG, 7)).Copy _
    Destination:=Worksheets(1).Range("X2")
Worksheets(1).Range("X1").Value = "Parking"

'run loops to write notes and other things

For RowLooper = 1 To LastRowColA 'payer info from log
    Set Infocell = ActiveSheet.Cells(RowLooper, 15)
    Set Infocell2 = ActiveSheet.Cells(RowLooper, 9)
    Set NotesCell = ActiveSheet.Cells(RowLooper, 28)
    If Infocell2.Value = "Company" Then
        NotesCell.Value = "Service took place in a moving vehicle from "
        MsgBox "ending now"
        Exit Sub
    End If
    If Infocell2.Value = "Personal" Then
        NotesCell.Value = "Staff travel from "
    End If
    If Infocell2.Value = "Charity" Then
        NotesCell.Value = "Transported client from "
    End If
    'Parking overwriters "staff travel from"
    If Left(Infocell.Value, 3) = "A9 " Then
        ActiveSheet.Cells(RowLooper, 20).Value = "Parking"
        NotesCell.Value = "PARKING-No Note needed!"
    End If
    If Left(Infocell.Value, 3) = "A91" Then 'Meeting note overwrites "staff travel from"
        ActiveSheet.Cells(RowLooper, 20).Value = "Meeting content"
        NotesCell.Value = "Content in this Sht's Notes Col"
    End If
    If Left(Infocell.Value, 2) = "A1" Then
        NotesCell.Value = NotesCell.Value & "office "
    End If
    If Left(Infocell.Value, 2) = "A2" Then
        NotesCell.Value = NotesCell.Value & "client's home "
    End If
    If Left(Infocell.Value, 2) = "A3" Then
        NotesCell.Value = NotesCell.Value & "school "
    End If
    If Left(Infocell.Value, 2) = "A4" Then
        NotesCell.Value = NotesCell.Value & "court "
    End If
    If Left(Infocell.Value, 2) = "A5" Then
        NotesCell.Value = NotesCell.Value & "FNC "
    End If
    If Left(Infocell.Value, 2) = "A6" Then
        NotesCell.Value = NotesCell.Value & "community location "
    End If
    If Left(Infocell.Value, 2) = "A7" Then
        NotesCell.Value = NotesCell.Value & " hospital "
    End If
    If Left(Infocell.Value, 2) = "A8" Then
        NotesCell.Value = NotesCell.Value & " juvenile detention "
    End If
    Next RowLooper
   
For RowLooper2 = 1 To LastRowColA 'account info from log
    Set NotesCell2 = ActiveSheet.Cells(RowLooper2, 28)
    Set Infocell3 = ActiveSheet.Cells(RowLooper2, 10)
    If Left(Infocell3.Value, 2) = "A1" Then
        NotesCell2.Value = NotesCell2.Value & "to office"
    End If
    If Left(Infocell3.Value, 2) = "A2" Then
        NotesCell2.Value = NotesCell2.Value & "to client's home"
    End If
    If Left(Infocell3.Value, 2) = "A3" Then
        NotesCell2.Value = NotesCell2.Value & "to client's school"
    End If
    If Left(Infocell3.Value, 2) = "A4" Then
        NotesCell2.Value = NotesCell2.Value & "to court"
    End If
    If Left(Infocell3.Value, 2) = "A5" Then
        NotesCell2.Value = NotesCell2.Value & "to FNC"
    End If
    If Left(Infocell3.Value, 2) = "A6" Then
        NotesCell2.Value = NotesCell2.Value & "to community location"
    End If
    If Left(Infocell3.Value, 2) = "A7" Then
        NotesCell2.Value = NotesCell2.Value & "to hospital"
    End If
    If Left(Infocell3.Value, 2) = "A8" Then
        NotesCell2.Value = NotesCell2.Value & "to juvenile detention"
    End If
Next RowLooper2
'Make a table with the data
    Range("A1").Select
    'Selects A1 to last row in col X (=#24 in alphabet)
    ActiveSheet.ListObjects.Add(xlSrcRange, Range(Cells(1, 1), Cells(LastRowColA, 28)), , xlYes).Name = _
        "Table1"
    Range("Table1[#All]").Select
    ActiveSheet.ListObjects("Table1").TableStyle = "TableStyleMedium2"
    With ActiveCell.Characters(Start:=1, Length:=9).Font
        .Name = "Arial"
        .FontStyle = "Regular"
        .Size = 10
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ColorIndex = xlAutomatic
        .TintAndShade = 0
        .ThemeFont = xlThemeFontNone
    End With
'
'Freeze the panes
Range("A2").Select
ActiveWindow.FreezePanes = True

'color the column headers different per section
'
'Billing Notes Range:
Range("Table1[[#Headers],[Trip Date]:[BillingNotes]]").Select

    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent3
        .TintAndShade = 0.399975585192419
        .PatternTintAndShade = 0
    End With

    With Selection.Font
        .ColorIndex = xlAutomatic
        .TintAndShade = 0
    End With
'
'Mileage Notes Range:
Range("Table1[[#Headers],[Date]:[Parking]]").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent2
        .TintAndShade = 0.399975585192419
        .PatternTintAndShade = 0
    End With
    With Selection.Font
        .ColorIndex = xlAutomatic
        .TintAndShade = 0
    End With
'Hide cells I don't need to see:
'Center some of the columns:

Columns("A:D").ColumnWidth = 0
Columns("F:I").ColumnWidth = 0
Columns("J:K").ColumnWidth = 14.57
Columns("K:N").HorizontalAlignment = xlCenter
Columns("L:L").ColumnWidth = 9
Columns("M:M").ColumnWidth = 14.57
Columns("N:N").ColumnWidth = 9
Columns("O:O").ColumnWidth = 10.14
Columns("P:P").ColumnWidth = 7
Columns("Q:Q").ColumnWidth = 10.14
Rows.RowHeight = 14

With Columns("R:R")
    .ColumnWidth = 14.57
    .HorizontalAlignment = xlCenter
End With
'Columns("S:S").ColumnWidth = 0 needs to be a spacer
Columns("T:T").ColumnWidth = 10.14
Columns("V:V").HorizontalAlignment = xlCenter
'Columns("W:W").ColumnWidth = 0 needs to be a spacer
Columns("Y:AA").HorizontalAlignment = xlCenter
Columns("AB:AB").ColumnWidth = 75




    
'make file name
FileDateInfo = Cells(LastRowColK, 11).Value
FileDate = Format(FileDateInfo, "YYYY_mm_dd")

FileNameInfo = "Mileage to " & FileDate & " raw.xlsm"


FileNameInfo = "H:\MyDocuments\Mileage\Mileage to " & FileDate & " raw.xlsm"
If Application.UserName = "<deleted for privacy>" Then
    ActiveWorkbook.SaveAs FileNameInfo, FileFormat:=52 ' 52=xlOpenXMLWorkbookMacroEnabled
End If

Cells(LastRowColR, 18).Select

End Sub
