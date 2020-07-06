unit GoodsTest;

interface

uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TGoodsTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

 TGoods = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoods(Id, Code: Integer; Name: String;
                               Weight: Double;
                               GoodsGroupId, MeasureId, TradeMarkId,ItemInfoMoneyId,BusinessId,FuelId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;

     { TGoodsTest }

constructor TGoods.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Goods';
  spSelect := 'gpSelect_Object_Goods';
  spGet := 'gpGet_Object_Goods';
end;

function TGoods.InsertDefault: integer;
begin
  result := InsertUpdateGoods(0, -1, 'Товар 1', 1.0, 0, 0, 0, 0, 0, 0);
  inherited;
end;

function TGoods.InsertUpdateGoods(Id, Code: Integer; Name: String;
                                      Weight: Double;
                                      GoodsGroupId, MeasureId, TradeMarkId,ItemInfoMoneyId,BusinessId,FuelId: Integer): integer;

begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inWeight', ftFloat, ptInput, Weight);
  FParams.AddParam('inGoodsGroupId', ftInteger, ptInput, GoodsGroupId);
  FParams.AddParam('inMeasureId', ftInteger, ptInput, MeasureId);
  FParams.AddParam('inTradeMarkId', ftInteger, ptInput, TradeMarkId);
  FParams.AddParam('inItemInfoMoneyId', ftInteger, ptInput, ItemInfoMoneyId);
  FParams.AddParam('inBusinessId', ftInteger, ptInput, BusinessId);
  FParams.AddParam('inFuelId', ftInteger, ptInput, FuelId);
  result := InsertUpdate(FParams);
end;

procedure TGoodsTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Goods\';
  inherited;
end;

procedure TGoodsTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TGoods;
begin
  ObjectTest := TGoods.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка объекта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о юр лице
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Товар 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;
initialization
  //TestFramework.RegisterTest('Объекты', TGoodsTest.Suite);
end.
