unit AccountGroupTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TAccountGroupTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TAccountGroup = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateAccountGroup(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, // JuridicalTest,
      Data.DB;
     { TAccountGroupTest }
constructor TAccountGroup.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_AccountGroup';
  spSelect := 'gpSelect_Object_AccountGroup';
  spGet := 'gpGet_Object_AccountGroup';
end;

function TAccountGroup.InsertDefault: integer;
begin
  result := InsertUpdateAccountGroup(0, -4, '������ �������������� ������ 1');
  inherited;
end;

function TAccountGroup.InsertUpdateAccountGroup(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TAccountGroupTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\AccountGroup\';
  inherited;
end;

procedure TAccountGroupTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAccountGroup;
begin
  ObjectTest := TAccountGroup.Create;
  // ������� ������
 RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� ������ ���.������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '������ �������������� ������ 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('�������', TAccountGroupTest.Suite);

end.
