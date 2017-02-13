unit CommonMovementItemProcedureTest;

interface

uses dbTest;

type

  TCommonMovementItemProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;


implementation

uses UtilConst, TestFramework;

{ TCommonMovementProcedure }

procedure TCommonMovementItemProcedure.ProcedureLoad;
begin
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\_Common\';
  inherited;
end;

initialization

  TestFramework.RegisterTest('������ ����������', TCommonMovementItemProcedure.Suite);
  TestFramework.RegisterTest('���������', TCommonMovementItemProcedure.Suite);

end.
