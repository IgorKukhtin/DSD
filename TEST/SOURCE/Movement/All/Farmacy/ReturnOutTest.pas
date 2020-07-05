unit ReturnOutTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TReturnOutTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TReturnOut = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateReturnOut(Id: Integer; InvNumber, InvNumberPartner: String;
             OperDate, OperDatePartner: TDateTime;
             PriceWithVAT: Boolean; FromId, ToId, NDSKindId, IncomeId, ReturnTypeId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, UnitsTest, dbObjectTest, SysUtils, Db,
     TestFramework, JuridicalTest, IncomeTest, ReturnTypeTest;

{ TReturnOut }

constructor TReturnOut.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ReturnOut';
  spSelect := 'gpSelect_Movement_ReturnOut';
  spGet := 'gpGet_Movement_ReturnOut';
end;

function TReturnOut.InsertDefault: integer;
var Id: Integer;
    InvNumber, InvNumberPartner: String;
    OperDate, OperDatePartner: TDateTime;
    PriceWithVAT: Boolean;
    FromId, ToId, NDSKindId,
    IncomeId, ReturnTypeId: Integer;
begin
  Id := 0;
  InvNumber := '1';
  InvNumberPartner := '-1';
  OperDate := Date;
  OperDatePartner := Date + 10;

  PriceWithVAT := true;

  FromId := TJuridical.Create.GetDefault;
  ToId := TUnit.Create.GetDefault;
  NDSKindId := 0;
  IncomeId := TIncome.Create.GetDefault;
  ReturnTypeId := TReturnType.Create.GetDefault;
  //

  result := InsertUpdateReturnOut(Id, InvNumber, InvNumberPartner,
             OperDate, OperDatePartner,
             PriceWithVAT,
             FromId, ToId, NDSKindId, IncomeId, ReturnTypeId);
  inherited;
end;

function TReturnOut.InsertUpdateReturnOut(Id: Integer; InvNumber, InvNumberPartner: String;
             OperDate, OperDatePartner: TDateTime;
             PriceWithVAT: Boolean; FromId, ToId, NDSKindId, IncomeId, ReturnTypeId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inInvNumberPartner', ftString, ptInput, InvNumberPartner);
  FParams.AddParam('inOperDatePartner', ftDateTime, ptInput, OperDatePartner);
  FParams.AddParam('inPriceWithVAT', ftBoolean, ptInput, PriceWithVAT);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inNDSKindId', ftInteger, ptInput, NDSKindId);
  FParams.AddParam('inIncomeId', ftInteger, ptInput, IncomeId);
  FParams.AddParam('inReturnTypeId', ftInteger, ptInput, ReturnTypeId);
  result := InsertUpdate(FParams);
end;

procedure TReturnOut.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inIsErased', ftBoolean, ptInput, true);
end;

{ TBankStatementItemTest }

procedure TReturnOutTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\ReturnOut\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItem\ReturnOut\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItemContainer\ReturnOut\';
  inherited;
end;

procedure TReturnOutTest.Test;
var
  ReturnOut: TReturnOut;
  Id: Integer;
  RecordCount: integer;
begin
  ReturnOut := TReturnOut.Create;
  RecordCount := ReturnOut.GetDataSet.RecordCount;
  Id := ReturnOut.InsertDefault;
  // создание документа
  try
  // редактирование
    ReturnOut.GetRecord(Id);
    Check((RecordCount + 1)= ReturnOut.GetDataSet.RecordCount, '«апись не добавлена');
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;


initialization

//  TestFramework.RegisterTest('ƒокументы', TReturnOutTest.Suite);

end.
