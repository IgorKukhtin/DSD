unit dbMeatTest;

interface
uses TestFramework, dbTest;

type
  TdbMeatTest = class (TdbTest)
  published
    procedure CreateReportProcedure;
  end;


implementation

uses zLibUtil, utilConst;

const
  ReportsPath = '..\DATABASE\MEAT';

{ TdbProcedureTest }


procedure TdbMeatTest.CreateReportProcedure;
begin
  DirectoryLoad(ReportsPath + '\PROCEDURE\');
  DirectoryLoad(ReportsPath + '\METADATA');
end;

initialization

//  TestFramework.RegisterTest('������ ��� �������� 1�', TdbMeatTest.Suite);

end.
