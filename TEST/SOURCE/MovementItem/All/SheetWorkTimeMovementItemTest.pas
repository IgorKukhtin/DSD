unit SheetWorkTimeMovementItemTest;

interface

uses dbMovementItemTest;

type

  TSheetWorkTimeMovementItemTest = class(TdbMovementItemTest)
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

uses UtilConst, Db, SysUtils, PersonalTest, UnitsTest;

{ TSheetWorkTimeMovementItemTest }

procedure TSheetWorkTimeMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'MovementItem\_SheetWorkTime\';
  inherited;
  ScriptDirectory := ProcedurePath + 'Movement\_SheetWorkTime\';
  inherited;
end;

procedure TSheetWorkTimeMovementItemTest.Test;
var
  SheetWorkTimeMovementItem: TSheetWorkTimeMovementItem;
  PersonalId, PositionId, UnitId, PersonalGroupId: Integer;
  OperDate: TDateTime;
  Value: string;
  TypeId: Integer;
begin
  SheetWorkTimeMovementItem := TSheetWorkTimeMovementItem.Create;
  PersonalId := TPersonal.Create.GetDefault;
  PositionId := 0;
  UnitId := TUnit.Create.GetDefault;
  PersonalGroupId := 0;
  OperDate := StrToDateTime('2100-01-01');
  Value := '8';
  TypeId := 0;
  // ѕросто создадим
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

end.
