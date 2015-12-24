unit ChangeIncomePaymentTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TChangeIncomePaymentTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TChangeIncomePayment = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateChangeIncomePayment(Id: Integer; InvNumber: String; OperDate: TDateTime;
             TotalSumm: Real;
             FromId, JuridicalId, ChangeIncomePaymentKindId: Integer; Comment: String): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, dbObjectTest, SysUtils, Db,
     TestFramework, JuridicalTest, ChangeIncomePaymentKindTest;

var
InvNumber: String;
    OperDate: TDateTime;
    TotalSumm: Real;
    FromId, JuridicalId, ChangeIncomePaymentKindId: Integer;
    Comment: String;
{ TChangeIncomePayment }

constructor TChangeIncomePayment.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ChangeIncomePayment';
  spSelect := 'gpSelect_Movement_ChangeIncomePayment';
  spGet := 'gpGet_Movement_ChangeIncomePayment';
end;

function TChangeIncomePayment.InsertDefault: integer;
var Id: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  TotalSumm:=1.0;

  FromId := TJuridical.Create.GetDefault;
  JuridicalId := FromId;
  ChangeIncomePaymentKindId:=TChangeIncomePaymentKind.Create.GetDefault;
  Comment := 'Test';
  result := InsertUpdateChangeIncomePayment(Id, InvNumber, OperDate,
             TotalSumm,
             FromId, JuridicalId, ChangeIncomePaymentKindId, Comment);
  inherited;
end;

function TChangeIncomePayment.InsertUpdateChangeIncomePayment(Id: Integer; InvNumber: String; OperDate: TDateTime;
             TotalSumm: Real;
             FromId, JuridicalId, ChangeIncomePaymentKindId: Integer; Comment: String): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inTotalSumm', ftFloat, ptInput, TotalSumm);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inChangeIncomePaymentKindId', ftInteger, ptInput, ChangeIncomePaymentKindId);
  FParams.AddParam('inComment', ftString, ptInput, Comment);

  result := InsertUpdate(FParams);
end;

{ TBankStatementItemTest }

procedure TChangeIncomePaymentTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\ChangeIncomePayment\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItemContainer\ChangeIncomePayment\';
  inherited;
end;

procedure TChangeIncomePaymentTest.Test;
var
  ChangeIncomePayment: TChangeIncomePayment;
  Id: Integer;
  DS: TDataSet;
begin
  ChangeIncomePayment := TChangeIncomePayment.Create;
  Id := ChangeIncomePayment.InsertDefault;
  // создание документа
  try
  // редактирование
    DS := ChangeIncomePayment.GetRecord(Id);
    with DS do
      Check((FieldByName('OperDate').AsDateTime = OperDate) AND
            (FieldByName('InvNumber').AsString = InvNumber) AND
            (FieldByName('TotalSumm').AsFloat = TotalSumm) AND
            (FieldByName('FromId').AsInteger = FromId) AND
            (FieldByName('JuridicalId').AsInteger = JuridicalId) AND
            (FieldByName('ChangeIncomePaymentKindId').AsInteger = ChangeIncomePaymentKindId) AND
            (FieldByName('Comment').AsString = Comment),
            'Ќе сход€тс€ данные Id = ' + FieldByName('id').AsString);
  finally
    // удаление
    DeleteMovement(Id);
  end;
end;


initialization

  TestFramework.RegisterTest('ƒокументы', TChangeIncomePaymentTest.Suite);

end.
