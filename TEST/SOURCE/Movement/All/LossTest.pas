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
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementLoss(Id: Integer; InvNumber: String;
               OperDate: TDateTime; FromId, ToId: Integer): Integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, PartnerTest, UnitsTest, CurrencyTest, dbObjectTest, SysUtils,
     Db, TestFramework;

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
    FromId, ToId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  FromId := TPartner.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  //
  result := InsertUpdateMovementLoss(Id, InvNumber, OperDate, FromId, ToId);
end;

function TLoss.InsertUpdateMovementLoss(Id: Integer; InvNumber: String;
               OperDate: TDateTime; FromId, ToId: Integer): Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);

  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);

  result := InsertUpdate(FParams);
end;


{ TLossTest }

procedure TLossTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\Loss\';
  inherited;
end;

procedure TLossTest.Test;
var
  MovementLoss: TLoss;
  Id: Integer;
begin
  MovementLoss := TLoss.Create;
  Id := MovementLoss.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;


initialization

//  TestFramework.RegisterTest('Документы', TLossTest.Suite);

end.
