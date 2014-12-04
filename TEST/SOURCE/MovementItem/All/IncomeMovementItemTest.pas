unit IncomeMovementItemTest;

interface

uses dbMovementItemTest, dbTest, ObjectTest;

type

  TIncomeMovementItemTest = class(TdbTest)
  protected
    procedure SetUp; override;
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TIncomeMovementItem = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemIncome
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, AmountPacker, Price, CountForPrice, LiveWeight, HeadCount: double;
       PartionGoods: String; GoodsKindId, AssetId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, PersonalTest, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants, dbObjectMeatTest, IncomeTest, GoodsTest;

{ TIncomeMovementItemTest }

procedure TIncomeMovementItemTest.Test;
var
  MovementItemIncome: TIncomeMovementItem;
  Id: Integer;
begin
  MovementItemIncome := TIncomeMovementItem.Create;
  Id := MovementItemIncome.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    MovementItemIncome.Delete(Id);
  end;
end;

procedure TIncomeMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'MovementItem\Income\';
  inherited;
  ScriptDirectory := ProcedurePath + 'Movement\Income\';
  inherited;
end;

procedure TIncomeMovementItemTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

{ TIncomeMovementItem }

constructor TIncomeMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_Income';
  spSelect := 'gpSelect_MovementItem_Income';
  spGet := 'gpGet_MovementItem_Income';
end;

procedure TIncomeMovementItem.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TIncome.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
end;

function TIncomeMovementItem.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountPartner, AmountPacker, Price, CountForPrice, LiveWeight, HeadCount: double;
    PartionGoods:String;
    GoodsKindId,AssetId: Integer;
begin
  Id:=0;
  MovementId:= TIncome.Create.GetDefault;
  GoodsId:=TGoods.Create.GetDefault;
  Amount:=10;
  AmountPartner:=11;
  AmountPacker:=12;
  Price:=2.34;
  CountForPrice:=1;
  LiveWeight:=505.67;
  HeadCount:=5;
  PartionGoods:='';
  GoodsKindId:=0;
  AssetId:=0;
  //
  result := InsertUpdateMovementItemIncome(Id, MovementId, GoodsId,
                                           Amount, AmountPartner, AmountPacker, Price, CountForPrice, LiveWeight, HeadCount,
                                           PartionGoods,
                                           GoodsKindId,AssetId);
end;

function TIncomeMovementItem.InsertUpdateMovementItemIncome
  (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, AmountPacker, Price, CountForPrice, LiveWeight, HeadCount: double;
       PartionGoods:String;GoodsKindId,AssetId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inAmountPartner', ftFloat, ptInput, AmountPartner);
  FParams.AddParam('inAmountPacker', ftFloat, ptInput, AmountPacker);
  FParams.AddParam('inPrice', ftFloat, ptInput, Price);
  FParams.AddParam('inCountForPrice', ftFloat, ptInput, CountForPrice);
  FParams.AddParam('inLiveWeight', ftFloat, ptInput, LiveWeight);
  FParams.AddParam('inHeadCount', ftFloat, ptInput, HeadCount);
  FParams.AddParam('inPartionGoods', ftString, ptInput, PartionGoods);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  FParams.AddParam('inAssetId', ftInteger, ptInput, AssetId);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Строки Документов', TIncomeMovementItemTest.Suite);

end.
