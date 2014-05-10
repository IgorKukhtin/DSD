unit PersonalSendCashTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TPersonalSendCashTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPersonalSendCash = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePersonalSendCash(const Id: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TPersonalSendCash }

constructor TPersonalSendCash.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_PersonalSendCash';
  spSelect := 'gpSelect_Movement_PersonalSendCash';
  spGet := 'gpGet_Movement_PersonalSendCash';
end;

function TPersonalSendCash.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate, StartRunPlan, EndRunPlan, StartRun, EndRun: TDateTime;
    HoursAdd: Double;
    Comment:String;
    CarId, CarTrailerId, PersonalDriverId, PersonalDriverMoreId, UnitForwardingId: Integer;
begin
  Id:=0;

  result := InsertUpdatePersonalSendCash(Id);
end;

function TPersonalSendCash.InsertUpdatePersonalSendCash(const Id: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
{  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inStartRunPlan', ftDateTime, ptInput, StartRunPlan);
  FParams.AddParam('inEndRunPlan', ftDateTime, ptInput, EndRunPlan);
  FParams.AddParam('inStartRun', ftDateTime, ptInput, StartRun);
  FParams.AddParam('inEndRun', ftDateTime, ptInput, EndRun);

  FParams.AddParam('inHoursAdd', ftFloat, ptInput, HoursAdd);
  FParams.AddParam('inComment', ftString, ptInput, Comment);

  FParams.AddParam('inCarId', ftInteger, ptInput, CarId);
  FParams.AddParam('inCarTrailerId', ftInteger, ptInput, CarTrailerId);
  FParams.AddParam('inPersonalDriverId', ftInteger, ptInput, PersonalDriverId);
  FParams.AddParam('inPersonalDriverMoreId', ftInteger, ptInput, PersonalDriverMoreId);
  FParams.AddParam('inUnitForwardingId', ftInteger, ptInput, UnitForwardingId);

  result := InsertUpdate(FParams);
}
end;

{ TPersonalSendCashTest }

procedure TPersonalSendCashTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\PersonalSendCash\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\PersonalSendCash\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\PersonalSendCash\';
  inherited;
end;

procedure TPersonalSendCashTest.Test;
var MovementPersonalSendCash: TPersonalSendCash;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementPersonalSendCash := TPersonalSendCash.Create;
  Id := MovementPersonalSendCash.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TPersonalSendCashTest.Suite);

end.
