unit ReturnInMovementItemTest;

interface

uses dbMovementItemTest, dbTest, ObjectTest;

type

  TReturnInMovementItemTest = class(TdbTest)
  protected
    procedure SetUp; override;
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; virtual;
    procedure Test; virtual;
  end;

  TReturnInMovementItem = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateReturnInMovementItem
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner,
       Price, CountForPrice, HeadCount: double;
       PartionGoods:String; GoodsKindId, AssetId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, PersonalTest, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants, dbObjectMeatTest, ReturnInTest, GoodsTest;

{ TReturnInMovementItemTest }

procedure TReturnInMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'MovementItem\ReturnIn\';
  inherited;
  ScriptDirectory := ProcedurePath + 'Movement\ReturnIn\';
  inherited;
end;

procedure TReturnInMovementItemTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

function TReturnInMovementItem.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountPartner, Price, CountForPrice,
    HeadCount: double;
    PartionGoods:String;
    GoodsKindId, AssetId: Integer;
begin
  Id:=0;
  MovementId := TReturnIn.Create.GetDefault;
  GoodsId := TGoods.Create.GetDefault;
  Amount:=10;
  AmountPartner:=11;
  Price:=2.34;
  CountForPrice:=1;
  HeadCount:=5;
  PartionGoods:='';
  GoodsKindId:=0;
  AssetId:=0;
  //
  result := InsertUpdateReturnInMovementItem(Id, MovementId, GoodsId,
                              Amount, AmountPartner,
                              Price, CountForPrice, HeadCount,
                              PartionGoods, GoodsKindId, AssetId);
end;

procedure TReturnInMovementItemTest.Test;
var ReturnInMovementItem: TReturnInMovementItem;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  ReturnInMovementItem := TReturnInMovementItem.Create;
  Id := ReturnInMovementItem.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    ReturnInMovementItem.Delete(Id);
  end;


end;

{ TReturnInMovementItem }

constructor TReturnInMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_ReturnIn';
end;

function TReturnInMovementItem.InsertUpdateReturnInMovementItem(
  Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, Price,
       CountForPrice, HeadCount: double;
       PartionGoods:String; GoodsKindId, AssetId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inAmountPartner', ftFloat, ptInput, AmountPartner);
//  FParams.AddParam('inAmountChangePercent', ftFloat, ptInput, AmountChangePercent);
//  FParams.AddParam('inChangePercentAmount', ftFloat, ptInput, ChangePercentAmount);
  FParams.AddParam('inPrice', ftFloat, ptInput, Price);
  FParams.AddParam('ioCountForPrice', ftFloat, ptInputOutput, CountForPrice);
//  FParams.AddParam('outAmountSumm', ftFloat, ptOutput, AmountSumm);
  FParams.AddParam('inHeadCount', ftFloat, ptInput, HeadCount);
  FParams.AddParam('inPartionGoods', ftString, ptInput, PartionGoods);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  FParams.AddParam('inAssetId', ftInteger, ptInput, AssetId);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Строки Документов', TReturnInMovementItemTest.Suite);

end.

