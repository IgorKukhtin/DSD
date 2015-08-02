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
end;

initialization

  TestFramework.RegisterTest('���������', TCommonMovementProcedure.Suite);
  TestFramework.RegisterTest('���������', TCommonMovementProcedure.Suite);

end.
