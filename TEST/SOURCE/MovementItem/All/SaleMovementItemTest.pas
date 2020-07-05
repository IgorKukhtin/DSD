unit SaleMovementItemTest;

interface

uses dbMovementItemTest, dbTest, ObjectTest;

type

  TSaleMovementItemTest = class(TdbTest)
  protected
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; virtual;
    procedure Test; virtual;
  end;

  TSaleMovementItem = class(TMovementItemTest)
  public
    function InsertDefault: integer; override;
  public
    function InsertUpdateSaleMovementItem
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, AmountChangePercent, ChangePercentAmount,
       Price, CountForPrice, HeadCount: double;
       PartionGoods:String; GoodsKindId, AssetId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, PersonalTest, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants, dbObjectMeatTest, SaleTest, GoodsTest;

{ TSaleMovementItemTest }

procedure TSaleMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'MovementItem\Sale\';
  inherited;
  ScriptDirectory := ProcedurePath + 'Movement\Sale\';
  inherited;
end;

procedure TSaleMovementItemTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

procedure TSaleMovementItemTest.TearDown;
begin
  inherited;
end;

function TSaleMovementItem.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountPartner, Price, CountForPrice,
    HeadCount, AmountChangePercent, ChangePercentAmount: double;
    PartionGoods:String;
    GoodsKindId, AssetId: Integer;
begin
  Id:=0;
  MovementId := TSale.Create.GetDefault;
  GoodsId := TGoods.Create.GetDefault;
  Amount:=10;
  AmountPartner:=11;
  ChangePercentAmount := 10;
  Price:=2.34;
  CountForPrice:=1;
  HeadCount:=5;
  PartionGoods:='';
  GoodsKindId:=0;
  AssetId:=0;
  AmountChangePercent := 0;
  //
  result := InsertUpdateSaleMovementItem(Id, MovementId, GoodsId,
                              Amount, AmountPartner, AmountChangePercent, ChangePercentAmount,
                              Price, CountForPrice, HeadCount,
                              PartionGoods, GoodsKindId, AssetId);
end;

procedure TSaleMovementItemTest.Test;
var SaleMovementItem: TSaleMovementItem;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  SaleMovementItem := TSaleMovementItem.Create;
  Id := SaleMovementItem.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    SaleMovementItem.Delete(Id);
  end;
end;

{ TSaleMovementItem }

constructor TSaleMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_Sale';
end;

function TSaleMovementItem.InsertUpdateSaleMovementItem(
  Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, AmountChangePercent, ChangePercentAmount, Price,
       CountForPrice, HeadCount: double;
       PartionGoods:String; GoodsKindId, AssetId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inAmountPartner', ftFloat, ptInput, AmountPartner);
  FParams.AddParam('inAmountChangePercent', ftFloat, ptInput, AmountChangePercent);
  FParams.AddParam('inChangePercentAmount', ftFloat, ptInput, ChangePercentAmount);
  FParams.AddParam('inPrice', ftFloat, ptInput, Price);
  FParams.AddParam('i0CountForPrice', ftFloat, ptInputOutput, CountForPrice);
  FParams.AddParam('inHeadCount', ftFloat, ptInput, HeadCount);
  FParams.AddParam('inPartionGoods', ftString, ptInput, PartionGoods);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  FParams.AddParam('inAssetId', ftInteger, ptInput, AssetId);
  result := InsertUpdate(FParams);
end;

initialization

//  TestFramework.RegisterTest('Строки Документов', TSaleMovementItemTest.Suite);

end.
