unit ZakazExternalTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type

  TZakazExternalTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TZakazExternal = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementZakazExternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
             OperDatePartner, OperDateMark: TDateTime; InvNumberPartner: String;
             FromId, PersonalId, RouteId, RouteSortingId: Integer
             ): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, PartnerTest, UnitsTest, CurrencyTest, dbObjectTest, SysUtils,
     Db, TestFramework;

{ TZakazExternal }

constructor TZakazExternal.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ZakazExternal';
  spSelect := 'gpSelect_Movement_ZakazExternal';
  spGet := 'gpGet_Movement_ZakazExternal';
end;

function TZakazExternal.InsertDefault: integer;
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

function TZakazExternal.InsertUpdateMovementZakazExternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
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


{ TZakazExternalTest }

procedure TZakazExternalTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\ZakazExternal\';
  inherited;
end;

procedure TZakazExternalTest.Test;
var
  MovementZakazExternal: TZakazExternal;
  Id: Integer;
begin
  MovementZakazExternal := TZakazExternal.Create;
  Id := MovementZakazExternal.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;


initialization

  TestFramework.RegisterTest('Документы', TZakazExternalTest.Suite);

end.
