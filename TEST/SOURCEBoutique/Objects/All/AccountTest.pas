unit AccountTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TAccountTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TAccount = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateAccount(const Id, Code : integer; Name: string; AccountGroupId: Integer;
                                     AccountDirectionId, InfoMoneyDestinationId, InfoMoneyId: integer): integer;
    constructor Create; override;
  end;


implementation

uses DB, UtilConst, TestFramework, SysUtils, AccountGroupTest,
     AccountDirectionTest;

{ TdbUnitTest }

procedure TAccountTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Account\';
  inherited;
end;

procedure TAccountTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAccount;
begin
  ObjectTest := TAccount.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Управленческого счета
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Упр.счете
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Test - Управленческие счет 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TAccount}
constructor TAccount.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Account';
  spSelect := 'gpSelect_Object_Account';
  spGet := 'gpGet_Object_Account';
end;

function TAccount.InsertDefault: integer;
var
  AccountGroupId: Integer;
  AccountDirectionId: Integer;
begin
  AccountGroupId := TAccountGroup.Create.GetDefault;
  AccountDirectionId:= TAccountDirection.Create.GetDefault;;
  result := InsertUpdateAccount(0, -3, 'Test - Управленческие счет 1', AccountGroupId, AccountDirectionId, 1,1);
  inherited;
end;

function TAccount.InsertUpdateAccount;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inAccountGroupId', ftInteger, ptInput, AccountGroupId);
  FParams.AddParam('inAccountDirectionId', ftInteger, ptInput, AccountDirectionId);
  FParams.AddParam('inInfoMoneyDestinationId', ftInteger, ptInput, InfoMoneyDestinationId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  result := InsertUpdate(FParams);
end;


initialization
  TestFramework.RegisterTest('Объекты', TAccountTest.Suite);

end.
