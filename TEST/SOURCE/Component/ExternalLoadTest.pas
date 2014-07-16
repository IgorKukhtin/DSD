unit ExternalLoadTest;

interface

uses
  TestFramework;

type

  TExternalLoadTest = class (TTestCase)
  private
  protected
    // �������������� ������ ��� ������������
    procedure SetUp; override;
  published
    procedure LoadPriceListTest;
  end;

implementation

uses Storage, Authentication, ExternalLoad, SysUtils, CommonData;

{ TExternalLoadTest }

procedure TExternalLoadTest.LoadPriceListTest;
var ImportSettings: TImportSettings;
begin
  ImportSettings := TImportSettings.Create(TImportSettingsItems);
  ImportSettings.FileType := dtXLS;
  ImportSettings.Directory := '..\DOC\���������� �������� � �������\������\����\';
  TExecuteImportSettings.Create.Execute(ImportSettings);
end;

procedure TExternalLoadTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', '�����', gc_User);
end;

initialization
  TestFramework.RegisterTest('ExternalLoadTest', TExternalLoadTest.Suite);

end.
