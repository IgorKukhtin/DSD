unit KeyMedia;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, EUSignCP, ComCtrls, ImgList, ImageLink,
  Buttons;

{ ------------------------------------------------------------------------------ }

type
  TKeyMediaFrame = class(TFrame)
    SplitterImage1: TImage;
    InfoLabel: TLabel;
    DeviceTypeLabel: TLabel;
    DeviceNameValueLabel: TStaticText;
    DeviceNameLabel: TLabel;
    SplitterImage2: TImage;
    KMPasswordLabel: TLabel;
    KeyboardStatePanel: TPanel;
    KSWarningImage: TImage;
    KSLabel: TLabel;
    KSWTimer: TTimer;
    KMPasswordEdit: TEdit;
    KMTreeView: TTreeView;
    KMImageList: TImageList;
    KSLanguageBackgroundLabel: TLabel;
    KSLanguageLabel: TLabel;
    DeviceTypeStaticText: TStaticText;
    RefreshImageLink: TImageLinkFrame;
    ScreenKBSpeedButton: TSpeedButton;
    InfoImage: TImage;
    NewPasswordPanel: TPanel;
    KMNewPasswordEdit: TEdit;
    KMNewPasswordLabel: TLabel;
    KMNewPasswordRepeatEdit: TEdit;
    KMNewPasswordRepeatLabel: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure SelectDeviceClick(Sender: TObject);
    procedure UpdateDeviceList(Selected: TTreeNode);
    procedure UpdateDeviceTypeList();
    procedure RefreshImageLinkClick(Sender: TObject);
    procedure UpdatePasswordFieldsState(Enabled: Boolean);
    function ValidatePasswordData(): Boolean;
    procedure OKButtonClick(Sender: TObject);
    procedure KSWTimerTimer(Sender: TObject);
    procedure ScreenKBSpeedButtonClick(Sender: TObject);

  private
    CPInterface: PEUSignCP;
    KeyMedia: PEUKeyMedia;
    NewPassword: PAnsiChar;
    Error: Cardinal;
    ChangePassword: Boolean;
    IsPKReaded: Boolean;

  public
    procedure ConfigForm(CPInterface: PEUSignCP; KeyMedia: PEUKeyMedia;
      ChangePassword: Boolean; NewPassword: PAnsiChar = nil;
      IsPKReaded: Boolean = False);
  end;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

uses EUSignCPOwnUI
{$if CompilerVersion > 19}
  , ScreenKeyboard
{$ifend};

{ ------------------------------------------------------------------------------ }

const
  KLNames: Array [0 .. 111] of String = ('NE', 'AR', 'BU', 'CA', 'CH', 'CZ',
    'DA', 'DE', 'GR', 'EN', 'SP', 'FI', 'FR', 'HE', 'HU', 'IC', 'IT', 'JA',
    'KO', 'DU', 'NO', 'PO', 'PO', '-', 'RO', 'RU', 'CR', 'SL', 'AL', 'SW', 'TH',
    'TU', 'UR', 'IN', 'UK', 'BE', 'SL', 'ES', 'LA', 'LI', '-', 'FA', 'VI', 'AR',
    'AZ', 'BA', '-', 'MA', '-', '-', '-', '-', '-', '-', 'AF', 'GE', 'FA', 'HI',
    '-', '-', '-', '-', 'MA', 'KA', '-', 'SW', '-', 'UZ', 'TA', 'BE', 'PU',
    'GU', 'OR', 'TA', 'TE', 'KA', 'MA', 'AS', 'MA', 'SA', '-', '-', '-', '-',
    '-', '-', '-', 'KO', 'MA', 'SI', '-', '-', '-', '-', '-', '-', 'KA', 'NE',
    '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-');

{$R *.dfm}

{ ============================================================================== }

procedure TKeyMediaFrame.ConfigForm(CPInterface: PEUSignCP;
  KeyMedia: PEUKeyMedia; ChangePassword: Boolean; NewPassword: PAnsiChar;
  IsPKReaded: Boolean);
begin
  self.KeyMedia := KeyMedia;
  self.CPInterface := CPInterface;
  self.ChangePassword := ChangePassword;
  self.NewPassword := NewPassword;

  self.IsPKReaded := IsPKReaded and ChangePassword;

  DeviceTypeStaticText.Caption := '';
  DeviceNameValueLabel.Caption := '';

  NewPasswordPanel.Visible := ChangePassword;

  UpdatePasswordFieldsState(False);

  UpdateDeviceTypeList();
end;

{ ============================================================================== }

procedure TKeyMediaFrame.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Return: Integer;
  Selected: TTreeNode;

begin
  CanClose := True;
  Selected := KMTreeView.Selected;

  if ((Selected = nil) or (Selected.Level <> 1)) and
    (TForm(Parent).ModalResult = mrOk) then
  begin
    Return := MessageBox(TForm(Parent).Handle,
      'Не вказано носій ключової інформації, обрaти носій?',
      'Повідомлення оператору', MB_YESNOCANCEL or MB_ICONWARNING);
    case Return of
      IDYES:
        begin
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

{ ------------------------------------------------------------------------------ }

procedure TKeyMediaFrame.FormShow(Sender: TObject);
begin
  KMTreeView.SetFocus;

  if IsPKReaded then
  begin
    SelectDeviceClick(nil);
    KMPasswordEdit.Text := KeyMedia.Password;
  end
  else if (KMTreeView.Items.Count > 1) then
  begin
    KMTreeView.Items[0].Selected := True;
    SelectDeviceClick(nil);
  end;

  try
    KSWTimer.Enabled := True;
    ActivateKeyboardLayout(LoadKeyboardLayout('00000409', KLF_ACTIVATE or
      KLF_REPLACELANG), KLF_REORDER);
  except
    KSWTimer.Enabled := False;
    KeyboardStatePanel.Visible := False;
  end;
end;

{ ============================================================================== }

procedure TKeyMediaFrame.OKButtonClick(Sender: TObject);
var
  SelectedNode: TTreeNode;

begin
  SelectedNode := KMTreeView.Selected;

  if (SelectedNode.Level <> 1) then
  begin
    MessageBoxA(TForm(Parent).Handle, 'Не вказано носій ключової інформації',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if (not ValidatePasswordData()) then
    Exit;

  StrCopy(KeyMedia.Password, PAnsiChar(AnsiString(KMPasswordEdit.Text)));

  KeyMedia.TypeIndex := SelectedNode.Parent.Index;
  KeyMedia.DeviceIndex := SelectedNode.Index;

  if ChangePassword then
  begin
    StrCopy(NewPassword, PAnsiChar(AnsiString(KMNewPasswordEdit.Text)));
  end;

  Error := NO_ERROR;

  TForm(Parent).ModalResult := mrOk;
  TForm(Parent).Hide;
end;

{ ------------------------------------------------------------------------------ }

procedure TKeyMediaFrame.KSWTimerTimer(Sender: TObject);
var
  ID: Integer;

begin
  KSWTimer.Enabled := False;

  KSWarningImage.Visible := Boolean(GetKeyState(VK_CAPITAL) and $1);
  KSLabel.Visible := Boolean(GetKeyState(VK_CAPITAL) and $1);

  ID := LoByte(GetKeyboardLayout(GetCurrentThreadId()));
  if (ID >= 112) then
    ID := 111;

  KSLanguageLabel.Caption := KLNames[ID];
  KSWTimer.Enabled := True;
end;

{ ------------------------------------------------------------------------------ }

procedure TKeyMediaFrame.SelectDeviceClick(Sender: TObject);
var
  SelectedNode: TTreeNode;
  IsDevice: Boolean;

begin
  SelectedNode := KMTreeView.Selected;
  IsDevice := (not(SelectedNode.Level = 0));

  UpdatePasswordFieldsState(IsDevice);
  ScreenKBSpeedButton.Visible := IsDevice;

  DeviceNameLabel.Visible := IsDevice;
  DeviceNameValueLabel.Visible := IsDevice;

  if IsDevice then
  begin
    DeviceTypeStaticText.Caption := SelectedNode.Parent.Text;
    DeviceNameValueLabel.Caption := SelectedNode.Text;
  end
  else
  begin
    DeviceTypeStaticText.Caption := SelectedNode.Text;
    SelectedNode.Expand(False);
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TKeyMediaFrame.ScreenKBSpeedButtonClick(Sender: TObject);
var
  Pos: TPoint;

begin
{$if CompilerVersion > 19}
  if ScreenKeyboardForm.IsShown then
    Exit;

  ScreenKeyboardForm.IsShown := True;

  Pos := self.ClientToScreen(Point(self.Left, KMPasswordEdit.Top));
  Pos.Y := Pos.Y + 2 * KMPasswordEdit.Height;

  ScreenKeyboardForm.Left := Pos.X;
  ScreenKeyboardForm.Top := Pos.Y;

  ScreenKeyboardForm.ShowKeyboard(KMPasswordEdit);
{$ifend}
end;

{ ------------------------------------------------------------------------------ }

procedure TKeyMediaFrame.RefreshImageLinkClick(Sender: TObject);
var
  SelectedNode: TTreeNode;

begin
  SelectedNode := KMTreeView.Selected;

  if (SelectedNode.Level = 0) then
  begin
    UpdateDeviceList(SelectedNode);
    UpdatePasswordFieldsState(False);
  end;

  KMTreeView.SetFocus;

  SelectedNode.Selected := True;
  SelectedNode.Expanded := True;
end;

{ ------------------------------------------------------------------------------ }

procedure TKeyMediaFrame.UpdateDeviceList(Selected: TTreeNode);
var
  DeviceDescription: Array [0 .. (EU_DEV_DESC_MAX_LENGTH + 1)] of AnsiChar;
  TypeIndex, DeviceIndex: Cardinal;
  Error: Cardinal;
  Device: TTreeNode;

begin
  Selected.DeleteChildren;
  TypeIndex := Selected.Index;

  Error := EU_ERROR_NONE;
  DeviceIndex := 0;

  while (Error = EU_ERROR_NONE) do
  begin
    Error := CPInterface.EnumKeyMediaDevices(TypeIndex, DeviceIndex,
      @DeviceDescription);
    if (Error = EU_ERROR_NONE) then
    begin
      Device := KMTreeView.Items.AddChild(Selected,
        AnsiString(DeviceDescription));
      Device.ImageIndex := Selected.ImageIndex;
      Device.SelectedIndex := Selected.ImageIndex;

      if IsPKReaded then
      begin
        if (KeyMedia.TypeIndex = TypeIndex) and
          (KeyMedia.DeviceIndex = DeviceIndex) then
          begin
           Device.Selected := True;
          end;
      end;

    end
    else if (Error <> EU_WARNING_END_OF_ENUM) then
    begin
      EUShowErrorMessage(Handle,
        PAnsiChar(AnsiString('Опис помилки: ' + CPInterface.GetErrorDesc
        (Error))));
      Exit;
    end;

    DeviceIndex := DeviceIndex + 1;
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TKeyMediaFrame.UpdateDeviceTypeList();
var
  DeviceType: Array [0 .. (EU_TYPE_DESC_MAX_LENGTH + 1)] of AnsiChar;
  Error: Cardinal;
  Index: Cardinal;
  Item: TTreeNode;

begin
  KMTreeView.Items.Clear;
  Error := EU_ERROR_NONE;
  Index := 0;

  while (Error = EU_ERROR_NONE) do
  begin
    Error := CPInterface.EnumKeyMediaTypes(Index, @DeviceType);
    if Error = EU_ERROR_NONE then
    begin
      Item := KMTreeView.Items.Add(nil, AnsiString(DeviceType));
      Item.ImageIndex := 0;
      Item.SelectedIndex := Item.ImageIndex;
      UpdateDeviceList(Item);
    end
    else if (Error <> EU_WARNING_END_OF_ENUM) then
    begin
      EUShowErrorMessage(Handle,
        PAnsiChar(AnsiString('Опис помилки: ' + CPInterface.GetErrorDesc
        (Error))));
      Exit;
    end;

    Index := Index + 1;
  end;
end;

{ ------------------------------------------------------------------------------ }

procedure TKeyMediaFrame.UpdatePasswordFieldsState(Enabled: Boolean);
begin
  KMPasswordLabel.Enabled := Enabled;
  KMPasswordEdit.Enabled := Enabled;
  KMPasswordEdit.Text := '';

  if ChangePassword then
  begin
    KMNewPasswordEdit.Enabled := Enabled;
    KMNewPasswordLabel.Enabled := Enabled;
    KMNewPasswordEdit.Text := '';

    KMNewPasswordRepeatEdit.Enabled := Enabled;
    KMNewPasswordRepeatLabel.Enabled := Enabled;
    KMNewPasswordRepeatEdit.Text := '';
  end;
end;

{ ------------------------------------------------------------------------------ }

function TKeyMediaFrame.ValidatePasswordData(): Boolean;
begin
  ValidatePasswordData := False;
  if (Length(KMPasswordEdit.Text) < 1) then
  begin
    MessageBoxA(TForm(Parent).Handle,
      'Не вказано пароль до носія ключової інформації',
      'Повідомлення оператору', MB_ICONERROR);
    Exit;
  end;

  if ChangePassword then
  begin
    if (Length(KMNewPasswordEdit.Text) < 1) then
    begin
      MessageBoxA(TForm(Parent).Handle,
        'Не вказано новий пароль до носія ключової інформації',
        'Повідомлення оператору', MB_ICONERROR);
      Exit;
    end;

    if (KMNewPasswordEdit.Text <> KMNewPasswordRepeatEdit.Text) then
    begin
      MessageBoxA(TForm(Parent).Handle,
        'Новий пароль до носія ключової інформації та його повтор не співпадають',
        'Повідомлення оператору', MB_ICONERROR);
      Exit;
    end;
  end;

  ValidatePasswordData := True;
end;

{ ============================================================================== }

end.
