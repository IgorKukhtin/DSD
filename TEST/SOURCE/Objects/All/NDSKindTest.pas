unit NDSKindTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest ;

type
  TNDSKindTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
  end;

  TNDSKind = class(TObjectTest)
  public
    function GetDefault: integer;
    constructor Create; override;
  end;
implementation

uses UtilConst;

{TNDSKindTest}
constructor TNDSKind.Create;
begin
  inherited;
  spSelect := 'gpSelect_Object_NDSKind';
end;

procedure TNDSKindTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\NDSKind\';
  inherited;
end;

function TNDSKind.GetDefault: integer;
begin
  result := GetDataSet.FieldByName('Id').AsInteger
end;

initialization
 // TestFramework.RegisterTest('Объекты', TNDSKindTest.Suite);

end.
