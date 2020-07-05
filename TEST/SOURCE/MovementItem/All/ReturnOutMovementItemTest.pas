unit ReturnOutMovementItemTest;

interface

uses dbMovementItemTest, dbTest, ObjectTest;

type

  TReturnOutMovementItemTest = class(TdbTest)
  protected
    procedure SetUp; override;
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TReturnOutMovementItem = class(TMovementItemTest)
  protected
    function InsertDefault: integer; override;
  public
    function InsertUpdateReturnOutMovementItem
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner,
       Price, CountForPrice, HeadCount: double;
       PartionGoods:String; GoodsKindId, AssetId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, PersonalTest, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants, dbObjectMeatTest, ReturnOutTest, GoodsTest;

{ TReturnOutMovementItemTest }

procedure TReturnOutMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'MovementItem\ReturnOut\';
  inherited;
  ScriptDirectory := ProcedurePath + 'Movement\ReturnOut\';
  inherited;
end;

procedure TReturnOutMovementItemTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

function TReturnOutMovementItem.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountPartner, Price, CountForPrice,
    HeadCount: double;
    PartionGoods:String;
    GoodsKindId, AssetId: Integer;
begin
  Id:=0;
  MovementId:= TReturnOut.Create.GetDefault;
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
  result := InsertUpdateReturnOutMovementItem(Id, MovementId, GoodsId,
                              Amount, AmountPartner,
                              Price, CountForPrice, HeadCount,
                              PartionGoods, GoodsKindId, AssetId);
end;

procedure TReturnOutMovementItemTest.Test;
var ReturnOutMovementItem: TReturnOutMovementItem;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  ReturnOutMovementItem := TReturnOutMovementItem.Create;
  Id := ReturnOutMovementItem.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    ReturnOutMovementItem.Delete(Id);
  end;


end;

{ TReturnOutMovementItem }

constructor TReturnOutMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_ReturnOut';
end;

function TReturnOutMovementItem.InsertUpdateReturnOutMovementItem(
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

//  TestFramework.RegisterTest('Строки Документов', TReturnOutMovementItemTest.Suite);

end.

