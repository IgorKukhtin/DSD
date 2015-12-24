unit ChangeIncomePaymentKindTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest ;

type
  TChangeIncomePaymentKindTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
  end;

  TChangeIncomePaymentKind = class(TObjectTest)
  public
    function GetDefault: integer;
    constructor Create; override;
  end;
implementation

uses UtilConst;

{TChangeIncomePaymentKindTest}
constructor TChangeIncomePaymentKind.Create;
begin
  inherited;
  spSelect := 'gpSelect_Object_ChangeIncomePaymentKind';
end;

procedure TChangeIncomePaymentKindTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\ChangeIncomePaymentKind\';
  inherited;
end;

function TChangeIncomePaymentKind.GetDefault: integer;
begin
  result := GetDataSet.FieldByName('Id').AsInteger
end;

initialization
  TestFramework.RegisterTest('Объекты', TChangeIncomePaymentKindTest.Suite);

end.
