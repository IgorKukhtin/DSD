unit OrderKindTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest ;

type
  TOrderKindTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TOrderKind = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateOrderKind(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;
implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;
     {TOrderKindTest}
constructor TOrderKind.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_OrderKind';
  spSelect := 'gpSelect_Object_OrderKind';
  spGet := 'gpGet_Object_OrderKind';
end;

function TOrderKind.InsertDefault: integer;
begin
  result := InsertUpdateOrderKind(0, -3, '��� ����� ������');
  inherited;
end;

function TOrderKind.InsertUpdateOrderKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TOrderKindTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\OrderKind\';
  inherited;
end;


procedure TOrderKindTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TOrderKind;
begin
  ObjectTest := TOrderKind.Create;
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
  TestFramework.RegisterTest('�������', TOrderKindTest.Suite);

end.
