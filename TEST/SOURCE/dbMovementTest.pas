unit dbMovementTest;

interface
uses TestFramework, dbObjectTest;

type

  TdbMovementTest = class (TTestCase)
  private
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure MovementIncomeTest;
  end;

  TMovementIncome = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementIncome(Id: Integer; InvNumber: String; OperDate: TDateTime;
             FromId, ToId, PaidKindId, ContractId, CarId, PersonalDriverId, PersonalPackerId: Integer;
             OperDatePartner: TDateTime; InvNumberPartner: String; PriceWithVAT: Boolean;
             VATPercent, DiscountPercent, ExtraChargesPercent: double): integer;
    constructor Create; override;
  end;

implementation

uses DB;
{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
procedure TdbMovementTest.TearDown;
begin
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TdbMovementTest.MovementIncomeTest;
begin
  // создание документа
  // редактирование
  // удаление
end;

procedure TdbMovementTest.SetUp;
begin
  inherited;
end;
{------------------------------------------------------------------------------}
{ TMovementIncome }

constructor TMovementIncome.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_MovementIncome';
  spSelect := 'gpSelect_Object_MovementIncome';
  spGet := 'gpGet_Object_MovementIncome';
end;

function TMovementIncome.InsertDefault: integer;
begin

end;

function TMovementIncome.InsertUpdateMovementIncome(Id: Integer; InvNumber: String;
  OperDate: TDateTime; FromId, ToId, PaidKindId, ContractId, CarId,
  PersonalDriverId, PersonalPackerId: Integer; OperDatePartner: TDateTime;
  InvNumberPartner: String; PriceWithVAT: Boolean; VATPercent, DiscountPercent,
  ExtraChargesPercent: double): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inCarId', ftInteger, ptInput, CarId);
  FParams.AddParam('inPersonalDriverId', ftInteger, ptInput, PersonalDriverId);
  FParams.AddParam('inPersonalPackerId', ftInteger, ptInput, PersonalPackerId);
  FParams.AddParam('inOperDatePartner', ftDateTime, ptInput, OperDatePartner);
  FParams.AddParam('inInvNumberPartner', ftString, ptInput, InvNumberPartner);
  FParams.AddParam('inPriceWithVAT', ftBoolean, ptInput, PriceWithVAT);
  FParams.AddParam('inVATPercent', ftFloat, ptInput, VATPercent);
  FParams.AddParam('inDiscountPercent', ftFloat, ptInput, DiscountPercent);
  FParams.AddParam('inExtraChargesPercent', ftFloat, ptInput, ExtraChargesPercent);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Документы', TdbMovementTest.Suite);

end.

implementation

end.
