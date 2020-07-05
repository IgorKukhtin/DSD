unit ProfitLossServiceTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TProfitLossServiceTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TProfitLossService = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateProfitLossService(const Id: integer; InvNumber: String;
        OperDate: TDateTime; AmountIn, AmountOut: Double;Comment:String;
        ContractId, InfoMoneyId, JuridicalId, PaidKindId, UnitId,ContractConditionKindId,BonusKindId: integer; IsLoad:Boolean): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, dbObjectMeatTest, JuridicalTest, dbObjectTest, SysUtils, Db,
     TestFramework, ContractTest, InfoMoneyTest;

{ TProfitLossService }

constructor TProfitLossService.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ProfitLossService';
  spSelect := 'gpSelect_Movement_ProfitLossService';
  spGet := 'gpGet_Movement_ProfitLossService';
end;

function TProfitLossService.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    AmountIn, AmountOut: Double;
    Comment:String;
    ContractId, ContractConditionKindId, InfoMoneyId, JuridicalId, PaidKindId, UnitId,BonusKindId: Integer;
    isLoad:Boolean;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  AmountIn := 123.45;
  AmountOut := 0;
  Comment:='';
  ContractId := TContract.Create.GetDefault;
  ContractConditionKindId:=0;
  InfoMoneyId := 0;
  with TInfoMoney.Create.GetDataSet do begin
     if Locate('Code', '21501', []) then
        InfoMoneyId := FieldByName('Id').AsInteger;
  end;
  JuridicalId := TJuridical.Create.GetDefault;
  UnitId := 0;
  PaidKindId:=0;
  BonusKindId:=0;
  isLoad:=false;

  result := InsertUpdateProfitLossService(Id, InvNumber, OperDate, AmountIn, AmountOut, Comment,
              ContractId,InfoMoneyId, JuridicalId, PaidKindId, UnitId,ContractConditionKindId,BonusKindId,isLoad);
end;

function TProfitLossService.InsertUpdateProfitLossService(const Id: integer; InvNumber: String;
        OperDate: TDateTime; AmountIn, AmountOut: Double;Comment:String;
        ContractId, InfoMoneyId, JuridicalId, PaidKindId, UnitId,ContractConditionKindId,BonusKindId: integer; IsLoad:Boolean): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inAmountIn', ftFloat, ptInput, AmountIn);
  FParams.AddParam('inAmountOut', ftFloat, ptInput, AmountOut);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inContractConditionKindId', ftInteger, ptInput, ContractConditionKindId);
  FParams.AddParam('inBonusKindId', ftInteger, ptInput, BonusKindId);
  FParams.AddParam('inIsLoad', ftBoolean, ptInput, IsLoad);


  result := InsertUpdate(FParams);

end;

{ TProfitLossServiceTest }

procedure TProfitLossServiceTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\ProfitLossService\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\ProfitLossService\';
  inherited;
end;

procedure TProfitLossServiceTest.Test;
var MovementProfitLossService: TProfitLossService;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementProfitLossService := TProfitLossService.Create;
  Id := MovementProfitLossService.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

//  TestFramework.RegisterTest('Документы', TProfitLossServiceTest.Suite);

end.
