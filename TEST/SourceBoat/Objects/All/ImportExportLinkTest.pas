unit ImportExportLinkTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest ;

type
  TImportExportLinkTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
  end;

  TImportExportLink = class(TObjectTest)
  public
    function GetDefault: integer;
    constructor Create; override;
  end;
implementation

uses UtilConst;

{TImportExportLinkTest}
constructor TImportExportLink.Create;
begin
  inherited;
  spSelect := 'gpSelect_Object_ImportExportLink';
end;

procedure TImportExportLinkTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ImportExportLink\';
  inherited;
end;

function TImportExportLink.GetDefault: integer;
begin
  result := GetDataSet.FieldByName('Id').AsInteger
end;

initialization
  TestFramework.RegisterTest('Объекты', TImportExportLinkTest.Suite);


end.
