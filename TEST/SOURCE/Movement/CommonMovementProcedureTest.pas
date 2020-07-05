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
  ScriptDirectory := LocalProcedurePath + 'Movement\_Common\';
  inherited;
//  ZQuery.SQL.LoadFromFile(LocalProcedurePath + 'Movement\lpInsertUpdate_MovementFloat_TotalSumm.sql');
//  ZQuery.ExecSQL;
end;

initialization

//  TestFramework.RegisterTest('Документы', TCommonMovementProcedure.Suite);
//  TestFramework.RegisterTest('Процедуры', TCommonMovementProcedure.Suite);

end.
