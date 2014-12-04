unit OrderInternalTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TOrderInternalTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TOrderInternal = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  protected
     procedure SetDataSetParam; override;
  public
    function InsertUpdateOrderInternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
             UnitId, OrderKindId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, UnitsTest, dbObjectTest,
     SysUtils, Db, TestFramework, ContractTest;

{ TOrderInternal }

constructor TOrderInternal.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_OrderInternal';
  spSelect := 'gpSelect_Movement_OrderInternal';
  spGet := 'gpGet_Movement_OrderInternal';
end;

function TOrderInternal.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    UnitId, OrderKindId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  UnitId := TUnit.Create.GetDefault;
  OrderKindId := 0;
  //
  result := InsertUpdateOrderInternal(Id, InvNumber, OperDate, UnitId, OrderKindId);
end;

function TOrderInternal.InsertUpdateOrderInternal(Id: Integer; InvNumber: String; OperDate: TDateTime;
             UnitId, OrderKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inOrderKindId', ftInteger, ptInput, OrderKindId);

  result := InsertUpdate(FParams);
end;

procedure TOrderInternal.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inIsErased', ftBoolean, ptInput, true);
end;

{ TOrderInternalTest }

procedure TOrderInternalTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\OrderInternal\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItem\OrderInternal\';
  inherited;
end;

procedure TOrderInternalTest.Test;
var MovementOrderInternal: TOrderInternal;
    Id: Integer;
    RecordCount: Integer;
begin
  inherited;
  // Создаем документ
  MovementOrderInternal := TOrderInternal.Create;
  RecordCount := MovementOrderInternal.GetDataSet.RecordCount;
  Id := MovementOrderInternal.InsertDefault;
  // создание документа
  Check(MovementOrderInternal.GetDataSet.RecordCount = RecordCount + 1, 'Не добавилась запись');
  try
  // редактирование
  finally
    MovementOrderInternal.Delete(Id);
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TOrderInternalTest.Suite);

end.
