unit PersonalServiceTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

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
        OperDate: TDateTime; PersonalId: integer; Amount: Double; Comment: String;
        ContractId, InfoMoneyId, UnitId, PositionId, PaidKindId: integer;  ServiceDate: TDateTime): integer;
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
    InvNumber, Comment: String;
    OperDate, ServiceDate: TDateTime;
    Amount: Double;
    PersonalId, ContractId, InfoMoneyId, UnitId, PositionId, PaidKindId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  Comment:='Comment';
  OperDate:= Date;
  ServiceDate:= Date;

  PaidKindId := 0;
  InfoMoneyId := 0;
  UnitId := 0;
  PositionId := 0;
  PersonalId := 0;
  ContractId := 0;

  Amount := 265.68;

  result := InsertUpdatePersonalService(Id, InvNumber, OperDate, PersonalId, Amount, Comment,
              ContractId, InfoMoneyId, UnitId, PositionId, PaidKindId, ServiceDate);
end;

function TPersonalService.InsertUpdatePersonalService(const Id: integer; InvNumber: String;
        OperDate: TDateTime;  PersonalId: integer;  Amount: Double; Comment: String;
        ContractId, InfoMoneyId, UnitId, PositionId, PaidKindId: integer; ServiceDate: TDateTime): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inPersonalId', ftInteger, ptInput, PersonalId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  //FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inPositionId', ftInteger, ptInput, PositionId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  FParams.AddParam('inServiceDate', ftDateTime, ptInput, ServiceDate);

  result := InsertUpdate(FParams);

end;

{ TPersonalServiceTest }

procedure TPersonalServiceTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\PersonalService\';
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
