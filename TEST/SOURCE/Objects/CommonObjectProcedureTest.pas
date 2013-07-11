unit CommonObjectProcedureTest;

interface

uses dbTest;

type

  TCommonObjectProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;

implementation

uses UtilConst, TestFramework;

{ ОбщиеПроцедурыОбъектов }

procedure TCommonObjectProcedure.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Common';
  inherited;
end;

initialization
  TestFramework.RegisterTest('Объекты', TCommonObjectProcedure.Suite);
  TestFramework.RegisterTest('Процедуры', TCommonObjectProcedure.Suite);

end.
