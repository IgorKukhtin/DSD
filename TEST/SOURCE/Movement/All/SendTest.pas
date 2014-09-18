unit SendTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type

  TSendTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TSend = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementSend(Id: Integer; InvNumber: String;
             OperDate: TDateTime; FromId, ToId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, PartnerTest, UnitsTest, CurrencyTest, dbObjectTest, SysUtils,
     Db, TestFramework;

{ TSend }

constructor TSend.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Send';
  spSelect := 'gpSelect_Movement_Send';
  spGet := 'gpGet_Movement_Send';
end;

function TSend.InsertDefault: integer;
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

function TSend.InsertUpdateMovementSend(Id: Integer; InvNumber: String; OperDate: TDateTime;
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


{ TSendTest }

procedure TSendTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\Send\';
  inherited;
end;

procedure TSendTest.Test;
var
  MovementSend: TSend;
  Id: Integer;
begin
  MovementSend := TSend.Create;
  Id := MovementSend.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;


initialization

  TestFramework.RegisterTest('Документы', TSendTest.Suite);

end.