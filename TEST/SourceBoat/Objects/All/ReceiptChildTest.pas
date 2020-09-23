unit ReceiptChildTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TReceiptChildTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

   TReceiptChild = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
   function InsertUpdateReceiptChild(const Id: integer; Value: Double; Weight, TaxExit: boolean;
                                     StartDate, EndDate: TDateTime; Comment: string;
                                     ReceiptId, GoodsId, GoodsKindId: integer): integer;
    constructor Create; override;
  end;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, DB, CarModelTest,
     InfoMoneyGroupTest, InfoMoneyDestinationTest, AssetGroupTest, GoodsTest,
     GoodsKindTest;

 {TReceiptChildTest}
 constructor TReceiptChild.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ReceiptChild';
  spSelect := 'gpSelect_Object_ReceiptChild';
  spGet := 'gpGet_Object_ReceiptChild';
end;

function TReceiptChild.InsertDefault: integer;
var
  GoodsId, GoodsKindId: Integer;
begin
  GoodsId:= TGoods.Create.GetDefault;
  GoodsKindId:= TGoodsKind.Create.GetDefault;

  result := InsertUpdateReceiptChild(0, 123,true, true, date, date, 'Составляющие рецептур - Значение', 2, GoodsId, GoodsKindId);
end;

function TReceiptChild.InsertUpdateReceiptChild;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('Value', ftFloat, ptInput, Value);
  FParams.AddParam('Weight', ftBoolean, ptInput, Weight);
  FParams.AddParam('TaxExit', ftBoolean, ptInput, TaxExit);
  FParams.AddParam('StartDate', ftDateTime, ptInput, StartDate);
  FParams.AddParam('EndDate', ftDateTime, ptInput, EndDate);
  FParams.AddParam('Comment', ftString, ptInput, Comment);
  FParams.AddParam('inReceiptId', ftInteger, ptInput, ReceiptId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  result := InsertUpdate(FParams);
end;

procedure TReceiptChildTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ReceiptChild\';
  inherited;
end;


procedure TReceiptChildTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReceiptChild;
begin
  ObjectTest := TReceiptChild.Create;
  // Получим список
   RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Составляющие рецептур
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Comment').AsString = 'Составляющие рецептур - Значение'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TReceiptChildTest.Suite);
end.
