unit TransportTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TTransportTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TTransport = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateTransport(const Id: integer; InvNumber: String;
        OperDate, StartRunPlan, EndRunPlan, StartRun, EndRun: TDateTime; HoursAdd : Double;
        Comment:String; CarId, CarTrailerId, PersonalDriverId, PersonalDriverMoreId, PersonalId, UnitForwardingId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, dbObjectMeatTest, JuridicalTest, dbObjectTest, SysUtils, Db,
     TestFramework, CarTest;

{ TTransport }

constructor TTransport.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Transport';
  spSelect := 'gpSelect_Movement_Transport';
  spGet := 'gpGet_Movement_Transport';
end;

function TTransport.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate, StartRunPlan, EndRunPlan, StartRun, EndRun: TDateTime;
    HoursAdd: Double;
    Comment:String;
    CarId, CarTrailerId, PersonalDriverId, PersonalDriverMoreId, PersonalId, UnitForwardingId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate    := Date;
  StartRunPlan:= Date;
  EndRunPlan  := Date;
  StartRun    := Date;
  EndRun      := Date;
  HoursAdd := -123;
  Comment:='';
  CarId := TCar.Create.GetDefault;
  CarTrailerId:=0;
  PersonalDriverId := 0;
  PersonalDriverMoreId := 0;
  PersonalId := 0;
  UnitForwardingId := 0;

  result := InsertUpdateTransport(Id, InvNumber, OperDate, StartRunPlan, EndRunPlan, StartRun, EndRun,
              HoursAdd, Comment,
              CarId, CarTrailerId, PersonalDriverId, PersonalDriverMoreId, PersonalId, UnitForwardingId);
end;

function TTransport.InsertUpdateTransport(const Id: integer; InvNumber: String;
        OperDate, StartRunPlan, EndRunPlan, StartRun, EndRun: TDateTime; HoursAdd : Double;
        Comment:String; CarId, CarTrailerId, PersonalDriverId, PersonalDriverMoreId, PersonalId, UnitForwardingId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inStartRunPlan', ftDateTime, ptInput, StartRunPlan);
  FParams.AddParam('inEndRunPlan', ftDateTime, ptInput, EndRunPlan);
  FParams.AddParam('inStartRun', ftDateTime, ptInput, StartRun);
  FParams.AddParam('inEndRun', ftDateTime, ptInput, EndRun);

  FParams.AddParam('inHoursAdd', ftFloat, ptInput, HoursAdd);
  FParams.AddParam('outHoursWork', ftFloat, ptOutput, 0);
  FParams.AddParam('inComment', ftString, ptInput, Comment);

  FParams.AddParam('inCarId', ftInteger, ptInput, CarId);
  FParams.AddParam('inCarTrailerId', ftInteger, ptInput, CarTrailerId);
  FParams.AddParam('inPersonalDriverId', ftInteger, ptInput, PersonalDriverId);
  FParams.AddParam('inPersonalDriverMoreId', ftInteger, ptInput, PersonalDriverMoreId);
  FParams.AddParam('inPersonalId', ftInteger, ptInput, PersonalId);
  FParams.AddParam('inUnitForwardingId', ftInteger, ptInput, UnitForwardingId);

  result := InsertUpdate(FParams);

end;

{ TTransportTest }

procedure TTransportTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\Transport\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\Transport\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\Transport\';
  inherited;
end;

procedure TTransportTest.Test;
var MovementTransport: TTransport;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementTransport := TTransport.Create;
  Id := MovementTransport.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TTransportTest.Suite);

end.
