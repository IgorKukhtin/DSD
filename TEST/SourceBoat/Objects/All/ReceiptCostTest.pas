unit ReceiptCostTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TReceiptCostTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

    TReceiptCost = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateReceiptCost(const Id, Code : integer; Name: string): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, DB, CarModelTest,
     InfoMoneyGroupTest, InfoMoneyDestinationTest, AssetGroupTest;
{TReceiptCostTest}
constructor TReceiptCost.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ReceiptCost';
  spSelect := 'gpSelect_Object_ReceiptCost';
  spGet := 'gpGet_Object_ReceiptCost';
end;

function TReceiptCost.InsertDefault: integer;
begin
   result := InsertUpdateReceiptCost(0, -1, 'Затраты в рецептурах');
end;

function TReceiptCost.InsertUpdateReceiptCost;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TReceiptCostTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ReceiptCost\';
  inherited;
end;

procedure TReceiptCostTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReceiptCost;
begin
  ObjectTest := TReceiptCost.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка объекта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Затраты в рецептурах'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TReceiptCostTest.Suite);

end.
