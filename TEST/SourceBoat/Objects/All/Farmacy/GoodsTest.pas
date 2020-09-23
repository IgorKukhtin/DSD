unit GoodsTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TGoodsTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

 TGoods = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoods(Id: Integer; Code, Name: String;
                                      GoodsGroupId, MeasureId, NDSKindId, ReferCode: Integer;
                                      MinimumLot, ReferPrice, Price: double;
                                      isClose, isTop: boolean; PercentMarkup: double): integer;
    constructor Create; override;
  end;


implementation

uses UtilConst, TestFramework, DB, MeasureTest, NDSKindTest;

constructor TGoods.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Goods';
  spSelect := 'gpSelect_Object_Goods_Retail';
  spGet := 'gpGet_Object_Goods';
end;

function TGoods.InsertDefault: integer;
var MeasureId: Integer;
    NDSKindId: Integer;
begin
  MeasureId := TMeasure.Create.GetDefault;
  NDSKindId := TNDSKind.Create.GetDefault;

  result := InsertUpdateGoods(0, '-1', 'Товар 1', 0, MeasureId, NDSKindId, 0, 0, 0, 0, true, true, 10);
  inherited;
end;

function TGoods.InsertUpdateGoods(Id: Integer; Code, Name: String;
                                      GoodsGroupId, MeasureId, NDSKindId,
                                      ReferCode: Integer;
                                      MinimumLot, ReferPrice, Price: double;
                                      isClose, isTop: boolean; PercentMarkup: double): integer;

begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftString, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inGoodsGroupId', ftInteger, ptInput, GoodsGroupId);
  FParams.AddParam('inMeasureId', ftInteger, ptInput, MeasureId);
  FParams.AddParam('inNDSKindId', ftInteger, ptInput, NDSKindId);

  FParams.AddParam('inMinimumLot', ftFloat, ptInput, MinimumLot);
  FParams.AddParam('inReferCode', ftInteger, ptInput, ReferCode);
  FParams.AddParam('inReferPrice', ftFloat, ptInput, ReferPrice);

  FParams.AddParam('inPrice', ftFloat, ptInput, Price);
  FParams.AddParam('inIsClose', ftBoolean, ptInput, IsClose);
  FParams.AddParam('inTOP', ftBoolean, ptInput, isTOP);
  FParams.AddParam('inPercentMarkup', ftFloat, ptInput, PercentMarkup);

  result := InsertUpdate(FParams);
end;

{ TGoodsTest }

procedure TGoodsTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\Goods\';
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
  TestFramework.RegisterTest('Объекты', TGoodsTest.Suite);


end.
