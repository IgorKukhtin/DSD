unit SendDebtTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TSendDebtTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TSendDebt = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateSendDebt(const Id: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TSendDebt }

constructor TSendDebt.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_SendDebt';
  spSelect := 'gpSelect_Movement_SendDebt';
  spGet := 'gpGet_Movement_SendDebt';
end;

function TSendDebt.InsertDefault: integer;
var Id: Integer;
begin
  Id:=0;
  result := InsertUpdateSendDebt(Id);
end;

function TSendDebt.InsertUpdateSendDebt(const Id: integer): integer;
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

{ TSendDebtTest }

procedure TSendDebtTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\SendDebt\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\SendDebt\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\SendDebt\';
  inherited;
end;

procedure TSendDebtTest.Test;
var MovementSendDebt: TSendDebt;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementSendDebt := TSendDebt.Create;
  Id := MovementSendDebt.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

//  TestFramework.RegisterTest('Документы', TSendDebtTest.Suite);

end.
