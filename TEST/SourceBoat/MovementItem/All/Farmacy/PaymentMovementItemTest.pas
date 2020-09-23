unit PaymentMovementItemTest;

interface

uses dbTest, ObjectTest;

type

  TPaymentMovementItemTest = class(TdbTest)
  protected
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPaymentMovementItem = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemPayment
      (Id, MovementId, IncomeId: Integer; SummaPay: double): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants, PaymentTest, IncomeTest;

{ TPaymentMovementItemTest }

procedure TPaymentMovementItemTest.Test;
var
  MovementItemPayment: TPaymentMovementItem;
  Id: Integer;
begin
  exit;
  MovementItemPayment := TPaymentMovementItem.Create;
  Id := MovementItemPayment.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    MovementItemPayment.Delete(Id);
  end;
end;

procedure TPaymentMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Payment\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItem\Payment\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItemContainer\Payment\';
  inherited;
end;

{ TPaymentMovementItem }

constructor TPaymentMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_Payment';
  spSelect := 'gpSelect_MovementItem_Payment';
//  spGet := 'gpGet_MovementItem_Payment';
end;

procedure TPaymentMovementItem.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TPayment.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
  FParams.AddParam('inIsErased', ftBoolean, ptInput, False);
  FParams.AddParam('inDateStart', ftDateTime, ptInput, Date);
  FParams.AddParam('inDateEnd', ftDateTime, ptInput, Date);
end;

function TPaymentMovementItem.InsertDefault: integer;
var Id, MovementId, IncomeId: Integer;
    SummaPay: double;
begin
  Id:=0;
  MovementId := TPayment.Create.GetDefault;
  IncomeId := TIncome.Create.GetDefault;
  result := InsertUpdateMovementItemPayment(Id, MovementId, IncomeId, 1.0);
end;

function TPaymentMovementItem.InsertUpdateMovementItemPayment
  (Id, MovementId, IncomeId: Integer; SummaPay: double): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inIncomeId', ftInteger, ptInput, IncomeId);
  FParams.AddParam('ioBankAccountId', ftInteger, ptInputOutput, 0);
  FParams.AddParam('ioAccountId', ftInteger, ptInputOutput, 0);
  FParams.AddParam('outAccountName', ftString, ptOutput, '');
  FParams.AddParam('outBankId', ftInteger, ptOutput, 0);
  FParams.AddParam('outBankName', ftString, ptOutput, '');
  FParams.AddParam('inSummaPay', ftFloat, ptInput, SummaPay);
  FParams.AddParam('inNeedPay', ftBoolean, ptInput, True);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('—троки ƒокументов', TPaymentMovementItemTest.Suite);

end.
