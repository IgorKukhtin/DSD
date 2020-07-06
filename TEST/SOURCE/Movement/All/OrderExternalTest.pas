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
  protected
     procedure SetDataSetParam; override;
  public
    function InsertUpdateOrderExternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
             FromId, ToId, ContractId, InternalOrderId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, UnitsTest, dbObjectTest,
     SysUtils, Db, TestFramework, ContractTest, OrderInternalTest;

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
    InvNumber: String;
    OperDate: TDateTime;
    FromId, ToId, InternalOrderId, ContractId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  FromId := TJuridical.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  ContractId := 0;
  InternalOrderId := TOrderInternal.Create.GetDefault;
  //
  result := InsertUpdateOrderExternal(Id, InvNumber, OperDate, FromId, ToId, ContractId, InternalOrderId);
end;

function TOrderExternal.InsertUpdateOrderExternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
             FromId, ToId, ContractId, InternalOrderId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inInternalOrderId', ftInteger, ptInput, InternalOrderId);

  result := InsertUpdate(FParams);
end;

procedure TOrderExternal.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inIsErased', ftBoolean, ptInput, true);
end;

{ TOrderExternalTest }

procedure TOrderExternalTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\OrderExternal\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItem\OrderExternal\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'Calculation\ExternalOrder\';
  inherited;
end;

procedure TOrderExternalTest.Test;
var MovementOrderExternal: TOrderExternal;
    Id: Integer;
    RecordCount: Integer;
begin
  inherited;
  // Создаем документ
  MovementOrderExternal := TOrderExternal.Create;
  RecordCount := MovementOrderExternal.GetDataSet.RecordCount;
  Id := MovementOrderExternal.InsertDefault;
  // создание документа
  Check(MovementOrderExternal.GetDataSet.RecordCount = RecordCount + 1, 'Не добавилась запись');
  try
  // редактирование
  finally
    MovementOrderExternal.Delete(Id);
  end;
end;

initialization

//  TestFramework.RegisterTest('Документы', TOrderExternalTest.Suite);

end.
