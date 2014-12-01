unit FileTypeKindTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest ;

type
  TFileTypeKindTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
  end;

  TFileTypeKind = class(TObjectTest)
  public
    function GetDefault: integer;
    constructor Create; override;
  end;
implementation

uses UtilConst;

{TFileTypeKindTest}
constructor TFileTypeKind.Create;
begin
  inherited;
  spSelect := 'gpSelect_Object_FileTypeKind';
end;

procedure TFileTypeKindTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\FileTypeKind\';
  inherited;
end;

function TFileTypeKind.GetDefault: integer;
begin
  result := GetDataSet.FieldByName('Id').AsInteger
end;

initialization
  TestFramework.RegisterTest('Объекты', TFileTypeKindTest.Suite);

end.
