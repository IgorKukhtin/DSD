unit ReceiptTest;

interface
uses dbTest, dbObjectTest, TestFramework, ObjectTest;
type
  TReceiptTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

   TReceipt = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
   function InsertUpdateReceipt(const Id: integer; Name, Code, Comment: string;
                                Value, ValueCost, TaxExit, PartionValue, PartionCount, WeightPackage: Double;
                                StartDate, EndDate: TDateTime;
                                Main: boolean;
                                GoodsId, GoodsKindId, GoodsKindCompleteId, ReceiptCostId, ReceiptKindId: integer): integer;
    constructor Create; override;
  end;

implementation

  uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, DB, CarModelTest,
     InfoMoneyGroupTest, InfoMoneyDestinationTest, AssetGroupTest, GoodsTest,
     GoodsKindTest, ReceiptCostTest;

 {TReceiptTest}
 constructor TReceipt.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Receipt';
  spSelect := 'gpSelect_Object_Receipt';
  spGet := 'gpGet_Object_Receipt';
end;

function TReceipt.InsertDefault: integer;
var
  GoodsId, GoodsKindId, ReceiptCostId: Integer;
begin
  ReceiptCostId := TReceiptCost.Create.GetDefault;
  GoodsId:= TGoods.Create.GetDefault;
  GoodsKindId:= TGoodsKind.Create.GetDefault;

  result := InsertUpdateReceipt(0, '��������� 1', '123', '���������', 1, 2, 80, 2, 1,1 , date, date, true, GoodsId, GoodsKindId, 1, ReceiptCostId, 1);
end;

function TReceipt.InsertUpdateReceipt;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('Name', ftString, ptInput, Name);
  FParams.AddParam('Code', ftString, ptInput, Code);
  FParams.AddParam('Comment', ftString, ptInput, Comment);
  FParams.AddParam('Value', ftFloat, ptInput, Value);
  FParams.AddParam('ValueCost', ftFloat, ptInput, ValueCost);
  FParams.AddParam('TaxExit', ftFloat, ptInput, TaxExit);
  FParams.AddParam('PartionValue', ftFloat, ptInput, PartionValue);
  FParams.AddParam('PartionCount', ftFloat, ptInput, PartionCount);
  FParams.AddParam('WeightPackage', ftFloat, ptInput, WeightPackage);
  FParams.AddParam('StartDate', ftDateTime, ptInput, StartDate);
  FParams.AddParam('EndDate', ftDateTime, ptInput, EndDate);
  FParams.AddParam('Main', ftBoolean, ptInput, Main);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  FParams.AddParam('inGoodsKindCompleteId', ftInteger, ptInput, GoodsKindCompleteId);
  FParams.AddParam('inReceiptCostId', ftInteger, ptInput, ReceiptCostId);
  FParams.AddParam('inReceiptKindId', ftInteger, ptInput, ReceiptKindId);
  result := InsertUpdate(FParams);
end;

 procedure TReceiptTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Receipt\';
  inherited;
end;

procedure TReceiptTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReceipt;
begin
  ObjectTest := TReceipt.Create;
  // ������� ������
 RecordCount := ObjectTest.GetDataSet.RecordCount;
  // �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ���������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '��������� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;
initialization
  //TestFramework.RegisterTest('�������', TReceiptTest.Suite);

end.
