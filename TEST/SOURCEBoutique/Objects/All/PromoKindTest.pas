unit PromoKindTest;

interface

uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TPromoKindTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

 TPromoKind = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdatePromoKind(Id, Code: Integer; Name: String): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, Data.DB;

     { TPromoKindTest }

constructor TPromoKind.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_PromoKind';
  spSelect := 'gpSelect_Object_PromoKind';
  spGet := 'gpGet_Object_PromoKind';
end;

function TPromoKind.InsertDefault: integer;
begin
  result := InsertUpdatePromoKind(0, -1, 'Вид акции 1');
  inherited;
end;

function TPromoKind.InsertUpdatePromoKind(Id, Code: Integer; Name: String): integer;

begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TPromoKindTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\PromoKind\';
  inherited;
end;

procedure TPromoKindTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPromoKind;
begin
  ObjectTest := TPromoKind.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка объекта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о виде акции
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Вид акции 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TPromoKindTest.Suite);

end.
