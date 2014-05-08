unit dbMovementCompleteTest;

interface

uses TestFramework, DB, dbTest;

type

  TdbMovementCompleteTest = class (TdbTest)
  private
    // Распроведение документа
    procedure UnCompleteMovement(Id: integer);
  published
    procedure CompleteMovementIncomeTest;
  end;

implementation

uses Storage, SysUtils, dbMovementTest, DBClient, dsdDB, dbMovementItemTest,
     dbObjectTest, Authentication, CommonData;
{ TdbMovementItemTest }

{ TdbMovementCompleteTest }

procedure TdbMovementCompleteTest.CompleteMovementIncomeTest;
const
   pXML =
  '<xml Session = "">' +
    '<gpComplete_Movement_Income OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
       '<inIsLastComplete DataType="ftBoolean" Value="false"/>' +
    '</gpComplete_Movement_Income>' +
  '</xml>';
var
  MovementIncomeTest: TMovementIncomeTest;
  MovementId, MovementItemId: Integer;
begin
  MovementIncomeTest := TMovementIncomeTest.Create;
  try
    MovementItemId := TMovementItemIncomeTest.Create.GetDefault;
    MovementId := MovementIncomeTest.GetDefault;
    TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [MovementId]));
    try
      check(MovementIncomeTest.GetRecord(MovementId).FieldByName('StatusCode').AsInteger = 1, 'Статус не изменился');
    finally
      UnCompleteMovement(MovementId);
    end;
  finally

  end;
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

