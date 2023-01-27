unit cxGridAddOn;

interface

uses cxGridTableView, Classes, dxmdaset, DBClient, cxDBPivotGrid;

type

   TcxViewToMemTable = class(TObject)
   private
     procedure LoadAllRecords(GridView: TcxGridTableView; MemData: TdxMemData);
     procedure CreateFields(GridView: TcxGridTableView; MemData: TdxMemData);
     procedure LoadAllRecords2(GridView: TcxGridTableView; MemData: TClientDataSet);
     procedure CreateFields2(GridView: TcxGridTableView; MemData: TClientDataSet);
     procedure LoadAllRecords3(PivotGrid: TcxDBPivotGrid; MemData: TClientDataSet);
     procedure CreateFields3(PivotGrid: TcxDBPivotGrid; MemData: TClientDataSet);
   public
     function LoadData(GridView: TcxGridTableView): TdxMemData;
     function LoadData2(GridView: TcxGridTableView): TClientDataSet;
     function LoadData3(PivotGrid: TcxDBPivotGrid): TClientDataSet;
   end;

implementation

uses DB, cxGridDBTableView;

{ TcxViewToMemTable }

procedure TcxViewToMemTable.CreateFields(GridView: TcxGridTableView; MemData: TdxMemData);
var i: integer;
    AField: TField;
begin
    with GridView do
      begin
        for i := 0 to ColumnCount - 1 do
            with TField.Create(MemData) do
              if Assigned(TcxGridDBColumn(Columns[i]).DataBinding.Field) then
              begin
                AField              := DefaultFieldClasses[TcxGridDBColumn(Columns[i]).DataBinding.Field.DataType].Create(MemData);
                AField.Name         := TcxGridDBColumn(Columns[i]).DataBinding.Field.FieldName;

                AField.DisplayLabel := TcxGridDBColumn(Columns[i]).DataBinding.Field.DisplayLabel;
                AField.DisplayWidth := TcxGridDBColumn(Columns[i]).DataBinding.Field.DisplayWidth;
                if TcxGridDBColumn(Columns[i]).DataBinding.Field.DataType in [ftString] then
                   AField.Size      := 255;
                AField.EditMask     := TcxGridDBColumn(Columns[i]).DataBinding.Field.EditMask;
                AField.FieldName    := TcxGridDBColumn(Columns[i]).DataBinding.Field.FieldName;
                AField.Visible      := TcxGridDBColumn(Columns[i]).DataBinding.Field.Visible;
                AField.FieldKind    := TcxGridDBColumn(Columns[i]).DataBinding.Field.FieldKind;
                AField.DataSet      := MemData;
              end;//with TField.Create(fMemData) do

        MemData.FieldDefs.Update;
      end;//with TcxGridDBTableView(fGrid) do
end;

procedure TcxViewToMemTable.LoadAllRecords;
var i, j, c: integer;
begin
  MemData.Open;
  with GridView do
  Begin
    if CloneCount = 0 then
    Begin
      for I := 0 to DataController.FilteredRecordCount - 1 do
      begin
        MemData.Append;
        for j := 0 to ColumnCount - 1 do
          if Assigned(TcxGridDBColumn(columns[j]).DataBinding.Field) then
             if MemData.FindField(TcxGridDBColumn(columns[j]).DataBinding.Field.FieldName) <> nil then
                MemData.FieldByName(TcxGridDBColumn(columns[j]).DataBinding.Field.FieldName).Value :=
                    DataController.Values[DataController.FilteredRecordIndex[i], columns[j].Index];
        MemData.post;
      end;//for I := 0 to fGrid.DataController.FilteredRecordCount - 1 do
    End
    else
    Begin
      FOR C := 0 to CloneCount -1 do
      Begin
        with Clones[C] DO
        Begin
          for I := 0 to DataController.FilteredRecordCount - 1 do
            begin
              MemData.Append;
              for j := 0 to ColumnCount - 1 do
                if Assigned(TcxGridDBColumn(columns[j]).DataBinding.Field) then
                   if MemData.FindField(TcxGridDBColumn(columns[j]).DataBinding.Field.FieldName) <> nil then
                      MemData.FieldByName(TcxGridDBColumn(columns[j]).DataBinding.Field.FieldName).Value :=
                          DataController.Values[DataController.FilteredRecordIndex[i], columns[j].Index];
              MemData.post;
            end;//for I := 0 to fGrid.DataController.FilteredRecordCount - 1 do
        end;
      end;
    End;
  End;
end;

function TcxViewToMemTable.LoadData(
  GridView: TcxGridTableView): TdxMemData;
begin
  result := TdxMemData.Create(nil);
  CreateFields(GridView, result);
  LoadAllRecords(GridView, result);
end;

procedure TcxViewToMemTable.CreateFields2(GridView: TcxGridTableView; MemData: TClientDataSet);
var i: integer;
    AField: TField;
begin
  with GridView do
  begin
    for i := 0 to ColumnCount - 1 do
    Begin
      if Assigned(TcxGridDBColumn(Columns[i]).DataBinding.Field) then
        MemData.FieldDefs.Add(TcxGridDBColumn(Columns[i]).DataBinding.Field.FieldName,
                              TcxGridDBColumn(Columns[i]).DataBinding.Field.DataType,
                              TcxGridDBColumn(Columns[i]).DataBinding.Field.Size,
                              TcxGridDBColumn(Columns[i]).DataBinding.Field.Required);
//            with TField.Create(MemData) do
//              if Assigned(TcxGridDBColumn(Columns[i]).DataBinding.Field) then
//              begin
//                AField              := DefaultFieldClasses[TcxGridDBColumn(Columns[i]).DataBinding.Field.DataType].Create(MemData);
//                AField.Name         := TcxGridDBColumn(Columns[i]).DataBinding.Field.FieldName;
//
//                AField.DisplayLabel := TcxGridDBColumn(Columns[i]).DataBinding.Field.DisplayLabel;
//                AField.DisplayWidth := TcxGridDBColumn(Columns[i]).DataBinding.Field.DisplayWidth;
//                if TcxGridDBColumn(Columns[i]).DataBinding.Field.DataType in [ftString] then
//                   AField.Size      := 255;
//                AField.EditMask     := TcxGridDBColumn(Columns[i]).DataBinding.Field.EditMask;
//                AField.FieldName    := TcxGridDBColumn(Columns[i]).DataBinding.Field.FieldName;
//                AField.Visible      := TcxGridDBColumn(Columns[i]).DataBinding.Field.Visible;
//                AField.FieldKind    := TcxGridDBColumn(Columns[i]).DataBinding.Field.FieldKind;
//                AField.DataSet      := MemData;
//              end;//with TField.Create(fMemData) do
      end;
  end;//with TcxGridDBTableView(fGrid) do
  MemData.CreateDataSet;
  MemData.Active := True;
end;

procedure TcxViewToMemTable.LoadAllRecords2;
var i, j, c: integer;
begin
  MemData.Open;
  with GridView do
  Begin
    if CloneCount = 0 then
    Begin
      for I := 0 to DataController.FilteredRecordCount - 1 do
      begin
        MemData.Append;
        for j := 0 to ColumnCount - 1 do
          if Assigned(TcxGridDBColumn(columns[j]).DataBinding.Field) then
             if MemData.FindField(TcxGridDBColumn(columns[j]).DataBinding.Field.FieldName) <> nil then
                MemData.FieldByName(TcxGridDBColumn(columns[j]).DataBinding.Field.FieldName).Value :=
                    DataController.Values[DataController.FilteredRecordIndex[i], columns[j].Index];
        MemData.post;
      end;//for I := 0 to fGrid.DataController.FilteredRecordCount - 1 do
    End
    else
    Begin
      FOR C := 0 to CloneCount -1 do
      Begin
        with Clones[C] DO
        Begin
          for I := 0 to DataController.FilteredRecordCount - 1 do
            begin
              MemData.Append;
              for j := 0 to ColumnCount - 1 do
                if Assigned(TcxGridDBColumn(columns[j]).DataBinding.Field) then
                   if MemData.FindField(TcxGridDBColumn(columns[j]).DataBinding.Field.FieldName) <> nil then
                      MemData.FieldByName(TcxGridDBColumn(columns[j]).DataBinding.Field.FieldName).Value :=
                          DataController.Values[DataController.FilteredRecordIndex[i], columns[j].Index];
              MemData.post;
            end;//for I := 0 to fGrid.DataController.FilteredRecordCount - 1 do
        end;
      end;
    End;
  End;
end;

procedure TcxViewToMemTable.LoadAllRecords3(PivotGrid: TcxDBPivotGrid; MemData: TClientDataSet);
var i, j, c: integer; bAdd : boolean;
begin
  MemData.Open;
  with PivotGrid.DataSource.DataSet do
  Begin
    First;
    while not Eof do
    begin
      bAdd := True;
      for j := 0 to FieldCount - 1 do
        for c := 0 to PivotGrid.FieldCount - 1 do
          if TcxDBPivotGridField(PivotGrid.Fields[c]).DataBinding.DBField.FieldName = Fields[j].FieldName then
             if (TcxDBPivotGridField(PivotGrid.Fields[c]).Filter.Values.Count > 0) then
                bAdd := bAdd and TcxDBPivotGridField(PivotGrid.Fields[c]).Filter.Contains(Fields[j].Value);

      if bAdd then
      begin
        MemData.Append;
        for j := 0 to FieldCount - 1 do
           if MemData.FindField(Fields[j].FieldName) <> nil then
              MemData.FieldByName(Fields[j].FieldName).Value := Fields[j].Value;
        MemData.post;
      end;
      Next;
    end;
  End;

//  with PivotGrid do
//  Begin
//    for I := 0 to DataController.FilteredRecordCount - 1 do
//    begin
//      MemData.Append;
//      for j := 0 to FieldCount - 1 do
//        if Assigned(TcxDBPivotGridField(Fields[j]).DataBinding.Field) then
//           if MemData.FindField(TcxDBPivotGridField(Fields[j]).DataBinding.DBField.FieldName) <> nil then
//              MemData.FieldByName(TcxDBPivotGridField(Fields[j]).DataBinding.DBField.FieldName).Value :=
//                  DataController.Values[DataController.FilteredRecordIndex[i], Fields[j].Index];
//      MemData.post;
//    end;
//  End;
end;

procedure TcxViewToMemTable.CreateFields3(PivotGrid: TcxDBPivotGrid; MemData: TClientDataSet);
var i: integer;
    AField: TField;
begin
  with PivotGrid.DataSource.DataSet do
  begin
    for i := 0 to FieldCount - 1 do
    Begin
        MemData.FieldDefs.Add(Fields[i].FieldName,
                              Fields[i].DataType,
                              Fields[i].Size,
                              Fields[i].Required);
      end;
  end;//with TcxGridDBTableView(fGrid) do
//  with PivotGrid do
//  begin
//    for i := 0 to FieldCount - 1 do
//    Begin
//      if Assigned(TcxDBPivotGridField(Fields[i]).DataBinding.DBField) then
//        MemData.FieldDefs.Add(TcxDBPivotGridField(Fields[i]).DataBinding.DBField.FieldName,
//                              TcxDBPivotGridField(Fields[i]).DataBinding.DBField.DataType,
//                              TcxDBPivotGridField(Fields[i]).DataBinding.DBField.Size,
//                              TcxDBPivotGridField(Fields[i]).DataBinding.DBField.Required);
//      end;
//  end;//with TcxGridDBTableView(fGrid) do
  MemData.CreateDataSet;
  MemData.Active := True;
end;

function TcxViewToMemTable.LoadData2(
  GridView: TcxGridTableView): TClientDataSet;
begin
  result := TClientDataSet.Create(nil);
  CreateFields2(GridView, result);
  LoadAllRecords2(GridView, result);
end;

function TcxViewToMemTable.LoadData3(PivotGrid: TcxDBPivotGrid): TClientDataSet;
begin
  result := TClientDataSet.Create(nil);
  CreateFields3(PivotGrid, result);
  LoadAllRecords3(PivotGrid, result);
end;

end.
