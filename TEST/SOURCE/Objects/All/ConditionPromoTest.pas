unit ConditionPromoTest;

interface

uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TConditionPromoTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

 TConditionPromo = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateConditionPromo(Id, Code: Integer; Name: String): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, Data.DB;

     { TConditionPromoTest }

constructor TConditionPromo.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ConditionPromo';
  spSelect := 'gpSelect_Object_ConditionPromo';
  spGet := 'gpGet_Object_ConditionPromo';
end;

function TConditionPromo.InsertDefault: integer;
begin
  result := InsertUpdateConditionPromo(0, -1, '������� ������� � ����� 1');
  inherited;
end;

function TConditionPromo.InsertUpdateConditionPromo(Id, Code: Integer; Name: String): integer;

begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TConditionPromoTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\ConditionPromo\';
  inherited;
end;

procedure TConditionPromoTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TConditionPromo;
begin
  ObjectTest := TConditionPromo.Create;
  // ������� ������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '������� ������� � ����� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  //TestFramework.RegisterTest('�������', TConditionPromoTest.Suite);

end.
