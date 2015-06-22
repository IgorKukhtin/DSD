unit PriceTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TPriceTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPrice = class(TObjectTest)
  function InsertDefault: integer; override;
  procedure SetDataSetParam; override;
  public
    function InsertUpdatePrice(const Id: Integer; const Price, MCS: Double;
      const GoodsId, UnitId: Integer): integer;
    constructor Create; override;
  end;
var
  Price_Value: Double;
  MCS_Value: Double;
  GoodsId: Integer;
  UnitID: Integer;

//const
//  Price_Value: Double = 0.01;
//  GoodsId: Integer = 388281;
//  UnitID: Integer = 183290;
implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB, GoodsTest,
     UnitsTest;
     { TPriceTest }
constructor TPrice.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Price';
  spSelect := 'gpSelect_Object_Price';
  spGet := 'gpGet_Object_Price';
end;

function TPrice.InsertDefault: integer;
begin
  result := InsertUpdatePrice(0, Price_Value, MCS_Value, GoodsId, UnitId);
  inherited;
end;

function TPrice.InsertUpdatePrice(const Id: Integer; const Price, MCS: Double;
      const GoodsId, UnitId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inPrice', ftFloat, ptInput, Price);
  FParams.AddParam('inMCSValue', ftFloat, ptInput, MCS);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  result := InsertUpdate(FParams);
end;

procedure TPrice.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inUnitId', ftInteger, ptInput, true);
  FParams.AddParam('inIsShowAll', ftboolean, ptInput, False);
  FParams.AddParam('inIsShowDel', ftboolean, ptInput, False);
end;

procedure TPriceTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Price\';
  inherited;
end;

procedure TPriceTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPrice;
begin
  ObjectTest := TPrice.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� ����� ����

  Price_Value := 0.01;
  MCS_Value := 1.0;
  GoodsId := TGoods.Create.GetDefault;
  UnitID  := TUnit.Create.GetDefault;

  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Price').AsFloat = Price_Value) AND
            (FieldByName('MCSValue').AsFloat = MCS_Value) AND
            (FieldByName('GoodsId').AsInteger = GoodsId) AND
            (FieldByName('UnitId').AsInteger = UnitId),
            '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('�������', TPriceTest.Suite);

end.
