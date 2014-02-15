unit CommonMovementProcedureTest;

interface

uses dbTest;

type

  TCommonMovementProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;


implementation

uses UtilConst, TestFramework;

{ TCommonMovementProcedure }

procedure TCommonMovementProcedure.ProcedureLoad;
begin
  inherited;
  ScriptDirectory := ProcedurePath + 'Movement\_Common\';
  inherited;
end;

initialization

  TestFramework.RegisterTest('Документы', TCommonMovementProcedure.Suite);
  TestFramework.RegisterTest('Процедуры', TCommonMovementProcedure.Suite);

end.
