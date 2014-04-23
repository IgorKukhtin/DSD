program EUSignTestP;

uses
  Forms,
  Main in 'Main.pas' {TestForm},
  Certificate in 'Certificate.pas' {CertificateForm},
  Certificates in 'Certificates.pas' {CertificatesForm},
  CRL in 'CRL.pas' {CRLForm},
  CRLs in 'CRLs.pas' {CRLsForm},
  EUSignCP in 'EUSignCP.pas',
  KeyMedia in 'KeyMedia.pas' {KeyMediaFrame: TFrame},
  ReadPK in 'ReadPK.pas' {ReadPKForm},
  Settings in 'Settings.pas' {SettingsForm},
  ImageLink in 'ImageLink.pas' {ImageLinkFrame: TFrame},
{$if CompilerVersion > 19}
  ScreenKeyboard in 'ScreenKeyboard.pas' {ScreenKeyboardForm},
{$ifend}
  CMSInfo in 'CMSInfo.pas' {CMSInfoForm},
  EUSignCPOwnUI in 'EUSignCPOwnUI.pas',
  GenerateKeys in 'GenerateKeys.pas' {GenerateKeysForm},
  ChangePassword in 'ChangePassword.pas' {ChangePasswordForm},
  CRInfo in 'CRInfo.pas' {CRForm},
  CertAndCRLFunctionsFrame in 'TestFrames\CertAndCRLFunctionsFrame.pas' {CertAndCRLsFrame: TFrame},
  EnvelopeFunctionsFrame in 'TestFrames\EnvelopeFunctionsFrame.pas' {EncrFunctionsFrame: TFrame},
  PrivateKeyFunctionsFrame in 'TestFrames\PrivateKeyFunctionsFrame.pas' {PKFunctionsFrame: TFrame},
  SessionFunctionsFrame in 'TestFrames\SessionFunctionsFrame.pas' {TestSessionFrame: TFrame},
  SignFunctionsFrame in 'TestFrames\SignFunctionsFrame.pas' {SignFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ІІТ Користувач ЦСК-1.3. Бібліотека підпису';
  Application.CreateForm(TTestForm, TestForm);
{$if CompilerVersion > 19}
  Application.CreateForm(TScreenKeyboardForm, ScreenKeyboardForm);
{$ifend}
  Application.CreateForm(TChangePasswordForm, ChangePasswordForm);
  Application.Run;
end.
