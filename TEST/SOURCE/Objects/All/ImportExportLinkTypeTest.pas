unit ImportExportLinkTypeTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest ;

type
  TImportExportLinkTypeTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
  end;

  TImportExportLinkType = class(TObjectTest)
  public
    function GetDefault: integer;
    constructor Create; override;
  end;
implementation

uses UtilConst;

{TImportExportLinkTypeTest}
constructor TImportExportLinkType.Create;
begin
  inherited;
  spSelect := 'gpSelect_Object_ImportExportLinkType';
end;

procedure TImportExportLinkTypeTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ImportExportLinkType\';
  inherited;
end;

function TImportExportLinkType.GetDefault: integer;
begin
  result := GetDataSet.FieldByName('Id').AsInteger
end;

initialization
 // TestFramework.RegisterTest('Объекты', TImportExportLinkTypeTest.Suite);

end.
