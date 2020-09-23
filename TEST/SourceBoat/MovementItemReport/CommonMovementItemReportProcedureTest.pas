unit CommonMovementItemReportProcedureTest;

interface

uses dbTest;

type

  TCommonMovementItemReportProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;

implementation

uses UtilConst, TestFramework;

{ TCommonMovementProcedure }

procedure TCommonMovementItemReportProcedure.ProcedureLoad;
begin
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemReport\';
  inherited;
end;

initialization

//  TestFramework.RegisterTest('Процедуры', TCommonMovementItemReportProcedure.Suite);

end.
