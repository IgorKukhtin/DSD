unit dbMovementCompleteTest;

interface

uses TestFramework, DB;

type

  TdbMovementCompleteTest = class (TTestCase)
  private
    // Распроведение документа
    procedure UnCompleteMovement(Id: integer);
        // Удаление документа
    procedure DeleteMovementItem(Id: integer);
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure CompleteMovementIncomeTest;
  end;

implementation

uses Storage, SysUtils, dbMovementTest, DBClient, dsdDB, dbMovementItemTest, dbObjectTest;
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
    DeleteMovementItem(MovementItemId);
    with TMovementItemIncomeTest.Create do
         Delete(MovementItemId);

    MovementIncomeTest.Free
  end;
end;

procedure TdbMovementCompleteTest.DeleteMovementItem(Id: integer);
const
   pXML =
  '<xml Session = "">' +
    '<lpDelete_MovementItem OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</lpDelete_MovementItem>' +
  '</xml>';
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]))
end;

procedure TdbMovementCompleteTest.SetUp;
begin
  inherited;

end;

procedure TdbMovementCompleteTest.TearDown;
begin
  inherited;
  if Assigned(InsertedIdMovementItemList) then
     with TMovementTest.Create do
       while InsertedIdMovementItemList.Count > 0 do begin
          DeleteRecord(StrToInt(InsertedIdMovementItemList[0]));
          InsertedIdMovementItemList.Delete(0);
       end;
  if Assigned(InsertedIdMovementList) then
     with TMovementTest.Create do
       while InsertedIdMovementList.Count > 0 do begin
          DeleteRecord(StrToInt(InsertedIdMovementList[0]));
          InsertedIdMovementList.Delete(0);
       end;
  if Assigned(InsertedIdObjectList) then
     with TObjectTest.Create do
       while InsertedIdObjectList.Count > 0 do begin
          DeleteRecord(StrToInt(InsertedIdObjectList[0]));
          InsertedIdObjectList.Delete(0);
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

