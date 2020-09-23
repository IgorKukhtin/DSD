unit PriceGroupSettingsTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TPriceGroupSettingsTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPriceGroupSettingsObjectTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdatePriceGroupSettings(const Id: integer; Name: string;
         MinPrice, Percent: real): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils;

{ TdbUnitTest }

procedure TPriceGroupSettingsTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\PriceGroupSettings\';
  inherited;
end;

procedure TPriceGroupSettingsTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPriceGroupSettingsObjectTest;
begin
  ObjectTest := TPriceGroupSettingsObjectTest.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Типа импорта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о роли
    with ObjectTest.GetRecord(Id) do begin
      Check((FieldByName('MinPrice').AsFloat = 10), 'Не сходятся данные Id = ' + IntToStr(id));
    end;
    // Получим список ролей
    Check(ObjectTest.GetDataSet.RecordCount = (RecordCount + 1), 'Количество записей не изменилось');
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TPriceGroupSettingsTest }

constructor TPriceGroupSettingsObjectTest.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_PriceGroupSettings';
  spSelect := 'gpSelect_Object_PriceGroupSettings';
  spGet := 'gpGet_Object_PriceGroupSettings';
end;

function TPriceGroupSettingsObjectTest.InsertDefault: integer;
begin
  result := InsertUpdatePriceGroupSettings(0, 'От 0 до 10', 10, 100);
  inherited;
end;

function TPriceGroupSettingsObjectTest.InsertUpdatePriceGroupSettings(const Id: integer;
         Name: string; MinPrice, Percent: real): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inMinPrice', ftFloat, ptInput, MinPrice);
  FParams.AddParam('inPercent', ftFloat, ptInput, Percent);

  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Объекты', TPriceGroupSettingsTest.Suite);

end.
