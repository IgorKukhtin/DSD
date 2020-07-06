unit CorrespondentAccountTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type
  TCorrespondentAccountTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TCorrespondentAccount = class(TObjectTest)
     function InsertDefault: integer; override;
  public
    function InsertUpdateCorrespondentAccount(const Id, Code: Integer; Name: string; BankAccountId, BankId: integer): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, BankAccountTest, BankTest;

{ TCorrespondentAccountTest }

procedure TCorrespondentAccountTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\CorrespondentAccount\';
  inherited;
end;

procedure TCorrespondentAccountTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TCorrespondentAccount;
begin
  ObjectTest := TCorrespondentAccount.Create;
  // Проверили выполнение Get для 0 записи
  ObjectTest.GetRecord(0);
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Корреспондентский счет
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Корреспондентский счет
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Корреспондентский счет'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

    {TCorrespondentAccount}
constructor TCorrespondentAccount.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_CorrespondentAccount';
  spSelect := 'gpSelect_Object_CorrespondentAccount';
  spGet := 'gpGet_Object_CorrespondentAccount';
end;

function TCorrespondentAccount.InsertDefault: integer;
var
  BankAccountId, BankId: Integer;
begin
  BankAccountId := TBankAccount.Create.GetDefault;
  BankId := TBank.Create.GetDefault;
  result := InsertUpdateCorrespondentAccount(0, -1, 'Корреспондентский счет', BankAccountId, BankId);
  inherited;
end;

function TCorrespondentAccount.InsertUpdateCorrespondentAccount;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inBankAccountId', ftInteger, ptInput, BankAccountId);
  FParams.AddParam('inBankId', ftInteger, ptInput, BankId);
  result := InsertUpdate(FParams);
end;



initialization
  //TestFramework.RegisterTest('Объекты', TCorrespondentAccountTest.Suite);

end.
