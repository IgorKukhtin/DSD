unit EnvelopeFunctionsFrame;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, StrUtils, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ComCtrls, ExtCtrls,
  EUSignCP, EUSignCPOwnUI, Certificates;

{ ------------------------------------------------------------------------------ }

type
  PEUBinaryItems = ^TEUBinaryItems;
  TEUBinaryItems = record
    Items: PPByte;
    ItemsSizes: PCardinal;
    Count: Cardinal;
end;

{ ------------------------------------------------------------------------------ }

type
  TEnvelopeFunctionsFrame = class(TFrame)
    SettingsPanel: TPanel;
    SettingsLabel: TLabel;
    SettingsUnderlineImage: TImage;
    AddSignCheckBox: TCheckBox;
    EncryptDataPanel: TPanel;
    SignDataUnderlineImage: TImage;
    DataLabel: TLabel;
    EncryptDataLabel: TLabel;
    EncryptDataTitleLabel: TLabel;
    EncryptDataButton: TButton;
    DecryptDataButton: TButton;
    EncryptedDataRichEdit: TRichEdit;
    EncryptDataEdit: TEdit;
    EncryptFilePanel: TPanel;
    SignFileUnderlineImage: TImage;
    EncryptFileLabel: TLabel;
    EncryptedFileLabel: TLabel;
    EncryptFileTitleLabel: TLabel;
    EncryptFileButton: TButton;
    DecryptFileButton: TButton;
    EncryptFileEdit: TEdit;
    ChooseEncryptFileButton: TButton;
    EncryptedFileEdit: TEdit;
    ChooseEncryptedFileButton: TButton;
    TestPanel: TPanel;
    TestEncryptionLabel: TLabel;
    FullDataTestButton: TButton;
    FullFileTestButton: TButton;
    TargetFileOpenDialog: TOpenDialog;
    DecryptedDataLabel: TLabel;
    DecryptedDataEdit: TEdit;
    DecryptedFileLabel: TLabel;
    DecryptedFileEdit: TEdit;
    ChooseDecryptedFileButton: TButton;
    MultiEnvelopCheckBox: TCheckBox;
    UseDynamycKeysCheckBox: TCheckBox;
    AppendCertCheckBox: TCheckBox;
    RecipientsCertsFromFileCheckBox: TCheckBox;
    procedure EncryptDataButtonClick(Sender: TObject);
    procedure DecryptDataButtonClick(Sender: TObject);
    procedure ChooseEncryptedFileButtonClick(Sender: TObject);
    procedure ChooseEncryptFileButtonClick(Sender: TObject);
    procedure EncryptFileButtonClick(Sender: TObject);
    procedure DecryptFileButtonClick(Sender: TObject);
    procedure FullDataTestButtonClick(Sender: TObject);
    procedure FullFileTestButtonClick(Sender: TObject);
    procedure ChooseDecryptedFileButtonClick(Sender: TObject);
    procedure UseDynamycKeysCheckBoxClick(Sender: TObject);
    procedure AddSignCheckBoxClick(Sender: TObject);

  private
    CPInterface: PEUSignCP;
    UseOwnUI: Boolean;
    procedure ChangeControlsState(Enabled: Boolean);
    procedure ClearAllData();
    function GetOwnCertificateForEnvelop(Info: PPEUCertInfoEx): Cardinal;
    function ChooseCertificatesInfoForEncryption(OnlyOne: Boolean;
      CertsInfo: PEUCertificatesUniqueInfo): Cardinal;
    function ChooseCertificatesFromFile(OnlyOne: Boolean;
      Certificates: PEUBinaryItems): Cardinal;
    function EncryptData(CertsInfo: PEUCertificatesUniqueInfo;
      Data: PByte; DataLength: Cardinal; EnvelopedString: PPAnsiChar): Cardinal;
    function DynamicEncryptData(CertsInfo: PEUCertificatesUniqueInfo;
      Data: PByte; DataLength: Cardinal; EnvelopedString: PPAnsiChar): Cardinal;
    function EncryptDataToRecipients(Data: PByte; DataLength: Cardinal;
      EnvelopedString: PPAnsiChar): Cardinal;
    function EncryptFile(CertsInfo: PEUCertificatesUniqueInfo;
      TargetFile, EncryptedFileName: PAnsiChar) : Cardinal;
    function DynamicEncryptFile(CertsInfo: PEUCertificatesUniqueInfo;
      TargetFile, EncryptedFileName: PAnsiChar) : Cardinal;
    function EncryptFileToRecipients(TargetFile, EncryptedFileName: PAnsiChar)
      : Cardinal;

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

function AllocBinaryItems(Count: Cardinal; Items: PEUBinaryItems): Boolean;
begin
  Items.Count := 0;
  Items.Items := nil;
  Items.ItemsSizes := nil;
  AllocBinaryItems := False;

  Items.Items := AllocMem(Count * SizeOf(PByte));
  if (Items.Items = nil) then
    Exit;

  Items.ItemsSizes := AllocMem(Count * SizeOf(Cardinal));
  if (Items.ItemsSizes = nil) then
  begin
    FreeMem(Items.Items);
    Items.Items := nil;
    Exit;
  end;

  Items.Count := Count;

  AllocBinaryItems := True;
end;

{ ------------------------------------------------------------------------------ }

procedure FreeBinaryItems(Items: PEUBinaryItems);
var
  Index: Integer;
  CurItemDataPointer: PPByte;
begin
  if (Items.Count = 0) then
    Exit;

  if (Items.ItemsSizes <> nil) then
  begin
    FreeMem(Items.ItemsSizes);
    Items.ItemsSizes := nil;
  end;

  if (Items.Items <> nil) then
  begin
    CurItemDataPointer := Items.Items;
    for Index := 0 to (Items.Count - 1) do
    begin
      if (CurItemDataPointer^ <> nil) then
      begin
        FreeMemory(CurItemDataPointer^);
        CurItemDataPointer^ := nil;
      end;
      CurItemDataPointer := Pointer(Cardinal(
        Pointer(CurItemDataPointer)) + SizeOf(PByte));
    end;

    FreeMem(Items.Items);
    Items.Items := nil;
  end;

  Items.Count := 0;
end;

{ ------------------------------------------------------------------------------ }

function CreateBinaryItems(Count: Cardinal; var ItemsData: array of PByte;
  ItemsDataSizes: array of Cardinal; var Items: PEUBinaryItems): Boolean;
var
  Index: Integer;
  CurItemDataPointer: PPByte;
  CurItemDataSizePointer: PCardinal;

begin
  CreateBinaryItems := False;

  if (Length(ItemsData) <> Length(ItemsDataSizes)) then
    Exit;

  if (not AllocBinaryItems(Count, Items)) then
    Exit;

  CurItemDataPointer := Items.Items;
  CurItemDataSizePointer := Items.ItemsSizes;

  for Index := 0 to High(ItemsData) do
  begin
    CurItemDataPointer^ := GetMemory(ItemsDataSizes[Index] * SizeOf(Byte));
    if (CurItemDataPointer^ = nil) then
    begin
      FreeBinaryItems(Items);
      Exit;
    end;

    CopyMemory(CurItemDataPointer^, ItemsData[Index], ItemsDataSizes[Index]);
    CurItemDataSizePointer^ := ItemsDataSizes[Index];

    CurItemDataPointer := Pointer(Cardinal(
      Pointer(CurItemDataPointer)) + SizeOf(PByte));
    CurItemDataSizePointer := Pointer(Cardinal(
      Pointer(CurItemDataSizePointer)) + SizeOf(Cardinal));
  end;


  CreateBinaryItems := True;
end;

{ ============================================================================== }

procedure TEnvelopeFunctionsFrame.ChangeControlsState(Enabled: Boolean);
var
  EncryptWithDynamicKey: Boolean;
  
begin
  if (CPInterface <> nil) then
  begin
    UseDynamycKeysCheckBox.Enabled := CPInterface.IsInitialized();
  end
  else
  begin
    UseDynamycKeysCheckBox.Enabled := False;
  end;
  
  EncryptWithDynamicKey := ((UseDynamycKeysCheckBox.Enabled and
    UseDynamycKeysCheckBox.Checked) or Enabled);
  
  AddSignCheckBox.Enabled := Enabled;
  RecipientsCertsFromFileCheckBox.Enabled := EncryptWithDynamicKey;
  AppendCertCheckBox.Enabled := (Enabled and AddSignCheckBox.Checked and
    UseDynamycKeysCheckBox.Checked);
  
  MultiEnvelopCheckBox.Enabled := EncryptWithDynamicKey;
  EncryptDataButton.Enabled := EncryptWithDynamicKey;
  DecryptDataButton.Enabled := Enabled;
  EncryptedDataRichEdit.Enabled := EncryptWithDynamicKey;
  EncryptDataEdit.Enabled := EncryptWithDynamicKey;
  EncryptFileButton.Enabled := EncryptWithDynamicKey;
  DecryptFileButton.Enabled := Enabled;
  EncryptFileEdit.Enabled := EncryptWithDynamicKey;
  ChooseEncryptFileButton.Enabled := EncryptWithDynamicKey;
  EncryptedFileEdit.Enabled := EncryptWithDynamicKey;
  ChooseEncryptedFileButton.Enabled := Enabled;
  FullDataTestButton.Enabled := Enabled;
  FullFileTestButton.Enabled := Enabled;
  DecryptedDataEdit.Enabled := Enabled;
  DecryptedFileEdit.Enabled := Enabled;
  ChooseDecryptedFileButton.Enabled := Enabled;
end;

{ ------------------------------------------------------------------------------ }

procedure TEnvelopeFunctionsFrame.Initialize(CPInterface: PEUSignCP;
  UseOwnUI: Boolean);
begin
  self.CPInterface := CPInterface;
  self.UseOwnUI := UseOwnUI;
  ChangeControlsState(False);
end;

{ ------------------------------------------------------------------------------ }

procedure TEnvelopeFunctionsFrame.Deinitialize();
begin
  ClearAllData();
  ChangeControlsState(False);
  self.CPInterface := nil;
  self.UseOwnUI := false;
end;

{ ------------------------------------------------------------------------------ }

procedure TEnvelopeFunctionsFrame.WillShow();
var
  Enabled: LongBool;

begin
  Enabled := ((CPInterface <> nil) and
    CPInterface.IsInitialized and
    CPInterface.IsPrivateKeyReaded());

  ChangeControlsState(Enabled);
end;

{ ============================================================================== }

procedure TEnvelopeFunctionsFrame.ClearAllData();
begin
  AddSignCheckBox.Checked := False;
  MultiEnvelopCheckBox.Checked := False;
  AppendCertCheckBox.Checked := False;
  RecipientsCertsFromFileCheckBox.Checked := False;
  
  if (CPInterface <> nil) then
  begin
    if (not CPInterface.IsInitialized) then
      UseDynamycKeysCheckBox.Checked := False;
  end
  else
  begin
    UseDynamycKeysCheckBox.Checked := False;
  end;
  
  EncryptFileEdit.Text := '';
  EncryptedFileEdit.Text := '';
  DecryptedFileEdit.Text := '';

  EncryptDataEdit.Text := '';
  EncryptedDataRichEdit.Text := '';
  DecryptedDataEdit.Text := '';
end;

{ ============================================================================== }

procedure TEnvelopeFunctionsFrame.AddSignCheckBoxClick(Sender: TObject);
begin
  AppendCertCheckBox.Enabled := (AddSignCheckBox.Checked and
    UseDynamycKeysCheckBox.Checked);
end;

{ ------------------------------------------------------------------------------ }

procedure TEnvelopeFunctionsFrame.UseDynamycKeysCheckBoxClick(Sender: TObject);
begin
  WillShow();  
end;

{ ============================================================================== }

function TEnvelopeFunctionsFrame.ChooseCertificatesInfoForEncryption(
  OnlyOne: Boolean; CertsInfo: PEUCertificatesUniqueInfo): Cardinal;
var
  Info: PEUCertInfoEx;
  ReceiversCertificates: PEUCertificates;
  Index: Integer;
  Error: Cardinal;
  
begin
  if UseOwnUI then
  begin
    if OnlyOne then
    begin
      if (not EUShowCertificates(WindowHandle, '', CPInterface,
        'Сертифікати користувачів-отримувачів', CertTypeEndUser,
        @Info, EU_CERT_KEY_TYPE_DSTU4145, EU_KEY_USAGE_KEY_AGREEMENT)) then
      begin
        ChooseCertificatesInfoForEncryption := EU_ERROR_CANCELED_BY_GUI;
        Exit;
      end;

      SetLength(CertsInfo.Issuers, 1);
      SetLength(CertsInfo.Serials, 1);
      CertsInfo.Issuers[0] := Info.Issuer;
      CertsInfo.Serials[0] := Info.Serial;

      CPInterface.FreeCertificateInfoEx(Info);
    end
    else
    begin
      if (not EUSelectCertificates(WindowHandle, '', CPInterface,
          'Сертифікати користувачів-отримувачів', 
          CertTypeEndUser, CertsInfo, 
          EU_CERT_KEY_TYPE_DSTU4145, EU_KEY_USAGE_KEY_AGREEMENT)) then
      begin
        ChooseCertificatesInfoForEncryption := EU_ERROR_CANCELED_BY_GUI;
        Exit;
      end;
    end;
  end
  else
  begin
    Error := CPInterface.GetReceiversCertificates(@ReceiversCertificates);
    if (Error <> EU_ERROR_NONE) then
    begin
      ChooseCertificatesInfoForEncryption := Error;
      Exit;
    end;

    if (ReceiversCertificates.Count < 1) then
    begin
      CPInterface.FreeReceiversCertificates(ReceiversCertificates);
      ChooseCertificatesInfoForEncryption := EU_ERROR_CANCELED_BY_GUI;
      Exit;
    end;
    
    if OnlyOne then
    begin
      Info := ReceiversCertificates.Certificates[0];
      SetLength(CertsInfo.Issuers, 1);
      SetLength(CertsInfo.Serials, 1);
      CertsInfo.Issuers[0] := Info.Issuer;
      CertsInfo.Serials[0] := Info.Serial;
    end
    else
    begin
      SetLength(CertsInfo.Issuers, ReceiversCertificates.Count);
      SetLength(CertsInfo.Serials, ReceiversCertificates.Count);
      for Index := 0 to High(ReceiversCertificates.Certificates) do
      begin
        Info := ReceiversCertificates.Certificates[Index];
        CertsInfo.Issuers[Index] := Info.Issuer;
        CertsInfo.Serials[Index] := Info.Serial;
      end;
    end;
    
    CPInterface.FreeReceiversCertificates(ReceiversCertificates);
  end;

  ChooseCertificatesInfoForEncryption := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

function TEnvelopeFunctionsFrame.ChooseCertificatesFromFile(OnlyOne: Boolean;
  Certificates: PEUBinaryItems): Cardinal;
var
  FileName: AnsiString;
  FileStream: TFileStream;
  CertificatesData: array of PByte;
  CertificatesDataLength: array of Cardinal;
  CertificatesCount: Cardinal;
  CertData: PByte;
  CertDataSize: Int64;
  MBResult: Integer;

begin
  SetLength(CertificatesData, 0);
  SetLength(CertificatesDataLength, 0);
  CertificatesCount := 0;

  while True do
  begin
    TargetFileOpenDialog.Title := 'Оберіть файл з сертифікатом';
    TargetFileOpenDialog.Filter := 'Файли з сертифікатами (*.cer)|*.cer';
    if (not TargetFileOpenDialog.Execute()) then
    begin
      ChooseCertificatesFromFile := EU_ERROR_CANCELED_BY_GUI;
      Exit;
    end;

    FileName := AnsiString(TargetFileOpenDialog.FileName);
    if (FileName = '') then
    begin
      ChooseCertificatesFromFile := EU_ERROR_CANCELED_BY_GUI;
      Exit;
    end;

    FileStream := nil;

    try
      FileStream := TFileStream.Create(FileName, fmOpenRead);
      FileStream.Seek(0, soBeginning);

      CertDataSize := FileStream.Size;
      CertData := GetMemory(CertDataSize);
      FileStream.Read(CertData^, CertDataSize);

      CertificatesCount := CertificatesCount + 1;
      SetLength(CertificatesData, CertificatesCount);
      SetLength(CertificatesDataLength, CertificatesCount);
      CertificatesData[High(CertificatesData)] := CertData;
      CertificatesDataLength[High(CertificatesDataLength)] := CertDataSize;

      FileStream.Destroy;
    Except
      if (FileStream <> nil) then
        FileStream.Destroy;

      for CertData in CertificatesData do
        FreeMemory(CertData);
      ChooseCertificatesFromFile := EU_ERROR_UNKNOWN;
      Exit;
    end;

    if OnlyOne then
      Break;

    MBResult := MessageBoxA(Handle, 'Обрати наступний сетрифікат одержувача?',
      'Повідомлення оператору', MB_YESNO or MB_ICONQUESTION);
    if (MBResult = IDNO) then
      Break;
  end;

  if (not (CreateBinaryItems(CertificatesCount, CertificatesData,
    CertificatesDataLength, Certificates))) then
  begin
    ChooseCertificatesFromFile := EU_ERROR_MEMORY_ALLOCATION;
    for CertData in CertificatesData do
      FreeMemory(CertData);
    Exit;
  end;

  for CertData in CertificatesData do
    FreeMemory(CertData);

  ChooseCertificatesFromFile := EU_ERROR_NONE;
end;

{ ============================================================================== }

function TEnvelopeFunctionsFrame.EncryptData(
  CertsInfo: PEUCertificatesUniqueInfo; Data: PByte; DataLength: Cardinal;
  EnvelopedString: PPAnsiChar): Cardinal;
var
  UseSign: LongBool;
  Issuers: PAnsiChar;
  Serials: PAnsiChar;
  Error: Cardinal;

begin
  UseSign := (AddSignCheckBox.Checked and AddSignCheckBox.Enabled);

  if MultiEnvelopCheckBox.Checked then
  begin
    Issuers := nil;
    Serials := nil;

    Error := EU_ERROR_MEMORY_ALLOCATION;

    if (EUStringArrayToPAnsiChar(CertsInfo.Issuers, @Issuers)
        and EUStringArrayToPAnsiChar(CertsInfo.Serials, @Serials)) then
    begin
      Error := CPInterface.EnvelopDataEx(Issuers, Serials, UseSign,
        Data, DataLength, @EnvelopedString, nil, nil);
    end;

    if (Issuers <> nil) then
      FreeMem(Issuers);
    if (Serials <> nil) then
      FreeMem(Serials);

    if (Error <> EU_ERROR_NONE) then
    begin
      EncryptData := Error;
      Exit;
    end;
  end
  else
  begin
    Error := CPInterface.EnvelopData(PAnsiChar(CertsInfo.Issuers[0]),
      PAnsiChar(CertsInfo.Serials[0]), UseSign, Data,
      DataLength, @EnvelopedString, nil, nil);
    if (Error <> EU_ERROR_NONE) then
    begin
      EncryptData := Error;
      Exit;
    end;
  end;

  EncryptData := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

function TEnvelopeFunctionsFrame.DynamicEncryptData(
  CertsInfo: PEUCertificatesUniqueInfo; Data: PByte; DataLength: Cardinal;
  EnvelopedString: PPAnsiChar): Cardinal;
var
  UseSign: LongBool;
  AppendCert: LongBool;
  Issuers: PAnsiChar;
  Serials: PAnsiChar;
  Error: Cardinal;

begin
  Issuers := nil;
  Serials := nil;

  if (not EUStringArrayToPAnsiChar(CertsInfo.Issuers, @Issuers)) then
  begin
    DynamicEncryptData := EU_ERROR_MEMORY_ALLOCATION;
    Exit;
  end;

  if (not EUStringArrayToPAnsiChar(CertsInfo.Serials, @Serials)) then
  begin
    FreeMem(Issuers);
    DynamicEncryptData := EU_ERROR_MEMORY_ALLOCATION;
    Exit;
  end;

  UseSign := (AddSignCheckBox.Checked and AddSignCheckBox.Enabled);
  AppendCert := (AppendCertCheckBox.Checked and AppendCertCheckBox.Enabled);

  Error := CPInterface.EnvelopDataExWithDynamicKey(Issuers, Serials, UseSign,
    AppendCert, Data, DataLength, EnvelopedString, nil, nil); 
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMem(Issuers);
    FreeMem(Serials);
    DynamicEncryptData := Error;
    Exit;
  end;
  
  FreeMem(Issuers);
  FreeMem(Serials); 

  DynamicEncryptData := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

function TEnvelopeFunctionsFrame.EncryptDataToRecipients(Data: PByte;
  DataLength: Cardinal; EnvelopedString: PPAnsiChar): Cardinal;
var
  UseSign: LongBool;
  AppendCert: LongBool;
  RecipientsCerts: TEUBinaryItems;
  Error: Cardinal;

begin
  UseSign := (AddSignCheckBox.Checked and AddSignCheckBox.Enabled);
  AppendCert := (AppendCertCheckBox.Checked and AppendCertCheckBox.Enabled);

  Error := ChooseCertificatesFromFile((not MultiEnvelopCheckBox.Checked),
    @RecipientsCerts);
  if (Error <> EU_ERROR_NONE) then
  begin
    EncryptDataToRecipients := Error;
    Exit;
  end;

  if (RecipientsCerts.Count < 1) then
  begin
    EncryptDataToRecipients := EU_ERROR_CANCELED_BY_GUI;
    Exit;
  end;

  if UseDynamycKeysCheckBox.Checked then
  begin
    Error := CPInterface.EnvelopDataToRecipientsWithDynamicKey(
      RecipientsCerts.Count, RecipientsCerts.Items,
      RecipientsCerts.ItemsSizes,
      UseSign, AppendCert, Data, DataLength, EnvelopedString, nil, nil);
  end
  else
  begin
    Error := CPInterface.EnvelopDataToRecipients(RecipientsCerts.Count,
      @RecipientsCerts.Items, @RecipientsCerts.ItemsSizes,
      UseSign, Data, DataLength, EnvelopedString, nil, nil);
  end;

  if (Error <> EU_ERROR_NONE) then
  begin
    FreeBinaryItems(@RecipientsCerts);
    EncryptDataToRecipients := Error;
    Exit;
  end;

  FreeBinaryItems(@RecipientsCerts);

  EncryptDataToRecipients := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

procedure TEnvelopeFunctionsFrame.EncryptDataButtonClick(Sender: TObject);
var
  DataString: WideString;
  DataStringLength: Cardinal;
  EnvelopedString: PAnsiChar;
  CertsInfo: TEUCertificatesUniqueInfo;
  Error: Cardinal;

begin
  if (not CPInterface.IsPrivateKeyReaded() and 
    (not UseDynamycKeysCheckBox.Checked)) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  DataString := WideString(EncryptDataEdit.Text);
  if (Length(DataString) > 0) then
  begin
    DataStringLength := (Length(DataString) + 1) * 2;
  end
  else
    DataStringLength := 0;
  EncryptedDataRichEdit.Text := '';
  DecryptedDataEdit.Text := '';

  if (RecipientsCertsFromFileCheckBox.Checked
    and RecipientsCertsFromFileCheckBox.Enabled) then
  begin
    Error := EncryptDataToRecipients(PByte(DataString),
      DataStringLength, @EnvelopedString);
  end
  else
  begin
    Error := ChooseCertificatesInfoForEncryption(not MultiEnvelopCheckBox.Checked,
      @CertsInfo);
    if (Error <> EU_ERROR_NONE) then
    begin
      if (Error <> EU_ERROR_CANCELED_BY_GUI) then
        EUShowError(Handle, Error);
      Exit;
    end;

    if UseDynamycKeysCheckBox.Checked then
    begin
      Error := DynamicEncryptData(@CertsInfo, PByte(DataString),
        DataStringLength, @EnvelopedString);
    end
    else
    begin
      Error := DynamicEncryptData(@CertsInfo, PByte(DataString),
        DataStringLength, @EnvelopedString);
    end;
  end;

  if (Error <> EU_ERROR_NONE) then
  begin
    if (Error <> EU_ERROR_CANCELED_BY_GUI) then
      EUShowError(Handle, Error);
    Exit;
  end;

  EncryptedDataRichEdit.Text := string(EnvelopedString);
  CPInterface.FreeMemory(PByte(EnvelopedString));
end;

{ ------------------------------------------------------------------------------ }

procedure TEnvelopeFunctionsFrame.DecryptDataButtonClick(Sender: TObject);
var
  Error: Cardinal;
  EnvelopInfo: TEUEnvelopInfo;
  Data: PByte;
  DataLength: Cardinal;
  AnsiSignStringing: AnsiString;

begin
  if (not CPInterface.IsPrivateKeyReaded()) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  DataLength := 0;
  Data := nil;
  AnsiSignStringing := AnsiString(EncryptedDataRichEdit.Text);
  DecryptedDataEdit.Text := '';

  Error := CPInterface.DevelopData(PAnsiChar(AnsiSignStringing), nil, 0,
    @Data, @DataLength, @EnvelopInfo);

  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  if (EnvelopInfo.Filled) then
  begin
    if UseOwnUI then
    begin
      EUSignCPOwnUI.EUShowSignInfo(WindowHandle, '', @EnvelopInfo,
        EnvelopInfo.bTime, True, True);
    end
    else
      CPInterface.ShowSenderInfo(@EnvelopInfo);
  end;

  if (DataLength > 0) then
    DecryptedDataEdit.Text := String(PWideChar(Data));

  CPInterface.FreeSenderInfo(@EnvelopInfo);
  CPInterface.FreeMemory(Data);
end;

{ ============================================================================== }

procedure TEnvelopeFunctionsFrame.ChooseEncryptFileButtonClick(Sender: TObject);
begin
  TargetFileOpenDialog.Title := 'Оберіть файл для зашифрування';
  TargetFileOpenDialog.FileName := '';
  TargetFileOpenDialog.Filter := '';
  if (not TargetFileOpenDialog.Execute(Handle)) then
    Exit;

   EncryptFileEdit.Text := TargetFileOpenDialog.FileName;
end;

{ ------------------------------------------------------------------------------ }

function TEnvelopeFunctionsFrame.EncryptFile(
  CertsInfo: PEUCertificatesUniqueInfo; TargetFile,
  EncryptedFileName: PAnsiChar) : Cardinal;
var
  UseSign: LongBool;
  Issuers: PAnsiChar;
  Serials: PAnsiChar;
  Error: Cardinal;

begin
  UseSign := (AddSignCheckBox.Checked and AddSignCheckBox.Enabled);

  if MultiEnvelopCheckBox.Checked then
  begin
    Issuers := nil;
    Serials := nil;

    Error := EU_ERROR_MEMORY_ALLOCATION;
    if (EUStringArrayToPAnsiChar(CertsInfo.Issuers, @Issuers)
        and EUStringArrayToPAnsiChar(CertsInfo.Serials, @Serials)) then
    begin
      Error := CPInterface.EnvelopFileEx(Issuers, Serials, UseSign,
        PAnsiChar(TargetFile), PAnsiChar(EncryptedFileName));
    end;

    if (Issuers <> nil) then
      FreeMem(Issuers);
    if (Serials <> nil) then
      FreeMem(Serials);
    end
  else
  begin
    Error := CPInterface.EnvelopFile(PAnsiChar(CertsInfo.Issuers[0]),
      PAnsiChar(CertsInfo.Serials[0]), UseSign,
      PAnsiChar(TargetFile), PAnsiChar(EncryptedFileName));
  end;

  EncryptFile := Error;
end;

{ ------------------------------------------------------------------------------ }

function TEnvelopeFunctionsFrame.DynamicEncryptFile(
  CertsInfo: PEUCertificatesUniqueInfo; TargetFile,
  EncryptedFileName: PAnsiChar): Cardinal;
var
  UseSign: LongBool;
  AppendCert: LongBool;
  Issuers: PAnsiChar;
  Serials: PAnsiChar;
  Error: Cardinal;

begin
  Issuers := nil;
  Serials := nil;
   
  if (not EUStringArrayToPAnsiChar(CertsInfo.Issuers, @Issuers)) then
  begin
    DynamicEncryptFile := EU_ERROR_MEMORY_ALLOCATION;
    Exit;
  end;

  if (not EUStringArrayToPAnsiChar(CertsInfo.Serials, @Serials)) then
  begin
    FreeMem(Issuers);
    DynamicEncryptFile := EU_ERROR_MEMORY_ALLOCATION;
    Exit;
  end;

  UseSign := (AddSignCheckBox.Checked and AddSignCheckBox.Enabled);
  AppendCert := (AppendCertCheckBox.Checked and AppendCertCheckBox.Enabled);
  
  Error := CPInterface.EnvelopFileExWithDynamicKey(Issuers, Serials, UseSign,
    AppendCert, TargetFile, EncryptedFileName);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMem(Issuers);      
    FreeMem(Serials);
    DynamicEncryptFile := Error;
    Exit;
  end;
  
  FreeMem(Issuers);      
  FreeMem(Serials); 

  DynamicEncryptFile := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

function TEnvelopeFunctionsFrame.EncryptFileToRecipients(TargetFile,
  EncryptedFileName: PAnsiChar) : Cardinal;
var
  UseSign: LongBool;
  AppendCert: LongBool;
  RecipientsCerts: TEUBinaryItems;
  Error: Cardinal;

begin
  Error := ChooseCertificatesFromFile((not MultiEnvelopCheckBox.Checked),
    @RecipientsCerts);
  if (Error <> EU_ERROR_NONE) then
  begin
    EncryptFileToRecipients := Error;
    Exit;
  end;

  if (RecipientsCerts.Count < 1) then
  begin
    EncryptFileToRecipients := EU_ERROR_CANCELED_BY_GUI;
    Exit;
  end;

  UseSign := (AddSignCheckBox.Checked and AddSignCheckBox.Enabled);
  AppendCert := (AppendCertCheckBox.Checked and AppendCertCheckBox.Enabled);

  if UseDynamycKeysCheckBox.Checked then
  begin
    Error := CPInterface.EnvelopFileToRecipientsWithDynamicKey(
      RecipientsCerts.Count, RecipientsCerts.Items,
      @RecipientsCerts.ItemsSizes,
      UseSign, AppendCert, TargetFile, EncryptedFileName);
  end
  else
  begin
    Error := CPInterface.EnvelopFileToRecipients(RecipientsCerts.Count,
      @RecipientsCerts.Items, @RecipientsCerts.ItemsSizes,
      UseSign, TargetFile, EncryptedFileName);
  end;

  if (Error <> EU_ERROR_NONE) then
  begin
    FreeBinaryItems(@RecipientsCerts);
    EncryptFileToRecipients := Error;
    Exit;
  end;

  FreeBinaryItems(@RecipientsCerts);

  EncryptFileToRecipients := EU_ERROR_NONE;
end;

{ ------------------------------------------------------------------------------ }

procedure TEnvelopeFunctionsFrame.EncryptFileButtonClick(Sender: TObject);
var
  TargetFile: AnsiString;
  EncryptedFileName: AnsiString;
  CertsInfo: TEUCertificatesUniqueInfo;
  Error: Cardinal;
  
begin
  if ((not CPInterface.IsPrivateKeyReaded()) and
    (not UseDynamycKeysCheckBox.Checked)) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if (Length(EncryptFileEdit.Text) = 0) then
  begin
    MessageBoxA(Handle, 'Файл для зашифрування не обрано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  TargetFile := AnsiString(EncryptFileEdit.Text);
  if (EncryptedFileEdit.Text <> '') then
  begin
    EncryptedFileName := AnsiString(EncryptedFileEdit.Text);
  end
  else
    EncryptedFileName := TargetFile + '.p7e';

  DecryptedFileEdit.Text := '';

  if (RecipientsCertsFromFileCheckBox.Checked
    and RecipientsCertsFromFileCheckBox.Enabled) then
  begin
    Error := EncryptFileToRecipients(PAnsiChar(TargetFile),
      PAnsiChar(EncryptedFileName))
  end
  else
  begin
    Error := ChooseCertificatesInfoForEncryption(
      not MultiEnvelopCheckBox.Checked, @CertsInfo);
    if (Error <> EU_ERROR_NONE) then
    begin
      if (Error <> EU_ERROR_CANCELED_BY_GUI) then
        EUShowError(Handle, Error);
      Exit;
    end;

    if UseDynamycKeysCheckBox.Checked then
    begin
      Error := DynamicEncryptFile(@CertsInfo,
        PAnsiChar(TargetFile), PAnsiChar(EncryptedFileName));
    end
    else
    begin
      Error := EncryptFile(@CertsInfo,
        PAnsiChar(TargetFile), PAnsiChar(EncryptedFileName));
    end;
  end;

  if (Error <> EU_ERROR_NONE) then
  begin
    if (Error <> EU_ERROR_CANCELED_BY_GUI) then
      EUShowError(Handle, Error);
    Exit;
  end;

  EncryptedFileEdit.Text := EncryptedFileName;
  MessageBox(Handle, 'Файл успішно зашифрованно',
      'Повідомлення оператору', MB_ICONINFORMATION);
end;

{ ------------------------------------------------------------------------------ }

procedure TEnvelopeFunctionsFrame.ChooseEncryptedFileButtonClick(Sender: TObject);
begin
  TargetFileOpenDialog.Title := 'Оберіть зашифрований файл';
  TargetFileOpenDialog.FileName := '';
  TargetFileOpenDialog.Filter := '';
  if (not TargetFileOpenDialog.Execute(Handle)) then
    Exit;

  EncryptedFileEdit.Text := TargetFileOpenDialog.FileName;
end;

{ ------------------------------------------------------------------------------ }

procedure TEnvelopeFunctionsFrame.ChooseDecryptedFileButtonClick(
  Sender: TObject);
begin
  TargetFileOpenDialog.Title := 'Оберіть файл';
  TargetFileOpenDialog.FileName := '';
  TargetFileOpenDialog.Filter := '';
  if (not TargetFileOpenDialog.Execute(Handle)) then
    Exit;

   DecryptedFileEdit.Text := TargetFileOpenDialog.FileName;
end;

{ ------------------------------------------------------------------------------ }

procedure TEnvelopeFunctionsFrame.DecryptFileButtonClick(Sender: TObject);
var
  Error: Cardinal;
  EnvelopInfo: TEUEnvelopInfo;
  TargetFile: AnsiString;
  DecryptedFile: AnsiString;

begin
  if (not CPInterface.IsPrivateKeyReaded()) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if (Length(EncryptedFileEdit.Text) = 0) then
  begin
    MessageBoxA(Handle, 'Файл для розшифрування (*.p7e) не обрано',
      'Повідомлення оператору',
      MB_ICONERROR);
    Exit;
  end;

  TargetFile := AnsiString(EncryptedFileEdit.Text);

  if (DecryptedFileEdit.Text <> '') then
  begin
    DecryptedFile := AnsiString(DecryptedFileEdit.Text);
  end
  else
    DecryptedFile := LeftStr(TargetFile, Length(TargetFile) - 4);

  Error := CPInterface.DevelopFile(PAnsiChar(TargetFile), PAnsiChar(DecryptedFile),
    @EnvelopInfo);

  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  if(EnvelopInfo.Filled) then
  begin
    if UseOwnUI then
    begin
        EUSignCPOwnUI.EUShowSignInfo(WindowHandle, '', @EnvelopInfo,
          EnvelopInfo.bTime, True, True);
    end
    else
      CPInterface.ShowSenderInfo(@EnvelopInfo);
  end;

  DecryptedFileEdit.Text := DecryptedFile;
  CPInterface.FreeSenderInfo(@EnvelopInfo);

  MessageBox(Handle, 'Файл успішно розшифрованно',
      'Повідомлення оператору', MB_ICONINFORMATION);
end;

{ ============================================================================== }

function TEnvelopeFunctionsFrame.GetOwnCertificateForEnvelop
  (Info: PPEUCertInfoEx): Cardinal;
var
  Index: Cardinal;

begin
	Index := 0;

  while True do
  begin
    Result := CPInterface.EnumOwnCertificates(Index, Info);

    if (Result <> EU_ERROR_NONE) then
      Exit;

    if (Info^.PublicKeyType = EU_CERT_KEY_TYPE_DSTU4145) and
        ((Info^.KeyUsageType and EU_KEY_USAGE_KEY_AGREEMENT)=
          EU_KEY_USAGE_KEY_AGREEMENT) then
    begin
      Exit;
    end;

    Index := Index + 1;
    CPInterface.FreeCertificateInfoEx(Info^);
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TEnvelopeFunctionsFrame.FullDataTestButtonClick(Sender: TObject);
var
  Data, EnvData, DevData: PByte;
  DataSize, EnvDataSize, DevDataSize, Error: Cardinal;
  EnvDataString: PAnsiChar;
  EnvelopInfo: TEUEnvelopInfo;
  Index: Integer;
  Info: PEUCertInfoEx;
  Issuer, Serial: AnsiString;

begin

  if (not CPInterface.IsPrivateKeyReaded()) then
  begin
    MessageBoxA(Handle, 'Особистий ключ не зчитано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  Error := GetOwnCertificateForEnvelop(@Info);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  Issuer := Info.Issuer;
  Serial := Info.Serial;

  CPInterface.FreeCertificateInfoEx(Info);

  DataSize := $00800000;
  Data := GetMemory(DataSize);
  if (Data = nil) then
  begin
    MessageBoxA(Handle, 'Недостатньо ресурсів для завершення операції',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  for Index := 0 to (DataSize - 1) do
{$if CompilerVersion > 19}
    Data[Index] := Index;
{$else}
    PByte(Cardinal(Data) + Index)^ := Index;
{$ifend}

  Error := CPInterface.EnvelopData(PAnsiChar(Issuer), PAnsiChar(Serial), False,
    Data, DataSize, nil, @EnvData, @EnvDataSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.DevelopData(nil, EnvData, EnvDataSize,
    @DevData, @DevDataSize, @EnvelopInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    CPInterface.FreeMemory(EnvData);
    EUShowError(Handle, Error);
    Exit;
  end;

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @EnvelopInfo, False, True, True);
  end
  else
    CPInterface.ShowSignInfo(@EnvelopInfo);

  if (DevDataSize <> DataSize) or
    (not CompareMem(Data, DevData, DataSize)) then
  begin
    FreeMemory(Data);
    CPInterface.FreeMemory(EnvData);
    CPInterface.FreeMemory(DevData);
    CPInterface.FreeSignInfo(@EnvelopInfo);
      MessageBoxA(Handle, 'Виникла помилка при тестуванні: дані не співпадають',
    'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  CPInterface.FreeMemory(EnvData);
  CPInterface.FreeMemory(DevData);
  CPInterface.FreeSignInfo(@EnvelopInfo);

  Error := CPInterface.EnvelopData(PAnsiChar(Issuer), PAnsiChar(Serial), True,
    Data, DataSize, nil, @EnvData, @EnvDataSize);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.DevelopData(nil, EnvData, EnvDataSize,
    @DevData, @DevDataSize, @EnvelopInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    CPInterface.FreeMemory(EnvData);
    EUShowError(Handle, Error);
    Exit;
  end;

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @EnvelopInfo, True, False, True);
  end
  else
    CPInterface.ShowSignInfo(@EnvelopInfo);

  if (DevDataSize <> DataSize) or
    (not CompareMem(Data, DevData, DataSize)) then
  begin
    FreeMemory(Data);
    CPInterface.FreeMemory(EnvData);
    CPInterface.FreeMemory(DevData);
    CPInterface.FreeSignInfo(@EnvelopInfo);

      MessageBoxA(Handle, 'Виникла помилка при тестуванні: дані не співпадають',
    'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  CPInterface.FreeMemory(EnvData);
  CPInterface.FreeMemory(DevData);
  CPInterface.FreeSignInfo(@EnvelopInfo);

  Error := CPInterface.EnvelopData(PAnsiChar(Issuer), PAnsiChar(Serial), False,
    Data, DataSize, @EnvDataString, nil, nil);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.DevelopData(EnvDataString, nil, 0,
    @DevData, @DevDataSize, @EnvelopInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    CPInterface.FreeMemory(PByte(EnvDataString));
    EUShowError(Handle, Error);
    Exit;
  end;

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @EnvelopInfo, False, True, True);
  end
  else
    CPInterface.ShowSignInfo(@EnvelopInfo);

  if (DevDataSize <> DataSize) or
    (not CompareMem(Data, DevData, DataSize)) then
  begin
    FreeMemory(Data);

    CPInterface.FreeMemory(PByte(EnvDataString));
    CPInterface.FreeMemory(DevData);
    CPInterface.FreeSignInfo(@EnvelopInfo);

    MessageBoxA(Handle, 'Виникла помилка при тестуванні: дані не співпадають',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  CPInterface.FreeMemory(PByte(EnvDataString));
  CPInterface.FreeMemory(DevData);
  CPInterface.FreeSignInfo(@EnvelopInfo);

  Error := CPInterface.EnvelopData(PAnsiChar(Issuer), PAnsiChar(Serial), True,
    Data, DataSize, @EnvDataString, nil, nil);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.DevelopData(EnvDataString, nil, 0,
    @DevData, @DevDataSize, @EnvelopInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    FreeMemory(Data);
    CPInterface.FreeMemory(PByte(EnvDataString));
    EUShowError(Handle, Error);
    Exit;
  end;

  if UseOwnUI then
  begin
    EUShowSignInfo(WindowHandle, '', @EnvelopInfo, True, True, True);
  end
  else
    CPInterface.ShowSignInfo(@EnvelopInfo);

  if (DevDataSize <> DataSize) or
    (not CompareMem(Data, DevData, DataSize)) then
  begin
    FreeMemory(Data);

    CPInterface.FreeMemory(PByte(EnvDataString));
    CPInterface.FreeMemory(DevData);
    CPInterface.FreeSignInfo(@EnvelopInfo);

    MessageBoxA(Handle, 'Виникла помилка при тестуванні: дані не співпадають',
    'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  CPInterface.FreeMemory(PByte(EnvDataString));
  CPInterface.FreeMemory(DevData);
  CPInterface.FreeSignInfo(@EnvelopInfo);

  MessageBoxA(Handle, 'Тестування виконано успішно',
    'Повідомлення оператору', MB_ICONINFORMATION);
end;

{ ------------------------------------------------------------------------------ }

procedure TEnvelopeFunctionsFrame.FullFileTestButtonClick(Sender: TObject);
var
  FileName, EnvFileName, DevFileName: AnsiString;
  Error: Cardinal;
  EnvelopInfo: TEUEnvelopInfo;
  Info: PEUCertInfoEx;
  Issuer, Serial: AnsiString;

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
    MessageBoxA(Handle, 'Файл для тестування шифрування файлів не обрано',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  EnvFileName := FileName + '.p7e';
  DevFileName := LeftStr(FileName, Length(FileName) - 8) + '.new' +
    RightStr(FileName, 4);

  Error := GetOwnCertificateForEnvelop(@Info);
  if (Error <> EU_ERROR_NONE) then
  begin
    if Error = EU_WARNING_END_OF_ENUM then
    begin
      MessageBoxA(Handle, 'Зашифрування даних на ключі користувача не можливо',
        'Повідомлення оператору', MB_ICONERROR);
    end
    else
      EUShowError(Handle, Error);
    Exit;
  end;

  Issuer := Info.Issuer;
  Serial := Info.Serial;

  CPInterface.FreeCertificateInfoEx(Info);

  Error := CPInterface.EnvelopFile(PAnsiChar(Issuer), PAnsiChar(Serial),  False,
    PAnsiChar(FileName), PAnsiChar(EnvFileName));
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.DevelopFile(PAnsiChar(EnvFileName),
    PAnsiChar(DevFileName), @EnvelopInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  if UseOwnUI then
  begin
      EUSignCPOwnUI.EUShowSignInfo(WindowHandle, '', @EnvelopInfo,
        EnvelopInfo.bTime, True, True);
  end
  else
    CPInterface.ShowSenderInfo(@EnvelopInfo);

  CPInterface.FreeSignInfo(@EnvelopInfo);

    Error := CPInterface.EnvelopFile(PAnsiChar(Issuer), PAnsiChar(Serial),  True,
    PAnsiChar(FileName), PAnsiChar(EnvFileName));
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  Error := CPInterface.DevelopFile(PAnsiChar(EnvFileName),
    PAnsiChar(DevFileName), @EnvelopInfo);
  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowError(Handle, Error);
    Exit;
  end;

  if UseOwnUI then
  begin
      EUSignCPOwnUI.EUShowSignInfo(WindowHandle, '', @EnvelopInfo,
        EnvelopInfo.bTime, True, True);
  end
  else
    CPInterface.ShowSenderInfo(@EnvelopInfo);

  CPInterface.FreeSignInfo(@EnvelopInfo);

  MessageBoxA(Handle, 'Тестування виконано успішно',
    'Повідомлення оператору', MB_ICONINFORMATION);
end;

{ ============================================================================== }

end.
