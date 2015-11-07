unit UnitsTest;

interface

uses dbTest, dbObjectTest, dbObjectMeatTest, ObjectTest, BranchTest, Variants;

type

  TUnitTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TUnit = class(TObjectTest)
  private
    BranchTest: TBranch;
    function InsertDefault: integer; override;
  public
    function InsertUpdateUnit(Id, Code: Integer; Name: String;
                              PartionDate: Boolean;
                              ParentId, BranchId, BusinessId, JuridicalId,
                              AccountDirectionId, ProfitLossDirectionId: integer): integer;
    constructor Create; override;
  end;


implementation

uses DB, UtilConst, TestFramework, SysUtils;

{ TdbUnitTest }

procedure TUnitTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Unit\';
  inherited;
end;

procedure TUnitTest.Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TUnit;
begin
 // ��� ���� ������ ��������� ������������ ������ � �������.
 // � ������ ������������.
  ObjectTest := TUnit.Create;
  // ������� ������ ��������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� �������
 // ��������� ������ 1
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �������������
    with ObjectTest.GetRecord(Id) do begin
         Check((FieldByName('Name').AsString = 'Test - �������������'), '�� �������� ������ Id = ' + IntToStr(Id));
         Check((FieldByName('isLeaf').AsBoolean ), '�� ��������� ����������� �������� isLeaf Id = ' + IntToStr(Id));
    end;
    // ������ ������ ������ �� ���� � ��������� ������
    try
      ObjectTest.InsertUpdateUnit(Id, -1, '������ 1 - ����', true, Id, 0, 0, 0, 0, 0);
      Check(false, '��� ��������� �� ������');
    except

    end;
    // ��������� ��� ������ 2
    // ������ � ������ 2 ������ �� ������ 1
    Id2 := ObjectTest.InsertUpdateUnit(0, -2, '������ 2 - ����', true, Id, 0, 0, 0, 0, 0);
    try
      with ObjectTest.GetRecord(Id) do begin
           Check(FieldByName('isLeaf').AsBoolean = false, '�� ��������� ����������� �������� isLeaf Id = ' + IntToStr(Id));
      end;
      with ObjectTest.GetRecord(Id2) do begin
          Check(FieldByName('isLeaf').AsBoolean, '�� ��������� ����������� �������� isLeaf Id = ' + IntToStr(Id2));
      end;
      // ������ ������ ������ � ������ 1 �� ������ 2 � ��������� ������
      try
        ObjectTest.InsertUpdateUnit(Id, -1, '������ 1 - ����', true, Id2, 0, 0, 0, 0, 0);
        Check(false, '��� ��������� �� ������');
      except

      end;
      // ��������� ��� ������ 3
      // ������ � ������ 3 ������ �� ������ 2
      Id3 := ObjectTest.InsertUpdateUnit(0, -3, '������ 3 - ����',true, Id2, 0, 0, 0, 0, 0);
      try
        with ObjectTest.GetRecord(Id2) do begin
           Check(FieldByName('isLeaf').AsBoolean = false, '�� ��������� ����������� �������� isLeaf Id = ' + IntToStr(Id2));
        end;
        with ObjectTest.GetRecord(Id3) do begin
           Check(FieldByName('isLeaf').AsBoolean, '�� ��������� ����������� �������� isLeaf Id = ' + IntToStr(Id3));
        end;
        // ������ 2 ��� ������ �� ������ 1
        // ������ � ������ 1 ������ �� ������ 3 � ��������� ������
        try
          ObjectTest.InsertUpdateUnit(Id, -1, '������ 1 - ����',true, Id3, 0, 0, 0, 0, 0);
          Check(false, '��� ��������� �� ������');
        except

        end;
        Check((ObjectTest.GetDataSet.RecordCount = RecordCount + 3), '���������� ������� �� ����������');
        ObjectTest.InsertUpdateUnit(Id3, -3, '������ 3 - ����', true,0, 0, 0, 0, 0, 0);
        with ObjectTest.GetRecord(Id2) do begin
           Check(FieldByName('isLeaf').AsBoolean, '�� ��������� ����������� �������� isLeaf Id = ' + IntToStr(Id2));
        end;
      finally
        ObjectTest.Delete(Id3);
      end;
      ObjectTest.InsertUpdateUnit(Id2, -3, '������ 3 - ����', true, 0, 0, 0, 0, 0, 0);
      with ObjectTest.GetRecord(Id) do begin
         Check(FieldByName('isLeaf').AsBoolean, '�� ��������� ����������� �������� isLeaf Id = ' + IntToStr(Id));
      end;
    finally
      ObjectTest.Delete(Id2);
    end;
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TUnitTest }

constructor TUnit.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Unit';
  spSelect := 'gpSelect_Object_Unit';
  spGet := 'gpGet_Object_Unit';
  BranchTest := TBranch.Create;
end;

function TUnit.InsertDefault: integer;
begin
  result := InsertUpdateUnit(0, -11100, 'Test - �������������',true, 0, BranchTest.GetDefault, 0, 0, 0, 0);
  inherited;
end;

function TUnit.InsertUpdateUnit(Id, Code: Integer; Name: String;
                                    PartionDate: Boolean;
                                    ParentId, BranchId, BusinessId, JuridicalId,
                                    AccountDirectionId, ProfitLossDirectionId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inPartionDate', ftBoolean, ptInput, PartionDate);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  FParams.AddParam('inBranchId', ftInteger, ptInput, BranchId);

  FParams.AddParam('inBusinessId', ftInteger, ptInput, BusinessId);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inContractId', ftInteger, ptInput, null);
  FParams.AddParam('inAccountDirectionId', ftInteger, ptInput, AccountDirectionId);
  FParams.AddParam('inProfitLossDirectionId', ftInteger, ptInput, ProfitLossDirectionId);
  FParams.AddParam('inRouteId', ftInteger, ptInput, Null);
  FParams.AddParam('inRouteSortingId', ftInteger, ptInput, Null);
  FParams.AddParam('inAreaId', ftInteger, ptInput, Null);
  result := InsertUpdate(FParams);
  if Id = 0 then
     InsertedIdObjectList.Add(IntToStr(result));
end;


initialization
  TestFramework.RegisterTest('�������', TUnitTest.Suite);

end.
