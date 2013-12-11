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

const
  ProcessPath = '..\DATABASE\COMMON\PROCESS\';

{ TdbProcessTest }

procedure TdbProcessTest.ProcedureLoad;
begin
  ScriptDirectory := ProcessPath;
  inherited;
end;

initialization
  TestFramework.RegisterTest('Процессы', TdbProcessTest.Suite);

end.
