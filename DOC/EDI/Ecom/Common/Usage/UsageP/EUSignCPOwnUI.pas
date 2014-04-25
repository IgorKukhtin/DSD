unit EUSignCPOwnUI;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Classes, Controls, Forms, ShlObj,
  EUSignCP,
  Certificate, Certificates, Settings, CMSInfo, CRL, CRLs, KeyMedia, ReadPK,
  GenerateKeys, ChangePassword,
  CRInfo;

{ ============================================================================== }

procedure EUInitializeOwnUI(ACPInterface: PEUSignCP; AIsUI: Boolean);
procedure EUDeinitializeOwnUI();
function  EUUseOwnUI(): Boolean;

{ ------------------------------------------------------------------------------ }

procedure EUShowError(Handle: Cardinal; Error: Cardinal);
procedure EUShowErrorMessage(Handle: Cardinal; Error: PAnsiChar);
function EUShowMessage(Handle: Cardinal; Text, Title: PAnsiChar;
  uType: Cardinal; DefaultID: ShortInt = IDNo): Integer;

{ ============================================================================== }

function EUGetPrivateKeyMedia(Parent: HWND; Caption: AnsiString;
  SubTitle: AnsiString; CPInterface: PEUSignCP; KeyMedia: PEUKeyMedia): Cardinal;

{ ------------------------------------------------------------------------------ }

function EUReadPrivateKey(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; CertOwnerInfo: PEUCertOwnerInfo): Cardinal;

{ ------------------------------------------------------------------------------ }

function EUChangePrivateKeyPassword(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; KeyMedia: PEUKeyMedia): Cardinal;

{ ------------------------------------------------------------------------------ }

function EUShowCertificate(Parent: HWND; Caption: AnsiString;
 CPInterface: PEUSignCP; Info: PEUCertInfoEx;
 CertStatus: CertificateStatus; IsUserCertificate: Boolean): Cardinal;

{ ------------------------------------------------------------------------------ }

function EUShowCertificates(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; CertCaption: AnsiString; CertType: CertificatesType;
  Info: PPEUCertInfoEx; PublicKeyType: Cardinal = EU_CERT_KEY_TYPE_UNKNOWN;
  KeyUsage: Cardinal = EU_KEY_USAGE_UNKNOWN): Boolean;

{ ------------------------------------------------------------------------------ }

function EUSelectCertificates(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; CertCaption: AnsiString; CertType: CertificatesType;
  CertificatesInfo: PEUCertificatesUniqueInfo;
  PublicKeyType: Cardinal = EU_CERT_KEY_TYPE_UNKNOWN;
  KeyUsage: Cardinal = EU_KEY_USAGE_UNKNOWN): Boolean;

{ ------------------------------------------------------------------------------ }

function EUShowCRL(Parent: HWND; Caption: AnsiString; Info: PEUCRLDetailedInfo)
  : Cardinal;

{ ------------------------------------------------------------------------------ }

function EUShowCRLs(Parent: HWND; Caption: AnsiString; CPInterface: PEUSignCP)
  : Cardinal;

{ ------------------------------------------------------------------------------ }

function EUShowSettings(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; IsCA: Boolean): Cardinal;

{ ------------------------------------------------------------------------------ }

function EUShowSignInfo(Parent: HWND; Caption: AnsiString; Info: PEUSignInfo;
  IsSigned, IsEnveloped, IsUser: Boolean): Cardinal;

{ ------------------------------------------------------------------------------ }

function EUShowCRInfo(Parent: HWND; Caption: AnsiString; Info: PEUCRInfo)
  : Cardinal;

{ ------------------------------------------------------------------------------ }

function EUShowGenerateKeys(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; InternationalMode: Boolean): Cardinal;

{ ============================================================================== }

function EUBrowseForFolder(const Text: String; Folder: String;
  FormHandle: THandle): String;

{ ============================================================================== }

implementation

{ ------------------------------------------------------------------------------ }

var
  IsUI: Boolean = False;
  CPInterfaceUI: PEUSignCP = nil;

  { ------------------------------------------------------------------------------ }

procedure EUDeinitializeOwnUI();
begin
  IsUI := False;
  CPInterfaceUI := nil;
end;

{ ------------------------------------------------------------------------------ }

procedure EUInitializeOwnUI(ACPInterface: PEUSignCP; AIsUI: Boolean);
begin
  IsUI := AIsUI;
  CPInterfaceUI := ACPInterface;
end;

{ ------------------------------------------------------------------------------ }

function  EUUseOwnUI(): Boolean;
begin
  EUUseOwnUI := IsUI;
end;

{ ------------------------------------------------------------------------------ }

procedure EUShowError(Handle: Cardinal; Error: Cardinal);
begin
  if (not IsUI) then
    Exit;

  if (CPInterfaceUI <> nil) then
  begin
    MessageBoxA(Handle, CPInterfaceUI.GetErrorDesc(Error),
      'Повідомлення оператору', MB_OK or MB_ICONERROR);
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure EUShowErrorMessage(Handle: Cardinal; Error: PAnsiChar);
begin
  if (not IsUI) then
    Exit;

  MessageBoxA(Handle, Error, 'Повідомлення оператору', MB_OK or MB_ICONERROR);
end;

{ ------------------------------------------------------------------------------ }

function EUShowMessage(Handle: Cardinal; Text, Title: PAnsiChar;
  uType: Cardinal; DefaultID: ShortInt = IDNo): Integer;
begin
  if (not IsUI) then
  begin
    EUShowMessage := DefaultID;

    Exit;
  end;

  EUShowMessage := MessageBoxA(Handle, Text, Title, uType);
end;

{ ============================================================================== }

function EUGetPrivateKeyMedia(Parent: HWND; Caption: AnsiString;
  SubTitle: AnsiString; CPInterface: PEUSignCP; KeyMedia: PEUKeyMedia): Cardinal;
var
  ReadPKForm: TReadPKForm;

begin
  ReadPKForm := TReadPKForm.CreateParented(Parent);
  if (ReadPKForm = nil) then
  begin
    EUGetPrivateKeyMedia := EU_ERROR_UNKNOWN;
    Exit;
  end;

  if (Caption <> '') then
    ReadPKForm.Caption := string(Caption);
  if (SubTitle <> '') then
    ReadPKForm.TopLabel.Caption := string(SubTitle);

  ReadPKForm.KeyMediaFrame.ConfigForm(CPInterface, KeyMedia, False);
  if (ReadPKForm.ShowModal() = mrOk) then
  begin
    EUGetPrivateKeyMedia := EU_ERROR_NONE;
  end
  else
    EUGetPrivateKeyMedia := EU_ERROR_CANCELED_BY_GUI;

  ReadPKForm.Destroy();
end;

{ ------------------------------------------------------------------------------ }

function EUReadPrivateKey(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; CertOwnerInfo: PEUCertOwnerInfo): Cardinal;
var
  ReadPKForm: TReadPKForm;

begin
  ReadPKForm := TReadPKForm.CreateParented(Parent);
  if (ReadPKForm = nil) then
  begin
    EUReadPrivateKey := EU_ERROR_UNKNOWN;
    Exit;
  end;

  if (Caption <> '') then
    ReadPKForm.Caption := string(Caption);

  EUReadPrivateKey := ReadPKForm.ReadPrivateKey(CPInterface, CertOwnerInfo);

  ReadPKForm.Destroy();
end;

{ ------------------------------------------------------------------------------ }

function EUShowCertificate(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; Info: PEUCertInfoEx; CertStatus: CertificateStatus;
  IsUserCertificate: Boolean): Cardinal;
var
  Certificate: TCertificateForm;

begin
  Certificate := TCertificateForm.CreateParented(Parent);
  if (Certificate = nil) then
  begin
    EUShowCertificate := EU_ERROR_UNKNOWN;
    Exit;
  end;

  if (Caption <> '') then
    Certificate.Caption := string(Caption);

  EUShowCertificate := Certificate.ShowForm(CPInterface, Info,
    CertStatus, IsUserCertificate);
  Certificate.Destroy();
end;

{ ------------------------------------------------------------------------------ }

function EUShowCertificates(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; CertCaption: AnsiString; CertType: CertificatesType;
  Info: PPEUCertInfoEx; PublicKeyType: Cardinal = EU_CERT_KEY_TYPE_UNKNOWN;
  KeyUsage: Cardinal = EU_KEY_USAGE_UNKNOWN): Boolean;
var
  Certificates: TCertificatesForm;

begin
  Certificates := TCertificatesForm.CreateParented(Parent);
  if (Certificates = nil) then
  begin
    EUShowCertificates := False;
    Exit;
  end;

  if (Caption <> '') then
    Certificates.Caption := string(Caption);

  EUShowCertificates := Certificates.ShowForm(CPInterface, CertType,
    CertCaption, Info, PublicKeyType, KeyUsage);
  Certificates.Destroy();
end;

{ ------------------------------------------------------------------------------ }

function EUSelectCertificates(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; CertCaption: AnsiString; CertType: CertificatesType;
  CertificatesInfo: PEUCertificatesUniqueInfo;
  PublicKeyType: Cardinal = EU_CERT_KEY_TYPE_UNKNOWN;
  KeyUsage: Cardinal = EU_KEY_USAGE_UNKNOWN): Boolean;
var
  CertificatesForm: TCertificatesForm;
begin
  CertificatesForm := TCertificatesForm.CreateParented(Parent);
  if (CertificatesForm = nil) then
  begin
    EUSelectCertificates := False;
    Exit;
  end;

  if (Caption <> '') then
    CertificatesForm.Caption := string(Caption);

  EUSelectCertificates := CertificatesForm.SelectCertificates(CPInterface,
    CertType, CertCaption, CertificatesInfo, PublicKeyType, KeyUsage);
  CertificatesForm.Destroy();
end;

{ ------------------------------------------------------------------------------ }

function EUShowCRL(Parent: HWND; Caption: AnsiString;
  Info: PEUCRLDetailedInfo): Cardinal;
var
  CRL: TCRLForm;
  Error: Cardinal;

begin
  CRL := TCRLForm.CreateParented(Parent);
  if (CRL = nil) then
  begin
    EUShowCRL := EU_ERROR_UNKNOWN;
    Exit;
  end;

  if (Caption <> '') then
    CRL.Caption := string(Caption);

  Error := CRL.SetData(Info);

  if (Error <> EU_ERROR_NONE) then
  begin
    CRL.Destroy();
    EUShowCRL := Error;
    Exit;
  end;

  CRL.ShowModal();
  CRL.Destroy();

  EUShowCRL := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

function EUShowCRLs(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP): Cardinal;
var
  CRLs: TCRLsForm;

begin
  CRLs := TCRLsForm.CreateParented(Parent);
  if (CRLs = nil) then
  begin
    EUShowCRLs := EU_ERROR_UNKNOWN;

    Exit;
  end;

  if (Caption <> '') then
    CRLs.Caption := string(Caption);

  CRLs.Initialize(CPInterface);
  CRLs.ShowModal();
  CRLs.Destroy();

  EUShowCRLs := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

function EUShowSettings(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; IsCA: Boolean): Cardinal;
var
  Settings: TSettingsForm;

begin
  Settings := TSettingsForm.CreateParented(Parent);
  if (Settings = nil) then
  begin
    EUShowSettings := EU_ERROR_UNKNOWN;
    Exit;
  end;

  if (Caption <> '') then
    Settings.Caption := string(Caption);

  Settings.Initialize(CPInterface, IsCA);
  Settings.ShowModal();
  Settings.Destroy();

  EUShowSettings := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

function EUShowSignInfo(Parent: HWND; Caption: AnsiString; Info: PEUSignInfo;
  IsSigned, IsEnveloped, IsUser: Boolean): Cardinal;
var
  Signature: TCMSInfoForm;
  Error: Cardinal;

begin
  Signature := TCMSInfoForm.CreateParented(Parent);
  if (Signature = nil) then
  begin
    EUShowSignInfo := EU_ERROR_UNKNOWN;
    Exit;
  end;

  Error := Signature.SetData(Info, IsSigned, IsEnveloped, IsUser);
  if (Caption <> '') then
    Signature.Caption := string(Caption);

  if (Error <> EU_ERROR_NONE) then
  begin
    Signature.Destroy();
    EUShowSignInfo := Error;
    Exit;
  end;

  Signature.ShowModal();
  Signature.Destroy();

  EUShowSignInfo := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

function EUShowCRInfo(Parent: HWND; Caption: AnsiString; Info: PEUCRInfo): Cardinal;
var
  CRInfo: TCRForm;

begin
  CRInfo := TCRForm.CreateParented(Parent);
  if (CRInfo = nil) then
  begin
    EUShowCRInfo := EU_ERROR_UNKNOWN;
    Exit;
  end;

  if (Caption <> '') then
    CRInfo.Caption := string(Caption);

  CRInfo.ShowForm(Info);
  CRInfo.Destroy();

  EUShowCRInfo := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

function EUShowGenerateKeys(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; InternationalMode: Boolean): Cardinal;
var
  GenerateKeysForm: TGenerateKeysForm;

begin
  GenerateKeysForm := TGenerateKeysForm.CreateParented(Parent);
  if (GenerateKeysForm = nil) then
  begin
    EUShowGenerateKeys := EU_ERROR_UNKNOWN;
    Exit;
  end;

  GenerateKeysForm.SetData(CPInterface, InternationalMode);
  if (Caption <> '') then
    GenerateKeysForm.Caption := string(Caption);

  GenerateKeysForm.ShowModal();
  GenerateKeysForm.Destroy();

  EUShowGenerateKeys := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

function EUChangePrivateKeyPassword(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; KeyMedia: PEUKeyMedia): Cardinal;
var
  ChangePKPassword: TChangePasswordForm;

begin
  ChangePKPassword := TChangePasswordForm.CreateParented(Parent);
  if (ChangePKPassword = nil) then
  begin
    EUChangePrivateKeyPassword := EU_ERROR_UNKNOWN;
    Exit;
  end;

  if (Caption <> '') then
    ChangePKPassword.Caption := string(Caption);

  EUChangePrivateKeyPassword :=
    ChangePKPassword.ChangePrivateKeyPassword(CPInterface, KeyMedia);
  ChangePKPassword.Destroy();
end;

{ ============================================================================== }

function EUBrowseForFolder(const Text: String; Folder: String;
  FormHandle: THandle): String;
  function BFFCallbackProc(hwnd: hwnd; uMsg: UINT; lParam: lParam;
    lpData: lParam): Integer; stdcall;
  begin
    if uMsg = BFFM_INITIALIZED then
      SendMessage(hwnd, BFFM_SETSELECTION, 1, lpData);
    Result := 0;
  end;

var
  TitleName: String;
  lpItemID: PItemIDList;
  BrowseInfo: TBrowseInfo;
  DisplayName: Array [0 .. MAX_PATH] of char;
  TempPath: Array [0 .. MAX_PATH] of char;

begin
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);

  BrowseInfo.hwndOwner := FormHandle;
  BrowseInfo.pszDisplayName := @DisplayName;

  TitleName := Text;

  BrowseInfo.lpszTitle := PChar(TitleName);
  BrowseInfo.ulFlags := bif_NewDialogStyle;
  BrowseInfo.lpfn := @BFFCallbackProc;
  BrowseInfo.lParam := dword(PChar(Folder));

  lpItemID := SHBrowseForFolder(BrowseInfo);
  if (lpItemID <> nil) then
  begin
    SHGetPathFromIDList(lpItemID, TempPath);
    GlobalFreePtr(lpItemID);

    Result := TempPath;
  end
  else
    Result := '';
end;

{ ============================================================================== }

end.
