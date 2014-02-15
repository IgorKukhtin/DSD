unit SheetWorkTimeMovementItemTest;

interface

uses dbMovementItemTest, dbTest;

type

  TSheetWorkTimeMovementItemTest = class(TdbTest)
  protected
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; virtual;
    procedure Test; virtual;
  end;

  TSheetWorkTimeMovementItem = class(TMovementItemTest)
  public
    function InsertUpdateSheetWorkTimeMovementItem
      (PersonalId, PositionId, UnitId, PersonalGroupId: Integer;
       OperDate: TDateTime; Value: string; TypeId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, PersonalTest, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants;

{ TSheetWorkTimeMovementItemTest }

procedure TSheetWorkTimeMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'MovementItem\SheetWorkTime\';
  inherited;
  ScriptDirectory := ProcedurePath + 'Movement\SheetWorkTime\';
  inherited;
end;

procedure TSheetWorkTimeMovementItemTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

procedure TSheetWorkTimeMovementItemTest.TearDown;
begin
  inherited;
  if Assigned(InsertedIdMovementItemList) then
     with TMovementItemTest.Create do
       while InsertedIdMovementItemList.Count > 0 do
          Delete(StrToInt(InsertedIdMovementItemList[0]));

  if Assigned(InsertedIdMovementList) then
     with TMovementTest.Create do
       while InsertedIdMovementList.Count > 0 do
          Delete(StrToInt(InsertedIdMovementList[0]));

  if Assigned(InsertedIdObjectList) then
     with TObjectTest.Create do
       while InsertedIdObjectList.Count > 0 do
          Delete(StrToInt(InsertedIdObjectList[0]));
end;

procedure TSheetWorkTimeMovementItemTest.Test;
var
  SheetWorkTimeMovementItem: TSheetWorkTimeMovementItem;
  PersonalId, PositionId, UnitId, PersonalGroupId: Integer;
  OperDate: TDateTime;
  Value: string;
  TypeId: Integer;
begin
  exit;
  SheetWorkTimeMovementItem := TSheetWorkTimeMovementItem.Create;
  PersonalId := TPersonal.Create.GetDefault;
  PositionId := 0;
  UnitId := TUnit.Create.GetDefault;
  PersonalGroupId := 0;
  OperDate := VarToDateTime('2100-01-01');
  Value := '8';
  TypeId := 0;
  // Просто создадим
  SheetWorkTimeMovementItem.InsertUpdateSheetWorkTimeMovementItem(
             PersonalId, PositionId, UnitId, PersonalGroupId, OperDate, Value, TypeId);
  try
  // а потом отредактируем
  finally
  end;
end;

{ TSheetWorkTimeMovementItem }

constructor TSheetWorkTimeMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_SheetWorkTime';
end;

function TSheetWorkTimeMovementItem.InsertUpdateSheetWorkTimeMovementItem(
  PersonalId, PositionId, UnitId, PersonalGroupId: Integer; OperDate: TDateTime;
  Value: string; TypeId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioPersonalId', ftInteger, ptInputOutput, PersonalId);
  FParams.AddParam('inPositionId', ftInteger, ptInput, PositionId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inPersonalGroupId', ftInteger, ptInput, PersonalGroupId);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inValue', ftString, ptInput, Value);
  FParams.AddParam('inTypeId', ftInteger, ptInput, TypeId);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Строки Документов', TSheetWorkTimeMovementItemTest.Suite);

end.
