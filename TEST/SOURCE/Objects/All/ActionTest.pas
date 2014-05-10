unit ActionTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TActionTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TAction = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateAction(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, JuridicalTest;

{ TdbUnitTest }

procedure TActionTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Action\';
  inherited;
end;

procedure TActionTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAction;
begin
  ObjectTest := TAction.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �������
    with ObjectTest.GetRecord(Id) do
         Check((FieldByName('Name').AsString = 'actExit-test'), '�� �������� ������ Id = ' + IntToStr(Id));

    Check(ObjectTest.GetDataSet.RecordCount = (RecordCount + 1), '���������� ������� �� ����������');
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TActionTest }

constructor TAction.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Action';
  spSelect := 'gpSelect_Object_Action';
  spGet := 'gpGet_Object_Action';
end;

function TAction.InsertDefault: integer;
begin
  result := InsertUpdateAction(0, -1, 'actExit-test');
  inherited;
end;

function TAction.InsertUpdateAction;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('�������', TActionTest.Suite);

end.

