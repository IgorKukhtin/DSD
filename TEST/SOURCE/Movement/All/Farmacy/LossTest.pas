unit LossTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type

  TLossTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TLoss = class(TMovementTest)
  private
  protected
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementLoss(Id: Integer; InvNumber: String;
             OperDate: TDateTime; UnitID, ArticleLossId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, UnitsTest, dbObjectTest, SysUtils,
     Db, TestFramework, GoodsTest, ArticleLossTest;

{ TLoss }

constructor TLoss.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Loss';
  spSelect := 'gpSelect_Movement_Loss';
  spGet := 'gpGet_Movement_Loss';
end;

function TLoss.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    UnitID, ArticleLossId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  UnitId := TUnit.Create.GetDefault;
  ArticleLossId := TArticleLoss.Create.GetDefault;
  result := InsertUpdateMovementLoss(Id, InvNumber, OperDate, UnitId, ArticleLossId);
end;

function TLoss.InsertUpdateMovementLoss(Id: Integer; InvNumber: String; OperDate: TDateTime;
                         UnitId, ArticleLossId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inArticleLossId', ftInteger, ptInput, ArticleLossId);

  result := InsertUpdate(FParams);
end;

{ TLossTest }

procedure TLossTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Loss\';
  inherited;
end;

procedure TLossTest.Test;
var
  MovementLoss: TLoss;
  Id: Integer;
begin
  MovementLoss := TLoss.Create;
  // создание документа
  Id := MovementLoss.InsertDefault;
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;

end;

{ TLossItem }

initialization

//  TestFramework.RegisterTest('Документы', TLossTest.Suite);

end.
