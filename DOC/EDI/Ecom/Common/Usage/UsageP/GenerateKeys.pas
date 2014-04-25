unit GenerateKeys;
{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  IniFiles, EUSignCP;

{ ------------------------------------------------------------------------------ }

type
  TGenerateKeysForm = class(TForm)
    CRSaveDialog: TSaveDialog;
    FinalPanel: TPanel;
    FinalTopLabel: TLabel;
    FinalHeaderImage: TImage;
    FinalNavigatorPanel: TPanel;
    FinalNavigatorBottomImage: TImage;
    FinalNavigatorNextButton: TButton;
    Page1InternationalPanel: TPanel;
    Page1InternationalTopLabel: TLabel;
    CAPTypeInternationalLabel: TLabel;
    InternationalKeysSLabel: TLabel;
    InternationalCAPFilesLabel: TLabel;
    Page1InternationalHeaderImage: TImage;
    Page1InternationalNavigatorPanel: TPanel;
    Page1InternationalNavigatorBottomImage: TImage;
    Page1InternationalNextButton: TButton;
    Page1InternationalCancelButton: TButton;
    Page1InternationalBackButton: TButton;
    CAPTypeInternationalComboBox: TComboBox;
    InternationalKeysSComboBox: TComboBox;
    InternationalCAPFilesComboBox: TComboBox;
    InternationalCAPFilesButton: TButton;
    Page1KeyTypePanel: TPanel;
    Page1KeyTypeTopLabel: TLabel;
    KeyTypeRadioGroup: TRadioGroup;
    Page1KeyTypeNavigatorPanel: TPanel;
    Page1KeyTypeNavigatorBottomImage: TImage;
    Page1KeyTypeNextButton: TButton;
    Page1KeyTypeCancelButton: TButton;
    Page3Panel: TPanel;
    Page3NavigatorPanel: TPanel;
    Page3NavigatorBottomImage: TImage;
    Page3NextButton: TButton;
    Page3CancelButton: TButton;
    Page3BackButton: TButton;
    Page3HeaderPanel: TPanel;
    Page3TopLabel: TLabel;
    DSCRPanel: TPanel;
    CRFileLabel: TLabel;
    CRFileEdit: TEdit;
    CRFileChangeButton: TButton;
    KEPCRPanel: TPanel;
    KEPCRFileLabel: TLabel;
    KEPCRFileEdit: TEdit;
    KEPCRFileChangeButton: TButton;
    Page3SplitPanel: TPanel;
    Page3HeaderImage: TImage;
    InternationalCRPanel: TPanel;
    InternationalCRFileLabel: TLabel;
    InternationalCRFileEdit: TEdit;
    InternationalCRFileChangeButton: TButton;
    Page1Panel: TPanel;
    CAPTypeLabel: TLabel;
    CAPFilesLabel: TLabel;
    Page1TopLabel: TLabel;
    DSKeysSLabel: TLabel;
    KEPKeysSLabel: TLabel;
    Page1HeaderImage: TImage;
    Page1NavigatorPanel: TPanel;
    Page1NavigatorBottomImage: TImage;
    Page1NextButton: TButton;
    Page1CancelButton: TButton;
    Page1BackButton: TButton;
    CAPTypeComboBox: TComboBox;
    CAPFilesComboBox: TComboBox;
    CAPFilesButton: TButton;
    DSKeysSComboBox: TComboBox;
    KEPKeysSComboBox: TComboBox;
    UseKEPCRCheckBox: TCheckBox;
    SavePKCheckBox: TCheckBox;
    PKPanel: TPanel;
    PKLabel: TLabel;
    PKEdit: TEdit;
    PKButton: TButton;
    PKPasswordEdit: TEdit;
    PKPasswordLabel: TLabel;
    procedure ShowPagePanel(PagePanel: TPanel);
    procedure FormShow(Sender: TObject);
    procedure SetComboboxPathes(ComboBox: TComboBox);
    function GeneratePrivateKey(): Boolean;
    procedure PreparePage1Panel();
    procedure PreparePage1InternationalPanel();
    procedure PreparePage3Panel();
    procedure Page1KeyTypeNextButtonClick(Sender: TObject);
    procedure Page1BackButtonClick(Sender: TObject);
    procedure Page1NextButtonClick(Sender:TObject);
    procedure Page1CancelButtonClick(Sender:TObject);
    procedure Page1InternationalBackButtonClick(Sender:TObject);
    procedure Page1InternationalNextButtonClick(Sender:TObject);
    procedure Page3BackButtonClick(Sender:TObject);
    procedure Page3NextButtonClick(Sender:TObject);
    procedure FinalNavigatorNextButtonClick(Sender:TObject);
    procedure CRFileChangeButtonClick(Sender:TObject);
    procedure KEPCRFileChangeButtonClick(Sender:TObject);
    procedure InternationalCRFileChangeButtonClick(Sender:TObject);
    procedure UseKEPCRCheckBoxClick(Sender:TObject);
    procedure CAPFilesButtonClick(Sender:TObject);
    procedure InternationalCAPFilesButtonClick(Sender:TObject);
    procedure PKButtonClick(Sender: TObject);
    procedure SavePKCheckBoxClick(Sender: TObject);

  private
    CPInterface: PEUSignCP;
    MakeUAKeys: Boolean;
	  MakeInternationalKeys: Boolean;
	  MakeKEPKey: Boolean;
    InternationalMode: Boolean;
    Request: TMemoryStream;
    RequestPath: Array [0 .. (EU_PATH_MAX_LENGTH-1)] of AnsiChar;
    KEPRequest: TMemoryStream;
    KEPRequestPath: Array [0 .. (EU_PATH_MAX_LENGTH-1)] of AnsiChar;
    InternationalRequest: TMemoryStream;
    InternationalRequestPath: Array [0 .. (EU_PATH_MAX_LENGTH-1)] of AnsiChar;

  public
    Constructor CreateParented(Parent: HWND); overload;
    Destructor  Destroy; override;
    procedure SetData(CPInterface: PEUSignCP; InternationalMode: Boolean);

  end;

type
  PEUKeyRequestInfo = ^TEUKeyRequestInfo;
  TEUKeyRequestInfo = record
    RequestP: PPByte;
    RequestLengthP: PCardinal;
    RequestPathP: PAnsiChar;
end;

{ ------------------------------------------------------------------------------ }

var
  GenerateKeysForm: TGenerateKeysForm;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ------------------------------------------------------------------------------ }

uses EUSignCPOwnUI;

{ ============================================================================== }

Constructor TGenerateKeysForm.CreateParented(Parent: HWND);
begin
  inherited;
  InternationalMode := False;

  ZeroMemory(@RequestPath, EU_PATH_MAX_LENGTH);
  ZeroMemory(@KEPRequestPath, EU_PATH_MAX_LENGTH);
  ZeroMemory(@InternationalRequestPath, EU_PATH_MAX_LENGTH);

  Request := TMemoryStream.Create;
  KEPRequest := TMemoryStream.Create;
  InternationalRequest := TMemoryStream.Create;

  MakeUAKeys := False;
  MakeInternationalKeys := False;
  MakeKEPKey := False;
end;

{ ------------------------------------------------------------------------------ }

destructor TGenerateKeysForm.Destroy;
begin
  Request.Destroy;
  KEPRequest.Destroy;
  InternationalRequest.Destroy;
  inherited;
 end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.SetData(CPInterface: PEUSignCP;
  InternationalMode: Boolean);
begin
  self.CPInterface := CPInterface;
  self.InternationalMode := InternationalMode;
end;

{ ============================================================================== }

procedure TGenerateKeysForm.ShowPagePanel(PagePanel: TPanel);
var
  PagePanels: Array [0..4] of TPanel;
  Index: Cardinal;

begin
  PagePanels[0] := Page1KeyTypePanel;
  PagePanels[1] := Page1InternationalPanel;
  PagePanels[2] := Page1Panel;
  PagePanels[3] := Page3Panel;
  PagePanels[4] := FinalPanel;

  for Index := 0 to Length(PagePanels) - 1 do
  begin
    if (PagePanel <> PagePanels[Index]) then
      PagePanels[Index].Visible := False;
  end;

  PagePanel.Visible := True;
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.FormShow(Sender: TObject);
begin
  if InternationalMode then
  begin
		ShowPagePanel(Page1KeyTypePanel);
  end
	else
  begin
    Page1BackButton.Visible := False;
		KeyTypeRadioGroup.ItemIndex := 0;
		Page1KeyTypeNextButtonClick(nil);
  end;
end;

{ ============================================================================== }

procedure TGenerateKeysForm.SavePKCheckBoxClick(Sender: TObject);
begin
 PKPanel.Visible := SavePKCheckBox.Checked;
end;

procedure TGenerateKeysForm.SetComboboxPathes(ComboBox: TComboBox);
var
  Drive : Array[0..2] of Char;
  DriveType: Cardinal;

  DriveBits: set of 0..25;
  I: Byte;

begin
  Drive := 'X:';
  ComboBox.Items.Clear();

  ComboBox.Items.Add(ExcludeTrailingPathDelimiter(
          ExtractFilePath(Application.ExeName)));

  Cardinal(DriveBits) := GetLogicalDrives;
  if (Cardinal(DriveBits) <> 0) then
  begin
    for I := 0 to 25 do
    begin
      if I in DriveBits then
      begin
        Drive[0] := Chr(Ord('A') + I);
        DriveType := GetDriveType(Drive);

        if ((DriveType <> DRIVE_REMOVABLE) and
          (DriveType <> DRIVE_CDROM)) then
                continue;
      end;
    end;
  end;
   ComboBox.ItemIndex := 0;
end;

{ ------------------------------------------------------------------------------ }

procedure SetRequestData(NeedData: Boolean; RequestPointer: PPByte;
  RequestLengthPointer: PCardinal; RequestPathPointer: PAnsiChar;
  Info: PEUKeyRequestInfo);
begin
  if NeedData then
  begin
    Info.RequestP := RequestPointer;
    Info.RequestLengthP := RequestLengthPointer;
    Info.RequestPathP := RequestPathPointer;
  end
  else
  begin
    Info.RequestP := nil;
    Info.RequestLengthP := nil;
    Info.RequestPathP := nil;
  end;
end;

function TGenerateKeysForm.GeneratePrivateKey(): Boolean;
var
  UAKeysType: Cardinal;
  InternationalKeysType: Cardinal;
  Error: Cardinal;
  isValid: Boolean;
  KeyMedia: TEUKeyMedia;
  KeyMediaPointer: PEUKeyMedia;
  PKData: PByte;
  PKDataLength: Cardinal;
  PKDataPointer: PPByte;
  PKDataLengthPointer: PCardinal;
  UARequestData: PByte;
  UARequestDataLength: Cardinal;
  UAKEPRequestData: PByte;
  UAKEPRequestDataLength: Cardinal;
  InternationalRequestData: PByte;
  InternationalRequestDataLength: Cardinal;
  UARequestInfo: TEUKeyRequestInfo;
  UAKEPRequestInfo: TEUKeyRequestInfo;
  InterRequestInfo:TEUKeyRequestInfo;
  PKMemoryStream: TMemoryStream;
  RequestInfo: PEUCRInfo;

begin
  GeneratePrivateKey := False;
  UAKeysType := EU_KEYS_TYPE_NONE;
	InternationalKeysType := EU_KEYS_TYPE_NONE;

	if MakeUAKeys then
	begin
		case (CAPTypeComboBox.ItemIndex) of
		  0: UAKeysType := EU_KEYS_TYPE_DSTU_AND_ECDH_WITH_GOSTS;

		  else
      begin
        MessageBox(Handle, 'Не обрано тип державних ' +
				  'криптографічних алгоритмів та протоколів',
				  'Повідомлення оператору',
				  MB_OK or MB_ICONERROR);
      Exit;
      end;
		end;
	end;

	if MakeInternationalKeys then
	begin
    case (CAPTypeInternationalComboBox.ItemIndex) of
		  0: InternationalKeysType := EU_KEYS_TYPE_RSA_WITH_SHA;
		  else
      begin
        MessageBox(Handle, 'Не обрано тип міжнародних ' +
          'криптографічних алгоритмів та протоколів',
          'Повідомлення оператору',
          MB_OK or MB_ICONERROR);
        Exit;
      end;
		end;
  end;

  PKDataPointer := nil;
  PKDataLengthPointer := nil;

  if SavePKCheckBox.Checked then
  begin
    StrCopy(KeyMedia.Password, PAnsiChar(AnsiString(PKPasswordEdit.Text)));
    PKDataPointer := @PKData;
    PKDataLengthPointer := @PKDataLength;
    KeyMediaPointer := @KeyMedia;
  end
  else
  begin
    if EUSignCPOwnUI.EUUseOwnUI then
    begin
      Error := EUSignCPOwnUI.EUGetPrivateKeyMedia(Handle,
        'Генерація особистого ключа', '', CPInterface, @KeyMedia);
      if Error <> EU_ERROR_NONE then
        Exit;
      KeyMediaPointer := @KeyMedia;
    end
    else
    begin
      KeyMediaPointer := nil;
    end;
  end;

  SetRequestData(MakeUAKeys, @UARequestData, @UARequestDataLength, RequestPath,
    @UARequestInfo);
  SetRequestData(UseKEPCRCheckBox.Checked, @UAKEPRequestData,
    @UAKEPRequestDataLength, KEPRequestPath, @UAKEPRequestInfo);
  SetRequestData(MakeInternationalKeys, @InternationalRequestData,
    @InternationalRequestDataLength, InternationalRequestPath, @InterRequestInfo);

  Error := CPInterface.GeneratePrivateKey(KeyMediaPointer,
    UAKeysType,
    DSKeysSComboBox.ItemIndex + 1,
    KEPKeysSComboBox.ItemIndex + 1,
    PAnsiChar(AnsiString(ExcludeTrailingPathDelimiter(CAPFilesComboBox.Text))),
    InternationalKeysType,
    InternationalKeysSComboBox.ItemIndex + 1,
    PAnsiChar(AnsiString(ExcludeTrailingPathDelimiter(InternationalCAPFilesComboBox.Text))),
    PKDataPointer, PKDataLengthPointer,
    nil, nil,
    UARequestInfo.RequestP, UARequestInfo.RequestLengthP, UARequestInfo.RequestPathP,
    UAKEPRequestInfo.RequestP, UAKEPRequestInfo.RequestLengthP,
    UAKEPRequestInfo.RequestPathP,
    InterRequestInfo.RequestP, InterRequestInfo.RequestLengthP,
    InterRequestInfo.RequestPathP);

  if (Error <> EU_ERROR_NONE) then
  begin
    EUShowErrorMessage(Handle,
        PAnsiChar(AnsiString('Виникла помилка при генерації особистого ключа:' +
          #13#10 + 'Опис помилки: ' + CPInterface.GetErrorDesc
        (Error))));
    Exit;
  end;

  isValid := True;
  if MakeUAKeys then
    isValid := EUDataToStream(UARequestData, UARequestDataLength, Request);
  if (MakeUAKeys and UseKEPCRCheckBox.Checked and isValid) then
      isValid := EUDataToStream(UAKEPRequestData, UAKEPRequestDataLength, KEPRequest);
  if (MakeInternationalKeys and isValid) then
    isValid := EUDataToStream(InternationalRequestData,
        InternationalRequestDataLength, InternationalRequest);

  if (not isValid) then
  begin
    EUSignCPOwnUI.EUShowErrorMessage(Handle,
      PAnsiChar('Виникла помилка при генерації особистого ключа: ' +
      'пошкоджені дані запиту на формування сертифіката'));
  end;

  if (SavePKCheckBox.Checked and isValid) then
  begin
    PKMemoryStream := TMemoryStream.Create;
    isValid := EUDataToStream(PKData,
        PKDataLength, PKMemoryStream);

    if isValid then
    begin
      isValid := EUWriteToFile(AnsiString(PKEdit.Text), PKMemoryStream);
    end;

    if (not isValid) then
    begin
      EUSignCPOwnUI.EUShowErrorMessage(Handle,
        PAnsiChar('Виникла помилка при генерації особистого ключа: ' +
        'не можливо зберегти файл з особистим ключем'));
    end;

    PKMemoryStream.Destroy;
  end;

  if (not isValid) then
  begin
    if MakeUAKeys then
      CPInterface.FreeMemory(UARequestData);
    if MakeInternationalKeys then
      CPInterface.FreeMemory(InternationalRequestData);
    if UseKEPCRCheckBox.Checked then
      CPInterface.FreeMemory(UAKEPRequestData);
    if SavePKCheckBox.Checked then
       CPInterface.FreeMemory(PKData);
    Exit;
  end;

  if MakeUAKeys then
  begin
    Error := CPInterface.GetCRInfo(UARequestData,
      UARequestDataLength, @RequestInfo);
    if (Error = EU_ERROR_NONE) then
    begin
      EUSignCPOwnUI.EUShowCRInfo(Handle, 'Запит на формування сертифіката ' +
        'з відкритим ключем ЕЦП', RequestInfo);
      CPInterface.FreeCRInfo(RequestInfo);
    end;

    if UseKEPCRCheckBox.Checked then
    begin
      Error := CPInterface.GetCRInfo(UAKEPRequestData,
      UAKEPRequestDataLength, @RequestInfo);
      if (Error = EU_ERROR_NONE) then
      begin
        EUSignCPOwnUI.EUShowCRInfo(Handle, 'Запит на формування сертифіката ' +
          'з відкритим ключем протоколу розподілу', RequestInfo);
        CPInterface.FreeCRInfo(RequestInfo);
      end;
    end;
  end;

	if MakeInternationalKeys then
	begin
		case InternationalKeysType of
		EU_KEYS_TYPE_RSA_WITH_SHA:
    begin
      Error := CPInterface.GetCRInfo(InternationalRequestData,
        InternationalRequestDataLength, @RequestInfo);
      if (Error = EU_ERROR_NONE) then
      begin
        EUSignCPOwnUI.EUShowCRInfo(Handle, 'Запит на формування сертифіката ' +
          'з відкритим ключем RSA', RequestInfo);
        CPInterface.FreeCRInfo(RequestInfo);
      end;
    end;
		end;
  end;

  PreparePage3Panel();
  ShowPagePanel(Page3Panel);

  GeneratePrivateKey := True;

  if SavePKCheckBox.Checked then
    CPInterface.FreeMemory(PKData);
  if MakeUAKeys then
    CPInterface.FreeMemory(UARequestData);
  if MakeInternationalKeys then
    CPInterface.FreeMemory(InternationalRequestData);
  if UseKEPCRCheckBox.Checked then
    CPInterface.FreeMemory(UAKEPRequestData);
end;

{ ============================================================================== }

procedure TGenerateKeysForm.PreparePage1Panel();
begin
  MakeKEPKey := TRUE;

	if (CAPTypeComboBox.ItemIndex < 0) then
		CAPTypeComboBox.ItemIndex := 0;

	if (DSKeysSComboBox.ItemIndex < 0) then
		DSKeysSComboBox.ItemIndex := 3;

	UseKEPCRCheckBox.Checked := False;
	UseKEPCRCheckBoxClick(nil);
	SetComboboxPathes(CAPFilesComboBox);
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.PreparePage1InternationalPanel();
begin
  if (CAPTypeInternationalComboBox.ItemIndex < 0) then
		CAPTypeInternationalComboBox.ItemIndex := 0;

	if (InternationalKeysSComboBox.ItemIndex < 0) then
		InternationalKeysSComboBox.ItemIndex := 1;

	SetComboboxPathes(InternationalCAPFilesComboBox);
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.PreparePage3Panel();
begin
	if MakeUAKeys then
	begin
		CRFileEdit.Text := string(RequestPath);

		if (MakeKEPKey and UseKEPCRCheckBox.Checked) then
			KEPCRFileEdit.Text := string(KEPRequestPath);
	end;

	if MakeInternationalKeys then
		InternationalCRFileEdit.Text := string(InternationalRequestPath);

	DSCRPanel.Visible := MakeUAKeys;
	KEPCRPanel.Visible := MakeUAKeys and MakeKEPKey and UseKEPCRCheckBox.Checked;
	InternationalCRPanel.Visible := MakeInternationalKeys;

	Page3SplitPanel.Top := 0;
	InternationalCRPanel.Top := 0;
	KEPCRPanel.Top := 0;
	DSCRPanel.Top := 0;
	Page3HeaderPanel.Top := 0;
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.Page1KeyTypeNextButtonClick(Sender:TObject);
begin
  MakeUAKeys := (KeyTypeRadioGroup.ItemIndex <> 1);
	MakeInternationalKeys := (KeyTypeRadioGroup.ItemIndex <> 0);

	if MakeUAKeys then
	begin
		PreparePage1Panel();
		ShowPagePanel(Page1Panel);
	end
	else
	begin
		PreparePage1InternationalPanel();
		ShowPagePanel(Page1InternationalPanel);
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.Page1BackButtonClick(Sender:TObject);
begin
  ShowPagePanel(Page1KeyTypePanel);
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.Page1NextButtonClick(Sender:TObject);
begin
  if (PKEdit.Text = '') then
  begin
    MessageBox(Handle, 'Не обрано файл для запису особистого ключа',
        'Повідомлення оператору',
        MB_OK or MB_ICONERROR);
    PKEdit.SetFocus();
    Exit;
  end;

	if MakeInternationalKeys then
	begin
		PreparePage1InternationalPanel();
		ShowPagePanel(Page1InternationalPanel);
	end
	else
		GeneratePrivateKey();
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.Page1CancelButtonClick(Sender:TObject);
begin
  if (MessageBox(Handle, 'Завершити роботу?',
        'Повідомлення оператору', MB_YESNO or MB_ICONQUESTION) <> IDYES) then
  begin
    Exit;
  end;

  ModalResult := mrCancel;
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.Page1InternationalBackButtonClick(Sender:TObject);
begin
  if(MakeUAKeys) then
  begin
		ShowPagePanel(Page1Panel);
  end
	else
		ShowPagePanel(Page1KeyTypePanel);
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.Page1InternationalNextButtonClick(Sender:TObject);
begin
  GeneratePrivateKey();
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.Page3BackButtonClick(Sender:TObject);
begin
  Request.Clear;
  KEPRequest.Clear;
  InternationalRequest.Clear;

  if(not MakeInternationalKeys) then
  begin
		ShowPagePanel(Page1Panel);
  end
	else
		ShowPagePanel(Page1InternationalPanel);
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.FinalNavigatorNextButtonClick(Sender:TObject);
begin
  ModalResult := mrOk;
end;

{ ============================================================================== }

procedure TGenerateKeysForm.CRFileChangeButtonClick(Sender:TObject);
begin
	CRSaveDialog.InitialDir := ExtractFilePath(CRFileEdit.Text);
	CRSaveDialog.FileName := ExtractFileName(CRFileEdit.Text);

	if CRSaveDialog.Execute() then
		CRFileEdit.Text := CRSaveDialog.FileName;
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.KEPCRFileChangeButtonClick(Sender:TObject);
begin
	CRSaveDialog.InitialDir := ExtractFilePath(KEPCRFileEdit.Text);
	CRSaveDialog.FileName := ExtractFileName(KEPCRFileEdit.Text);

	if CRSaveDialog.Execute() then
		KEPCRFileEdit.Text := CRSaveDialog.FileName;
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.InternationalCRFileChangeButtonClick(Sender:TObject);
begin
  CRSaveDialog.InitialDir := ExtractFilePath(InternationalCRFileEdit.Text);
	CRSaveDialog.FileName := ExtractFileName(InternationalCRFileEdit.Text);

  if CRSaveDialog.Execute() then
		InternationalCRFileEdit.Text := CRSaveDialog.FileName;
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.UseKEPCRCheckBoxClick(Sender:TObject);
begin
	if (MakeKEPKey and UseKEPCRCheckBox.Checked) then
	begin
		if (KEPKeysSComboBox.ItemIndex < 0) then
			KEPKeysSComboBox.ItemIndex := 3;
	end;

	KEPKeysSLabel.Visible := MakeKEPKey and UseKEPCRCheckBox.Checked;
	KEPKeysSComboBox.Visible := MakeKEPKey and UseKEPCRCheckBox.Checked;
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.CAPFilesButtonClick(Sender:TObject);
var
  Folder: AnsiString;
  PathEditText: AnsiString;

begin
  PathEditText := '';

  Folder := EUSignCPOwnUI.EUBrowseForFolder(
    'Каталог з файлами криптографічних параметрів', PathEditText, 0);

	if (Folder <> '') then
	begin
		CAPFilesComboBox.Text := ExcludeTrailingPathDelimiter(Folder);
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.InternationalCAPFilesButtonClick(Sender:TObject);
var
  Folder: AnsiString;
  PathEditText: AnsiString;

begin
  PathEditText := '';

  Folder := EUSignCPOwnUI.EUBrowseForFolder(
    'Каталог з файлами криптографічних параметрів', PathEditText, 0);

	if (Folder <> '') then
		InternationalCAPFilesComboBox.Text := ExcludeTrailingPathDelimiter(Folder);
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.Page3NextButtonClick(Sender:TObject);
begin
  if MakeUAKeys then
  begin
    if (CRFileEdit.Text = '') then
    begin
      MessageBox(Handle,
              'Не вказане ім''я файлу для запису ' +
              'запиту на формування сертифіката ' +
              'з відкитим ключем ЕЦП',
              'Повідомлення оператору',
              MB_OK or MB_ICONWARNING);
      CRFileEdit.SetFocus();
      Exit;
    end;

    if (MakeKEPKey and UseKEPCRCheckBox.Checked) then
    begin
      if (KEPCRFileEdit.Text = '') then
      begin
        MessageBox(Handle,
                'Не вказане ім''я файлу для запису ' +
                'запиту на формування сертифіката ' +
                'з відкитим ключем протоколу ' +
                'розподілу',
                'Повідомлення оператору',
                MB_OK or MB_ICONWARNING);
        KEPCRFileEdit.SetFocus();
        Exit;
      end;
    end;

    if (not EUWriteToFile(CRFileEdit.Text, Request)) then
    begin
      MessageBox(Handle,
              'Виникла помилка при записі запиту на ' +
              'формування сертифіката ' +
              'з відкитим ключем ЕЦП у файл',
              'Повідомлення оператору',
              MB_OK or MB_ICONERROR);
      Exit;
    end;

    if (MakeKEPKey and UseKEPCRCheckBox.Checked) then
    begin
      if (not EUWriteToFile(KEPCRFileEdit.Text, KEPRequest)) then
      begin
        MessageBox(Handle,
                'Виникла помилка при записі ' +
                'запиту на формування сертифіката ' +
                'з відкитим ключем протоколу ' +
                'розподілу у файл',
                'Повідомлення оператору',
                MB_OK or MB_ICONERROR);
        Exit;
      end;
    end;
  end;

  if (MakeInternationalKeys) then
  begin
    if (InternationalCRFileEdit.Text = '') then
    begin
      MessageBox(Handle,
        'Не вказане ім''я файлу для запису ' +
        'запиту на формування сертифіката ' +
        'з відкритим ключем RSA',
        'Повідомлення оператору',
        MB_OK or MB_ICONWARNING);

      InternationalCRFileEdit.SetFocus();

      Exit;
    end;

    if (not EUWriteToFile(AnsiString(InternationalCRFileEdit.Text),
      InternationalRequest)) then
    begin
      MessageBox(Handle,
        'Виникла помилка при записі запиту на ' +
        'формування сертифіката ' +
        'з відкритим ключем RSA ' +
        'у файл',
        'Повідомлення оператору',
        MB_OK or MB_ICONERROR);
      Exit;
    end;
  end;

  ShowPagePanel(FinalPanel);
end;

{ ------------------------------------------------------------------------------ }

procedure TGenerateKeysForm.PKButtonClick(Sender: TObject);
begin
	CRSaveDialog.InitialDir := ExtractFilePath(PKEdit.Text);
	CRSaveDialog.FileName := ExtractFileName(PKEdit.Text);

	if CRSaveDialog.Execute() then
		PKEdit.Text := CRSaveDialog.FileName;
end;

{ ============================================================================== }

end.
