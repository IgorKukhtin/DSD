unit ProductionSeparateTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type

  TProductionSeparateTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TProductionSeparate = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementProductionSeparate(Id: Integer; InvNumber: String;
             OperDate: TDateTime; PartionGoods: String; FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, PartnerTest, UnitsTest, CurrencyTest, dbObjectTest, SysUtils,
     Db, TestFramework;

{ TProductionSeparate }

constructor TProductionSeparate.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ProductionSeparate';
  spSelect := 'gpSelect_Movement_ProductionSeparate';
  spGet := 'gpGet_Movement_ProductionSeparate';
end;

function TProductionSeparate.InsertDefault: integer;
begin
  result := InsertUpdateMovementProductionSeparate(0, 'Номер 1' ,Date, '12.05.13', 0, 0);
end;

function TProductionSeparate.InsertUpdateMovementProductionSeparate(Id: Integer;
             InvNumber: String; OperDate: TDateTime; PartionGoods: String;
             FromId, ToId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inPartionGoods', ftString, ptInput, PartionGoods);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  result := InsertUpdate(FParams);
end;


{ TProductionSeparateTest }

procedure TProductionSeparateTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\ProductionSeparate\';
  inherited;
end;

procedure TProductionSeparateTest.Test;
var
  MovementProductionSeparate: TProductionSeparate;
  Id: Integer;
begin
  MovementProductionSeparate := TProductionSeparate.Create;
  Id := MovementProductionSeparate.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;


initialization

  TestFramework.RegisterTest('Документы', TProductionSeparateTest.Suite);

end.
