unit dbObjectMeatTest;

interface
uses dbObjectTest, Classes, TestFramework, Authentication, Db, XMLIntf, dsdDB, dbTest, ObjectTest;

type

  TdbObjectTest = class (TdbTest)
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;

    function GetRecordCount(ObjectTest: TObjectTest): integer;

  published
//    procedure DocumentTaxKind_Test;
   end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, ZLibEx, zLibUtil,UnitsTest, JuridicalTest, BusinessTest,
     GoodsTest, GoodsKindTest;


{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
function TdbObjectTest.GetRecordCount(ObjectTest: TObjectTest): integer;
begin
  Result := ObjectTest.GetDataSet.RecordCount;
end;
{------------------------------------------------------------------------------}



{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
procedure TdbObjectTest.TearDown;
begin
  inherited;
  if Assigned(InsertedIdObjectList) then
     with TObjectTest.Create do
       while InsertedIdObjectList.Count > 0 do begin
          DeleteRecord(StrToInt(InsertedIdObjectList[0]));
          InsertedIdObjectList.Delete(0);
       end;
end;
{------------------------------------------------------------------------------}
procedure TdbObjectTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;
{------------------------------------------------------------------------------}



{ TDataBaseUsersObjectTest }





{=================}
{TTaxKindTest}
{
constructor TTaxKindTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_DocumentTaxKind';
  spSelect := 'gpSelect_Object_DocumentTaxKind';
  spGet := 'gpGet_Object_DocumentTaxKind';
end;

function TTaxKindTest.InsertDefault: integer;
begin
  result := InsertUpdateDocumentTaxKind(0, -3, 'Тип формирования налогового документа');
  inherited;
end;

function TTaxKindTest.InsertUpdateDocumentTaxKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.DocumentTaxKind_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TDocumentTaxKindTest;
begin
  ObjectTest := TDocumentTaxKindTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Тип формирования налогового документа'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;
}
{==================================}


(*
 
procedure TdbObjectTest.Position_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPositionTest;
begin
  ObjectTest := TPositionTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка группы
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Должности'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TAssetGroupTest}
constructor TAssetGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_AssetGroup';
  spSelect := 'gpSelect_Object_AssetGroup';
  spGet := 'gpGet_Object_AssetGroup';
end;

function TAssetGroupTest.InsertDefault: integer;
var
  ParentId: Integer;
begin
  ParentId:=0;
  result := InsertUpdateAssetGroup(0, -1, 'Группа основных средств', ParentId);
end;

function TAssetGroupTest.InsertUpdateAssetGroup;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.AssetGroup_Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TAssetGroupTest;
begin
 // тут наша задача проверить правильность работы с деревом.
 // а именно зацикливание.
  ObjectTest := TAssetGroupTest.Create;
  // Получим список объектов
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка объекта
 // добавляем группу 1
  Id := ObjectTest.InsertDefault;
  try
    // теперь делаем ссылку на себя и проверяем ошибку
    try
      ObjectTest.InsertUpdateAssetGroup(Id, -1, 'Тест Группа 1', Id);
      Check(false, 'Нет сообщение об ошибке');
    except

    end;
    // добавляем еще группу 2
    // делаем у группы 2 ссылку на группу 1
    Id2 := ObjectTest.InsertUpdateAssetGroup(0, -2, 'Тест Группа 2', Id);
    try
      // теперь ставим ссылку у группы 1 на группу 2 и проверяем ошибку
      try
        ObjectTest.InsertUpdateAssetGroup(Id, -1, 'Тест Группа 1', Id2);
        Check(false, 'Нет сообщение об ошибке');
      except

      end;
      // добавляем еще группу 3
      // делаем у группы 3 ссылку на группу 2
      Id3 := ObjectTest.InsertUpdateAssetGroup(0, -3, 'Тест Группа 3', Id2);
      try
        // группа 2 уже ссылка на группу 1
        // делаем у группы 1 ссылку на группу 3 и проверяем ошибку
        try
          ObjectTest.InsertUpdateAssetGroup(Id, -1, 'Тест Группа 1', Id3);
          Check(false, 'Нет сообщение об ошибке');
        except

        end;
        Check((GetRecordCount(ObjectTest) = RecordCount + 3), 'Количество записей не изменилось');
      finally
        ObjectTest.Delete(Id3);
      end;
    finally
      ObjectTest.Delete(Id2);
    end;
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TAssetTest}
constructor TAssetTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Asset';
  spSelect := 'gpSelect_Object_Asset';
  spGet := 'gpGet_Object_Asset';
end;

function TAssetTest.InsertDefault: integer;
var
  AssetGroupId: Integer;
  JuridicalId: Integer;
  MakerId: Integer;
begin
  AssetGroupId := TAssetGroupTest.Create.GetDefault;
  JuridicalId:=0;
  MakerId:=0;
  result := InsertUpdateAsset(0, -1, 'Основные средства', date, 'InvNumber', 'FullName', 'SerialNumber'
                            , 'PassportNumber', 'Comment', AssetGroupId,JuridicalId,MakerId);
end;

function TAssetTest.InsertUpdateAsset;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('Release', ftDateTime, ptInput, Release);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inFullName', ftString, ptInput, FullName);
  FParams.AddParam('inSerialNumber', ftString, ptInput, SerialNumber);
  FParams.AddParam('inPassportNumber', ftString, ptInput, PassportNumber);
  FParams.AddParam('inComment', ftString, ptInput, Comment);

  FParams.AddParam('inAssetGroupId', ftInteger, ptInput, AssetGroupId);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inMakerId', ftInteger, ptInput, MakerId);

  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Asset_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAssetTest;
begin
  ObjectTest := TAssetTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка объекта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Основные средства'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TReceiptCostTest}
constructor TReceiptCostTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ReceiptCost';
  spSelect := 'gpSelect_Object_ReceiptCost';
  spGet := 'gpGet_Object_ReceiptCost';
end;

function TReceiptCostTest.InsertDefault: integer;
begin
   result := InsertUpdateReceiptCost(0, -1, 'Затраты в рецептурах');
end;

function TReceiptCostTest.InsertUpdateReceiptCost;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ReceiptCost_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReceiptCostTest;
begin
  ObjectTest := TReceiptCostTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка объекта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Затраты в рецептурах'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

 {TReceiptChildTest}
 constructor TReceiptChildTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ReceiptChild';
  spSelect := 'gpSelect_Object_ReceiptChild';
  spGet := 'gpGet_Object_ReceiptChild';
end;

function TReceiptChildTest.InsertDefault: integer;
var
  GoodsId, GoodsKindId: Integer;
begin
  GoodsId:= TGoods.Create.GetDefault;
  GoodsKindId:= TGoodsKind.Create.GetDefault;

  result := InsertUpdateReceiptChild(0, 123,true, true, date, date, 'Составляющие рецептур - Значение', 2, GoodsId, GoodsKindId);
end;

function TReceiptChildTest.InsertUpdateReceiptChild;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('Value', ftFloat, ptInput, Value);
  FParams.AddParam('Weight', ftBoolean, ptInput, Weight);
  FParams.AddParam('TaxExit', ftBoolean, ptInput, TaxExit);
  FParams.AddParam('StartDate', ftDateTime, ptInput, StartDate);
  FParams.AddParam('EndDate', ftDateTime, ptInput, EndDate);
  FParams.AddParam('Comment', ftString, ptInput, Comment);
  FParams.AddParam('inReceiptId', ftInteger, ptInput, ReceiptId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ReceiptChild_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReceiptChildTest;
begin
  ObjectTest := TReceiptChildTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Составляющие рецептур
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Comment').AsString = 'Составляющие рецептур - Значение'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


 {TReceiptTest}
 constructor TReceiptTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Receipt';
  spSelect := 'gpSelect_Object_Receipt';
  spGet := 'gpGet_Object_Receipt';
end;

function TReceiptTest.InsertDefault: integer;
var
  GoodsId, GoodsKindId, ReceiptCostId: Integer;
begin
  ReceiptCostId := TReceiptCostTest.Create.GetDefault;
  GoodsId:= TGoods.Create.GetDefault;
  GoodsKindId:= TGoodsKind.Create.GetDefault;

  result := InsertUpdateReceipt(0, 'Рецептура 1', '123', 'Рецептуры', 1, 2, 80, 2, 1,1 , date, date, true, GoodsId, GoodsKindId, 1, ReceiptCostId, 1);
end;

function TReceiptTest.InsertUpdateReceipt;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('Name', ftString, ptInput, Name);
  FParams.AddParam('Code', ftString, ptInput, Code);
  FParams.AddParam('Comment', ftString, ptInput, Comment);
  FParams.AddParam('Value', ftFloat, ptInput, Value);
  FParams.AddParam('ValueCost', ftFloat, ptInput, ValueCost);
  FParams.AddParam('TaxExit', ftFloat, ptInput, TaxExit);
  FParams.AddParam('PartionValue', ftFloat, ptInput, PartionValue);
  FParams.AddParam('PartionCount', ftFloat, ptInput, PartionCount);
  FParams.AddParam('WeightPackage', ftFloat, ptInput, WeightPackage);
  FParams.AddParam('StartDate', ftDateTime, ptInput, StartDate);
  FParams.AddParam('EndDate', ftDateTime, ptInput, EndDate);
  FParams.AddParam('Main', ftBoolean, ptInput, Main);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  FParams.AddParam('inGoodsKindCompleteId', ftInteger, ptInput, GoodsKindCompleteId);
  FParams.AddParam('inReceiptCostId', ftInteger, ptInput, ReceiptCostId);
  FParams.AddParam('inReceiptKindId', ftInteger, ptInput, ReceiptKindId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Receipt_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReceiptTest;
begin
  ObjectTest := TReceiptTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Рецептуре
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Рецептура 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;
  *)
initialization

//  TestFramework.RegisterTest('Объекты', TdbObjectTest.Suite);

end.
