unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, FMX.Objects, FMX.Edit,
  System.Generics.Collections;

type
  TFormStackItem = record
    PageIndex: Integer;
    Data: TObject;
  end;

  TfrmMain = class(TForm)
    vsbMain: TVertScrollBox;
    pBack: TPanel;
    tcMain: TTabControl;
    tiStart: TTabItem;
    LoginPanel: TPanel;
    LoginScaledLayout: TScaledLayout;
    Layout1: TLayout;
    LoginEdit: TEdit;
    Layout2: TLayout;
    Label2: TLabel;
    Layout3: TLayout;
    PasswordLabel: TLabel;
    Layout4: TLayout;
    PasswordEdit: TEdit;
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    WebServerLayout: TLayout;
    WebServerLayout11: TLayout;
    WebServerLabel: TLabel;
    WebServerLayout12: TLayout;
    WebServerEdit: TEdit;
    Layout43: TLayout;
    Layout5: TLayout;
    Layout37: TLayout;
    LogInButton: TButton;
    tiMain: TTabItem;
    procedure LogInButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FFormsStack: TStack<TFormStackItem>;
    FTemporaryServer: string;
    FUseAdminRights: boolean;

    procedure SwitchToForm(const TabItem: TTabItem; const Data: TObject);
    procedure Wait(AWait: Boolean);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses System.IOUtils, System.IniFiles, Authentication, Storage, CommonData, CursorUtils;

{$R *.fmx}

// перевод формы в/из режим ожидания
procedure TfrmMain.Wait(AWait: Boolean);
begin
  LogInButton.Enabled := not AWait;
  LoginEdit.Enabled := not AWait;
  PasswordEdit.Enabled := not AWait;
  WebServerEdit.Enabled := not AWait;

  if AWait then
    Screen_Cursor_crHourGlass
  else
    Screen_Cursor_crDefault;

  Application.ProcessMessages;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  {$IFDEF ANDROID}
  ScreenService: IFMXScreenService;
  OrientSet: TScreenOrientations;
  {$ENDIF}
  SettingsFile : TIniFile;
begin
  FUseAdminRights := false;

  //Application.OnIdle := MobileIdle;

  FormatSettings.DecimalSeparator := '.';

  // получение настроек из ini файла
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  SettingsFile := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'settings.ini'));
  {$ELSE}
  SettingsFile := TIniFile.Create(TPath.Combine(ExtractFilePath(ParamStr(0)), 'settings.ini'));
  {$ENDIF}
  try
    LoginEdit.Text := SettingsFile.ReadString('LOGIN', 'USERNAME', '');
    FTemporaryServer := SettingsFile.ReadString('LOGIN', 'TemporaryServer', '');
  finally
    FreeAndNil(SettingsFile);
  end;

  // установка вертикального положения экрана телефона
  {$IFDEF ANDROID}
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
  begin
    OrientSet := [TScreenOrientation.Portrait];
    ScreenService.SetSupportedScreenOrientations(OrientSet);
  end;
  {$ENDIF}

  FFormsStack := TStack<TFormStackItem>.Create;

  // установка разрешений
  {$IFDEF ANDROID}
  if not PermissionsService.IsPermissionGranted(JStringToString(TJManifest_permission.JavaClass.READ_PHONE_STATE)) or
     not PermissionsService.IsPermissionGranted(JStringToString(TJManifest_permission.JavaClass.CAMERA)) or
     not PermissionsService.IsPermissionGranted(JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION)) or
     not PermissionsService.IsPermissionGranted(JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)) then
  begin
    FPermissionState := False;
    PermissionsService.RequestPermissions([JStringToString(TJManifest_permission.JavaClass.READ_PHONE_STATE),
                                           JStringToString(TJManifest_permission.JavaClass.CAMERA),
                                           JStringToString(TJManifest_permission.JavaClass.ACCESS_FINE_LOCATION),
                                           JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)],
      procedure(const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray)
      begin
        if (Length(AGrantResults) > 1) and (AGrantResults[0] = TPermissionStatus.Granted) then
          FPermissionState := True;
      end);
  end;
  {$ENDIF}
end;

// переход на заданную форму с сохранением её в стэк открываемых форм
procedure TfrmMain.SwitchToForm(const TabItem: TTabItem; const Data: TObject);
var
  Item: TFormStackItem;
begin
  Item.PageIndex := tcMain.ActiveTab.Index;
  Item.Data := Data;
  FFormsStack.Push(Item);
  tcMain.ActiveTab := TabItem;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FFormsStack.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  SwitchToForm(tiStart, nil);
//  ChangeMainPageUpdate(tcMain);
end;

procedure TfrmMain.LogInButtonClick(Sender: TObject);
var
  ErrorMessage: String;
  SettingsFile : TIniFile;
  NeedSync : boolean;
begin
  NeedSync := not assigned(gc_User);

//  if not FPermissionState then
//  begin
//    ShowMessage('Необходимые разрешения не предоставлены');
//    exit;
//  end;


  if gc_WebService = '' then
    gc_WebService := WebServerEdit.Text;

  Wait(True);
  try
    ErrorMessage := TAuthentication.CheckLogin(TStorageFactory.GetStorage, LoginEdit.Text, PasswordEdit.Text, gc_User);

    Wait(False);

    if ErrorMessage <> '' then
    begin
      ShowMessage(ErrorMessage);
      exit;
    end;
  except on E: Exception do
    begin
      Wait(False);

      if assigned(gc_User) then  { Проверяем login и password в локальной БД }
      begin
        gc_User.Local := true;

        if (LoginEdit.Text <> gc_User.Login) or (PasswordEdit.Text <> gc_User.Password) then
        begin
          ShowMessage('Введен неправильный логин или пароль');
          exit;
        end
        else
          ShowMessage('Нет связи с сервером. Программа переведена в режим автономной работы.');
      end
      else
      begin
        ShowMessage('Нет связи с сервером. Продолжение работы невозможно'+#13#10 + E.Message);
        exit;
      end;
    end;
    //
  end;

  // !!!Optimize!!!
  //if SyncCheckBox.IsChecked = TRUE then
  //   fOptimizeDB;

//  // сохранение координат при логине и запуск таймера
//  tSavePathTimer(tSavePath);
//
//  if not gc_User.Local then
//  begin
//    if not DM.GetConfigurationInfo then
//      Exit;
//
//    if NeedSync then
//      DM.SynchronizeWithMainDatabase
//    else
//      DM.CheckUpdate; // проверка небходимости обновления
//  end;

  // сохранение логина в ini файле
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  SettingsFile := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'settings.ini'));
  {$ELSE}
  SettingsFile := TIniFile.Create(TPath.Combine(ExtractFilePath(ParamStr(0)), 'settings.ini'));
  {$ENDIF}
  try
    SettingsFile.WriteString('LOGIN', 'USERNAME', LoginEdit.Text);
    if FUseAdminRights then
    begin
      SettingsFile.WriteString('LOGIN', 'TemporaryServer', WebServerEdit.Text);
      FTemporaryServer := WebServerEdit.Text;
    end;
  finally
    FreeAndNil(SettingsFile);
  end;

  SwitchToForm(tiMain, nil);
end;

end.
