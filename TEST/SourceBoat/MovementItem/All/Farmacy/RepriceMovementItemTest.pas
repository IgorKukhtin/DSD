unit RepriceMovementItemTest;

interface

uses dbTest, ObjectTest;

type

  TRepriceMovementItemTest = class(TdbTest)
  protected
  published
    // загрузка процедура из определенной директории
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TRepriceMovementItem = class(TMovementItemTest)
  private
  protected
    function InsertDefault: integer; override;
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemReprice
      (Id, GoodsId, UnitId: Integer; Amount, PriceOld, PriceNew: double; GUID:String): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, Db, SysUtils, dbMovementTest, UnitsTest,
     Storage, Authentication, TestFramework, CommonData, dbObjectTest,
     Variants, RepriceTest, GoodsTest, dsdDB;

{ TRepriceMovementItemTest }

procedure TRepriceMovementItemTest.Test;
var
  MovementItemReprice: TRepriceMovementItem;
  Id: Integer;
begin
  MovementItemReprice := TRepriceMovementItem.Create;
  Id := MovementItemReprice.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    MovementItemReprice.Delete(Id);
  end;
end;

procedure TRepriceMovementItemTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'Movement\Reprice\';
  inherited;
  ScriptDirectory := LocalProcedurePath + 'MovementItem\Reprice\';
  inherited;
end;

{ TRepriceMovementItem }

constructor TRepriceMovementItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_Reprice';
  spSelect := 'gpSelect_MovementItem_Reprice';
//  spGet := 'gpGet_MovementItem_Reprice';
end;

procedure TRepriceMovementItem.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TReprice.Create.GetDefault);
end;

function TRepriceMovementItem.InsertDefault: integer;
var Id, MovementId, GoodsId, UnitId: Integer;
    Amount, PriceOld, PriceNew: double;
    GUID: String;
    sp: TdsdStoredProc;
begin
  Id:=0;
  GoodsId := TGoods.Create.GetDefault;
  UnitId := TUnit.Create.GetDefault;
  Amount := 1;
  PriceOld := 1.0;
  PriceNew := 2.0;
  MovementId := TReprice.Create.GetDefault;
  sp := TdsdStoredProc.Create(nil);
  sp.StoredProcName := 'gpGet_Movement_Reprice';
  sp.OutputType := otResult;
  sp.Params.Clear;
  sp.Params.AddParam('inMovementId',ftInteger,ptInput,MovementId);
  sp.Params.AddParam('Id',ftInteger,ptOutput,Null);
  sp.Params.AddParam('InvNumber',ftString,ptOutput,Null);
  sp.Params.AddParam('OperDate',ftDateTime,ptOutput,Null);
  sp.Params.AddParam('TotalSumm',ftFloat,ptOutput,Null);
  sp.Params.AddParam('UnitId',ftInteger,ptOutput,Null);
  sp.Params.AddParam('UnitName',ftString,ptOutput,Null);
  sp.Params.AddParam('GUID',ftString,ptOutput,Null);
  sp.Execute;
  GUID := varToStr(sp.ParamByName('GUID').Value);
  result := InsertUpdateMovementItemReprice(Id, GoodsId, UnitId, Amount, PriceOld, PriceNew, GUID);
end;

function TRepriceMovementItem.InsertUpdateMovementItemReprice
  (Id, GoodsId, UnitId: Integer; Amount, PriceOld, PriceNew: double; GUID:String): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inPriceOld', ftFloat, ptInput, PriceOld);
  FParams.AddParam('inPriceNew', ftFloat, ptInput, PriceNew);
  FParams.AddParam('inGUID', ftString, ptInput, GUID);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('—троки ƒокументов', TRepriceMovementItemTest.Suite);

end.
