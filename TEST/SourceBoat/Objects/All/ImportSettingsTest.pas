unit ImportSettingsTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TImportSettingsTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
    procedure LoadDataTest;
  end;

  TImportSettingsObjectTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateImportSettings(const Id, Code : integer;
         Name: string; JuridicalId, ContractId, FileTypeId, ImportTypeId, StartRow: Integer;
         HDR: Boolean; Directory, Query: string): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, ExternalLoad;

{ TdbUnitTest }

procedure TImportSettingsTest.LoadDataTest;
var ObjectTest: TImportSettingsObjectTest;
    ImportSettings: TImportSettings;
begin
  ObjectTest := TImportSettingsObjectTest.Create;
  ImportSettings := TImportSettingsFactory.GetImportSettings(ObjectTest.GetDataSet.FieldByName('Id').asInteger);
end;

procedure TImportSettingsTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ImportSettings\';
  inherited;
  ScriptDirectory := ProcedurePath + 'OBJECTS\ImportSettingsItems\';
  inherited;
end;

procedure TImportSettingsTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TImportSettingsObjectTest;
begin
  ObjectTest := TImportSettingsObjectTest.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Типа импорта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о роли
    with ObjectTest.GetRecord(Id) do begin
      Check((FieldByName('name').AsString = 'Загрузка прихода'), 'Не сходятся данные Id = ' + IntToStr(id));
      Check((FieldByName('Query').AsString = 'Memo'), 'Не сходятся данные Id = ' + IntToStr(id));
    end;
    // Получим список ролей
    Check(ObjectTest.GetDataSet.RecordCount = (RecordCount + 1), 'Количество записей не изменилось');
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TImportSettingsTest }

constructor TImportSettingsObjectTest.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_ImportSettings';
  spSelect := 'gpSelect_Object_ImportSettings';
  spGet := 'gpGet_Object_ImportSettings';
end;

function TImportSettingsObjectTest.InsertDefault: integer;
begin
  result := InsertUpdateImportSettings(0, -1, 'Загрузка прихода', 0, 0, 0, 0, 0, true, 'Directory', 'Memo');
  inherited;
end;

function TImportSettingsObjectTest.InsertUpdateImportSettings(const Id, Code : integer;
         Name: string; JuridicalId, ContractId, FileTypeId, ImportTypeId, StartRow: Integer;
         HDR: Boolean; Directory, Query: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inContractId', ftInteger, ptInput, ContractId);
  FParams.AddParam('inFileTypeId', ftInteger, ptInput, FileTypeId);
  FParams.AddParam('inImportTypeId', ftInteger, ptInput, ImportTypeId);
  FParams.AddParam('inStartRow', ftInteger, ptInput, StartRow);
  FParams.AddParam('inHDR', ftBoolean, ptInput, HDR);
  FParams.AddParam('inDirectory', ftString, ptInput, Directory);
  FParams.AddParam('inQuery', ftBlob, ptInput, Query);

  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Объекты', TImportSettingsTest.Suite);

end.
