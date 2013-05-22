unit dbMovementCompleteTest;

interface

uses TestFramework, DB;

type

  TdbMovementCompleteTest = class (TTestCase)
  private
    // Распроведение документа
    procedure UnCompleteMovement(Id: integer);
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure CompleteMovementIncomeTest;
  end;

implementation

uses Storage, SysUtils, dbMovementTest, DBClient, dsdDB, dbMovementItemTest;
{ TdbMovementItemTest }

{ TdbMovementCompleteTest }

procedure TdbMovementCompleteTest.CompleteMovementIncomeTest;
const
   pXML =
  '<xml Session = "">' +
    '<gpComplete_Movement_Income OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</gpComplete_Movement_Income>' +
  '</xml>';
var
  MovementIncomeTest: TMovementIncomeTest;
  MovementId: Integer;
begin
  MovementIncomeTest := TMovementIncomeTest.Create;
  try
    TMovementItemIncomeTest.Create.GetDefault;
    MovementId := MovementIncomeTest.GetDefault;
    TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [MovementId]));
    try
      check(MovementIncomeTest.GetRecord(MovementId).FieldByName('StatusCode').AsInteger = 2, 'Статус не изменился');
    finally
      UnCompleteMovement(MovementId);
    end;
  finally
    MovementIncomeTest.Free
  end;
end;

procedure TdbMovementCompleteTest.SetUp;
begin
  inherited;

end;

procedure TdbMovementCompleteTest.TearDown;
begin
  inherited;

end;

procedure TdbMovementCompleteTest.UnCompleteMovement(Id: integer);
const
   pXML =
  '<xml Session = "">' +
    '<gpUnComplete_Movement OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</gpUnComplete_Movement>' +
  '</xml>';
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]))
end;

initialization
  TestFramework.RegisterTest('Проведение Документов', TdbMovementCompleteTest.Suite);

end.

