unit cxGridAddOn;

interface

uses cxGridTableView, Classes, dxmdaset, DBClient;

type

   TcxViewToMemTable = class(TObject)
   private
     procedure LoadAllRecords(GridView: TcxGridTableView; MemData: TdxMemData);
     procedure CreateFields(GridView: TcxGridTableView; MemData: TdxMemData);
     procedure LoadAllRecords2(GridView: TcxGridTableView; MemData: TClientDataSet);
     procedure CreateFields2(GridView: TcxGridTableView; MemData: TClientDataSet);
   public
     function LoadData(GridView: TcxGridTableView): TdxMemData;
     function LoadData2(GridView: TcxGridTableView): TClientDataSet;
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

function TcxViewToMemTable.LoadData2(
  GridView: TcxGridTableView): TClientDataSet;
begin
  result := TClientDataSet.Create(nil);
  CreateFields2(GridView, result);
  LoadAllRecords2(GridView, result);
end;

end.
