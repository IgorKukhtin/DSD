unit GoodsPropertyTest;

interface
uses dbTest, dbObjectTest, TestFramework, ObjectTest;
   type
  TGoodsPropertyTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TGoodsProperty = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoodsProperty(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;
{ TGoodsPropertyTest }

constructor TGoodsProperty.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_GoodsProperty';
  spSelect := 'gpSelect_Object_GoodsProperty';
  spGet := 'gpGet_Object_GoodsProperty';
end;

function TGoodsProperty.InsertDefault: integer;
begin
  result := InsertUpdateGoodsProperty(0, -1, 'Классификатор свойств товаров');
  inherited;
end;

function TGoodsProperty.InsertUpdateGoodsProperty(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TGoodsPropertyTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\GoodsProperty\';
  inherited;
end;
                                {TGoodsPropertyTest}
procedure TGoodsPropertyTest.Test;

var Id: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsProperty;
begin
  ObjectTest := TGoodsProperty.Create;
  // Получим список
   RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка классификатора свойств товаров
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о классификаторе свойств товаров
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Классификатор свойств товаров'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
//  TestFramework.RegisterTest('Объекты', TGoodsPropertyTest.Suite);
end.
