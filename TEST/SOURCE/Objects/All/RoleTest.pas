unit RoleTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TRoleTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TRole = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateRole(const Id, Code : integer; Name: string): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils;

{ TdbUnitTest }

procedure TRoleTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Role\';
  inherited;
end;

procedure TRoleTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TRole;
begin
  ObjectTest := TRole.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� ��������������� �����
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ����
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = '����'), '�� �������� ������ Id = ' + IntToStr(id));
    // ������� ������ �����
    Check(ObjectTest.GetDataSet.RecordCount = (RecordCount + 1), '���������� ������� �� ����������');
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TRoleTest }

constructor TRole.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_Role';
  spSelect := 'gpSelect_Object_Role';
  spGet := 'gpGet_Object_Role';
end;

function TRole.InsertDefault: integer;
begin
  result := InsertUpdateRole(0, -1, '����');
  inherited;
end;

function TRole.InsertUpdateRole(const Id, Code : integer; Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

initialization
  //TestFramework.RegisterTest('�������', TRoleTest.Suite);

end.
