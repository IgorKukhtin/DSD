unit CommonFunctionTest;

interface
uses dbTest;

type

  TFunction = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;


implementation

uses UtilConst, TestFramework;

{ TCommonMovementProcedure }

procedure TFunction.ProcedureLoad;
begin
  ScriptDirectory := FunctionPath;
  inherited;
end;

initialization

  TestFramework.RegisterTest('ФункцииComon', TFunction.Suite);
  TestFramework.RegisterTest('ПроцедурыComon', TFunction.Suite);
end.
