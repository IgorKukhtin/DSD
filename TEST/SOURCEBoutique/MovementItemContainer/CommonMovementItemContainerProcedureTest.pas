unit CommonMovementItemContainerProcedureTest;

interface

uses dbTest;

type

  TCommonMovementItemContainerProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;

implementation

uses UtilConst, TestFramework;

{ TCommonMovementProcedure }

procedure TCommonMovementItemContainerProcedure.ProcedureLoad;
begin
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\';
  inherited;
end;

initialization

  TestFramework.RegisterTest('���������� ����������', TCommonMovementItemContainerProcedure.Suite);
  TestFramework.RegisterTest('���������', TCommonMovementItemContainerProcedure.Suite);

end.
