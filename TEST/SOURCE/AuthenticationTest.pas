unit AuthenticationTest;

interface
uses TestFramework;

type
  TAuthenticationTest = class (TTestCase)
  private
  protected
    // �������������� ������ ��� ������������
    procedure SetUp; override;
    // ���������� ������ ��� ������������
    procedure TearDown; override;
  published
    procedure Authentication;
  end;

implementation

uses Authentication, Storage, SysUtils, UtilConst;

{ TAuthenticationTest }

procedure TAuthenticationTest.Authentication;
var lUser: TUser;
    ErrorMessage: String;
begin
  try
    TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Admin1', 'Admin', lUser);
    Check(false, '��� ��������� �� ������');
  except
    on E: Exception do
       ErrorMessage := E.Message;
  end;
  Check(Pos('������������ ����� ��� ������', ErrorMessage) <> -1, '������ ' + ErrorMessage);

  try
    TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Admin', 'Admin1', lUser);
    Check(false, '��� ��������� �� ������');
  except
    on E: Exception do
       ErrorMessage := E.Message;
  end;
  Check(Pos('������������ ����� ��� ������', ErrorMessage) <> -1, '������ ' + ErrorMessage);

  Check(TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', gc_AdminPassword, lUser), '�������� ������������');
end;

procedure TAuthenticationTest.SetUp;
begin
  inherited;
end;

procedure TAuthenticationTest.TearDown;
begin
  inherited;

end;

initialization
//  TestFramework.RegisterTest('���� �������������', TAuthenticationTest.Suite);

end.
