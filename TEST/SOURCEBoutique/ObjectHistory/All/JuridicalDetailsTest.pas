unit JuridicalDetailsTest;
interface

uses dbTest, dbObjectTest, SysUtils, Classes;

type

  TJuridicalDetailsTest = class (TdbTest)
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
//    procedure TearDown; override;
  published
    procedure ProcedureLoad; override;
  end;


(*  TJuridicalDetails = class(TObjectTest)
  private
    function InsertDefault: integer; override;
    procedure DeleteRecord(Id: Integer); override;
    procedure InsertUpdateInList(Id: integer); override;
  public
    function InsertUpdatePriceListItem(const Id: integer; PriceListId, GoodsId: integer;
                 OperDate: TDateTime; Price: double): integer;
    constructor Create; override;
    procedure Delete(Id: Integer); override;
  end;

  *)

implementation

uses DB, UtilConst, TestFramework, Authentication, CommonData, Storage,
   dbMovementItemTest, dbMovementTest;

procedure TJuridicalDetailsTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTHistory\JuridicalDetails\';
  inherited;
end;

procedure TJuridicalDetailsTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

(*procedure TJuridicalDetailsTest.TearDown;
begin
  inherited;
  if Assigned(InsertedIdObjectHistoryList) then
     with TPriceListItem.Create do
       while InsertedIdObjectHistoryList.Count > 0 do
          Delete(StrToInt(InsertedIdObjectHistoryList[0]));

  if Assigned(InsertedIdMovementItemList) then
     with TMovementItemTest.Create do
       while InsertedIdMovementItemList.Count > 0 do
          Delete(StrToInt(InsertedIdMovementItemList[0]));

  if Assigned(InsertedIdMovementList) then
     with TMovementTest.Create do
       while InsertedIdMovementList.Count > 0 do
          Delete(StrToInt(InsertedIdMovementList[0]));

  if Assigned(InsertedIdObjectList) then
     with TObjectTest.Create do
       while InsertedIdObjectList.Count > 0 do
          Delete(StrToInt(InsertedIdObjectList[0]));}
end;

procedure TPriceListItemTest.Test;
var GoodsId, PriceListId: Integer;
    RecordCount: Integer;
    ObjectTest: TPriceListItem;
    Id_2012, Id_2013, Id_2011, Id_2011_06_06: Integer;
begin
  GoodsId := TGoodsTest.Create.GetDefault;
  PriceListId := TPriceListTest.Create.GetDefault;
  try
    ObjectTest := TPriceListItem.Create;
    // Добавляем историю с датой 01.01.2012
    Id_2012 := ObjectTest.InsertUpdatePriceListItem(0, PriceListId, GoodsId, StrToDate('01.01.2012'), 2012);
    // Добавляем историю с датой 01.01.2013
    Id_2013 := ObjectTest.InsertUpdatePriceListItem(0, PriceListId, GoodsId, StrToDate('01.01.2013'), 2013);
    ObjectTest.InsertUpdatePriceListItem(0, PriceListId, GoodsId, StrToDate('01.01.2014'), 2014);
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
    ObjectTest.Delete(Id_2011_06_06);
    // Удаляем историю с датой 01.01.2011
    ObjectTest.Delete(Id_2011);
    // Удаляем историю с датой 01.01.2013
    ObjectTest.Delete(Id_2013);
    // Удаляем историю с датой 01.01.2012
    ObjectTest.Delete(Id_2012);
  finally
  end;
end;

{ TPriceListItemHistoryTest }

constructor TPriceListItem.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_ObjectHistory_PriceListItem';
  spSelect := 'gpSelect_ObjectHistory_PriceListItem';
  spGet := '';
end;

procedure TPriceListItem.Delete(Id: Integer);
var Index: Integer;
begin
  if InsertedIdObjectHistoryList.Find(IntToStr(Id), Index) then begin
     // здесь мы разрешаем удалять ТОЛЬКО вставленные в момент теста данные
     DeleteRecord(Id);
     InsertedIdObjectHistoryList.Delete(Index);
  end
  else
     raise Exception.Create('Попытка удалить запись, вставленную вне теста!!!');
end;

procedure TPriceListItem.DeleteRecord(Id: Integer);
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

function TPriceListItem.InsertDefault: integer;
begin

end;

procedure TPriceListItem.InsertUpdateInList(Id: integer);
begin
  InsertedIdObjectHistoryList.Add(IntToStr(Id));
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
  *)
initialization

  TestFramework.RegisterTest('Истории', TJuridicalDetailsTest.Suite);

end.
