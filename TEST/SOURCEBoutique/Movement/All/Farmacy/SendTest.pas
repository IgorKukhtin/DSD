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
  protected
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementSend(Id: Integer; InvNumber: String;
             OperDate: TDateTime; UnitFromId, UnitToId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, UnitsTest, dbObjectTest, SysUtils,
     Db, TestFramework, GoodsTest;

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
    UnitID: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  UnitId := TUnit.Create.GetDefault;
  result := InsertUpdateMovementSend(Id, InvNumber, OperDate, UnitId, UnitId);
end;

function TSend.InsertUpdateMovementSend(Id: Integer; InvNumber: String; OperDate: TDateTime;
                         UnitFromId, UnitToId: Integer):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inFromId', ftInteger, ptInput, UnitFromId);
  FParams.AddParam('inToId', ftInteger, ptInput, UnitToId);

  result := InsertUpdate(FParams);
end;

{ TSendTest }

procedure TSendTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Send\';
  inherited;
end;

procedure TSendTest.Test;
var
  MovementSend: TSend;
  Id: Integer;
begin
  MovementSend := TSend.Create;
  // создание документа
  Id := MovementSend.InsertDefault;
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;

end;

{ TSendItem }

initialization

  TestFramework.RegisterTest('Документы', TSendTest.Suite);

end.
