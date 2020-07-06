unit PaidKindTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest ;

type
  TPaidKindTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPaidKind = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePaidKind(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;
implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;
     {TPaidKindTest}
constructor TPaidKind.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_PaidKind';
  spSelect := 'gpSelect_Object_PaidKind';
  spGet := 'gpGet_Object_PaidKind';
end;

function TPaidKind.InsertDefault: integer;
begin
  result := InsertUpdatePaidKind(0, -3, '��� ����� ������');
  inherited;
end;

function TPaidKind.InsertUpdatePaidKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TPaidKindTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\PaidKind\';
  inherited;
end;


procedure TPaidKindTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPaidKind;
begin
  ObjectTest := TPaidKind.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� ���� ����� ������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ���� ����� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '��� ����� ������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;




initialization
//  TestFramework.RegisterTest('�������', TPaidKindTest.Suite);

end.
