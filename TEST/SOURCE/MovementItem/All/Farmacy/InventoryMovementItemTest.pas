unit InventoryMovementItemTest;

interface

uses dbTest, ObjectTest;

type

  TInventoryMovementItemTest = class(TdbTest)
  protected
    //procedure SetUp; override;
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TInventoryMovementItem = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemInventory
      (Id, MovementId, GoodsId: Integer; Amount, Price: double): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants, InventoryTest, GoodsTest;

{ TInventoryMovementItemTest }

procedure TInventoryMovementItemTest.Test;
var
  MovementItemInventory: TInventoryMovementItem;
  Id: Integer;
begin
  exit;
  MovementItemInventory := TInventoryMovementItem.Create;
  Id := MovementItemInventory.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    MovementItemInventory.Delete(Id);
  end;
end;

procedure TInventoryMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Inventory\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItem\Inventory\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItemContainer\Inventory\';
  inherited;
end;

//procedure TInventoryMovementItemTest.SetUp;
//begin
//  inherited;
//  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', gc_AdminPassword, gc_User);
//end;

{ TInventoryMovementItem }

constructor TInventoryMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_Inventory';
  spSelect := 'gpSelect_MovementItem_Inventory';
//  spGet := 'gpGet_MovementItem_Inventory';
end;

procedure TInventoryMovementItem.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TInventory.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
  FParams.AddParam('inIsErased', ftBoolean, ptInput, False);
end;

function TInventoryMovementItem.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, Price: double;
begin
  Id:=0;
  MovementId:= TInventory.Create.GetDefault;
  GoodsId:=TGoods.Create.GetDefault;
  Amount:=0;
  Price := 0.01;
  //
  result := InsertUpdateMovementItemInventory(Id, MovementId, GoodsId, Amount, Price);
end;

function TInventoryMovementItem.InsertUpdateMovementItemInventory
  (Id, MovementId, GoodsId: Integer; Amount, Price: double): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inPrice', ftFloat, ptInput, Price);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Строки Документов', TInventoryMovementItemTest.Suite);

end.
