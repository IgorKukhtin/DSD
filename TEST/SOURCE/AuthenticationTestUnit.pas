unit AuthenticationTestUnit;

interface
uses TestFramework;

type
  TAuthenticationTest = class (TTestCase)
  private
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure Authentication;
  end;

implementation

uses AuthenticationUnit, StorageUnit;

{ TAuthenticationTest }

procedure TAuthenticationTest.Authentication;
var lUser: TUser;
begin
  Check(TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Admin', 'Admin', lUser), 'Проверка пользователя');
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
  TestFramework.RegisterTest('AuthenticationTest', TAuthenticationTest.Suite);

end.
