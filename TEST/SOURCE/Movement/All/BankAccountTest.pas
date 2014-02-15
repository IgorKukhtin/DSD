unit BankAccountTest;

interface

uses dbTest, dbMovementTest;

type
  TBankAccountMovementTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TBankAccountMovement = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateBankAccount(const Id: integer; InvNumber: String;
        OperDate: TDateTime; Amount: Double;
        FromId, ToId, InfoMoneyId, ContractId, UnitId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework, dsdDB, DBClient;

{ TBankAccount }

constructor TBankAccountMovement.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_BankAccount';
  spSelect := 'gpSelect_Movement_BankAccount';
  spGet := 'gpGet_Movement_BankAccount';
end;

function TBankAccountMovement.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    Amount: Double;
    FromId, ToId, InfoMoneyId, ContractId, UnitId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  FromId := TJuridical.Create.GetDefault;
  ToId := TBankAccount.Create.GetDefault;
  ContractId := 0;
  InfoMoneyId := 0;
  UnitId := 0;
  Amount := 265.68;

  result := InsertUpdateBankAccount(Id, InvNumber, OperDate, Amount,
              FromId, ToId, InfoMoneyId, ContractId, UnitId);
end;

function TBankAccountMovement.InsertUpdateBankAccount(const Id: integer; InvNumber: String;
        OperDate: TDateTime; Amount: Double;
        FromId, ToId, InfoMoneyId, ContractId, UnitId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);

  result := InsertUpdate(FParams);

end;

{ TBankAccountTest }

procedure TBankAccountMovementTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\BankAccount\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\BankAccount\';
  inherited;
end;

procedure TBankAccountMovementTest.Test;
var MovementBankAccount: TBankAccountMovement;
    Id: Integer;
    StoredProc: TdsdStoredProc;
    AccountAmount, AccountAmountTwo: double;
begin
  inherited;
  AccountAmount := 0;
  AccountAmountTwo := 0;
  // Создаем документ
  MovementBankAccount := TBankAccountMovement.Create;
  // создание документа
  Id := MovementBankAccount.InsertDefault;
  // Проверяем остаток по счету кассы
  StoredProc := TdsdStoredProc.Create(nil);
  StoredProc.Params.AddParam('inStartDate', ftDateTime, ptInput, Date);
  StoredProc.Params.AddParam('inEndDate', ftDateTime, ptInput, TDateTime(Date));
  StoredProc.StoredProcName := 'gpReport_Balance';
  StoredProc.DataSet := TClientDataSet.Create(nil);
  StoredProc.OutputType := otDataSet;
  StoredProc.Execute;
  with StoredProc.DataSet do begin
     if Locate('AccountCode', '40101', []) then
        AccountAmount := FieldByName('AmountDebetEnd').AsFloat + FieldByName('AmountKreditEnd').AsFloat
  end;
  try
    // проведение
    MovementBankAccount.DocumentComplete(Id);
    StoredProc.Execute;
    with StoredProc.DataSet do begin
      if Locate('AccountCode', '40101', []) then
         AccountAmountTwo := FieldByName('AmountDebetEnd').AsFloat - FieldByName('AmountKreditEnd').AsFloat;
    end;
    Check(abs(AccountAmount - (AccountAmountTwo + 265.68)) < 0.01, 'Провелось не правильно. Было ' + FloatToStr(AccountAmount) + ' стало ' + FloatToStr(AccountAmountTwo));
  finally
    // распроведение
    MovementBankAccount.DocumentUnComplete(Id);
    StoredProc.Free;
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TBankAccountMovementTest.Suite);

end.
