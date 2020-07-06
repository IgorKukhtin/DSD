unit ReturnTypeTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest ;

type
  TReturnTypeTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TReturnType = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateReturnType(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;
implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;
     {TReturnTypeTest}
constructor TReturnType.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ReturnType';
  spSelect := 'gpSelect_Object_ReturnType';
  spGet := 'gpGet_Object_ReturnType';
end;

function TReturnType.InsertDefault: integer;
begin
  result := InsertUpdateReturnType(0, -3, 'Вид возврата');
  inherited;
end;

function TReturnType.InsertUpdateReturnType;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TReturnTypeTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ReturnType\';
  inherited;
end;


procedure TReturnTypeTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReturnType;
begin
  ObjectTest := TReturnType.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Вида возврата
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Виде возврата
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Вид возврата'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
 // TestFramework.RegisterTest('Объекты', TReturnTypeTest.Suite);

end.
