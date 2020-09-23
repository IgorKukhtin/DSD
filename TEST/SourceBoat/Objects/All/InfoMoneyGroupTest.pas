unit InfoMoneyGroupTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TInfoMoneyGroupTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

   TInfoMoneyGroup = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateInfoMoneyGroup(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, DB;

{ TInfoMoneyGroupTest }
constructor TInfoMoneyGroup.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_InfoMoneyGroup';
  spSelect := 'gpSelect_Object_InfoMoneyGroup';
  spGet := 'gpGet_Object_InfoMoneyGroup';
end;

function TInfoMoneyGroup.InsertDefault: integer;
begin
  result := InsertUpdateInfoMoneyGroup(0, -4, 'Группы управленческих аналитик 1');
  inherited;
end;

function TInfoMoneyGroup.InsertUpdateInfoMoneyGroup(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TInfoMoneyGroupTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\InfoMoneyGroup\';
  inherited;
end;

procedure TInfoMoneyGroupTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TInfoMoneyGroup;
begin
  ObjectTest := TInfoMoneyGroup.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Группы управленческих аналитик 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization

//  TestFramework.RegisterTest('Объекты', TInfoMoneyGroupTest.Suite);

end.
