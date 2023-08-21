unit LoginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus, cxLabel, Vcl.StdCtrls,
  cxButtons, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxPropertiesStore,
  dxSkinsCore, dxSkinsDefaultPainters, cxClasses, UtilConst, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TcxComboBoxUser = Class(TcxComboBox)
  private
    function GetUsers: string;
    procedure SetUsers(const Value: string);
  published
    property Users: string read GetUsers write SetUsers;
  end;

  TcxComboBox = Class(TcxComboBoxUser)
  end;

  TLoginForm = class(TForm)
    edUserName: TcxComboBox;
    edPassword: TcxTextEdit;
    btnOk: TcxButton;
    btnCancel: TcxButton;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxPropertiesStore: TcxPropertiesStore;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAllowLocalConnect: Boolean;
    FOnlyLocal: Boolean;
    function GetUsers: string;
    procedure SetUsers(const Value: string);
    procedure SetAllowLocalConnect(Value: Boolean);
  public
    property AllowLocalConnect: Boolean read FAllowLocalConnect write SetAllowLocalConnect;
    property OnlyLocal: Boolean read FOnlyLocal write FOnlyLocal;
  published
    property Users: string read GetUsers write SetUsers;
  end;

implementation

{$R *.dfm}

uses
  Storage, Authentication, CommonData, MessagesUnit, StrUtils, LocalWorkUnit, ParentForm;

{ TcxComboBoxUser }

function TcxComboBoxUser.GetUsers: string;
begin
  result := Properties.Items.Text
end;

procedure TcxComboBoxUser.SetUsers(const Value: string);
  var ItemList : String;
begin
  if dsdProject = prFarmacy then
  begin
    try
      ItemList := TAuthentication.GetLoginList(TStorageFactory.GetStorage);
      if ItemList <> '' then
      begin
        Properties.Items.Text := ItemList;
        Exit;
      end;
    except
    end;
  end;

  if Value <> '' then Properties.Items.Text := Value
end;

{ TLoginForm }

procedure TLoginForm.btnOkClick(Sender: TObject);
var TextMessage,EMessage: String;
begin
  try
    if not FOnlyLocal then
    Begin
      TAuthentication.CheckLogin(TStorageFactory.GetStorage, edUserName.Text,
        edPassword.Text, gc_User, not FAllowLocalConnect);
      if assigned(gc_User) then
      Begin
        if edUserName.Properties.Items.IndexOf(edUserName.Text) = -1 then
           edUserName.Properties.Items.Add(edUserName.Text);
// 01.05.19  Получение списка пользователей централизовано
//        if FAllowLocalConnect then
//          SaveLocalConnect(edUserName.Text, edPassword.Text, gc_User.Session);
        TStorageFactory.GetStorage.LoadReportList(gc_User.Session);
        if dsdProject = prProject then
        begin
          TStorageFactory.GetStorage.LoadReportPriorityList(gc_User.Session);
          TStorageFactory.GetStorage.LoadStoredProcList(gc_User.Session);
        end;
        if dsdProject = prFarmacy then
          TStorageFactory.GetStorage.LoadReportLocalList(gc_User.Session);
        ModalResult := mrOk;
      End
      else
        FOnlyLocal := FAllowLocalConnect;
    End;
    if FOnlyLocal then
    Begin
      if CheckLocalConnect(edUserName.Text, edPassword.Text, gc_User) then
      Begin
        ModalResult := mrOk;
        exit;
      End;
    End;
  except
    on E: Exception do
    begin
      if ((pos('connect timed out', AnsilowerCase(E.Message)) > 0) or
          (pos('internal server error', AnsilowerCase(E.Message)) > 0) or
          (pos('not allowed', AnsilowerCase(E.Message)) > 0)) and
         FAllowLocalConnect then
      Begin
        if CheckLocalConnect(edUserName.Text, edPassword.Text, gc_User) then
        Begin
          ModalResult := mrOk;
          exit;
        End
        else
          FOnlyLocal := True;
      End
      else
      Begin
        if pos('context', AnsilowerCase(E.Message)) = 0 then
           TextMessage := E.Message
        else
           // Выбрасываем все что после Context
           TextMessage := Copy(E.Message, 1, pos('context', AnsilowerCase(E.Message)) - 1);
        TextMessage := ReplaceStr(TextMessage, 'ERROR:', 'ОШИБКА:');
        EMessage := E.Message;
        TMessagesForm.Create(nil).Execute(TextMessage, EMessage);
      End;
    end;
  end;
end;

procedure TLoginForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree
end;

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  if dsdProject = prFarmacy then edUserName.Properties.Sorted := True;
  with cxPropertiesStore.Components.Add do begin
    Component := edUserName;
    Properties.Add('Users');
    Properties.Add('Text');
  end;
  with cxPropertiesStore.Components.Add do begin
    Component := Self;
    Properties.Add('Height');
    Properties.Add('Left');
    Properties.Add('Top');
    Properties.Add('Width');
    Properties.Add('Users');
  end;
  cxPropertiesStore.RestoreFrom;

  AllowLocalConnect := False;
  FOnlyLocal := False;
  TranslateForm(Self);
end;

function TLoginForm.GetUsers: string;
begin
  result := edUserName.Properties.Items.Text
end;

procedure TLoginForm.SetAllowLocalConnect(Value: Boolean);
begin
  FAllowLocalConnect := Value;
  gc_allowLocalConnection := Value;
end;

procedure TLoginForm.SetUsers(const Value: string);
begin
  if edUserName.Properties.Items.Text = '' then edUserName.Properties.Items.Text := Value
end;

end.
//А тут должна быть картинка программы
