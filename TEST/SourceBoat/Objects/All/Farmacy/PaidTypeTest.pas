unit PaidTypeTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TPaidTypeTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPaidType = class(TObjectTest)
  function InsertDefault: integer; override;
  procedure SetDataSetParam; override;
  public
    function InsertUpdatePaidType(const Id: Integer; const PaidTypeCode: Integer;
  const PaidTypeName: String): integer;
    constructor Create; override;
  end;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB, GoodsTest,
     UnitsTest;
     { TPaidTypeTest }
constructor TPaidType.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_PaidType';
  spSelect := 'gpSelect_Object_PaidType';
  spGet := 'gpGet_Object_PaidType';
end;

function TPaidType.InsertDefault: integer;
begin
  result := InsertUpdatePaidType(0, -10, 'Тестовый тип оплаты');
  inherited;
end;

function TPaidType.InsertUpdatePaidType(const Id: Integer; const PaidTypeCode: Integer;
  const PaidTypeName: String): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inPaidTypeCode', ftInteger, ptInput, PaidTypeCode);
  FParams.AddParam('inPaidTypeName', ftString, ptInput, PaidTypeName);
  result := InsertUpdate(FParams);
end;

procedure TPaidType.SetDataSetParam;
begin
  inherited;
end;

procedure TPaidTypeTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\PaidType\';
  inherited;
end;

procedure TPaidTypeTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPaidType;
begin
  ObjectTest := TPaidType.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка нового типа оплаты

  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('PaidTypeCode').AsInteger = -10) AND
            (FieldByName('PaidTypeName').AsString = 'Тестовый тип оплаты'),
            'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TPaidTypeTest.Suite);

end.
