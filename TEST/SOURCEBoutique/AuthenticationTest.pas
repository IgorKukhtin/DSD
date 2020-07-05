unit AuthenticationTest;

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

uses Authentication, Storage, SysUtils, UtilConst;

{ TAuthenticationTest }

procedure TAuthenticationTest.Authentication;
var lUser: TUser;
    ErrorMessage: String;
begin
  try
    TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Admin1', 'Admin', lUser);
    Check(false, 'Нет сообщения об ошибке');
  except
    on E: Exception do
       ErrorMessage := E.Message;
  end;
  Check(Pos('Неправильный логин или пароль', ErrorMessage) <> -1, 'Ошибка ' + ErrorMessage);

  try
    TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Admin', 'Admin1', lUser);
    Check(false, 'Нет сообщения об ошибке');
  except
    on E: Exception do
       ErrorMessage := E.Message;
  end;
  Check(Pos('Неправильный логин или пароль', ErrorMessage) <> -1, 'Ошибка ' + ErrorMessage);

  Check(TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', gc_AdminPassword, lUser), 'Проверка пользователя');
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
//  TestFramework.RegisterTest('Тест идентификации', TAuthenticationTest.Suite);

end.
