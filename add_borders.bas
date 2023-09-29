Sub AddBorders
    Dim oDoc As Object
    Dim oSheet As Object
    Dim oCell As Object
    Dim oCellRange As Object

    oDoc = ThisComponent
    oSheet = oDoc.Sheets(0) ' Assuming the first sheet

    oCellRange = oSheet.getCellRangeByName("A1:Z100") ' Adjust the range as needed

    With oCellRange.Borders
        .IsOutline = True
        .IsInside = True
        .LineColor = RGB(0, 0, 0) ' Border color (black)
        .LineStyle = com.sun.star.table.BorderLine.SINGLE ' Border style
    End With
End Sub
