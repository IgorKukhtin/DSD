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

  TestFramework.RegisterTest('����������', TCommonContainerProcedure.Suite);
  TestFramework.RegisterTest('���������', TCommonContainerProcedure.Suite);

end.
