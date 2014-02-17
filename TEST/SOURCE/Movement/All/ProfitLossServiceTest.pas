unit ProfitLossServiceTest;

interface

uses dbTest, dbMovementTest;

type
  TProfitLossServiceTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TProfitLossService = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateProfitLossService(Id: Integer; InvNumber: String; OperDate: TDateTime):Integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, dbObjectTest, SysUtils, Db, TestFramework;

{ TProfitLossService }

constructor TProfitLossService.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ProfitLossService';
  spSelect := 'gpSelect_Movement_ProfitLossService';
  spGet := 'gpGet_Movement_ProfitLossService';
end;

function TProfitLossService.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  //
  result := InsertUpdateProfitLossService(Id, InvNumber, OperDate);
end;

function TProfitLossService.InsertUpdateProfitLossService(Id: Integer; InvNumber: String; OperDate: TDateTime):Integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  result := InsertUpdate(FParams);
end;

{ TProfitLossServiceTest }

procedure TProfitLossServiceTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\ProfitLossService\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\ProfitLossService\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\ProfitLossService\';
  inherited;
end;

procedure TProfitLossServiceTest.Test;
var MovementProfitLossService: TProfitLossService;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementProfitLossService := TProfitLossService.Create;
  Id := MovementProfitLossService.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    MovementProfitLossService.Delete(Id);
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TProfitLossServiceTest.Suite);

end.
