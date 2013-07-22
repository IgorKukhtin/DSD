unit PriceListItemTest;

interface

uses dbTest, dbObjectTest;

type

  TPriceListItemTest = class (TdbTest)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPriceListItem = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePriceListItem(const Id: integer; PriceListId, GoodsId: integer;
                 OperDate: TDateTime; Price: double): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils;

procedure TPriceListItemTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTHistory\_PriceListItem\';
  inherited;
end;

procedure TPriceListItemTest.Test;
var GoodsId, PriceListId: Integer;
    RecordCount: Integer;
    ObjectTest: TPriceListItem;
    Id_2012, Id_2013, Id_2011, Id_2011_06_06: Integer;
begin
(*  GoodsId := TGoodsTest.Create.GetDefault;
  PriceListId := TPriceListTest.Create.GetDefault;
  try
    ObjectTest := TPriceListItem.Create;
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
  end;*)
end;

{ TPriceListItemHistoryTest }

constructor TPriceListItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_ObjectHistory_PriceListItem';
  spSelect := 'gpSelect_ObjectHistory_PriceListItem';
  spGet := '';
end;

function TPriceListItem.InsertDefault: integer;
begin

end;

function TPriceListItem.InsertUpdatePriceListItem(const Id: integer;
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
  TestFramework.RegisterTest('Истории', TPriceListItemTest.Suite);

end.
