unit InfoMoneyTest;

interface

uses dbTest, dbObjectTest;

type

  TInfoMoneyTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TInfoMoney = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateInfoMoney(const Id, Code : integer; Name: string; InfoMoneyGroupId: Integer;
                                     InfoMoneyDestinationId: integer): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, Authentication, Storage, CommonData;

{ TInfoMoneyTest }

procedure TInfoMoneyTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\InfoMoney\';
  inherited;
end;

procedure TInfoMoneyTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TInfoMoney;
begin
  inherited;
  ObjectTest := TInfoMoney.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '�������������� ��������� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TInfoMoneyTest}
 constructor TInfoMoney.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_InfoMoney';
  spSelect := 'gpSelect_Object_InfoMoney';
  spGet := 'gpGet_Object_InfoMoney';
end;

function TInfoMoney.InsertDefault: integer;
var
  InfoMoneyGroupId: Integer;
  InfoMoneyDestinationId: Integer;
begin
  InfoMoneyGroupId := TInfoMoneyGroupTest.Create.GetDefault;
  InfoMoneyDestinationId:= TInfoMoneyDestinationTest.Create.GetDefault;;
  result := InsertUpdateInfoMoney(0, -3, '�������������� ��������� 1', InfoMoneyGroupId, InfoMoneyDestinationId);
  inherited;
end;

function TInfoMoney.InsertUpdateInfoMoney;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inInfoMoneyGroupId', ftInteger, ptInput, InfoMoneyGroupId);
  FParams.AddParam('inInfoMoneyDestinationId', ftInteger, ptInput, InfoMoneyDestinationId);

  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('�������', TInfoMoneyTest.Suite);

end.
