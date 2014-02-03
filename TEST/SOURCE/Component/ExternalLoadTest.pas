unit ExternalLoadTest;

interface

uses
  TestFramework;

type

  TExternalLoadTest = class (TTestCase)
  private
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
  published
    procedure Load1CSaleTest;
  end;

implementation

uses Storage, Authentication, ExternalDocumentLoad, SysUtils, CommonData;

{ TExternalLoadTest }

procedure TExternalLoadTest.Load1CSaleTest;
begin
  with TSale1CLoadAction.Create(nil) do begin
    try
      FileName := '..\TEST\DATA\01-06.01.DBF';
      StartDateParam.Value := StrToDate('01.01.2014');
      EndDateParam.Value := StrToDate('01.01.2015');
      Execute;
    finally
      Free;
    end;
  end;
end;

procedure TExternalLoadTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

initialization
  TestFramework.RegisterTest('ExternalLoadTest', TExternalLoadTest.Suite);

end.
