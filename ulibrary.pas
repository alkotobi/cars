unit ulibrary;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,db,Grids,math,BufDataset,Uni;
procedure fillStringGridFromDataset(DataSet: TDataSet; StringGrid: TStringGrid);
procedure fillBufDatasetFromDataset(SourceDataset: TDataset; BufDataset: TBufDataset);


implementation

procedure fillStringGridFromDataset(DataSet: TDataSet; StringGrid: TStringGrid);
var
  i, j: Integer;
  MaxWidths: array of Integer;
  SampleCount: Integer = 5; // Number of sample records to check for max width
begin
  // Check if the dataset is active
  if not DataSet.Active then
    Exit;

  // Clear existing data in the StringGrid
  StringGrid.Clear;

  // Set the number of columns in the StringGrid based on the number of fields in the dataset
  StringGrid.ColCount := DataSet.FieldCount;

  // Initialize MaxWidths array
  SetLength(MaxWidths, DataSet.FieldCount);

  // Set the column titles in the StringGrid and calculate initial widths based on field names
  for i := 0 to DataSet.FieldCount - 1 do
  begin
    StringGrid.Cells[i, 0] := DataSet.Fields[i].FieldName;
    MaxWidths[i] := Length(DataSet.Fields[i].FieldName) * 6; // Approximate width based on character length
  end;

  // Set the number of rows in the StringGrid based on the number of records in the dataset
  DataSet.First;
  i := 1; // Start from row 1 because row 0 is used for column headers
  while not DataSet.Eof do
  begin
    for j := 0 to DataSet.FieldCount - 1 do
    begin
      StringGrid.Cells[j, i] := DataSet.Fields[j].AsString;
      // Update MaxWidths based on the current cell content
      MaxWidths[j] := Max(MaxWidths[j], Length(DataSet.Fields[j].AsString) * 6);
    end;
    Inc(i);
    DataSet.Next;
    // Limit the number of sample records to check for max width
    if i > SampleCount + 1 then
      Break;
  end;

  // Set the row count in the StringGrid
  StringGrid.RowCount := i;

  // Set the column widths based on the calculated MaxWidths
  for i := 0 to DataSet.FieldCount - 1 do
  begin
    StringGrid.ColWidths[i] := MaxWidths[i];
  end;
end;



procedure fillBufDatasetFromDataset(SourceDataset: TDataset; BufDataset: TBufDataset);
var
  i: Integer;
begin
  // Clear any existing data in the BufDataset
  BufDataset.Close;
  BufDataset.FieldDefs.Clear;

  // Copy field definitions from the source dataset to the BufDataset
  for i := 0 to SourceDataset.FieldCount - 1 do
  begin
    BufDataset.FieldDefs.Add(SourceDataset.Fields[i].FieldName,
                             SourceDataset.Fields[i].DataType,
                             SourceDataset.Fields[i].Size,
                             SourceDataset.Fields[i].Required);
  end;

  // Create the BufDataset structure
  BufDataset.CreateDataSet;

  // Disable controls to improve performance during data loading
  BufDataset.DisableControls;
  try
    // Iterate through the source dataset and append each record to the BufDataset
    SourceDataset.First;
    while not SourceDataset.Eof do
    begin
      BufDataset.Append;
      for i := 0 to SourceDataset.FieldCount - 1 do
      begin
        BufDataset.Fields[i].Assign(SourceDataset.Fields[i]);
      end;
      BufDataset.Post;
      SourceDataset.Next;
    end;
  finally
    BufDataset.EnableControls;
  end;
end;
end.

