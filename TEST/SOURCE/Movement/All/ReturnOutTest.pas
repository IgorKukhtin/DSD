unit ReturnOutTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TReturnOutTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TReturnOut = class(TMovementTest)
  protected
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementReturnOut(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId,
             CurrencyDocumentId, CurrencyPartnerId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, dbObjectMeatTest, JuridicalTest, UnitsTest, dbObjectTest, SysUtils,
     Db, TestFramework, PartnerTest, ContractTest, PaidKindTest, CurrencyTest;

{ TReturnOut }

constructor TReturnOut.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ReturnOut';
  spSelect := 'gpSelect_Movement_ReturnOut';
  spGet := 'gpGet_Movement_ReturnOut';
end;

function TReturnOut.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    OperDatePartner: TDateTime;
    PriceWithVAT: Boolean;
    VATPercent, ChangePercent: double;
    FromId, ToId, PaidKindId, ContractId, CurrencyId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  OperDatePartner:= Date;

  PriceWithVAT:=true;
  VATPercent:=20;
  ChangePercent:=-10;

  FromId := TPartner.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  PaidKindId:=0;
  ContractId:=0;
  CurrencyId := TCurrency.Create.GetDefault;
  //
  result := InsertUpdateMovementReturnOut(Id, InvNumber, OperDate,
             OperDatePartner, PriceWithVAT,
             VATPercent, ChangePercent,
             FromId, ToId, PaidKindId, ContractId, CurrencyId, CurrencyId);
end;

function TReturnOut.InsertUpdateMovementReturnOut(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId,
             CurrencyDocumentId, CurrencyPartnerId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);

  FParams.AddParam('inOperDatePartner', ftDateTime, ptInput, OperDatePartner);

  FParams.AddParam('inPriceWithVAT', ftBoolean, ptInput, PriceWithVAT);
  FParams.AddParam('inVATPercent', ftFloat, ptInput, VATPercent);
  FParams.AddParam('inChangePercent', ftFloat, ptInput, ChangePercent);

  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inCurrencyDocumentId', ftInteger, ptInput, CurrencyDocumentId);
  FParams.AddParam('inCurrencyPartnerId', ftInteger, ptInput, CurrencyPartnerId);

  result := InsertUpdate(FParams);
end;

{ TReturnOutTest }

procedure TReturnOutTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\ReturnOut\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\ReturnOut\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\ReturnOut\';
  inherited;
end;

procedure TReturnOutTest.Test;
var MovementReturnOut: TReturnOut;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementReturnOut := TReturnOut.Create;
  Id := MovementReturnOut.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    MovementReturnOut.Delete(Id);
  end;
end;

initialization

//  TestFramework.RegisterTest('Документы', TReturnOutTest.Suite);

end.
