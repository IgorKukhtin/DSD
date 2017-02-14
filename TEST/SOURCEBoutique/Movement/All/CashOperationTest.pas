unit CashOperationTest;

interface

uses dbTest, dbMovementTest, DB, ObjectTest;

type
  TCashOperationTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TCashOperation = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateCashOperation(const Id: integer; InvNumber: String;
        OperDate: TDateTime; Amount: Double; Comment: string;
        CashId, ObjectId, ContractId, InfoMoneyId, UnitId: integer): integer;
    constructor Create; override;
    function GetRecord(Id: integer): TDataSet; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, TestFramework,
     DBClient, dsdDB, CashTest, dbObjectMeatTest, InfoMoneyTest;

{ TIncomeCashJuridical }

constructor TCashOperation.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Cash';
  spSelect := 'gpSelect_Movement_Cash';
  spGet := 'gpGet_Movement_Cash';
  spCompleteProcedure := 'gpComplete_Movement_Cash';
end;

function TCashOperation.GetRecord(Id: integer): TDataSet;
begin
  with FdsdStoredProc do begin
    DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := spGet;
    OutputType := otDataSet;
    Params.Clear;
    Params.AddParam('ioId', ftInteger, ptInputOutput, Id);
    Params.AddParam('inOperDate', ftDateTime, ptInput, Date);
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TCashOperation.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    Amount: Double;
    CashId, ObjectId, PaidKindId, InfoMoneyId, ContractId, UnitId, PositionId: Integer;
    AccrualsDate: TDateTime;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  // Выбираем кассу
  CashId := TCash.Create.GetDefault;
  // Выбираем Юр лицо
  ObjectId := TJuridical.Create.GetDefault;
  PaidKindId := 0;
  ContractId := 0;
  InfoMoneyId := 0;
  with TInfoMoney.Create.GetDataSet do begin
     if Locate('Code', '10103', []) then
        InfoMoneyId := FieldByName('Id').AsInteger;
  end;
  UnitId := 0;
  Amount := 265.68;
  //
  PositionId := 0;
  AccrualsDate := Date;

  result := InsertUpdateCashOperation(Id, InvNumber,
        OperDate, Amount, 'Это комментарий',
        CashId, ObjectId, ContractId, InfoMoneyId, UnitId);
;
end;

function TCashOperation.InsertUpdateCashOperation(const Id: integer; InvNumber: String;
        OperDate: TDateTime; Amount: Double; Comment: string;
        CashId, ObjectId, ContractId, InfoMoneyId, UnitId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inAmountIn', ftFloat, ptInput, Amount);
  FParams.AddParam('inAmountOut', ftFloat, ptInput, 0);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  FParams.AddParam('inCashId', ftInteger, ptInput, CashId);
  FParams.AddParam('inObjectId', ftInteger, ptInput, ObjectId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);

  result := InsertUpdate(FParams);

end;

procedure TCashOperation.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inCashId', ftInteger, ptInput, 0);
end;

{ TIncomeCashJuridicalTest }

procedure TCashOperationTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\Cash\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\Cash\';
  inherited;
end;

procedure TCashOperationTest.Test;
var MovementCashOperation: TCashOperation;
    Id, RecordCount: Integer;
    StoredProc: TdsdStoredProc;
    AccountAmount, AccountAmountTwo: double;
begin
  inherited;
  AccountAmount := 0;
  AccountAmountTwo := 0;
  // Создаем объект документ
  MovementCashOperation := TCashOperation.Create;

  RecordCount := MovementCashOperation.GetDataSet.RecordCount;

  // Проверяем остаток по счету кассы
  StoredProc := TdsdStoredProc.Create(nil);
  StoredProc.Params.AddParam('inStartDate', ftDateTime, ptInput, Date);
  StoredProc.Params.AddParam('inEndDate', ftDateTime, ptInput, TDateTime(Date));
  StoredProc.StoredProcName := 'gpReport_Balance';
  StoredProc.DataSet := TClientDataSet.Create(nil);
  StoredProc.OutputType := otDataSet;
  StoredProc.Execute;
  with StoredProc.DataSet do begin
     if Locate('AccountCode', '40201', []) then
        AccountAmount := FieldByName('AmountDebetEnd').AsFloat + FieldByName('AmountKreditEnd').AsFloat
  end;
  // создание документа и проведение
  Id := MovementCashOperation.InsertDefault;
  MovementCashOperation.GetRecord(Id);
  try
    StoredProc.Execute;
    with StoredProc.DataSet do begin
      if Locate('AccountCode', '40201', []) then
         AccountAmountTwo := FieldByName('AmountDebetEnd').AsFloat - FieldByName('AmountKreditEnd').AsFloat;
    end;
    Check(abs(AccountAmount - (AccountAmountTwo - 265.68)) < 0.01, 'Провелось не правильно. Было ' + FloatToStr(AccountAmount) + ' стало ' + FloatToStr(AccountAmountTwo));
  finally
    // распроведение
    MovementCashOperation.DocumentUnComplete(Id);
    StoredProc.Free;
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TCashOperationTest.Suite);

end.
