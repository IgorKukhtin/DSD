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
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementInventory(Id: Integer; InvNumber: String;
             OperDate: TDateTime; FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, PartnerTest, UnitsTest, CurrencyTest, dbObjectTest, SysUtils,
     Db, TestFramework;

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
    FromId, ToId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  FromId := TPartner.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  //
  result := InsertUpdateMovementInventory(Id, InvNumber, OperDate, FromId, ToId);
end;

function TInventory.InsertUpdateMovementInventory(Id: Integer; InvNumber: String; OperDate: TDateTime;
                         FromId, ToId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);

  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);

  result := InsertUpdate(FParams);
end;


{ TInventoryTest }

procedure TInventoryTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\Inventory\';
  inherited;
end;

procedure TInventoryTest.Test;
var
  MovementInventory: TInventory;
  Id: Integer;
begin
  MovementInventory := TInventory.Create;
  Id := MovementInventory.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;


initialization

//  TestFramework.RegisterTest('Документы', TInventoryTest.Suite);

end.
