unit ReturnInTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TReturnInTest = class(TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TReturnIn = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateReturnIn(Id: integer; InvNumber, InvNumberPartner,
      InvNumberMark: String; OperDate: TDateTime; OperDatePartner: TDateTime;
      Checked, PriceWithVAT: Boolean; VATPercent, ChangePercent: double;
      FromId, ToId, PaidKindId, ContractId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, dbObjectMeatTest, DocumentTaxKindTest, UnitsTest, dbObjectTest,
  SysUtils, Db, TestFramework, PartnerTest, PaidKindTest, ContractTest;


{ TReturnIn }

constructor TReturnIn.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ReturnIn';
  spSelect := 'gpSelect_Movement_ReturnIn';
  spGet := 'gpGet_Movement_ReturnIn';
end;

function TReturnIn.InsertDefault: integer;
var
  Id: integer;
  InvNumber, InvNumberPartner, InvNumberMark: String;
  OperDate: TDateTime;
  OperDatePartner: TDateTime;
  Checked, PriceWithVAT: Boolean;
  VATPercent, ChangePercent: double;
  FromId, ToId, PaidKindId, ContractId: integer;
begin
  Id := 0;
  InvNumber := '1';
  InvNumberPartner := '123';
  InvNumberMark := '456';
  OperDate := Date;

  OperDatePartner := Date;
  Checked := true;
  PriceWithVAT := true;
  VATPercent := 20;
  ChangePercent := -10;

  FromId := TPartner.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  PaidKindId := TPaidKind.Create.GetDefault;
  ContractId := TContract.Create.GetDefault;
  //
  result := InsertUpdateReturnIn(Id, InvNumber, InvNumberPartner, InvNumberMark,
    OperDate, OperDatePartner, Checked, PriceWithVAT, VATPercent, ChangePercent,
    FromId, ToId, PaidKindId, ContractId);
end;

function TReturnIn.InsertUpdateReturnIn(Id: integer;
  InvNumber, InvNumberPartner, InvNumberMark: String; OperDate: TDateTime;
  OperDatePartner: TDateTime; Checked, PriceWithVAT: Boolean;
  VATPercent, ChangePercent: double; FromId, ToId, PaidKindId,
  ContractId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inInvNumberPartner', ftString, ptInput, InvNumberPartner);
  FParams.AddParam('inInvNumberMark', ftString, ptInput, InvNumberMark);
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

  result := InsertUpdate(FParams);
end;

{ TReturnInTest }

procedure TReturnInTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\ReturnIn\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\ReturnIn\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\ReturnIn\';
  inherited;
end;

procedure TReturnInTest.Test;
var
  MovementReturnIn: TReturnIn;
  Id: integer;
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

// TestFramework.RegisterTest('Документы', TReturnInTest.Suite);

end.
