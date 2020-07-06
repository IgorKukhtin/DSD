unit ProfitLossDirectionTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TProfitLossDirectionTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

   TProfitLossDirection = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateProfitLossDirection(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, DB;

     { TProfitLossDirectionTest }
constructor TProfitLossDirection.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ProfitLossDirection';
  spSelect := 'gpSelect_Object_ProfitLossDirection';
  spGet := 'gpGet_Object_ProfitLossDirection';
end;

function TProfitLossDirection.InsertDefault: integer;
begin
  result := InsertUpdateProfitLossDirection(0, -1, '��������� ������ ������ � �������� � ������� - ����������� 1');
  inherited;
end;

function TProfitLossDirection.InsertUpdateProfitLossDirection(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;


procedure TProfitLossDirectionTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ProfitLossDirection\';
  inherited;
end;

procedure TProfitLossDirectionTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TProfitLossDirection;
begin
  ObjectTest := TProfitLossDirection.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� ������ ���.������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '��������� ������ ������ � �������� � ������� - ����������� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
 // TestFramework.RegisterTest('�������', TProfitLossDirectionTest.Suite);

end.
