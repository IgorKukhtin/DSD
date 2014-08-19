unit CommonObjectProcedureTest;

interface

uses dbTest;

type

  TCommonObjectProcedure = class (TdbTest)
  published
    procedure ProcedureLoad; override;
    procedure AllProcedureLoad;
  end;

implementation

uses UtilConst, TestFramework;

{ ОбщиеПроцедурыОбъектов }

procedure TCommonObjectProcedure.AllProcedureLoad;
begin
//  DirectoryLoad(ProcedurePath + 'OBJECTS\')
end;

procedure TCommonObjectProcedure.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\_Common\';
  inherited;
  ScriptDirectory := ProcedurePath + 'OBJECTS\_Union\';
  inherited;
end;

initialization
  TestFramework.RegisterTest('Объекты', TCommonObjectProcedure.Suite);
  TestFramework.RegisterTest('Процедуры', TCommonObjectProcedure.Suite);

end.
