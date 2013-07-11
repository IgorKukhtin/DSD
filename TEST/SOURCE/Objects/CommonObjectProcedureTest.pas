unit CommonObjectProcedureTest;

interface

uses dbTest;

type

  ОбщиеПроцедурыОбъектов = class (TdbTest)
  published
    procedure ЗагрузкаПроцедур; override;
  end;

implementation

uses UtilConst, TestFramework;

{ ОбщиеПроцедурыОбъектов }

procedure ОбщиеПроцедурыОбъектов.ЗагрузкаПроцедур;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Common';
  inherited;
end;

initialization
  TestFramework.RegisterTest('Объекты', ОбщиеПроцедурыОбъектов.Suite);
  TestFramework.RegisterTest('Процедуры', ОбщиеПроцедурыОбъектов.Suite);

end.
