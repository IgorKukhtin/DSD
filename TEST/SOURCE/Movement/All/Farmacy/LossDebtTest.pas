unit LossDebtTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TLossDebtTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TLossDebt = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateLossDebt(const Id: integer; InvNumber: string;
        OperDate: TDateTime; JuridicalId: integer): Integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TLossDebt }

constructor TLossDebt.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_LossDebt';
  spSelect := 'gpSelect_Movement_LossDebt';
  spGet := 'gpGet_Movement_LossDebt';
end;

function TLossDebt.InsertDefault: integer;
var Id: Integer;
begin
  Id:=0;
  result := InsertUpdateLossDebt(Id, '-12', Date, TJuridical.Create.GetDefault);
end;

function TLossDebt.InsertUpdateLossDebt(const Id: integer; InvNumber: string;
        OperDate: TDateTime; JuridicalId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);

  result := InsertUpdate(FParams);
end;

{ TLossDebtTest }

procedure TLossDebtTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\LossDebt\';
  inherited;
end;

procedure TLossDebtTest.Test;
var MovementLossDebt: TLossDebt;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementLossDebt := TLossDebt.Create;
  MovementLossDebt.GetDataSet.RecordCount;

  Id := MovementLossDebt.InsertDefault;
  // создание документа
  try
  // редактирование
     MovementLossDebt.GetRecord(Id);
  finally

  end;
end;

initialization

//  TestFramework.RegisterTest('Документы', TLossDebtTest.Suite);

end.
