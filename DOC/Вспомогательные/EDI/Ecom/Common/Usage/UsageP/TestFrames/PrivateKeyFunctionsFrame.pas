unit PrivateKeyFunctionsFrame;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  EUSignCP, EUSignCPOwnUI, Certificate;

{ ------------------------------------------------------------------------------ }

type
  TPKFunctionsFrame = class(TFrame)
    PKOpenDialog: TOpenDialog;
    PKParamsPanel: TPanel;
    PKParamsUnderlineImage: TImage;
    PKFromFileCheckBox: TCheckBox;
    PKReadPanel: TPanel;
    PKReadUnderlineImage: TImage;
    PKCertificateButton: TButton;
    PKFromFileGroupBox: TGroupBox;
    PKFileLabel: TLabel;
    PKFileEdit: TEdit;
    PKPasswordLabel: TLabel;
    PKPasswordEdit: TEdit;
    PKChangeFileButton: TButton;
    PKReadTitleLabel: TLabel;
    PKParamsTitleLabel: TLabel;
    PKFunctionsPanel: TPanel;
    PKFunctionsUnderlineImage: TImage;
    PKFunctionsTitleLabel: TLabel;
    PKReadButton: TButton;
    PKChangePasswordButton: TButton;
    PKBackupButton: TButton;
    PKGenButton: TButton;
    PKDestroyButton: TButton;
    procedure PKChangePasswordButtonClick(Sender: TObject);
    procedure PKBackupButtonClick(Sender: TObject);
    procedure PKGenButtonClick(Sender: TObject);
    procedure PKDestroyButtonClick(Sender: TObject);
    procedure PKReadButtonClick(Sender: TObject);
    procedure PKCertificateButtonClick(Sender: TObject);
    procedure PKChangeFileButtonClick(Sender: TObject);
    procedure PKFromFileCheckBoxClick(Sender: TObject);

  private
     KeyMedia: TEUKeyMedia;
     CPInterface: PEUSignCP;
     UseOwnUI: Boolean;
     CertOwnerInfo: TEUCertOwnerInfo;
     procedure PKFromFileConfigControls(Enabled: Boolean; Clear: Boolean = True);
     procedure ChangeControlsState(Enabled: Boolean);
     function PKReadFromFile(): Boolean;
     function PKReadFromKM(): Boolean;

  public
    procedure Initialize(CPInterface: PEUSignCP; UseOwnUI: Boolean);
    procedure Deinitialize();
    procedure WillShow();

  end;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ============================================================================== }

procedure TPKFunctionsFrame.ChangeControlsState(Enabled: Boolean);
begin
  PKFromFileCheckBox.Enabled := Enabled;
  PKChangeFileButton.Enabled := Enabled;
  PKReadButton.Enabled := Enabled;
  PKChangePasswordButton.Enabled := Enabled;
  PKBackupButton.Enabled := Enabled;
  PKGenButton.Enabled := Enabled;
  PKDestroyButton.Enabled := Enabled;

  PKFromFileCheckBox.Checked := PKFromFileCheckBox.Checked and Enabled;
  PKFromFileConfigControls(PKFromFileCheckBox.Checked,
    (not PKFromFileCheckBox.Checked));
end;

{ ------------------------------------------------------------------------------ }

procedure TPKFunctionsFrame.Initialize(CPInterface: PEUSignCP; UseOwnUI: Boolean);
begin
  self.CPInterface := CPInterface;
  self.UseOwnUI := UseOwnUI;

  ChangeControlsState(True);
end;

{ ------------------------------------------------------------------------------ }

procedure TPKFunctionsFrame.Deinitialize();
begin
  if CPInterface.IsPrivateKeyReaded() then
  begin
    CPInterface.FreeCertOwnerInfo(@CertOwnerInfo);
    CPInterface.ResetOperation();
    CPInterface.ResetPrivateKey();
    PKCertificateButton.Enabled := False;
    PKReadButton.Caption := 'Зчитати ключ...';
  end;

  ChangeControlsState(False);

  self.CPInterface := nil;
  self.UseOwnUI := false;
end;

{ ------------------------------------------------------------------------------ }

procedure TPKFunctionsFrame.WillShow();
var
  Enabled: Boolean;

begin
  Enabled := ((CPInterface <> nil) and CPInterface.IsInitialized);
  ChangeControlsState(Enabled);
end;

{ ============================================================================== }

procedure TPKFunctionsFrame.PKChangeFileButtonClick(Sender: TObject);
begin
	if (not PKOpenDialog.Execute()) then
	  Exit;

  PKFileEdit.Text := PKOpenDialog.FileName;
end;

{ ------------------------------------------------------------------------------ }

procedure TPKFunctionsFrame.PKFromFileConfigControls(Enabled: Boolean;
  Clear: Boolean = True);
begin
  if Enabled then
  begin
    PKParamsPanel.Height := PKFromFileGroupBox.Top + PKFromFileGroupBox.Height + 6;
  end
  else
  begin
    PKParamsPanel.Height := PKFromFileCheckBox.Top + PKFromFileCheckBox.Height + 6;
  end;

  PKReadPanel.Top := PKParamsPanel.Top + PKParamsPanel.Height;
  PKFunctionsPanel.Top := PKReadPanel.Top + PKReadPanel.Height;
  PKFromFileGroupBox.Visible := Enabled;

  if Clear then
  begin
    PKPasswordEdit.Text := '';
    PKFileEdit.Text := '';
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TPKFunctionsFrame.PKFromFileCheckBoxClick(Sender: TObject);
begin
  PKFromFileConfigControls(PKFromFileCheckBox.Checked, True);
end;

{ ============================================================================== }

function TPKFunctionsFrame.PKReadFromFile(): Boolean;
var
  Error: Cardinal;
  PKFile: AnsiString;
  Password: AnsiString;

begin
  PKReadFromFile := False;
  PKFile := PKFileEdit.Text;
  Password := PKPasswordEdit.Text;

  if (PKFile = '') then
  begin
    MessageBoxA(Handle,
    'Не вказано файл з особистим ключем',
     'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if (Password = '') then
  begin
    MessageBoxA(Handle,
    'Не вказано пароль до файлу з особистим ключем',
     'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  Error := CPInterface.ReadPrivateKeyFile(PAnsiChar(PKFile),
    PAnsiChar(Password), @CertOwnerInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUSignCPOwnUI.EUShowError(Handle, Error);
    Exit;
  end;

  PKReadFromFile := True;
end;

{ ------------------------------------------------------------------------------ }

function TPKFunctionsFrame.PKReadFromKM(): Boolean;
var
  Error: Cardinal;

begin
  PKReadFromKM := False;

  if UseOwnUI then
  begin
    Error := EUSignCPOwnUI.EUGetPrivateKeyMedia(Handle, '',
      '', CPInterface, @KeyMedia);
    if (Error <> EU_ERROR_NONE) then
      Exit;

    Error := CPInterface.ReadPrivateKey(@KeyMedia, @CertOwnerInfo);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUSignCPOwnUI.EUShowError(Handle, Error);
      Exit;
    end;
  end
  else
  begin
    Error := CPInterface.GetPrivateKeyMedia(@KeyMedia);
    if (Error <> EU_ERROR_NONE) then
      Exit;

    Error := CPInterface.ReadPrivateKey(@KeyMedia, @CertOwnerInfo);
    if (Error <> EU_ERROR_NONE) then
      Exit;
  end;

  PKReadFromKM := True;
end;

{ ------------------------------------------------------------------------------ }

procedure TPKFunctionsFrame.PKReadButtonClick(Sender: TObject);
var
  IsKeyReaded: Boolean;

begin
  IsKeyReaded := CPInterface.IsPrivateKeyReaded();

  if (not IsKeyReaded) then
  begin
    if PKFromFileCheckBox.Checked then
    begin
     if (not PKReadFromFile()) then
      Exit;
    end
    else
    begin
     if (not PKReadFromKM()) then
      Exit;
    end;

    PKReadButton.Caption := 'Зтерти ключ...';
    IsKeyReaded := True;
  end
  else
  begin
    CPInterface.FreeCertOwnerInfo(@CertOwnerInfo);
    CPInterface.ResetOperation();
    CPInterface.ResetPrivateKey();

    PKReadButton.Caption := 'Зчитати ключ...';
    PKPasswordEdit.Text := '';
    IsKeyReaded := False;
  end;

  PKCertificateButton.Enabled := IsKeyReaded;
  PKFromFileCheckBox.Enabled := (not IsKeyReaded);
end;

{ ------------------------------------------------------------------------------ }

procedure TPKFunctionsFrame.PKCertificateButtonClick(Sender: TObject);
var
  Error: Cardinal;
  CertUserInfo: PEUCertInfoEx;

begin
  if (not CPInterface.IsPrivateKeyReaded()) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано', 'Повідомлення оператору',
      MB_ICONERROR);
    Exit;
  end;

  if UseOwnUI then
  begin
    Error := CPInterface.EnumOwnCertificates(0, @CertUserInfo);
    if (Error <> EU_ERROR_NONE) then
    begin
      MessageBoxA(Handle, 'Помилка при отриманні інформації про сертифікат',
        'Повідомлення оператору', MB_ICONERROR);
      Exit;
    end;

    EUShowCertificate(WindowHandle, 'Власний сертифікат', CPInterface,
      CertUserInfo, CertStatusDefault, true);

    CPInterface.FreeCertificateInfoEx(CertUserInfo);
  end
  else
    CPInterface.ShowOwnCertificate();

end;

{ ============================================================================== }

procedure TPKFunctionsFrame.PKBackupButtonClick(Sender: TObject);
var
  IsHardware: LongBool;
  IsKeyExists: LongBool;
  Error: Cardinal;
  Choice: Integer;
  SourceKeyMedia, TargetKeyMedia: TEUKeyMedia;

begin
  if (not UseOwnUI) then
  begin
    CPInterface.BackupPrivateKey(nil, nil);
    Exit;
  end;

  if (CPInterface.IsPrivateKeyReaded and (not PKFromFileCheckBox.Checked)) then
  begin
      Error := CPInterface.IsHardwareKeyMedia(@KeyMedia, @IsHardware);
      if (Error <> EU_ERROR_NONE) then
      begin
        EUSignCPOwnUI.EUShowError(Handle, Error);
        Exit;
      end;

      if IsHardware then
      begin
        EUSignCPOwnUI.EUShowErrorMessage(Handle,
          'Носій ключової інформації не підтримує резервне копіювання ключа');
        Exit;
      end;

      StrCopy(SourceKeyMedia.Password, KeyMedia.Password);
      SourceKeyMedia.TypeIndex := KeyMedia.TypeIndex;
      SourceKeyMedia.DeviceIndex := KeyMedia.DeviceIndex;
  end
  else
  begin
    while True do
    begin
      Error := EUSignCPOwnUI.EUGetPrivateKeyMedia(Handle,
        'Резервне копіювання ключа',
        'Встановіть носій ключової інформації з якого' +
        ' необхідно провести резервне копіювання особистого ключа',
        CPInterface, @SourceKeyMedia);
      if (Error <> EU_ERROR_NONE) then
        Exit;

      Error := CPInterface.IsHardwareKeyMedia(@SourceKeyMedia, @IsHardware);
      if (Error <> EU_ERROR_NONE) then
      begin
        EUSignCPOwnUI.EUShowError(Handle, Error);
        Exit;
      end;

      if IsHardware then
      begin
         Choice := MessageBox(Handle,
          'Носій ключової інформації не підтримує резервне' +
          ' копіювання ключа, обрати інший?',
          'Повідомлення оператору', MB_YESNOCANCEL or MB_ICONWARNING);
        if (Choice <> IDYES) then
          Exit;
      end
      else
        break;
    end;
  end;

  while True do
  begin
    Error := EUSignCPOwnUI.EUGetPrivateKeyMedia(Handle,
      'Резервне копіювання ключа',
      'Встановіть носій ключової інформації на який необхідно' +
      ' провести резервне копіювання особистого ключа',
      CPInterface, @TargetKeyMedia);
    if (Error <> EU_ERROR_NONE) then
      Exit;

    Error := CPInterface.IsHardwareKeyMedia(@TargetKeyMedia, @IsHardware);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUSignCPOwnUI.EUShowError(Handle, Error);
      Exit;
    end;

    if IsHardware then
    begin
      Choice := MessageBox(Handle,
        'Носій ключової інформації не підтримує резервне' +
        ' копіювання ключа, обрати інший?',
        'Повідомлення оператору', MB_YESNOCANCEL or MB_ICONWARNING);
      if (Choice <> IDYES) then
        Exit;
    end
    else
    begin
      Error := CPInterface.IsPrivateKeyExists(@TargetKeyMedia, @IsKeyExists);

      if (Error <> EU_ERROR_NONE) then
      begin
        EUSignCPOwnUI.EUShowError(Handle, Error);
        Exit;
      end;

      if (not IsKeyExists) then
        break;

      Choice := MessageBox(Handle,
        'Носій ключової інформації вже має особистий ключ, перезаписати його?',
        'Повідомлення оператору', MB_YESNOCANCEL or MB_ICONWARNING);
      if (Choice <> IDYES) then
        Exit;

      break;
    end;
  end;

  Error := CPInterface.BackupPrivateKey(@SourceKeyMedia, @TargetKeyMedia);
  if (Error <> EU_ERROR_NONE) then
    EUSignCPOwnUI.EUShowError(Handle, Error);
end;

{ ------------------------------------------------------------------------------ }

procedure TPKFunctionsFrame.PKChangePasswordButtonClick(Sender: TObject);
begin
  if (not UseOwnUI) then
  begin
    CPInterface.ChangePrivateKeyPassword(nil, nil);
    Exit;
  end;

  if (CPInterface.IsPrivateKeyReaded and
    (not PKFromFileCheckBox.Checked)) then
  begin
    EUSignCPOwnUI.EUChangePrivateKeyPassword(Handle, '', CPInterface, @KeyMedia);
  end
  else
    EUSignCPOwnUI.EUChangePrivateKeyPassword(Handle, '', CPInterface, nil);
end;

{ ------------------------------------------------------------------------------ }

procedure TPKFunctionsFrame.PKDestroyButtonClick(Sender: TObject);
var
  Error: Cardinal;
  KeyMediaIn: TEUKeyMedia;
  Choice: Integer;

begin
  if (not UseOwnUI) then
  begin
    CPInterface.DestroyPrivateKey(nil);
    Exit;
  end;

  if (CPInterface.IsPrivateKeyReaded and
    (not PKFromFileCheckBox.Checked)) then
  begin
    Choice := MessageBox(Handle,
          'Знищити поточний особистий ключ?',
          'Повідомлення оператору', MB_YESNOCANCEL or MB_ICONWARNING);
        if (Choice <> IDYES) then
          Exit;
    PKReadButtonClick(nil);
    Error := CPInterface.DestroyPrivateKey(@KeyMedia);
  end
  else
  begin
    Error := EUSignCPOwnUI.EUGetPrivateKeyMedia(Handle,'Знищення ключа', '',
        CPInterface, @KeyMediaIn);
    if (Error <> EU_ERROR_NONE) then
      Exit;

   Error := CPInterface.DestroyPrivateKey(@KeyMediaIn);
   end;

   if (Error <> EU_ERROR_NONE) then
   begin
    EUSignCPOwnUI.EUShowError(Handle, Error);
   end
   else
    MessageBox(Handle, 'Виконано успішно',
      'Повідомлення оператору', MB_ICONINFORMATION);
end;

{ ------------------------------------------------------------------------------ }

procedure TPKFunctionsFrame.PKGenButtonClick(Sender: TObject);
begin
  EUSignCPOwnUI.EUShowGenerateKeys(Handle, '', CPInterface, True);
end;

{ ============================================================================== }

end.
