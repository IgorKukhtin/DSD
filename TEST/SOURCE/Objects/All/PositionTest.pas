unit PositionTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TPositionTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

    TPosition = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdatePosition(const Id, Code : integer; Name: string): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, DB, CarModelTest,
     InfoMoneyGroupTest, InfoMoneyDestinationTest;

     { TPositionTest }
constructor TPosition.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Position';
  spSelect := 'gpSelect_Object_Position';
  spGet := 'gpGet_Object_Position';
end;

function TPosition.InsertDefault: integer;
begin
  result := InsertUpdatePosition(0, -1, 'Должности');
end;

function TPosition.InsertUpdatePosition(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

  procedure TPositionTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Position\';
  inherited;
end;

procedure TPositionTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPosition;
begin
  ObjectTest := TPosition.Create;
  // Получим список
RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка группы
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Должности'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;
initialization
  //TestFramework.RegisterTest('Объекты', TPositionTest.Suite);
end.
