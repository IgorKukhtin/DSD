unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.DateUtils, Data.DB,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, FMX.Objects, FMX.Edit,
  System.Generics.Collections, System.Actions, FMX.ActnList, FMX.Platform,
  System.IniFiles, FMX.VirtualKeyboard, FMX.DialogService, FMX.DataWedgeBarCode,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, uDM, FMX.Media,  Winsoft.FireMonkey.Obr, System.ImageList, FMX.ImgList,
  FMX.DateTimeCtrls, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  FMX.ListBox
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
    bSend: TButton;
    Image2: TImage;
    Label5: TLabel;
    bProductionUnion: TButton;
    Image4: TImage;
    lProductionUnion: TLabel;
    bUpload: TButton;
    Image6: TImage;
    Label7: TLabel;
    bLogIn: TButton;
    Image3: TImage;
    Label8: TLabel;
    bInfo: TButton;
    Image5: TImage;
    Label6: TLabel;
    bGoods: TButton;
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
    pInventoryJournal: TPanel;
    Label41: TLabel;
    deInventoryStartDate: TDateEdit;
    Label10: TLabel;
    deInventoryEntDate: TDateEdit;
    lwInventoryJournal: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    bInventoryJournalRefresh: TSpeedButton;
    Image10: TImage;
    tiInventory: TTabItem;
    Panel2: TPanel;
    Label11: TLabel;
    sbInventoryRefresh: TSpeedButton;
    Image11: TImage;
    edInventoryInvNumber: TEdit;
    edInventoryStatus: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    edInventoryUnit: TEdit;
    edInventoryComment: TEdit;
    edInventoryOperDate: TEdit;
    sbInventoryScan: TSpeedButton;
    Image12: TImage;
    imInventoryStatus: TImage;
    BindSourceDB2: TBindSourceDB;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    lwInventoryList: TListView;
    BindSourceDB3: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    LinkListControlToField2: TLinkListControlToField;
    tiInventoryScan: TTabItem;
    tiGoods: TTabItem;
    pGoods: TPanel;
    lwGoods: TListView;
    BindSourceDB4: TBindSourceDB;
    LinkListControlToField3: TLinkListControlToField;
    bGoodsChoice: TSpeedButton;
    Image13: TImage;
    bGoodsRefresh: TSpeedButton;
    Image14: TImage;
    Panel3: TPanel;
    Label14: TLabel;
    Label16: TLabel;
    edInventScanBarCode: TEdit;
    edInventScanPartNumber: TEdit;
    Label15: TLabel;
    edInventScanАmount: TEdit;
    Image15: TImage;
    bInventScanSearch: TSpeedButton;
    Image16: TImage;
    lwInventoryScan: TListView;
    bInventScanOk: TEditButton;
    BindSourceDB5: TBindSourceDB;
    LinkListControlToField4: TLinkListControlToField;
    ppEnterAmount: TPopup;
    pEnterAmount: TPanel;
    lAmount: TLabel;
    b7: TButton;
    b8: TButton;
    b9: TButton;
    b4: TButton;
    b5: TButton;
    b6: TButton;
    b1: TButton;
    b2: TButton;
    b3: TButton;
    b0: TButton;
    bDot: TButton;
    bEnterAmount: TButton;
    bAddAmount: TButton;
    bClearAmount: TButton;
    lMeasure: TLabel;
    bMinusAmount: TButton;
    tiProductionUnion: TTabItem;
    Panel4: TPanel;
    Edit1: TEdit;
    EditButton1: TEditButton;
    Image17: TImage;
    Label17: TLabel;
    ppInventScan: TPopup;
    pInventScan: TPanel;
    RadioButtonInvScan1: TRadioButton;
    RadioButtonInvScan2: TRadioButton;
    RadioButtonInvScan3: TRadioButton;
    RadioButtonInvScan4: TRadioButton;
    lGoodsSelect: TLabel;
    bppInventScanClose: TSpeedButton;
    Image20: TImage;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;

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
    procedure ShowGoods;
    procedure ShowProductionUnion;
    procedure ShowInventoryJournal;
    procedure ShowInventory;
    procedure ShowInventoryScan;
    procedure bInfoClick(Sender: TObject);
    procedure sbScanClick(Sender: TObject);
    procedure OnScanResultDetails(Sender: TObject; AAction, ASource, ALabel_Type, AData_String: String);
    procedure OnScanResultLogin(Sender: TObject; AData_String: String);
    procedure OnScanResultGoods(Sender: TObject; AData_String: String);
    procedure OnScanResultInventoryScan(Sender: TObject; AData_String: String);
    procedure OnScanProductionUnion(Sender: TObject; AData_String: String);
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
    procedure sbInventoryRefreshClick(Sender: TObject);
    procedure sbInventoryScanClick(Sender: TObject);
    procedure bGoodsClick(Sender: TObject);
    procedure bGoodsRefreshClick(Sender: TObject);
    procedure bGoodsChoiceClick(Sender: TObject);
    procedure bInventoryJournalRefreshClick(Sender: TObject);
    procedure bInventScanSearchClick(Sender: TObject);
    procedure edInventScanАmountChangeTracking(Sender: TObject);
    procedure bInventScanOkClick(Sender: TObject);
    procedure lwInventoryScanItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure SetDateDownloadGoods(Values : TDateTime);
    procedure b0Click(Sender: TObject);
    procedure bDotClick(Sender: TObject);
    procedure bClearAmountClick(Sender: TObject);
    procedure bEnterAmountClick(Sender: TObject);
    procedure bAddAmountClick(Sender: TObject);
    procedure bMinusAmountClick(Sender: TObject);
    procedure bUploadClick(Sender: TObject);
    procedure bProductionUnionClick(Sender: TObject);
    procedure RadioButtonInvScan4Click(Sender: TObject);
    procedure lwGoodsSearchChange(Sender: TObject);
    procedure lwGoodsChange(Sender: TObject);
    procedure cbSearchTypeGoodsChange(Sender: TObject);
    procedure ppInventScanClosePopup(Sender: TObject);
    procedure bppInventScanCloseClick(Sender: TObject);
  private
    { Private declarations }
    FFormsStack: TStack<TFormStackItem>;
    FDataWedgeBarCode: TDataWedgeBarCode;
    FCameraScanBarCode: TCameraComponent;
    FObr: TFObr;
    FWebServer: string;
    FINIFile: string;
    FPermissionState: boolean;
    FisZebraScaner: boolean;
    FisCameraScanBarCode: boolean;
    FisBecomeForeground: Boolean;
    FDateDownloadGoods: TDateTime;

    procedure SwitchToForm(const TabItem: TTabItem; const Data: TObject);
    procedure ReturnPriorForm(const OmitOnChange: Boolean = False);
    procedure DeleteInventoryGoods(const AResult: TModalResult);
    procedure BackInventoryScan(const AResult: TModalResult);
    procedure DownloadGoods(const AResult: TModalResult);
    procedure UploadAllData(const AResult: TModalResult);
    procedure CreateInventory(const AResult: TModalResult);
    procedure ShowppInventScan;

    {$IFDEF ANDROID}
    function HandleAppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
    {$ENDIF}

    procedure Wait(AWait: Boolean);
  public
    { Public declarations }
    property DateDownloadGoods: TDateTime read FDateDownloadGoods write SetDateDownloadGoods;
  end;

var
  frmMain: TfrmMain;

implementation

uses System.IOUtils, FMX.SearchBox, Authentication, Storage, CommonData, CursorUtils;

{$R *.fmx}

const
  WebServer = 'http://in.mer-lin.org.ua/projectboat_test/index.php';

function SearshBox(AListView: TListView): TSearchBox;
var
  AIdx: Integer;
begin
  Result := Nil;
  for AIdx := 0 to AListView.ComponentCount - 1 do
    if AListView.Components[AIdx] is TSearchBox then
    begin
      Result := TSearchBox(AListView.Components[AIdx]);
      Break;
    end;
end;

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

  SearshBox(lwGoods).OnChangeTracking := lwGoodsChange;


  FFormsStack := TStack<TFormStackItem>.Create;

  FDataWedgeBarCode := TDataWedgeBarCode.Create(Nil);

  // получение настроек из ini файла
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  FisZebraScaner := Pos('Zebra', JStringToString(TJBuild.JavaClass.MANUFACTURER)) > 0;
  FINIFile := TPath.Combine(TPath.GetDocumentsPath, 'settings.ini');
  {$ELSE}
  FisZebraScaner := False;
  FINIFile := TPath.Combine(ExtractFilePath(ParamStr(0)), 'settings.ini');
  {$ENDIF}

  SettingsFile := TIniFile.Create(FINIFile);
  try
    LoginEdit.Text := SettingsFile.ReadString('LOGIN', 'USERNAME', '');
    FWebServer := SettingsFile.ReadString('LOGIN', 'WebServer', WebServer);
    FDataWedgeBarCode.isIllumination := SettingsFile.ReadBool('DataWedge', 'isIllumination', True);
    FDateDownloadGoods := SettingsFile.ReadDateTime('Params', 'DateDownloadGoods', IncDay(Now, - 2));
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

procedure TfrmMain.SetDateDownloadGoods(Values : TDateTime);
  var SettingsFile : TIniFile;
begin
  // Сохраним в ini файла
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FDateDownloadGoods := Values;
    SettingsFile.WriteDateTime('Params', 'DateDownloadGoods', FDateDownloadGoods);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.bDotClick(Sender: TObject);
begin
  if lAmount.Text = '' then
    lAmount.Text := '0.'
  else
  if pos('.', lAmount.Text) = 0 then
    lAmount.Text := lAmount.Text + TButton(Sender).Text;
end;

// ввод числа (для редактирования количества товара)
procedure TfrmMain.b0Click(Sender: TObject);
begin
  if lAmount.Text = '0' then
    lAmount.Text := '';

  lAmount.Text := lAmount.Text + TButton(Sender).Text;
end;

// очистка количества товаров
procedure TfrmMain.bClearAmountClick(Sender: TObject);
begin
  lAmount.Text := '0';
end;

procedure TfrmMain.bAddAmountClick(Sender: TObject);
begin
  if tcMain.ActiveTab = tiInventoryScan then
  begin
    DM.cdsInventoryGoods.Edit;
    DM.cdsInventoryGoodsAmount.AsFloat := DM.cdsInventoryGoodsAmount.AsFloat + StrToFloatDef(lAmount.Text, 0);
    DM.cdsInventoryGoods.Post;
    DM.SaveInventoryGoods;
  end;

  ppEnterAmount.IsOpen := false;
end;

// отнимание количества товаров от введенных ранее
procedure TfrmMain.bMinusAmountClick(Sender: TObject);
begin
  if tcMain.ActiveTab = tiInventoryScan then
  begin
    DM.cdsInventoryGoods.Edit;
    DM.cdsInventoryGoodsAmount.AsFloat := DM.cdsInventoryGoodsAmount.AsFloat - StrToFloatDef(lAmount.Text, 0);
    DM.cdsInventoryGoods.Post;
    DM.SaveInventoryGoods;
  end;

  ppEnterAmount.IsOpen := false;
end;

// Сборка Узла / Лодки
procedure TfrmMain.bProductionUnionClick(Sender: TObject);
begin
  ShowProductionUnion;
end;

// присвоение количества товаров
procedure TfrmMain.bEnterAmountClick(Sender: TObject);
begin
  if tcMain.ActiveTab = tiInventoryScan then
  begin
    DM.cdsInventoryGoods.Edit;
    DM.cdsInventoryGoodsAmount.AsFloat := StrToFloatDef(lAmount.Text, 0);
    DM.cdsInventoryGoods.Post;
    DM.SaveInventoryGoods;
  end;

  ppEnterAmount.IsOpen := false;
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

procedure TfrmMain.bppInventScanCloseClick(Sender: TObject);
begin
  ppInventScan.IsOpen := false;
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

procedure TfrmMain.RadioButtonInvScan4Click(Sender: TObject);
begin
  If Not (Sender is TRadioButton) Then // Защитимся от не выспавшегося самого себя
    Exit;
  RadioButtonInvScan1.IsChecked := TRadioButton(Sender).Tag = 0;
  RadioButtonInvScan2.IsChecked := TRadioButton(Sender).Tag = 1;
  RadioButtonInvScan3.IsChecked := TRadioButton(Sender).Tag = 2;
  RadioButtonInvScan4.IsChecked := TRadioButton(Sender).Tag = 3;
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

procedure TfrmMain.cbSearchTypeGoodsChange(Sender: TObject);
begin
  ShowGoods;
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

  bGoodsChoice.Visible := False;

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
      DM.cdsGoods.Close;
    end
    else
    begin
      imLogo.Visible := false;
      sbBack.Visible := true;
    end;

    if (tcMain.ActiveTab = tiInformation) or (tcMain.ActiveTab = tiInventoryScan) or (tcMain.ActiveTab = tiGoods) or (tcMain.ActiveTab = tiProductionUnion)  then
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
    else
    if tcMain.ActiveTab = tiGoods then
    begin
      lCaption.Text := 'Комплектующие';
      bGoodsChoice.Visible := False;
      FDataWedgeBarCode.OnScanResult := OnScanResultGoods;
    end
    else
    if tcMain.ActiveTab = tiScanBarCode then
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
    end else
    if tcMain.ActiveTab = tiInventoryScan then
    begin
      lCaption.Text := 'Вставка товара в инвентаризацию';
      DM.InitInventoryGoods;
      FDataWedgeBarCode.OnScanResult := OnScanResultInventoryScan;
    end
    else
    if tcMain.ActiveTab = tiProductionUnion then
    begin
      lCaption.Text := 'Сборка Узла / Лодки';
      bGoodsChoice.Visible := False;
      FDataWedgeBarCode.OnScanResult := OnScanProductionUnion;
    end
  end;
end;

// Ввод только числа
procedure TfrmMain.edInventScanАmountChangeTracking(Sender: TObject);
Var FEdit : TEdit;
    FFloat : Single;
begin
  If Not (Sender is TEdit) Then // Защитимся от не выспавшегося самого себя
    Exit;
  FEdit:=(Sender as TEdit); // Для удобства...
  FEdit.Text:=FEdit.Text.Replace(' ',''); // Убираем случайные пробелы
  if (FEdit.Text.IsEmpty) or (FEdit.Text.Equals('-')) then // Если пусто (ничего не введено или все удалено) или только минус, ничего не делаем
    Exit;
  if FormatSettings.DecimalSeparator = '.' then
    FEdit.Text:=FEdit.Text.Replace(',', FormatSettings.DecimalSeparator) // Заменяйм запятую на системный разделитель
  else FEdit.Text:=FEdit.Text.Replace('.', FormatSettings.DecimalSeparator); // Заменяйм точку на системный разделитель
  if FEdit.Text.Equals(FormatSettings.DecimalSeparator) then // Если введен разделитель, добавляем перед ним ноль для красоты (не обязательно)
  begin
    FEdit.Text:='0,';
    FEdit.CaretPosition:=FEdit.CaretPosition+1; // без этого курсор останется между нулём и запятой
  end;
  if (Pos(FormatSettings.DecimalSeparator, FEdit.Text) > 0) and
     (Length(Copy(FEdit.Text,  Pos(FormatSettings.DecimalSeparator, FEdit.Text) + 1, Length(FEdit.Text))) > 4) then
    FEdit.Text:=FEdit.TagString // Если много знаков после запятой, восстанавливаем из временного хранилища
  else if TryStrToFloat(FEdit.Text,FFloat) Then // Пробуем преобразовать в число
    FEdit.TagString:=FEdit.Text // Если удалось, сохраняем в временном хранилище
  Else
    FEdit.Text:=FEdit.TagString; // Если не удалось, восстанавливаем из временного хранилища
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

procedure TfrmMain.lwGoodsChange(Sender: TObject);
begin
  DM.FilterGoods := TSearchBox(Sender).Text;
  DM.LoadGoodsList;
end;

// начитка информации справочника товаров
procedure TfrmMain.ShowGoods;
begin
  DM.FilterGoods := SearshBox(lwGoods).Text;
  DM.LoadGoodsList;
  if tcMain.ActiveTab <> tiGoods then SwitchToForm(tiGoods, nil);
end;

// начитка информации журнала инвентаризаций
procedure TfrmMain.ShowInventoryJournal;
begin
  if DM.GetInventoryActive(False) then
  begin
    SwitchToForm(tiInventoryScan, nil);
  end else TDialogService.MessageDialog('Инвентаризация по "Складу основному" не найдена.'#13#13'Создать ?',
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, CreateInventory);

//  if not DM.DownloadInventoryJournal then Exit;
//  SwitchToForm(tiInventoryJournal, nil);
end;

// Сборка Узла / Лодки
procedure TfrmMain.ShowProductionUnion;
begin
  SwitchToForm(tiProductionUnion, nil);
end;

// начитка информации журнала инвентаризаций
procedure TfrmMain.ShowInventory;
begin
  if not DM.cdsInventoryJournal.Active then Exit;
  if DM.cdsInventoryJournal.IsEmpty then Exit;
  if DM.cdsInventoryJournalId.AsInteger = 0 then Exit;

  if not DM.DownloadInventory then Exit;
  imInventoryStatus.MultiResBitmap.Assign(ilPartners.Source.Items[DM.cdsInventoryJournalStatusId.AsInteger].MultiResBitmap);

  if not DM.DownloadInventoryList then Exit;

  if tcMain.ActiveTab <> tiInventory then SwitchToForm(tiInventory, nil);
end;


// начитка информации для сканирования
procedure TfrmMain.ShowInventoryScan;
begin
  if not DM.cdsInventory.Active then Exit;
  if DM.cdsInventory.IsEmpty then Exit;
  if DM.cdsInventoryId.AsInteger = 0 then Exit;

  if DM.cdsInventoryJournalStatusId.AsInteger <> 1 then
  begin
    ShowMessage('Добавлять товар в проведенную инвентаризацию запрещено.');
    Exit;
  end;

  imInventoryStatus.MultiResBitmap.Assign(ilPartners.Source.Items[DM.cdsInventoryJournalStatusId.AsInteger].MultiResBitmap);

  if not DM.cdsGoods.Active then DM.LoadGoods;

  SwitchToForm(tiInventoryScan, nil);
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

procedure TfrmMain.bInventoryJournalRefreshClick(Sender: TObject);
begin
  DM.DownloadInventoryJournal;
end;

procedure TfrmMain.ShowppInventScan;
begin
  sbScan.Enabled := False;
  sbBack.Enabled := False;
  Panel3.Enabled := False;
  lwInventoryScan.Enabled := False;
  ppInventScan.IsOpen := True;
end;

// Поиск товара для вставки в инвентаризацию по введеному коду
procedure TfrmMain.bInventScanOkClick(Sender: TObject);
  var Code: Integer;
begin

  if Length(edInventScanBarCode.Text) > 12 then
    edInventScanBarCode.Text := Copy(edInventScanBarCode.Text, 1, Length(edInventScanBarCode.Text) - 1);

  if edInventScanBarCode.Text = '' then Exit;
  if not DM.cdsGoods.Active then DM.LoadGoods;

  try
    try
      if COPY(edInventScanBarCode.Text, 1, 2) = '00' then
      begin
        if not TryStrToInt(edInventScanBarCode.Text, Code) then
        begin
          ShowMessage('Не правельный штрихкод ' + edInventScanBarCode.Text);
          Exit;
        end else DM.cdsGoods.Filter := 'Code = ' + IntToStr(Code);
      end else DM.cdsGoods.Filter := 'EAN LIKE ''' + edInventScanBarCode.Text + '%''';
      DM.cdsGoods.Filtered := True;
      if DM.cdsGoods.RecordCount = 1 then
      begin
        DM.AddInventoryGoods;
      end else if DM.cdsGoods.RecordCount > 1 then
      begin
        SearshBox(lwGoods).Text := edInventScanBarCode.Text;
        DM.FilterGoodsEAN := True;
        if RadioButtonInvScan1.IsChecked then
          bInventScanSearchClick(Sender)
        else ShowppInventScan;
        Exit;
      end else ShowMessage('Товар с штрихкодом ' + edInventScanBarCode.Text + ' не найден.');
    finally
      DM.cdsGoods.Filtered := False;
      DM.cdsGoods.Filter := '';
    end;
  finally
    if not ppInventScan.IsOpen then edInventScanBarCode.Text := '';
  end;
end;

// Поиск товара для вставки в инвентаризацию
procedure TfrmMain.bInventScanSearchClick(Sender: TObject);
begin
  ShowGoods;
  bGoodsChoice.Visible := True;
end;

// Выбор товара
procedure TfrmMain.bGoodsChoiceClick(Sender: TObject);
begin
  DM.FilterGoodsEAN := False;
  if lwGoods.ItemCount = 0 then Exit;

  ReturnPriorForm;
  if (tcMain.ActiveTab = tiInventoryScan)  then
  begin
    if RadioButtonInvScan1.IsChecked then
    begin
      DM.AddInventoryGoods(True);
    end else ShowppInventScan;
  end;
end;

// переход на форму справочника товаров
procedure TfrmMain.bGoodsClick(Sender: TObject);
begin
  SearshBox(lwGoods).Text := '';
  ShowGoods;
end;

// перечитать товар
procedure TfrmMain.bGoodsRefreshClick(Sender: TObject);
begin
  TDialogService.MessageDialog('Загрузить справочник Комплектующих?',
       TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DownloadGoods)
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

procedure TfrmMain.bUploadClick(Sender: TObject);
begin
  if not DM.isInventoryGoodsSend then
    TDialogService.MessageDialog('Отправить все несохраненные данные?',
       TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, UploadAllData)
  else ShowMessage('Нет данных для отправки.');
end;

procedure TfrmMain.OnCloseDialog(const AResult: TModalResult);
begin
  if AResult = mrOK then
    Close;
end;

// обработка нажатия кнопки возврата на предидущую форму
procedure TfrmMain.sbBackClick(Sender: TObject);
begin
  if (tcMain.ActiveTab = tiGoods)  then
  begin
    DM.FilterGoodsEAN := False;
  end else if (tcMain.ActiveTab = tiInventoryJournal)  then
  begin
    DM.cdsInventoryJournal.Close;
  end
  else if (tcMain.ActiveTab = tiInventory)  then
  begin
    DM.cdsInventory.Close;
    DM.cdsInventoryList.Close;
  end
  else if (tcMain.ActiveTab = tiInventoryScan)  then
  begin
    if DM.cdsInventoryGoods.RecordCount > 0 then
    begin
      TDialogService.MessageDialog('Отправить введенные в инвентаризацию дааные на сервер?', TMsgDlgType.mtWarning,
        [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, BackInventoryScan);
    end;

    DM.cdsInventoryGoods.Close;
    DM.cdsGoods.Close;
  end;

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
  SettingsFile := TIniFile.Create(FINIFile);
  try
    SettingsFile.WriteBool('DataWedge', 'isIllumination', FDataWedgeBarCode.isIllumination);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.sbInventoryRefreshClick(Sender: TObject);
begin
  ShowInventory;
end;

//
procedure TfrmMain.sbInventoryScanClick(Sender: TObject);
begin
  ShowInventoryScan;
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
  DM.DownloadInventoryJournal;
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
      if ppEnterAmount.IsOpen then
        ppEnterAmount.IsOpen := false
      else
      if ppInventScan.IsOpen then
        ppInventScan.IsOpen := false
      else
      if tcMain.ActiveTab = tiStart then
        TDialogService.MessageDialog('Закрыть программу?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], TMsgDlgBtn.mbCancel, -1, OnCloseDialog)
      else
      if tcMain.ActiveTab = tiMain then
        bReloginClick(bRelogin)
      else
        sbBackClick(sbBack);
    end;
  end;
end;

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
  SettingsFile := TIniFile.Create(FINIFile);
  try
    SettingsFile.WriteString('LOGIN', 'USERNAME', LoginEdit.Text);
  finally
    FreeAndNil(SettingsFile);
  end;

  SwitchToForm(tiMain, nil);
end;

procedure TfrmMain.lwGoodsSearchChange(Sender: TObject);
begin
end;

// Покажим инвентаризацию
procedure TfrmMain.lwInventoryJournalItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if Assigned(ItemObject) and (ItemObject.Name = 'EditButton') then ShowInventory;
end;

procedure TfrmMain.BackInventoryScan(const AResult: TModalResult);
begin
  if AResult = mrYes then DM.UploadInventoryGoods;
end;

procedure TfrmMain.DeleteInventoryGoods(const AResult: TModalResult);
begin
  if AResult = mrYes then DM.DeleteInventoryGoods;
end;

procedure TfrmMain.DownloadGoods(const AResult: TModalResult);
begin
  if AResult = mrYes then DM.DownloadGoods;
end;

procedure TfrmMain.UploadAllData(const AResult: TModalResult);
begin
  if AResult = mrYes then DM.UploadAllData;
end;

procedure TfrmMain.CreateInventory(const AResult: TModalResult);
begin
  if AResult = mrYes then if DM.GetInventoryActive(True) then
    SwitchToForm(tiInventoryScan, nil);
end;

procedure TfrmMain.lwInventoryScanItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if Assigned(ItemObject) and (ItemObject.Name = 'DeleteButton') then
    TDialogService.MessageDialog('Удалить товар "' + DM.cdsInventoryGoodsGoodsName.AsString +
         '" подготовленный к вставке в инвентаризацию ?',
         TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteInventoryGoods)
  else
  // вызов формы для редактирования количества выбранного товара
  if Assigned(ItemObject) and ((ItemObject.Name = 'Amount') or (ItemObject.Name = 'MeasureName')) and
     not DM.cdsInventoryGoods.IsEmpty and (DM.cdsInventoryGoodsisSend.AsBoolean = False) then
  begin
    lAmount.Text := '0';
    lMeasure.Text := DM.cdsInventoryGoodsMeasureName.AsString;

    ppEnterAmount.IsOpen := true;
  end;

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

procedure TfrmMain.ppInventScanClosePopup(Sender: TObject);
begin
  sbScan.Enabled := True;
  sbBack.Enabled := True;
  Panel3.Enabled := True;
  lwInventoryScan.Enabled := True;
end;

procedure TfrmMain.OnScanResultGoods(Sender: TObject; AData_String: String);
begin
  SearshBox(lwGoods).Text := Copy(AData_String, 1, Length(AData_String) - 1);
end;

// Обрабатываем отсканированный товар для инвентаризации
procedure TfrmMain.OnScanResultInventoryScan(Sender: TObject; AData_String: String);
begin

  edInventScanBarCode.Text := AData_String;

  bInventScanOkClick(Sender);
end;

// Обрабатываем отсканированный товар для производства
procedure TfrmMain.OnScanProductionUnion(Sender: TObject; AData_String: String);
begin

//
end;

end.
