unit ImportGroupTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TImportGroupTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TImportGroupObjectTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateImportGroup(const Id: integer; Name: string): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, ExternalLoad;

{ TdbUnitTest }

procedure TImportGroupTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ImportGroup\';
  inherited;
end;

procedure TImportGroupTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TImportGroupObjectTest;
begin
  ObjectTest := TImportGroupObjectTest.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� ���� �������
  Id := ObjectTest.InsertDefault;
  try
    // ������� ������ �����
    Check(ObjectTest.GetDataSet.RecordCount = (RecordCount + 1), '���������� ������� �� ����������');
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TImportGroupTest }

constructor TImportGroupObjectTest.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_ImportGroup';
  spSelect := 'gpSelect_Object_ImportGroup';
  spGet := 'gpGet_Object_ImportGroup';
end;

function TImportGroupObjectTest.InsertDefault: integer;
begin
  result := InsertUpdateImportGroup(0, '�������� �������');
  inherited;
end;

function TImportGroupObjectTest.InsertUpdateImportGroup(const Id: integer; Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inName', ftString, ptInput, Name);

  result := InsertUpdate(FParams);
end;

initialization
  //TestFramework.RegisterTest('�������', TImportGroupTest.Suite);

end.
