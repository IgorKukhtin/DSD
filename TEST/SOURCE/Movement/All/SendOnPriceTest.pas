unit SendOnPriceTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type

  TSendOnPriceTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TSendOnPrice = class(TMovementTest)
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

implementation

uses UtilConst, PartnerTest, UnitsTest, CurrencyTest, dbObjectTest, SysUtils,
     Db, TestFramework;

{ TSendOnPrice }

constructor TSendOnPrice.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_SendOnPrice';
  spSelect := 'gpSelect_Movement_SendOnPrice';
  spGet := 'gpGet_Movement_SendOnPrice';
end;

function TSendOnPrice.InsertDefault: integer;
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

  FromId := TPartner.Create.GetDefault;
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

function TSendOnPrice.InsertUpdateMovementSendOnPrice(Id: Integer; InvNumber: String; OperDate: TDateTime;
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


{ TSendOnPriceTest }

procedure TSendOnPriceTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\SendOnPrice\';
  inherited;
end;

procedure TSendOnPriceTest.Test;
var
  MovementSendOnPrice: TSendOnPrice;
  Id: Integer;
begin
  MovementSendOnPrice := TSendOnPrice.Create;
  Id := MovementSendOnPrice.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;


initialization

//  TestFramework.RegisterTest('Документы', TSendOnPriceTest.Suite);

end.
