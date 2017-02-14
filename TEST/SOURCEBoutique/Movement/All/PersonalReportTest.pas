unit PersonalReportTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TPersonalReportTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPersonalReport = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePersonalReport(const Id: integer; InvNumber: String;
        OperDate: TDateTime; AmountIn: Double; AmountOut: Double;
        Comment: String;
        MemberId, InfoMoneyId, UnitId, MoneyPlaceId, CarId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, MemberTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TPersonalReport }

constructor TPersonalReport.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_PersonalReport';
  spSelect := 'gpSelect_Movement_PersonalReport';
  spGet := 'gpGet_Movement_PersonalReport';
end;

function TPersonalReport.InsertDefault: integer;
var Id: Integer;
    InvNumber, Comment: String;
    OperDate: TDateTime;
    AmountIn, AmountOut: Double;
    MemberId, InfoMoneyId, UnitId, MoneyPlaceId, CarId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  AmountIn:= 265.68;
  AmountOut:= 0;
  Comment:= '';
  MemberId := 8490;//TMember.Create.GetDefault;
  InfoMoneyId := 0;
  UnitId := 0;
  InfoMoneyId := 8908;
  MoneyPlaceId := 14686;
  CarId := 0;

  result := InsertUpdatePersonalReport(Id,InvNumber,
        OperDate, AmountIn, AmountOut,
        Comment,
        MemberId, InfoMoneyId, UnitId, MoneyPlaceId, CarId);
end;

function TPersonalReport.InsertUpdatePersonalReport(const Id: integer; InvNumber: String;
        OperDate: TDateTime; AmountIn: Double; AmountOut: Double;
        Comment: String;
        MemberId, InfoMoneyId, UnitId, MoneyPlaceId, CarId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inAmountIn', ftFloat, ptInput, AmountIn);
  FParams.AddParam('inAmountOut', ftFloat, ptInput, AmountOut);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  FParams.AddParam('inMemberId', ftInteger, ptInput, MemberId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inMoneyPlaceId', ftInteger, ptInput, MoneyPlaceId);
  FParams.AddParam('inCarId', ftInteger, ptInput, CarId);

  result := InsertUpdate(FParams);

end;

{ TPersonalReportTest }

procedure TPersonalReportTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\PersonalReport\';
  inherited;
end;

procedure TPersonalReportTest.Test;
var MovementPersonalReport: TPersonalReport;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementPersonalReport := TPersonalReport.Create;
//  Id := MovementPersonalReport.InsertDefault;
  Id := 0;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TPersonalReportTest.Suite);

end.
