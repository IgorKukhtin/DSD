unit CertAndCRLFunctionsFrame;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes,
  Forms, Dialogs, StdCtrls, ExtCtrls, Graphics, Controls,
  EUSignCP, EUSignCPOwnUI, Certificates, Certificate;

{ ------------------------------------------------------------------------------ }

type
  TCertAndCRLsFrame = class(TFrame)
    ShowCertAndCRLPanel: TPanel;
    ShowCertAndCRLUnderlineImage: TImage;
    EncryptFileTitleLabel: TLabel;
    ShowCertificatesButton: TButton;
    ShowCRLButton: TButton;
    CheckCertPanel: TPanel;
    CheckCertUnderlineImage: TImage;
    CheckCertLabel: TLabel;
    CheckCertTitleLabel: TLabel;
    CheckCertFileButton: TButton;
    CheckCertFileEdit: TEdit;
    ChooseCheckCertFileButton: TButton;
    UpdateCertStorageButton: TButton;
    SearchCertPanel: TPanel;
    SearchCertUnderlineImage: TImage;
    SearchCertTitleLabel: TLabel;
    SearchCertButtonByNBUCode: TButton;
    TargetFileOpenDialog: TOpenDialog;
    SearchCertButtonByEmail: TButton;
    procedure UpdateCertStorageButtonClick(Sender: TObject);
    procedure ShowCertificatesButtonClick(Sender: TObject);
    procedure ShowCRLButtonClick(Sender: TObject);
    procedure ChooseCheckCertFileButtonClick(Sender: TObject);
    procedure CheckCertFileButtonClick(Sender: TObject);
    procedure SearchCertButtonByEmailClick(Sender: TObject);
    procedure SearchCertButtonByNBUCodeClick(Sender: TObject);

  private
    CPInterface: PEUSignCP;
    UseOwnUI: Boolean;
    procedure ChangeControlsState(Enabled: Boolean);

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

procedure TCertAndCRLsFrame.ChangeControlsState(Enabled: Boolean);
begin
  CheckCertFileEdit.Enabled := Enabled;
  ChooseCheckCertFileButton.Enabled := Enabled;
  ShowCertificatesButton.Enabled := Enabled;
  ShowCRLButton.Enabled := Enabled;
  CheckCertFileButton.Enabled := Enabled;
  UpdateCertStorageButton.Enabled := Enabled;
  SearchCertButtonByNBUCode.Enabled := Enabled;
  SearchCertButtonByEmail.Enabled := Enabled;
end;

{ ------------------------------------------------------------------------------ }

procedure TCertAndCRLsFrame.Initialize(CPInterface: PEUSignCP; UseOwnUI: Boolean);
begin
  self.CPInterface := CPInterface;
  self.UseOwnUI := UseOwnUI;
  ChangeControlsState(True);
end;

{ ------------------------------------------------------------------------------ }

procedure TCertAndCRLsFrame.Deinitialize();
begin
  ChangeControlsState(False);
  self.CPInterface := nil;
  self.UseOwnUI := false;
end;

{ ------------------------------------------------------------------------------ }

procedure TCertAndCRLsFrame.WillShow();
var
  Enabled: Boolean;

begin
  Enabled := ((CPInterface <> nil) and CPInterface.IsInitialized);
  ChangeControlsState(Enabled);
end;

{ ============================================================================== }

procedure TCertAndCRLsFrame.UpdateCertStorageButtonClick(Sender: TObject);
var
  Error: Cardinal;
  FSReload: LongBool;

begin
  FSReload := (MessageBox(Handle,
    'Перечитати повністю сертифікати та СВС в файловому сховищі?',
    'Повідомлення оператору', MB_YESNO or MB_ICONWARNING) = IDYES);

  Error := CPInterface.RefreshFileStore(FSReload);
  if (Error <> EU_ERROR_NONE) then
    EUShowError(Handle, Error);
end;

{ ------------------------------------------------------------------------------ }

procedure TCertAndCRLsFrame.ShowCertificatesButtonClick(Sender: TObject);
begin
  if UseOwnUI then
  begin
    EUShowCertificates(WindowHandle, '', CPInterface, 'Сертифікати',
      CertTypeEndUser, nil);
  end
  else
    CPInterface.ShowCertificates();
end;

{ ------------------------------------------------------------------------------ }

procedure TCertAndCRLsFrame.ShowCRLButtonClick(Sender: TObject);
begin
  if UseOwnUI then
  begin
    EUShowCRLs(WindowHandle, '', CPInterface);
  end
  else
    CPInterface.ShowCRLs();
end;

{ ============================================================================== }

procedure TCertAndCRLsFrame.ChooseCheckCertFileButtonClick(Sender: TObject);
begin
  if (not TargetFileOpenDialog.Execute(Handle)) then
    Exit;

   CheckCertFileEdit.Text := TargetFileOpenDialog.FileName;
end;

{ ------------------------------------------------------------------------------ }

procedure TCertAndCRLsFrame.CheckCertFileButtonClick(Sender: TObject);
var
  FileName: AnsiString;
  FileStream: TFileStream;
  Error: Cardinal;
  CertData: PByte;
  CertDataSize: Int64;

begin
  FileName := CheckCertFileEdit.Text;
  if (FileName = '') then
  begin
    MessageBox(Handle, 'Сертифікат для перевірки не обрано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  FileStream := nil;
  CertData := nil;

  try
    FileStream := TFileStream.Create(FileName, fmOpenRead);
    FileStream.Seek(0, soBeginning);

    CertDataSize := FileStream.Size;
    CertData := GetMemory(CertDataSize);
    FileStream.Read(CertData^, CertDataSize);

    Error := CPInterface.CheckCertificate(CertData,
      Cardinal(CertDataSize));

    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
    end
    else
      MessageBox(Handle, 'Сертифікат успішно перевірено',
        'Повідомлення оператору', MB_ICONINFORMATION);

  finally
    if (FileStream <> nil) then
      FileStream.Destroy;
    if (CertData <> nil) then
      FreeMemory(CertData);
  end;
end;

{ ============================================================================== }

procedure TCertAndCRLsFrame.SearchCertButtonByEmailClick(Sender: TObject);
var
  Email: AnsiString;
  Error: Cardinal;
  OnTime: SYSTEMTIME;
  Issuer: array [0..(EU_ISSUER_MAX_LENGTH - 1)] of AnsiChar;
  Serial: array [0..(EU_SERIAL_MAX_LENGTH - 1)] of AnsiChar;
  Info: PEUCertInfoEx;

begin
  Email := AnsiString(InputBox(string('Пошук сертифіката'),
    string('Введіть E-mail адресу'), ''));
  if (Email = '') then
    Exit;

  DateTimeToSystemTime(Now(), OnTime);

  Error := CPInterface.GetCertificateByEMail(PAnsiChar(Email),
    EU_CERT_KEY_TYPE_DSTU4145, EU_KEY_USAGE_DIGITAL_SIGNATURE,
    @OnTime, @Issuer, @Serial);

  if (Error <> EU_ERROR_NONE) then
  begin
    EUSignCPOwnUI.EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.GetCertificateInfoEx(@Issuer, @Serial, @Info);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUSignCPOwnUI.EUShowError(Handle, Error);
    Exit;
  end;

  EUSignCPOwnUI.EUShowCertificate(Handle, 'Сертифікат знайдений за Email',
    CPInterface, Info, CertStatusDefault, False);

  CPInterface.FreeCertificateInfoEx(Info);
end;

{ ------------------------------------------------------------------------------ }

procedure TCertAndCRLsFrame.SearchCertButtonByNBUCodeClick(Sender: TObject);
var
  NBUCode: AnsiString;
  Error: Cardinal;
  OnTime: SYSTEMTIME;
  Issuer: array [0..(EU_ISSUER_MAX_LENGTH - 1)] of AnsiChar;
  Serial: array [0..(EU_SERIAL_MAX_LENGTH - 1)] of AnsiChar;
  Info: PEUCertInfoEx;

begin
  NBUCode := AnsiString(InputBox('Пошук сертифіката', 'Введіть код НБУ', ''));
  if (NBUCode = '') then
    Exit;

  DateTimeToSystemTime(Now(), OnTime);

  Error := CPInterface.GetCertificateByNBUCode(PAnsiChar(NBUCode),
    EU_CERT_KEY_TYPE_DSTU4145, EU_KEY_USAGE_DIGITAL_SIGNATURE, @OnTime, @Issuer,
    @Serial);

  if (Error <> EU_ERROR_NONE) then
  begin
    EUSignCPOwnUI.EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.GetCertificateInfoEx(@Issuer, @Serial, @Info);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUSignCPOwnUI.EUShowError(Handle, Error);
    Exit;
  end;

  EUSignCPOwnUI.EUShowCertificate(Handle, 'Сертифікат знайдений за кодом НБУ',
    CPInterface, Info, CertStatusDefault, False);

  CPInterface.FreeCertificateInfoEx(Info);
end;

{ ============================================================================== }

end.
