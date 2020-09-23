unit BankTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type
  TBankTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TBank = class(TObjectTest)
     function InsertDefault: integer; override;
  public
    function InsertUpdateBank(const Id, Code: Integer; Name, MFO, SWIFT, IBAN: string; JuridicalId: integer): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, JuridicalTest;

{ TBankTest }

procedure TBankTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Bank\';
  inherited;
end;

procedure TBankTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TBank;
begin
  ObjectTest := TBank.Create;
  // Проверили выполнение Get для 0 записи
  ObjectTest.GetRecord(0);
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Банка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о банке
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Банк'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

    {TBank}
constructor TBank.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Bank';
  spSelect := 'gpSelect_Object_Bank';
  spGet := 'gpGet_Object_Bank';
end;

function TBank.InsertDefault: integer;
var
  JuridicalId: Integer;
begin
  JuridicalId := TJuridical.Create.GetDefault;
  result := InsertUpdateBank(0, -1, 'Банк', 'МФО', 'SWIFT', 'IBAN', JuridicalId);
  inherited;
end;

function TBank.InsertUpdateBank;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inMFO', ftString, ptInput, MFO);
  FParams.AddParam('inSWIFT', ftString, ptInput, SWIFT);
  FParams.AddParam('inIBAN', ftString, ptInput, IBAN);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  result := InsertUpdate(FParams);
end;



initialization
  TestFramework.RegisterTest('Объекты', TBankTest.Suite);

end.
