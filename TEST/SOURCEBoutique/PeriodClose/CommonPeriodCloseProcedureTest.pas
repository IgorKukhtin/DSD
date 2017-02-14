unit CommonPeriodCloseProcedureTest;

interface
uses dbTest;

type

  TPeriodCloseProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;


implementation

uses UtilConst, TestFramework;

{ TCommonMovementProcedure }

procedure TPeriodCloseProcedure.ProcedureLoad;
begin
  inherited;
  ScriptDirectory := ProcedurePath + 'PeriodClose\';
  inherited;
end;

initialization

  TestFramework.RegisterTest('�������� �������', TPeriodCloseProcedure.Suite);
  TestFramework.RegisterTest('���������', TPeriodCloseProcedure.Suite);

end.
