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
        OperDate: TDateTime; AmountIn, AmountOut: Double;Comment:String;
        BusinessId, ContractId, InfoMoneyId, JuridicalId, JuridicalBasisId, PaidKindId, UnitId,ContractConditionKindId: integer): integer;
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
    AmountIn, AmountOut: Double;
    Comment:String;
    BusinessId, ContractId, ContractConditionKindId, InfoMoneyId, JuridicalId, JuridicalBasisId, PaidKindId, UnitId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  AmountIn := 123.45;
  AmountOut := 0;
  Comment:='';
  BusinessId := 0;
  ContractId:=TContractTest.Create.GetDefault;
  ContractConditionKindId:=0;
  InfoMoneyId := 0;
  with TInfoMoneyTest.Create.GetDataSet do begin
     if Locate('Code', '21501', []) then
        InfoMoneyId := FieldByName('Id').AsInteger;
  end;
  JuridicalId := TJuridical.Create.GetDefault;
  JuridicalBasisId := TJuridical.Create.GetDefault;
  UnitId := 0;
  PaidKindId:=0;

  result := InsertUpdateService(Id, InvNumber, OperDate, AmountIn, AmountOut, Comment,
              BusinessId, ContractId,InfoMoneyId, JuridicalId, JuridicalBasisId, PaidKindId, UnitId,ContractConditionKindId);
end;

function TService.InsertUpdateService(const Id: integer; InvNumber: String;
        OperDate: TDateTime; AmountIn, AmountOut: Double;Comment:String;
        BusinessId, ContractId, InfoMoneyId, JuridicalId, JuridicalBasisId, PaidKindId, UnitId,ContractConditionKindId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inAmountIn', ftFloat, ptInput, AmountIn);
  FParams.AddParam('inAmountOut', ftFloat, ptInput, AmountOut);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  FParams.AddParam('inBusinessId', ftInteger, ptInput, BusinessId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inJuridicalBasisId', ftInteger, ptInput, JuridicalBasisId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inContractConditionKindId', ftInteger, ptInput, ContractConditionKindId);

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
