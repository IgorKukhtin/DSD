unit dbLoadTest;

interface

uses dbTest;

type

  TLoadTest = class (TdbTest)
  published
    procedure ProcedureLoad; override;
  end;

implementation

uses UtilConst, TestFramework;

const
  CommonFunctionPath = '..\DATABASE\COMMON\FUNCTION\';
  CommonProcedurePath = '..\DATABASE\COMMON\PROCEDURE\';
  CommonReportsPath = '..\DATABASE\COMMON\REPORTS\';

  FarmacyFunctionPath = '..\DATABASE\Farmacy\FUNCTION\';
  FarmacyProcedurePath = '..\DATABASE\Farmacy\PROCEDURE\';
  FarmacyReportsPath = '..\DATABASE\Farmacy\REPORTS\';


{ ОбщиеПроцедурыОбъектов }

procedure TLoadTest.ProcedureLoad;
begin
  ScriptDirectory := FarmacyProcedurePath + 'Load\';
  inherited;
end;

initialization
  TestFramework.RegisterTest('Load', TLoadTest.Suite);

end.
