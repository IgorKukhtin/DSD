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

  TestFramework.RegisterTest('�������Comon', TFunction.Suite);
  TestFramework.RegisterTest('���������Comon', TFunction.Suite);
end.
