unit BankAccountTest;

interface

uses dbTest, dbMovementTest;

type
  TBankAccountTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TBankAccount = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateBankAccount(const Id: integer; InvNumber: String;
        OperDate: TDateTime; ParentId: integer; Amount: Double;
        FromId, ToId, InfoMoneyId, ContractId, UnitId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TBankAccount }

constructor TBankAccount.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_BankAccount';
  spSelect := 'gpSelect_Movement_BankAccount';
  spGet := 'gpGet_Movement_BankAccount';
end;

function TBankAccount.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    ParentId: integer;
    Amount: Double;
    FromId, ToId, InfoMoneyId, ContractId, UnitId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  ParentId := 0;
  FromId := TJuridical.Create.GetDefault;
  ToId := TJuridical.Create.GetDefault;
  ContractId := 0;
  InfoMoneyId := 0;
  UnitId := 0;
  Amount := 265.68;

  result := InsertUpdateBankAccount(Id, InvNumber, OperDate, ParentId, Amount,
              FromId, ToId, InfoMoneyId, ContractId, UnitId);
end;

function TBankAccount.InsertUpdateBankAccount(const Id: integer; InvNumber: String;
        OperDate: TDateTime; ParentId: integer; Amount: Double;
        FromId, ToId, InfoMoneyId, ContractId, UnitId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);

  result := InsertUpdate(FParams);

end;

{ TBankAccountTest }

procedure TBankAccountTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\_BankAccount\';
  inherited;
end;

procedure TBankAccountTest.Test;
var MovementBankAccount: TBankAccount;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementBankAccount := TBankAccount.Create;
  Id := MovementBankAccount.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TBankAccountTest.Suite);

end.
