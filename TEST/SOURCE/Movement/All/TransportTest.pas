unit TransportTest;

interface

uses dbTest, dbMovementTest;

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
        OperDate, WorkTime: TDateTime; MorningOdometre, EveningOdometre, Distance,
        Cold, Norm: Double;
        CarId, MemberId, RouteId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

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
    OperDate, WorkTime: TDateTime;
    MorningOdometre, EveningOdometre, Distance,Cold, Norm: Double;
    CarId, MemberId, RouteId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  WorkTime:= Date;
  OperDate:= Date;
  MorningOdometre := 45654;
  EveningOdometre := 45859;
  Distance := 205;
  Cold := 5;
  Norm := 100;
  CarId := TCarTest.Create.GetDefault;
  MemberId := 0;
  RouteId := TRouteTest.Create.GetDefault;
  result := InsertUpdateTransport(Id, InvNumber, OperDate, WorkTime, MorningOdometre,
              EveningOdometre, Distance, Cold, Norm,
              CarId, MemberId, RouteId);
end;

function TTransport.InsertUpdateTransport(const Id: integer; InvNumber: String;
        OperDate, WorkTime: TDateTime; MorningOdometre, EveningOdometre, Distance,
        Cold, Norm: Double;
        CarId, MemberId, RouteId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inWorkTime', ftDateTime, ptInput, WorkTime);

  FParams.AddParam('inMorningOdometre', ftFloat, ptInput, MorningOdometre);
  FParams.AddParam('inEveningOdometre', ftFloat, ptInput, EveningOdometre);
  FParams.AddParam('inDistance', ftFloat, ptInput, Distance);
  FParams.AddParam('inCold', ftFloat, ptInput, Cold);
  FParams.AddParam('inNorm', ftFloat, ptInput, Norm);

  FParams.AddParam('inCarId', ftInteger, ptInput, CarId);
  FParams.AddParam('inMemberId', ftInteger, ptInput, MemberId);
  FParams.AddParam('inRouteId', ftInteger, ptInput, RouteId);

  result := InsertUpdate(FParams);

end;

{ TTransportTest }

procedure TTransportTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\_Transport\';
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
