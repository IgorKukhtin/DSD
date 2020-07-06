unit ProfitLossTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TProfitLossTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TProfitLoss = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateProfitLoss(const Id, Code : integer; Name: string; ProfitLossGroupId: Integer;
                                     ProfitLossDirectionId, InfoMoneyDestinationId, InfoMoneyId: integer): integer;
    constructor Create; override;
  end;
implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, DB, ProfitLossGroupTest, ProfitLossDirectionTest;

{TProfitLossTest}
 constructor TProfitLoss.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ProfitLoss';
  spSelect := 'gpSelect_Object_ProfitLoss';
  spGet := 'gpGet_Object_ProfitLoss';
end;

function TProfitLoss.InsertDefault: integer;
var
  ProfitLossGroupId: Integer;
  ProfitLossDirectionId: Integer;
 // InfoMoneyDestinationId: Integer;
 // InfoMoneyId: Integer;
begin
  ProfitLossGroupId := TProfitLossGroup.Create.GetDefault;
  ProfitLossDirectionId:= TProfitLossDirection.Create.GetDefault;
  result := InsertUpdateProfitLoss(0, -3, 'Управленческие счет 1', ProfitLossGroupId, ProfitLossDirectionId, 1, 1);
  inherited;
end;

function TProfitLoss.InsertUpdateProfitLoss;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inProfitLossGroupId', ftInteger, ptInput, ProfitLossGroupId);
  FParams.AddParam('inProfitLossDirectionId', ftInteger, ptInput, ProfitLossDirectionId);
  FParams.AddParam('inInfoMoneyDestinationId', ftInteger, ptInput, InfoMoneyDestinationId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  result := InsertUpdate(FParams);
end;

procedure TProfitLossTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ProfitLoss\';
  inherited;
end;


procedure TProfitLossTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TProfitLoss;
begin
  ObjectTest := TProfitLoss.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Управленческие счет 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
 // TestFramework.RegisterTest('Объекты', TProfitLossTest.Suite);

end.
