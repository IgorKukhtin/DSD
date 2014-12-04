unit ProcessTest;

interface
uses TestFramework, DB, dbTest;

type

  TdbProcessTest = class (TdbTest)
  published
      // загрузка процедура из определенной директории
    procedure ProcedureLoad; override;
  end;

implementation

uses UtilConst;

{ TdbProcessTest }

procedure TdbProcessTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcessPath;
  inherited;
end;

initialization
  TestFramework.RegisterTest('Процессы', TdbProcessTest.Suite);

end.
