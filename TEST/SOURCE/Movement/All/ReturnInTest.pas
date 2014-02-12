unit ReturnInTest;

interface

uses dbTest, dbMovementTest;

type
  TReturnInTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TReturnIn = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateReturnIn(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; Checked,PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, DocumentTaxKindId: Integer):Integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, DocumentTaxKindTest, UnitsTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TReturnIn }

constructor TReturnIn.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ReturnIn';
  spSelect := 'gpSelect_Movement_ReturnIn';
  spGet := 'gpGet_Movement_ReturnIn';
end;

function TReturnIn.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    OperDatePartner: TDateTime;
    Checked, PriceWithVAT: Boolean;
    VATPercent, ChangePercent: double;
    FromId, ToId, PaidKindId, ContractId, DocumentTaxKindId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  OperDatePartner:= Date;
  Checked:=true;
  PriceWithVAT:=true;
  VATPercent:=20;
  ChangePercent:=-10;

  FromId := TPartnerTest.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  PaidKindId:=TPaidKindTest.Create.GetDefault;
  ContractId:=TContractTest.Create.GetDefault;
  DocumentTaxKindId:=TDocumentTaxKind.Create.GetDefault;
  //
  result := InsertUpdateReturnIn(Id, InvNumber, OperDate,
             OperDatePartner, Checked, PriceWithVAT,
             VATPercent, ChangePercent,
             FromId, ToId, PaidKindId, ContractId, DocumentTaxKindId);
end;

function TReturnIn.InsertUpdateReturnIn(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; Checked,PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, DocumentTaxKindId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);

  FParams.AddParam('inOperDatePartner', ftDateTime, ptInput, OperDatePartner);

  FParams.AddParam('inChecked', ftBoolean, ptInput, Checked);
  FParams.AddParam('inPriceWithVAT', ftBoolean, ptInput, PriceWithVAT);
  FParams.AddParam('inVATPercent', ftFloat, ptInput, VATPercent);
  FParams.AddParam('inChangePercent', ftFloat, ptInput, ChangePercent);

  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inDocumentTaxKindId', ftInteger, ptInput, DocumentTaxKindId);


  result := InsertUpdate(FParams);
end;

{ TReturnInTest }

procedure TReturnInTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\_ReturnIn\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\_ReturnIn\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\_ReturnIn\';
  inherited;
end;

procedure TReturnInTest.Test;
var MovementReturnIn: TReturnIn;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementReturnIn := TReturnIn.Create;
  Id := MovementReturnIn.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    MovementReturnIn.Delete(Id);
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TReturnInTest.Suite);

end.
