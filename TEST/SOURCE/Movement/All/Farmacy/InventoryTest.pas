unit InventoryTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type

  TInventoryTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TInventory = class(TMovementTest)
  private
  protected
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementInventory(Id: Integer; InvNumber: String;
             OperDate: TDateTime; UnitID: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, UnitsTest, dbObjectTest, SysUtils,
     Db, TestFramework, GoodsTest;

{ TInventory }

constructor TInventory.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Inventory';
  spSelect := 'gpSelect_Movement_Inventory';
  spGet := 'gpGet_Movement_Inventory';
end;

function TInventory.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    UnitID: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  UnitId := TUnit.Create.GetDefault;
  result := InsertUpdateMovementInventory(Id, InvNumber, OperDate, UnitId);
end;

function TInventory.InsertUpdateMovementInventory(Id: Integer; InvNumber: String; OperDate: TDateTime;
                         UnitId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inFullInvent', ftBoolean, ptInput, False);
  result := InsertUpdate(FParams);
end;

{ TInventoryTest }

procedure TInventoryTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Inventory\';
  inherited;
end;

procedure TInventoryTest.Test;
var
  MovementInventory: TInventory;
  Id: Integer;
begin
  MovementInventory := TInventory.Create;
  // создание документа
  Id := MovementInventory.InsertDefault;
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;

end;

{ TInventoryItem }

initialization

  TestFramework.RegisterTest('Документы', TInventoryTest.Suite);

end.
