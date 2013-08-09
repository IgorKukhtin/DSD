unit CashOperationTest;

interface

uses dbTest, dbMovementTest;

type
  TCashOperationTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TCashOperation = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateCashOperation(const Id: integer; InvNumber: String;
        OperDate: TDateTime; Amount: Double;
        FromId, ToId, PaidKindId, InfoMoneyId, ContractId, UnitId, PositionId: integer;
        AccrualsDate: TDateTime): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TIncomeCashJuridical }

constructor TCashOperation.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Cash';
  spSelect := 'gpSelect_Movement_Cash';
  spGet := 'gpGet_Movement_Cash';
end;

function TCashOperation.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    Amount: Double;
    FromId, ToId, PaidKindId, InfoMoneyId, ContractId, UnitId, PositionId: Integer;
    AccrualsDate: TDateTime;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  // Выбираем кассу
  FromId := TCashTest.Create.GetDefault;
  // Выбираем Юр лицо
  ToId := TJuridical.Create.GetDefault;
  PaidKindId := 0;
  ContractId := 0;
  InfoMoneyId := 0;
  UnitId := 0;
  Amount := 265.68;
  //
  PositionId := 0;
  AccrualsDate := Date;

  result := InsertUpdateCashOperation(Id, InvNumber, OperDate, Amount,
              FromId, ToId, PaidKindId, InfoMoneyId, ContractId, UnitId, PositionId, AccrualsDate);
end;

function TCashOperation.InsertUpdateCashOperation(const Id: integer; InvNumber: String;
        OperDate: TDateTime; Amount: Double;
        FromId, ToId, PaidKindId, InfoMoneyId, ContractId, UnitId, PositionId: integer;
        AccrualsDate: TDateTime): integer;
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
  FParams.AddParam('inPositionId', ftInteger, ptInput, PositionId);
  FParams.AddParam('inAccrualsDate', ftDateTime, ptInput, AccrualsDate);

  result := InsertUpdate(FParams);

end;

{ TIncomeCashJuridicalTest }

procedure TCashOperationTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\_Cash\';
  inherited;
end;

procedure TCashOperationTest.Test;
var MovementCashOperation: TCashOperation;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementCashOperation := TCashOperation.Create;
  Id := MovementCashOperation.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TCashOperationTest.Suite);



end.
