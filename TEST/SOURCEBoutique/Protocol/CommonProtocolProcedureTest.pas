unit CommonProtocolProcedureTest;

interface
uses dbTest;

type

  TProtocolProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;


implementation

uses UtilConst, TestFramework;

{ TCommonMovementProcedure }

procedure TProtocolProcedure.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Protocol\';
  inherited;
end;

initialization

  TestFramework.RegisterTest('��������', TProtocolProcedure.Suite);
  TestFramework.RegisterTest('���������', TProtocolProcedure.Suite);
end.
