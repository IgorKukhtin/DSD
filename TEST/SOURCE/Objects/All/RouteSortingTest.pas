unit RouteSortingTest;

interface
 uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TRouteSortingTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;
    TRouteSorting = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateRouteSorting(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;

     {TRouteSortingTest }
constructor TRouteSorting.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_RouteSorting';
  spSelect := 'gpSelect_Object_RouteSorting';
  spGet := 'gpGet_Object_RouteSorting';
end;

function TRouteSorting.InsertDefault: integer;
begin
  result := InsertUpdateRouteSorting(0, -111, 'test ���������� ���������');
  inherited;
end;

function TRouteSorting.InsertUpdateRouteSorting(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TRouteSortingTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\RouteSorting\';
  inherited;
 end;

  procedure TRouteSortingTest.Test;
       var Id: integer;
    RecordCount: Integer;
    ObjectTest: TRouteSorting;
begin
  ObjectTest := TRouteSorting.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� �� ����
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ���������� ��������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'test ���������� ���������'), '�� �������� ������ Id = ' + IntToStr(Id));

  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  //TestFramework.RegisterTest('�������', TRouteSortingTest.Suite);

end.
