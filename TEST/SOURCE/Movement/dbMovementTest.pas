unit dbMovementTest;

interface
uses TestFramework, dbObjectTest, Classes, dbTest;

type

  TMovementTest = class(TObjectTest)
  protected
    spCompleteProcedure: string;
    spUnCompleteProcedure: string;
    procedure InsertUpdateInList(Id: integer); override;
    procedure DocumentComplete(Id: integer);
    procedure DocumentUncomplete(Id: integer);
    procedure DeleteRecord(Id: Integer); override;
    procedure SetDataSetParam; override;
  public
    constructor Create; override;
    procedure Delete(Id: Integer); override;
  end;

  TdbMovementTestNew = class (TdbTest)
  protected
    procedure SetUp; override;
      // возвращаем данные для тестирования
    procedure TearDown; override;
  end;

  TdbMovementTest = class (TdbMovementTestNew)
  private
    // Удаление документа
    procedure DeleteMovement(Id: integer);
  published
    procedure MovementIncomeTest;
    procedure MovementProductionUnionTest;
    procedure MovementProductionSeparateTest;
    procedure MovementSendOnPriceTest;
    procedure MovementReturnOutTest;
    procedure MovementSendTest;

    procedure MovementLossTest;
    procedure MovementInventoryTest;
    procedure MovementZakazExternalTest;
    procedure MovementZakazInternalTest;
  end;

  TMovementIncomeTest = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementIncome(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; InvNumberPartner: String; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, PersonalPackerId: Integer
             ): integer;
    constructor Create; override;
  end;

  TMovementProductionUnionTest = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementProductionUnion(Id: Integer; InvNumber: String;
             OperDate: TDateTime; FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

  TMovementProductionSeparateTest = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementProductionSeparate(Id: Integer; InvNumber: String;
             OperDate: TDateTime; PartionGoods: String; FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

  TMovementSendOnPriceTest = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementSendOnPrice(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, CarId, PersonalDriverId, RouteId, RouteSortingId: Integer
             ): integer;
    constructor Create; override;
  end;

  TMovementReturnOutTest = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementReturnOut(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId: Integer
             ): integer;
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

  var
      // Список добавленных Id
    InsertedIdMovementList: TStringList;

implementation

uses DB, Storage, SysUtils, UnitsTest, dbMovementItemTest, dsdDB, CommonData, Authentication;
{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
procedure TdbMovementTest.DeleteMovement(Id: integer);
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
{------------------------------------------------------------------------------}
procedure TdbMovementTest.MovementIncomeTest;
var
  MovementIncome: TMovementIncomeTest;
  Id: Integer;
begin
  MovementIncome := TMovementIncomeTest.Create;
  Id := MovementIncome.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;

procedure TdbMovementTest.MovementProductionUnionTest;
var
  MovementProductionUnion: TMovementProductionUnionTest;
  Id: Integer;
begin
  MovementProductionUnion := TMovementProductionUnionTest.Create;
  Id := MovementProductionUnion.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;

procedure TdbMovementTest.MovementProductionSeparateTest;
var
  MovementProductionSeparate: TMovementProductionSeparateTest;
  Id: Integer;
begin
  MovementProductionSeparate := TMovementProductionSeparateTest.Create;
  Id := MovementProductionSeparate.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;

procedure TdbMovementTest.MovementSendOnPriceTest;
var
  MovementSendOnPrice: TMovementSendOnPriceTest;
  Id: Integer;
begin
  MovementSendOnPrice := TMovementSendOnPriceTest.Create;
  Id := MovementSendOnPrice.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
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
{------------------------------------------------------------------------------}
{ TMovementIncome }
constructor TMovementIncomeTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Income';
  spSelect := 'gpSelect_Movement_Income';
  spGet := 'gpGet_Movement_Income';
end;

function TMovementIncomeTest.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    OperDatePartner: TDateTime;
    InvNumberPartner: String;
    PriceWithVAT: Boolean;
    VATPercent, ChangePercent: double;
    FromId, ToId, PaidKindId, ContractId, PersonalPackerId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  OperDatePartner:= Date;
  InvNumberPartner:='InvNumberPartner';

  PriceWithVAT:=true;
  VATPercent:=20;
  ChangePercent:=-10;

  FromId := TPartnerTest.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  PaidKindId:=0;
  ContractId:=0;
  PersonalPackerId:=0;
  //
  result := InsertUpdateMovementIncome(Id, InvNumber, OperDate,
             OperDatePartner, InvNumberPartner, PriceWithVAT,
             VATPercent, ChangePercent,
             FromId, ToId, PaidKindId, ContractId, PersonalPackerId);
  inherited;
end;

function TMovementIncomeTest.InsertUpdateMovementIncome(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; InvNumberPartner: String; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, PersonalPackerId: Integer):Integer;
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

  result := InsertUpdate(FParams);
end;

{ TMovementProductionUnionTest }

constructor TMovementProductionUnionTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ProductionUnion';
  spSelect := 'gpSelect_Movement_ProductionUnion';
  spGet := 'gpGet_Movement_ProductionUnion';
end;

function TMovementProductionUnionTest.InsertDefault: integer;
begin
  result := InsertUpdateMovementProductionUnion(0, 'Номер 1', Date, 0, 0);
end;

function TMovementProductionUnionTest.InsertUpdateMovementProductionUnion(
  Id: Integer; InvNumber: String; OperDate: TDateTime; FromId,
  ToId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  result := InsertUpdate(FParams);
end;


{ TMovementProductionSeparateTest }
constructor TMovementProductionSeparateTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ProductionSeparate';
  spSelect := 'gpSelect_Movement_ProductionSeparate';
  spGet := 'gpGet_Movement_ProductionSeparate';
end;

function TMovementProductionSeparateTest.InsertDefault: integer;
begin
  result := InsertUpdateMovementProductionSeparate(0, 'Номер 1' ,Date, '12.05.13', 0, 0);
end;

function TMovementProductionSeparateTest.InsertUpdateMovementProductionSeparate(
  Id: Integer; InvNumber: String; OperDate: TDateTime; PartionGoods: String;
  FromId, ToId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inPartionGoods', ftString, ptInput, PartionGoods);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  result := InsertUpdate(FParams);
end;


{ TMovementSendOnPrice }
constructor TMovementSendOnPriceTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_SendOnPrice';
  spSelect := 'gpSelect_Movement_SendOnPrice';
  spGet := 'gpGet_Movement_SendOnPrice';
end;

function TMovementSendOnPriceTest.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    OperDatePartner: TDateTime;
    PriceWithVAT: Boolean;
    VATPercent, ChangePercent: double;
    FromId, ToId, CarId, PersonalDriverId, RouteId, RouteSortingId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  OperDatePartner:= Date;

  PriceWithVAT:=true;
  VATPercent:=20;
  ChangePercent:=-10;

  FromId := TPartnerTest.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  CarId:=0;
  PersonalDriverId:=0;
  RouteId:=0;
  RouteSortingId:=0;
  //
  result := InsertUpdateMovementSendOnPrice(Id, InvNumber, OperDate,
             OperDatePartner, PriceWithVAT,
             VATPercent, ChangePercent,
             FromId, ToId, CarId, PersonalDriverId, RouteId, RouteSortingId);

end;

function TMovementSendOnPriceTest.InsertUpdateMovementSendOnPrice(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, CarId, PersonalDriverId, RouteId, RouteSortingId: Integer):Integer;
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

  FParams.AddParam('inCarId', ftInteger, ptInput, CarId);
  FParams.AddParam('inPersonalDriverId', ftInteger, ptInput, PersonalDriverId);
  FParams.AddParam('inRouteId', ftInteger, ptInput, RouteId);
  FParams.AddParam('inRouteSortingId', ftInteger, ptInput, RouteSortingId);

  result := InsertUpdate(FParams);
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
    FromId, ToId, PaidKindId, ContractId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  OperDatePartner:= Date;

  PriceWithVAT:=true;
  VATPercent:=20;
  ChangePercent:=-10;

  FromId := TPartnerTest.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  PaidKindId:=0;
  ContractId:=0;
  //
  result := InsertUpdateMovementReturnOut(Id, InvNumber, OperDate,
             OperDatePartner, PriceWithVAT,
             VATPercent, ChangePercent,
             FromId, ToId, PaidKindId, ContractId);
end;

function TMovementReturnOutTest.InsertUpdateMovementReturnOut(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId: Integer):Integer;
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

  FromId := TPartnerTest.Create.GetDefault;
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

  FromId := TPartnerTest.Create.GetDefault;
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

  FromId := TPartnerTest.Create.GetDefault;
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

  FromId := TPartnerTest.Create.GetDefault;
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

  FromId := TPartnerTest.Create.GetDefault;
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

{ TMovementTest }

constructor TMovementTest.Create;
begin
  inherited;
  spUnCompleteProcedure := 'gpUnComplete_Movement';
end;

procedure TMovementTest.Delete(Id: Integer);
var Index: Integer;
begin
  if InsertedIdMovementList.Find(IntToStr(Id), Index) then begin
     // здесь мы разрешаем удалять ТОЛЬКО вставленные в момент теста данные
     DeleteRecord(Id);
     InsertedIdMovementList.Delete(Index);
  end
  else
     raise Exception.Create('Попытка удалить запись, вставленную вне теста!!!');
end;

procedure TMovementTest.DeleteRecord(Id: Integer);
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

procedure TMovementTest.DocumentComplete(Id: integer);
begin
  with FdsdStoredProc do begin
    StoredProcName := spCompleteProcedure;
    OutputType := otResult;
    Params.Clear;
    Params.AddParam('inMovementId', ftInteger, ptInput, Id);
    Execute;
  end;
end;

procedure TMovementTest.DocumentUncomplete(Id: integer);
begin
  with FdsdStoredProc do begin
    StoredProcName := spUnCompleteProcedure;
    OutputType := otResult;
    Params.Clear;
    Params.AddParam('inMovementId', ftInteger, ptInput, Id);
    Execute;
  end;
end;

procedure TMovementTest.InsertUpdateInList(Id: integer);
begin
  InsertedIdMovementList.Add(IntToStr(Id));
end;

procedure TMovementTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, FloatToDateTime(Date - 1));
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
end;

{ TdbMovementTestNew }

procedure TdbMovementTestNew.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

procedure TdbMovementTestNew.TearDown;
begin
  inherited;
  if Assigned(InsertedIdMovementItemList) then
     with TMovementTest.Create do
       while InsertedIdMovementItemList.Count > 0 do
          Delete(StrToInt(InsertedIdMovementItemList[0]));

  if Assigned(InsertedIdMovementList) then
   with TMovementTest.Create do
     while InsertedIdMovementList.Count > 0 do
        Delete(StrToInt(InsertedIdMovementList[0]));

  if Assigned(InsertedIdObjectList) then
     with TObjectTest.Create do
       while InsertedIdObjectList.Count > 0 do
          Delete(StrToInt(InsertedIdObjectList[0]));
end;

initialization
  InsertedIdMovementList := TStringList.Create;
  InsertedIdMovementList.Sorted := true;

  TestFramework.RegisterTest('Документы', TdbMovementTest.Suite);

end.
