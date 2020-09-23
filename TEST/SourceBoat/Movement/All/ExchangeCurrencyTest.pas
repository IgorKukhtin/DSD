unit ExchangeCurrencyTest;

interface

uses dbTest, dbMovementTest;

type
  TExchangeCurrencyTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TExchangeCurrency = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateExchangeCurrency(const Id: integer; InvNumber: String;
        OperDate: TDateTime; AmountFrom, AmountTo: Double;
        FromId, ToId, InfoMoneyId: integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, JuridicalTest, dbObjectTest, SysUtils, Db, TestFramework;

{ TExchangeCurrency }

constructor TExchangeCurrency.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_ExchangeCurrency';
  spSelect := 'gpSelect_Movement_ExchangeCurrency';
  spGet := 'gpGet_Movement_ExchangeCurrency';
end;

function TExchangeCurrency.InsertDefault: integer;
var Id: Integer;
    InvNumber: String;
    OperDate: TDateTime;
    AmountFrom, AmountTo: Double;
    FromId, ToId, InfoMoneyId: Integer;
begin
  Id:=0;
  InvNumber:='1';
  OperDate:= Date;
  FromId := TPersonalTest.Create.GetDefault;
  ToId := TJuridical.Create.GetDefault;
  InfoMoneyId := 0;
  AmountFrom := 265.68;
  AmountTo := 432.10;

  result := InsertUpdateExchangeCurrency(Id, InvNumber, OperDate, AmountFrom, AmountTo,
              FromId, ToId, InfoMoneyId);
end;

function TExchangeCurrency.InsertUpdateExchangeCurrency(const Id: integer; InvNumber: String;
        OperDate: TDateTime; AmountFrom, AmountTo: Double;
        FromId, ToId, InfoMoneyId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inAmountFrom', ftFloat, ptInput, AmountFrom);
  FParams.AddParam('inAmountTo', ftFloat, ptInput, AmountTo);
  FParams.AddParam('inFromId', ftInteger, ptInput, FromId);
  FParams.AddParam('inToId', ftInteger, ptInput, ToId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);

  result := InsertUpdate(FParams);

end;

{ TExchangeCurrencyTest }

procedure TExchangeCurrencyTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\ExchangeCurrency\';
  inherited;
end;

procedure TExchangeCurrencyTest.Test;
var MovementExchangeCurrency: TExchangeCurrency;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementExchangeCurrency := TExchangeCurrency.Create;
  Id := MovementExchangeCurrency.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TExchangeCurrencyTest.Suite);

end.
