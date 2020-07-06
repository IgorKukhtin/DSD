unit ProfitLossGroupTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TProfitLossGroupTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;


  TProfitLossGroup = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateProfitLossGroup(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, DB;

     { TProfitLossGroupTest }
constructor TProfitLossGroup.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ProfitLossGroup';
  spSelect := 'gpSelect_Object_ProfitLossGroup';
  spGet := 'gpGet_Object_ProfitLossGroup';
end;

function TProfitLossGroup.InsertDefault: integer;
begin
  result := InsertUpdateProfitLossGroup(0, -4, '������ ������ ������ � �������� � ������� 1');
  inherited;
end;

function TProfitLossGroup.InsertUpdateProfitLossGroup(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TProfitLossGroupTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ProfitLossGroup\';
  inherited;
end;


procedure TProfitLossGroupTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TProfitLossGroup;
begin
  ObjectTest := TProfitLossGroup.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '������ ������ ������ � �������� � ������� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

 initialization
  //TestFramework.RegisterTest('�������', TProfitLossGroupTest.Suite);

end.
