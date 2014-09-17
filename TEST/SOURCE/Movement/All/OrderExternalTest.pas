unit OrderExternalTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TOrderExternalTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TOrderExternal = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateOrderExternal(Id: Integer; InvNumber,InvNumberPartner,InvNumberOrder: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; Checked, PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, {CarId, PersonalDriverId, RouteId, PersonalId, }RouteSortingId,PriceListId: Integer
             ): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, dbObjectMeatTest, JuridicalTest, UnitsTest, dbObjectTest,
     SysUtils, Db, TestFramework, PartnerTest, ContractTest;

{ TOrderExternal }

constructor TOrderExternal.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_OrderExternal';
  spSelect := 'gpSelect_Movement_OrderExternal';
  spGet := 'gpGet_Movement_OrderExternal';
end;

function TOrderExternal.InsertDefault: integer;
var Id: Integer;
    InvNumber,InvNumberPartner: String;
    OperDate: TDateTime;
    OperDatePartner: TDateTime;
    Checked,PriceWithVAT: Boolean;
    VATPercent, ChangePercent: double;
    InvNumberOrder:String;
    FromId, ToId, PaidKindId, ContractId, {CarId, PersonalDriverId, RouteId, PersonalId,} RouteSortingId, PriceListId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  InvNumberPartner:='123';
  OperDate:= Date;
  OperDatePartner:= Date;

  Checked:=true;
  PriceWithVAT:=true;
  VATPercent:=20;
  ChangePercent:=-10;

  InvNumberOrder:='';

  FromId := TPartner.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  PaidKindId:=1;
  ContractId:=TContract.Create.GetDefault;
  //CarId:=0;
  //PersonalDriverId:=0;
  //RouteId:=0;
  //PersonalId:=0;
  RouteSortingId:=0;
  PriceListId:=0;
  //
  result := InsertUpdateOrderExternal(Id, InvNumber, InvNumberPartner, InvNumberOrder, OperDate,
             OperDatePartner, Checked, PriceWithVAT,
             VATPercent, ChangePercent,
             FromId, ToId, PaidKindId, ContractId,
             {CarId,PersonalDriverId, RouteId, PersonalId,}
             RouteSortingId,PriceListId);
end;

function TOrderExternal.InsertUpdateOrderExternal(Id: Integer; InvNumber,InvNumberPartner,InvNumberOrder: String; OperDate: TDateTime;
             OperDatePartner: TDateTime; Checked, PriceWithVAT: Boolean;
             VATPercent, ChangePercent: double;
             FromId, ToId, PaidKindId, ContractId, {CarId, PersonalDriverId, RouteId, PersonalId, }RouteSortingId,PriceListId: Integer
             ): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inInvNumberPartner', ftString, ptInput, InvNumber);
  FParams.AddParam('inInvNumberOrder', ftString, ptInput, InvNumberOrder);

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

//  FParams.AddParam('inCarId', ftInteger, ptInput, CarId);
//  FParams.AddParam('inPersonalDriverId', ftInteger, ptInput, PersonalDriverId);
//  FParams.AddParam('inRouteId', ftInteger, ptInput, RouteId);
//  FParams.AddParam('inPersonalId', ftInteger, ptInput, PersonalId);

  FParams.AddParam('inRouteSortingId', ftInteger, ptInput, RouteSortingId);
  FParams.AddParam('ioPriceListId', ftInteger, ptInput, PriceListId);

  result := InsertUpdate(FParams);
end;

{ TOrderExternalTest }

procedure TOrderExternalTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\OrderExternal\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItem\OrderExternal\';
  inherited;
end;

procedure TOrderExternalTest.Test;
var MovementOrderExternal: TOrderExternal;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementOrderExternal := TOrderExternal.Create;
  Id := MovementOrderExternal.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    MovementOrderExternal.Delete(Id);
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TOrderExternalTest.Suite);

end.
