unit CommonObjectCostProcedureTest;

interface

uses dbTest;

type

  TObjectCostProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;


implementation

uses UtilConst, TestFramework;

{ TCommonMovementProcedure }

procedure TObjectCostProcedure.ProcedureLoad;
begin
  inherited;
  ScriptDirectory := ProcedurePath + 'ObjectCost\';
  inherited;
end;

initialization

//  TestFramework.RegisterTest('Себестоимость', TObjectCostProcedure.Suite);
//  TestFramework.RegisterTest('Процедуры', TObjectCostProcedure.Suite);

end.
