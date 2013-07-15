unit CommonObjectHistoryProcedureTest;

interface
uses dbTest;

type

  TObjectHistoryProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;


implementation

uses UtilConst, TestFramework;

{ TCommonMovementProcedure }

procedure TObjectHistoryProcedure.ProcedureLoad;
begin
  inherited;
  ScriptDirectory := ProcedurePath + 'ObjectHistory\Common\';
  inherited;
end;

initialization

  TestFramework.RegisterTest('Истории', TObjectHistoryProcedure.Suite);
  TestFramework.RegisterTest('Процедуры', TObjectHistoryProcedure.Suite);
end.
