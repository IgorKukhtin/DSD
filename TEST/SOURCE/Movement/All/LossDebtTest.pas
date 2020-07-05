unit LossDebtTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TLossDebtTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TLossDebt = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateLossDebt(const Id: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TLossDebt }

constructor TLossDebt.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_LossDebt';
  spSelect := 'gpSelect_Movement_LossDebt';
  spGet := 'gpGet_Movement_LossDebt';
end;

function TLossDebt.InsertDefault: integer;
var Id: Integer;
begin
  Id:=0;
  result := InsertUpdateLossDebt(Id);
end;

function TLossDebt.InsertUpdateLossDebt(const Id: integer): integer;
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

{ TLossDebtTest }

procedure TLossDebtTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\LossDebt\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\LossDebt\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\LossDebt\';
  inherited;
end;

procedure TLossDebtTest.Test;
var MovementLossDebt: TLossDebt;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementLossDebt := TLossDebt.Create;
  Id := MovementLossDebt.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

//  TestFramework.RegisterTest('Документы', TLossDebtTest.Suite);

end.
