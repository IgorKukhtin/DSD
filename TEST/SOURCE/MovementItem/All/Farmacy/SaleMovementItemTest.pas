unit SaleMovementItemTest;

interface

uses dbTest, ObjectTest;

type

  TSaleMovementItemTest = class(TdbTest)
  protected
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TSaleMovementItem = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemSale
      (Id, MovementId, GoodsId: Integer; Amount, Price: double): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants, SaleTest, IncomeMovementItemTest;

{ TSaleMovementItemTest }

procedure TSaleMovementItemTest.Test;
var
  MovementItemSale: TSaleMovementItem;
  Id: Integer;
begin
  exit;
  MovementItemSale := TSaleMovementItem.Create;
  Id := MovementItemSale.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    MovementItemSale.Delete(Id);
  end;
end;

procedure TSaleMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Sale\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItem\Sale\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItemContainer\Sale\';
  inherited;
end;

{ TSaleMovementItem }

constructor TSaleMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_Sale';
  spSelect := 'gpSelect_MovementItem_Sale';
//  spGet := 'gpGet_MovementItem_Sale';
end;

procedure TSaleMovementItem.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TSale.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
  FParams.AddParam('inIsErased', ftBoolean, ptInput, False);
end;

function TSaleMovementItem.InsertDefault: integer;
var Id, MovementId, GoodsId, PartionGoodsId: Integer;
    Amount, Price: double;
begin
  Id:=0;
  MovementId := TSale.Create.GetDefault;
  With TIncomeMovementItem.Create.GetDataSet DO
  Begin
    GoodsId := FieldByName('GoodsId').asInteger;
    Amount := FieldBYName('Amount').asFloat;
  End;
  result := InsertUpdateMovementItemSale(Id, MovementId, GoodsId, Amount, 1.0);
end;

function TSaleMovementItem.InsertUpdateMovementItemSale
  (Id, MovementId, GoodsId: Integer; Amount, Price: double): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inPrice', ftFloat, ptInput, Amount);
  result := InsertUpdate(FParams);
end;

initialization

//  TestFramework.RegisterTest('—троки ƒокументов', TSaleMovementItemTest.Suite);

end.
