unit GoodsGroupTest;

interface
uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TGoodsGroupTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TGoodsGroup = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoodsGroup(const Id: integer; Code: Integer;
        Name: string; ParentId: integer): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, Data.DB;

 {TGoodsGroupTest}
constructor TGoodsGroup.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_GoodsGroup';
  spSelect := 'gpSelect_Object_GoodsGroup';
  spGet := 'gpGet_Object_GoodsGroup';
end;

function TGoodsGroup.InsertDefault: integer;
var
  ParentId: Integer;
begin
  ParentId:=0;
  result := InsertUpdateGoodsGroup(0, -1, '������ ������', ParentId);
  inherited;
end;

function TGoodsGroup.InsertUpdateGoodsGroup;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  result := InsertUpdate(FParams);
end;

    procedure TGoodsGroupTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\GoodsGroup\';
  inherited;
end;

procedure TGoodsGroupTest.Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsGroup;
begin
 // ��� ���� ������ ��������� ������������ ������ � �������.
 // � ������ ������������.
  ObjectTest := TGoodsGroup.Create;
  // ������� ������ ��������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� �������
 // ��������� ������ 1
  Id := ObjectTest.InsertDefault;
  try
    // ������ ������ ������ �� ���� � ��������� ������
    try
      ObjectTest.InsertUpdateGoodsGroup(Id, 1, '������ 1', Id);
      Check(false, '��� ��������� �� ������');
    except

    end;
    // ��������� ��� ������ 2
    // ������ � ������ 2 ������ �� ������ 1
    Id2 := ObjectTest.InsertUpdateGoodsGroup(0, 2, '������ 2', Id);
    try
      // ������ ������ ������ � ������ 1 �� ������ 2 � ��������� ������
      try
        ObjectTest.InsertUpdateGoodsGroup(Id, 1, '������ 1', Id2);
        Check(false, '��� ��������� �� ������');
      except

      end;
      // ��������� ��� ������ 3
      // ������ � ������ 3 ������ �� ������ 2
      Id3 := ObjectTest.InsertUpdateGoodsGroup(0, 3, '������ 3', Id2);
      try
        // ������ 2 ��� ������ �� ������ 1
        // ������ � ������ 1 ������ �� ������ 3 � ��������� ������
        try
          ObjectTest.InsertUpdateGoodsGroup(Id, 1, '������ 1', Id3);
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
  //TestFramework.RegisterTest('�������', TGoodsGroupTest.Suite);

end.
