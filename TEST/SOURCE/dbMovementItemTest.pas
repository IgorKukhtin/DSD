unit dbMovementItemTest;

interface
uses TestFramework, dbObjectTest, DB;

type

  TdbMovementItemTest = class (TTestCase)
  private
    // Удаление документа
    procedure DeleteMovementItem(Id: integer);
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure MovementItemIncomeTest;
    procedure MovementItemSendOnPriceTest;
    procedure MovementItemSaleTest;
    procedure MovementItemReturnOutTest;
    procedure MovementItemProductionUnionTest;
  end;

  TMovementItemIncomeTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
    procedure Delete(Id: Integer); override;
  public
    function InsertUpdateMovementItemIncome
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, AmountPacker, Price, CountForPrice, LiveWeight, HeadCount: double;
       PartionGoods:String;GoodsKindId,AssetId: Integer): integer;
    constructor Create; override;
  end;

  TMovementItemProductionUnionMasterTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
    procedure Delete(Id: Integer); override;
  public
    function GetDataSet: TDataSet; override;
    function InsertUpdateMovementProductionUnionMaster
      (Id, MovementId, GoodsId: Integer;
       Amount: double; PartionClose: Boolean; Comment: String;
       Count, RealWeight, CuterCount: double;
       ReceiptId: Integer): integer;
    constructor Create; override;
  end;

  TMovementItemProductionUnionChildTest = class(TObjectTest)
  private
    MovementItem_InId: INTEGER;
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
    procedure Delete(Id: Integer); override;
  public
    function GetDataSet: TDataSet; override;
    function InsertUpdateMovementProductionUnionChild
      (Id, MovementId, GoodsId: Integer;
       Amount: double; ParentId: integer;
       AmountReceipt: double; Comment: string): integer;
    constructor Create; override;
  end;

  TMovementItemSendOnPriceTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
    procedure Delete(Id: Integer); override;
  public
    function InsertUpdateMovementItemSendOnPrice
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, Price, CountForPrice, HeadCount: double;
       PartionGoods:String; GoodsKindId: Integer): integer;
    constructor Create; override;
  end;

  TMovementItemSaleTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
    procedure Delete(Id: Integer); override;
  public
    function InsertUpdateMovementItemSale
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, Price, CountForPrice, HeadCount: double;
       PartionGoods:String; GoodsKindId: Integer): integer;
    constructor Create; override;
  end;

  TMovementItemReturnOutTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
    procedure Delete(Id: Integer); override;
  public
    function InsertUpdateMovementItemReturnOut
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, Price, CountForPrice, HeadCount: double;
       PartionGoods:String; GoodsKindId: Integer): integer;
    constructor Create; override;
  end;
implementation

uses Storage, SysUtils, dbMovementTest, DBClient, dsdDB;
{ TdbMovementItemTest }
{------------------------------------------------------------------------------}
procedure TdbMovementItemTest.TearDown;
begin
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TdbMovementItemTest.DeleteMovementItem(Id: integer);
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
{------------------------------------------------------------------------------}
procedure TdbMovementItemTest.MovementItemIncomeTest;
var
  MovementItemIncome: TMovementItemIncomeTest;
  Id: Integer;
begin
  MovementItemIncome := TMovementItemIncomeTest.Create;
  Id := MovementItemIncome.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovementItem(Id);
    MovementItemIncome.Delete(Id);
  end;
end;

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
    DeleteMovementItem(Id);
    MovementItemSendOnPrice.Delete(Id);
  end;
end;

procedure TdbMovementItemTest.MovementItemSaleTest;
var
  MovementItemSale: TMovementItemSaleTest;
  Id: Integer;
begin
  MovementItemSale := TMovementItemSaleTest.Create;
  Id := MovementItemSale.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    // удаление
    DeleteMovementItem(Id);
    MovementItemSale.Delete(Id);
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
    DeleteMovementItem(Id);
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
    DeleteMovementItem(Id);
    DeleteMovementItem(MovementItemProductionUnionChild.MovementItem_InId);
    MovementItemProductionUnionChild.Delete(Id);
  end;
end;

procedure TdbMovementItemTest.SetUp;
begin
  inherited;
end;
{------------------------------------------------------------------------------}
{ TMovementIncome }

constructor TMovementItemIncomeTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_Income';
  spSelect := 'gpSelect_MovementItem_Income';
  spGet := 'gpGet_MovementItem_Income';
end;

procedure TMovementItemIncomeTest.Delete(Id: Integer);
begin
  with TGoodsTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TMovementItemIncomeTest.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountPartner, AmountPacker, Price, CountForPrice, LiveWeight, HeadCount: double;
    PartionGoods:String;
    GoodsKindId,AssetId: Integer;
begin
  Id:=0;
  MovementId:= TMovementIncomeTest.Create.GetDefault;
  GoodsId:=TGoodsTest.Create.GetDefault;
  Amount:=10;
  AmountPartner:=11;
  AmountPacker:=12;
  Price:=2.34;
  CountForPrice:=1;
  LiveWeight:=505.67;
  HeadCount:=5;
  PartionGoods:='';
  GoodsKindId:=0;
  AssetId:=0;
  //
  result := InsertUpdateMovementItemIncome(Id, MovementId, GoodsId,
                                           Amount, AmountPartner, AmountPacker, Price, CountForPrice, LiveWeight, HeadCount,
                                           PartionGoods,
                                           GoodsKindId,AssetId);
end;

function TMovementItemIncomeTest.InsertUpdateMovementItemIncome
  (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, AmountPacker, Price, CountForPrice, LiveWeight, HeadCount: double;
       PartionGoods:String;GoodsKindId,AssetId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
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

procedure TMovementItemIncomeTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TMovementIncomeTest.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
end;

{ TMovementSSendOnPrice }
constructor TMovementItemSendOnPriceTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_SendOnPrice';
  spSelect := 'gpSelect_MovementItem_SendOnPrice';
  spGet := 'gpGet_MovementItem_SendOnPrice';
end;

procedure TMovementItemSendOnPriceTest.Delete(Id: Integer);
begin
  with TGoodsTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TMovementItemSendOnPriceTest.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountPartner, Price, CountForPrice, HeadCount: double;
    PartionGoods:String;
    GoodsKindId: Integer;
begin
  Id:=0;
  MovementId:= TMovementSendOnPriceTest.Create.GetDefault;
  GoodsId:=TGoodsTest.Create.GetDefault;
  Amount:=10;
  AmountPartner:=11;
  Price:=2.34;
  CountForPrice:=1;
  HeadCount:=5;
  PartionGoods:='';
  GoodsKindId:=0;
  //
  result := InsertUpdateMovementItemSendOnPrice(Id, MovementId, GoodsId,
                              Amount, AmountPartner, Price, CountForPrice, HeadCount,
                              PartionGoods, GoodsKindId);
end;

function TMovementItemSendOnPriceTest.InsertUpdateMovementItemSendOnPrice
  (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, Price, CountForPrice, HeadCount: double;
       PartionGoods:String;GoodsKindId: Integer): integer;
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
  result := InsertUpdate(FParams);
end;

procedure TMovementItemSendOnPriceTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TMovementSendOnPriceTest.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
end;

{ TMovementSale }
constructor TMovementItemSaleTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_Sale';
  spSelect := 'gpSelect_MovementItem_Sale';
  spGet := 'gpGet_MovementItem_Sale';
end;

procedure TMovementItemSaleTest.Delete(Id: Integer);
begin
  with TGoodsTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TMovementItemSaleTest.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountPartner, Price, CountForPrice, HeadCount: double;
    PartionGoods:String;
    GoodsKindId: Integer;
begin
  Id:=0;
  MovementId:= TMovementSaleTest.Create.GetDefault;
  GoodsId:=TGoodsTest.Create.GetDefault;
  Amount:=10;
  AmountPartner:=11;
  Price:=2.34;
  CountForPrice:=1;
  HeadCount:=5;
  PartionGoods:='';
  GoodsKindId:=0;
  //
  result := InsertUpdateMovementItemSale(Id, MovementId, GoodsId,
                              Amount, AmountPartner, Price, CountForPrice, HeadCount,
                              PartionGoods, GoodsKindId);
end;

function TMovementItemSaleTest.InsertUpdateMovementItemSale
  (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, Price, CountForPrice, HeadCount: double;
       PartionGoods:String;GoodsKindId: Integer): integer;
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
  result := InsertUpdate(FParams);
end;

procedure TMovementItemSaleTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TMovementSaleTest.Create.GetDefault);
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

procedure TMovementItemReturnOutTest.Delete(Id: Integer);
begin
  with TGoodsTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TMovementItemReturnOutTest.InsertDefault: integer;
var Id, MovementId, GoodsId: Integer;
    Amount, AmountPartner, Price, CountForPrice, HeadCount: double;
    PartionGoods:String;
    GoodsKindId: Integer;
begin
  Id:=0;
  MovementId:= TMovementReturnOutTest.Create.GetDefault;
  GoodsId:=TGoodsTest.Create.GetDefault;
  Amount:=10;
  AmountPartner:=11;
  Price:=2.34;
  CountForPrice:=1;
  HeadCount:=5;
  PartionGoods:='';
  GoodsKindId:=0;
  //
  result := InsertUpdateMovementItemReturnOut(Id, MovementId, GoodsId,
                              Amount, AmountPartner, Price, CountForPrice, HeadCount,
                              PartionGoods, GoodsKindId);
end;

function TMovementItemReturnOutTest.InsertUpdateMovementItemReturnOut
  (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, Price, CountForPrice, HeadCount: double;
       PartionGoods:String;GoodsKindId: Integer): integer;
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
  result := InsertUpdate(FParams);
end;

procedure TMovementItemReturnOutTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TMovementReturnOutTest.Create.GetDefault);
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

procedure TMovementItemProductionUnionMasterTest.Delete(Id: Integer);
begin
  with TGoodsTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TMovementItemProductionUnionMasterTest.GetDataSet: TDataSet;
begin

end;

function TMovementItemProductionUnionMasterTest.InsertDefault: integer;
var MovementId, GoodsId: Integer;
begin
  MovementId := TMovementIncomeTest.Create.GetDefault;
  GoodsId := TGoodsTest.Create.GetDefault;

  result := InsertUpdateMovementProductionUnionMaster(0, MovementId, GoodsId,
  10, false, 'Партия', 2.34, 505.67, 1, 0);
end;

function TMovementItemProductionUnionMasterTest.InsertUpdateMovementProductionUnionMaster(
  Id, MovementId, GoodsId: Integer; Amount: double; PartionClose: Boolean;
  Comment: String; Count, RealWeight, CuterCount: double;
  ReceiptId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inPartionClose', ftBoolean, ptInput, PartionClose);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  FParams.AddParam('inCount', ftFloat, ptInput, Count);
  FParams.AddParam('inRealWeight', ftFloat, ptInput, RealWeight);
  FParams.AddParam('inCuterCount', ftFloat, ptInput, CuterCount);
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

procedure TMovementItemProductionUnionChildTest.Delete(Id: Integer);
begin
  with TGoodsTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
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
var MovementId, GoodsId: Integer;
begin
  MovementId := TMovementIncomeTest.Create.GetDefault;
  GoodsId := TGoodsTest.Create.GetDefault;
  MovementItem_InId := TMovementItemProductionUnionMasterTest.Create.GetDefault;

  result := InsertUpdateMovementProductionUnionChild(0, MovementId, GoodsId, 10,
  MovementItem_InId, 10, 'Comment');
end;

function TMovementItemProductionUnionChildTest.InsertUpdateMovementProductionUnionChild(
  Id, MovementId, GoodsId: Integer; Amount: double; ParentId: integer;
  AmountReceipt: double; Comment: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  FParams.AddParam('inAmountReceipt', ftFloat, ptInput, AmountReceipt);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  result := InsertUpdate(FParams);
end;

procedure TMovementItemProductionUnionChildTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TMovementProductionUnionTest.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
end;

initialization
  TestFramework.RegisterTest('Строки Документов', TdbMovementItemTest.Suite);

end.
