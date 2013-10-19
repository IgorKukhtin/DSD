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

uses UtilConst, Db;

{ TSheetWorkTimeMovementItemTest }

procedure TSheetWorkTimeMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'MovementItem\_SheetWorkTime\';
  inherited;
  ScriptDirectory := ProcedurePath + 'Movement\_SheetWorkTime\';
  inherited;
end;

procedure TSheetWorkTimeMovementItemTest.Test;
begin

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
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inAmountPartner', ftFloat, ptInput, AmountPartner);
  FParams.AddParam('inAmountPacker', ftFloat, ptInput, AmountPacker);
  FParams.AddParam('inPrice', ftFloat, ptInput, Price);
  FParams.AddParam('inCountForPrice', ftFloat, ptInput, CountForPrice);
  FParams.AddParam('inLiveWeight', ftFloat, ptInput, LiveWeight);
  FParams.AddParam('inHeadCount', ftFloat, ptInput, HeadCount);
  FParams.AddParam('inPartionGoods', ftString, ptInput, PartionGoods);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  FParams.AddParam('inAssetId', ftInteger, ptInput, AssetId);
  result := InsertUpdate(FParams);
end;

end.
