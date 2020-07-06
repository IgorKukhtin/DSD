unit dbCreateViewTest;

interface

uses dbTest;

type

  TView = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;

implementation

uses UtilConst, TestFramework;

{ ОбщиеПроцедурыОбъектов }

procedure TView.ProcedureLoad;
begin

  ScriptDirectory := ViewPath;
  inherited;
  ScriptDirectory := LocalViewPath;
  inherited;
end;

initialization
//  TestFramework.RegisterTest('VIEW', TView.Suite);

end.
