unit CarModelTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type

  TCarModelTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;


  TCarModel = class(TObjectTest)
     function InsertDefault: integer; override;
  public
   function InsertUpdateCarModel(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;

  {TCarModelTest}
constructor TCarModel.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_CarModel';
  spSelect := 'gpSelect_Object_CarModel';
  spGet := 'gpGet_Object_CarModel';
end;

function TCarModel.InsertDefault: integer;
begin
  result := InsertUpdateCarModel(0, -1, '����� ����������');
  inherited;
end;

function TCarModel.InsertUpdateCarModel;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TCarModelTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\CarModel\';
  inherited;
end;

procedure TCarModelTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TCarModel;
begin
  ObjectTest := TCarModel.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� ����� ����������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ������� ���������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '����� ����������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('�������', TCarModelTest.Suite);

end.
