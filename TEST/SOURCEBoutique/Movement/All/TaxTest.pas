unit TaxTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TTaxTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TTax = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateTax(Id: Integer; InvNumber, InvNumberPartner,InvNumberBranch: String; OperDate: TDateTime;
             Checked, Document, PriceWithVAT: Boolean;
             VATPercent: double;
             FromId, ToId, PartnerId, ContractId, DocumentTaxKindId: Integer
             ): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, dbObjectMeatTest, JuridicalTest, DocumentTaxKindTest
   , dbObjectTest, SysUtils, Db, TestFramework, PartnerTest, ContractTest;

{ TTax }

constructor TTax.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Tax';
  spSelect := 'gpSelect_Movement_Tax';
  spGet := 'gpGet_Movement_Tax';
end;

function TTax.InsertDefault: integer;
var Id: Integer;
    InvNumber,InvNumberPartner,InvNumberBranch: String;
    OperDate: TDateTime;
    Checked, Document, PriceWithVAT: Boolean;
    VATPercent: double;
    FromId, ToId, PartnerId, ContractId, DocumentTaxKindId : Integer;
begin
  Id:=0;
  InvNumber:='1';
  InvNumberPartner:='123';
  InvNumberBranch:='456';
  OperDate:= Date;
  Checked:=true;
  Document:=true;
  PriceWithVAT:=true;
  VATPercent:=20;

  FromId := TJuridical.Create.GetDefault;
  ToId :=TJuridical.Create.GetDefault;
  PartnerId:=TPartner.Create.GetDefault;
  DocumentTaxKindId:=TDocumentTaxKind.Create.GetDefault;
  ContractId:=TContract.Create.GetDefault;

  result := InsertUpdateTax(Id, InvNumber, InvNumberPartner,InvNumberBranch, OperDate,
             Checked, Document, PriceWithVAT,
             VATPercent,
             FromId, ToId,  PartnerId, ContractId, DocumentTaxKindId);
end;

function TTax.InsertUpdateTax(Id: Integer; InvNumber, InvNumberPartner,InvNumberBranch: String; OperDate: TDateTime;
             Checked, Document, PriceWithVAT: Boolean;
             VATPercent: double;
             FromId, ToId, PartnerId, ContractId, DocumentTaxKindId: Integer
             ): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inInvNumberPartner', ftString, ptInput, InvNumber);
  FParams.AddParam('inInvNumberBranch', ftString, ptInput, InvNumberBranch);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inChecked', ftBoolean, ptInput, Checked);
  FParams.AddParam('inDocument', ftBoolean, ptInput, Document);
  FParams.AddParam('inPriceWithVAT', ftBoolean, ptInput, PriceWithVAT);
  FParams.AddParam('inVATPercent', ftFloat, ptInput, VATPercent);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('PartnerId', ftInteger, ptInput, PartnerId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inDocumentTaxKindId', ftInteger, ptInput, DocumentTaxKindId);

  result := InsertUpdate(FParams);
end;

{ TTaxTest }

procedure TTaxTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\Tax\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\Tax\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\Tax\';
  inherited;
end;

procedure TTaxTest.Test;
var MovementTax: TTax;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementTax := TTax.Create;
  Id := MovementTax.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    MovementTax.Delete(Id);
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TTaxTest.Suite);

end.

