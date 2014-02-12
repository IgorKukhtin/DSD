unit TaxTest;

interface

uses dbTest, dbMovementTest;

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
    function InsertUpdateTax(Id: Integer; InvNumber, InvNumberPartner: String; OperDate: TDateTime;
             Checked, Document, PriceWithVAT: Boolean;
             VATPercent: double;
             FromId, ToId, ContractId, DocumentTaxKindId: Integer
             ): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, UnitsTest, DocumentTaxKindTest, dbObjectTest, SysUtils, Db, TestFramework;

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
    InvNumber,InvNumberPartner: String;
    OperDate: TDateTime;
    Checked, Document, PriceWithVAT: Boolean;
    VATPercent: double;
    FromId, ToId, ContractId, DocumentTaxKindId : Integer;
begin
  Id:=0;
  InvNumber:='1';
  InvNumberPartner:='123';
  OperDate:= Date;
  Checked:=true;
  Document:=true;
  PriceWithVAT:=true;
  VATPercent:=20;

  FromId := TPartnerTest.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  DocumentTaxKindId:=0;//TDocumentTaxKindTest.GetDefault;
//  DocumentTaxKindId:=TDocumentTaxKindTest.GetDefault;
  ContractId:=TContractTest.Create.GetDefault;

  result := InsertUpdateTax(Id, InvNumber, InvNumberPartner, OperDate,
             Checked, Document, PriceWithVAT,
             VATPercent,
             FromId, ToId,  ContractId, DocumentTaxKindId);
end;

function TTax.InsertUpdateTax(Id: Integer; InvNumber, InvNumberPartner: String; OperDate: TDateTime;
             Checked, Document, PriceWithVAT: Boolean;
             VATPercent: double;
             FromId, ToId, ContractId, DocumentTaxKindId: Integer
             ): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inInvNumberPartner', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inChecked', ftBoolean, ptInput, Checked);
  FParams.AddParam('inDocument', ftBoolean, ptInput, Document);
  FParams.AddParam('inPriceWithVAT', ftBoolean, ptInput, PriceWithVAT);
  FParams.AddParam('inVATPercent', ftFloat, ptInput, VATPercent);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inDocumentTaxKindId', ftInteger, ptInput, DocumentTaxKindId);

  result := InsertUpdate(FParams);
end;

{ TTaxTest }

procedure TTaxTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\_Tax\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\_Tax\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\_Tax\';
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

