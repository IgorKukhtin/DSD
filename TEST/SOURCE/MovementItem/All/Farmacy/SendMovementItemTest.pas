unit SendMovementItemTest;

interface

uses dbTest, ObjectTest;

type

  TSendMovementItemTest = class(TdbTest)
  protected
    //procedure SetUp; override;
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TSendMovementItem = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemSend
      (Id, MovementId, GoodsId: Integer; Amount: double): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants, SendTest, IncomeMovementItemTest;

{ TSendMovementItemTest }

procedure TSendMovementItemTest.Test;
var
  MovementItemSend: TSendMovementItem;
  Id: Integer;
begin
  exit;
  MovementItemSend := TSendMovementItem.Create;
  Id := MovementItemSend.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    MovementItemSend.Delete(Id);
  end;
end;

procedure TSendMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Send\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItem\Send\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItemContainer\Send\';
  inherited;
end;

{ TSendMovementItem }

constructor TSendMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_Send';
  spSelect := 'gpSelect_MovementItem_Send';
//  spGet := 'gpGet_MovementItem_Send';
end;

procedure TSendMovementItem.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TSend.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
  FParams.AddParam('inIsErased', ftBoolean, ptInput, False);
end;

function TSendMovementItem.InsertDefault: integer;
var Id, MovementId, GoodsId, PartionGoodsId: Integer;
    Amount, Price: double;
begin
  Id:=0;
  MovementId := TSend.Create.GetDefault;
  With TIncomeMovementItem.Create.GetDataSet DO
  Begin
    GoodsId := FieldByName('GoodsId').asInteger;
    Amount := FieldBYName('Amount').asFloat;
  End;
  result := InsertUpdateMovementItemSend(Id, MovementId, GoodsId, Amount);
end;

function TSendMovementItem.InsertUpdateMovementItemSend
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

//  TestFramework.RegisterTest('—троки ƒокументов', TSendMovementItemTest.Suite);

end.
