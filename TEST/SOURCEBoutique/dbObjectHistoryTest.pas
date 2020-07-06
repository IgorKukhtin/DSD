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

uses SysUtils, Storage;

{ TdbObjectHistoryTest }

procedure TdbObjectHistoryTest.DeleteHistoryObject(Id: integer);
const
   pXML =
  '<xml Session = "">' +
    '<lpDelete_ObjectHistory OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</lpDelete_ObjectHistory>' +
  '</xml>';
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]))
end;

function TdbObjectHistoryTest.GetRecordCount(ObjectTest: TObjectTest): integer;
begin

end;

procedure TdbObjectHistoryTest.PriceListItem_Test;
var GoodsId, PriceListId: Integer;
    RecordCount: Integer;
    ObjectTest: TPriceListItemHistoryTest;
    Id_2012, Id_2013, Id_2011, Id_2011_06_06: Integer;
begin
  GoodsId := TGoodsTest.Create.GetDefault;
  PriceListId := TPriceListTest.Create.GetDefault;
  try
    ObjectTest := TPriceListItemHistoryTest.Create;
    // Добавляем историю с датой 01.01.2012
    Id_2012 := ObjectTest.InsertUpdatePriceListItem(0, PriceListId, GoodsId, StrToDate('01.01.2012'), 2012);
    // Добавляем историю с датой 01.01.2013
    Id_2013 := ObjectTest.InsertUpdatePriceListItem(0, PriceListId, GoodsId, StrToDate('01.01.2013'), 2013);
    // Добавляем историю с датой 01.01.2011
    Id_2011 := ObjectTest.InsertUpdatePriceListItem(0, PriceListId, GoodsId, StrToDate('01.01.2011'), 2011);
    // Добавляем историю с датой 06.06.2011
    Id_2011_06_06 := ObjectTest.InsertUpdatePriceListItem(0, PriceListId, GoodsId, StrToDate('06.06.2011'), 201106);

    // Изменяем историю с датой 01.01.2012 на 01.01.2010
    ObjectTest.InsertUpdatePriceListItem(Id_2012, PriceListId, GoodsId, StrToDate('01.01.2010'), 2012);
    // Изменяем историю с датой 01.01.2010 на 01.01.2020
    ObjectTest.InsertUpdatePriceListItem(Id_2012, PriceListId, GoodsId, StrToDate('01.01.2020'), 2012);
    // Изменяем историю с датой 01.01.2020 на 01.01.2012
    ObjectTest.InsertUpdatePriceListItem(Id_2012, PriceListId, GoodsId, StrToDate('01.01.2012'), 2012);

    // Удаляем историю с датой 06.06.2011
    DeleteHistoryObject(Id_2011_06_06);
    // Удаляем историю с датой 01.01.2011
    DeleteHistoryObject(Id_2011);
    // Удаляем историю с датой 01.01.2013
    DeleteHistoryObject(Id_2013);
    // Удаляем историю с датой 01.01.2012
    DeleteHistoryObject(Id_2012);
  finally
    with TGoodsTest.Create do
      try
        Delete(GetDefault);
      finally
        Free
      end;
    with TPriceListTest.Create do
      try
        Delete(GetDefault);
      finally
        Free
      end;
  end;
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
//  TestFramework.RegisterTest('Истории', TdbObjectHistoryTest.Suite);

end.
