unit cxGridAddOn;

interface

uses cxGridTableView, Classes, dxmdaset;

type

   TcxViewToMemTable = class(TObject)
   private
     procedure LoadAllRecords(GridView: TcxGridTableView; MemData: TdxMemData);
     procedure CreateFields(GridView: TcxGridTableView; MemData: TdxMemData);
   public
     function LoadData(GridView: TcxGridTableView): TdxMemData;
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
var i, j: integer;
begin
  MemData.Open;
  with GridView do
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

function TcxViewToMemTable.LoadData(
  GridView: TcxGridTableView): TdxMemData;
begin
  result := TdxMemData.Create(nil);
  CreateFields(GridView, result);
  LoadAllRecords(GridView, result);
end;

end.
