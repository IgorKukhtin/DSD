unit PaymentTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type

  TPaymentTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPayment = class(TMovementTest)
  private
  protected
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementPayment(Id: Integer; InvNumber: String;
       OperDate: TDateTime; JuridicalId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, UnitsTest, PaidKindTest, JuridicalTest, dbObjectTest, SysUtils,
     Db, TestFramework, BankAccountTest;

{ TPayment }

constructor TPayment.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Payment';
  spSelect := 'gpSelect_Movement_Payment';
  spGet := 'gpGet_Movement_Payment';
end;

function TPayment.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    JuridicalId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  JuridicalId := TJuridical.Create.GetDefault;
  OperDate := Date;
  TBankAccount.Create.GetDefault;
  result := InsertUpdateMovementPayment(Id, InvNumber, OperDate, JuridicalId);
end;

function TPayment.InsertUpdateMovementPayment(Id: Integer; InvNumber: String;
   OperDate: TDateTime; JuridicalId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftdateTime, ptInput, OperDate);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  result := InsertUpdate(FParams);
end;

{ TPaymentTest }

procedure TPaymentTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Payment\';
  inherited;
end;

procedure TPaymentTest.Test;
var
  MovementPayment: TPayment;
  Id: Integer;
begin
  MovementPayment := TPayment.Create;
  // создание документа
  Id := MovementPayment.InsertDefault;
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;

end;

{ TPaymentItem }

initialization

  TestFramework.RegisterTest('Документы', TPaymentTest.Suite);

end.
