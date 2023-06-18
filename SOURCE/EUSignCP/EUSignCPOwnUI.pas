unit EUSignCPOwnUI;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, //Classes, Controls,
  //Forms,
  EUSignCP
  {,
  Certificate, Certificates, Settings, CMSInfo, CRL, CRLs, KeyMedia, ReadPK};

{ ============================================================================== }

procedure EUInitializeOwnUI(ACPInterface: PEUSignCP; AIsUI: Boolean);
procedure EUDeinitializeOwnUI();

{ ------------------------------------------------------------------------------ }

procedure EUShowError(Handle: Cardinal; Error: Cardinal);
procedure EUShowErrorMessage(Handle: Cardinal; Error: PAnsiChar);
function EUShowMessage(Handle: Cardinal; Text, Title: PAnsiChar;
  uType: Cardinal; DefaultID: ShortInt = IDNo): Integer;

{ ============================================================================== }

function EUReadPrivateKey(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; CertOwnerInfo: PEUCertOwnerInfo; KeyMedia: PEUKeyMedia;
   showError: boolean ): Cardinal;

{
function EUGetPrivateKeyMedia(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; KeyMedia: PEUKeyMedia): Cardinal;


function EUShowCertificate(Parent: HWND; Caption: AnsiString; Info: PEUCertInfo;
  CertStatus: CertificateStatus): Cardinal;

function ShowCertificates(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; CertCaption: AnsiString; CertType: CertificatesType;
  Info: PEUCertInfo): Boolean;


function EUShowCRL(Parent: HWND; Caption: AnsiString; Info: PEUCRLDetailedInfo)
  : Cardinal;


function EUShowCRLs(Parent: HWND; Caption: AnsiString; CPInterface: PEUSignCP)
  : Cardinal;


function EUShowSettings(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; IsCA: Boolean): Cardinal;


function EUShowSignInfo(Parent: HWND; Caption: AnsiString; Info: PEUSignInfo;
  IsSigned, IsEnveloped, IsUser: Boolean): Cardinal;
}
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

procedure EUShowError(Handle: Cardinal; Error: Cardinal);
begin
  if not IsUI then
    Exit;

  if CPInterfaceUI <> nil then
  begin

    //MessageBoxA(Handle, CPInterfaceUI.GetErrorDesc(Error),
    //  'Повідомлення оператору', MB_OK or MB_ICONERROR);
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure EUShowErrorMessage(Handle: Cardinal; Error: PAnsiChar);
begin
  if not IsUI then
    Exit;

  //MessageBoxA(Handle, Error, 'Повідомлення оператору', MB_OK or MB_ICONERROR);
end;

{ ------------------------------------------------------------------------------ }

function EUShowMessage(Handle: Cardinal; Text, Title: PAnsiChar;
  uType: Cardinal; DefaultID: ShortInt = IDNo): Integer;
begin
  if not IsUI then
  begin
    EUShowMessage := DefaultID;

    Exit;
  end;

  //EUShowMessage := MessageBoxA(Handle, Text, Title, uType);
  EUShowMessage := DefaultID;
end;

function EUReadPrivateKey(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; CertOwnerInfo: PEUCertOwnerInfo; KeyMedia: PEUKeyMedia;
  showError: boolean ): Cardinal;
begin
 result := 0;
end;


{ ============================================================================== }
{
function EUGetPrivateKeyMedia(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; KeyMedia: PEUKeyMedia): Cardinal;
var
  //ReadPKForm: TReadPKForm;

begin

  ReadPKForm := TReadPKForm.CreateParented(Parent);
  if ReadPKForm = nil then
  begin
    EUGetPrivateKeyMedia := EU_ERROR_UNKNOWN;

    Exit;
  end;

  if Caption <> '' then
    ReadPKForm.Caption := Caption;

  ReadPKForm.KeyMediaFrame.ConfigForm(CPInterface, KeyMedia, False);
  if (ReadPKForm.ShowModal() = mrOk) then
  begin
    EUGetPrivateKeyMedia := EU_ERROR_NONE;
  end
  else
    EUGetPrivateKeyMedia := EU_ERROR_CANCELED_BY_GUI;

  ReadPKForm.Destroy();

end;
}
{ ------------------------------------------------------------------------------ }
{
function EUReadPrivateKey(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; CertOwnerInfo: PEUCertOwnerInfo; KeyMedia: PEUKeyMedia): Cardinal;
var
  ReadPKForm: TReadPKForm;

begin
  ReadPKForm := TReadPKForm.CreateParented(Parent);
  if ReadPKForm = nil then
  begin
    EUReadPrivateKey := EU_ERROR_UNKNOWN;

    Exit;
  end;

  if Caption <> '' then
    ReadPKForm.Caption := Caption;

  EUReadPrivateKey := ReadPKForm.ReadPrivateKey(CPInterface, CertOwnerInfo, KeyMedia);

  ReadPKForm.Destroy();
end;
}
{ ------------------------------------------------------------------------------ }
{
function EUShowCertificate(Parent: HWND; Caption: AnsiString; Info: PEUCertInfo;
  CertStatus: CertificateStatus): Cardinal;
var
  Certificate: TCertificateForm;
  Error: Cardinal;

begin
  Certificate := TCertificateForm.CreateParented(Parent);
  if Certificate = nil then
  begin
    EUShowCertificate := EU_ERROR_UNKNOWN;

    Exit;
  end;

  if Caption <> '' then
    Certificate.Caption := Caption;

  Error := Certificate.SetData(Info, CertStatus);
  EUShowCertificate := Error;
  if Error <> EU_ERROR_NONE then
  begin
    Certificate.Destroy();

    Exit;
  end;

  Certificate.ShowModal();

  Certificate.Destroy();
end;
}
{ ------------------------------------------------------------------------------ }
{
function ShowCertificates(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; CertCaption: AnsiString; CertType: CertificatesType;
  Info: PEUCertInfo): Boolean;
var
  Certificates: TCertificatesForm;

begin
  Certificates := TCertificatesForm.CreateParented(Parent);
  if Certificates = nil then
  begin
    ShowCertificates := False;

    Exit;
  end;

  if Caption <> '' then
    Certificates.Caption := Caption;

  ShowCertificates := Certificates.ShowForm(CPInterface, CertType,
    CertCaption, Info);

  Certificates.Destroy();
end;
}
{ ------------------------------------------------------------------------------ }
{
function EUShowCRL(Parent: HWND; Caption: AnsiString; Info: PEUCRLDetailedInfo)
  : Cardinal;
var
  CRL: TCRLForm;
  Error: Cardinal;

begin
  CRL := TCRLForm.CreateParented(Parent);
  if CRL = nil then
  begin
    EUShowCRL := EU_ERROR_UNKNOWN;

    Exit;
  end;

  if Caption <> '' then
    CRL.Caption := Caption;

  Error := CRL.SetData(Info);
  EUShowCRL := Error;

  if Error <> EU_ERROR_NONE then
  begin
    CRL.Destroy();

    Exit;
  end;

  CRL.ShowModal();

  CRL.Destroy();
end;
}
{ ------------------------------------------------------------------------------ }
{
function EUShowCRLs(Parent: HWND; Caption: AnsiString; CPInterface: PEUSignCP)
  : Cardinal;
var
  CRLs: TCRLsForm;

begin
  CRLs := TCRLsForm.CreateParented(Parent);
  if CRLs = nil then
  begin
    EUShowCRLs := EU_ERROR_UNKNOWN;

    Exit;
  end;

  if Caption <> '' then
    CRLs.Caption := Caption;

  CRLs.Initialize(CPInterface);

  CRLs.ShowModal();

  CRLs.Destroy();

  EUShowCRLs := EU_ERROR_NONE;
end;
}
{ ------------------------------------------------------------------------------ }
{
function EUShowSettings(Parent: HWND; Caption: AnsiString;
  CPInterface: PEUSignCP; IsCA: Boolean): Cardinal;
var
  Settings: TSettingsForm;

begin
  Settings := TSettingsForm.CreateParented(Parent);
  if Settings = nil then
  begin
    EUShowSettings := EU_ERROR_UNKNOWN;

    Exit;
  end;

  if Caption <> '' then
    Settings.Caption := Caption;

  Settings.Initialize(CPInterface, IsCA);

  Settings.ShowModal();

  Settings.Destroy();

  EUShowSettings := EU_ERROR_NONE;
end;
}
{ ------------------------------------------------------------------------------ }
{
function EUShowSignInfo(Parent: HWND; Caption: AnsiString; Info: PEUSignInfo;
  IsSigned, IsEnveloped, IsUser: Boolean): Cardinal;
var
  Signature: TCMSInfoForm;
  Error: Cardinal;

begin
  Signature := TCMSInfoForm.CreateParented(Parent);
  if Signature = nil then
  begin
    EUShowSignInfo := EU_ERROR_UNKNOWN;

    Exit;
  end;

  Error := Signature.SetData(Info, IsSigned, IsEnveloped, IsUser);
  if Caption <> '' then
    Signature.Caption := Caption;

  EUShowSignInfo := Error;
  if Error <> EU_ERROR_NONE then
  begin
    Exit;

    Signature.Destroy();
  end;

  Signature.ShowModal();

  Signature.Destroy();
end;
}
{ ============================================================================== }

end.
