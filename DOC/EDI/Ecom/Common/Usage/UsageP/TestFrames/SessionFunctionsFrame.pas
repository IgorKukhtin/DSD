unit SessionFunctionsFrame;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,
  EUSignCP, EUSignCPOwnUI, Certificate;

{ ------------------------------------------------------------------------------ }

type
  TTestSessionFrame = class(TFrame)
    SessionParamsPanel: TPanel;
    SessionParamsUnderlineImage: TImage;
    SessionParamsTitleLabel: TLabel;
    SessionCertExpireTimeLabel: TLabel;
    SessionCertExpireTimeEdit: TEdit;
    SessionClientPanel: TPanel;
    ClientSessionUnderlineImage: TImage;
    SessionClientTitleLabel: TLabel;
    ShowServerCertButton: TButton;
    LoadClientSessionButton: TButton;
    SaveClientSessionButton: TButton;
    ClientFileWithSessionLabel: TLabel;
    ClientFileWithSessionEdit: TEdit;
    ChooseClientFileWithSessionButton: TButton;
    DataToEncryptLabel: TLabel;
    DataToEncryptEdit: TEdit;
    EncryptButton: TButton;
    EncryptSyncButton: TButton;
    SessionServerPanel: TPanel;
    ServerSessionUnderlineImage: TImage;
    SessionServerTitleLabel: TLabel;
    ServerFileWithSessionLabel: TLabel;
    EncryptedDataLabel: TLabel;
    ShowClientCertButton: TButton;
    LoadServerButton: TButton;
    SaveServerSessionButton: TButton;
    ServerFileWithSessionEdit: TEdit;
    ChooseServerFileWithSessionButton: TButton;
    EncryptedDataEdit: TEdit;
    DecryptButton: TButton;
    DecryptSyncButton: TButton;
    DecryptedDataEdit: TEdit;
    DecryptedDataLabel: TLabel;
    TestSessionPanel: TPanel;
    TestSessionTitleLabel: TLabel;
    TestSessionButton: TButton;
    SessionInitPanel: TPanel;
    SessionInitUnderlineImage: TImage;
    SessionInitTitleLabel: TLabel;
    SessionInitButton: TButton;
    SessionClientCheckStateButton: TButton;
    SessionCheckCertsButton: TButton;
    TargetFileOpenDialog: TOpenDialog;
    SessionServerCheckButton: TButton;
    procedure SessionInitButtonClick(Sender: TObject);
    procedure SessionTestButtonClick(Sender: TObject);
    procedure ChooseSessionFileButtonClick(Sender: TObject);
    procedure LoadSessionButtonClick(Sender: TObject);
    procedure SaveSessionButtonClick(Sender: TObject);
    procedure SessionCheckStateButtonClick(Sender: TObject);
    procedure EncryptSyncButtonClick(Sender: TObject);
    procedure EncryptButtonClick(Sender: TObject);
    procedure ShowCertButtonClick(Sender: TObject);
    procedure DecryptSyncButtonClick(Sender: TObject);
    procedure DecryptButtonClick(Sender: TObject);
    procedure SessionCheckCertsButtonClick(Sender: TObject);

  private
    CPInterface: PEUSignCP;
    UseOwnUI: Boolean;
    UserSession, ServerSession: PVOID;
    procedure ChangeControlsState(Enabled: Boolean);
    function SessionInitialize(ExpireTime: Cardinal; ClientSession,
      ServerSession: PPVOID): Cardinal;
    procedure ChangeSessionButtonsState(Enabled: Boolean);

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

procedure TTestSessionFrame.ChangeSessionButtonsState(Enabled: Boolean);
begin
  if Enabled then
  begin
    SessionInitButton.Caption := 'Завершити сесію...';
  end
  else
  begin
    SessionInitButton.Caption := 'Ініціалізувати сесію...';
    DataToEncryptEdit.Text := '';
    EncryptedDataEdit.Text := '';
    DecryptedDataEdit.Text := '';
  end;

  SessionCheckCertsButton.Enabled := Enabled;
  SaveClientSessionButton.Enabled := Enabled;
  EncryptButton.Enabled := Enabled;
  EncryptSyncButton.Enabled := Enabled;
  ShowServerCertButton.Enabled := Enabled;
  DecryptButton.Enabled := Enabled;
  DecryptSyncButton.Enabled := Enabled;
  SaveServerSessionButton.Enabled := Enabled;
  ShowClientCertButton.Enabled := Enabled;
end;

{ ------------------------------------------------------------------------------ }

procedure TTestSessionFrame.ChangeControlsState(Enabled: Boolean);
var
  IsSessionInitialized: Boolean;

begin
  SessionCertExpireTimeEdit.Enabled := Enabled;
  LoadClientSessionButton.Enabled := Enabled;
  ClientFileWithSessionEdit.Enabled := Enabled;
  ChooseClientFileWithSessionButton.Enabled := Enabled;
  DataToEncryptEdit.Enabled := Enabled;
  LoadServerButton.Enabled := Enabled;
  ServerFileWithSessionEdit.Enabled := Enabled;
  ChooseServerFileWithSessionButton.Enabled := Enabled;
  EncryptedDataEdit.Enabled := Enabled;
  DecryptedDataEdit.Enabled := Enabled;
  TestSessionButton.Enabled := Enabled;
  SessionInitButton.Enabled := Enabled;
  SessionClientCheckStateButton.Enabled := Enabled;
  SessionServerCheckButton.Enabled := Enabled;

  IsSessionInitialized := ((UserSession <> nil) and (ServerSession <> nil));
  ChangeSessionButtonsState(Enabled and IsSessionInitialized);
end;

{ ------------------------------------------------------------------------------ }

procedure TTestSessionFrame.Initialize(CPInterface: PEUSignCP; UseOwnUI: Boolean);
begin
  self.CPInterface := CPInterface;
  self.UseOwnUI := UseOwnUI;
  UserSession := nil;
  ServerSession := nil;
  ChangeControlsState(False);
end;

{ ------------------------------------------------------------------------------ }

procedure TTestSessionFrame.Deinitialize();
begin
  ClientFileWithSessionEdit.Text := '';
  ServerFileWithSessionEdit.Text := '';
  ChangeControlsState(False);
  if (UserSession <> nil) then
    CPInterface.SessionDestroy(UserSession);

  if (ServerSession <> nil) then
    CPInterface.SessionDestroy(ServerSession);

  self.CPInterface := nil;
  self.UseOwnUI := false;
end;

{ ------------------------------------------------------------------------------ }

procedure TTestSessionFrame.WillShow();
var
  Enabled: Boolean;

begin
  Enabled := ((CPInterface <> nil) and
    CPInterface.IsInitialized and
    CPInterface.IsPrivateKeyReaded());

  ChangeControlsState(Enabled);
end;

{ ============================================================================== }

function TTestSessionFrame.SessionInitialize(ExpireTime: Cardinal; ClientSession,
  ServerSession: PPVOID): Cardinal;
var
  ClientData: PByte;
  ClientDataLength: Cardinal;
  ServerData: PByte;
  ServerDataLength: Cardinal;

begin
  Result := CPInterface.ClientSessionCreateStep1(ExpireTime, ClientSession,
    @ClientData, @ClientDataLength);
  if (Result <> EU_ERROR_NONE) then
    Exit;

  Result := CPInterface.ServerSessionCreateStep1(ExpireTime, ClientData,
    ClientDataLength, ServerSession, @ServerData, @ServerDataLength);
  if (Result <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(ClientData);
    CPInterface.SessionDestroy(ClientSession^);
    Exit;
  end;

  CPInterface.FreeMemory(ClientData);

  Result := CPInterface.ClientSessionCreateStep2(ClientSession^,
    ServerData, ServerDataLength, @ClientData, @ClientDataLength);

  if (Result <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(ServerData);
    CPInterface.SessionDestroy(ClientSession^);
    CPInterface.SessionDestroy(ServerSession^);
    Exit;
  end;

  CPInterface.FreeMemory(ServerData);

  Result := CPInterface.ServerSessionCreateStep2(ServerSession^, ClientData,
    ClientDataLength);

  if (Result <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(ClientData);
    CPInterface.SessionDestroy(ClientSession^);
    CPInterface.SessionDestroy(ServerSession^);
    Exit;
  end;

  CPInterface.FreeMemory(ClientData);
end;

{ ------------------------------------------------------------------------------ }

procedure TTestSessionFrame.SessionInitButtonClick(Sender: TObject);
var
  Error: Cardinal;
  ExpireTime: Cardinal;

begin
  if ((UserSession <> nil) and (ServerSession <> nil))then
  begin
    LoadClientSessionButton.Enabled := True;
    CPInterface.SessionDestroy(UserSession);
    UserSession := nil;
    LoadServerButton.Enabled := True;
    CPInterface.SessionDestroy(ServerSession);
    ServerSession := nil;
    ChangeSessionButtonsState(False);
  end
  else
  begin
    if (not CPInterface.IsPrivateKeyReaded()) then
    begin
      MessageBoxA(Handle, 'Особистий ключ не зчитано',
        'Повідомлення оператору', MB_ICONERROR);
    Exit;
    end;

    if (UserSession <> nil) then
    begin
      CPInterface.SessionDestroy(UserSession);
      UserSession := nil;
    end;

    if (ServerSession <> nil) then
    begin
      CPInterface.SessionDestroy(ServerSession);
      ServerSession := nil;
    end;

    ExpireTime := StrToInt(SessionCertExpireTimeEdit.Text);
    Error := SessionInitialize(ExpireTime, @UserSession, @ServerSession);
    if (Error <> EU_ERROR_NONE) then
    begin
      UserSession := nil;
      ServerSession := nil;
      EUShowError(Handle, Error);
      Exit;
    end;
    LoadClientSessionButton.Enabled := False;
    LoadServerButton.Enabled := False;
    ChangeSessionButtonsState(True);
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TTestSessionFrame.SessionCheckCertsButtonClick(Sender: TObject);
begin
  if CPInterface.SessionCheckCertificates(UserSession) then
  begin
    EUShowError(Handle, Error);
  end
  else
  begin
    MessageBoxA(Handle, 'Сертифікати сесії успішно перевірені',
      'Повідомлення оператору', MB_ICONINFORMATION);
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TTestSessionFrame.SessionCheckStateButtonClick(Sender: TObject);
var
  Session: System.Pointer;

begin
  if (Sender = SessionClientCheckStateButton) then
  begin
    Session := UserSession;
  end
  else
    Session := ServerSession;

  if ((Session <> nil) and
      CPInterface.SessionIsInitialized(Session)) then
  begin
    MessageBoxA(Handle, 'Сесія ініціалізована',
      'Повідомлення оператору', MB_ICONINFORMATION);
  end
  else
  begin
    MessageBoxA(Handle, 'Сесія не ініціалізована',
      'Повідомлення оператору', MB_ICONERROR);
  end;
end;

{ ============================================================================== }

procedure TTestSessionFrame.ChooseSessionFileButtonClick(Sender: TObject);
begin
  if (not TargetFileOpenDialog.Execute(Handle)) then
    Exit;

  if (Sender = ChooseClientFileWithSessionButton) then
  begin
    ClientFileWithSessionEdit.Text := TargetFileOpenDialog.FileName;
  end
  else
    ServerFileWithSessionEdit.Text := TargetFileOpenDialog.FileName;
end;

{ ------------------------------------------------------------------------------ }

procedure TTestSessionFrame.LoadSessionButtonClick(Sender: TObject);
var
  FileName: AnsiString;
  FileStream: TFileStream;
  Error: Cardinal;
  SessionData: PByte;
  SessionDataSize: Int64;

begin
  if (Sender = LoadClientSessionButton) then
  begin
    FileName := AnsiString(ClientFileWithSessionEdit.Text);
  end
  else
    FileName := AnsiString(ServerFileWithSessionEdit.Text);

  if (FileName = '') then
  begin
    MessageBoxA(Handle, 'Файл з сесією не обрано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  FileStream := nil;
  SessionData := nil;

  if ((ServerSession <> nil) and (UserSession <> nil)) then
     SessionInitButtonClick(nil);

  try
    FileStream := TFileStream.Create(string(FileName), fmOpenRead);
    FileStream.Seek(0, soBeginning);

    SessionDataSize := FileStream.Size;
    SessionData := GetMemory(SessionDataSize);
    FileStream.Read(SessionData^, SessionDataSize);

    if (Sender = LoadClientSessionButton) then
    begin
      if (UserSession <> nil) then
      begin
        CPInterface.SessionDestroy(UserSession);
        UserSession := nil;
      end;

      Error := CPInterface.SessionLoad(SessionData,
        Cardinal(SessionDataSize), @UserSession);
    end
    else
    begin
      if (ServerSession <> nil) then
      begin
        CPInterface.SessionDestroy(ServerSession);
        ServerSession := nil;
      end;

      Error := CPInterface.SessionLoad(SessionData,
        Cardinal(SessionDataSize), @ServerSession);
    end;

    if (Error <> EU_ERROR_NONE) then
    begin
      EUShowError(Handle, Error);
    end
    else
      MessageBoxA(Handle, 'Сесія успішно завантажена',
        'Повідомлення оператору', MB_ICONINFORMATION);

    if ((ServerSession <> nil) and (UserSession <> nil)) then
    begin
      LoadClientSessionButton.Enabled := False;
      LoadServerButton.Enabled := False;
      ChangeSessionButtonsState(True);
    end;
  finally
    if (FileStream <> nil) then
      FileStream.Destroy;
    if (SessionData <> nil) then
      FreeMemory(SessionData);
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TTestSessionFrame.SaveSessionButtonClick(Sender: TObject);
var
  Error: Cardinal;
  FileName: AnsiString;
  SessionDataStream: TMemoryStream;
  SessionData: PByte;
  SessionDataSize: Cardinal;

begin
  if (Sender = SaveClientSessionButton) then
  begin
    FileName := AnsiString(ClientFileWithSessionEdit.Text);
  end
  else
    FileName := AnsiString(ServerFileWithSessionEdit.Text);

  if (FileName = '') then
  begin
    MessageBoxA(Handle, 'Файл для збереження сесії не обрано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  SessionData := nil;

  if (Sender = SaveClientSessionButton) then
  begin
    Error := CPInterface.SessionSave(UserSession, @SessionData,
      @SessionDataSize);
  end
  else
  begin
    Error := CPInterface.SessionSave(ServerSession, @SessionData,
      @SessionDataSize);
  end;

  if (Error <> EU_ERROR_NONE) then
    EUShowError(Handle, Error);

  SessionDataStream := TMemoryStream.Create();
  if ((not EUDataToStream(SessionData, SessionDataSize, SessionDataStream)) or
      (not EUWriteToFile(FileName, SessionDataStream))) then
  begin
    MessageBoxA(Handle, 'Виникла помилка при збереженні сесії до файла',
      'Повідомлення оператору', MB_ICONERROR);
    SessionDataStream.Destroy();
    CPInterface.FreeMemory(SessionData);
    Exit;
  end;

  SessionDataStream.Destroy();
  CPInterface.FreeMemory(SessionData);
end;

{ ============================================================================== }

procedure TTestSessionFrame.EncryptSyncButtonClick(Sender: TObject);
var
  Error: Cardinal;
  DataString: WideString;
  DataStringLength: Cardinal;
  EncryptedData: PByte;
  EncryptedDataLength: Cardinal;
  EncryptedDataString: PAnsiChar;

begin
  DataString := WideString(DataToEncryptEdit.Text);
  EncryptedDataEdit.Text := '';

  if (Length(DataString) > 0) then
  begin
    DataStringLength := (Length(DataString) + 1) * 2;
  end
  else
    DataStringLength := 0;

  Error := CPInterface.SessionEncrypt(UserSession, PByte(DataString),
    DataStringLength, @EncryptedData, @EncryptedDataLength);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.Base64Encode(EncryptedData,
    EncryptedDataLength, @EncryptedDataString);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(EncryptedData);
    EUShowError(Handle, Error);
    Exit;
  end;

  EncryptedDataEdit.Text := string(EncryptedDataString);
  DecryptedDataEdit.Text := '';

  CPInterface.FreeMemory(EncryptedData);
  CPInterface.FreeMemory(PByte(EncryptedDataString));
end;

{ ------------------------------------------------------------------------------ }

procedure TTestSessionFrame.DecryptSyncButtonClick(Sender: TObject);
var
  Error: Cardinal;
  EncryptedDataString: AnsiString;
  EncryptedData: PByte;
  EncryptedDataLength: Cardinal;
  DecryptedData: PByte;
  DecryptedDataLength: Cardinal;

begin
  EncryptedDataString := AnsiString(EncryptedDataEdit.Text);
  Error := CPInterface.Base64Decode(PAnsiChar(EncryptedDataString),
    @EncryptedData, @EncryptedDataLength);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  DecryptedDataEdit.Text := '';

  Error := CPInterface.SessionDecrypt(ServerSession,
    EncryptedData, EncryptedDataLength, @DecryptedData, @DecryptedDataLength);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(EncryptedData);
    EUShowError(Handle, Error);
    Exit;
  end;

  if (DecryptedDataLength > 0) then
    DecryptedDataEdit.Text := String(PWideChar(DecryptedData));

  CPInterface.FreeMemory(EncryptedData);
  CPInterface.FreeMemory(DecryptedData);
end;

{ ------------------------------------------------------------------------------ }

procedure TTestSessionFrame.EncryptButtonClick(Sender: TObject);
var
  Error: Cardinal;
  DataString: WideString;
  EncryptedData: PByte;
  EncryptedDataLength: Cardinal;
  EncryptedDataString: PAnsiChar;

begin
  DataString := WideString(DataToEncryptEdit.Text);
  EncryptedDataEdit.Text := '';

  if (Length(DataString) > 0) then
  begin
    EncryptedDataLength := (Length(DataString) + 1) * 2;
  end
  else
    EncryptedDataLength := 0;

  EncryptedData := GetMemory(EncryptedDataLength);
  if (EncryptedData = nil) then
  begin
    EUShowError(Handle, EU_ERROR_MEMORY_ALLOCATION);
    Exit;
  end;

  CopyMemory(EncryptedData, PByte(DataString), EncryptedDataLength);
  Error := CPInterface.SessionEncryptContinue(UserSession, EncryptedData,
    EncryptedDataLength);

  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(EncryptedData);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.Base64Encode(EncryptedData,
    EncryptedDataLength, @EncryptedDataString);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(EncryptedData);
    EUShowError(Handle, Error);
    Exit;
  end;

  EncryptedDataEdit.Text := string(EncryptedDataString);
  DecryptedDataEdit.Text := '';
  FreeMemory(EncryptedData);
  CPInterface.FreeMemory(PByte(EncryptedDataString));
end;

{ ------------------------------------------------------------------------------ }

procedure TTestSessionFrame.DecryptButtonClick(Sender: TObject);
var
  Error: Cardinal;
  EncryptedDataString: AnsiString;
  EncryptedData: PByte;
  EncryptedDataLength: Cardinal;

begin
  EncryptedDataString := AnsiString(EncryptedDataEdit.Text);
  Error := CPInterface.Base64Decode(PAnsiChar(EncryptedDataString),
    @EncryptedData, @EncryptedDataLength);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  DecryptedDataEdit.Text := '';
  Error := CPInterface.SessionDecryptContinue(ServerSession,
    EncryptedData, EncryptedDataLength);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(EncryptedData);
    EUShowError(Handle, Error);
    Exit;
  end;

  if (EncryptedDataLength > 0) then
    DecryptedDataEdit.Text := String(PWideChar(EncryptedData));

  CPInterface.FreeMemory(EncryptedData);
end;

{ ============================================================================== }

procedure TTestSessionFrame.ShowCertButtonClick(Sender: TObject);
var
  Error: Cardinal;
  Info: TEUCertInfo;
  InfoEx: PEUCertInfoEx;

begin
  if (Sender = ShowClientCertButton) then
  begin
    Error := CPInterface.SessionGetPeerCertificateInfo(UserSession, @Info);
  end
  else
    Error := CPInterface.SessionGetPeerCertificateInfo(ServerSession, @Info);

  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.GetCertificateInfoEx(Info.Issuer, Info.Serial, @InfoEx);
  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeCertificateInfo(@Info);
    EUShowError(Handle, Error);
    Exit;
  end;

  EUShowCertificate(Handle, '', CPInterface, InfoEx, CertStatusDefault, False);
  CPInterface.FreeCertificateInfo(@Info);
  CPInterface.FreeCertificateInfoEx(InfoEx);
end;

{ ============================================================================== }

procedure TTestSessionFrame.SessionTestButtonClick(Sender: TObject);
var
  Error: Cardinal;
  ExpireTime: Cardinal;
  ClientSession: PVOID;
  ServerSession: PVOID;
  ClientData: PByte;
  ClientDataLength: Cardinal;
  ServerData: PByte;
  ServerDataLength: Cardinal;
  DecryptedData: PByte;
  DecryptedDataLength: Cardinal;

begin
  if (not CPInterface.IsPrivateKeyReaded()) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано', 'Повідомлення оператору',
      MB_ICONERROR);
    Exit;
  end;

  ExpireTime := StrToInt(SessionCertExpireTimeEdit.Text);
  Error := CPInterface.ClientSessionCreateStep1(ExpireTime, @ClientSession,
    @ClientData, @ClientDataLength);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.ServerSessionCreateStep1(ExpireTime, ClientData,
    ClientDataLength, @ServerSession, @ServerData, @ServerDataLength);

  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(ClientData);
    CPInterface.SessionDestroy(ClientSession);
    EUShowError(Handle, Error);
    Exit;
  end;

  CPInterface.FreeMemory(ClientData);

  Error := CPInterface.ClientSessionCreateStep2(ClientSession,
    ServerData, ServerDataLength, @ClientData, @ClientDataLength);

  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(ServerData);
    CPInterface.SessionDestroy(ClientSession);
    CPInterface.SessionDestroy(ServerSession);
    EUShowError(Handle, Error);
    Exit;
  end;

  CPInterface.FreeMemory(ServerData);

  Error := CPInterface.ServerSessionCreateStep2(ServerSession, ClientData,
    ClientDataLength);

  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(ClientData);
    CPInterface.SessionDestroy(ClientSession);
    CPInterface.SessionDestroy(ServerSession);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.SessionEncrypt(ClientSession, ClientData, ClientDataLength,
    @ServerData, @ServerDataLength);

  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(ClientData);
    CPInterface.SessionDestroy(ClientSession);
    CPInterface.SessionDestroy(ServerSession);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error :=  CPInterface.SessionDecrypt(ServerSession, ServerData, ServerDataLength,
    @DecryptedData, @DecryptedDataLength);

  if (Error <> EU_ERROR_NONE) then
  begin
    CPInterface.FreeMemory(ClientData);
    CPInterface.FreeMemory(ServerData);
    CPInterface.SessionDestroy(ClientSession);
    CPInterface.SessionDestroy(ServerSession);
    EUShowError(Handle, Error);
    Exit;
  end;

  if (ClientDataLength = DecryptedDataLength) and
    CompareMem(ClientData, DecryptedData, ClientDataLength) then
  begin
    MessageBoxA(Handle, 'Тестування сесії завершено успішно',
      'Повідомлення оператору', MB_ICONINFORMATION);
  end
  else
    MessageBoxA(Handle, 'Виникла помилка при тестуванні сесії',
      'Повідомлення оператору', MB_ICONERROR);

  CPInterface.FreeMemory(ClientData);
  CPInterface.FreeMemory(ServerData);
  CPInterface.FreeMemory(DecryptedData);
  CPInterface.SessionDestroy(ClientSession);
  CPInterface.SessionDestroy(ServerSession);
end;

{ ============================================================================== }

end.


