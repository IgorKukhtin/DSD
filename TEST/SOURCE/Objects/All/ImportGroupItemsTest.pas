unit ImportGroupItemsTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TImportGroupItemsTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TImportGroupItemsObjectTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateImportGroupItems(const Id, ImportSettingsId, ImportGroupId: integer): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, ImportSettingsTest, ImportGroupTest;

{ TdbUnitTest }

procedure TImportGroupItemsTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ImportGroupItems\';
  inherited;
end;

procedure TImportGroupItemsTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TImportGroupItemsObjectTest;
begin
  ObjectTest := TImportGroupItemsObjectTest.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Типа импорта
  Id := ObjectTest.InsertDefault;
  try
    // Получим список ролей
    Check(ObjectTest.GetDataSet.RecordCount = (RecordCount + 1), 'Количество записей не изменилось');
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TImportGroupItemsTest }

constructor TImportGroupItemsObjectTest.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_ImportGroupItems';
  spSelect := 'gpSelect_Object_ImportGroupItems';
  spGet := 'gpGet_Object_ImportGroupItems';
end;

function TImportGroupItemsObjectTest.InsertDefault: integer;
var vbImportSettingsId, vbImportGroupId: integer;
begin
  vbImportSettingsId := TImportSettingsObjectTest.Create.GetDefault;
  vbImportGroupId := TImportGroupObjectTest.Create.GetDefault;
  result := InsertUpdateImportGroupItems(0, vbImportSettingsId, vbImportGroupId);
  inherited;
end;

function TImportGroupItemsObjectTest.
          InsertUpdateImportGroupItems(const Id, ImportSettingsId, ImportGroupId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inImportSettingsId', ftInteger, ptInput, ImportSettingsId);
  FParams.AddParam('inImportGroupId', ftInteger, ptInput, ImportGroupId);

  result := InsertUpdate(FParams);
end;

initialization
 // TestFramework.RegisterTest('Объекты', TImportGroupItemsTest.Suite);

end.

