unit ServiceTest;

interface

uses dbTest, dbMovementTest;

type
  TServiceTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TService = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateService(const Id: integer; InvNumber: String;
        OperDate: TDateTime; Amount: Double;
        JuridicalId, MainJuridicalId, BusinessId, PaidKindId, InfoMoneyId, UnitId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TService }

constructor TService.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Service';
  spSelect := 'gpSelect_Movement_Service';
  spGet := 'gpGet_Movement_Service';
end;

function TService.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    Amount: Double;
    JuridicalId, MainJuridicalId, BusinessId, PaidKindId, InfoMoneyId, UnitId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  JuridicalId := TJuridical.Create.GetDefault;
  MainJuridicalId := TJuridical.Create.GetDefault;
  BusinessId := 0;
  InfoMoneyId := 0;
  UnitId := 0;
  Amount := 265.68;
  PaidKindId:=0;

  result := InsertUpdateService(Id, InvNumber, OperDate, Amount,
              JuridicalId, MainJuridicalId, BusinessId, PaidKindId, InfoMoneyId, UnitId);
end;

function TService.InsertUpdateService(const Id: integer; InvNumber: String;
        OperDate: TDateTime; Amount: Double;
        JuridicalId, MainJuridicalId, BusinessId, PaidKindId, InfoMoneyId, UnitId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inMainJuridicalId', ftInteger, ptInput, MainJuridicalId);
  FParams.AddParam('inBusinessId', ftInteger, ptInput, BusinessId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);

  result := InsertUpdate(FParams);

end;

{ TServiceTest }

procedure TServiceTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\_Service\';
  inherited;
end;

procedure TServiceTest.Test;
var MovementService: TService;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementService := TService.Create;
  Id := MovementService.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TServiceTest.Suite);

end.
