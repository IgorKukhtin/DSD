unit PersonalAccountTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TPersonalAccountTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPersonalAccount = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePersonalAccount(const Id: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TPersonalAccount }

constructor TPersonalAccount.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_PersonalAccount';
  spSelect := 'gpSelect_Movement_PersonalAccount';
  spGet := 'gpGet_Movement_PersonalAccount';
end;

function TPersonalAccount.InsertDefault: integer;
var Id: Integer;
begin
  Id:=0;
  result := InsertUpdatePersonalAccount(Id);
end;

function TPersonalAccount.InsertUpdatePersonalAccount(const Id: integer): integer;
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

{ TPersonalAccountTest }

procedure TPersonalAccountTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\PersonalAccount\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\PersonalAccount\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\PersonalAccount\';
  inherited;
end;

procedure TPersonalAccountTest.Test;
var MovementPersonalAccount: TPersonalAccount;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementPersonalAccount := TPersonalAccount.Create;
  Id := MovementPersonalAccount.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TPersonalAccountTest.Suite);

end.
