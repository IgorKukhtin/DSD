unit TaxCorrectiveMovementItemTest;

interface

uses dbMovementItemTest, dbTest, ObjectTest;

type

  TTaxCorrectiveMovementItemTest = class(TdbTest)
  protected
    procedure SetUp; override;
    // возвращаем данные для тестирования
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; virtual;
    procedure Test; virtual;
  end;

  TTaxCorrectiveMovementItem = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateTaxCorrectiveMovementItem
      (Id, MovementId, GoodsId: Integer; Amount, Price, CountForPrice: double; GoodsKindId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, PersonalTest, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants, dbObjectMeatTest, TaxCorrectiveTest, GoodsTest;

{ TTaxCorrectiveMovementItemTest }

procedure TTaxCorrectiveMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'MovementItem\TaxCorrective\';
  inherited;
  ScriptDirectory := ProcedurePath + 'Movement\TaxCorrective\';
  inherited;
end;

procedure TTaxCorrectiveMovementItemTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

function TTaxCorrectiveMovementItem.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountPartner, Price, CountForPrice,
    HeadCount: double;
    PartionGoods:String;
    GoodsKindId, AssetId: Integer;
begin
  Id:=0;
  MovementId:= TTaxCorrective.Create.GetDefault;
  GoodsId:=TGoods.Create.GetDefault;
  Amount:=10;
  AmountPartner:=11;
  Price:=2.34;
  CountForPrice:=1;
  HeadCount:=5;
  PartionGoods:='';
  GoodsKindId:=0;
  AssetId:=0;
  //
  result := InsertUpdateTaxCorrectiveMovementItem(Id, MovementId, GoodsId, Amount, Price, CountForPrice, GoodsKindId);
end;

procedure TTaxCorrectiveMovementItemTest.Test;
var TaxCorrectiveMovementItem: TTaxCorrectiveMovementItem;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  TaxCorrectiveMovementItem := TTaxCorrectiveMovementItem.Create;
  Id := TaxCorrectiveMovementItem.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    TaxCorrectiveMovementItem.Delete(Id);
  end;


end;

{ TTaxCorrectiveMovementItem }

constructor TTaxCorrectiveMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_TaxCorrective';
end;

function TTaxCorrectiveMovementItem.InsertUpdateTaxCorrectiveMovementItem
 (Id, MovementId, GoodsId: Integer; Amount, Price, CountForPrice: double; GoodsKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inPrice', ftFloat, ptInput, Price);
  FParams.AddParam('ioCountForPrice', ftFloat, ptInput, CountForPrice);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  result := InsertUpdate(FParams);
end;

initialization

//  TestFramework.RegisterTest('Строки Документов', TTaxCorrectiveMovementItemTest.Suite);
 
end.

