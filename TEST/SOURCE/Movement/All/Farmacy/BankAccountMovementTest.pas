unit BankAccountMovementTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

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
        FromId, ToId, CurrencyId, InfoMoneyId, BusinessId, ContractId, UnitId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework, dsdDB,
     DBClient, BankAccountTest, InfoMoneyTest, UnitsTest, CurrencyTest;

{ TBankAccount }

constructor TBankAccountMovement.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_BankAccount';
  spSelect := 'gpSelect_Movement_BankAccount';
  spGet := 'gpGet_Movement_BankAccount';
  spCompleteProcedure := 'gpComplete_Movement_BankAccount';
end;

function TBankAccountMovement.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    Amount: Double;
    FromId, ToId, InfoMoneyId, BusinessId, ContractId, UnitId, CurrencyId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  FromId := TJuridical.Create.GetDefault;
  ToId := TBankAccount.Create.GetDefault;
  ContractId := 0;
  InfoMoneyId := 0;
  CurrencyId := TCurrency.Create.GetDefault;
  with TInfoMoney.Create.GetDataSet do begin
     if Locate('Code', '10103', []) then
        InfoMoneyId := FieldByName('Id').AsInteger;
  end;
  BusinessId := 0;
  UnitId := TUnit.Create.GetDefault;
  Amount := 265.68;

  result := InsertUpdateBankAccount(Id, InvNumber, OperDate, Amount,
              FromId, ToId, CurrencyId, InfoMoneyId, BusinessId, ContractId, UnitId);
end;

function TBankAccountMovement.InsertUpdateBankAccount(const Id: integer; InvNumber: String;
        OperDate: TDateTime; Amount: Double;
        FromId, ToId, CurrencyId, InfoMoneyId, BusinessId, ContractId, UnitId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inAmountIn', ftFloat, ptInput, Amount);
  FParams.AddParam('inAmountOut', ftFloat, ptInput, 0);
  FParams.AddParam('inAmountSumm', ftFloat, ptInput, 0);
  FParams.AddParam('inBankAccountId', ftInteger, ptInput, FromId);
  FParams.AddParam('inComment', ftString, ptInput, '');
  FParams.AddParam('inMoneyPlaceId', ftInteger, ptInput, ToId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inCurrencyId', ftInteger, ptInput, CurrencyId);
  FParams.AddParam('inCurrencyPartnerValue', ftFloat, ptInput, 0);
  FParams.AddParam('inParPartnerValue', ftFloat, ptInput, 0);

  result := InsertUpdate(FParams);

end;

{ TBankAccountTest }

procedure TBankAccountMovementTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\BankAccount\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItemContainer\BankAccount\';
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
  // ������� ��������
  MovementBankAccount := TBankAccountMovement.Create;
  // �������� ���������
  Id := MovementBankAccount.InsertDefault;
  // ��������� ������� �� ����� �����
  StoredProc := TdsdStoredProc.Create(nil);
  StoredProc.Params.AddParam('inStartDate', ftDateTime, ptInput, Date);
  StoredProc.Params.AddParam('inEndDate', ftDateTime, ptInput, TDateTime(Date));
  StoredProc.StoredProcName := 'gpReport_Balance';
  StoredProc.DataSet := TClientDataSet.Create(nil);
  StoredProc.OutputType := otDataSet;
  StoredProc.Execute;
  with StoredProc.DataSet do begin
     if Locate('AccountCode', '40301', []) then
        AccountAmount := FieldByName('AmountDebetEnd').AsFloat + FieldByName('AmountKreditEnd').AsFloat
  end;
  try
    // ����������
    //MovementBankAccount.DocumentComplete(Id);
    //StoredProc.Execute;
//    with StoredProc.DataSet do begin
  //    if Locate('AccountCode', '40301', []) then
    //     AccountAmountTwo := FieldByName('AmountDebetEnd').AsFloat - FieldByName('AmountKreditEnd').AsFloat;
   // end;
   // Check(abs(AccountAmount - (AccountAmountTwo + 265.68)) < 0.01, '��������� �� ���������. ���� ' + FloatToStr(AccountAmount) + ' ����� ' + FloatToStr(AccountAmountTwo));
  finally
    // �������������
    //MovementBankAccount.DocumentUnComplete(Id);
    StoredProc.Free;
  end;
end;

initialization

  TestFramework.RegisterTest('���������', TBankAccountMovementTest.Suite);

end.
