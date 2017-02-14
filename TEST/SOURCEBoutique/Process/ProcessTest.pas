unit ProcessTest;

interface

uses TestFramework, ZConnection, ZDataset, dbTest;

type

  TdbProcessTest = class (TdbTest)
  published
      // �������� ��������� �� ������������ ����������
    procedure CreateProcess;

  end;

implementation


uses zLibUtil;

const
  CommonProcessPath = '..\DATABASE\Boutique\Process\';

{ TdbProcessTest }

procedure TdbProcessTest.CreateProcess;
begin
 DirectoryLoad(CommonProcessPath);
end;



initialization
  TestFramework.RegisterTest('��������', TdbProcessTest.Suite);

end.
