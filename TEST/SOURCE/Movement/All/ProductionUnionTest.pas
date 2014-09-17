unit ProductionUnionTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type

  TProductionUnionTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TProductionUnion = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementProductionUnion(Id: Integer; InvNumber: String;
             OperDate: TDateTime; FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, PartnerTest, UnitsTest, CurrencyTest, dbObjectTest, SysUtils,
     Db, TestFramework;

{ TProductionUnion }

constructor TProductionUnion.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ProductionUnion';
  spSelect := 'gpSelect_Movement_ProductionUnion';
  spGet := 'gpGet_Movement_ProductionUnion';
end;

function TProductionUnion.InsertDefault: integer;
begin
  result := InsertUpdateMovementProductionUnion(0, 'Номер 1', Date, 0, 0);
end;

function TProductionUnion.InsertUpdateMovementProductionUnion(
  Id: Integer; InvNumber: String; OperDate: TDateTime; FromId,
  ToId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  result := InsertUpdate(FParams);
end;


{ TProductionUnionTest }

procedure TProductionUnionTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\ProductionUnion\';
  inherited;
end;

procedure TProductionUnionTest.Test;
var
  MovementProductionUnion: TProductionUnion;
  Id: Integer;
begin
  MovementProductionUnion := TProductionUnion.Create;
  Id := MovementProductionUnion.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;


initialization

  TestFramework.RegisterTest('Документы', TProductionUnionTest.Suite);

end.
