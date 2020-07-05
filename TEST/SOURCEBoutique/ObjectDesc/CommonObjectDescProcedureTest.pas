unit CommonObjectDescProcedureTest;

interface

uses dbTest;

type

  TCommonObjectDescProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;


implementation

uses UtilConst, TestFramework;

{ TCommonObjectDescProcedure }

procedure TCommonObjectDescProcedure.ProcedureLoad;
begin
  inherited;
  ScriptDirectory := ProcedurePath + 'ObjectDesc\';
  inherited;
end;

initialization

//  TestFramework.RegisterTest('Процедуры', TCommonObjectDescProcedure.Suite);

end.
