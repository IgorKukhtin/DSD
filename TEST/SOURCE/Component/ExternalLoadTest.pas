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
    procedure ImportSettingsTest;
    procedure LoadPriceListTest;
  end;

implementation

uses Storage, Authentication, ExternalLoad, SysUtils, CommonData, JuridicalTest,
     dsdDB, DB, Variants;

{ TExternalLoadTest }

procedure TExternalLoadTest.ImportSettingsTest;
begin

end;

procedure TExternalLoadTest.LoadPriceListTest;
var ImportSettings: TImportSettings;
    JuridicalId: Integer;
begin
  ImportSettings := TImportSettings.Create(TImportSettingsItems);
  ImportSettings.FileType := dtXLS;
  ImportSettings.Directory := '..\DOC\���������� �������� � �������\������\����\';
  JuridicalId := 0;
  try
    JuridicalId := TJuridical.Create.GetDataSet.FieldByName('Id').AsInteger;
  except

  end;
  if JuridicalId = 0 then exit;

  ImportSettings.JuridicalId := JuridicalId;

  ImportSettings.StoredProc.StoredProcName := 'gpInsertUpdate_Movement_LoadPriceList';
  ImportSettings.StoredProc.Params.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  ImportSettings.StoredProc.Params.AddParam('inGoodsCode', ftString, ptInput, null);
  ImportSettings.StoredProc.Params.AddParam('inGoodsName', ftString, ptInput, null);
  ImportSettings.StoredProc.Params.AddParam('inGoodsNDS', ftString, ptInput, null);
  ImportSettings.StoredProc.Params.AddParam('inPrice', ftFloat, ptInput, 0);
  ImportSettings.StoredProc.Params.AddParam('inRemains', ftFloat, ptInput, 0);
  ImportSettings.StoredProc.Params.AddParam('inExpirationDate', ftDateTime, ptInput, Date);
  ImportSettings.StoredProc.Params.AddParam('inPackCount', ftInteger, ptInput, 0);
  ImportSettings.StoredProc.Params.AddParam('inProducerName', ftString, ptInput, '');
  ImportSettings.StartRow := 4;

  with TImportSettingsItems(ImportSettings.Add) do begin
    ItemName := '���';
    Param := ImportSettings.StoredProc.ParamByName('inGoodsCode')
  end;
  with TImportSettingsItems(ImportSettings.Add) do begin
    ItemName := '�����';
    Param := ImportSettings.StoredProc.ParamByName('inGoodsName')
  end;
  with TImportSettingsItems(ImportSettings.Add) do begin
    ItemName := '������� ���';
    Param := ImportSettings.StoredProc.ParamByName('inGoodsNDS')
  end;
  with TImportSettingsItems(ImportSettings.Add) do begin
    ItemName := '����';
    Param := ImportSettings.StoredProc.ParamByName('inPrice')
  end;
  with TImportSettingsItems(ImportSettings.Add) do begin
    ItemName := '���-�� � ��������';
    Param := ImportSettings.StoredProc.ParamByName('inPackCount')
  end;
  with TImportSettingsItems(ImportSettings.Add) do begin
    ItemName := '���� ��������';
    Param := ImportSettings.StoredProc.ParamByName('inExpirationDate')
  end;
  with TImportSettingsItems(ImportSettings.Add) do begin
    ItemName := '�������������';
    Param := ImportSettings.StoredProc.ParamByName('inProducerName')
  end;

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
