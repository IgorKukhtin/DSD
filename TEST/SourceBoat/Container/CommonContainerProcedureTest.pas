unit CommonContainerProcedureTest;

interface

uses dbTest;

type

  TCommonContainerProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;


implementation

uses UtilConst, TestFramework;

{ TCommonMovementProcedure }

procedure TCommonContainerProcedure.ProcedureLoad;
begin
  inherited;
  ScriptDirectory := ProcedurePath + 'Container\';
  inherited;
end;

initialization

  TestFramework.RegisterTest('Контейнеры', TCommonContainerProcedure.Suite);
  TestFramework.RegisterTest('Процедуры', TCommonContainerProcedure.Suite);

end.
