unit PriceListMovementTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TPriceListMovementTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPriceListMovement = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  protected
     procedure SetDataSetParam; override;
  public
    function InsertUpdatePriceListMovement(Id: Integer; InvNumber: String; OperDate: TDateTime;
             JuridicalId, ContractId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, UnitsTest, dbObjectTest,
     SysUtils, Db, TestFramework, ContractTest;

{ TPriceListMovement }

constructor TPriceListMovement.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_PriceList';
  spSelect := 'gpSelect_Movement_PriceList';
  spGet := 'gpGet_Movement_PriceList';
end;

function TPriceListMovement.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    JuridicalId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;

  JuridicalId := TJuridical.Create.GetDefault;
  //
  result := InsertUpdatePriceListMovement(Id, InvNumber, OperDate, JuridicalId, 0);
end;

function TPriceListMovement.InsertUpdatePriceListMovement(Id: Integer; InvNumber: String; OperDate: TDateTime;
             JuridicalId, ContractId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);

  result := InsertUpdate(FParams);
end;

procedure TPriceListMovement.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inIsErased', ftBoolean, ptInput, true);
end;

{ TPriceListMovementTest }

procedure TPriceListMovementTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\PriceList\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItem\PriceList\';
  inherited;
end;

procedure TPriceListMovementTest.Test;
var PriceListMovement: TPriceListMovement;
    Id: Integer;
    RecordCount: Integer;
begin
  inherited;
  // Создаем документ
  PriceListMovement := TPriceListMovement.Create;
  RecordCount := PriceListMovement.GetDataSet.RecordCount;
  Id := PriceListMovement.InsertDefault;
  // создание документа
  Check(PriceListMovement.GetDataSet.RecordCount = RecordCount + 1, 'Не добавилась запись');
  try
  // редактирование
  finally
    PriceListMovement.Delete(Id);
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TPriceListMovementTest.Suite);

end.
