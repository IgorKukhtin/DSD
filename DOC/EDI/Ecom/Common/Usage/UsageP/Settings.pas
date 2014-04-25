unit Settings;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, StdCtrls, ComCtrls, Registry,
  EUSignCP, Certificates;

{ ------------------------------------------------------------------------------ }

const
  SettingsAddressSplitter = ';';

{ ------------------------------------------------------------------------------ }

type
  TSettingsForm = class(TForm)
    TabsImageList: TImageList;
    BottomPanel: TPanel;
    BottomBottomImage: TImage;
    BottomTopImage: TImage;
    OKButton, CancelButton, ApplyButton: TButton;
    LeftPanel: TPanel;
    TabsBottomImage, TabsLeftImage, TabsRightImage, TabsTopImage: TImage;
    TabsListView: TListView;
    RightPanel, MainSplitPanel, MainTopSplitPanel: TPanel;
    MainTopImage, MainRightImage, MainLeftImage, MainBottomImage: TImage;
    MainRightSplitPanel, MainLeftSplitPanel, MainBottomSplitPanel: TPanel;
    PageControl: TPageControl;
    P1TabSheet, P2TabSheet, P3TabSheet, P4TabSheet, P5TabSheet: TTabSheet;
    P1Panel, P2Panel, P3Panel, P4Panel, P5Panel: TPanel;
    CP1TopImage, Tab1Split1Image: TImage;
    CP1TopLabel, FStoreTitleLabel: TLabel;
    FSPathBrowseButton: TButton;
    FSAutoRefreshCheckBox: TCheckBox;
    FSPathEdit: TEdit;
    FSPathLabel: TLabel;
    FSSaveFromConnCheckBox: TCheckBox;
    CertExpirationTimeLabel: TLabel;
    CertExpirationTimeEdit: TEdit;
    CheckCRLsCheckBox, OnlyOwnCRLsCheckBox, AutoDownloadCRLsCheckBox,
      FullAndDeltaCRLsCheckBox: TCheckBox;
    Tab1Split2Image: TImage;
    UseProxyCheckBox: TCheckBox;
    ProxyAddressLabel: TLabel;
    CP2TopImage: TImage;
    CP2TopLabel: TLabel;
    Tab2Split1Image: TImage;
    ProxyAddressEdit, ProxyPortEdit: TEdit;
    ProxyPortLabel, ProxyLoginLabel, ProxyPasswordLabel: TLabel;
    AuthProxyCheckBox, SaveProxyPasswordCheckBox: TCheckBox;
    ProxyPasswordEdit, ProxyLoginEdit: TEdit;
    Tab2Split2Image, Tab2Split3Image, CP3TopImage: TImage;
    CP3TopLabel: TLabel;
    GetTSCheckBox: TCheckBox;
    TSPServerAddressLabel: TLabel;
    TSPServerPortLabel: TLabel;
    TSPServerPortEdit: TEdit;
    TSPServerAddressEdit: TEdit;
    Tab3Split1Image: TImage;
    TSPServerSetButton: TButton;
    CP4TopImage: TImage;
    CP4TopLabel: TLabel;
    UseOCSPCheckBox: TCheckBox;
    OCSPServerAddressLabel: TLabel;
    OCSPServerPortLabel: TLabel;
    OCSPBeforeFSCheckBox: TCheckBox;
    OCSPServerPortEdit: TEdit;
    OCSPServerAddressEdit: TEdit;
    Tab4Split1Image: TImage;
    OCSPServerSetButton: TButton;
    CP5TopImage: TImage;
    CP5TopLabel: TLabel;
    UseLDAPCheckBox: TCheckBox;
    LDAPAddressLabel: TLabel;
    LDAPPortLabel: TLabel;
    AnonimousLDAPCheckBox: TCheckBox;
    LDAPUserLabel: TLabel;
    LDAPPasswordLabel: TLabel;
    LDAPPasswordEdit: TEdit;
    LDAPUserEdit: TEdit;
    Tab5Split2Image: TImage;
    LDAPPortEdit: TEdit;
    LDAPAddressEdit: TEdit;
    Tab5Split1Image: TImage;
    LDAPSetButton: TButton;
    P6TabSheet: TTabSheet;
    P6Panel: TPanel;
    CP6TopImage: TImage;
    CP6TopLabel: TLabel;
    CMPServerAddressLabel: TLabel;
    CMPServerPortLabel: TLabel;
    Tab6Split1Image: TImage;
    UseCMPCheckBox: TCheckBox;
    CMPServerPortEdit: TEdit;
    CMPServerAddressEdit: TEdit;
    CMPServerSetButton: TButton;
    Button1: TButton;
    Button2: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TabsListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ApplyButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure ControlClick(Sender: TObject);
    procedure CMPServerSetButtonClick(Sender: TObject);
    procedure FSPathBrowseButtonClick(Sender: TObject);
    procedure LDAPSetButtonClick(Sender: TObject);
    procedure OCSPServerSet(Address: PAnsiChar);
    procedure OCSPServerSetButtonClick(Sender: TObject);
    procedure OCSPServerSetFromUserButtonClick(Sender: TObject);
    procedure TSPServerSetButtonClick(Sender: TObject);
    procedure TSPServerSetFromUserButtonClick(Sender: TObject);
    procedure AnonimousLDAPCheckBoxClick(Sender: TObject);
    procedure AuthProxyCheckBoxClick(Sender: TObject);
    procedure AutoDownloadCRLsCheckBoxClick(Sender: TObject);
    procedure CheckCRLsCheckBoxClick(Sender: TObject);
    procedure GetTSCheckBoxClick(Sender: TObject);
    procedure SaveProxyPasswordCheckBoxClick(Sender: TObject);
    procedure UseCMPCheckBoxClick(Sender: TObject);
    procedure UseLDAPCheckBoxClick(Sender: TObject);
    procedure UseOCSPCheckBoxClick(Sender: TObject);
    procedure UseProxyCheckBoxClick(Sender: TObject);

  private
    IsShown, NotGot, IsCA: Boolean;
    CPInterface: PEUSignCP;
    function GetSettings(): Boolean;
    procedure SetDefaults();
    function SetSettings(blOnlyFStore: Boolean): Boolean;
    function CreateCertAndCRLCatalog(Name: String): Boolean;
    function GetProxyFromInternetSettings(): Boolean;
    function CheckServerEdit(ServerName: AnsiString; Name, Port: TEdit;
      Item: TListItem; EmptyFields: Boolean = False): Boolean;
    function CheckIntegerEdit(Edit: TEdit; Min, Max: Integer): Boolean;
    function IsServerDNSNameExist(DNSNames, DNSName: String): Boolean;

  public
    procedure Initialize(CPInterface: PEUSignCP; IsCA: Boolean);

  end;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

uses
  EUSignCPOwnUI;

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ============================================================================== }

procedure TSettingsForm.Initialize(CPInterface: PEUSignCP; IsCA: Boolean);
var
  Index: Integer;
  Item: TListItem;

begin
  self.CPInterface := CPInterface;
  self.IsCA := IsCA;

  IsShown := False;
  NotGot := False;
  
  if (not GetSettings()) then
  begin
    SetDefaults();

    MessageBox(Handle, 'Параметри роботи не знайдені або пошкоджені ' +
      'у системному реєстрі.' + #13#10 +
      'Всі параметри вcтановлені по замовчанню',
      'Повідомлення оператору', MB_OK or MB_ICONWARNING);

    NotGot := True;
  end;

  if IsCA then
  begin
    CertExpirationTimeLabel.Enabled := False;
    CertExpirationTimeEdit.Text := '1';
    CertExpirationTimeEdit.Enabled := False;

    GetTSCheckBox.Checked := False;
    UseLDAPCheckBox.Checked := False;

    PageControl.Pages[2].TabVisible := False;
    PageControl.Pages[4].TabVisible := False;
  end;

  CheckCRLsCheckBoxClick(nil);
  UseProxyCheckBoxClick(nil);
  GetTSCheckBoxClick(nil);
  UseOCSPCheckBoxClick(nil);
  UseLDAPCheckBoxClick(nil);
  UseCMPCheckBoxClick(nil);

  ApplyButton.Enabled := NotGot;

  TabsListView.Items.Clear();
  Index := 0;

  while (Index < PageControl.PageCount) do
  begin

    if ((not IsCA) or ((Index <> 2) and (Index <> 4))) then
    begin
      Item := TabsListView.Items.Add();
      Item.ImageIndex := Index;
      Item.Caption := PageControl.Pages[Index].Caption;
    end;

    Index := Index + 1;
  end;

  TabsListView.Selected := TabsListView.Items.Item[0];
  IsShown := True;
end;

{ ============================================================================== }

procedure TSettingsForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Return: Integer;

begin
  CanClose := True;

  if ApplyButton.Enabled then
  begin

    Return := MessageBox(Handle, 'Зберегти параметри роботи перед виходом?',
      'Повідомлення оператору', MB_YESNOCANCEL or MB_ICONWARNING);

    case Return of
      IDYES:
        begin
          ApplyButtonClick(nil);
          if ApplyButton.Enabled then
            CanClose := False;
        end;
      IDNO:
        CanClose := True;
      IDCANCEL:
        CanClose := False;
    else
      CanClose := False;
    end;
  end;

end;

{ ============================================================================== }

procedure TSettingsForm.TabsListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin

  if ((Item = nil) or (not Selected)) then
    Exit;

  if (PageControl.TabIndex <> Item.Index) then
  begin
    if (IsCA and (Item.Index = 2)) then
    begin
      PageControl.ActivePage := PageControl.Pages[Item.Index + 1];
    end
    else
      PageControl.ActivePage := PageControl.Pages[Item.Index];
  end;

end;

{ ============================================================================== }

procedure TSettingsForm.ApplyButtonClick(Sender: TObject);
begin
  if SetSettings(False) then
    ApplyButton.Enabled := False;
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.OKButtonClick(Sender: TObject);
begin
  if ApplyButton.Enabled then
    ApplyButtonClick(Sender);

  ModalResult := mrOk;
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.EditChange(Sender: TObject);
begin
  ApplyButton.Enabled := True;
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.ControlClick(Sender: TObject);
begin
  ApplyButton.Enabled := True;
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.CMPServerSetButtonClick(Sender: TObject);
var
  Info: PEUCertInfoEx;

begin
  if (not EUShowCertificates(WindowHandle, '', CPInterface,
    'Сертифікат CMP-сервера', CertTypeCACMP, @Info)) then
    Exit;

  if (StrLen(Info.SubjDNS) <> 0) then
  begin
    CMPServerAddressEdit.Text := Info.SubjDNS;
    EditChange(nil);
  end;

  CPInterface.FreeCertificateInfoEx(Info);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.FSPathBrowseButtonClick(Sender: TObject);
var
  Folder: AnsiString;
  PathEditText: AnsiString;

begin
  PathEditText := FSPathEdit.Text;

  Folder := EUSignCPOwnUI.EUBrowseForFolder('Каталог з сертифікатами та СВС',
    PathEditText, 0);
  if (Folder <> '') then
  begin
    FSPathEdit.Text := ExcludeTrailingPathDelimiter(Folder);
    if FSAutoRefreshCheckBox.Checked then
    begin
      SetSettings(True);
    end
    else
      EditChange(nil);
  end;

end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.LDAPSetButtonClick(Sender: TObject);
var
  Info: PEUCertInfoEx;

begin
  if (not EUShowCertificates(WindowHandle, '', CPInterface,
    'Сертифікат LDAP-сервера', CertTypeCA, @Info)) then
    Exit;

  if (StrLen(Info.SubjDNS) <> 0) then
  begin
    LDAPAddressEdit.Text := Info.SubjDNS;
    EditChange(nil);
  end;

  CPInterface.FreeCertificateInfoEx(Info);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.OCSPServerSet(Address: PAnsiChar);
begin

  if IsServerDNSNameExist(OCSPServerAddressEdit.Text, String(Address)) then
  begin
    MessageBox(Handle, 'OCSP-сервер вже є у списку', 'Повідомлення оператору',
      MB_OK or MB_ICONWARNING);

    Exit;
  end;

  if (Length(OCSPServerAddressEdit.Text) = 0) then
  begin
    OCSPServerAddressEdit.Text := Address;
  end
  else
  begin
    OCSPServerAddressEdit.Text := OCSPServerAddressEdit.Text +
      SettingsAddressSplitter + Address;
  end;

  EditChange(nil);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.OCSPServerSetButtonClick(Sender: TObject);
var
  Info: PEUCertInfoEx;

begin
  if (not EUShowCertificates(WindowHandle, '', CPInterface,
    'Сертифікат OCSP-сервера', CertTypeCAOCSP, @Info)) then
    Exit;

  if (StrLen(Info.SubjDNS) <> 0) then
  begin
     OCSPServerSet(Info.SubjDNS);
  end;


  CPInterface.FreeCertificateInfoEx(Info);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.OCSPServerSetFromUserButtonClick(Sender: TObject);
var
  Info: PEUCertInfoEx;

begin
  if (not EUShowCertificates(WindowHandle, '', CPInterface,
    'Сертифікат користувача', CertTypeEndUser, @Info)) then
    Exit;

  if (StrLen(Info.OCSPAccessInfo) <> 0) then
  begin
    OCSPServerSet(Info.OCSPAccessInfo);
  end;

  CPInterface.FreeCertificateInfoEx(Info);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.TSPServerSetButtonClick(Sender: TObject);
var
  Info: PEUCertInfoEx;

begin
  if (not EUShowCertificates(WindowHandle, '', CPInterface,
    'Сертифікат TSP-сервера', CertTypeCATSP, @Info)) then
    Exit;

  if (StrLen(Info.SubjDNS) <> 0) then
  begin
    TSPServerAddressEdit.Text := Info.SubjDNS;
    EditChange(nil);
  end;

  CPInterface.FreeCertificateInfoEx(Info);
end;

{ ------------------------------------------------------------------------------ }

 procedure TSettingsForm.TSPServerSetFromUserButtonClick(Sender: TObject);
var
  Info: PEUCertInfoEx;

begin
  if (not EUShowCertificates(WindowHandle, '', CPInterface,
    'Сертифікат користувача', CertTypeEndUser, @Info)) then
    Exit;

  if (StrLen(Info.TSPAccessInfo) <> 0) then
  begin
    TSPServerAddressEdit.Text := Info.TSPAccessInfo;
    EditChange(nil);
  end;

  CPInterface.FreeCertificateInfoEx(Info);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.AnonimousLDAPCheckBoxClick(Sender: TObject);
var
  Flag: Boolean;

begin
  if AnonimousLDAPCheckBox.Checked then
  begin
    LDAPUserEdit.Clear();
    LDAPPasswordEdit.Clear();
  end;

  Flag := UseLDAPCheckBox.Checked and (not AnonimousLDAPCheckBox.Checked);

  Tab5Split2Image.Visible := Flag;
  LDAPUserEdit.Visible := Flag;
  LDAPUserLabel.Visible := Flag;
  LDAPPasswordEdit.Visible := Flag;
  LDAPPasswordLabel.Visible := Flag;

  ControlClick(nil);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.AuthProxyCheckBoxClick(Sender: TObject);
begin
  Tab2Split2Image.Visible := AuthProxyCheckBox.Checked;
  ProxyLoginEdit.Visible := AuthProxyCheckBox.Checked;
  ProxyLoginLabel.Visible := AuthProxyCheckBox.Checked;
  ProxyPasswordEdit.Visible := AuthProxyCheckBox.Checked;
  ProxyPasswordLabel.Visible := AuthProxyCheckBox.Checked;
  SaveProxyPasswordCheckBox.Visible := AuthProxyCheckBox.Checked;

  if (not AuthProxyCheckBox.Checked) then
  begin
    ProxyLoginEdit.Text := '';
    ProxyPasswordEdit.Text := '';
    SaveProxyPasswordCheckBox.Checked := False;
  end;

  SaveProxyPasswordCheckBoxClick(nil);

  ControlClick(nil);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.AutoDownloadCRLsCheckBoxClick(Sender: TObject);
begin
  if (not AutoDownloadCRLsCheckBox.Checked) then
  begin
    FullAndDeltaCRLsCheckBox.Checked := False;
  end
  else
  begin
    if IsShown then
      FullAndDeltaCRLsCheckBox.Checked := True;
  end;

  FullAndDeltaCRLsCheckBox.Enabled := AutoDownloadCRLsCheckBox.Checked;

  ControlClick(nil);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.CheckCRLsCheckBoxClick(Sender: TObject);
begin
  if (not CheckCRLsCheckBox.Checked) then
  begin
    OnlyOwnCRLsCheckBox.Checked := False;
    FullAndDeltaCRLsCheckBox.Checked := False;
    AutoDownloadCRLsCheckBox.Checked := False;
  end
  else
  begin
    if IsShown then
    begin
      OnlyOwnCRLsCheckBox.Checked := True;
      FullAndDeltaCRLsCheckBox.Checked := True;
      AutoDownloadCRLsCheckBox.Checked := True;
    end;
  end;

  Tab1Split2Image.Visible := CheckCRLsCheckBox.Checked;
  OnlyOwnCRLsCheckBox.Visible := CheckCRLsCheckBox.Checked;
  FullAndDeltaCRLsCheckBox.Visible := CheckCRLsCheckBox.Checked;
  AutoDownloadCRLsCheckBox.Visible := CheckCRLsCheckBox.Checked;

  AutoDownloadCRLsCheckBoxClick(nil);

  ControlClick(nil);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.GetTSCheckBoxClick(Sender: TObject);
begin
  if (IsShown and GetTSCheckBox.Checked) then
  begin
    TSPServerAddressEdit.Text := '';
    TSPServerPortEdit.Text := '80';

    if GetTSCheckBox.Checked then
      TSPServerSetButtonClick(nil);
  end;

  Tab3Split1Image.Visible := GetTSCheckBox.Checked;
  TSPServerAddressEdit.Visible := GetTSCheckBox.Checked;
  TSPServerAddressLabel.Visible := GetTSCheckBox.Checked;
  TSPServerPortEdit.Visible := GetTSCheckBox.Checked;
  TSPServerPortLabel.Visible := GetTSCheckBox.Checked;
  TSPServerSetButton.Visible := GetTSCheckBox.Checked;

  if (not GetTSCheckBox.Checked) then
  begin
    TSPServerAddressEdit.Text := '';
    TSPServerPortEdit.Text := '';
  end;

  ControlClick(nil);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.SaveProxyPasswordCheckBoxClick(Sender: TObject);
begin
  Tab2Split3Image.Visible := SaveProxyPasswordCheckBox.Checked;
  ProxyPasswordEdit.Visible := SaveProxyPasswordCheckBox.Checked;
  ProxyPasswordLabel.Visible := SaveProxyPasswordCheckBox.Checked;

  if (not SaveProxyPasswordCheckBox.Checked) then
    ProxyPasswordEdit.Text := '';

  ControlClick(nil);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.UseCMPCheckBoxClick(Sender: TObject);
begin
  if (IsShown and UseCMPCheckBox.Checked) then
  begin
    CMPServerAddressEdit.Text := '';
    CMPServerPortEdit.Text := '80';

    if UseCMPCheckBox.Checked then
      CMPServerSetButtonClick(nil);
  end;

  Tab6Split1Image.Visible := UseCMPCheckBox.Checked;
  CMPServerAddressEdit.Visible := UseCMPCheckBox.Checked;
  CMPServerAddressLabel.Visible := UseCMPCheckBox.Checked;
  CMPServerPortEdit.Visible := UseCMPCheckBox.Checked;
  CMPServerPortLabel.Visible := UseCMPCheckBox.Checked;
  CMPServerSetButton.Visible := UseCMPCheckBox.Checked;

  if (not UseCMPCheckBox.Checked) then
  begin
    CMPServerAddressEdit.Text := '';
    CMPServerPortEdit.Text := ''
  end;

  ControlClick(nil);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.UseLDAPCheckBoxClick(Sender: TObject);
begin
  if (IsShown and UseLDAPCheckBox.Checked) then
  begin
    LDAPAddressEdit.Clear();
    LDAPPortEdit.Text := '389';
    AnonimousLDAPCheckBox.Checked := True;
    LDAPUserEdit.Clear();
    LDAPPasswordEdit.Clear();

    if UseLDAPCheckBox.Checked then
      LDAPSetButtonClick(nil);
  end;

  Tab5Split1Image.Visible := UseLDAPCheckBox.Checked;
  LDAPAddressEdit.Visible := UseLDAPCheckBox.Checked;
  LDAPAddressLabel.Visible := UseLDAPCheckBox.Checked;
  LDAPPortEdit.Visible := UseLDAPCheckBox.Checked;
  LDAPPortLabel.Visible := UseLDAPCheckBox.Checked;
  LDAPSetButton.Visible := UseLDAPCheckBox.Checked;

  if (not UseLDAPCheckBox.Checked) then
  begin
    LDAPAddressEdit.Text := '';
    LDAPPortEdit.Text := '';
    AnonimousLDAPCheckBox.Visible := False;
  end
  else
  begin
    AnonimousLDAPCheckBox.Visible := True;
  end;

  AnonimousLDAPCheckBoxClick(nil);
  ControlClick(nil);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.UseOCSPCheckBoxClick(Sender: TObject);
begin
  if (IsShown and UseOCSPCheckBox.Checked) then
  begin
    OCSPServerAddressEdit.Text := '';
    OCSPServerPortEdit.Text := '80';
    OCSPBeforeFSCheckBox.Checked := False;

    if UseOCSPCheckBox.Checked then
      OCSPServerSetButtonClick(nil);
  end;

  Tab4Split1Image.Visible := UseOCSPCheckBox.Checked;
  OCSPServerAddressEdit.Visible := UseOCSPCheckBox.Checked;
  OCSPServerAddressLabel.Visible := UseOCSPCheckBox.Checked;
  OCSPServerPortEdit.Visible := UseOCSPCheckBox.Checked;
  OCSPServerPortLabel.Visible := UseOCSPCheckBox.Checked;
  OCSPBeforeFSCheckBox.Visible := UseOCSPCheckBox.Checked;
  OCSPServerSetButton.Visible := UseOCSPCheckBox.Checked;

  if (not UseOCSPCheckBox.Checked) then
  begin
    OCSPServerAddressEdit.Text := '';
    OCSPServerPortEdit.Text := '';
    OCSPBeforeFSCheckBox.Checked := False;
  end;

  ControlClick(nil);
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.UseProxyCheckBoxClick(Sender: TObject);
begin
  if (IsShown and UseProxyCheckBox.Checked) then
  begin
    if (not GetProxyFromInternetSettings()) then
    begin
      ProxyAddressEdit.Text := '';
      ProxyPortEdit.Text := '3128';
    end;

    AuthProxyCheckBox.Checked := True;
    ProxyLoginEdit.Text := '';
    SaveProxyPasswordCheckBox.Checked := False;
    ProxyPasswordEdit.Text := '';
  end;

  Tab2Split1Image.Visible := UseProxyCheckBox.Checked;
  ProxyAddressEdit.Visible := UseProxyCheckBox.Checked;
  ProxyAddressLabel.Visible := UseProxyCheckBox.Checked;
  ProxyPortEdit.Visible := UseProxyCheckBox.Checked;
  ProxyPortLabel.Visible := UseProxyCheckBox.Checked;

  if (not UseProxyCheckBox.Checked) then
  begin
    ProxyAddressEdit.Text := '';
    ProxyPortEdit.Text := '';

    ProxyLoginEdit.Text := '';
    ProxyPasswordEdit.Text := '';
  end;

  if (not UseProxyCheckBox.Checked) then
  begin
    AuthProxyCheckBox.Checked := False;
    AuthProxyCheckBox.Visible := False;
  end
  else
    AuthProxyCheckBox.Visible := True;

  AuthProxyCheckBoxClick(nil);
  ControlClick(nil);
end;

{ ============================================================================== }

function TSettingsForm.GetSettings(): Boolean;
var
  Error: Cardinal;
  FileStore: TEUSettingsFileStore;
  Proxy: TEUSettingsProxy;
  TSP: TEUSettingsTSP;
  OCSP: TEUSettingsOCSP;
  LDAP: TEUSettingsLDAP;
  CMP: TEUSettingsCMP;

begin
  GetSettings := False;

  Error := CPInterface.GetFileStoreSettings(@FileStore.Path,
    @FileStore.CheckCRLs, @FileStore.AutoRefresh, @FileStore.OwnCRLsOnly,
    @FileStore.FullAndDeltaCRLs, @FileStore.AutoDownloadCRLs,
    @FileStore.SaveLoadedCerts, @FileStore.ExpireTime);

  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  FSPathEdit.Text := FileStore.Path;
  CheckCRLsCheckBox.Checked := FileStore.CheckCRLs;
  FSAutoRefreshCheckBox.Checked := FileStore.AutoRefresh;
  OnlyOwnCRLsCheckBox.Checked := FileStore.OwnCRLsOnly;
  FullAndDeltaCRLsCheckBox.Checked := FileStore.FullAndDeltaCRLs;
  AutoDownloadCRLsCheckBox.Checked := FileStore.AutoDownloadCRLs;
  FSSaveFromConnCheckBox.Checked := FileStore.SaveLoadedCerts;
  CertExpirationTimeEdit.Text := IntToStr(FileStore.ExpireTime);

  Error := CPInterface.GetProxySettings(@Proxy.UseProxy, @Proxy.Anonymous,
    @Proxy.Address, @Proxy.Port, @Proxy.User, @Proxy.Password,
    @Proxy.SavePassword);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  UseProxyCheckBox.Checked := Proxy.UseProxy;
  ProxyAddressEdit.Text := Proxy.Address;
  ProxyPortEdit.Text := Proxy.Port;
  AuthProxyCheckBox.Checked := not Proxy.Anonymous;
  ProxyLoginEdit.Text := Proxy.User;
  ProxyPasswordEdit.Text := Proxy.Password;
  SaveProxyPasswordCheckBox.Checked := Proxy.SavePassword;

  Error := CPInterface.GetTSPSettings(@TSP.GetStamps, @TSP.Address,
    @TSP.Port);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  GetTSCheckBox.Checked := TSP.GetStamps;
  TSPServerAddressEdit.Text := TSP.Address;
  TSPServerPortEdit.Text := TSP.Port;

  Error := CPInterface.GetOCSPSettings(@OCSP.UseOCSP, @OCSP.BeforeStore,
    @OCSP.Address, @OCSP.Port);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  UseOCSPCheckBox.Checked := OCSP.UseOCSP;
  OCSPServerAddressEdit.Text := OCSP.Address;
  OCSPServerPortEdit.Text := OCSP.Port;
  OCSPBeforeFSCheckBox.Checked := OCSP.BeforeStore;

  Error := CPInterface.GetLDAPSettings(@LDAP.UseLDAP, @LDAP.Address, @LDAP.Port,
    @LDAP.Anonymous, @LDAP.User, @LDAP.Password);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  UseLDAPCheckBox.Checked := LDAP.UseLDAP;
  LDAPAddressEdit.Text := LDAP.Address;
  LDAPPortEdit.Text := LDAP.Port;
  AnonimousLDAPCheckBox.Checked := LDAP.Anonymous;
  LDAPUserEdit.Text := LDAP.User;
  LDAPPasswordEdit.Text := LDAP.Password;

  Error := CPInterface.GetCMPSettings(@CMP.UseCMP, @CMP.Address, @CMP.Port,
    @CMP.Name);
  if (Error <> EU_ERROR_NONE) then
  begin
    CMP.UseCMP := False;
    StrCopy(CMP.Address, '');
    StrCopy(CMP.Port, '80');
  end;

  UseCMPCheckBox.Checked := CMP.UseCMP;
  CMPServerAddressEdit.Text := CMP.Address;
  CMPServerPortEdit.Text := CMP.Port;

  GetSettings := True;
end;

{ ------------------------------------------------------------------------------ }

function TSettingsForm.SetSettings(blOnlyFStore: Boolean): Boolean;
var
  Error: Cardinal;
  FStore: TEUSettingsFileStore;
  Proxy: TEUSettingsProxy;
  TSP: TEUSettingsTSP;
  OCSP: TEUSettingsOCSP;
  LDAP: TEUSettingsLDAP;
  CMP: TEUSettingsCMP;

begin
  SetSettings := False;

  if (FSPathEdit.Text = '') then
  begin
    MessageBox(Handle, 'Не вказане ім''я каталогу з сертифікатами та СВС',
      'Повідомлення оператору', MB_OK or MB_ICONWARNING);
    if (not blOnlyFStore) then
      TabsListView.Selected := TabsListView.Items.Item[0];

    FSPathEdit.SetFocus();
    Exit;
  end;

  Error := EU_ERROR_UNKNOWN;

  if (not DirectoryExists(FSPathEdit.Text)) then
  begin
    if CreateCertAndCRLCatalog(FSPathEdit.Text) then
    begin
      if (not blOnlyFStore) then
        TabsListView.Selected := TabsListView.Items.Item[0];

      FSPathEdit.SetFocus();
      Exit;
    end;
  end;

  if (CertExpirationTimeEdit.Text = '') then
  begin
    MessageBox(Handle,
      'Не вказаний час зберігання стану перевіреного сертифіката',
      'Повідомлення оператору', MB_OK or MB_ICONWARNING);
    if (not blOnlyFStore) then
      TabsListView.Selected := TabsListView.Items.Item[0];

    CertExpirationTimeEdit.SetFocus();
    Exit;
  end;

  if (not CheckIntegerEdit(CertExpirationTimeEdit, 1, 60 * 60 * 24)) then
  begin
    MessageBox(Handle, 'Час зберігання стану перевіреного сертифіката ' +
      'має невірний формат (повинен бути в діапазоні від ' +
      '1 до 86 400 с (1 доби))', 'Повідомлення оператору',
      MB_OK or MB_ICONWARNING);
    if (not blOnlyFStore) then
      TabsListView.Selected := TabsListView.Items.Item[0];

    CertExpirationTimeEdit.SetFocus();
    Exit;
  end;

  StrCopy(@FStore.Path, PAnsiChar(AnsiString(FSPathEdit.Text)));
  FStore.CheckCRLs := CheckCRLsCheckBox.Checked;
  FStore.AutoRefresh := FSAutoRefreshCheckBox.Checked;
  FStore.OwnCRLsOnly := OnlyOwnCRLsCheckBox.Checked;
  FStore.FullAndDeltaCRLs := FullAndDeltaCRLsCheckBox.Checked;
  FStore.AutoDownloadCRLs := AutoDownloadCRLsCheckBox.Checked;
  FStore.SaveLoadedCerts := FSSaveFromConnCheckBox.Checked;
  FStore.ExpireTime := StrToInt(CertExpirationTimeEdit.Text);

  Error := CPInterface.SetFileStoreSettings(FStore.Path, FStore.CheckCRLs,
    FStore.AutoRefresh, FStore.OwnCRLsOnly, FStore.FullAndDeltaCRLs,
    FStore.AutoDownloadCRLs, FStore.SaveLoadedCerts, FStore.ExpireTime);

  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowErrorMessage(Handle, 'Виникла помилка при записі параметрів файлового ' +
      'сховища у системний реєстр');

    if (not blOnlyFStore) then
      TabsListView.Selected := TabsListView.Items.Item[0];

    Exit;
  end;

  if blOnlyFStore then
  begin
    SetSettings := True;
    Exit;
  end;

  if UseProxyCheckBox.Checked then
  begin

    if (not CheckServerEdit('proxy', ProxyAddressEdit, ProxyPortEdit,
      TabsListView.Items.Item[1])) then
      Exit;

    if (AuthProxyCheckBox.Checked and (ProxyLoginEdit.Text = '')) then
    begin

      MessageBox(Handle, 'Не вказане ім''я користувача proxy-сервера',
        'Повідомлення оператору', MB_OK or MB_ICONWARNING);
      TabsListView.Selected := TabsListView.Items.Item[1];
      ProxyLoginEdit.SetFocus();
      Exit;
    end;

  end;

  Proxy.UseProxy := UseProxyCheckBox.Checked;
  StrCopy(@Proxy.Address, PAnsiChar(AnsiString(ProxyAddressEdit.Text)));
  StrCopy(@Proxy.Port, PAnsiChar(AnsiString(ProxyPortEdit.Text)));
  Proxy.Anonymous := not AuthProxyCheckBox.Checked;
  StrCopy(@Proxy.User, PAnsiChar(AnsiString(ProxyLoginEdit.Text)));
  StrCopy(@Proxy.Password, PAnsiChar(AnsiString(ProxyPasswordEdit.Text)));
  Proxy.SavePassword := SaveProxyPasswordCheckBox.Checked;

  Error := CPInterface.SetProxySettings(Proxy.UseProxy, Proxy.Anonymous,
    @Proxy.Address, @Proxy.Port, @Proxy.User, @Proxy.Password,
    Proxy.SavePassword);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowErrorMessage(Handle, 'Виникла помилка при записі параметрів ' +
      'proxy-сервера у системний реєстр');
    TabsListView.Selected := TabsListView.Items.Item[1];
    Exit;
  end;

  if GetTSCheckBox.Checked then
  begin
    if (not CheckServerEdit('TSP', TSPServerAddressEdit, TSPServerPortEdit,
      TabsListView.Items.Item[2], True)) then
      Exit;
  end;

  TSP.GetStamps := GetTSCheckBox.Checked;
  StrCopy(@TSP.Address, PAnsiChar(AnsiString(TSPServerAddressEdit.Text)));
  StrCopy(@TSP.Port, PAnsiChar(AnsiString(TSPServerPortEdit.Text)));

  Error := CPInterface.SetTSPSettings(TSP.GetStamps, @TSP.Address, @TSP.Port);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowErrorMessage(Handle, 'Виникла помилка при записі параметрів ' +
      'TSP-сервера у системний реєстр');
    TabsListView.Selected := TabsListView.Items.Item[2];
    Exit;
  end;

  if UseOCSPCheckBox.Checked then
  begin
    if (not CheckServerEdit('OCSP', OCSPServerAddressEdit, OCSPServerPortEdit,
      TabsListView.Items.Item[3], True)) then
      Exit;
  end;

  OCSP.UseOCSP := UseOCSPCheckBox.Checked;
  OCSP.BeforeStore := OCSPBeforeFSCheckBox.Checked;
  StrCopy(@OCSP.Address, PAnsiChar(AnsiString(OCSPServerAddressEdit.Text)));
  StrCopy(@OCSP.Port, PAnsiChar(AnsiString(OCSPServerPortEdit.Text)));

  Error := CPInterface.SetOCSPSettings(OCSP.UseOCSP, OCSP.BeforeStore,
    @OCSP.Address, @OCSP.Port);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowErrorMessage(Handle, 'Виникла помилка при записі параметрів ' +
      'OCSP-сервера у системний реєстр');
    TabsListView.Selected := TabsListView.Items.Item[3];
    Exit;
  end;

  if UseLDAPCheckBox.Checked then
  begin
    if (not CheckServerEdit('LDAP', LDAPAddressEdit, LDAPPortEdit,
      TabsListView.Items.Item[4])) then
        Exit;

    if (not AnonimousLDAPCheckBox.Checked) then
    begin

      if (LDAPUserEdit.Text = '') then
      begin
        MessageBox(Handle, 'Не вказане ім''я користувача LDAP-сервера',
          'Повідомлення оператору', MB_OK or MB_ICONWARNING);

        TabsListView.Selected := TabsListView.Items.Item[4];
        LDAPUserEdit.SetFocus();
        Exit;
      end;

      if (LDAPPasswordEdit.Text = '') then
      begin
        MessageBox(Handle, 'Не вказаний пароль доступу до LDAP-сервера',
          'Повідомлення оператору', MB_OK or MB_ICONWARNING);

        TabsListView.Selected := TabsListView.Items.Item[4];
        LDAPPasswordEdit.SetFocus();
        Exit;
      end;
    end;
  end;

  LDAP.UseLDAP := UseLDAPCheckBox.Checked;
  StrCopy(@LDAP.Address, PAnsiChar(AnsiString(LDAPAddressEdit.Text)));
  StrCopy(@LDAP.Port, PAnsiChar(AnsiString(LDAPPortEdit.Text)));
  LDAP.Anonymous := AnonimousLDAPCheckBox.Checked;
  StrCopy(@LDAP.User, PAnsiChar(AnsiString(LDAPUserEdit.Text)));
  StrCopy(@LDAP.Password, PAnsiChar(AnsiString(LDAPPasswordEdit.Text)));

  Error := CPInterface.SetLDAPSettings(LDAP.UseLDAP, @LDAP.Address, @LDAP.Port,
    LDAP.Anonymous, @LDAP.User, @LDAP.Password);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowErrorMessage(Handle, 'Виникла помилка при записі параметрів ' +
      'LDAP-сервера у системний реєстр');
    TabsListView.Selected := TabsListView.Items.Item[4];
    Exit;
  end;

  if UseCMPCheckBox.Checked then
  begin
    if (not CheckServerEdit('CMP', CMPServerAddressEdit, CMPServerPortEdit,
      TabsListView.Items.Item[5])) then
      Exit;
  end;

  CMP.UseCMP := UseCMPCheckBox.Checked;

  StrCopy(@CMP.Address, PAnsiChar(AnsiString(CMPServerAddressEdit.Text)));
  StrCopy(@CMP.Port, PAnsiChar(AnsiString(CMPServerPortEdit.Text)));

  Error := CPInterface.SetCMPSettings(CMP.UseCMP, @CMP.Address, @CMP.Port,
    @CMP.Name);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowErrorMessage(Handle, 'Виникла помилка при записі параметрів ' +
      'CMP-сервера у системний реєстр');
    TabsListView.Selected := TabsListView.Items.Item[5];
    Exit;
  end;

  NotGot := False;
  SetSettings := True;
end;

{ ------------------------------------------------------------------------------ }

procedure TSettingsForm.SetDefaults();
begin
  CheckCRLsCheckBox.Checked := False;
  UseProxyCheckBox.Checked := False;
  GetTSCheckBox.Checked := False;
  UseOCSPCheckBox.Checked := False;
  UseLDAPCheckBox.Checked := False;
  UseCMPCheckBox.Checked := False;

  FSPathEdit.Text := '';
  FSAutoRefreshCheckBox.Checked := True;
  OnlyOwnCRLsCheckBox.Checked := False;
  FullAndDeltaCRLsCheckBox.Checked := False;
  AutoDownloadCRLsCheckBox.Checked := False;
  FSSaveFromConnCheckBox.Checked := True;

  if (not IsCA) then
  begin
    CertExpirationTimeEdit.Text := '3600';
  end
  else
  begin
    CertExpirationTimeEdit.Text := '1';
  end;
end;

{ ============================================================================== }

function TSettingsForm.CreateCertAndCRLCatalog(Name: String): Boolean;
var
  Res: ShortInt;

begin

  Res := MessageBox(Handle, 'Каталог з сертифікатами та СВС не існує або ' +
    'немає доступу до нього. Створити його?', 'Повідомлення оператору',
    MB_YESNO or MB_ICONWARNING);

  if (Res <> IDYES) then
  begin
    CreateCertAndCRLCatalog := False;
    Exit;
  end;

  try
    if ForceDirectories(Name) then
    begin
      CreateCertAndCRLCatalog := True;
    end
    else
    begin
      MessageBox(Handle, 'Виникла помилка при створенні ' +
        'каталогу з сертифікатами та СВС', 'Повідомлення оператору',
        MB_OK or MB_ICONWARNING);

      CreateCertAndCRLCatalog := False;
    end;
  except
    MessageBox(Handle, 'Виникла помилка при створенні ' +
      'каталогу з сертифікатами та СВС', 'Повідомлення оператору',
      MB_OK or MB_ICONWARNING);

      CreateCertAndCRLCatalog := False;
  end;
end;

{ ------------------------------------------------------------------------------ }

function TSettingsForm.CheckIntegerEdit(Edit: TEdit; Min: Integer;
  Max: Integer): Boolean;
begin
  CheckIntegerEdit := False;

  try
    if ((StrToInt(Edit.Text) > Max) or (StrToInt(Edit.Text) < Min)) then
      Exit;
  except
    Exit;
  end;

  CheckIntegerEdit := True;
end;

{ ------------------------------------------------------------------------------ }

function TSettingsForm.CheckServerEdit(ServerName: AnsiString;
  Name, Port: TEdit; Item: TListItem; EmptyFields: Boolean = False): Boolean;
var
  MBResult: Integer;

begin
  CheckServerEdit := False;

  if (Name.Text = '') then
  begin
    if EmptyFields then
    begin
       MBResult := MessageBoxA(Handle, PAnsiChar(AnsiString(
          'Не вказане ім''я або ІР-адреса ' + ServerName + '-сервера. Продовжити?')),
          'Повідомлення оператору',
          MB_YESNO or MB_ICONWARNING);
      case MBResult of
        IDNO:
          begin
           TabsListView.Selected := Item;
           Name.SetFocus();
           Exit;
          end;
      end;
    end
    else
    begin
        MessageBoxA(Handle, PAnsiChar(AnsiString('Не вказане ім''я або ІР-адреса '
          + ServerName + '-сервера')), 'Повідомлення оператору',
          MB_OK or MB_ICONWARNING);
        TabsListView.Selected := Item;
        Name.SetFocus();
        Exit;
    end;
  end;

  if (Port.Text = '') then
  begin
    if EmptyFields then
    begin
      Port.Text := '80';
    end
    else
    begin
      MessageBoxA(Handle, PAnsiChar(AnsiString('Не вказаний номер TCP-порта ' +
        ServerName + '-сервера')), 'Повідомлення оператору',
        MB_OK or MB_ICONWARNING);

      TabsListView.Selected := Item;

      Port.SetFocus();
      Exit;
    end;
  end;

  if (not CheckIntegerEdit(Port, 1, 65535)) then
  begin
    MessageBoxA(Handle, PAnsiChar(AnsiString('Номер TCP-порта ' + ServerName +
      '-сервера має невірний формат(повинен бути в діапазоні від 1 до 65 535)')
      ), 'Повідомлення оператору', MB_OK or MB_ICONWARNING);

    TabsListView.Selected := Item;
    Port.SetFocus();
    Exit;
  end;

  CheckServerEdit := True;
end;

{ ------------------------------------------------------------------------------ }

function TSettingsForm.GetProxyFromInternetSettings(): Boolean;
var
  Registry: TRegistry;
  ProxyServer: TStringList;
  ProxyServerStr: String;

begin
  GetProxyFromInternetSettings := False;
  Registry := TRegistry.Create();

  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if (not Registry.OpenKey
      ('Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings', False))
    then
    begin
      Registry.Destroy();
      Exit;
    end;

    if (not Registry.ReadBool('ProxyEnable')) then
    begin
      Registry.CloseKey();
      Exit;
    end;

    ProxyServerStr := Registry.ReadString('ProxyServer');
    Registry.CloseKey();
  finally
    Registry.Destroy();
  end;

  try
    if (Length(ProxyServerStr) <> 0) then
    begin
      ProxyServer := TStringList.Create;
      if ExtractStrings([':'], [' '], PChar(ProxyServerStr), ProxyServer) = 2 then
      begin
        ProxyPortEdit.Text := ProxyServer[1];
        ProxyAddressEdit.Text := ProxyServer[0];
        GetProxyFromInternetSettings := True;
      end;
    end;
  finally
    if (ProxyServer <> nil) then
      ProxyServer.Destroy();
  end;
end;

{ ------------------------------------------------------------------------------ }

function TSettingsForm.IsServerDNSNameExist(DNSNames, DNSName: String): Boolean;
var
  DNSNamesList: TStringList;
  Index, Count: Integer;

begin
  IsServerDNSNameExist := False;

  if ((Length(DNSName) = 0) or (Length(DNSNames) = 0)) then
    Exit;

  DNSNamesList := TStringList.Create();

  Count := ExtractStrings([SettingsAddressSplitter], [' '],
    PChar(DNSNames), DNSNamesList);

  Index := 0;

  while (Index < Count) do
  begin
    if (AnsiCompareStr(DNSNamesList[Index], DNSName) = 0) then
    begin
      IsServerDNSNameExist := True;
      Exit;
    end;

    Index := Index + 1;
  end;

  DNSNamesList.Destroy();
end;

{ ============================================================================== }

end.
