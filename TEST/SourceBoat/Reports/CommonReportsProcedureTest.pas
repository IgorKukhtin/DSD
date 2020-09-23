unit CommonReportsProcedureTest;

interface

uses dbTest;

type

  TCommonReportsProcedureProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;


implementation

uses UtilConst, TestFramework;

{ TCommonMovementProcedure }

procedure TCommonReportsProcedureProcedure.ProcedureLoad;
begin
  inherited;
  ScriptDirectory := ReportsPath + 'Common\';
  inherited;
end;

initialization

  TestFramework.RegisterTest('������', TCommonReportsProcedureProcedure.Suite);
  TestFramework.RegisterTest('���������', TCommonReportsProcedureProcedure.Suite);

end.
