unit dbObjectHistoryTest;

interface

uses TestFramework, Authentication, Db, XMLIntf, dsdDB, dbObjectTest;

type

  TdbObjectHistoryTest = class (TTestCase)
  protected
    // Удаление объекта
    procedure DeleteHistoryObject(Id: integer);
    // получение поличества записей
    function GetRecordCount(ObjectTest: TObjectTest): integer;
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure PriceListItem_Test;
  end;

  TPriceListItemHistoryTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePriceListItem(const Id: integer; PriceListId, GoodsId: integer;
                 OperDate: TDateTime; Price: double): integer;
    constructor Create; override;
  end;

implementation

uses SysUtils;

{ TdbObjectHistoryTest }

procedure TdbObjectHistoryTest.DeleteHistoryObject(Id: integer);
begin

end;

function TdbObjectHistoryTest.GetRecordCount(ObjectTest: TObjectTest): integer;
begin

end;

procedure TdbObjectHistoryTest.PriceListItem_Test;
var GoodsId, PriceListId: Integer;
    RecordCount: Integer;
    ObjectTest: TPriceListItemHistoryTest;
begin
  GoodsId := TGoodsTest.Create.GetDefault;
  PriceListId := TPriceListTest.Create.GetDefault;

  ObjectTest := TPriceListItemHistoryTest.Create;

  ObjectTest.InsertUpdatePriceListItem(0, PriceListId, GoodsId, StrToDate('01.01.2012'), 10);
  // Добавляем историю с датой 01.01.2012
  // Добавляем историю с датой 01.01.2013
  // Добавляем историю с датой 01.01.2011
  // Добавляем историю с датой 06.06.2011
  // Удаляем историю с датой 06.06.2011
  // Удаляем историю с датой 01.01.2011
  // Удаляем историю с датой 01.01.2013
  // Удаляем историю с датой 01.01.2012
end;

procedure TdbObjectHistoryTest.SetUp;
begin
  inherited;

end;

procedure TdbObjectHistoryTest.TearDown;
begin
  inherited;

end;

{ TPriceListItemHistoryTest }

constructor TPriceListItemHistoryTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_ObjectHistory_PriceListItem';
  spSelect := 'gpSelect_ObjectHistory_PriceListItem';
  spGet := '';
end;

function TPriceListItemHistoryTest.InsertDefault: integer;
begin

end;

function TPriceListItemHistoryTest.InsertUpdatePriceListItem(const Id: integer;
  PriceListId, GoodsId: integer; OperDate: TDateTime; Price: double): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inPriceListId', ftInteger, ptInput, PriceListId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, OperDate);
  FParams.AddParam('inPrice', ftFloat, ptInput, Price);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Истории', TdbObjectHistoryTest.Suite);

end.
