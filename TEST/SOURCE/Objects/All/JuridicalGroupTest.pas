unit JuridicalGroupTest;

interface
uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TJuridicalGroupTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TJuridicalGroup = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateJuridicalGroup(const Id, Code: Integer; Name: string; JuridicalGroupId: integer): integer;
    constructor Create; override;
  end;

implementation
uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;
     { TJuridicalGroupTest }
constructor TJuridicalGroup.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_JuridicalGroup';
  spSelect := 'gpSelect_Object_JuridicalGroup';
  spGet := 'gpGet_Object_JuridicalGroup';
end;

function TJuridicalGroup.InsertDefault: integer;
begin
  result := InsertUpdateJuridicalGroup(0, -1, '������ �� ��� 1', 0);
  inherited;
end;

function TJuridicalGroup.InsertUpdateJuridicalGroup(const Id, Code: Integer;
  Name: string; JuridicalGroupId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inJuridicalGroupId', ftInteger, ptInput, JuridicalGroupId);
  result := InsertUpdate(FParams);
end;

   procedure TJuridicalGroupTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\JuridicalGroup\';
  inherited;
end;

procedure TJuridicalGroupTest.Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TJuridicalGroup;
begin
 // ��� ���� ������ ��������� ������������ ������ � �������.
 // � ������ ������������.
  ObjectTest := TJuridicalGroup.Create;
  // ������� ������ ��������
   RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� �������
 // ��������� ������ 1
  Id := ObjectTest.InsertDefault;
  try
    // ������ ������ ������ �� ���� � ��������� ������
    try
      ObjectTest.InsertUpdateJuridicalGroup(Id, -1, '������ 1', Id);
      Check(false, '��� ��������� �� ������');
    except

    end;
    // ��������� ��� ������ 2
    // ������ � ������ 2 ������ �� ������ 1
    Id2 := ObjectTest.InsertUpdateJuridicalGroup(0, -2, '������ 2', Id);
    try
      // ������ ������ ������ � ������ 1 �� ������ 2 � ��������� ������
      try
        ObjectTest.InsertUpdateJuridicalGroup(Id, -1, '������ 1', Id2);
        Check(false, '��� ��������� �� ������');
      except

      end;
      // ��������� ��� ������ 3
      // ������ � ������ 3 ������ �� ������ 2
      Id3 := ObjectTest.InsertUpdateJuridicalGroup(0, -3, '������ 3', Id2);
      try
        // ������ 2 ��� ������ �� ������ 1
        // ������ � ������ 1 ������ �� ������ 3 � ��������� ������
        try
          ObjectTest.InsertUpdateJuridicalGroup(Id, -1, '������ 1', Id3);
          Check(false, '��� ��������� �� ������');
        except

        end;
        Check((ObjectTest.GetDataSet.RecordCount = RecordCount + 3), '���������� ������� �� ����������');
      finally
        ObjectTest.Delete(Id3);
      end;
    finally
      ObjectTest.Delete(Id2);
    end;
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
//  TestFramework.RegisterTest('�������', TJuridicalGroupTest.Suite);
end.
