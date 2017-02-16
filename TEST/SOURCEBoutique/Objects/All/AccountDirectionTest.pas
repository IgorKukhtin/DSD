unit AccountDirectionTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TAccountDirectionTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

    TAccountDirection= class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateAccountDirection(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, // JuridicalTest,
      Data.DB;

     { TAccountDirectionTest }
constructor TAccountDirection.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_AccountDirection';
  spSelect := 'gpSelect_Object_AccountDirection';
  spGet := 'gpGet_Object_AccountDirection';
end;

function TAccountDirection.InsertDefault: integer;
begin
  result := InsertUpdateAccountDirection(0, -4, 'Аналитики управленческих счетов 1');
  inherited;
end;

function TAccountDirection.InsertUpdateAccountDirection(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TAccountDirectionTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\AccountDirection\';
  inherited;
end;


procedure TAccountDirectionTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAccountDirection;
begin
  ObjectTest := TAccountDirection.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка группы урп.счетов
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Аналитики управленческих счетов 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TAccountDirectionTest.Suite);

end.
