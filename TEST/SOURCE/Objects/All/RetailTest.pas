unit RetailTest;

interface
uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TRetailTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;


  TRetail = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
   function InsertUpdateRetail(const Id: integer; Code: Integer;
        Name, GLNCode: string): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, DB;

{ TCurrencyTest }

constructor TRetail.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Retail';
  spSelect := 'gpSelect_Object_Retail';
  spGet := 'gpGet_Object_Retail';
end;

function TRetail.InsertDefault: integer;
begin
  result := InsertUpdateRetail(0, -1, 'Торговая сеть', '6543567');
end;

function TRetail.InsertUpdateRetail(const Id: integer; Code: Integer;
  Name, GlnCode: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inGlnCode', ftString, ptInput, GlnCode);
  result := InsertUpdate(FParams);
end;

procedure TRetailTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Retail\';
  inherited;
end;

procedure TRetailTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TRetail;
begin
  ObjectTest := TRetail.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;

  if ObjectTest.GetDataSet.Locate('Name', 'Торговая сеть', []) then
     Id := ObjectTest.GetDataSet.FieldByName('Id').AsInteger
  else
     // Вставка Филиала
     Id := ObjectTest.InsertDefault;

  try
    // Получение данных о Филиале
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Торговая сеть'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
 // TestFramework.RegisterTest('Объекты', TRetailTest.Suite);

end.
