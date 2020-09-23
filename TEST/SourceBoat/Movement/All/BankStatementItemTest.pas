unit BankStatementItemTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TBankStatementItemTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TBankStatementItem = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateBankStatementItem(const Id: integer; InvNumber: String;
        OperDate: TDateTime; OKPO: String; Amount: Double;
        InfoMoneyId, ContractId, UnitId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TBankStatementItem }

constructor TBankStatementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_BankStatementItem';
  spSelect := 'gpSelect_Movement_BankStatementItem';
  spGet := 'gpGet_Movement_BankStatementItem';
end;

function TBankStatementItem.InsertDefault: integer;
var Id: Integer;
    InvNumber, OKPO: String;
    OperDate: TDateTime;
    Amount: Double;
    InfoMoneyId, ContractId, UnitId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  OKPO:= '45645689';
  InfoMoneyId := 0;
  UnitId := 0;
  ContractId := 0;
  Amount := 265.68;

  result := InsertUpdateBankStatementItem(Id, InvNumber, OperDate, OKPO, Amount,
              InfoMoneyId, ContractId, UnitId);
end;

function TBankStatementItem.InsertUpdateBankStatementItem(const Id: integer; InvNumber: String;
        OperDate: TDateTime; OKPO: String; Amount: Double;
        InfoMoneyId, ContractId, UnitId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inOKPO', ftString, ptInput, OKPO);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);

  result := InsertUpdate(FParams);

end;

{ TBankStatementItemTest }

procedure TBankStatementItemTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\BankStatementItem\';
  inherited;
end;

procedure TBankStatementItemTest.Test;
var MovementBankStatementItem: TBankStatementItem;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementBankStatementItem := TBankStatementItem.Create;
  Id := MovementBankStatementItem.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

//  TestFramework.RegisterTest('Документы', TBankStatementItemTest.Suite);

end.
