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

//  TestFramework.RegisterTest('Данные для загрузки 1С', TdbMeatTest.Suite);

end.
