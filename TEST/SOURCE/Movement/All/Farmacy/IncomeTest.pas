unit IncomeTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TIncomeTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TIncome = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateIncome(Id: Integer; InvNumber: String; OperDate: TDateTime;
             PriceWithVAT: Boolean; FromId, ToId, NDSKindId, ContractId: Integer; PayDate: TDateTime;
             InvNumberBranch: String; OperDateBranch: TDateTime): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, UnitsTest, dbObjectTest, SysUtils, Db,
     TestFramework, JuridicalTest;

{ TIncome }

constructor TIncome.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Income';
  spSelect := 'gpSelect_Movement_Income';
  spGet := 'gpGet_Movement_Income';
end;

function TIncome.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    PriceWithVAT: Boolean;
    FromId, ToId, NDSKindId, ContractId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;


  PriceWithVAT:=true;

  FromId := TJuridical.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  NDSKindId:=0;
  ContractId:=0;
  //
  result := InsertUpdateIncome(Id, InvNumber, OperDate,
             PriceWithVAT,
             FromId, ToId, NDSKindId, ContractId, OperDate + 10,
             '0000',OperDate + 1);
  inherited;
end;

function TIncome.InsertUpdateIncome(Id: Integer; InvNumber: String; OperDate: TDateTime;
             PriceWithVAT: Boolean;
             FromId, ToId, NDSKindId, ContractId: Integer; PayDate: TDateTime;
             InvNumberBranch: String; OperDateBranch: TDateTime): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inPriceWithVAT', ftBoolean, ptInput, PriceWithVAT);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inNDSKindId', ftInteger, ptInput, NDSKindId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inPaymentDate', ftDateTime, ptInput, PayDate);
  FParams.AddParam('inInvNumberBranch', ftString, ptInput, InvNumberBranch);
  FParams.AddParam('inOperDateBranch', ftDateTime, ptInput, OperDateBranch);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, 0);
  result := InsertUpdate(FParams);
end;

{ TBankStatementItemTest }

procedure TIncomeTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Income\';
  inherited;
end;

procedure TIncomeTest.Test;
var
  Income: TIncome;
  Id: Integer;
begin
  Income := TIncome.Create;
  Id := Income.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;


initialization

//  TestFramework.RegisterTest('Документы', TIncomeTest.Suite);

end.
