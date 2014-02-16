unit TaxCorrectiveTest;

interface

uses dbTest, dbMovementTest;

type
  TTaxCorrectiveTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TTaxCorrective = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateTaxCorrective(Id: Integer; InvNumber, InvNumberPartner: String; OperDate: TDateTime;
             Checked, Document, PriceWithVAT: Boolean;
             VATPercent: double;
             FromId, ToId, ContractId, DocumentTaxKindId: Integer
             ): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, UnitsTest, DocumentTaxKindTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TTaxCorrective }

constructor TTaxCorrective.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_TaxCorrective';
  spSelect := 'gpSelect_Movement_TaxCorrective';
  spGet := 'gpGet_Movement_TaxCorrective';
end;

function TTaxCorrective.InsertDefault: integer;
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
  DocumentTaxKindId:=TDocumentTaxKind.Create.GetDefault;
  ContractId:=TContractTest.Create.GetDefault;

  result := InsertUpdateTaxCorrective(Id, InvNumber, InvNumberPartner, OperDate,
             Checked, Document, PriceWithVAT,
             VATPercent,
             FromId, ToId,  ContractId, DocumentTaxKindId);
end;

function TTaxCorrective.InsertUpdateTaxCorrective(Id: Integer; InvNumber, InvNumberPartner: String; OperDate: TDateTime;
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

{ TTaxCorrectiveTest }

procedure TTaxCorrectiveTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\TaxCorrective\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\TaxCorrective\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\TaxCorrective\';
  inherited;
end;

procedure TTaxCorrectiveTest.Test;
var MovementTaxCorrective: TTaxCorrective;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementTaxCorrective := TTaxCorrective.Create;
  Id := MovementTaxCorrective.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    MovementTaxCorrective.Delete(Id);
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TTaxCorrectiveTest.Suite);

end.

