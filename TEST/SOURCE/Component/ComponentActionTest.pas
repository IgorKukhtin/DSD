unit ComponentActionTest;

interface

uses
  TestFramework;

type
  TActionTest = class (TTestCase)
  private
  protected
    // подготавливаем данные дл€ тестировани€
    procedure SetUp; override;
  published
    procedure InternetActionTest;
  end;

implementation

uses dsdInternetAction;

{ TActionTest }

procedure TActionTest.InternetActionTest;
begin
  with TdsdSMTPAction.Create(nil) do
    try
      Host.Value := 'dsd.biz.ua';
      UserName.Value := 'test@dsd.biz.ua';
      FromAddress.Value := 'test@dsd.biz.ua';
      Password.Value := 'testtest';
      ToAddress.Value :=  'kukhtinigor@gmail.com, igor@dsd.biz.ua';
      Body.Value := 'Ёто супер письмо!!!';
      Subject.Value := 'ј вот и заголовок';
      Execute;
    finally
      Free;
    end;
end;

procedure TActionTest.SetUp;
begin
  inherited;

end;

initialization
  TestFramework.RegisterTest('ActionTest', TActionTest.Suite);

end.
