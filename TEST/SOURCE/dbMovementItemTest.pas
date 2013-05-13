unit dbMovementItemTest;

interface
uses TestFramework, dbObjectTest;

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
  end;

  TMovementItemIncomeTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateMovementItemIncome
      (Id, MovementId, GoodsId: Integer;
       Amount, AmountPartner, Price, CountForPrice, LiveWeight, HeadCount: double;
       GoodsKindId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses DB, Storage, SysUtils, dbMovementTest;
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

initialization
  TestFramework.RegisterTest('—троки ƒокументов', TdbMovementItemTest.Suite);

end.

end.
