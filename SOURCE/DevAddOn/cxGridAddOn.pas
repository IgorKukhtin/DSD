unit cxGridAddOn;

interface

uses cxGridTableView, Classes, dxmdaset;

type

   TcxViewToMemTable = class(TObject)
   private
     function  GetValidName(AOwner: TComponent; AName: string): string;
     procedure LoadAllRecords;
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
          if Columns[i].Visible then
            with TField.Create(MemData) do
              begin
                AField              := DefaultFieldClasses[TcxGridDBColumn(Columns[i]).DataBinding.Field.DataType].Create(MemData);
                AField.Name         := GetValidName(MemData, Name + TcxGridDBColumn(Columns[i]).DataBinding.Field.FieldName);

                AField.DisplayLabel := TcxGridDBColumn(Columns[i]).DataBinding.Field.DisplayLabel;
                AField.DisplayWidth := TcxGridDBColumn(Columns[i]).DataBinding.Field.DisplayWidth;
                AField.EditMask     := TcxGridDBColumn(Columns[i]).DataBinding.Field.EditMask;
                AField.FieldName    := TcxGridDBColumn(Columns[i]).DataBinding.Field.FieldName;
                AField.Visible      := TcxGridDBColumn(Columns[i]).DataBinding.Field.Visible;
                AField.FieldKind    := TcxGridDBColumn(Columns[i]).DataBinding.Field.FieldKind;
                AField.DataSet      := MemData;
              end;//with TField.Create(fMemData) do

        MemData.FieldDefs.Update;
      end;//with TcxGridDBTableView(fGrid) do
end;

function TcxViewToMemTable.GetValidName(AOwner: TComponent;
  AName: string): string;
begin

end;

procedure TcxViewToMemTable.LoadAllRecords;
begin

end;

function TcxViewToMemTable.LoadData(
  GridView: TcxGridTableView): TdxMemData;
begin

end;

end.
