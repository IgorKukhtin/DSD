unit GoodsKindTest;

interface
uses dbTest, dbObjectTest, TestFramework, ObjectTest;
   type
  TGoodsKindTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

   TGoodsKind = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoodsKind(Id, Code: Integer; Name: String): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;

 {TGoodsKindTest}
constructor TGoodsKind.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_GoodsKind';
  spSelect := 'gpSelect_Object_GoodsKind';
  spGet := 'gpGet_Object_GoodsKind';
end;

function TGoodsKind.InsertDefault: integer;
begin
  result := InsertUpdateGoodsKind(0, -1, 'Вид товара');
  inherited;
end;

function TGoodsKind.InsertUpdateGoodsKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TGoodsKindTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\GoodsKind\';
  inherited;
end;

procedure TGoodsKindTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsKind;
begin
  ObjectTest := TGoodsKind.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Вида товара
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Виде товара
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Вид товара'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;
    initialization
  //TestFramework.RegisterTest('Объекты', TGoodsKindTest.Suite);
end.
