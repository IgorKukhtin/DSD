unit LossMovementItemTest;

interface

uses dbTest, ObjectTest;

type

  TLossMovementItemTest = class(TdbTest)
  protected
    //procedure SetUp; override;
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TLossMovementItem = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemLoss
      (Id, MovementId, GoodsId: Integer; Amount: double): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants, LossTest, IncomeMovementItemTest;

{ TLossMovementItemTest }

procedure TLossMovementItemTest.Test;
var
  MovementItemLoss: TLossMovementItem;
  Id: Integer;
begin
  exit;
  MovementItemLoss := TLossMovementItem.Create;
  Id := MovementItemLoss.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    MovementItemLoss.Delete(Id);
  end;
end;

procedure TLossMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Loss\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItem\Loss\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItemContainer\Loss\';
  inherited;
end;

{ TLossMovementItem }

constructor TLossMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_Loss';
  spSelect := 'gpSelect_MovementItem_Loss';
//  spGet := 'gpGet_MovementItem_Loss';
end;

procedure TLossMovementItem.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TLoss.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
  FParams.AddParam('inIsErased', ftBoolean, ptInput, False);
end;

function TLossMovementItem.InsertDefault: integer;
var Id, MovementId, GoodsId, PartionGoodsId: Integer;
    Amount, Price: double;
begin
  Id:=0;
  MovementId := TLoss.Create.GetDefault;
  With TIncomeMovementItem.Create.GetDataSet DO
  Begin
    GoodsId := FieldByName('GoodsId').asInteger;
    Amount := FieldBYName('Amount').asFloat;
  End;
  result := InsertUpdateMovementItemLoss(Id, MovementId, GoodsId, Amount);
end;

function TLossMovementItem.InsertUpdateMovementItemLoss
  (Id, MovementId, GoodsId: Integer; Amount: double): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('—троки ƒокументов', TLossMovementItemTest.Suite);

end.
