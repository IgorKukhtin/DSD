unit dbMovementTest;

interface
uses TestFramework, dbObjectTest;

type

  TdbMovementTest = class (TTestCase)
  private
    // Удаление документа
    procedure DeleteMovement(Id: integer);
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure MovementIncomeTest;
    procedure MovementProductionUnionTest;
    procedure MovementProductionSeparateTest;
    procedure MovementSendOnPriceTest;
    procedure MovementSaleTest;
    procedure MovementReturnOutTest;
    procedure MovementReturnInTest;
    procedure MovementSendTest;

    procedure MovementLossTest;
    procedure MovementInventoryTest;

    procedure MovementZakazExternalTest;
    procedure MovementZakazInternalTest;

  end;

  TMovementIncomeTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementIncome(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; InvNumberPartner: String; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, CarId, PersonalDriverId, PersonalPackerId: Integer
             ): integer;
    constructor Create; override;
  end;

  TMovementProductionUnionTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementProductionUnion(Id: Integer; InvNumber: String;
             OperDate: TDateTime; FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

  TMovementProductionSeparateTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementProductionSeparate(Id: Integer; InvNumber: String;
             OperDate: TDateTime; PartionGoods: String; FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

  TMovementSendOnPriceTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementSendOnPrice(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, CarId, PersonalDriverId, RouteId, RouteSortingId: Integer
             ): integer;
    constructor Create; override;
  end;

  TMovementSaleTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementSale(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, CarId, PersonalDriverId, PersonalId, RouteId, RouteSortingId: Integer
             ): integer;
    constructor Create; override;
  end;

  TMovementReturnOutTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementReturnOut(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId: Integer
             ): integer;
    constructor Create; override;
  end;

  TMovementReturnInTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementReturnIn(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, CarId, PersonalDriverId: Integer
             ): integer;
    constructor Create; override;
  end;

  TMovementSendTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementSend(Id: Integer; InvNumber: String; OperDate: TDateTime;
             FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

  TMovementLossTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementLoss(Id: Integer; InvNumber: String; OperDate: TDateTime;
             FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

  TMovementInventoryTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementInventory(Id: Integer; InvNumber: String; OperDate: TDateTime;
             FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

  TMovementZakazExternalTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementZakazExternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner, OperDateMark: TDateTime; InvNumberPartner: String;
             FromId, PersonalId, RouteId, RouteSortingId: Integer
             ): integer;
    constructor Create; override;
  end;

  TMovementZakazInternalTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementZakazInternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
             FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses DB, Storage, SysUtils, UnitsTest;
{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
procedure TdbMovementTest.TearDown;
begin
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TdbMovementTest.DeleteMovement(Id: integer);
const
   pXML =
  '<xml Session = "">' +
    '<lpDelete_Movement OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</lpDelete_Movement>' +
  '</xml>';
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]))
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

procedure TdbMovementTest.MovementSaleTest;
var
  MovementSale: TMovementSaleTest;
  Id: Integer;
begin
  MovementSale := TMovementSaleTest.Create;
  Id := MovementSale.InsertDefault;
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

procedure TdbMovementTest.MovementReturnInTest;
var
  MovementReturnIn: TMovementReturnInTest;
  Id: Integer;
begin
  MovementReturnIn := TMovementReturnInTest.Create;
  Id := MovementReturnIn.InsertDefault;
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

procedure TdbMovementTest.SetUp;
begin
  inherited;
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
    FromId, ToId, PaidKindId, ContractId, CarId, PersonalDriverId, PersonalPackerId: Integer;
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
  CarId:=0;
  PersonalDriverId:=0;
  PersonalPackerId:=0;
  //
  result := InsertUpdateMovementIncome(Id, InvNumber, OperDate,
             OperDatePartner, InvNumberPartner, PriceWithVAT,
             VATPercent, ChangePercent,
             FromId, ToId, PaidKindId, ContractId, CarId, PersonalDriverId, PersonalPackerId);
end;

function TMovementIncomeTest.InsertUpdateMovementIncome(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; InvNumberPartner: String; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, CarId, PersonalDriverId, PersonalPackerId: Integer):Integer;
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
  FParams.AddParam('inCarId', ftInteger, ptInput, CarId);
  FParams.AddParam('inPersonalDriverId', ftInteger, ptInput, PersonalDriverId);
  FParams.AddParam('inPersonalPackerId', ftInteger, ptInput, PersonalPackerId);

  result := InsertUpdate(FParams);
end;

procedure TMovementIncomeTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, Date);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
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

procedure TMovementProductionUnionTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, Date);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
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

procedure TMovementProductionSeparateTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, Date);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
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

procedure TMovementSendOnPriceTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, Date);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
end;

{ TMovementSale }
constructor TMovementSaleTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Sale';
  spSelect := 'gpSelect_Movement_Sale';
  spGet := 'gpGet_Movement_Sale';
end;

function TMovementSaleTest.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    OperDatePartner: TDateTime;
    PriceWithVAT: Boolean;
    VATPercent, ChangePercent: double;
    FromId, ToId, PaidKindId, ContractId, CarId, PersonalDriverId, PersonalId,RouteId, RouteSortingId: Integer;
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
  PaidKindId:=1;
  ContractId:=TContractTest.Create.GetDefault;
  CarId:=0;
  PersonalDriverId:=0;
  PersonalId:=0;
  RouteId:=0;
  RouteSortingId:=0;
  //
  result := InsertUpdateMovementSale(Id, InvNumber, OperDate,
             OperDatePartner, PriceWithVAT,
             VATPercent, ChangePercent,
             FromId, ToId, PaidKindId, ContractId, CarId,
             PersonalDriverId, PersonalId, RouteId, RouteSortingId);

end;

function TMovementSaleTest.InsertUpdateMovementSale(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, CarId,
             PersonalDriverId, PersonalId, RouteId, RouteSortingId: Integer):Integer;
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

  FParams.AddParam('inCarId', ftInteger, ptInput, CarId);
  FParams.AddParam('inPersonalDriverId', ftInteger, ptInput, PersonalDriverId);
  FParams.AddParam('inPersonalId', ftInteger, ptInput, PersonalId);
  FParams.AddParam('inRouteId', ftInteger, ptInput, RouteId);
  FParams.AddParam('inRouteSortingId', ftInteger, ptInput, RouteSortingId);

  result := InsertUpdate(FParams);
end;

procedure TMovementSaleTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, Date);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
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

procedure TMovementReturnOutTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, Date);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
end;

{ TMovementReturnIn }
constructor TMovementReturnInTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ReturnIn';
  spSelect := 'gpSelect_Movement_ReturnIn';
  spGet := 'gpGet_Movement_ReturnIn';
end;

function TMovementReturnInTest.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    OperDatePartner: TDateTime;
    PriceWithVAT: Boolean;
    VATPercent, ChangePercent: double;
    FromId, ToId, PaidKindId, ContractId, CarId, PersonalDriverId: Integer;
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
  PaidKindId:=TPaidKindTest.Create.GetDefault;
  ContractId:=TContractTest.Create.GetDefault;
  CarId:=TCarTest.Create.GetDefault;
  PersonalDriverId:=0;
  //
  result := InsertUpdateMovementReturnIn(Id, InvNumber, OperDate,
             OperDatePartner, PriceWithVAT,
             VATPercent, ChangePercent,
             FromId, ToId, PaidKindId, ContractId,
             CarId, PersonalDriverId);
end;

function TMovementReturnInTest.InsertUpdateMovementReturnIn(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, CarId, PersonalDriverId: Integer):Integer;
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

  FParams.AddParam('inCarId', ftInteger, ptInput, CarId);
  FParams.AddParam('inPersonalDriverId', ftInteger, ptInput, PersonalDriverId);

  result := InsertUpdate(FParams);
end;

procedure TMovementReturnInTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, Date);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
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

procedure TMovementSendTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, Date);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
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

procedure TMovementLossTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, Date);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
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

procedure TMovementInventoryTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, Date);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
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

procedure TMovementZakazExternalTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, Date);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
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

procedure TMovementZakazInternalTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, Date);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
end;

initialization

//  TestFramework.RegisterTest('Документы', TdbMovementTest.Suite);

end.
