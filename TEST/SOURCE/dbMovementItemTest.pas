unit dbMovementItemTest;

interface
uses TestFramework, dbObjectTest, DB, dbTest, Classes, ObjectTest;

type

  TdbMovementItemTest = class (TdbTest)
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
  published
    procedure MovementItemSendOnPriceTest;
    procedure MovementItemReturnOutTest;
    procedure MovementItemProductionUnionTest;
    procedure MovementItemZakazExternalTest;
    procedure MovementItemZakazInternalTest;
  end;

  TMovementItemProductionUnionMasterTest = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  public
    function GetDataSet: TDataSet; override;
    function InsertUpdateMovementProductionUnionMaster
      (Id, MovementId, GoodsId: Integer;
       Amount: double; PartionClose: Boolean;
       Count, RealWeight, CuterCount: double;  PartionGoods, Comment: String;
       GoodsKindId, ReceiptId: Integer): integer;
    constructor Create; override;
  end;

  TMovementItemProductionUnionChildTest = class(TMovementItemTest)
  private
    MovementItem_InId: INTEGER;
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function GetDataSet: TDataSet; override;
    function InsertUpdateMovementProductionUnionChild
      (Id, MovementId, GoodsId: Integer;
       Amount: double; ParentId: integer;
       AmountReceipt: double;  PartionGoodsDate: TDateTime;
       PartionGoods, Comment: string; GoodsKindId: integer): integer;
    constructor Create; override;
  end;

  TMovementItemSendOnPriceTest = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemSendOnPrice
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, AmountChangePercent, ChangePercentAmount, Price,
       CountForPrice, HeadCount: double;
       PartionGoods:String; GoodsKindId: Integer): integer;
    constructor Create; override;
  end;

  TMovementItemReturnOutTest = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemReturnOut
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, Price, CountForPrice, HeadCount: double;
       PartionGoods:String; GoodsKindId, AssetId: Integer): integer;
    constructor Create; override;
  end;

  TMovementItemZakazExternalTest = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemZakazExternal
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountSecond: double;
       GoodsKindId: Integer): integer;
    constructor Create; override;
  end;

  TMovementItemZakazInternalTest = class(TMovementItemTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemZakazInternal
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountSecond: double;
       GoodsKindId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses Storage, SysUtils, dbMovementTest, DBClient, dsdDB, CommonData, Authentication,
     dbObjectMeatTest, GoodsTest, GoodsKindTest, IncomeTest, ProductionUnionTest,
     SendOnPriceTest, ReturnOutTest;
{ TdbMovementItemTest }

{------------------------------------------------------------------------------}
procedure TdbMovementItemTest.MovementItemSendOnPriceTest;
var
  MovementItemSendOnPrice: TMovementItemSendOnPriceTest;
  Id: Integer;
begin
  MovementItemSendOnPrice := TMovementItemSendOnPriceTest.Create;
  Id := MovementItemSendOnPrice.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    MovementItemSendOnPrice.Delete(Id);
  end;
end;

procedure TdbMovementItemTest.MovementItemReturnOutTest;
var
  MovementItemReturnOut: TMovementItemReturnOutTest;
  Id: Integer;
begin
  MovementItemReturnOut := TMovementItemReturnOutTest.Create;
  Id := MovementItemReturnOut.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    MovementItemReturnOut.Delete(Id);
  end;
end;

procedure TdbMovementItemTest.MovementItemProductionUnionTest;
var
  MovementItemProductionUnionChild: TMovementItemProductionUnionChildTest;
  Id: Integer;
begin
  MovementItemProductionUnionChild := TMovementItemProductionUnionChildTest.Create;
  Id := MovementItemProductionUnionChild.InsertDefault;
  // создание документа
  MovementItemProductionUnionChild.GetDataSet;
  try
  // редактирование
  finally
    // удаление
    MovementItemProductionUnionChild.Delete(Id);
    MovementItemProductionUnionChild.Delete(MovementItemProductionUnionChild.MovementItem_InId);
  end;
end;

procedure TdbMovementItemTest.MovementItemZakazExternalTest;
var
  MovementItemZakazExternal: TMovementItemZakazExternalTest;
  Id: Integer;
begin
(*  MovementItemZakazExternal := TMovementItemZakazExternalTest.Create;
  Id := MovementItemZakazExternal.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    MovementItemZakazExternal.Delete(Id);
  end;  *)
end;

procedure TdbMovementItemTest.MovementItemZakazInternalTest;
var
  MovementItemZakazInternal: TMovementItemZakazInternalTest;
  Id: Integer;
begin
(*  MovementItemZakazInternal := TMovementItemZakazInternalTest.Create;
  Id := MovementItemZakazInternal.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    MovementItemZakazInternal.Delete(Id);
  end;     *)
end;

procedure TdbMovementItemTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

{ TMovementSSendOnPrice }
constructor TMovementItemSendOnPriceTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_SendOnPrice';
  spSelect := 'gpSelect_MovementItem_SendOnPrice';
  spGet := 'gpGet_MovementItem_SendOnPrice';
end;

function TMovementItemSendOnPriceTest.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountPartner, Price, CountForPrice, HeadCount,
    AmountChangePercent, ChangePercentAmount: double;
    PartionGoods:String;
    GoodsKindId: Integer;
begin
  Id := 0;
  MovementId := TSendOnPrice.Create.GetDefault;
  GoodsId := TGoods.Create.GetDefault;
  Amount := 10;
  AmountPartner := 11;
  Price := 2.34;
  CountForPrice := 1;
  HeadCount := 5;
  PartionGoods := '';
  GoodsKindId := 0;
  AmountChangePercent := 0;
  ChangePercentAmount := 0;
  //
  result := InsertUpdateMovementItemSendOnPrice(Id, MovementId, GoodsId,
                              Amount, AmountPartner, AmountChangePercent, ChangePercentAmount,
                              Price, CountForPrice, HeadCount,
                              PartionGoods, GoodsKindId);
end;

function TMovementItemSendOnPriceTest.InsertUpdateMovementItemSendOnPrice
  (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, AmountChangePercent, ChangePercentAmount, Price,
       CountForPrice, HeadCount: double;
       PartionGoods:String;GoodsKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inAmountPartner', ftFloat, ptInput, AmountPartner);
  FParams.AddParam('inAmountChangePercent', ftFloat, ptInput, AmountChangePercent);
  FParams.AddParam('inChangePercentAmount', ftFloat, ptInput, ChangePercentAmount);
  FParams.AddParam('inPrice', ftFloat, ptInput, Price);
  FParams.AddParam('inCountForPrice', ftFloat, ptInput, CountForPrice);
  FParams.AddParam('inHeadCount', ftFloat, ptInput, HeadCount);
  FParams.AddParam('inPartionGoods', ftString, ptInput, PartionGoods);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  result := InsertUpdate(FParams);
end;

procedure TMovementItemSendOnPriceTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TSendOnPrice.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
end;


{ TMovementReturnOut }
constructor TMovementItemReturnOutTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_ReturnOut';
  spSelect := 'gpSelect_MovementItem_ReturnOut';
  spGet := 'gpGet_MovementItem_ReturnOut';
end;

function TMovementItemReturnOutTest.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountPartner, Price, CountForPrice, HeadCount: double;
    PartionGoods:String;
    GoodsKindId, AssetId: Integer;
begin
  Id:=0;
  MovementId:= TReturnOut.Create.GetDefault;
  GoodsId:=TGoods.Create.GetDefault;
  Amount:=10;
  AmountPartner:=11;
  Price:=2.34;
  CountForPrice:=1;
  HeadCount:=5;
  PartionGoods:='';
  GoodsKindId:=0;
  AssetId:=0;
  //
  result := InsertUpdateMovementItemReturnOut(Id, MovementId, GoodsId,
                              Amount, AmountPartner, Price, CountForPrice, HeadCount,
                              PartionGoods, GoodsKindId, AssetId);
end;

function TMovementItemReturnOutTest.InsertUpdateMovementItemReturnOut
  (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, Price, CountForPrice, HeadCount: double;
       PartionGoods:String; GoodsKindId, AssetId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inAmountPartner', ftFloat, ptInput, AmountPartner);
  FParams.AddParam('inPrice', ftFloat, ptInput, Price);
  FParams.AddParam('inCountForPrice', ftFloat, ptInput, CountForPrice);
  FParams.AddParam('inHeadCount', ftFloat, ptInput, HeadCount);
  FParams.AddParam('inPartionGoods', ftString, ptInput, PartionGoods);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  FParams.AddParam('inAssetId', ftInteger, ptInput, AssetId);
  result := InsertUpdate(FParams);
end;

procedure TMovementItemReturnOutTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TReturnOut.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
end;


{ TMovementItemProductionUnionMasterTest }

constructor TMovementItemProductionUnionMasterTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MI_ProductionUnion_Master';
  spSelect := 'gpSelect_MI_ProductionUnion';
  spGet := '';
end;

function TMovementItemProductionUnionMasterTest.GetDataSet: TDataSet;
begin

end;

function TMovementItemProductionUnionMasterTest.InsertDefault: integer;
var MovementId, GoodsKindId, GoodsId: Integer;
begin
  MovementId := TIncome.Create.GetDefault;
  GoodsId := TGoods.Create.GetDefault;
  GoodsKindId:= TGoodsKind.Create.GetDefault;

  result := InsertUpdateMovementProductionUnionMaster(0, MovementId, GoodsId,
  10, false, 2.34, 505.67, 1, 'Партия', 'Партия', GoodsKindId, 0);
end;

function TMovementItemProductionUnionMasterTest.InsertUpdateMovementProductionUnionMaster(
  Id, MovementId, GoodsId: Integer; Amount: double; PartionClose: Boolean;
  Count, RealWeight, CuterCount: double; PartionGoods, Comment: String;
  GoodsKindId, ReceiptId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inPartionClose', ftBoolean, ptInput, PartionClose);
  FParams.AddParam('inCount', ftFloat, ptInput, Count);
  FParams.AddParam('inRealWeight', ftFloat, ptInput, RealWeight);
  FParams.AddParam('inCuterCount', ftFloat, ptInput, CuterCount);
  FParams.AddParam('inPartionGoods', ftString, ptInput, PartionGoods);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  FParams.AddParam('inReceiptId', ftInteger, ptInput, ReceiptId);
  result := InsertUpdate(FParams);
end;

{ TMovementItemProductionUnionChildTest }

constructor TMovementItemProductionUnionChildTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MI_ProductionUnion_Child';
  spSelect := 'gpSelect_MI_ProductionUnion';
  spGet := '';
end;

function TMovementItemProductionUnionChildTest.GetDataSet: TDataSet;
begin
  with FdsdStoredProc do begin
    if (DataSets.Count = 0) or not Assigned(DataSets[0].DataSet) then
       DataSets.Add.DataSet := TClientDataSet.Create(nil);
    if (DataSets.Count = 1) or not Assigned(DataSets[1].DataSet) then
       DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := spSelect;
    OutputType := otMultiDataSet;
    FParams.Clear;
    SetDataSetParam;
    Params.Assign(FParams);
    Execute;
    result := DataSets[1].DataSet;
  end;
end;

function TMovementItemProductionUnionChildTest.InsertDefault: integer;
var MovementId, GoodsId, GoodsKindId : Integer;
begin
  MovementId := TIncome.Create.GetDefault;
  GoodsId := TGoods.Create.GetDefault;
  MovementItem_InId := TMovementItemProductionUnionMasterTest.Create.GetDefault;
  GoodsKindId:= TGoodsKind.Create.GetDefault;

  result := InsertUpdateMovementProductionUnionChild(0, MovementId, GoodsId, 10,
  MovementItem_InId, 10, Date,'Партия', 'Comment', GoodsKindId);
end;

function TMovementItemProductionUnionChildTest.InsertUpdateMovementProductionUnionChild(
  Id, MovementId, GoodsId: Integer; Amount: double; ParentId: integer;
  AmountReceipt: double;  PartionGoodsDate: TDateTime; PartionGoods, Comment: string;
  GoodsKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  FParams.AddParam('inAmountReceipt', ftFloat, ptInput, AmountReceipt);
  FParams.AddParam('inPartionGoodsDate', ftDateTime, ptInput, PartionGoodsDate);
  FParams.AddParam('inPartionGoods', ftString, ptInput, PartionGoods);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  result := InsertUpdate(FParams);
end;

procedure TMovementItemProductionUnionChildTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TProductionUnion.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
end;


{ TMovementZakazExternal }
constructor TMovementItemZakazExternalTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_ZakazExternal';
  spSelect := 'gpSelect_MovementItem_ZakazExternal';
  spGet := 'gpGet_MovementItem_ZakazExternal';
end;

function TMovementItemZakazExternalTest.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountSecond: double;
    GoodsKindId: Integer;
begin
{  Id:=0;
  MovementId:= TMovementZakazExternalTest.Create.GetDefault;
  GoodsId:=TGoodsTest.Create.GetDefault;
  Amount:=10;
  AmountSecond:=11;
  GoodsKindId:=0;
  //
  result := InsertUpdateMovementItemZakazExternal(Id, MovementId, GoodsId,
                              Amount, AmountSecond, GoodsKindId);}
end;

function TMovementItemZakazExternalTest.InsertUpdateMovementItemZakazExternal
  (Id, MovementId, GoodsId: Integer;
       Amount, AmountSecond: double;
       GoodsKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inAmountSecond', ftFloat, ptInput, AmountSecond);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);

  result := InsertUpdate(FParams);
end;

procedure TMovementItemZakazExternalTest.SetDataSetParam;
begin
  inherited;
//  FParams.AddParam('inMovementId', ftInteger, ptInput, TMovementZakazExternalTest.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
end;

{ TMovementZakazInternal }
constructor TMovementItemZakazInternalTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_ZakazInternal';
  spSelect := 'gpSelect_MovementItem_ZakazInternal';
  spGet := 'gpGet_MovementItem_ZakazInternal';
end;

function TMovementItemZakazInternalTest.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountSecond: double;
    GoodsKindId: Integer;
begin
{  Id:=0;
  MovementId:= TMovementZakazInternalTest.Create.GetDefault;
  GoodsId:=TGoodsTest.Create.GetDefault;
  Amount:=10;
  AmountSecond:=11;
  GoodsKindId:=0;
  //
  result := InsertUpdateMovementItemZakazInternal(Id, MovementId, GoodsId,
                              Amount, AmountSecond, GoodsKindId);}
end;

function TMovementItemZakazInternalTest.InsertUpdateMovementItemZakazInternal
  (Id, MovementId, GoodsId: Integer;
       Amount, AmountSecond: double;
       GoodsKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inAmountSecond', ftFloat, ptInput, AmountSecond);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  result := InsertUpdate(FParams);
end;

procedure TMovementItemZakazInternalTest.SetDataSetParam;
begin
  inherited;
  //FParams.AddParam('inMovementId', ftInteger, ptInput, TMovementZakazInternalTest.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
end;

initialization

//  TestFramework.RegisterTest('Строки Документов', TdbMovementItemTest.Suite);

end.
