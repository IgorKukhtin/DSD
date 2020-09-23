unit LossDebtMovementItemTest;

interface

uses dbTest, ObjectTest;

type

  TLossDebtMovementItemTest = class(TdbTest)
  protected
    procedure SetUp; override;
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TLossDebtMovementItem = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemLossDebt
  (Id, MovementId, JuridicalId: integer; AmountDebet, AmountKredit,
       SummDebet, SummKredit: Double; IsCalculated: Boolean): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants, LossDebtTest, JuridicalTest;

{ TLossDebtMovementItemTest }

procedure TLossDebtMovementItemTest.Test;
var
  MovementItemLossDebt: TLossDebtMovementItem;
  Id: Integer;
begin
  exit;
  MovementItemLossDebt := TLossDebtMovementItem.Create;
  Id := MovementItemLossDebt.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    MovementItemLossDebt.Delete(Id);
  end;
end;

procedure TLossDebtMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\LossDebt\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItem\LossDebt\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItemContainer\LossDebt\';
  inherited;
end;

procedure TLossDebtMovementItemTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', gc_AdminPassword, gc_User);
end;

{ TLossDebtMovementItem }

constructor TLossDebtMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_LossDebt';
  spSelect := 'gpSelect_MovementItem_LossDebt';
  spGet := 'gpGet_MovementItem_LossDebt';
end;

procedure TLossDebtMovementItem.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TLossDebt.Create.GetDefault);
end;

function TLossDebtMovementItem.InsertDefault: integer;
var Id, MovementId, JuridicalId: Integer;
    AmountDebet, AmountKredit,
    SummDebet, SummKredit: Double;
    IsCalculated: Boolean;
begin

  Id:=0;
  MovementId := TLossDebt.Create.GetDefault;
  JuridicalId := TJuridical.Create.GetDefault;
  AmountDebet := 1000;
  AmountKredit := 0;
  SummDebet := 0;
  SummKredit := 0;
  IsCalculated := true;
  //
  result := InsertUpdateMovementItemLossDebt  (Id, MovementId, JuridicalId,
       AmountDebet, AmountKredit, SummDebet, SummKredit, IsCalculated);

end;

function TLossDebtMovementItem.InsertUpdateMovementItemLossDebt
  (Id, MovementId, JuridicalId: integer; AmountDebet, AmountKredit,
       SummDebet, SummKredit: Double; IsCalculated: Boolean): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('ioAmountDebet', ftFloat, ptInputOutput, AmountDebet);
  FParams.AddParam('inAmountKredit', ftFloat, ptInputOutput, AmountKredit);
  FParams.AddParam('inSummDebet', ftFloat, ptInputOutput, SummDebet);
  FParams.AddParam('inSummKredit', ftFloat, ptInputOutput, SummKredit);
  FParams.AddParam('inIsCalculated', ftBoolean, ptInputOutput, IsCalculated);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Строки Документов', TLossDebtMovementItemTest.Suite);

end.
