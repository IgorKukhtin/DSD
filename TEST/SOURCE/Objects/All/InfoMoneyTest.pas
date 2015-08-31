unit InfoMoneyTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TInfoMoneyTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

   TInfoMoney = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateInfoMoney(const Id, Code : integer; Name: string; InfoMoneyGroupId: Integer;
                                     InfoMoneyDestinationId: integer): integer;
    constructor Create; override;
  end;
implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, DB, InfoMoneyGroupTest, InfoMoneyDestinationTest;

     {TInfoMoneyTest}
 constructor TInfoMoney.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_InfoMoney';
  spSelect := 'gpSelect_Object_InfoMoney';
  spGet := 'gpGet_Object_InfoMoney';
end;

function TInfoMoney.InsertDefault: integer;
var
  InfoMoneyGroupId: Integer;
  InfoMoneyDestinationId: Integer;
begin
  InfoMoneyGroupId := TInfoMoneyGroup.Create.GetDefault;
  InfoMoneyDestinationId:= TInfoMoneyDestination.Create.GetDefault;;
  result := InsertUpdateInfoMoney(0, -3, 'Управленческие аналитики 1', InfoMoneyGroupId, InfoMoneyDestinationId);
  inherited;
end;

function TInfoMoney.InsertUpdateInfoMoney;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inInfoMoneyGroupId', ftInteger, ptInput, InfoMoneyGroupId);
  FParams.AddParam('inInfoMoneyDestinationId', ftInteger, ptInput, InfoMoneyDestinationId);
  FParams.AddParam('inisProfitLoss', ftBoolean, ptInput, False);
  result := InsertUpdate(FParams);
end;

procedure TInfoMoneyTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\InfoMoney\';
  inherited;
end;

procedure TInfoMoneyTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TInfoMoney;
begin
  ObjectTest := TInfoMoney.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Управленческие аналитики 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TInfoMoneyTest.Suite);

end.
