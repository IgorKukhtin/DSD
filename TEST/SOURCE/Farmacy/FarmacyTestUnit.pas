unit FarmacyTestUnit;

interface

uses TestFramework;

type
  TFarmacyTest = class (TTestCase)
  private
    function InsertCash(CashName: string): string;
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure CashFoundationTest;
  end;


implementation

{ TFarmacyTest }

uses dsdDataSetWrapperUnit, Db, UtilType;

procedure TFarmacyTest.CashFoundationTest;
begin
  // Добавляем кассу
  // Создаем операцию "Расчеты с учредителями"
  // Проводим документ
  // Проверяем формирование баланса

end;

function TFarmacyTest.InsertCash(CashName: string): string;
begin
  with TdsdStoredProc.Create(nil) do
  try
    StoredProcName := 'gpInsertUpdate_Cash';
    OutputType := otResult;
    Params.AddParam('Id', ftInteger, ptInputOutput, 0);
    Params.AddParam('Name', ftString, ptInput, 'Главная касса');
    Execute;
    result := ParamByName('Id').Value
  finally
    Free;
  end;
end;

procedure TFarmacyTest.SetUp;
begin
  inherited;

end;

procedure TFarmacyTest.TearDown;
begin
  inherited;

end;

initialization
  TestFramework.RegisterTest('TFarmacyTest', TFarmacyTest.Suite);


end.
