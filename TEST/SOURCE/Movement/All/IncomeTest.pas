unit IncomeTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TIncomeTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TIncome = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateIncome(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; InvNumberPartner: String; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, PersonalPackerId,
             CurrencyDocumentId, CurrencyPartnerId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, PartnerTest, UnitsTest, CurrencyTest, dbObjectTest, SysUtils,
     Db, TestFramework;

{ TIncome }

constructor TIncome.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Income';
  spSelect := 'gpSelect_Movement_Income';
  spGet := 'gpGet_Movement_Income';
end;

function TIncome.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    OperDatePartner: TDateTime;
    InvNumberPartner: String;
    PriceWithVAT: Boolean;
    VATPercent, ChangePercent: double;
    FromId, ToId, PaidKindId, ContractId, PersonalPackerId: Integer;
    CurrencyId: integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  OperDatePartner:= Date;
  InvNumberPartner:='InvNumberPartner';

  PriceWithVAT:=true;
  VATPercent:=20;
  ChangePercent:=-10;

  FromId := TPartner.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  PaidKindId:=0;
  ContractId:=0;
  PersonalPackerId:=0;
  CurrencyId := TCurrency.Create.GetDefault;
  //
  result := InsertUpdateIncome(Id, InvNumber, OperDate,
             OperDatePartner, InvNumberPartner, PriceWithVAT,
             VATPercent, ChangePercent,
             FromId, ToId, PaidKindId, ContractId, PersonalPackerId, CurrencyId, CurrencyId);
  inherited;
end;

function TIncome.InsertUpdateIncome(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; InvNumberPartner: String; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, PersonalPackerId,
             CurrencyDocumentId, CurrencyPartnerId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);

  FParams.AddParam('inOperDatePartner', ftDateTime, ptInput, OperDatePartner);
  FParams.AddParam('inInvNumberPartner', ftString, ptInput, InvNumberPartner);

  FParams.AddParam('inPriceWithVAT', ftBoolean, ptInput, PriceWithVAT);
  FParams.AddParam('inVATPercent', ftFloat, ptInput, VATPercent);
  FParams.AddParam('inChangePercent', ftFloat, ptInput, ChangePercent);

  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inPersonalPackerId', ftInteger, ptInput, PersonalPackerId);
  FParams.AddParam('inCurrencyDocumentId', ftInteger, ptInput, CurrencyDocumentId);
  FParams.AddParam('inCurrencyPartnerId', ftInteger, ptInput, CurrencyPartnerId);

  result := InsertUpdate(FParams);
end;

{ TBankStatementItemTest }

procedure TIncomeTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\Income\';
  inherited;
end;

procedure TIncomeTest.Test;
var
  Income: TIncome;
  Id: Integer;
begin
  Income := TIncome.Create;
  Id := Income.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;


initialization

//  TestFramework.RegisterTest('Документы', TIncomeTest.Suite);

end.
