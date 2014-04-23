unit SignFunctionsFrame;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, StrUtils, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  EUSignCP, EUSignCPOwnUI, Certificates;

{ ------------------------------------------------------------------------------ }

type
  TSignFrame = class(TFrame)
    SettingsPanel: TPanel;
    SettingsLabel: TLabel;
    SettingsUnderlineImage: TImage;
    UseInternalSignCheckBox: TCheckBox;
    SignHashCheckBox: TCheckBox;
    UseRawSignCheckBox: TCheckBox;
    AddCertCheckBox: TCheckBox;
    HashParamsFromCertCheckBox: TCheckBox;
    SignDataPanel: TPanel;
    SignDataUnderlineImage: TImage;
    DataLabel: TLabel;
    SignDataLabel: TLabel;
    SignButton: TButton;
    SignAddButton: TButton;
    CheckSignButton: TButton;
    SignedDataRichEdit: TRichEdit;
    VerifyDataSignNextButton: TButton;
    SignFilePanel: TPanel;
    SignFileUnderlineImage: TImage;
    SignFileLabel: TLabel;
    SignedFileDataLabel: TLabel;
    SignFileButton: TButton;
    SignFileAddButton: TButton;
    CheckFileButton: TButton;
    VerifyFileSignNextButton: TButton;
    SignDataEdit: TEdit;
    SignFileEdit: TEdit;
    ChooseSignFileButton: TButton;
    SignedFileRichEdit: TRichEdit;
    SignedFileLabel: TLabel;
    SignedFileEdit: TEdit;
    ChooseSignedFileButton: TButton;
    TestPanel: TPanel;
    SignDataTitleLabel: TLabel;
    SignFileTitleLabel: TLabel;
    TargetFileOpenDialog: TOpenDialog;
    FullDataTestButton: TButton;
    TestSignLabel: TLabel;
    FullStreamTestButton: TButton;
    FullFileTestButton: TButton;
    procedure UseInternalSignCheckBoxClick(Sender: TObject);
    procedure UseRawSignCheckBoxClick(Sender: TObject);
    procedure SignButtonClick(Sender: TObject);
    procedure SignAddButtonClick(Sender: TObject);
    procedure VerifySignButtonClick(Sender: TObject);
    procedure SignHashCheckBoxClick(Sender: TObject);
    procedure ChooseSignedFileButtonClick(Sender: TObject);
    procedure ChooseSignFileButtonClick(Sender: TObject);
    procedure VerifyDataSignNextButtonClick(Sender: TObject);
    procedure SignFileButtonClick(Sender: TObject);
    procedure VerifyFileButtonClick(Sender: TObject);
    procedure FullDataTestButtonClick(Sender: TObject);
    procedure FullStreamTestButtonClick(Sender: TObject);
    procedure FullFileTestButtonClick(Sender: TObject);
    procedure SignFileAddButtonClick(Sender: TObject);
    procedure VerifyFileSignNextButtonClick(Sender: TObject);
    procedure SignedFileEditChange(Sender: TObject);
  private
    CPInterface: PEUSignCP;
    UseOwnUI: Boolean;
    VerifyDataSignIndex: Cardinal;
    VerifyFileSignIndex: Cardinal;
    procedure ChangeControlsState(Enabled: Boolean);
    procedure ClearSettings();
    procedure ClearData(All: Boolean);
    function HashData(Data: PByte; DataLength: Cardinal;
      Hash: PPAnsiChar): Cardinal;
    function HashFile(FileName: PAnsiChar; Hash: PPAnsiChar): Cardinal;
    function SignFilesTest(FileName: AnsiString; useTSP: Boolean): Cardinal;
    function VerifyFilesTest(FileName: AnsiString; useTSP: Boolean): Cardinal;

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

procedure TSignFrame.ChangeControlsState(Enabled: Boolean);
var
  IsPrivateKeyReaded: Boolean;

begin
  CheckSignButton.Enabled := Enabled;
  SignDataEdit.Enabled := Enabled;
  SignedDataRichEdit.Enabled := Enabled;
  VerifyDataSignNextButton.Enabled := Enabled;
  CheckFileButton.Enabled := Enabled;
  VerifyFileSignNextButton.Enabled := Enabled;
  SignedFileRichEdit.Enabled := Enabled;
  SignedFileEdit.Enabled := Enabled;
  ChooseSignedFileButton.Enabled := Enabled;

  UseInternalSignCheckBox.Enabled := Enabled;
  SignHashCheckBox.Enabled := Enabled;
  UseRawSignCheckBox.Enabled := Enabled;

  if (Enabled and (CPInterface <> nil))then
  begin
     IsPrivateKeyReaded := CPInterface.IsPrivateKeyReaded();
  end
  else
    IsPrivateKeyReaded := False;

  SignButton.Enabled := IsPrivateKeyReaded;
  SignAddButton.Enabled := IsPrivateKeyReaded;

  SignFileEdit.Enabled := IsPrivateKeyReaded;
  ChooseSignFileButton.Enabled := IsPrivateKeyReaded;
  SignFileButton.Enabled :=  IsPrivateKeyReaded;
  SignFileAddButton.Enabled := IsPrivateKeyReaded;

  FullDataTestButton.Enabled := IsPrivateKeyReaded;
  FullFileTestButton.Enabled := IsPrivateKeyReaded;
  FullStreamTestButton.Enabled := IsPrivateKeyReaded;
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.Initialize(CPInterface: PEUSignCP; UseOwnUI: Boolean);
begin
  self.CPInterface := CPInterface;
  self.UseOwnUI := UseOwnUI;
  ChangeControlsState(True);
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.Deinitialize();
begin
  ClearData(True);
  ClearSettings();
  ChangeControlsState(False);
  self.CPInterface := nil;
  self.UseOwnUI := false;
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.WillShow();
var
  Enabled: LongBool;

begin
  Enabled := ((CPInterface <> nil) and CPInterface.IsInitialized);
  if (not Enabled) then
    ClearSettings();

  if (Enabled and (not CPInterface.IsPrivateKeyReaded())) then
    ClearData(False);

  ChangeControlsState(Enabled);
end;

{ ============================================================================== }

procedure TSignFrame.ClearSettings;
begin
  UseInternalSignCheckBox.Checked := False;
  SignHashCheckBox.Checked := False;
  UseRawSignCheckBox.Checked := False;

  AddCertCheckBox.Checked := False;
  AddCertCheckBox.Enabled := False;

  HashParamsFromCertCheckBox.Checked := False;
  HashParamsFromCertCheckBox.Enabled := False;
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.ClearData(All: Boolean);
begin
  SignDataEdit.Text := '';
  SignFileEdit.Text := '';

  if All then
  begin
   SignedDataRichEdit.Text := '';
   VerifyDataSignNextButton.Caption := 'Перевірити наступний...';

   SignedFileRichEdit.Text := '';
   SignedFileEdit.Text := '';
   VerifyFileSignNextButton.Caption := 'Перевірити наступний...';
  end;
end;

{ ============================================================================== }

procedure TSignFrame.UseInternalSignCheckBoxClick(Sender: TObject);
begin
  SignHashCheckBox.Enabled := (not UseInternalSignCheckBox.Checked);
  HashParamsFromCertCheckBox.Enabled := (SignHashCheckBox.Enabled and
    SignHashCheckBox.Checked);

  UseRawSignCheckBox.Enabled := (not UseInternalSignCheckBox.Checked);
  AddCertCheckBox.Enabled := UseInternalSignCheckBox.Checked;
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.UseRawSignCheckBoxClick(Sender: TObject);
begin
  UseInternalSignCheckBox.Enabled := ((not SignHashCheckBox.Checked) and
    (not UseRawSignCheckBox.Checked));
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.SignHashCheckBoxClick(Sender: TObject);
begin
  UseInternalSignCheckBox.Enabled := ((not SignHashCheckBox.Checked) and
    (not UseRawSignCheckBox.Checked));

  HashParamsFromCertCheckBox.Enabled := SignHashCheckBox.Checked;
end;

{ ============================================================================== }

function TSignFrame.HashData(Data: PByte; DataLength: Cardinal;
  Hash: PPAnsiChar) : Cardinal;
var
  Info: PEUCertInfoEx;
  Cert: PByte;
  CertLength: Cardinal;

begin
  if (HashParamsFromCertCheckBox.Checked) then
  begin

    if (not EUShowCertificates(WindowHandle, '', CPInterface,
      'Сертифікати користувачів-отримувачів', CertTypeEndUser, @Info)) then
    begin
      Result := EU_ERROR_CANCELED_BY_GUI;
      Exit;
    end;

    Result := CPInterface.GetCertificate(Info.Issuer, Info.Serial, nil,
      @Cert, @CertLength);
    if (Result <> EU_ERROR_NONE) then
    begin
      CPInterface.FreeCertificateInfoEx(Info);
      Exit;
    end;

    CPInterface.FreeCertificateInfoEx(Info);

    Result := CPInterface.HashDataBeginWithParams(Cert, CertLength);
    if (Result <> EU_ERROR_NONE) then
    begin
      CPInterface.FreeMemory(Cert);
      Exit;
    end;

    CPInterface.FreeMemory(Cert);
  end;

  Result := CPInterface.HashDataContinue(Data, DataLength);
  if (Result <> EU_ERROR_NONE) then
  begin
    CPInterface.ResetOperation();
    Exit;
  end;

  Result := CPInterface.HashDataEnd(Hash, nil, nil);
  if (Result <> EU_ERROR_NONE) then
  begin
    CPInterface.ResetOperation();
    Exit;
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.SignButtonClick(Sender: TObject);
var
  Error: Cardinal;
  Hash: PAnsiChar;
  Sign: PAnsiChar;
  Data: WideString;

begin
  if (not CPInterface.IsPrivateKeyReaded()) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  Data := WideString(SignDataEdit.Text);
  SignedDataRichEdit.Text := '';
  VerifyDataSignIndex := 0;
  VerifyDataSignNextButton.Caption := 'Перевірити наступний...';

  if UseRawSignCheckBox.Checked then
  begin

    if SignHashCheckBox.Checked then
    begin

      Error := HashData(PByte(Data), Length(Data) * 2, @Hash);
      if (Error <> EU_ERROR_NONE) then
      begin
        if (Error <> EU_ERROR_CANCELED_BY_GUI) then
          EUShowError(Handle, Error);
        Exit;
      end;

      Error := CPInterface.RawSignHash(Hash, nil, 0, @Sign, nil, nil);
      if (Error <> EU_ERROR_NONE) then
      begin
        CPInterface.FreeMemory(PByte(Hash));
        EUShowError(Handle, Error);
        Exit;
      end;

      CPInterface.FreeMemory(PByte(Hash));

    end
    else
    begin

      Error := CPInterface.RawSignData(PByte(Data), Length(Data) * 2, 
        @Sign, nil, nil);
      if (Error <> EU_ERROR_NONE) then
      begin
        EUShowError(Handle, Error);
        Exit;
      end;

    end;

  end
  else if UseInternalSignCheckBox.Checked then
  begin

    Error := CPInterface.SignDataInternal(AddCertCheckBox.Checked,
      PByte(Data), Length(Data) * 2, @Sign, nil, nil);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
      Exit;
    end;

  end
  else if (SignHashCheckBox.Enabled and SignHashCheckBox.Checked) then
  begin

    Error := HashData(PByte(Data), Length(Data) * 2, @Hash);
    if (Error <> EU_ERROR_NONE) then
    begin
      if (Error <> EU_ERROR_CANCELED_BY_GUI) then
        EUShowError(Handle, Error);
      Exit;
    end;

    Error := CPInterface.SignHash(Hash, nil, 0, @Sign, nil, nil);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.FreeMemory(PByte(Hash));
      EUShowError(Handle, Error);
      Exit;
    end;
    
    CPInterface.FreeMemory(PByte(Hash));

  end
  else
  begin

    Error := CPInterface.SignDataContinue(PByte(Data), Length(Data) * 2);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.ResetOperation();
      EUShowError(Handle, Error);
      Exit;
    end;

    Error := CPInterface.SignDataEnd(@Sign, nil, nil);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.ResetOperation();
      EUShowError(Handle, Error);
      Exit;
    end;

  end;

  SignedDataRichEdit.Text := string(Sign);
  CPInterface.FreeMemory(PByte(Sign));
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.SignAddButtonClick(Sender: TObject);
var
  Error: Cardinal;
  Hash: PAnsiChar;
  Sign: PAnsiChar;
  Data: WideString;
  SignedDataString: AnsiString;
  IsAlreadySigned: LongBool;

begin
  if (not CPInterface.IsPrivateKeyReaded()) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if UseRawSignCheckBox.Checked then
  begin
    MessageBoxA(Handle, 'Додавання підпису до простого підпису не підтримується',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  Data := WideString(SignDataEdit.Text);
  SignedDataString := AnsiString(SignedDataRichEdit.Text);

  if ((SignedDataString = '') or (Length(SignedDataString) = 0)) then
  begin
    MessageBoxA(Handle, 'Підпис відсутній',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  Error := CPInterface.IsAlreadySigned(PAnsiChar(SignedDataString), nil, 0,
    @IsAlreadySigned);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  if IsAlreadySigned then
  begin
    MessageBoxA(Handle, 'Дані вже підписані користувачем',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if UseInternalSignCheckBox.Checked then
  begin

    Error := CPInterface.AppendSignInternal(AddCertCheckBox.Checked,
      PAnsiChar(SignedDataString), nil, 0, @Sign, nil, nil);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
      Exit;
    end;

  end
  else if (SignHashCheckBox.Enabled and SignHashCheckBox.Checked) then
  begin

    Error := HashData(PByte(Data), Length(Data) * 2, @Hash);
    if (Error <> EU_ERROR_NONE) then
    begin
      if (Error <> EU_ERROR_CANCELED_BY_GUI) then
        EUShowError(Handle, Error);
      Exit;
    end;

    Error := CPInterface.AppendSignHash(Hash, nil, 0,
      PAnsiChar(SignedDataString), nil, 0, @Sign, nil, nil);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.FreeMemory(PByte(Hash));
      EUShowError(Handle, Error);
      Exit;
    end;

    CPInterface.FreeMemory(PByte(Hash));

  end
  else
  begin

    Error := CPInterface.AppendSignBegin(PAnsiChar(SignedDataString), nil, 0);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.ResetOperation();
      EUShowError(Handle, Error);
      Exit;
    end;

    Error := CPInterface.SignDataContinue(PByte(Data), Length(Data) * 2);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.ResetOperation();
      EUShowError(Handle, Error);
      Exit;
    end;

    Error := CPInterface.SignDataEnd(@Sign, nil, nil);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.ResetOperation();
      EUShowError(Handle, Error);
      Exit;
    end;

  end;

  VerifyDataSignIndex := 0;
  VerifyDataSignNextButton.Caption := 'Перевірити наступний...';

  SignedDataRichEdit.Text := string(Sign);
  CPInterface.FreeMemory(PByte(Sign));
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.VerifySignButtonClick(Sender: TObject);
var
  Error: Cardinal;
  SignedDataString: AnsiString;
  Hash: PAnsiChar;
  SignInfo: TEUSignInfo;
  DataString: WideString;
  Data: PByte;
  DataLength: Cardinal;
  // !!!!
  xxx: AnsiString;
  // !!!!

begin
  DataString := WideString(SignDataEdit.Text);
  SignedDataString := AnsiString(SignedDataRichEdit.Text);

  if UseRawSignCheckBox.Checked then
  begin

    if SignHashCheckBox.Checked then
    begin

      Error := HashData(PByte(DataString), Length(DataString) * 2, @Hash);
      if (Error <> EU_ERROR_NONE) then
      begin
        if (Error <> EU_ERROR_CANCELED_BY_GUI) then
          EUShowError(Handle, Error);
        Exit;
      end;

      Error := CPInterface.RawVerifyHash(Hash, nil, 0,
        PAnsiChar(SignedDataString), nil, 0, @SignInfo);
      if (Error <> EU_ERROR_NONE) then
      begin
        CPInterface.FreeMemory(PByte(Hash));
        EUShowError(Handle, Error);
        Exit;
      end;

      CPInterface.FreeMemory(PByte(Hash));
      
    end
    else
    begin
    
      Error := CPInterface.RawVerifyData(PByte(DataString),
        Length(DataString) * 2, PAnsiChar(SignedDataString), nil, 0, @SignInfo);
      if (Error <> EU_ERROR_NONE) then
      begin
         EUShowError(Handle, Error);
         Exit;
      end;

    end;
    
  end
  else if UseInternalSignCheckBox.Checked then
  begin

    Error := CPInterface.VerifyDataInternal(PAnsiChar(SignedDataString), nil, 0,
      @Data, @DataLength, @SignInfo);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
      Exit;
    end;

    CPInterface.FreeMemory(PByte(Data));

  end
  else if (SignHashCheckBox.Enabled and SignHashCheckBox.Checked) then
  begin

    Error := HashData(PByte(DataString), Length(DataString) * 2, @Hash);
    if (Error <> EU_ERROR_NONE) then
    begin
      if (Error <> EU_ERROR_CANCELED_BY_GUI) then
        EUShowError(Handle, Error);
      Exit;
    end;

    Error := CPInterface.VerifyHash(Hash, nil, 0, PAnsiChar(SignedDataString),
      nil, 0, @SignInfo);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.FreeMemory(PByte(Hash));
      EUShowError(Handle, Error);
      Exit;
    end;

    CPInterface.FreeMemory(PByte(Hash));

  end
  else
  begin

    Error := CPInterface.VerifyDataBegin(PAnsiChar(SignedDataString), nil, 0);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.ResetOperation();
      EUShowError(Handle, Error);
      Exit;
    end;

    Error := CPInterface.VerifyDataContinue(PByte(DataString),
      Length(DataString) * 2);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.ResetOperation();
      EUShowError(Handle, Error);
      Exit;
    end;

    Error := CPInterface.VerifyDataEnd(@SignInfo);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.ResetOperation();
      EUShowError(Handle, Error);
      Exit;
    end;

  end;

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.VerifyDataSignNextButtonClick(Sender: TObject);
var
  Error: Cardinal;
  SignedDataString: AnsiString;
  Hash: PAnsiChar;
  SignInfo: TEUSignInfo;
  DataString: WideString;
  Data: PByte;
  DataLength: Cardinal;
  SignCount: Cardinal;

begin
  DataString := WideString(SignDataEdit.Text);
  SignedDataString := AnsiString(SignedDataRichEdit.Text);

  if UseRawSignCheckBox.Checked then
  begin
    MessageBoxA(Handle, 'Додавання підпису до простого підпису не підтримується',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  Error := CPInterface.GetSignsCount(PAnsiChar(SignedDataString), nil, 0,
    @SignCount);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  if (SignCount = 0) then
  begin
    MessageBoxA(Handle, 'Підписи відсутні',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  VerifyDataSignNextButton.Caption := 'Перевірити (' +
    IntToStr(VerifyDataSignIndex + 1) + ' з ' + IntToStr(SignCount) + ')...';

  if UseInternalSignCheckBox.Checked then
  begin

    Error := CPInterface.VerifyDataInternalSpecific(VerifyDataSignIndex,
      PAnsiChar(SignedDataString), nil, 0, @Data, @DataLength, @SignInfo);

    CPInterface.FreeMemory(PByte(Data));

  end
  else if (SignHashCheckBox.Enabled and SignHashCheckBox.Checked) then
  begin

    Error := HashData(PByte(DataString), Length(DataString) * 2, @Hash);
    if (Error = EU_ERROR_NONE) then
    begin
      Error := CPInterface.VerifyHashSpecific(Hash, nil, 0, VerifyDataSignIndex,
       PAnsiChar(SignedDataString), nil, 0, @SignInfo);

      CPInterface.FreeMemory(PByte(Hash));
    end;

    if (Error = EU_ERROR_CANCELED_BY_GUI) then
      Exit;

  end
  else
  begin

    Error := CPInterface.VerifyDataSpecificBegin(VerifyDataSignIndex,
      PAnsiChar(SignedDataString), nil, 0);
    if (Error = EU_ERROR_NONE) then
    begin
      Error := CPInterface.VerifyDataContinue(PByte(DataString),
        Length(DataString) * 2);
      if (Error = EU_ERROR_NONE) then
        Error := CPInterface.VerifyDataEnd(@SignInfo);
    end;

    if (Error <> EU_ERROR_NONE) then
      CPInterface.ResetOperation();

  end;

  VerifyDataSignIndex := (VerifyDataSignIndex + 1) Mod SignCount;

  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, AnsiString('Підписані дані(Підпис №' +
      IntToStr(VerifyDataSignIndex + 1) + ')'), @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);
end;

{ ============================================================================== }

function TSignFrame.HashFile(FileName: PAnsiChar;
  Hash: PPAnsiChar) : Cardinal;
var
  Info: PEUCertInfoEx;
  Cert: PByte;
  CertLength: Cardinal;

begin

  if HashParamsFromCertCheckBox.Checked then
  begin

    if (not EUShowCertificates(WindowHandle, '', CPInterface,
      'Сертифікати користувачів-отримувачів', CertTypeEndUser, @Info)) then
    begin
      Result := EU_ERROR_CANCELED_BY_GUI;
      Exit;
    end;

    Result := CPInterface.GetCertificate(Info.Issuer, Info.Serial, nil,
      @Cert, @CertLength);
    if (Result <> EU_ERROR_NONE) then
    begin
      CPInterface.FreeCertificateInfoEx(Info);
      Exit;
    end;

    CPInterface.FreeCertificateInfoEx(Info);

    Result := CPInterface.HashFileWithParams(Cert, CertLength,
      PAnsiChar(FileName), Hash, nil, nil);

    CPInterface.FreeMemory(Cert);
  end
  else
    Result := CPInterface.HashFile(PAnsiChar(FileName), Hash, nil, nil);

  if (Result <> EU_ERROR_NONE) then
  begin
    CPInterface.ResetOperation();
    Exit;
  end;

end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.SignFileButtonClick(Sender: TObject);
var
  TargetFile: AnsiString;
  FileWithSign: AnsiString;
  Hash: PAnsiChar;
  Sign: PAnsiChar;
  Error: Cardinal;

begin

  if (not CPInterface.IsPrivateKeyReaded()) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if (Length(SignFileEdit.Text) = 0) then
  begin
    MessageBoxA(Handle, 'Файл для підпису не обрано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  TargetFile := AnsiString(SignFileEdit.Text);
  FileWithSign := '';
  SignedFileEdit.Text := '';
  SignedFileRichEdit.Text := '';

  if UseRawSignCheckBox.Checked then
  begin

    if SignHashCheckBox.Checked then
    begin
      Error := HashFile(PAnsiChar(TargetFile), @Hash);
      if (Error <> EU_ERROR_NONE) then
      begin
        if (Error <> EU_ERROR_CANCELED_BY_GUI) then
          EUShowError(Handle, Error);
        Exit;
      end;

      Error := CPInterface.RawSignHash(Hash, nil, 0, @Sign, nil, nil);
      if (Error <> EU_ERROR_NONE) then
      begin
        CPInterface.FreeMemory(PByte(Hash));
        EUShowError(Handle, Error);
        Exit;
      end;

      SignedFileRichEdit.Text := string(Sign);
      CPInterface.FreeMemory(PByte(Hash));
      CPInterface.FreeMemory(PByte(Sign));
    end
    else
    begin
      FileWithSign := TargetFile + AnsiString('.raw.sig');

      Error := CPInterface.RawSignFile(PAnsiChar(TargetFile),
        PAnsiChar(FileWithSign));
      if (Error <> EU_ERROR_NONE) then
      begin
        EUShowError(Handle, Error);
        Exit;
      end;

    end;

  end
  else if (SignHashCheckBox.Enabled and SignHashCheckBox.Checked) then
  begin

    Error := HashFile(PAnsiChar(TargetFile), @Hash);
    if (Error <> EU_ERROR_NONE) then
    begin
      if (Error <> EU_ERROR_CANCELED_BY_GUI) then
        EUShowError(Handle, Error);
      Exit;
    end;

    Error := CPInterface.SignHash(Hash, nil, 0, @Sign, nil, nil);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.FreeMemory(PByte(Hash));
      EUShowError(Handle, Error);
      Exit;
    end;

    SignedFileRichEdit.Text := string(Sign);
    CPInterface.FreeMemory(PByte(Hash));
    CPInterface.FreeMemory(PByte(Sign));

  end
  else
  begin

    FileWithSign := TargetFile + AnsiString('.p7s');
    Error := CPInterface.SignFile(PAnsiChar(TargetFile),
      PAnsiChar(FileWithSign),
      not UseInternalSignCheckBox.Checked);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
      Exit;
    end;

  end;

  SignedFileEdit.Text := string(FileWithSign);

  MessageBoxA(Handle, 'Файл підписано',
    'Повідомлення оператору', MB_ICONINFORMATION);
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.SignFileAddButtonClick(Sender: TObject);
var
  TargetFile: AnsiString;
  FileWithSign: AnsiString;
  Hash: PAnsiChar;
  Sign: PAnsiChar;
  Error: Cardinal;
  SignedString: AnsiString;
  IsAlreadySigned: LongBool;

begin

  if (not CPInterface.IsPrivateKeyReaded()) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  TargetFile := AnsiString(SignFileEdit.Text);

  if (Length(TargetFile) = 0) then
  begin
    MessageBoxA(Handle, 'Файл для підпису не обрано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if UseRawSignCheckBox.Checked then
  begin
    MessageBoxA(Handle, 'Додавання підпису до простого підпису не підтримується',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if (SignHashCheckBox.Enabled and SignHashCheckBox.Checked) then
  begin

    SignedString := AnsiString(SignedFileRichEdit.Text);

    if ((SignedString = '') or (Length(SignedString) = 0)) then
    begin
      MessageBoxA(Handle, 'Підпис відсутній',
        'Повідомлення оператору', MB_ICONERROR);
      Exit;
    end;

    Error := CPInterface.IsAlreadySigned(PAnsiChar(SignedString), nil, 0,
      @IsAlreadySigned);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
      Exit;
    end;

    if IsAlreadySigned then
    begin
      MessageBoxA(Handle, 'Файл вже підписаний користувачем',
        'Повідомлення оператору', MB_ICONERROR);
      Exit;
    end;

    Error := HashFile(PAnsiChar(TargetFile), @Hash);
    if (Error <> EU_ERROR_NONE) then
    begin
      if (Error <> EU_ERROR_CANCELED_BY_GUI) then
        EUShowError(Handle, Error);
      Exit;
    end;

    Error := CPInterface.AppendSignHash(Hash, nil, 0,
      PAnsiChar(SignedString), nil, 0, @Sign, nil, nil);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.FreeMemory(PByte(Hash));
      EUShowError(Handle, Error);
      Exit;
    end;

    SignedFileRichEdit.Text := string(Sign);
    CPInterface.FreeMemory(PByte(Hash));
    CPInterface.FreeMemory(PByte(Sign));

  end
  else
  begin

    FileWithSign := TargetFile + AnsiString('.p7s');

    Error := CPInterface.IsFileAlreadySigned(PAnsiChar(FileWithSign),
      @IsAlreadySigned);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
      Exit;
    end;

    if IsAlreadySigned then
    begin
      MessageBoxA(Handle, 'Файл вже підписаний користувачем',
        'Повідомлення оператору', MB_ICONERROR);
      Exit;
    end;

    Error := CPInterface.AppendSignFile(PAnsiChar(TargetFile),
      PAnsiChar(FileWithSign), PAnsiChar(FileWithSign),
      not UseInternalSignCheckBox.Checked);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
      Exit;
    end;

  end;

  SignedFileEdit.Text := string(FileWithSign);

  MessageBoxA(Handle, 'Файл підписано',
    'Повідомлення оператору', MB_ICONINFORMATION);
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.VerifyFileButtonClick(Sender: TObject);
var
  Error: Cardinal;
  TargetFile: AnsiString;
  DataFile: AnsiString;
  Hash: PAnsiChar;
  SignedString: AnsiString;
  SignInfo: TEUSignInfo;

begin

  if (Length(SignedFileEdit.Text) = 0) then
  begin
    MessageBoxA(Handle, 'Файл для перевірки підпису не обрано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  TargetFile := AnsiString(SignedFileEdit.Text);

  if UseInternalSignCheckBox.Checked then
  begin
    DataFile := TargetFile + AnsiString('.new');
  end
  else if UseInternalSignCheckBox.Enabled then
  begin
    DataFile := LeftStr(TargetFile, Length(TargetFile) - 4);
  end
  else if UseRawSignCheckBox.Checked then
  begin
    DataFile := LeftStr(TargetFile, Length(TargetFile) - 8);
  end;

  if UseRawSignCheckBox.Checked then
  begin

    if SignHashCheckBox.Checked then
    begin

      Error := HashFile(PAnsiChar(TargetFile), @Hash);
      if (Error <> EU_ERROR_NONE) then
      begin
        if (Error <> EU_ERROR_CANCELED_BY_GUI) then
          EUShowError(Handle, Error);
        Exit;
      end;

      SignedString := AnsiString(SignedFileRichEdit.Text);

      Error := CPInterface.RawVerifyHash(Hash, nil, 0,
        PAnsiChar(SignedString), nil, 0, @SignInfo);
      if (Error <> EU_ERROR_NONE) then
      begin
        CPInterface.FreeMemory(PByte(Hash));
        EUShowError(Handle, Error);
        Exit;
      end;

      CPInterface.FreeMemory(PByte(Hash));

    end
    else
    begin
      Error := CPInterface.RawVerifyFile(PAnsiChar(TargetFile),
        PAnsiChar(DataFile), @SignInfo);
      if (Error <> EU_ERROR_NONE) then
      begin
        EUShowError(Handle, Error);
        Exit;
      end;
    end;

  end
  else if (SignHashCheckBox.Enabled and SignHashCheckBox.Checked) then
  begin

    Error := HashFile(PAnsiChar(TargetFile), @Hash);
    if (Error <> EU_ERROR_NONE) then
    begin
      if (Error <> EU_ERROR_CANCELED_BY_GUI) then
        EUShowError(Handle, Error);
      Exit;
    end;

    SignedString := AnsiString(SignedFileRichEdit.Text);

    Error := CPInterface.VerifyHash(Hash, nil, 0,
      PAnsiChar(SignedString), nil, 0, @SignInfo);
    if (Error <> EU_ERROR_NONE) then
    begin
      CPInterface.FreeMemory(PByte(Hash));
      EUShowError(Handle, Error);
      Exit;
    end;

    CPInterface.FreeMemory(PByte(Hash));

  end
  else
  begin

    Error := CPInterface.VerifyFile(PAnsiChar(TargetFile), PAnsiChar(DataFile),
      @SignInfo);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
      Exit;
    end;

  end;

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.VerifyFileSignNextButtonClick(Sender: TObject);
var
  TargetFile: AnsiString;
  DataFile: AnsiString;
  Hash: PAnsiChar;
  SignedString: AnsiString;
  Error: Cardinal;
  SignInfo: TEUSignInfo;
  SignCount: Cardinal;

begin
  TargetFile := AnsiString(SignedFileEdit.Text);

  if (Length(TargetFile) = 0) then
  begin
    MessageBoxA(Handle, 'Файл для перевірки підпису не обрано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if UseRawSignCheckBox.Checked then
  begin
    MessageBoxA(Handle, 'Додавання підпису до простого підпису не підтримується',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if UseInternalSignCheckBox.Enabled then
  begin

    Error := CPInterface.GetFileSignsCount(PAnsiChar(TargetFile), @SignCount);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
      Exit;
    end;

    if (SignCount = 0) then
    begin
      MessageBoxA(Handle, 'Підписи відсутні',
        'Повідомлення оператору', MB_ICONERROR);
      Exit;
    end;

    if UseInternalSignCheckBox.Checked then
    begin
      DataFile := TargetFile + AnsiString('.new');
    end
    else
      DataFile := LeftStr(TargetFile, Length(TargetFile) - 4);

  end
  else
  begin
  
    SignedString := AnsiString(SignedFileRichEdit.Text);
	
    Error := CPInterface.GetSignsCount(PAnsiChar(SignedString), nil, 0,
      @SignCount);
    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
      Exit;
    end;

    if (SignCount = 0) then
    begin
      MessageBoxA(Handle, 'Підписи відсутні',
      'Повідомлення оператору', MB_ICONERROR);
      Exit;
    end;

  end;

  VerifyFileSignNextButton.Caption := 'Перевірити (' +
    IntToStr(VerifyFileSignIndex + 1) + ' з ' + IntToStr(SignCount) + ')...';

  if (SignHashCheckBox.Enabled and SignHashCheckBox.Checked) then
  begin

    Error := HashFile(PAnsiChar(TargetFile), @Hash);
    if (Error = EU_ERROR_NONE) then
    begin
      Error := CPInterface.VerifyHashSpecific(Hash, nil, 0, 
		VerifyFileSignIndex, PAnsiChar(SignedString), nil, 0, @SignInfo);
      CPInterface.FreeMemory(PByte(Hash));
    end;

    if (Error = EU_ERROR_CANCELED_BY_GUI) then
      Exit;
  end
  else
  begin

    Error := CPInterface.VerifyFileSpecific(VerifyFileSignIndex,
      PAnsiChar(TargetFile), PAnsiChar(DataFile), @SignInfo);

  end;

  VerifyFileSignIndex := (VerifyFileSignIndex + 1) Mod SignCount;

  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, AnsiString('Підписані дані(Підпис №' +
      IntToStr(VerifyFileSignIndex + 1) + ')'), @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);
end;

{ ============================================================================== }

procedure TSignFrame.ChooseSignFileButtonClick(Sender: TObject);
begin
  TargetFileOpenDialog.Title := 'Оберіть файл для підпису';
  if (not TargetFileOpenDialog.Execute(Handle)) then
    Exit;
    
   SignFileEdit.Text := TargetFileOpenDialog.FileName;
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.ChooseSignedFileButtonClick(Sender: TObject);
begin
  TargetFileOpenDialog.Title := 'Оберіть файл з підписом';

  if (not TargetFileOpenDialog.Execute(Handle)) then
    Exit;

   SignedFileEdit.Text := TargetFileOpenDialog.FileName;
end; 

{ ============================================================================== }

procedure TSignFrame.SignedFileEditChange(Sender: TObject);
begin
  VerifyFileSignIndex := 0;
  VerifyFileSignNextButton.Caption := 'Перевірити наступний...';
end;

{ ============================================================================== }

procedure TSignFrame.FullDataTestButtonClick(Sender: TObject);
var
  Data, VerifiedData, Sign, SignedData, Hash: PByte;
  DataSize, VerifiedDataSize, SignSize, SignedDataSize, HashSize,
    Error: Cardinal;
  SignStringing, SignedDataString, HashStringing: PAnsiChar;
  SignInfo: TEUSignInfo;

begin

  if (not CPInterface.IsPrivateKeyReaded()) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  DataSize := $00800000;
  Data := GetMemory(DataSize);
  if (Data = nil) then
  begin
    MessageBoxA(Handle, 'Недостатньо ресурсів для завершення операції',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  Error := CPInterface.SignData(Data, DataSize, nil, @Sign, @SignSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.VerifyData(Data, DataSize, nil, Sign, SignSize,
    @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(Sign);
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  CPInterface.FreeMemory(Sign);

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);

  Error := CPInterface.SignData(Data, DataSize, @SignStringing, nil, nil);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.VerifyData(Data, DataSize, SignStringing, nil, 0,
    @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(PByte(SignStringing));
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  CPInterface.FreeMemory(PByte(SignStringing));

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);

  Error := CPInterface.SignDataContinue(Data, DataSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.SignDataEnd(nil, @Sign, @SignSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.VerifyDataBegin(nil, Sign, SignSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(Sign);
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  CPInterface.FreeMemory(Sign);

  Error := CPInterface.VerifyDataContinue(Data, DataSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.VerifyDataEnd(@SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);

  Error := CPInterface.SignDataContinue(Data, DataSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.SignDataEnd(@SignStringing, nil, nil);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.VerifyDataBegin(SignStringing, nil, 0);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(PByte(SignStringing));
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  CPInterface.FreeMemory(PByte(SignStringing));

  Error := CPInterface.VerifyDataContinue(Data, DataSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.VerifyDataEnd(@SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);

  Error := CPInterface.SignDataInternal(True, Data, DataSize, nil, @SignedData,
    @SignedDataSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.VerifyDataInternal(nil, SignedData, SignedDataSize,
    @VerifiedData, @VerifiedDataSize, @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(SignedData);
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  CPInterface.FreeMemory(SignedData);

  if ((VerifiedDataSize <> DataSize) or
      (not CompareMem(Data, VerifiedData, DataSize))) then
  begin
    CPInterface.FreeMemory(VerifiedData);
    FreeMemory(Data);
    MessageBoxA(Handle, 'Виникла помилка при перевірці підпису',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);
  CPInterface.FreeMemory(VerifiedData);

  Error := CPInterface.SignDataInternal(True, Data, DataSize, 
	@SignedDataString, nil, nil);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.VerifyDataInternal(SignedDataString, nil, 0,
    @VerifiedData, @VerifiedDataSize, @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(PByte(SignedDataString));
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  CPInterface.FreeMemory(PByte(SignedDataString));

  if ((VerifiedDataSize <> DataSize) or
      (not CompareMem(Data, VerifiedData, DataSize))) then
  begin
    CPInterface.FreeMemory(VerifiedData);
    FreeMemory(Data);
    MessageBoxA(Handle, 'Виникла помилка при перевірці підпису',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);
  CPInterface.FreeMemory(VerifiedData);

  Error := CPInterface.RawSignData(Data, DataSize, nil, @Sign, @SignSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.RawVerifyData(Data, DataSize, nil, 
	Sign, SignSize, @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(Sign);
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  CPInterface.FreeMemory(Sign);

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);

  Error := CPInterface.RawSignData(Data, DataSize, @SignStringing, nil, nil);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.RawVerifyData(Data, DataSize, SignStringing, nil, 0,
    @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(PByte(SignStringing));
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  CPInterface.FreeMemory(PByte(SignStringing));

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);

  Error := CPInterface.HashData(Data, DataSize, nil, @Hash, @HashSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.RawSignHash(nil, Hash, HashSize, nil, @Sign, @SignSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(Hash);
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.RawVerifyHash(nil, Hash, HashSize, nil, Sign, SignSize,
    @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(Sign);
    CPInterface.FreeMemory(Hash);
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  CPInterface.FreeMemory(Sign);
  CPInterface.FreeMemory(Hash);

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);

  Error := CPInterface.HashData(Data, DataSize, @HashStringing, nil, nil);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.RawSignHash(HashStringing, nil, 0, @SignStringing,
    nil, nil);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(PByte(HashStringing));
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.RawVerifyHash(HashStringing, nil, 0, SignStringing, nil,
    0, @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(PByte(SignStringing));
    CPInterface.FreeMemory(PByte(HashStringing));
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  CPInterface.FreeMemory(PByte(SignStringing));
  CPInterface.FreeMemory(PByte(HashStringing));

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @SignInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@SignInfo);

  CPInterface.FreeSignInfo(@SignInfo);
  FreeMemory(Data);

  MessageBoxA(Handle, 'Тестування виконано успішно',
    'Повідомлення оператору', MB_ICONINFORMATION);
end;

{ ------------------------------------------------------------------------------ }

function TSignFrame.SignFilesTest(FileName: AnsiString; useTSP: Boolean): Cardinal;
var
  FileOutName: AnsiString;
  FileVersion: AnsiString;
  TSP: AnsiString;

begin
  FileVersion := '.13';

  if useTSP then
  begin
    TSP := '.tsp';
  end
  else
    TSP := '';

  FileOutName := AnsiString(FileName + FileVersion + TSP + '.raw.sig');
  Result := CPInterface.RawSignFile(PAnsiChar(FileName),
    PAnsiChar(FileOutName));
  if (Result <> EU_ERROR_NONE) then
    Exit;

  FileOutName := AnsiString(FileName + FileVersion + TSP + '.crt.p7s');
  Result := CPInterface.SignFile(PAnsiChar(FileName),
    PAnsiChar(FileOutName), True);
  if (Result <> EU_ERROR_NONE) then
    Exit;

  FileOutName := AnsiString(FileName + FileVersion + TSP + '.int.crt.p7s');
  Result := CPInterface.SignFile(PAnsiChar(FileName),
    PAnsiChar(FileOutName), False);
  if (Result <> EU_ERROR_NONE) then
    Exit;
end;

{ ------------------------------------------------------------------------------ }

function TSignFrame.VerifyFilesTest(FileName: AnsiString; useTSP: Boolean): Cardinal;
var
  FileOutName: AnsiString;
  FileVersion: AnsiString;
  TSP: AnsiString;
  SignInfo: TEUSignInfo;

begin
  FileVersion := '.13';

  if useTSP then
  begin
    TSP := '.tsp';
  end
  else
    TSP := '';

  FileOutName := AnsiString(FileName + FileVersion + TSP + '.raw.sig');
  Result := CPInterface.RawVerifyFile(PAnsiChar(FileOutName),
    PAnsiChar(FileName), @SignInfo);
  if (Result <> EU_ERROR_NONE) then
    Exit;

  CPInterface.FreeSignInfo(@SignInfo);

  FileOutName := AnsiString(FileName + FileVersion + TSP + '.crt.p7s');
  Result := CPInterface.VerifyFile(PAnsiChar(FileOutName),
    PAnsiChar(FileName), @SignInfo);
  if (Result <> EU_ERROR_NONE) then
    Exit;

  CPInterface.FreeSignInfo(@SignInfo);

  FileOutName := AnsiString(FileName + FileVersion + TSP + '.int.crt.p7s');
  Result := CPInterface.VerifyFile(PAnsiChar(FileOutName),
    PAnsiChar(FileName + '.new'), @SignInfo);
  if (Result <> EU_ERROR_NONE) then
    Exit;

  CPInterface.FreeSignInfo(@SignInfo);
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.FullFileTestButtonClick(Sender: TObject);
var
  FileName: AnsiString;
  TSP: TEUSettingsTSP;
  Error: Cardinal;

begin
  if (not CPInterface.IsPrivateKeyReaded()) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  TargetFileOpenDialog.Title := 'Оберіть файл для тестування';
  if (not TargetFileOpenDialog.Execute()) then
	  Exit;

  FileName := TargetFileOpenDialog.FileName;
  if (Length(FileName) = 0) then
  begin
    MessageBoxA(Handle, 'Файл для тестування підпису файлів не обрано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  Error := CPInterface.GetTSPSettings(@TSP.GetStamps, @TSP.Address,
    @TSP.Port);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  if (not TSP.GetStamps) then
  begin
    MessageBoxA(Handle, 'Встановіть налаштування TSP-сервера',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  Error := CPInterface.SetTSPSettings(False, @TSP.Address, @TSP.Port);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := SignFilesTest(FileName, False);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    CPInterface.SetTSPSettings(True, @TSP.Address, @TSP.Port);
    Exit;
  end;

  Error := VerifyFilesTest(FileName, False);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    CPInterface.SetTSPSettings(True, @TSP.Address, @TSP.Port);
    Exit;
  end;

  Error := CPInterface.SetTSPSettings(True, @TSP.Address, @TSP.Port);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := SignFilesTest(FileName, True);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := VerifyFilesTest(FileName, True);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  MessageBoxA(Handle, 'Тестування виконано успішно',
    'Повідомлення оператору', MB_ICONINFORMATION);
end;

{ ------------------------------------------------------------------------------ }

procedure TSignFrame.FullStreamTestButtonClick(Sender: TObject);
var
  FileName: string;
  FileStream: TFileStream;
  HashStream: TMemoryStream;
  HashString: TStringStream;
  SignStream: TMemoryStream;
  SignString: TStringStream;
  SignInfo: TEUSignInfo;
  Error: Cardinal;

begin

  if (not CPInterface.IsPrivateKeyReaded()) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  TargetFileOpenDialog.Title := 'Оберіть файл для тестування функцій підпису потоків';

  if (not TargetFileOpenDialog.Execute()) then
	  Exit;

  FileName := TargetFileOpenDialog.FileName;
  if (Length(FileName) = 0) then
  begin
    MessageBoxA(Handle, 'Файл для тестування функцій підпису потоків не обрано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  FileStream := TFileStream.Create(FileName, fmOpenRead);

  HashStream := TMemoryStream.Create();
{$if CompilerVersion > 19}
  HashString := TStringStream.Create('', TEncoding.ASCII);
{$else}
  HashString := TStringStream.Create('');
{$ifend}

  SignStream := TMemoryStream.Create();
{$if CompilerVersion > 19}
  SignString := TStringStream.Create('', TEncoding.ASCII);
{$else}
  SignString := TStringStream.Create('');
{$ifend}

  FileStream.Position := 0;

  Error := EUSignCP.EUHashStream(CPInterface, FileStream, HashStream);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    Exit;
  end;

  FileStream.Position := 0;

  Error := EUSignCP.EUHashStream(CPInterface, FileStream, HashString);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  HashStream.Position := 0;

  Error := EUSignCP.EUSignStreamHash(CPInterface, HashStream, SignStream);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  HashStream.Position := 0;
  SignStream.Position := 0;

  Error := EUSignCP.EUVerifyStreamHash(CPInterface, HashStream, SignStream,
    @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  HashString.Position := 0;
  SignStream.Clear;

  Error := EUSignCP.EUSignStreamHash(CPInterface, HashString, SignStream);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  HashString.Position := 0;
  SignStream.Position := 0;

  Error := EUSignCP.EUVerifyStreamHash(CPInterface, HashString, SignStream,
    @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  HashStream.Position := 0;

  Error := EUSignCP.EUSignStreamHash(CPInterface, HashStream, SignString);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  HashStream.Position := 0;
  SignString.Position := 0;

  Error := EUSignCP.EUVerifyStreamHash(CPInterface, HashStream, SignString,
    @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  HashString.Position := 0;
  SignString.Position := 0;
  SignString.Size := 0;

  Error := EUSignCP.EUSignStreamHash(CPInterface, HashString, SignString);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  HashString.Position := 0;
  SignString.Position := 0;

  Error := EUSignCP.EUVerifyStreamHash(CPInterface, HashString, SignString,
    @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  FileStream.Position := 0;
  SignStream.Clear;

  Error := EUSignCP.EUSignStream(CPInterface, FileStream, SignStream);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  FileStream.Position := 0;
  SignStream.Position := 0;

  Error := EUSignCP.EUVerifyStream(CPInterface, FileStream, SignStream,
    @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  FileStream.Position := 0;
  SignString.Position := 0;
  SignString.Size := 0;

  Error := EUSignCP.EUSignStream(CPInterface, FileStream, SignString);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  FileStream.Position := 0;
  SignString.Position := 0;

  Error := EUSignCP.EUVerifyStream(CPInterface, FileStream, SignString,
    @SignInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    FileStream.Destroy;
    HashStream.Destroy;
    HashString.Destroy;
    SignStream.Destroy;
    SignString.Destroy;

    EUShowError(Handle, Error);
    Exit;
  end;

  MessageBoxA(Handle, 'Тестування потокових функцій виконано успішно',
    'Повідомлення оператору', MB_OK);

  FileStream.Destroy;
  HashStream.Destroy;
  HashString.Destroy;
  SignStream.Destroy;
  SignString.Destroy;
end;

{ ============================================================================== }

end.


