unit InfoMoneyDestinationTest;

interface

 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TInfoMoneyDestinationTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

    TInfoMoneyDestination = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateInfoMoneyDestination(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, DB, CarModelTest,
     ProfitLossDirectionTest, ProfitLossGroupTest;

{ TInfoMoneyDestinationTest }
constructor TInfoMoneyDestination.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_InfoMoneyDestination';
  spSelect := 'gpSelect_Object_InfoMoneyDestination';
  spGet := 'gpGet_Object_InfoMoneyDestination';
end;

function TInfoMoneyDestination.InsertDefault: integer;
begin
  result := InsertUpdateInfoMoneyDestination(0, -1, '�������������� ��������� - ����������');
  inherited;
end;

function TInfoMoneyDestination.InsertUpdateInfoMoneyDestination(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TInfoMoneyDestinationTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\InfoMoneyDestination\';
  inherited;
end;

procedure TInfoMoneyDestinationTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TInfoMoneyDestination;
begin
  ObjectTest := TInfoMoneyDestination.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� ������ ���.������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '�������������� ��������� - ����������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('�������', TInfoMoneyDestinationTest.Suite);

end.
