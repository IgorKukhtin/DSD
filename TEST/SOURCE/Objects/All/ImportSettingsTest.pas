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
    function InsertUpdateImportSettings(const Id, Code : integer; Name, ProcedureName: string): integer;
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
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� ���� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ����
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = '�������� �������'), '�� �������� ������ Id = ' + IntToStr(id));
    // ������� ������ �����
    Check(ObjectTest.GetDataSet.RecordCount = (RecordCount + 1), '���������� ������� �� ����������');
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
  result := InsertUpdateImportSettings(0, -1, '�������� �������', 'gpInsertIncome');
  inherited;
end;

function TImportSettingsObjectTest.InsertUpdateImportSettings(const Id, Code : integer; Name, ProcedureName: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inProcedureName', ftString, ptInput, ProcedureName);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('�������', TImportSettingsTest.Suite);

end.
