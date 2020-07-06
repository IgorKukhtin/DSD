unit BankAccountTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

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
                            JuridicalId, BankId, CurrencyId, CorrespondentBankId, BeneficiarysBankId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, JuridicalTest,
     BankTest, CurrencyTest;

{ TdbUnitTest }

procedure TBankAccountTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\BankAccount\';
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
  JuridicalId, BankId, CurrencyId, CorrespondentBankId, BeneficiarysBankId: Integer;
begin
  JuridicalId := TJuridical.Create.GetDefault;
  BankId:= TBank.Create.GetDefault;
  CorrespondentBankId:= TBank.Create.GetDefault;
  BeneficiarysBankId:= TBank.Create.GetDefault;
  WITH TCurrency.Create.GetDataSet do
    CurrencyId:= FieldByName('Id').AsInteger;

  result := InsertUpdateBankAccount(0, -1, 'Расчетный счет', JuridicalId, BankId, CurrencyId, CorrespondentBankId, BeneficiarysBankId);
  inherited;
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
  FParams.AddParam('inCorrespondentBankId', ftInteger, ptInput, CorrespondentBankId);
  FParams.AddParam('inBeneficiarysBankId', ftInteger, ptInput, BeneficiarysBankId);
  FParams.AddParam('inCorrespondentAccount', ftString, ptInput, '');
  FParams.AddParam('inBeneficiarysBankAccount', ftString, ptInput, '');
  FParams.AddParam('inBeneficiarysAccount', ftString, ptInput, '');
  result := InsertUpdate(FParams);
end;

initialization
  //TestFramework.RegisterTest('Объекты', TBankAccountTest.Suite);

end.
