unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, FMX.Objects, FMX.Edit,
  System.Generics.Collections, System.Actions, FMX.ActnList, FMX.Platform,
  System.IniFiles, FMX.VirtualKeyboard, FMX.DialogService, FMX.DataWedgeBarCode,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView
  {$IFDEF ANDROID}
  ,System.Permissions,Androidapi.JNI.Os, FMX.Helpers.Android, Androidapi.Helpers,
  Androidapi.JNI.Location, Androidapi.JNIBridge, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes, AndroidApi.JNI.WebKit
  {$ENDIF};

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
    acMain: TActionList;
    ChangePartnerInfoLeft: TChangeTabAction;
    ChangePartnerInfoRight: TChangeTabAction;
    ChangeMainPage: TChangeTabAction;
    aiWait: TAniIndicator;
    imLogo: TImage;
    lCaption: TLabel;
    sbBack: TSpeedButton;
    Image7: TImage;
    sbMain: TStyleBook;
    VertScrollBox8: TVertScrollBox;
    GridPanelLayout3: TGridPanelLayout;
    bHandBook: TButton;
    Image1: TImage;
    Label1: TLabel;
    bVisit: TButton;
    Image2: TImage;
    Label5: TLabel;
    bTasks: TButton;
    Image4: TImage;
    lTasks: TLabel;
    bReport: TButton;
    Image6: TImage;
    Label7: TLabel;
    bSync: TButton;
    Image3: TImage;
    Label8: TLabel;
    bInfo: TButton;
    Image5: TImage;
    Label6: TLabel;
    bDocuments: TButton;
    Image18: TImage;
    Label74: TLabel;
    bRelogin: TButton;
    Image19: TImage;
    Label75: TLabel;
    tiInformation: TTabItem;
    Panel17: TPanel;
    VertScrollBox6: TVertScrollBox;
    lWebService: TLayout;
    Label39: TLabel;
    eWebService: TEdit;
    lMobileVersion: TLayout;
    Label31: TLabel;
    eMobileVersion: TEdit;
    lServerVersion: TLayout;
    Label48: TLabel;
    eServerVersion: TEdit;
    bUpdateProgram: TButton;
    lCurWebService: TLayout;
    Label81: TLabel;
    eCurWebService: TEdit;
    pScanTest: TPanel;
    sbScan: TSpeedButton;
    Image8: TImage;
    lwPromoPartners: TListView;
    Label9: TLabel;

    procedure OnCloseDialog(const AResult: TModalResult);
    procedure sbBackClick(Sender: TObject);
    procedure LogInButtonClick(Sender: TObject);
    procedure bReloginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ChangeMainPageUpdate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ShowInformation;
    procedure bInfoClick(Sender: TObject);
    procedure sbScanClick(Sender: TObject);
    procedure OnScanResultDetails(Sender: TObject; AAction, ASource, ALabel_Type, AData_String: String);
  private
    { Private declarations }
    FFormsStack: TStack<TFormStackItem>;
    FDataWedgeBarCode: TDataWedgeBarCode;
    FTemporaryServer: string;
    FUseAdminRights: boolean;
    FPermissionState: boolean;

    procedure SwitchToForm(const TabItem: TTabItem; const Data: TObject);
    procedure ReturnPriorForm(const OmitOnChange: Boolean = False);

    procedure Wait(AWait: Boolean);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses System.IOUtils, Authentication, Storage, CommonData, CursorUtils;

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
  FPermissionState := True;

  // установка вертикального положения экрана телефона
  {$IFDEF ANDROID}
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
  begin
    OrientSet := [TScreenOrientation.Portrait];
    ScreenService.SetSupportedScreenOrientations(OrientSet);
  end;
  {$ENDIF}

  FFormsStack := TStack<TFormStackItem>.Create;

  FDataWedgeBarCode := TDataWedgeBarCode.Create(Nil);

  // установка разрешений
  {$IFDEF ANDROID}
  if not PermissionsService.IsPermissionGranted(JStringToString(TJManifest_permission.JavaClass.READ_PHONE_STATE)) or
     not PermissionsService.IsPermissionGranted(JStringToString(TJManifest_permission.JavaClass.CAMERA)) or
     not PermissionsService.IsPermissionGranted(JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)) then
  begin
    FPermissionState := False;
    PermissionsService.RequestPermissions([JStringToString(TJManifest_permission.JavaClass.READ_PHONE_STATE),
                                           JStringToString(TJManifest_permission.JavaClass.CAMERA),
                                           JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)],
      procedure(const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray)
      begin
        if (Length(AGrantResults) > 1) and (AGrantResults[0] = TPermissionStatus.Granted) then
          FPermissionState := True;
      end);
  end;
  {$ENDIF}
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FDataWedgeBarCode.Free;
  FFormsStack.Free;
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

// возврат на предидущую форму из стэка открываемых форм, с удалением её из стэка
procedure TfrmMain.ReturnPriorForm(const OmitOnChange: Boolean);
var
  Item: TFormStackItem;
  OnChange: TNotifyEvent;
begin

  if FFormsStack.Count > 0 then
    begin
      Item:= FFormsStack.Pop;

      OnChange := tcMain.OnChange;
      if OmitOnChange then tcMain.OnChange := nil;
      try
        tcMain.ActiveTab:= tcMain.Tabs[Item.PageIndex];
      finally
        tcMain.OnChange := OnChange;
      end;
    end
  else
    raise Exception.Create('Forms stack underflow');
end;

// обработка изменения закладки (формы)
procedure TfrmMain.ChangeMainPageUpdate(Sender: TObject);
begin
  FUseAdminRights := false;
  lwPromoPartners.Items.Clear;
  FDataWedgeBarCode.OnScanResultDetails := Nil;
  FDataWedgeBarCode.OnScanResult := Nil;
  PasswordEdit.Text := '';

  { настройка панели возврата }
  if (tcMain.ActiveTab = tiStart)  then
    pBack.Visible := false
  else
  begin
    pBack.Visible := true;
    if tcMain.ActiveTab = tiMain then
    begin
      imLogo.Visible := true;
      sbBack.Visible := false;
    end
    else
    begin
      imLogo.Visible := false;
      sbBack.Visible := true;
    end;

    if (tcMain.ActiveTab = tiInformation)  then
      sbScan.Visible := true
    else sbScan.Visible := false;

    if tcMain.ActiveTab = tiMain then
      lCaption.Text := 'Project Boot Mobile'
    else
    if tcMain.ActiveTab = tiInformation then
    begin
      lCaption.Text := 'Информация';
      FDataWedgeBarCode.OnScanResultDetails := OnScanResultDetails;
    end
    else
  end;
end;

// начитка информации про программу
procedure TfrmMain.ShowInformation;
var
  Res : integer;
begin

//  eMobileVersion.Text := DM.GetCurrentVersion;

//  Res := DM.CompareVersion(eMobileVersion.Text, DM.tblObject_ConstMobileVersion.AsString);
//  if Res > 0 then
//  begin
//    lServerVersion.Height := 60;
//    eServerVersion.Text := DM.tblObject_ConstMobileVersion.AsString;
//
//    {$IFDEF ANDROID}
//    bUpdateProgram.Visible := true
//    {$ELSE}
//    bUpdateProgram.Visible := false;
//    {$ENDIF}
//  end
//  else
//    lServerVersion.Height := 0;

//  eWebService.Text := DM.tblObject_ConstWebService.AsString
//            + ' ; ' + DM.tblObject_ConstWebService_two.AsString
//            + ' ; ' + DM.tblObject_ConstWebService_three.AsString
//            + ' ; ' + DM.tblObject_ConstWebService_four.AsString
//    ;

//  if not SameText(gc_WebService, DM.tblObject_ConstWebService.AsString) then
//  begin
//    lCurWebService.Height := 60;
//    eCurWebService.Text := gc_WebService;
//    if High(gc_WebServers) > 1 then eCurWebService.Text := eCurWebService.Text+ ' ; ' + gc_WebServers[1];
//    if High(gc_WebServers_r) > 0 then eCurWebService.Text := eCurWebService.Text+ ' ; ' + gc_WebServers_r[0];
//    if High(gc_WebServers_r) > 1 then eCurWebService.Text := eCurWebService.Text+ ' ; ' + gc_WebServers_r[1];
//  end
//  else
//    lCurWebService.Height := 0;
//  eSyncDateIn.Text := FormatDateTime('DD.MM.YYYY hh:nn:ss', DM.tblObject_ConstSyncDateIn.AsDateTime);
//  eSyncDateOut.Text := FormatDateTime('DD.MM.YYYY hh:nn:ss', DM.tblObject_ConstSyncDateOut.AsDateTime);

  SwitchToForm(tiInformation, nil);
end;

// переход на форму отображения информации
procedure TfrmMain.bInfoClick(Sender: TObject);
begin
  ShowInformation;
end;

// возврат на форму логина
procedure TfrmMain.bReloginClick(Sender: TObject);
begin
  ReturnPriorForm;
end;

procedure TfrmMain.OnCloseDialog(const AResult: TModalResult);
begin
  if AResult = mrOK then
    Close;
end;

// обработка нажатия кнопки возврата на предидущую форму
procedure TfrmMain.sbBackClick(Sender: TObject);
var
  Mes : string;
begin
//  if (tcMain.ActiveTab = tiOrderExternal) and FCanEditDocument then
//  begin
//    if DM.cdsOrderExternalId.AsInteger = -1 then
//      Mes := 'Выйти без сохранения заявки?'
//    else
//      Mes := 'Выйти из редактирования без сохранения?';
//
//    TDialogService.MessageDialog(Mes, TMsgDlgType.mtWarning,
//      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, BackResult);
//  end
//  else
//  if (tcMain.ActiveTab = tiStoreReal) and FCanEditDocument then
//  begin
//    if DM.cdsStoreRealsId.AsInteger = -1 then
//      Mes := 'Выйти без сохранения остатков?'
//    else
//      Mes := 'Выйти из редактирования без сохранения?';
//
//    TDialogService.MessageDialog(Mes, TMsgDlgType.mtWarning,
//      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, BackResult);
//  end
//  else
//  if (tcMain.ActiveTab = tiReturnIn) and FCanEditDocument then
//  begin
//    if DM.cdsReturnInId.AsInteger = -1 then
//      Mes := 'Выйти без сохранения возврата?'
//    else
//      Mes := 'Выйти из редактирования без сохранения?';
//
//    TDialogService.MessageDialog(Mes, TMsgDlgType.mtWarning,
//      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, BackResult);
//  end
//  else
    ReturnPriorForm;
end;

procedure TfrmMain.sbScanClick(Sender: TObject);
begin
  FDataWedgeBarCode.Scan;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
var
  FService : IFMXVirtualKeyboardService;
begin
  // возврат на предидущую форму при нажатии "отмены" на телефоне
  if Key = vkHardwareBack then
  begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
    begin
      // Back button pressed, keyboard visible, so do nothing...
    end else
    begin
      Key := 0;

//      if pProgress.Visible then
//        exit
//      else
//      if ppEnterAmount.IsOpen then
//        ppEnterAmount.IsOpen := false
//      else
//      if ppPartner.IsOpen then
//        ppPartner.IsOpen := false
//      else
//      if pAdminPassword.Visible then
//        bCancelPasswordClick(bCancelPassword)
//      else
//      if pEnterMovmentCash.Visible then
//        bCancelCashClick(bCancelCash)
//      else
//      if pNewPhotoGroup.Visible then
//        bCanclePGClick(bCanclePG)
//      else
//      if pPhotoComment.Visible then
//        bCancelPhotoClick(bCancelPhoto)
//      else
//      if pTaskComment.Visible then
//        bCancelTaskClick(bCancelTask)
//      else
      if tcMain.ActiveTab = tiStart then
        TDialogService.MessageDialog('Закрыть программу?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], TMsgDlgBtn.mbCancel, -1, OnCloseDialog)
      else
      if tcMain.ActiveTab = tiMain then
        bReloginClick(bRelogin)
      else
        sbBackClick(sbBack);
    end;
  end;end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  SwitchToForm(tiStart, nil);
  ChangeMainPageUpdate(nil);
end;

procedure TfrmMain.LogInButtonClick(Sender: TObject);
var
  ErrorMessage: String;
  SettingsFile : TIniFile;
  NeedSync : boolean;
begin
  NeedSync := not assigned(gc_User);

  if not FPermissionState then
  begin
    ShowMessage('Необходимые разрешения не предоставлены');
    exit;
  end;

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

procedure TfrmMain.OnScanResultDetails(Sender: TObject; AAction, ASource, ALabel_Type, AData_String: String);
begin
  with TListViewItem(TAppearanceListViewItems(lwPromoPartners.Items.AddItem(0))) do
  begin
    Data['ActionLabel'] := 'Action';
    Data['Action'] := AAction;
    Data['SourceLabel'] := 'Source';
    Data['Source'] := ASource;
    Data['Label_TypeLabel'] := 'Label_Type';
    Data['Label_Type'] := ALabel_Type;
    Data['Data_StringLabel'] := 'Data_String';
    Data['Data_String'] := AData_String;
  end;
end;


end.
