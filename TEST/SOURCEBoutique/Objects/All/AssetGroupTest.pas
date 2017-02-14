unit AssetGroupTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TAssetGroupTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

   TAssetGroup = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateAssetGroup(const Id: integer; Code: Integer;
        Name: string; ParentId: integer): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, DB, CarModelTest,
     InfoMoneyGroupTest, InfoMoneyDestinationTest;

     {TAssetGroupTest}
constructor TAssetGroup.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_AssetGroup';
  spSelect := 'gpSelect_Object_AssetGroup';
  spGet := 'gpGet_Object_AssetGroup';
end;

function TAssetGroup.InsertDefault: integer;
var
  ParentId: Integer;
begin
  ParentId:=0;
  result := InsertUpdateAssetGroup(0, -1, '������ �������� �������', ParentId);
end;

function TAssetGroup.InsertUpdateAssetGroup;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  result := InsertUpdate(FParams);
end;

procedure TAssetGroupTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\AssetGroup\';
  inherited;
end;

procedure TAssetGroupTest.Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TAssetGroup;
begin
 // ��� ���� ������ ��������� ������������ ������ � �������.
 // � ������ ������������.
  ObjectTest := TAssetGroup.Create;
  // ������� ������ ��������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� �������
 // ��������� ������ 1
  Id := ObjectTest.InsertDefault;
  try
    // ������ ������ ������ �� ���� � ��������� ������
    try
      ObjectTest.InsertUpdateAssetGroup(Id, -1, '���� ������ 1', Id);
      Check(false, '��� ��������� �� ������');
    except

    end;
    // ��������� ��� ������ 2
    // ������ � ������ 2 ������ �� ������ 1
    Id2 := ObjectTest.InsertUpdateAssetGroup(0, -2, '���� ������ 2', Id);
    try
      // ������ ������ ������ � ������ 1 �� ������ 2 � ��������� ������
      try
        ObjectTest.InsertUpdateAssetGroup(Id, -1, '���� ������ 1', Id2);
        Check(false, '��� ��������� �� ������');
      except

      end;
      // ��������� ��� ������ 3
      // ������ � ������ 3 ������ �� ������ 2
      Id3 := ObjectTest.InsertUpdateAssetGroup(0, -3, '���� ������ 3', Id2);
      try
        // ������ 2 ��� ������ �� ������ 1
        // ������ � ������ 1 ������ �� ������ 3 � ��������� ������
        try
          ObjectTest.InsertUpdateAssetGroup(Id, -1, '���� ������ 1', Id3);
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
  TestFramework.RegisterTest('�������', TAssetGroupTest.Suite);

end.
