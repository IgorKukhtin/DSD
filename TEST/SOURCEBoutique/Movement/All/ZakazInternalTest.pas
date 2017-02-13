unit ZakazInternalTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type

  TZakazInternalTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TZakazInternal = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementZakazInternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
             FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, PartnerTest, UnitsTest, CurrencyTest, dbObjectTest, SysUtils,
     Db, TestFramework;

{ TZakazInternal }

constructor TZakazInternal.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ZakazInternal';
  spSelect := 'gpSelect_Movement_ZakazInternal';
  spGet := 'gpGet_Movement_ZakazInternal';
end;

function TZakazInternal.InsertDefault: integer;
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

function TZakazInternal.InsertUpdateMovementZakazInternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
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


{ TZakazInternalTest }

procedure TZakazInternalTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\ZakazInternal\';
  inherited;
end;

procedure TZakazInternalTest.Test;
var
  MovementZakazInternal: TZakazInternal;
  Id: Integer;
begin
  MovementZakazInternal := TZakazInternal.Create;
  Id := MovementZakazInternal.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;


initialization

  TestFramework.RegisterTest('Документы', TZakazInternalTest.Suite);

end.
