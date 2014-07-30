unit MeasureTest;

interface

uses dbTest, dbObjectTest, ObjectTest;

type

  TMeasureTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TMeasure = class(TObjectTest)
     function InsertDefault: integer; override;
  public
    function InsertUpdateMeasure(Id, Code: Integer; Name: String): integer;
    constructor Create; override;
  end;


implementation

uses DB, UtilConst, TestFramework, SysUtils;

{ TdbUnitTest }

procedure TMeasureTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Measure\';
  inherited;
end;

procedure TMeasureTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TMeasure;
begin
  ObjectTest := TMeasure.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� ������� ���������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ������� ���������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '������� ���������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TMeasure}
constructor TMeasure.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Measure';
  spSelect := 'gpSelect_Object_Measure';
  spGet := 'gpGet_Object_Measure';
end;

function TMeasure.InsertDefault: integer;
begin
  result := InsertUpdateMeasure(0, -11, '������� ���������');
end;

function TMeasure.InsertUpdateMeasure;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;


initialization
  TestFramework.RegisterTest('�������', TMeasureTest.Suite);


end.
