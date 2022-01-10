unit ProcessTest;

interface

uses TestFramework, ZConnection, ZDataset, dbTest;

type

  TdbProcessTest = class (TdbTest)
  published
      // загрузка процедура из определенной директории
    procedure CreateProcess;

  end;

implementation


uses zLibUtil;

const
  CommonProcessPath = '..\DATABASE\Merlin\Process\';

{ TdbProcessTest }

procedure TdbProcessTest.CreateProcess;
begin
 DirectoryLoad(CommonProcessPath);
end;



initialization
  TestFramework.RegisterTest('Процессы', TdbProcessTest.Suite);

end.
