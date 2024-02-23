unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.DateUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, FMX.Objects, FMX.Edit,
  System.Generics.Collections, System.Actions, FMX.ActnList, FMX.Platform,
  System.IniFiles, FMX.VirtualKeyboard, FMX.DialogService, FMX.DataWedgeBarCode,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, uDM, FMX.Media,  Winsoft.FireMonkey.Obr, System.ImageList, FMX.ImgList,
  FMX.DateTimeCtrls, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope
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
    bInventoryJournal: TButton;
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
    bLogIn: TButton;
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
    lMobileVersion: TLayout;
    Label31: TLabel;
    eMobileVersion: TEdit;
    lServerVersion: TLayout;
    Label48: TLabel;
    eServerVersion: TEdit;
    bUpdateProgram: TButton;
    pScanTest: TPanel;
    sbScan: TSpeedButton;
    Image8: TImage;
    lwBarCodeResult: TListView;
    Label9: TLabel;
    Layout6: TLayout;
    Layout7: TLayout;
    Layout8: TLayout;
    LogInCodeButton: TButton;
    pProgress: TPanel;
    Layout9: TLayout;
    Pie3: TPie;
    pieProgress: TPie;
    Pie1: TPie;
    Circle1: TCircle;
    pieAllProgress: TPie;
    lProgress: TLabel;
    lProgressName: TLabel;
    Layout10: TLayout;
    lUser: TLabel;
    tiScanBarCode: TTabItem;
    imgCameraScanBarCode: TImage;
    tiStopCamera: TTimer;
    sbIlluminationMode: TSpeedButton;
    Image9: TImage;
    ilPartners: TImageList;
    ilButton: TImageList;
    tiInventoryJournal: TTabItem;
    pPromoPartnerDate: TPanel;
    Label41: TLabel;
    deInventoryStartDate: TDateEdit;
    Label10: TLabel;
    deInventoryEntDate: TDateEdit;
    lwInventoryJournal: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    sbtiInventoryJournalRefresh: TSpeedButton;
    Image10: TImage;
    tiInventory: TTabItem;

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
    procedure ShowInventoryJournal;
    procedure ShowInventory;
    procedure bInfoClick(Sender: TObject);
    procedure sbScanClick(Sender: TObject);
    procedure OnScanResultDetails(Sender: TObject; AAction, ASource, ALabel_Type, AData_String: String);
    procedure OnScanResultLogin(Sender: TObject; AData_String: String);
    procedure bLogInClick(Sender: TObject);
    procedure bUpdateProgramClick(Sender: TObject);
    procedure CameraScanBarCodeSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure OnObrBarcodeDetected(Sender: TObject);
    procedure tiStopCameraTimer(Sender: TObject);
    procedure sbIlluminationModeClick(Sender: TObject);
    procedure bInventoryJournalClick(Sender: TObject);
    procedure sbtiInventoryJournalRefreshClick(Sender: TObject);
    procedure lwInventoryJournalItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    { Private declarations }
    FFormsStack: TStack<TFormStackItem>;
    FDataWedgeBarCode: TDataWedgeBarCode;
    FCameraScanBarCode: TCameraComponent;
    FObr: TFObr;
    FWebServer: string;
    FPermissionState: boolean;
    FisZebraScaner: boolean;
    FisCameraScanBarCode: boolean;
    FisBecomeForeground: Boolean;

    procedure SwitchToForm(const TabItem: TTabItem; const Data: TObject);
    procedure ReturnPriorForm(const OmitOnChange: Boolean = False);
    {$IFDEF ANDROID}
    function HandleAppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
    {$ENDIF}

    procedure Wait(AWait: Boolean);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses System.IOUtils, Authentication, Storage, CommonData, CursorUtils;

{$R *.fmx}

const
  WebServer = 'http://in.mer-lin.org.ua/projectboat_test/index.php';

// перевод формы в/из режим ожидания
procedure TfrmMain.Wait(AWait: Boolean);
begin
  LogInButton.Enabled := not AWait;
  LoginEdit.Enabled := not AWait;
  PasswordEdit.Enabled := not AWait;

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
  var aFMXApplicationEventService: IFMXApplicationEventService;
  {$ENDIF}
  SettingsFile : TIniFile;
begin

  //Application.OnIdle := MobileIdle;

  FormatSettings.DecimalSeparator := '.';
  FisBecomeForeground := False;

  FFormsStack := TStack<TFormStackItem>.Create;

  FDataWedgeBarCode := TDataWedgeBarCode.Create(Nil);

  // получение настроек из ini файла
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  FisZebraScaner := Pos('Zebra', JStringToString(TJBuild.JavaClass.MANUFACTURER)) > 0;
  SettingsFile := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'settings.ini'));
  {$ELSE}
  FisZebraScaner := False;
  SettingsFile := TIniFile.Create(TPath.Combine(ExtractFilePath(ParamStr(0)), 'settings.ini'));
  {$ENDIF}
  try
    LoginEdit.Text := SettingsFile.ReadString('LOGIN', 'USERNAME', '');
    FWebServer := SettingsFile.ReadString('LOGIN', 'WebServer', WebServer);
    FDataWedgeBarCode.isIllumination := SettingsFile.ReadBool('DataWedge', 'isIllumination', True);
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

  if not FisZebraScaner then
  begin
    //Распознавание штрих кода
    FObr := TFObr.Create(Nil);
    FObr.OnBarcodeDetected := OnObrBarcodeDetected;

    //Настройка камерЫ
    FCameraScanBarCode := TCameraComponent.Create(Nil);
    FCameraScanBarCode.OnSampleBufferReady := CameraScanBarCodeSampleBufferReady;
    FCameraScanBarCode.Quality := FMX.Media.TVideoCaptureQuality.MediumQuality;
    FCameraScanBarCode.Kind := FMX.Media.TCameraKind.BackCamera;
    FCameraScanBarCode.FocusMode := FMX.Media.TFocusMode.ContinuousAutoFocus;
  end else
  begin
    FDataWedgeBarCode.SetIllumination;
    if FDataWedgeBarCode.isIllumination then
      Image9.MultiResBitmap.Assign(ilButton.Source.Items[ilButton.Source.IndexOf('ic_flash_on')].MultiResBitmap)
    else Image9.MultiResBitmap.Assign(ilButton.Source.Items[ilButton.Source.IndexOf('ic_flash_off')].MultiResBitmap);
  end;

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

  if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService, IInterface(aFMXApplicationEventService)) then
     aFMXApplicationEventService.SetApplicationEventHandler(HandleAppEvent)
  {$ENDIF}
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FCameraScanBarCode.Free;
  FObr.Free;
  FDataWedgeBarCode.Free;
  FFormsStack.Free;
end;

{$IFDEF ANDROID}
function TfrmMain.HandleAppEvent(AAppEvent: TApplicationEvent;
  AContext: TObject): Boolean;
begin
  case AAppEvent of
    TApplicationEvent.WillBecomeForeground : if FisZebraScaner then FisBecomeForeground := True;
  end;
  Result := True;
end;
{$ENDIF}

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
procedure TfrmMain.CameraScanBarCodeSampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  if FCameraScanBarCode.Active and FObr.Active and FisCameraScanBarCode  then
  begin
    FCameraScanBarCode.SampleBufferToBitmap(imgCameraScanBarCode.Bitmap, True);
    FCameraScanBarCode.SampleBufferToBitmap(FObr.Picture, True);
    FObr.Scan;
  end;
end;

procedure TfrmMain.OnObrBarcodeDetected(Sender: TObject);
var
  Barcode: TObrSymbol;
  pOnScanResult: TDataWedgeBarCodeResult;
  pOnScanResultDetails: TDataWedgeBarCodeResultDetails;
begin
  if (FObr.BarcodeCount > 0) and FisCameraScanBarCode then
  begin
    FisCameraScanBarCode := False;
    Barcode := FObr.Barcode[0];

    pOnScanResultDetails := FDataWedgeBarCode.OnScanResultDetails;
    pOnScanResult := FDataWedgeBarCode.OnScanResult;

    sbBackClick(Sender);

    if Assigned(pOnScanResultDetails) then pOnScanResultDetails(Self, '',
                          'Camera', Barcode.SymbologyName, Barcode.DataUtf8);

    if Assigned(pOnScanResult) then pOnScanResult(Self, Barcode.DataUtf8);

    tiStopCamera.Enabled := True;
  end;
end;

procedure TfrmMain.ChangeMainPageUpdate(Sender: TObject);
begin
  if tcMain.ActiveTab <> tiScanBarCode then
  begin
    FDataWedgeBarCode.OnScanResultDetails := Nil;
    FDataWedgeBarCode.OnScanResult := Nil;
  end;
  if (tcMain.ActiveTab <> tiInformation) and (tcMain.ActiveTab <> tiScanBarCode) then lwBarCodeResult.Items.Clear;
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
    sbIlluminationMode.Visible := sbScan.Visible and FisZebraScaner;

    if tcMain.ActiveTab = tiMain then
      lCaption.Text := 'A g i l i s'
    else
    if tcMain.ActiveTab = tiInformation then
    begin
      lCaption.Text := 'Информация';
      FDataWedgeBarCode.OnScanResultDetails := OnScanResultDetails;
    end
    else if tcMain.ActiveTab = tiScanBarCode then
    begin
      lCaption.Text := 'Сканер штрихкода';
      tiStopCamera.Enabled := False;
      imgCameraScanBarCode.Bitmap.Assign(Nil);
      if Assigned(FCameraScanBarCode) then
      begin
        FObr.Active := True;
        FisCameraScanBarCode := True;
        FCameraScanBarCode.Active := True;
      end;
    end else
    if tcMain.ActiveTab = tiInventoryJournal then
    begin
      lCaption.Text := 'Журнал инвентаризаций';
    end else
    if tcMain.ActiveTab = tiInventory then
    begin
      lCaption.Text := 'Инвентаризация';
    end
  end;
end;

// начитка информации про программу
procedure TfrmMain.ShowInformation;
var
  Res : integer;
begin

  eMobileVersion.Text := DM.GetCurrentVersion;

  {$IFDEF ANDROID}
  eServerVersion.Text := DM.GetMobileVersion;
  Res := DM.CompareVersion(eMobileVersion.Text, eServerVersion.Text);
  {$ELSE}
  Res := 0;
  {$ENDIF}

  if Res > 0 then
  begin
    lServerVersion.Visible := true;

    {$IFDEF ANDROID}
    bUpdateProgram.Visible := true;
    {$ELSE}
    bUpdateProgram.Visible := false;
    {$ENDIF}
  end
  else
    lServerVersion.Visible := False;

  SwitchToForm(tiInformation, nil);
end;

// начитка информации журнала инвентаризаций
procedure TfrmMain.ShowInventoryJournal;
begin
  if not DM.LoadInventoryJournal then Exit;
  SwitchToForm(tiInventoryJournal, nil);
end;

// начитка информации журнала инвентаризаций
procedure TfrmMain.ShowInventory;
begin
  if not DM.cdsInventoryJournal.Active then Exit;
  if DM.cdsInventoryJournal.IsEmpty then Exit;
  if DM.cdsInventoryJournalId.AsInteger = 0 then Exit;

  // if not DM.LoadInventory then Exit;
  SwitchToForm(tiInventory, nil);
end;

procedure TfrmMain.tiStopCameraTimer(Sender: TObject);
begin
  tiStopCamera.Enabled := False;
  if Assigned(FCameraScanBarCode) then
  begin
    FCameraScanBarCode.Active := false;
    FObr.Active := False;
  end;
end;

// переход на форму журнала инвентаризаций
procedure TfrmMain.bInventoryJournalClick(Sender: TObject);
begin
  ShowInventoryJournal;
end;

// переход на форму отображения информации
procedure TfrmMain.bInfoClick(Sender: TObject);
begin
  ShowInformation;
end;

// возврат на форму логина
procedure TfrmMain.bLogInClick(Sender: TObject);
begin
  FDataWedgeBarCode.OnScanResult := OnScanResultLogin;
   sbScanClick(Sender);
end;

procedure TfrmMain.bReloginClick(Sender: TObject);
begin
  ReturnPriorForm;
end;

procedure TfrmMain.bUpdateProgramClick(Sender: TObject);
begin
  DM.UpdateProgram(mrYes);
end;

procedure TfrmMain.OnCloseDialog(const AResult: TModalResult);
begin
  if AResult = mrOK then
    Close;
end;

// обработка нажатия кнопки возврата на предидущую форму
procedure TfrmMain.sbBackClick(Sender: TObject);
//var
//  Mes : string;
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

procedure TfrmMain.sbIlluminationModeClick(Sender: TObject);
  var SettingsFile : TIniFile;
begin
  FDataWedgeBarCode.isIllumination := not FDataWedgeBarCode.isIllumination;
  if FisZebraScaner then FDataWedgeBarCode.SetIllumination;
  if FDataWedgeBarCode.isIllumination then
    Image9.MultiResBitmap.Assign(ilButton.Source.Items[ilButton.Source.IndexOf('ic_flash_on')].MultiResBitmap)
  else Image9.MultiResBitmap.Assign(ilButton.Source.Items[ilButton.Source.IndexOf('ic_flash_off')].MultiResBitmap);

  // сохранение подсветки в ini файле
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  SettingsFile := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'settings.ini'));
  {$ELSE}
  SettingsFile := TIniFile.Create(TPath.Combine(ExtractFilePath(ParamStr(0)), 'settings.ini'));
  {$ENDIF}
  try
    SettingsFile.WriteBool('DataWedge', 'isIllumination', FDataWedgeBarCode.isIllumination);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.sbScanClick(Sender: TObject);
begin
  if FisBecomeForeground and FisZebraScaner then
  begin
    Sleep(500);
    FDataWedgeBarCode.SetIllumination;
    if FDataWedgeBarCode.isIllumination then
      Image9.MultiResBitmap.Assign(ilButton.Source.Items[ilButton.Source.IndexOf('ic_flash_on')].MultiResBitmap)
    else Image9.MultiResBitmap.Assign(ilButton.Source.Items[ilButton.Source.IndexOf('ic_flash_off')].MultiResBitmap);
    FisBecomeForeground := False;
  end;

  if FisZebraScaner then FDataWedgeBarCode.Scan
  else SwitchToForm(tiScanBarCode, nil);
end;

// Перерисовка журнала инвентаризаций
procedure TfrmMain.sbtiInventoryJournalRefreshClick(Sender: TObject);
begin
  DM.LoadInventoryJournal;
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

      if pProgress.Visible then
        exit
      else
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
  deInventoryStartDate.DateTime := IncDay(Date, -7);
  deInventoryEntDate.DateTime := Date();

  SwitchToForm(tiStart, nil);
  ChangeMainPageUpdate(nil);
end;

procedure TfrmMain.LogInButtonClick(Sender: TObject);
var
  ErrorMessage: String;
  SettingsFile : TIniFile;
begin

  if not FPermissionState then
  begin
    ShowMessage('Необходимые разрешения не предоставлены');
    exit;
  end;

  if gc_WebService = '' then gc_WebService := FWebServer;

  Wait(True);
  try

    if TButton(Sender).Tag = 1 then
    begin
      FDataWedgeBarCode.OnScanResult := OnScanResultLogin;
      sbScanClick(Sender);
      Wait(False);
      Exit;
    end else ErrorMessage := TAuthentication.CheckLogin(TStorageFactory.GetStorage, LoginEdit.Text, PasswordEdit.Text, gc_User);

    if Assigned(gc_User) then lUser.Text := gc_User.Login;

    Wait(False);

    if ErrorMessage <> '' then
    begin
      ShowMessage(ErrorMessage);
      exit;
    end;
  except on E: Exception do
    begin
      Wait(False);

      ShowMessage('Нет связи с сервером. Продолжение работы невозможно'+#13#10 + E.Message);
    end;
    //
  end;

  {$IFDEF ANDROID}
  DM.CheckUpdate; // проверка небходимости обновления
  {$ENDIF}

  // сохранение логина и веб сервера в ini файле
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  SettingsFile := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'settings.ini'));
  {$ELSE}
  SettingsFile := TIniFile.Create(TPath.Combine(ExtractFilePath(ParamStr(0)), 'settings.ini'));
  {$ENDIF}
  try
    SettingsFile.WriteString('LOGIN', 'USERNAME', LoginEdit.Text);
  finally
    FreeAndNil(SettingsFile);
  end;

  SwitchToForm(tiMain, nil);
end;

// Покажим инвентаризацию
procedure TfrmMain.lwInventoryJournalItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if Assigned(ItemObject) and (ItemObject.Name = 'EditButton') then ShowInventory;
end;

procedure TfrmMain.OnScanResultDetails(Sender: TObject; AAction, ASource, ALabel_Type, AData_String: String);
begin
  with TListViewItem(TAppearanceListViewItems(lwBarCodeResult.Items.AddItem(0))) do
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

procedure TfrmMain.OnScanResultLogin(Sender: TObject; AData_String: String);
var
  ErrorMessage, Password: String;
  I, J : Integer;
begin

  FDataWedgeBarCode.OnScanResult := Nil;

  try

    Password := '';
    for I := 1 to Length(AData_String) do
      if TryStrToInt(COPY(AData_String, I, 1), J) then Password := Password + COPY(AData_String, I, 1);

    Wait(True);
    try
      lUser.Text := '';
      ErrorMessage := TAuthentication.CheckLoginCode(TStorageFactory.GetStorage, Password, gc_User);
      if Assigned(gc_User) then lUser.Text := gc_User.Login;

      Wait(False);

      if ErrorMessage <> '' then
      begin
        ShowMessage(ErrorMessage);
        exit;
      end;
    except on E: Exception do
      begin
        Wait(False);
        ErrorMessage := 'Нет связи с сервером. Продолжение работы невозможно';
        ShowMessage(ErrorMessage+#13#10 + E.Message);
        exit;
      end;
      //
    end;

    {$IFDEF ANDROID}
    DM.CheckUpdate; // проверка небходимости обновления
    {$ENDIF}

  finally
    if (ErrorMessage <> '') and (tcMain.ActiveTab <> tiStart) then
      ReturnPriorForm
    else if (ErrorMessage = '') and (tcMain.ActiveTab = tiStart) then SwitchToForm(tiMain, nil);
  end;
end;

end.
