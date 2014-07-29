unit ImportTypeItemsTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TImportTypeItemsTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TImportTypeItems = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateImportTypeItems(const Id, ParamNumber : integer; Name, ParamType: string; ImportTypeId: integer): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, ImportTypeTest;

{ TImportTypeItemsTest }

procedure TImportTypeItemsTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ImportTypeItems\';
  inherited;
end;

procedure TImportTypeItemsTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TImportTypeItems;
begin
  ObjectTest := TImportTypeItems.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� ���� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ����
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = 'inId'), '�� �������� ������ Id = ' + IntToStr(id));
    // ������� ������ �����
    Check(ObjectTest.GetDataSet.RecordCount = (RecordCount + 1), '���������� ������� �� ����������');
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TImportTypeItems }

constructor TImportTypeItems.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_ImportTypeItems';
  spSelect := 'gpSelect_Object_ImportTypeItems';
  spGet := 'gpGet_Object_ImportTypeItems';
end;

function TImportTypeItems.InsertDefault: integer;
var ImportTypeId: integer;
begin
  ImportTypeId := TImportType.Create.GetDefault;

  result := InsertUpdateImportTypeItems(0, -1, 'inId', 'ftInteger', ImportTypeId);
  inherited;
end;

function TImportTypeItems.InsertUpdateImportTypeItems(const Id, ParamNumber : integer; Name, ParamType: string; ImportTypeId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inParamNumber', ftInteger, ptInput, ParamNumber);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inParamType', ftString, ptInput, ParamType);
  FParams.AddParam('inImportTypeId', ftInteger, ptInput, ImportTypeId);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('�������', TImportTypeItemsTest.Suite);

end.
