unit PersonalServiceTest;

interface

uses dbTest, dbMovementTest;

type
  TPersonalServiceTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPersonalService = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePersonalService(const Id: integer; InvNumber: String;
        OperDate, ServiceDate: TDateTime; Amount: Double;
        FromId, ToId, PaidKindId, InfoMoneyId, UnitId, PositionId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TPersonalService }

constructor TPersonalService.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_PersonalService';
  spSelect := 'gpSelect_Movement_PersonalService';
  spGet := 'gpGet_Movement_PersonalService';
end;

function TPersonalService.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate, ServiceDate: TDateTime;
    Amount: Double;
    FromId, ToId, PaidKindId, InfoMoneyId, UnitId, PositionId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  ServiceDate:= Date;
  FromId := TJuridical.Create.GetDefault;
  ToId := TJuridical.Create.GetDefault;
  PaidKindId := 0;
  InfoMoneyId := 0;
  UnitId := 0;
  PositionId := 0;
  Amount := 265.68;

  result := InsertUpdatePersonalService(Id, InvNumber, OperDate, ServiceDate, Amount,
              FromId, ToId, PaidKindId, InfoMoneyId, UnitId, PositionId);
end;

function TPersonalService.InsertUpdatePersonalService(const Id: integer; InvNumber: String;
        OperDate, ServiceDate: TDateTime; Amount: Double;
        FromId, ToId, PaidKindId, InfoMoneyId, UnitId, PositionId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inServiceDate', ftDateTime, ptInput, ServiceDate);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inPositionId', ftInteger, ptInput, PositionId);

  result := InsertUpdate(FParams);

end;

{ TPersonalServiceTest }

procedure TPersonalServiceTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\_PersonalService\';
  inherited;
end;

procedure TPersonalServiceTest.Test;
var MovementPersonalService: TPersonalService;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementPersonalService := TPersonalService.Create;
  Id := MovementPersonalService.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TPersonalServiceTest.Suite);

end.
