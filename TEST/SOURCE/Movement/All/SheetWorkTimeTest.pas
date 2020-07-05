unit SheetWorkTimeTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TSheetWorkTimeTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
//    procedure Test; override;
  end;

  TSheetWorkTime = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateSheetWorkTime(const Id: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TSheetWorkTime }

constructor TSheetWorkTime.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_SheetWorkTime';
  spSelect := 'gpSelect_Movement_SheetWorkTime';
  spGet := 'gpGet_Movement_SheetWorkTime';
end;

function TSheetWorkTime.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate, StartRunPlan, EndRunPlan, StartRun, EndRun: TDateTime;
    HoursAdd: Double;
    Comment:String;
    CarId, CarTrailerId, PersonalDriverId, PersonalDriverMoreId, UnitForwardingId: Integer;
begin
  Id:=0;

  result := InsertUpdateSheetWorkTime(Id);
end;

function TSheetWorkTime.InsertUpdateSheetWorkTime(const Id: integer): integer;
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

{ TSheetWorkTimeTest }

procedure TSheetWorkTimeTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\SheetWorkTime\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\SheetWorkTime\';
  inherited;
end;

(*procedure TSheetWorkTimeTest.Test;
var MovementSheetWorkTime: TSheetWorkTime;
    Id: Integer;
begin

  inherited;
  // Создаем сотрудника на подразделении
  // И потом у него на дату ставим часы
  // Проверяем что сформировался Movement и MovementItem
  MovementSheetWorkTime := TSheetWorkTime.Create;
  Id := MovementSheetWorkTime.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;
  *)
initialization

//  TestFramework.RegisterTest('Документы', TSheetWorkTimeTest.Suite);

end.
