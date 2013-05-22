unit dbMovementItemTest;

interface
uses TestFramework, dbObjectTest, DB;

type

  TdbMovementItemTest = class (TTestCase)
  private
    // ”даление документа
    procedure DeleteMovementItem(Id: integer);
  protected
    // подготавливаем данные дл€ тестировани€
    procedure SetUp; override;
    // возвращаем данные дл€ тестировани€
    procedure TearDown; override;
  published
    procedure MovementItemIncomeTest;
    procedure MovementItemProductionUnionTest;
  end;

  TMovementItemIncomeTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function InsertUpdateMovementItemIncome
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, Price, CountForPrice, LiveWeight, HeadCount: double;
       GoodsKindId: Integer): integer;
    constructor Create; override;
  end;

  TMovementItemProductionUnionInTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function GetDataSet: TDataSet; override;
    function InsertUpdateMovementProductionUnionIn
      (Id, MovementId, GoodsId: Integer;
       Amount: double; PartionClose: Boolean; Comment: String;
       Count, RealWeight, CuterCount: double;
       ReceiptId: Integer): integer;
    constructor Create; override;
  end;

  TMovementItemProductionUnionOutTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  protected
    procedure SetDataSetParam; override;
  public
    function GetDataSet: TDataSet; override;
    function InsertUpdateMovementProductionUnionOut
      (Id, MovementId, GoodsId: Integer;
       Amount: double; ParentId: integer;
       AmountReceipt: double; Comment: string): integer;
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
  end;
end;

procedure TdbMovementItemTest.MovementItemProductionUnionTest;
var
  MovementItemProductionUnionOut: TMovementItemProductionUnionOutTest;
  Id: Integer;
begin
  MovementItemProductionUnionOut := TMovementItemProductionUnionOutTest.Create;
  Id := MovementItemProductionUnionOut.InsertDefault;
  // создание документа
  MovementItemProductionUnionOut.GetDataSet;
  try
  // редактирование
  finally
    // удаление
    DeleteMovementItem(Id);
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

function TMovementItemIncomeTest.InsertDefault: integer;
var MovementId, GoodsId: Integer;
begin
  MovementId := TMovementIncomeTest.Create.GetDefault;
  GoodsId := TGoodsTest.Create.GetDefault;

  result := InsertUpdateMovementItemIncome(0, MovementId, GoodsId,
  10, 11, 2.34, 1, 505.67, 5, 0);
end;

function TMovementItemIncomeTest.InsertUpdateMovementItemIncome
  (Id, MovementId, GoodsId: Integer;
  Amount, AmountPartner, Price, CountForPrice, LiveWeight, HeadCount: double;
  GoodsKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inMovementId', ftInteger, ptInput, MovementId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inAmountPartner', ftFloat, ptInput, AmountPartner);
  FParams.AddParam('inPrice', ftFloat, ptInput, Price);
  FParams.AddParam('inCountForPrice', ftFloat, ptInput, CountForPrice);
  FParams.AddParam('inLiveWeight', ftFloat, ptInput, LiveWeight);
  FParams.AddParam('inHeadCount', ftFloat, ptInput, HeadCount);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  result := InsertUpdate(FParams);
end;

procedure TMovementItemIncomeTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TMovementIncomeTest.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
end;

{ TMovementItemProductionUnionInTest }

constructor TMovementItemProductionUnionInTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_In';
  spSelect := 'gpSelect_MovementItem_ProductionUnion';
  spGet := '';
end;

function TMovementItemProductionUnionInTest.GetDataSet: TDataSet;
begin

end;

function TMovementItemProductionUnionInTest.InsertDefault: integer;
var MovementId, GoodsId: Integer;
begin
  MovementId := TMovementIncomeTest.Create.GetDefault;
  GoodsId := TGoodsTest.Create.GetDefault;

  result := InsertUpdateMovementProductionUnionIn(0, MovementId, GoodsId,
  10, false, 'ѕарти€', 2.34, 505.67, 1, 0);
end;

function TMovementItemProductionUnionInTest.InsertUpdateMovementProductionUnionIn(
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

{ TMovementItemProductionUnionOutTest }

constructor TMovementItemProductionUnionOutTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_MovementItem_Out';
  spSelect := 'gpSelect_MovementItem_ProductionUnion';
  spGet := '';
end;

function TMovementItemProductionUnionOutTest.GetDataSet: TDataSet;
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

function TMovementItemProductionUnionOutTest.InsertDefault: integer;
var MovementId, GoodsId, MovementItem_InId: Integer;
begin
  MovementId := TMovementIncomeTest.Create.GetDefault;
  GoodsId := TGoodsTest.Create.GetDefault;
  MovementItem_InId := TMovementItemProductionUnionInTest.Create.GetDefault;

  result := InsertUpdateMovementProductionUnionOut(0, MovementId, GoodsId, 10,
  MovementItem_InId, 10, 'Comment');
end;

function TMovementItemProductionUnionOutTest.InsertUpdateMovementProductionUnionOut(
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

procedure TMovementItemProductionUnionOutTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inMovementId', ftInteger, ptInput, TMovementProductionUnionTest.Create.GetDefault);
  FParams.AddParam('inShowAll', ftBoolean, ptInput, true);
end;

initialization
  TestFramework.RegisterTest('—троки ƒокументов', TdbMovementItemTest.Suite);

end.
