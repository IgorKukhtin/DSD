unit AdvertisingTest;

interface

uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TAdvertisingTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

 TAdvertising = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateAdvertising(Id, Code: Integer; Name: String): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, Data.DB;

     { TAdvertisingTest }

constructor TAdvertising.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Advertising';
  spSelect := 'gpSelect_Object_Advertising';
  spGet := 'gpGet_Object_Advertising';
end;

function TAdvertising.InsertDefault: integer;
begin
  result := InsertUpdateAdvertising(0, -1, 'Рекламная поддержка 1');
  inherited;
end;

function TAdvertising.InsertUpdateAdvertising(Id, Code: Integer; Name: String): integer;

begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TAdvertisingTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Advertising\';
  inherited;
end;

procedure TAdvertisingTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAdvertising;
begin
  ObjectTest := TAdvertising.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка объекта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о рекламе
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Рекламная поддержка 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TAdvertisingTest.Suite);

end.
