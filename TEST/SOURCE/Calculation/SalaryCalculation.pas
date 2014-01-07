unit SalaryCalculation;

interface

uses TestFramework, dbTest;

type

  TCalculateTest = class (TdbTest)
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; override;
    procedure Test;
  end;


implementation

{ TCalculateTest }

procedure TCalculateTest.ProcedureLoad;
begin
  inherited;

end;

procedure TCalculateTest.Test;
begin
  // Получаем данные о расчете по одному человеку и подразделению за период

  // Проверили результат
end;

initialization
  TestFramework.RegisterTest('Расчеты', TCalculateTest.Suite);

end.
