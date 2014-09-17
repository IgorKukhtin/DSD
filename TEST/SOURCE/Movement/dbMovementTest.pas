unit dbMovementTest;

interface
uses TestFramework, dbObjectTest, Classes, dbTest, ObjectTest;

type

  TdbMovementTestNew = class (TdbTest)
  protected
    // Удаление документа
    procedure DeleteMovement(Id: integer);
    procedure SetUp; override;
  end;

  TdbMovementTest = class (TdbMovementTestNew)
  published
    procedure MovementReturnOutTest;
    procedure MovementSendTest;

    procedure MovementLossTest;
    procedure MovementInventoryTest;
    procedure MovementZakazExternalTest;
    procedure MovementZakazInternalTest;
  end;

  TMovementReturnOutTest = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementReturnOut(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId,
             CurrencyDocumentId, CurrencyPartnerId: Integer): integer;
    constructor Create; override;
  end;

  TMovementSendTest = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementSend(Id: Integer; InvNumber: String; OperDate: TDateTime;
             FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

  TMovementLossTest = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementLoss(Id: Integer; InvNumber: String; OperDate: TDateTime;
             FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

  TMovementInventoryTest = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementInventory(Id: Integer; InvNumber: String; OperDate: TDateTime;
             FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

  TMovementZakazExternalTest = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementZakazExternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner, OperDateMark: TDateTime; InvNumberPartner: String;
             FromId, PersonalId, RouteId, RouteSortingId: Integer
             ): integer;
    constructor Create; override;
  end;

  TMovementZakazInternalTest = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementZakazInternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
             FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses DB, Storage, SysUtils, UnitsTest, dbMovementItemTest, dsdDB, CommonData
   , Authentication, dbObjectMeatTest, PartnerTest, CurrencyTest;
{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
procedure TdbMovementTestNew.DeleteMovement(Id: integer);
const
   pXML =
  '<xml Session = "">' +
    '<lpDelete_Movement OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</lpDelete_Movement>' +
  '</xml>';
var i: integer;
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]));
  for i := 0 to DefaultValueList.Count - 1 do
      if DefaultValueList.Values[DefaultValueList.Names[i]] = IntToStr(Id) then begin
         DefaultValueList.Values[DefaultValueList.Names[i]] := '';
         break;
      end;
end;

procedure TdbMovementTest.MovementReturnOutTest;
var
  MovementReturnOut: TMovementReturnOutTest;
  Id: Integer;
begin
  MovementReturnOut := TMovementReturnOutTest.Create;
  Id := MovementReturnOut.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;

procedure TdbMovementTest.MovementSendTest;
var
  MovementSend: TMovementSendTest;
  Id: Integer;
begin
  MovementSend := TMovementSendTest.Create;
  Id := MovementSend.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;

procedure TdbMovementTest.MovementLossTest;
var
  MovementLoss: TMovementLossTest;
  Id: Integer;
begin
  MovementLoss := TMovementLossTest.Create;
  Id := MovementLoss.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;

procedure TdbMovementTest.MovementInventoryTest;
var
  MovementInventory: TMovementInventoryTest;
  Id: Integer;
begin
  MovementInventory := TMovementInventoryTest.Create;
  Id := MovementInventory.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;

procedure TdbMovementTest.MovementZakazExternalTest;
var
  MovementZakazExternal: TMovementZakazExternalTest;
  Id: Integer;
begin
  MovementZakazExternal := TMovementZakazExternalTest.Create;
  Id := MovementZakazExternal.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;

procedure TdbMovementTest.MovementZakazInternalTest;
var
  MovementZakazInternal: TMovementZakazInternalTest;
  Id: Integer;
begin
  MovementZakazInternal := TMovementZakazInternalTest.Create;
  Id := MovementZakazInternal.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;

{ TMovementReturnOut }
constructor TMovementReturnOutTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ReturnOut';
  spSelect := 'gpSelect_Movement_ReturnOut';
  spGet := 'gpGet_Movement_ReturnOut';
end;

function TMovementReturnOutTest.InsertDefault: integer;
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

function TMovementReturnOutTest.InsertUpdateMovementReturnOut(Id: Integer; InvNumber: String; OperDate: TDateTime;
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

{ TMovementSend }
constructor TMovementSendTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Send';
  spSelect := 'gpSelect_Movement_Send';
  spGet := 'gpGet_Movement_Send';
end;

function TMovementSendTest.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    FromId, ToId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  FromId := TPartner.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;

  //
  result := InsertUpdateMovementSend(Id, InvNumber, OperDate, FromId, ToId);

end;

function TMovementSendTest.InsertUpdateMovementSend(Id: Integer; InvNumber: String; OperDate: TDateTime;
                         FromId, ToId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);

  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);

  result := InsertUpdate(FParams);
end;

{ TMovementLoss }
constructor TMovementLossTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Loss';
  spSelect := 'gpSelect_Movement_Loss';
  spGet := 'gpGet_Movement_Loss';
end;

function TMovementLossTest.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    FromId, ToId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  FromId := TPartner.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  //
  result := InsertUpdateMovementLoss(Id, InvNumber, OperDate, FromId, ToId);
end;

function TMovementLossTest.InsertUpdateMovementLoss(Id: Integer; InvNumber: String; OperDate: TDateTime;
                                                    FromId, ToId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);

  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);

  result := InsertUpdate(FParams);
end;

{ TMovementInventory }
constructor TMovementInventoryTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Inventory';
  spSelect := 'gpSelect_Movement_Inventory';
  spGet := 'gpGet_Movement_Inventory';
end;

function TMovementInventoryTest.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    FromId, ToId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  FromId := TPartner.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  //
  result := InsertUpdateMovementInventory(Id, InvNumber, OperDate, FromId, ToId);
end;

function TMovementInventoryTest.InsertUpdateMovementInventory(Id: Integer; InvNumber: String; OperDate: TDateTime;
                                                    FromId, ToId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);

  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);

  result := InsertUpdate(FParams);
end;

{ TMovementZakazExternal }
constructor TMovementZakazExternalTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ZakazExternal';
  spSelect := 'gpSelect_Movement_ZakazExternal';
  spGet := 'gpGet_Movement_ZakazExternal';
end;

function TMovementZakazExternalTest.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    OperDatePartner: TDateTime;
    OperDateMark: TDateTime;
    InvNumberPartner: String;
    FromId, PersonalId, RouteId, RouteSortingId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  OperDatePartner:= Date;
  OperDateMark:= Date;
  InvNumberPartner:='4';

  FromId := TPartner.Create.GetDefault;
  PersonalId:=0;
  RouteId:=0;
  RouteSortingId:=0;
  //
  result := InsertUpdateMovementZakazExternal(Id, InvNumber, OperDate,
             OperDatePartner, OperDateMark, InvNumberPartner,
             FromId, PersonalId, RouteId, RouteSortingId);

end;

function TMovementZakazExternalTest.InsertUpdateMovementZakazExternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner, OperDateMark: TDateTime; InvNumberPartner: String;
             FromId, PersonalId, RouteId, RouteSortingId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);

  FParams.AddParam('inOperDatePartner', ftDateTime, ptInput, OperDatePartner);
  FParams.AddParam('inOperDateMark', ftDateTime, ptInput, OperDateMark);
  FParams.AddParam('inInvNumberPartner', ftString, ptInput, InvNumberPartner);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);

  FParams.AddParam('inPersonalId', ftInteger, ptInput, PersonalId);
  FParams.AddParam('inRouteId', ftInteger, ptInput, RouteId);
  FParams.AddParam('inRouteSortingId', ftInteger, ptInput, RouteSortingId);

  result := InsertUpdate(FParams);
end;

{ TMovementZakazInternal }
constructor TMovementZakazInternalTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ZakazInternal';
  spSelect := 'gpSelect_Movement_ZakazInternal';
  spGet := 'gpGet_Movement_ZakazInternal';
end;

function TMovementZakazInternalTest.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    FromId, ToId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  FromId := TPartner.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  //
  result := InsertUpdateMovementZakazInternal(Id, InvNumber, OperDate
                                            , FromId, ToId);

end;

function TMovementZakazInternalTest.InsertUpdateMovementZakazInternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
                                                                      FromId, ToId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);

  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);

  result := InsertUpdate(FParams);
end;

{ TdbMovementTestNew }

procedure TdbMovementTestNew.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;


initialization

  TestFramework.RegisterTest('Документы', TdbMovementTest.Suite);

end.
