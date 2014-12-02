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
                                      MinimumLot, ReferPrice: double): integer;
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

  result := InsertUpdateGoods(0, '-1', '����� 1', 0, MeasureId, NDSKindId, 0, 0, 0);
  inherited;
end;

function TGoods.InsertUpdateGoods(Id: Integer; Code, Name: String;
                                      GoodsGroupId, MeasureId, NDSKindId,
                                      ReferCode: Integer;
                                      MinimumLot, ReferPrice: double): integer;

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
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �� ����
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '����� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('�������', TGoodsTest.Suite);


end.
