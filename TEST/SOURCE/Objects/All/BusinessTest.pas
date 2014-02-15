unit BusinessTest;

interface

uses dbTest, dbObjectTest;

type

  TBusinessTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TBusiness = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateBusiness(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;

implementation

uses DB, UtilConst, TestFramework, SysUtils, JuridicalTest;

{ TdbUnitTest }

procedure TBusinessTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Business\';
  inherited;
end;

procedure TBusinessTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TBusiness;
begin
  ObjectTest := TBusiness.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �������
    with ObjectTest.GetRecord(Id) do
         Check((FieldByName('Name').AsString = '������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

    Check(ObjectTest.GetDataSet.RecordCount = (RecordCount + 1), '���������� ������� �� ����������');
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TBusinessTest }

constructor TBusiness.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Business';
  spSelect := 'gpSelect_Object_Business';
  spGet := 'gpGet_Object_Business';
end;

function TBusiness.InsertDefault: integer;
begin
  result := InsertUpdateBusiness(0, -1, '������');
  inherited;
end;

function TBusiness.InsertUpdateBusiness;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

initialization
  TestFramework.RegisterTest('�������', TBusinessTest.Suite);

end.
