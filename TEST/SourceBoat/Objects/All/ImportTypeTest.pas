unit ImportTypeTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TImportTypeTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TImportType = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateImportType(const Id, Code : integer; Name, ProcedureName: string): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils;

{ TdbUnitTest }

procedure TImportTypeTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ImportType\';
  inherited;
end;

procedure TImportTypeTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TImportType;
begin
  ObjectTest := TImportType.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка Типа импорта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о роли
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = 'Загрузка прихода'), 'Не сходятся данные Id = ' + IntToStr(id));
    // Получим список ролей
    Check(ObjectTest.GetDataSet.RecordCount = (RecordCount + 1), 'Количество записей не изменилось');
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TImportTypeTest }

constructor TImportType.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_ImportType';
  spSelect := 'gpSelect_Object_ImportType';
  spGet := 'gpGet_Object_ImportType';
end;

function TImportType.InsertDefault: integer;
begin
  result := InsertUpdateImportType(0, -1, 'Загрузка прихода', 'gpInsertIncome');
  inherited;
end;

function TImportType.InsertUpdateImportType(const Id, Code : integer; Name, ProcedureName: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inProcedureName', ftString, ptInput, ProcedureName);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('Объекты', TImportTypeTest.Suite);

end.
