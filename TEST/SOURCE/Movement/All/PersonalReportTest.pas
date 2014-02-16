unit PersonalReportTest;

interface

uses dbTest, dbMovementTest;

type
  TPersonalReportTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPersonalReport = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePersonalReport(const Id: integer; InvNumber: String;
        OperDate: TDateTime; Amount: Double;
        FromId, ToId, PaidKindId, InfoMoneyId, ContractId, UnitId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, PersonalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TPersonalReport }

constructor TPersonalReport.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_PersonalReport';
  spSelect := 'gpSelect_Movement_PersonalReport';
  spGet := 'gpGet_Movement_PersonalReport';
end;

function TPersonalReport.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    Amount: Double;
    FromId, ToId, PaidKindId, InfoMoneyId, ContractId, UnitId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  FromId := TPersonal.Create.GetDefault;
  ToId := TJuridical.Create.GetDefault;
  PaidKindId := 0;
  InfoMoneyId := 0;
  UnitId := 0;
  ContractId := 0;
  Amount := 265.68;

  result := InsertUpdatePersonalReport(Id, InvNumber, OperDate, Amount,
              FromId, ToId, PaidKindId, InfoMoneyId, ContractId, UnitId);
end;

function TPersonalReport.InsertUpdatePersonalReport(const Id: integer; InvNumber: String;
        OperDate: TDateTime; Amount: Double;
        FromId, ToId, PaidKindId, InfoMoneyId, ContractId, UnitId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);

  result := InsertUpdate(FParams);

end;

{ TPersonalReportTest }

procedure TPersonalReportTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\PersonalReport\';
  inherited;
end;

procedure TPersonalReportTest.Test;
var MovementPersonalReport: TPersonalReport;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementPersonalReport := TPersonalReport.Create;
  Id := MovementPersonalReport.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TPersonalReportTest.Suite);

end.
