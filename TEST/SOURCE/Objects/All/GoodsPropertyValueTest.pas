unit GoodsPropertyValueTest;

interface

uses dbTest, dbObjectTest, TestFramework, ObjectTest;

   type
  TGoodsPropertyValueTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;


  TGoodsPropertyValue = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoodsPropertyValue(const Id: Integer; Name: string;
        Amount: double; BarCode, Article, BarCodeGLN, ArticleGLN: string;
        GoodsPropertyId, GoodsId, GoodsKindId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB, GoodsTest,
     GoodsPropertyTest;

constructor TGoodsPropertyValue.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_GoodsPropertyValue';
  spSelect := 'gpSelect_Object_GoodsPropertyValue';
  spGet := 'gpGet_Object_GoodsPropertyValue';
end;

function TGoodsPropertyValue.InsertDefault: integer;
var
  GoodsPropertyId, GoodsId, GoodsKindId: Integer;
begin
  GoodsId := TGoods.Create.GetDefault;
  GoodsPropertyId := TGoodsProperty.Create.GetDefault;
  GoodsKindId := 0;
  result := InsertUpdateGoodsPropertyValue(0, 'GoodsPropertyValue', 10,
         'BarCode', 'Article', 'BarCodeGLN', 'ArticleGLN',
         GoodsPropertyId, GoodsId, GoodsKindId);
  inherited;
end;

function TGoodsPropertyValue.InsertUpdateGoodsPropertyValue(
  const Id: Integer; Name: string; Amount: double; BarCode, Article, BarCodeGLN,
  ArticleGLN: string; GoodsPropertyId, GoodsId, GoodsKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inBarCode', ftString, ptInput, BarCode);
  FParams.AddParam('inArticle', ftString, ptInput, Article);
  FParams.AddParam('inBarCodeGLN', ftString, ptInput, BarCodeGLN);
  FParams.AddParam('inArticleGLN', ftString, ptInput, ArticleGLN);

  FParams.AddParam('inGoodsPropertyId', ftInteger, ptInput, GoodsPropertyId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);

  result := InsertUpdate(FParams);
end;

procedure TGoodsPropertyValueTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\GoodsPropertyValue\';
  inherited;
end;

procedure TGoodsPropertyValueTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsPropertyValue;
begin
  ObjectTest := TGoodsPropertyValue.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка объекта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о юр лице
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'GoodsPropertyValue'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;
  initialization
 // TestFramework.RegisterTest('Объекты', TGoodsPropertyValueTest.Suite);
end.
