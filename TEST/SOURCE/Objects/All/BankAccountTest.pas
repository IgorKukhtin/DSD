unit BankAccountTest;

interface

uses dbTest, dbObjectTest;

type

  TBankAccountTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TBankAccount = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateBankAccount(Id, Code: Integer; Name: String;
                            JuridicalId, BankId, CurrencyId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, JuridicalTest;

{ TdbUnitTest }

procedure TBankAccountTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\_Cash\';
  inherited;
end;

procedure TBankAccountTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TBankAccount;
begin
  ObjectTest := TBankAccount.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Управленческого счета
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о кассе
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = 'Расчетный счет'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
    // Получим список касс
    Check(ObjectTest.GetDataSet.RecordCount = (RecordCount + 1), 'Количество записей не изменилось');
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TBankAccount}

constructor TBankAccount.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_BankAccount';
  spSelect := 'gpSelect_Object_BankAccount';
  spGet := 'gpGet_Object_BankAccount';
end;

function TBankAccount.InsertDefault: integer;
var
  JuridicalId, BankId, CurrencyId: Integer;
begin
  JuridicalId := TJuridical.Create.GetDefault;
  BankId:= TBankTest.Create.GetDefault;
  CurrencyId:= TCurrencyTest.Create.GetDefault;

  result := InsertUpdateBankAccount(0, -1, 'Расчетный счет', JuridicalId, BankId, CurrencyId);
end;

function TBankAccount.InsertUpdateBankAccount;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inBankId', ftInteger, ptInput, BankId);
  FParams.AddParam('inCurrencyId', ftInteger, ptInput, CurrencyId);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Объекты', TBankAccountTest.Suite);

end.
