unit BankStatementTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TBankStatementTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TBankStatement = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateBankStatement(const Id: integer; InvNumber: String;
        OperDate: TDateTime; FileName: String;
        BankAccountId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TBankStatement }

constructor TBankStatement.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_BankStatement';
  spSelect := 'gpSelect_Movement_BankStatement';
  spGet := 'gpGet_Movement_BankStatement';
end;

function TBankStatement.InsertDefault: integer;
var Id: Integer;
    InvNumber, FileName: String;
    OperDate: TDateTime;
    BankAccountId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  FileName:='1';
  BankAccountId := 0;

  result := InsertUpdateBankStatement(Id, InvNumber, OperDate,
              FileName, BankAccountId);
end;

function TBankStatement.InsertUpdateBankStatement(const Id: integer; InvNumber: String;
        OperDate: TDateTime; FileName: String;
        BankAccountId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inFileName', ftString, ptInput, FileName);
  FParams.AddParam('inBankAccountId', ftInteger, ptInput, BankAccountId);


  result := InsertUpdate(FParams);

end;

{ TBankStatementTest }

procedure TBankStatementTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\BankStatement\';
  inherited;
end;

procedure TBankStatementTest.Test;
var MovementBankStatement: TBankStatement;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementBankStatement := TBankStatement.Create;
  Id := MovementBankStatement.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TBankStatementTest.Suite);

end.
