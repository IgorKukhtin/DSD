unit JuridicalSettingsTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TJuridicalSettingsTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TJuridicalSettingsObjectTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateJuridicalSettings(const Id, JuridicalId: integer;
         Bonus: real): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, JuridicalTest;

{ TdbUnitTest }

procedure TJuridicalSettingsTest.ProcedureLoad;
begin
  ScriptDirectory := LocalProcedurePath + 'OBJECTS\JuridicalSettings\';
  inherited;
end;

procedure TJuridicalSettingsTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TJuridicalSettingsObjectTest;
begin
  ObjectTest := TJuridicalSettingsObjectTest.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Типа импорта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о роли
    with ObjectTest.GetRecord(Id) do begin
      Check((FieldByName('Bonus').AsFloat = 10), 'Не сходятся данные Id = ' + IntToStr(id));
    end;
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TJuridicalSettingsTest }

constructor TJuridicalSettingsObjectTest.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_JuridicalSettings';
  spSelect := 'gpSelect_Object_JuridicalSettings';
  spGet := 'gpGet_Object_JuridicalSettings';
end;

function TJuridicalSettingsObjectTest.InsertDefault: integer;
var JuridicalId: Integer;
begin
  JuridicalId := TJuridical.Create.GetDefault;
  result := InsertUpdateJuridicalSettings(0, JuridicalId, 10);
  inherited;
end;

function TJuridicalSettingsObjectTest.InsertUpdateJuridicalSettings
            (const Id, JuridicalId: integer; Bonus: real): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inBonus', ftFloat, ptInput, Bonus);

  result := InsertUpdate(FParams);
end;

initialization
 // TestFramework.RegisterTest('Объекты', TJuridicalSettingsTest.Suite);


end.
