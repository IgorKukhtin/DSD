unit TransportServiceTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TTransportServiceTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TTransportService = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateTransportService(const Id: integer; InvNumber: String;
        OperDate, StartRunPlan, EndRunPlan, StartRun, EndRun: TDateTime; HoursAdd : Double;
        Comment:String; CarId, CarTrailerId, PersonalDriverId, PersonalDriverMoreId, PersonalId, UnitForwardingId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, dbObjectMeatTest, JuridicalTest, dbObjectTest, SysUtils, Db,
     TestFramework, CarTest;

{ TTransportService }

constructor TTransportService.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_TransportService';
  spSelect := 'gpSelect_Movement_TransportService';
  spGet := 'gpGet_Movement_TransportService';
end;

function TTransportService.InsertDefault: integer;
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

  result := InsertUpdateTransportService(Id, InvNumber, OperDate, StartRunPlan, EndRunPlan, StartRun, EndRun,
              HoursAdd, Comment,
              CarId, CarTrailerId, PersonalDriverId, PersonalDriverMoreId, PersonalId, UnitForwardingId);
end;

function TTransportService.InsertUpdateTransportService(const Id: integer; InvNumber: String;
        OperDate, StartRunPlan, EndRunPlan, StartRun, EndRun: TDateTime; HoursAdd : Double;
        Comment:String; CarId, CarTrailerId, PersonalDriverId, PersonalDriverMoreId, PersonalId, UnitForwardingId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  {FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
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

  result := InsertUpdate(FParams);}

end;

{ TTransportServiceTest }

procedure TTransportServiceTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\TransportService\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\TransportService\';
  inherited;
end;

procedure TTransportServiceTest.Test;
var MovementTransportService: TTransportService;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementTransportService := TTransportService.Create;
  Id := MovementTransportService.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TTransportServiceTest.Suite);

end.
