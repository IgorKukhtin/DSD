unit UserTest;

interface
uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TUserTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TUser = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateUser(const Id, Code: integer; UserName, Password, Sign, Seal, Key : string; MemberId: Integer): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, Data.DB;

{ TUserTest }

constructor TUser.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_User';
  spSelect := 'gpSelect_Object_User';
  spGet := 'gpGet_Object_User';
end;

function TUser.InsertDefault: integer;
begin
  result := InsertUpdateUser(0, -2, 'UserName', 'Password', 'sign', 'seal', 'key', 0);
  inherited;
end;

function TUser.InsertUpdateUser(const Id, Code: integer; UserName, Password, Sign, Seal, Key: string; MemberId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inUserName', ftString, ptInput, UserName);
  FParams.AddParam('inPassword', ftString, ptInput, Password);
  FParams.AddParam('inSign', ftString, ptInput, Sign);
  FParams.AddParam('inSeal', ftString, ptInput, Seal);
  FParams.AddParam('inKey', ftString, ptInput, Key);
  FParams.AddParam('inMemberId', ftInteger, ptInput, MemberId);
  result := InsertUpdate(FParams);

end;

procedure TUserTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\User\';
  inherited;
end;

 procedure TUserTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TUser;
begin
  ObjectTest := TUser.Create;
  // ������� ������ �������������
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // ������� ������������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ������������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = 'UserName'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
//    // �������� �� �������������
//    try
//      ObjectTest.InsertUpdateUser(0, -2, 'UserName', 'Password', 'sign', 'seal', 'key', 0);
//      Check(false, '��� ��������� �� ������ InsertUpdate_Object_User Id=0');
//    except
//
//    end;
    // ��������� ������������

    // ������� ������ �������������
    Check((ObjectTest.GetDataSet.RecordCount = RecordCount + 1), '���������� ������� �� ����������');
  finally
    ObjectTest.Delete(Id);
  end;
end;
initialization
  TestFramework.RegisterTest('�������', TUserTest.Suite);
end.
