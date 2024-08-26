unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.DateUtils, System.Threading, Data.DB,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, FMX.Objects, FMX.Edit,
  System.Generics.Collections, System.Actions, FMX.ActnList, FMX.Platform,
  System.IniFiles, FMX.VirtualKeyboard, FMX.DialogService, FMX.DataWedgeBarCode,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Media,  Winsoft.FireMonkey.Obr, System.ImageList, FMX.ImgList,
  FMX.DateTimeCtrls, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  FMX.ListBox, FMX.ExtCtrls, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, System.StrUtils
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
    sbClose: TSpeedButton;
    Image7: TImage;
    sbMain: TStyleBook;
    VertScrollBox8: TVertScrollBox;
    GridPanelLayout3: TGridPanelLayout;
    bInventoryScan: TButton;
    Image1: TImage;
    Label1: TLabel;
    bSendScan: TButton;
    Image2: TImage;
    Label5: TLabel;
    bProductionUnionScan: TButton;
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
    sbIlluminationMode: TSpeedButton;
    imgIlluminationMode: TImage;
    ilPartners: TImageList;
    ilButton: TImageList;
    BindingsList1: TBindingsList;
    BindSourceDB2: TBindSourceDB;
    BindSourceDB3: TBindSourceDB;
    BindSourceDB4: TBindSourceDB;
    BindSourceDB5: TBindSourceDB;
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
    tiProductionUnionEdit: TTabItem;
    pPassword: TPanel;
    Rectangle1: TRectangle;
    pOrderInternal: TPanel;
    Label20: TLabel;
    edPUInvNumberFull: TEdit;
    edPUInvNumberFull_OrderClient: TEdit;
    Label21: TLabel;
    edPUAmount: TEdit;
    Label23: TLabel;
    edPUInvNumberFull_ProductionUnion: TEdit;
    Label24: TLabel;
    BindSourceDB7: TBindSourceDB;
    BindSourceDB8: TBindSourceDB;
    lMain: TLayout;
    lAddConfig: TLayout;
    Label34: TLabel;
    ppActions: TPopup;
    RectangleActions: TRectangle;
    rbWebServerTest: TRadioButton;
    rbWebServerMain: TRadioButton;
    TimerRefresh: TTimer;
    ppInfoView: TPopup;
    Rectangle3: TRectangle;
    lInfoView: TLabel;
    TimerInfoView: TTimer;
    ppWebServer: TPopup;
    btaEditRecord: TButton;
    btaErrorInfo: TButton;
    btaEraseRecord: TButton;
    btaInsertRecord: TButton;
    btaOk: TButton;
    btaClose: TButton;
    btaUnEraseRecord: TButton;
    btaCancel: TButton;
    lUseCamera: TLayout;
    Label10: TLabel;
    rbBarcodeScaner: TRadioButton;
    rbCameraScaner: TRadioButton;
    cbOpenScanChangingMode: TCheckBox;
    cbHideScanButton: TCheckBox;
    cblluminationMode: TCheckBox;
    cbHideIlluminationButton: TCheckBox;
    Layout11: TLayout;
    sbRefresh: TSpeedButton;
    Image12: TImage;
    sbBack: TSpeedButton;
    Image9: TImage;
    Layout12: TLayout;
    Layout13: TLayout;
    BindSourceDB9: TBindSourceDB;
    BindSourceDB10: TBindSourceDB;
    BindSourceDB11: TBindSourceDB;
    tiProductionUnionScan: TTabItem;
    tiProductionUnionList: TTabItem;
    Panel10: TPanel;
    bProductionUnionScanSearch: TSpeedButton;
    bProductionUnionScanMode: TSpeedButton;
    bViewProductionUnion: TSpeedButton;
    bProductionUnionScanNull: TSpeedButton;
    SpeedButton7: TSpeedButton;
    lwProductionUnionScan: TListView;
    BindSourceDB12: TBindSourceDB;
    LinkListControlToField7: TLinkListControlToField;
    Panel11: TPanel;
    pbPULErased: TPopupBox;
    pbPULAllUser: TPopupBox;
    pbPULOrderBy: TPopupBox;
    llwProductionUnionList: TLabel;
    lwProductionUnionList: TListView;
    BindSourceDB13: TBindSourceDB;
    LinkListControlToField8: TLinkListControlToField;
    Label17: TLabel;
    edPUGoodsCode: TEdit;
    edPUGoodsName: TMemo;
    Label49: TLabel;
    edPUArticle: TEdit;
    Label50: TLabel;
    edPUGoodsGroupName: TEdit;
    Label22: TLabel;
    bpProductionUnionCancel: TButton;
    bpProductionUnion: TButton;
    edPUToName: TEdit;
    Label51: TLabel;
    edPUFromName: TEdit;
    Label52: TLabel;
    edPURemains: TEdit;
    Label53: TLabel;
    BindSourceDB14: TBindSourceDB;
    LinkControlToField8: TLinkControlToField;
    LinkControlToField34: TLinkControlToField;
    LinkControlToField35: TLinkControlToField;
    LinkControlToField36: TLinkControlToField;
    LinkControlToField37: TLinkControlToField;
    LinkControlToField9: TLinkControlToField;
    LinkControlToField38: TLinkControlToField;
    LinkControlToField39: TLinkControlToField;
    ScanCamera: TCameraComponent;
    LinkControlToField7: TLinkControlToField;
    LinkControlToField6: TLinkControlToField;
    LinkControlToField10: TLinkControlToField;
    TimerTorchMode: TTimer;
    PanelMain: TPanel;
    iScanBarCodePanel: TPanel;
    WebServerLayout11: TLayout;
    WebServerLabel: TLabel;
    WebServerLayout12: TLayout;
    pbWebServer: TPopupBox;

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
    procedure ShowProductionUnionScan;
    procedure ShowProductionUnionList;
    procedure ShowEditProductionUnionItem(AId: Integer);
    procedure bInfoClick(Sender: TObject);
    procedure sbScanClick(Sender: TObject);
    procedure OnScanResultDetails(Sender: TObject; AAction, ASource, ALabel_Type, AData_String: String);
    procedure OnScanResultLogin(Sender: TObject; AData_String: String);
    procedure OnScanProductionUnion(Sender: TObject; AData_String: String);
    procedure bLogInClick(Sender: TObject);
    procedure bUpdateProgramClick(Sender: TObject);
    procedure CameraScanBarCodeSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure OnObrBarcodeDetected(Sender: TObject);
    procedure sbIlluminationModeClick(Sender: TObject);
    procedure edАmountChangeTracking(Sender: TObject);
    procedure SetDateDownloadDict(Values : TDateTime);
    procedure SetBarCodePref(Values : String);
    procedure SetDocBarCodePref(Values : String);
    procedure SetItemBarCodePref(Values : String);
    procedure SetArticleSeparators(Values : String);

    procedure SetisCameraScaner(Values : boolean);
    procedure SetisOpenScanChangingMode(Values : boolean);
    procedure SetisHideIlluminationButton(Values : boolean);
    procedure SetisHideScanButton(Values : boolean);
    function GetisIlluminationMode : Boolean;
    procedure SetisIlluminationMode(Values : boolean);

    procedure b0Click(Sender: TObject);
    procedure bDotClick(Sender: TObject);
    procedure bClearAmountClick(Sender: TObject);
    procedure bEnterAmountClick(Sender: TObject);
    procedure bAddAmountClick(Sender: TObject);
    procedure bMinusAmountClick(Sender: TObject);
    procedure bpProductionUnionClick(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure btnCancelClick(Sender: TObject);
    procedure rbWebServerClick(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure TimerInfoViewTimer(Sender: TObject);
    procedure sbRefreshClick(Sender: TObject);
    procedure lwProductionUnionScanDblClick(Sender: TObject);
    procedure lwProductionUnionScanGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure bProductionUnionScanModeClick(Sender: TObject);
    procedure bViewProductionUnionClick(Sender: TObject);
    procedure lwProductionUnionListGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lwProductionUnionListDblClick(Sender: TObject);
    procedure bpProductionUnionCancelClick(Sender: TObject);
    procedure pbPULOrderByChange(Sender: TObject);
    procedure bProductionUnionScanSearchClick(Sender: TObject);
    procedure bOrderInternalChoiceClick(Sender: TObject);
    procedure TimerTorchModeTimer(Sender: TObject);
  private
    { Private declarations }
    {$IF DEFINED(iOS) or DEFINED(ANDROID)}
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    {$ENDIF}
    FFormsStack: TStack<TFormStackItem>;
    FDataWedgeBarCode: TDataWedgeBarCode;
    FPasswordLabelClick: Integer;
    FINIFile: string;
    FPermissionState: boolean;
    // Ксть сканер Zebra
    FisZebraScaner: boolean;
    // Использовать в любом случае камеру устройства
    FisCameraScaner: boolean;
    // Открывать сканер при изменении режима
    FisOpenScanChangingMode: boolean;
    // Скрывать кнопку подсветки
    FisHideIlluminationButton: boolean;
    // Скрывать кнопку сканирования когда есть боковые
    FisHideScanButton: boolean;

    // Обработка штрих кода камерой
    FisBecomeForeground: Boolean;
    FDateDownloadDict: TDateTime;

    // Вид сканирования
    FScanType : Integer;
    FisNextScan : Boolean;
    FisScanOk : Boolean;
    FGoodsId: Integer;

    FIsUpdate: Boolean;
    FOldControl: TControl;
    FCuurControl: TControl;

    // Настройки
    FBarCodePref: String;
    FDocBarCodePref: String;
    FItemBarCodePref: String;
    FArticleSeparators: String;
    FCaptionFontSize: Single;

    // предвдущая страница
    FActiveTabPrew: TTabItem;

    // Заказ производство
    FProductionUnion: Integer;

    {$IF DEFINED(iOS) or DEFINED(ANDROID)}
    procedure CalcContentBoundsProc(Sender: TObject;
                                    var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
    {$ENDIF}
    procedure SwitchToForm(const TabItem: TTabItem; const Data: TObject);
    procedure ReturnPriorForm(const OmitOnChange: Boolean = False);
    procedure ProductionUnionInsert(const AResult: TModalResult);
    procedure ProductionUnionOpen(const AResult: TModalResult);
    procedure DeleteProductionUnionGoods(const AResult: TModalResult);
    procedure ErasedProductionUnionList(const AResult: TModalResult);
    procedure UnErasedProductionUnionList(const AResult: TModalResult);
    procedure NoBarCodeNextScan(const AResult: TModalResult);

    {$IF DEFINED(ANDROID)}
    function HandleAppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
    {$ENDIF}

    procedure Wait(AWait: Boolean);
  public
    { Public declarations }
    procedure SetProductionUnionScanButton;

    procedure NextScan;

    property DateDownloadDict: TDateTime read FDateDownloadDict write SetDateDownloadDict;
    property BarCodePref: String read FBarCodePref write SetBarCodePref;
    property DocBarCodePref: String read FDocBarCodePref write SetDocBarCodePref;
    property ItemBarCodePref: String read FItemBarCodePref write SetItemBarCodePref;
    property ArticleSeparators: String read FArticleSeparators write SetArticleSeparators;

    // Использовать в любом случае камеру устройства
    property isCameraScaner: boolean read FisCameraScaner write SetisCameraScaner;
    // Открывать сканер при изменении режима
    property isOpenScanChangingMode: boolean read FisOpenScanChangingMode write SetisOpenScanChangingMode;
    // Скрывать кнопку подсветки
    property isHideIlluminationButton: boolean read FisHideIlluminationButton write SetisHideIlluminationButton;
    // Скрывать кнопку сканирования когда есть боковые
    property isHideScanButton: boolean read FisHideScanButton write SetisHideScanButton;
    // Поссветка включена при старте сканирования
    property isIlluminationMode: boolean read GetisIlluminationMode write SetisIlluminationMode;

  end;

var
  frmMain: TfrmMain;

implementation

uses System.IOUtils, System.Math, System.RegularExpressions, FMX.SearchBox, FMX.Authentication, FMX.Storage,
     FMX.CommonData, FMX.CursorUtils, uDM;

{$R *.fmx}

var  ScanThread: TThread;
     ScanDATA: String;
     ScanSymbologyName: String;

const
  WebServer : string = 'http://integer-srv.alan.dp.ua/index.php;http://integer-srv2.alan.dp.ua/index.php';
  MainWidth = 336;

type
  { Поток для обработки штрихкода }
  TScanThread = class(TThread)
  private
    { Private declarations }
    FObr: TFObr;
    procedure OnObrBarcodeDetected(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean); overload;
    destructor Destroy; override;
  end;

{ TScanThread }

constructor TScanThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := true;
  FObr := TFObr.Create(Nil);
  FObr.Active := True;
  FObr.OnBarcodeDetected := OnObrBarcodeDetected;
end;

destructor TScanThread.Destroy;
begin
  FObr.Active := False;
  FObr.Free;
  ScanThread := Nil;
  inherited Destroy;
end;

procedure TScanThread.Execute;
begin
  sleep(200);

  Synchronize(nil,
        procedure
        begin
          try
            FObr.Picture.Assign(frmMain.imgCameraScanBarCode.Bitmap);
          except
          end;
        end);

  FObr.Scan;
end;

procedure TScanThread.OnObrBarcodeDetected(Sender: TObject);
var
  Barcode: TObrSymbol;
begin
  try
    Barcode := FObr.Barcode[0];

    ScanDATA := Barcode.DataUtf8;
    ScanSymbologyName := Barcode.SymbologyName;

    if (POS('EAN', Barcode.SymbologyName) > 0) or (POS('UPCA', Barcode.SymbologyName) > 0) then ScanDATA := Copy(ScanDATA, 1, Length(ScanDATA) - 1);

    if ScanDATA <> '' then
      TThread.Synchronize(nil,
        procedure
        begin
          try
            frmMain.OnObrBarcodeDetected(Nil);
          except
          end;
        end);
  except
  end;
end;

function GetSearshBox(AListView: TListView): TSearchBox;
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
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  ScreenService: IFMXScreenService;
  OrientSet: TScreenOrientations;
  {$ENDIF}
  {$IFDEF ANDROID}
  aFMXApplicationEventService: IFMXApplicationEventService;
  {$ENDIF}
  I, nWebServer: Integer;
  Res: TArray<string>;
  SettingsFile : TIniFile;
begin

  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  VKAutoShowMode := TVKAutoShowMode.Always;
  vsbMain.OnCalcContentBounds := CalcContentBoundsProc;
  {$ENDIF}

  FormatSettings.DecimalSeparator := '.';
  FisBecomeForeground := False;
  FPasswordLabelClick := 0;
  FScanType := 0;
  FisNextScan := False;
  FisScanOk := False;
  FBarCodePref := '0000';
  FDocBarCodePref := '2230';
  FItemBarCodePref := '2240';
  nWebServer:= 0;

  FFormsStack := TStack<TFormStackItem>.Create;

  FDataWedgeBarCode := TDataWedgeBarCode.Create(Nil);
  FCaptionFontSize := lCaption.TextSettings.Font.Size;

  // Проверка наличия сканера
  {$IF DEFINED(ANDROID)}
  FisZebraScaner := Pos('Zebra', JStringToString(TJBuild.JavaClass.MANUFACTURER)) > 0;
  {$ELSE}
  FisZebraScaner := False;
  {$ENDIF}

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
     aFMXApplicationEventService.SetApplicationEventHandler(HandleAppEvent);
  {$ENDIF}

  // получение настроек из ini файла
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  FINIFile := TPath.Combine(TPath.GetDocumentsPath, 'settings.ini');
  {$ELSE}
  FINIFile := TPath.Combine(ExtractFilePath(ParamStr(0)), 'settings.ini');
  {$ENDIF}

  SettingsFile := TIniFile.Create(FINIFile);
  try
    LoginEdit.Text := SettingsFile.ReadString('LOGIN', 'USERNAME', '');

    FDateDownloadDict := SettingsFile.ReadDateTime('Params', 'DateDownloadDict', IncDay(Now, - 2));

    FBarCodePref := SettingsFile.ReadString('Params', 'BarCodePref', '0000');
    FDocBarCodePref := SettingsFile.ReadString('Params', 'DocBarCodePref', '2230');
    FItemBarCodePref := SettingsFile.ReadString('Params', 'ItemBarCodePref', '2240');
    FArticleSeparators := SettingsFile.ReadString('Params', 'ArticleSeparators', ' ,-');

    FisCameraScaner := SettingsFile.ReadBool('DataWedge', 'isCameraScaner', False);
    FDataWedgeBarCode.isIllumination := SettingsFile.ReadBool('DataWedge', 'isIllumination', True);
    FisOpenScanChangingMode := SettingsFile.ReadBool('Params', 'isOpenScanChangingMode', False);
    FisHideScanButton := SettingsFile.ReadBool('Params', 'isHideScanButton', False);
    FisHideIlluminationButton := SettingsFile.ReadBool('Params', 'isHideIlluminationButton', False);

    nWebServer := SettingsFile.ReadInteger('Params', 'WebServer', nWebServer);

  finally
    FreeAndNil(SettingsFile);
  end;

  Res := TRegEx.Split(WebServer, ';');

  for I := Low(Res) to High(Res) do pbWebServer.Items.Add(Res[I]);

  if pbWebServer.Items.Count > nWebServer then pbWebServer.ItemIndex := nWebServer
  else pbWebServer.ItemIndex := 0;

  FPermissionState := True;
  // установка вертикального положения экрана телефона
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
  begin
    OrientSet := [TScreenOrientation.Portrait];
    ScreenService.SetSupportedScreenOrientations(OrientSet);
  end;
  // Изменим маштаб для смартфонов
  if MainWidth < Screen.Width then
  begin
    lMain.Scale.x := Screen.Width / MainWidth;
    lMain.Scale.y := lMain.Scale.x;
  end;
  {$ENDIF}
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FDataWedgeBarCode.Free;
  FFormsStack.Free;
end;

procedure TfrmMain.FormFocusChanged(Sender: TObject);
begin
  if Assigned(ActiveControl) then
  begin
    FIsUpdate := False;
    FOldControl := FCuurControl;
    FCuurControl := ActiveControl;
  end;
end;

procedure TfrmMain.SetDateDownloadDict(Values : TDateTime);
  var SettingsFile : TIniFile;
begin
  // Сохраним в ini файла
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FDateDownloadDict := Values;
    SettingsFile.WriteDateTime('Params', 'DateDownloadDict', FDateDownloadDict);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.SetBarCodePref(Values : String);
  var SettingsFile : TIniFile;
begin
  // Сохраним в ini файла
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FBarCodePref := Values;
    SettingsFile.WriteString('Params', 'BarCodePref', FBarCodePref);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.SetDocBarCodePref(Values : String);
  var SettingsFile : TIniFile;
begin
  // Сохраним в ini файла
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FDocBarCodePref := Values;
    SettingsFile.WriteString('Params', 'DocBarCodePref', FDocBarCodePref);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.SetItemBarCodePref(Values : String);
  var SettingsFile : TIniFile;
begin
  // Сохраним в ini файла
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FItemBarCodePref := Values;
    SettingsFile.WriteString('Params', 'BarCodePref', FItemBarCodePref);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.SetArticleSeparators(Values : String);
  var SettingsFile : TIniFile;
begin
  // Сохраним в ini файла
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FArticleSeparators := Values;
    SettingsFile.WriteString('Params', 'ArticleSeparators', FArticleSeparators);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.SetisCameraScaner(Values : boolean);
  var SettingsFile : TIniFile;
begin
  // Сохраним в ini файла
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FisCameraScaner := Values;
    SettingsFile.WriteBool('DataWedge', 'isCameraScaner', FisCameraScaner);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.SetisOpenScanChangingMode(Values : boolean);
  var SettingsFile : TIniFile;
begin
  // Сохраним в ini файла
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FisOpenScanChangingMode := Values;
    SettingsFile.WriteBool('Params', 'isisOpenScanChangingMode', FisOpenScanChangingMode);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.SetisHideIlluminationButton(Values : boolean);
  var SettingsFile : TIniFile;
begin
  // Сохраним в ini файла
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FisHideIlluminationButton := Values;
    SettingsFile.WriteBool('Params', 'isHideIlluminationButton', FisHideIlluminationButton);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.SetisHideScanButton(Values : boolean);
  var SettingsFile : TIniFile;
begin
  // Сохраним в ini файла
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FisHideScanButton := Values;
    SettingsFile.WriteBool('Params', 'isHideScanButton', FisHideScanButton);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

function TfrmMain.GetisIlluminationMode : Boolean;
begin
  Result := FDataWedgeBarCode.isIllumination
end;

procedure TfrmMain.SetisilluminationMode(Values : boolean);
  var SettingsFile : TIniFile;
begin
  // Сохраним в ini файла
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FDataWedgeBarCode.isIllumination := Values;
    SettingsFile.WriteBool('DataWedge', 'isIlluminationMode', FDataWedgeBarCode.isIllumination);
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

// ввод числа (для редактирования количества комплектующих)
procedure TfrmMain.b0Click(Sender: TObject);
begin
  if lAmount.Text = '0' then
    lAmount.Text := '';

  lAmount.Text := lAmount.Text + TButton(Sender).Text;
end;

// очистка количества комплектующих
procedure TfrmMain.bClearAmountClick(Sender: TObject);
begin
  lAmount.Text := '0';
end;

procedure TfrmMain.bAddAmountClick(Sender: TObject);
begin
//  if tcMain.ActiveTab = tiInventoryScan then DM.UpdateInventoryGoods(DM.qryInventoryGoodsAmount.AsFloat + StrToFloatDef(lAmount.Text, 0));

  ppEnterAmount.IsOpen := false;
end;

// отнимание количества комплектующих от введенных ранее
procedure TfrmMain.bMinusAmountClick(Sender: TObject);
begin
//  if tcMain.ActiveTab = tiInventoryScan then DM.UpdateInventoryGoods(DM.qryInventoryGoodsAmount.AsFloat - StrToFloatDef(lAmount.Text, 0));

  ppEnterAmount.IsOpen := false;
end;

procedure TfrmMain.bOrderInternalChoiceClick(Sender: TObject);
  var Id: Integer;
begin
end;

// Сборка Узла / Лодки
procedure TfrmMain.bProductionUnionScanModeClick(Sender: TObject);
begin
  FScanType := TSpinEditButton(Sender).Tag;
  SetProductionUnionScanButton;
  if FisOpenScanChangingMode then sbScanClick(Sender);
end;

procedure TfrmMain.bProductionUnionScanSearchClick(Sender: TObject);
begin
  FisNextScan := False;
  FisScanOk := False;
  bProductionUnionScanSearch.Visible := True;
end;

// присвоение количества комплектующих
procedure TfrmMain.bEnterAmountClick(Sender: TObject);
begin
//  if tcMain.ActiveTab = tiInventoryScan then DM.UpdateInventoryGoods(StrToFloatDef(lAmount.Text, 0));

  ppEnterAmount.IsOpen := false;
end;

{$IF DEFINED(ANDROID)}
function TfrmMain.HandleAppEvent(AAppEvent: TApplicationEvent;
  AContext: TObject): Boolean;
begin
  case AAppEvent of
    TApplicationEvent.WillBecomeForeground : if FisZebraScaner and not FisCameraScaner then FisBecomeForeground := True;
    TApplicationEvent.WillBecomeInactive, TApplicationEvent.WillTerminate : if tcMain.ActiveTab = tiScanBarCode then sbBackClick(Nil);
  end;
  Result := True;
end;
{$ENDIF}

procedure TfrmMain.ProductionUnionInsert(const AResult: TModalResult);
  var ScanId: Integer;
begin
//  if (AResult = mrYes) and (FOrderInternal <> 0) then
//  begin
//    try
//      if DM.InsertProductionUnion(FOrderInternal, ScanId) then
//      begin
//        if tcMain.ActiveTab = tiProductionUnionEdit then ReturnPriorForm;
//        if DM.cdsProductionUnionItemEdit.Active then
//        begin
//          bpProductionUnion.Visible := False;
//          if FisNextScan and FisScanOk and not FisZebraScaner then
//          begin
//            DM.cdsProductionUnionItemEdit.Close;
//            NextScan;
//          end else DM.GetProductionUnionItem(ScanId)
//        end else if FScanType <> 3 then
//          ShowEditProductionUnionItem(ScanId);
//      end;
//    except
//      on E : Exception do
//      begin
//        TDialogService.ShowMessage('Ошибка создания сборки узла/лодки'+#13#10 + GetTextMessage(E));
//      end;
//    end;
//  end;
end;

procedure TfrmMain.ProductionUnionOpen(const AResult: TModalResult);
begin
  if (FProductionUnion <> 0) and (FScanType <> 3) then
    ShowEditProductionUnionItem(FProductionUnion)
  else NextScan;
end;

procedure TfrmMain.DeleteProductionUnionGoods(const AResult: TModalResult);
begin
//  if AResult = mrYes then
//  begin
//    DM.SetErasedProductionUnion(DM.cdsProductionUnionListTop);
//    DM.DownloadProductionUnionListTop;
//  end;
end;

procedure TfrmMain.ErasedProductionUnionList(const AResult: TModalResult);
begin
//  if AResult = mrYes then
//  begin
//    DM.SetErasedProductionUnion(DM.cdsProductionUnionList);
//  end;
end;

procedure TfrmMain.UnErasedProductionUnionList(const AResult: TModalResult);
begin
//  if AResult = mrYes then
//  begin
//    DM.CompleteProductionUnion(DM.cdsProductionUnionList);
//  end;
end;

procedure TfrmMain.NoBarCodeNextScan(const AResult: TModalResult);
begin
  NextScan;
end;

// Формирование документа сборки
procedure TfrmMain.bpProductionUnionCancelClick(Sender: TObject);
begin
//  DM.cdsProductionUnionItemEdit.Close;
//  ReturnPriorForm;
end;

procedure TfrmMain.bpProductionUnionClick(Sender: TObject);
begin
  TDialogService.MessageDialog('Формировать документ сборки узла/лодки?',
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ProductionUnionInsert)
end;

// переход на заданную форму с сохранением её в стэк открываемых форм
procedure TfrmMain.SwitchToForm(const TabItem: TTabItem; const Data: TObject);
var
  Item: TFormStackItem;
begin
  Item.PageIndex := tcMain.ActiveTab.Index;
  Item.Data := Data;
  FFormsStack.Push(Item);
  FActiveTabPrew := tcMain.ActiveTab;
  tcMain.ActiveTab := TabItem;
end;

procedure TfrmMain.TimerInfoViewTimer(Sender: TObject);
begin
  TimerInfoView.Enabled := False;
  ppInfoView.IsOpen := False;
end;

procedure TfrmMain.TimerTorchModeTimer(Sender: TObject);
begin
  TimerTorchMode.Enabled := False;
  if ScanCamera.HasFlash and isIlluminationMode then
    ScanCamera.TorchMode := TTorchMode.ModeOn;
end;

// возврат на предидущую форму из стэка открываемых форм, с удалением её из стэка
procedure TfrmMain.ReturnPriorForm(const OmitOnChange: Boolean);
var
  Item: TFormStackItem;
  OnChange: TNotifyEvent;
begin

  sbBack.Visible := tcMain.ActiveTab <> tiStart;
  sbClose.Visible := sbBack.Visible;
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
  if ScanCamera.Active and not Assigned(ScanThread)  then
  begin
    ScanCamera.SampleBufferToBitmap(imgCameraScanBarCode.Bitmap, True);
    ScanThread := TScanThread.Create(False);
  end;
end;

procedure TfrmMain.OnObrBarcodeDetected(Sender: TObject);
var
  pOnScanResult: TDataWedgeBarCodeResult;
  pOnScanResultDetails: TDataWedgeBarCodeResultDetails;
begin
  if ScanDATA <> '' then
  begin
    pOnScanResultDetails := FDataWedgeBarCode.OnScanResultDetails;
    pOnScanResult := FDataWedgeBarCode.OnScanResult;

    sbBackClick(Sender);

    if Assigned(pOnScanResultDetails) then pOnScanResultDetails(Self, 'Scan',
                          'Camera', ScanSymbologyName, ScanDATA);

    if Assigned(pOnScanResult) then pOnScanResult(Self, ScanDATA);

    ScanSymbologyName := '';
    ScanDATA := '';
  end;
end;

procedure TfrmMain.SetProductionUnionScanButton;
begin
  bProductionUnionScanMode.ImageIndex := 13;
  bProductionUnionScanMode.TextSettings.FontColor := bProductionUnionScanSearch.TextSettings.FontColor;
  bProductionUnionScanMode.TextSettings.Font.Style := bProductionUnionScanSearch.TextSettings.Font.Style;
  bProductionUnionScanMode.TextSettings.Font.Size := bProductionUnionScanSearch.TextSettings.Font.Size;
  bProductionUnionScanNull.ImageIndex := 13;
  bProductionUnionScanNull.TextSettings.FontColor := bProductionUnionScanSearch.TextSettings.FontColor;
  bProductionUnionScanNull.TextSettings.Font.Style := bProductionUnionScanSearch.TextSettings.Font.Style;
  bProductionUnionScanNull.TextSettings.Font.Size := bProductionUnionScanSearch.TextSettings.Font.Size;


  case FScanType of
    0 : begin
          bProductionUnionScanMode.ImageIndex := 12;
          bProductionUnionScanMode.TextSettings.FontColor := TAlphaColorRec.Peru;
          bProductionUnionScanMode.TextSettings.Font.Style := [TFontStyle.fsBold];
          bProductionUnionScanMode.TextSettings.Font.Size := bProductionUnionScanSearch.TextSettings.Font.Size + 1;
        end;
    3 : begin
          bProductionUnionScanNull.ImageIndex := 12;
          bProductionUnionScanNull.TextSettings.FontColor := TAlphaColorRec.Peru;
          bProductionUnionScanNull.TextSettings.Font.Style := [TFontStyle.fsBold];
          bProductionUnionScanNull.TextSettings.Font.Size := bProductionUnionScanSearch.TextSettings.Font.Size + 1;
        end;
  end;
end;

procedure TfrmMain.ChangeMainPageUpdate(Sender: TObject);
begin

  {$IF DEFINED(ANDROID)}
  if tcMain.ActiveTab = tiStart then
  begin
    bGoods.Enabled := False;
    bInfo.Enabled := False;
    bInventoryScan.Enabled := False;
    bLogIn.Enabled := False;
    bProductionUnionScan.Enabled := False;
    bRelogin.Enabled := False;
    bSendScan.Enabled := False;
    bUpload.Enabled := False;
  end else if not bGoods.Enabled then
  begin
    TTask.Run(
    procedure
    begin
      sleep(1000);
      TThread.Synchronize(nil,
        procedure
        begin
          bGoods.Enabled := True;
          bInfo.Enabled := True;
          bInventoryScan.Enabled := True;
          bLogIn.Enabled := True;
          bProductionUnionScan.Enabled := True;
          bRelogin.Enabled := True;
          bSendScan.Enabled := True;
          bUpload.Enabled := True;
        end);
    end);
  end;
  {$ENDIF}

  if tcMain.ActiveTab <> tiScanBarCode then
  begin
    FDataWedgeBarCode.OnScanResultDetails := Nil;
    FDataWedgeBarCode.OnScanResult := Nil;
  end;
  if (tcMain.ActiveTab <> tiInformation) and (tcMain.ActiveTab <> tiScanBarCode) then lwBarCodeResult.Items.Clear;
  PasswordEdit.Text := '';
  lCaption.TextSettings.Font.Size := FCaptionFontSize;

  { настройка панели возврата }
  if (tcMain.ActiveTab = tiStart)  then
  begin
    pBack.Visible := false;
  end else
  begin
    pBack.Visible := true;
    sbRefresh.Visible := False;

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

    if tcMain.ActiveTab = tiMain then
      lCaption.Text := 'A g i l i s'
    else
    if tcMain.ActiveTab = tiInformation then
    begin
      lCaption.Text := 'Информация';
      FDataWedgeBarCode.OnScanResultDetails := OnScanResultDetails;
    end
    else
    if tcMain.ActiveTab = tiScanBarCode then
    begin
      lCaption.Text := 'Сканер штрихкода';

      //Настройка камерЫ
      ScanCamera.Quality := FMX.Media.TVideoCaptureQuality.MediumQuality;
      ScanCamera.Kind := FMX.Media.TCameraKind.BackCamera;
      ScanCamera.FocusMode := FMX.Media.TFocusMode.ContinuousAutoFocus;
      ScanCamera.OnSampleBufferReady := CameraScanBarCodeSampleBufferReady;
      ScanCamera.Active := True;
      //Зажгем подсветку с задержкой
      if ScanCamera.HasFlash and isIlluminationMode then TimerTorchMode.Enabled := True;
    end else
    if tcMain.ActiveTab = tiProductionUnionScan then
    begin
      lCaption.Text := 'Сборка Узла / Лодки';
      SetProductionUnionScanButton;
      sbRefresh.Visible := True;
      //DM.DownloadProductionUnionListTop;
      FDataWedgeBarCode.OnScanResult := OnScanProductionUnion;
      NextScan;
    end else
    if tcMain.ActiveTab = tiProductionUnionList then
    begin
      lCaption.Text := 'Просмотр призводства - сбороки';
      sbRefresh.Visible := True;
    end  else
    if tcMain.ActiveTab = tiProductionUnionEdit then
    begin
      lCaption.Text := 'Редактирование cборка Узла / Лодки';
      sbRefresh.Visible := True;
    end;

    if (tcMain.ActiveTab = tiInformation) or (tcMain.ActiveTab = tiProductionUnionScan) then
    begin
      sbScan.Visible := FisZebraScaner and not FisCameraScaner and not FisHideScanButton or not FisZebraScaner or FisCameraScaner;
    end else sbScan.Visible := false;

    if (tcMain.ActiveTab = tiInformation) or (tcMain.ActiveTab = tiProductionUnionScan) or (tcMain.ActiveTab = tiScanBarCode) then
    begin
      sbIlluminationMode.Visible := not FisHideIlluminationButton  and (FisZebraScaner or FisCameraScaner and ScanCamera.HasFlash or
                                    (tcMain.ActiveTab = tiScanBarCode) and ScanCamera.HasFlash);
    end else sbIlluminationMode.Visible := False;

    if sbIlluminationMode.Visible then
    begin
      if isIlluminationMode then
        imgIlluminationMode.MultiResBitmap.Assign(ilButton.Source.Items[ilButton.Source.IndexOf('ic_flash_on')].MultiResBitmap)
      else imgIlluminationMode.MultiResBitmap.Assign(ilButton.Source.Items[ilButton.Source.IndexOf('ic_flash_off')].MultiResBitmap);
    end;
  end;
end;

procedure TfrmMain.edАmountChangeTracking(Sender: TObject);
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

  if FisZebraScaner then
  begin
    lUseCamera.Visible := True;
    rbBarcodeScaner.IsChecked:= not FisCameraScaner;
    rbCameraScaner.IsChecked:= FisCameraScaner;
  end else lUseCamera.Visible := False;
  cbHideScanButton.Visible := lUseCamera.Visible;

  if cbHideScanButton.Visible then
    lAddConfig.Height := cbHideScanButton.Position.Y + cbHideScanButton.Height+ 2
  else lAddConfig.Height := cbHideIlluminationButton.Position.Y + cbHideIlluminationButton.Height + 2;

  // Открывать сканер при изменении режима
  cbOpenScanChangingMode.IsChecked := FisOpenScanChangingMode;
  // Скрывать кнопку подсветки
  cbHideIlluminationButton.IsChecked := FisHideIlluminationButton;
  // Скрывать кнопку сканирования когда есть боковые
  cbHideScanButton.IsChecked := FisHideScanButton;
  // Поссветка включена
  cblluminationMode.IsChecked := isIlluminationMode;

  SwitchToForm(tiInformation, nil);
end;

// начитка информации журнала перемещений
procedure TfrmMain.ShowProductionUnionList;
begin

  //if not DM.DownloadProductionUnionList(pbPULOrderBy.ItemIndex > 0, pbPULAllUser.ItemIndex > 0, pbPULErased.ItemIndex > 0, GetSearshBox(lwProductionUnionList).Text) then Exit;

  if tcMain.ActiveTab <> tiProductionUnionList then SwitchToForm(tiProductionUnionList, nil);
end;

// открытие на редактирование ранее введенной строки Сборка Узла / Лодки
procedure TfrmMain.ShowEditProductionUnionItem(AId: Integer);
begin
  if AID = 0 then Exit;

  bpProductionUnion.Visible := False;

//  if  DM.GetProductionUnionItem(AId) then
//    SwitchToForm(tiProductionUnionEdit, nil);
end;

// Сборка Узла / Лодки
procedure TfrmMain.ShowProductionUnionScan;
begin
  SwitchToForm(tiProductionUnionScan, nil);
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

procedure TfrmMain.bViewProductionUnionClick(Sender: TObject);
begin
  ShowProductionUnionList;
end;

procedure TfrmMain.OnCloseDialog(const AResult: TModalResult);
begin
  if AResult = mrOK then
    Close;
end;

// обработка нажатия кнопки возврата на предидущую форму
procedure TfrmMain.sbBackClick(Sender: TObject);
begin
  // если кнопкой назад то отменяем повтор
  if Sender = sbBack then
  begin
    FisNextScan := False;
    FisScanOk := False;
  end;

  if (tcMain.ActiveTab = tiScanBarCode) then
  begin
    ScanCamera.OnSampleBufferReady := Nil;
    if ScanCamera.HasFlash then ScanCamera.TorchMode := TTorchMode.ModeOff;
    ScanCamera.Active := False;
    imgCameraScanBarCode.Bitmap.Clear(TAlphaColorRec.White);
  end else if tcMain.ActiveTab = tiInformation then
  begin

    // Использовать в любом случае камеру устройства
    if isCameraScaner <> rbCameraScaner.IsChecked then
      isCameraScaner := rbCameraScaner.IsChecked;
    // Открывать сканер при изменении режима
    if isOpenScanChangingMode <> cbOpenScanChangingMode.IsChecked then
      isOpenScanChangingMode := cbOpenScanChangingMode.IsChecked;
    // Скрывать кнопку подсветки
    if isHideIlluminationButton <> cbHideIlluminationButton.IsChecked then
      isHideIlluminationButton := cbHideIlluminationButton.IsChecked;
    // Скрывать кнопку сканирования когда есть боковые
    if isHideScanButton <> cbHideScanButton.IsChecked then
      isHideScanButton := cbHideScanButton.IsChecked;
    // Поссветка включена
    if isIlluminationMode <> cblluminationMode.IsChecked then
      isIlluminationMode := cblluminationMode.IsChecked;
  end;

  ReturnPriorForm;
end;

procedure TfrmMain.sbIlluminationModeClick(Sender: TObject);
begin
  isIlluminationMode := not isIlluminationMode;
  if FisZebraScaner and not FisCameraScaner then FDataWedgeBarCode.SetIllumination;
  if isIlluminationMode then
    imgIlluminationMode.MultiResBitmap.Assign(ilButton.Source.Items[ilButton.Source.IndexOf('ic_flash_on')].MultiResBitmap)
  else imgIlluminationMode.MultiResBitmap.Assign(ilButton.Source.Items[ilButton.Source.IndexOf('ic_flash_off')].MultiResBitmap);

  if (tcMain.ActiveTab = tiScanBarCode) and ScanCamera.HasFlash then
  begin
    if isIlluminationMode then
      ScanCamera.TorchMode := TTorchMode.ModeOn
    else ScanCamera.TorchMode := TTorchMode.Modeoff;
  end;
end;

procedure TfrmMain.sbRefreshClick(Sender: TObject);
var
  Svc: IFMXVirtualKeyboardService;
begin

  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, Svc) then
    if TVirtualKeyboardState.Visible in Svc.VirtualKeyboardState then Svc.HideVirtualKeyboard;

  if tcMain.ActiveTab = tiProductionUnionScan then
  begin
  //  DM.DownloadProductionUnionListTop;
  end else if tcMain.ActiveTab = tiProductionUnionList then
  begin
    ShowProductionUnionList;
  end;
end;

// Следующее сканирование
procedure TfrmMain.NextScan;
begin
  FGoodsId := 0;
  FProductionUnion := 0;
  if FisNextScan and FisScanOk and not FisZebraScaner then sbScanClick(Nil);
  FisScanOk := False;
end;

// Включить сканер
procedure TfrmMain.sbScanClick(Sender: TObject);
begin
  if FisBecomeForeground and FisZebraScaner and not FisCameraScaner then
  begin
    FDataWedgeBarCode.SetIllumination;
    if isIlluminationMode then
      imgIlluminationMode.MultiResBitmap.Assign(ilButton.Source.Items[ilButton.Source.IndexOf('ic_flash_on')].MultiResBitmap)
    else imgIlluminationMode.MultiResBitmap.Assign(ilButton.Source.Items[ilButton.Source.IndexOf('ic_flash_off')].MultiResBitmap);
    FisBecomeForeground := False;
  end;

  FisNextScan := not FisZebraScaner or FisCameraScaner;

  if FisZebraScaner and not FisCameraScaner then FDataWedgeBarCode.Scan
  else SwitchToForm(tiScanBarCode, nil);
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
      if ppInfoView.IsOpen then
        ppInfoView.IsOpen := false
      else
      if ppWebServer.IsOpen then
        ppWebServer.IsOpen := false
      else
      if ppActions.IsOpen then
        ppActions.IsOpen := false
      else
      if ppEnterAmount.IsOpen then
        ppEnterAmount.IsOpen := false
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

{$IF DEFINED(iOS) or DEFINED(ANDROID)}
procedure TfrmMain.CalcContentBoundsProc(Sender: TObject;
                                       var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
                                2 * ClientHeight - FKBBounds.Top);
  end;
end;

procedure TfrmMain.RestorePosition;
begin
  vsbMain.ViewportPosition := PointF(vsbMain.ViewportPosition.X, 0);
  lMain.Align := TAlignLayout.Client;
  vsbMain.RealignContent;
end;

procedure TfrmMain.UpdateKBBounds;
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(vsbMain.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
       (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
      lMain.Align := TAlignLayout.Horizontal;
      vsbMain.RealignContent;
      Application.ProcessMessages;
      vsbMain.ViewportPosition :=
        PointF(vsbMain.ViewportPosition.X,
               LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then
    RestorePosition;
end;
{$ENDIF}

procedure TfrmMain.FormShow(Sender: TObject);
begin
  SwitchToForm(tiStart, nil);
  ChangeMainPageUpdate(nil);
end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;
  {$ENDIF}
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  if (Focused.GetObject is TEdit) and (Screen.ActiveForm = frmMain)  then
  begin
    TEdit(Focused.GetObject).CaretPosition := Length(TEdit(Focused.GetObject).Text);
    FKBBounds := TRectF.Create(Bounds);
    FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
    FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
    UpdateKBBounds;
  end;
  {$ENDIF}
end;

procedure TfrmMain.lwProductionUnionListDblClick(Sender: TObject);
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  var Handled: Boolean;
      GestureEventInfo: TGestureEventInfo;
  {$ENDIF}
begin
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  Handled := False;
  lwProductionUnionListGesture(Sender, GestureEventInfo, Handled)
  {$ENDIF}
end;

procedure TfrmMain.lwProductionUnionListGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var I: Integer;
begin
  if ppActions.IsOpen or Handled then Exit;

  // Сскроем все
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // Редактирование в сканированиях перемещения
//  if (tcMain.ActiveTab = tiProductionUnionList) and DM.cdsProductionUnionList.Active and not DM.cdsProductionUnionList.IsEmpty then
//  begin
//    btaCancel.Visible := True;
//    btaEraseRecord.Visible := DM.cdsProductionUnionListStatusCode.AsInteger <> 3;
//    btaUnEraseRecord.Visible := DM.cdsProductionUnionListStatusCode.AsInteger = 3;
//    btaEditRecord.Visible := DM.cdsProductionUnionListStatusCode.AsInteger <> 3;
//    ppActions.Height := 2;
//    for I := 0 to ComponentCount - 1 do
//      if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
//      begin
//        ppActions.Height := ppActions.Height + TButton(Components[I]).Height;
//      end;
//    ppActions.IsOpen := True;
//  end;

end;

procedure TfrmMain.lwProductionUnionScanDblClick(Sender: TObject);
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  var Handled: Boolean;
      GestureEventInfo: TGestureEventInfo;
  {$ENDIF}
begin
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  Handled := False;
  lwProductionUnionScanGesture(Sender, GestureEventInfo, Handled)
  {$ENDIF}
end;

procedure TfrmMain.lwProductionUnionScanGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var I: Integer;
begin
  if ppActions.IsOpen or Handled then Exit;

  // Сскроем все
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // Редактирование в сканированиях перемещения
//  if (tcMain.ActiveTab = tiProductionUnionScan) and DM.cdsProductionUnionListTop.Active and not DM.cdsProductionUnionListTop.IsEmpty then
//  begin
//    btaCancel.Visible := True;
//    btaEraseRecord.Visible := True;
//    btaEditRecord.Visible := True;
//    ppActions.Height := 2;
//    for I := 0 to ComponentCount - 1 do
//      if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
//      begin
//        ppActions.Height := ppActions.Height + TButton(Components[I]).Height;
//      end;
//    ppActions.IsOpen := True;
//  end;
end;

procedure TfrmMain.LogInButtonClick(Sender: TObject);
var
  ErrorMessage: String;
  SettingsFile : TIniFile;
  I: Integer;
  Res: TArray<string>;
begin

  try
    vsbMain.Enabled := false;

    if not FPermissionState then
    begin
      TDialogService.ShowMessage('Необходимые разрешения не предоставлены');
      exit;
    end;

    Res := TRegEx.Split(WebServer, ';');

    SetLength(gc_WebServers, High(Res) + 1);

    if pbWebServer.ItemIndex > 0 then
    begin
      gc_WebServers[0] := Copy(pbWebServer.Text, Pos('http', pbWebServer.Text), Length(pbWebServer.Text));
      if High(Res) > 0 then
        if pbWebServer.ItemIndex = 1 then
          gc_WebServers[1] :=  Copy(Res[1], Pos('http', Res[1]), Length(Res[1]))
        else gc_WebServers[1] :=  Copy(Res[0], Pos('http', Res[0]), Length(Res[0]));
    end else for I := Low(Res) to High(Res) do gc_WebServers[I] := Copy(Res[I], Pos('http', Res[I]), Length(Res[I]));

    gc_WebService := gc_WebServers[0];

    Wait(True);
    try
      try

        if TButton(Sender).Tag = 1 then
        begin
          FDataWedgeBarCode.OnScanResult := OnScanResultLogin;
          sbScanClick(Sender);
          Wait(False);
          Exit;
        end else ErrorMessage := TAuthentication.CheckLogin(TStorageFactory.GetStorage, LoginEdit.Text, PasswordEdit.Text, gc_User);

        if Assigned(gc_User) then lUser.Text := gc_User.Login;

        if ErrorMessage <> '' then
        begin
          TDialogService.ShowMessage(ErrorMessage);
          exit;
        end;
      except on E: Exception do
        begin
          TDialogService.ShowMessage('Нет связи с сервером. Продолжение работы невозможно. '+#13#10 + GetTextMessage(E));
          Exit;
        end;
        //
      end;
    finally
      Wait(False);
    end;

    {$IFDEF ANDROID}
    DM.CheckUpdate; // проверка небходимости обновления
    {$ENDIF}

    // сохранение логина и веб сервера в ini файле
    SettingsFile := TIniFile.Create(FINIFile);
    try
      SettingsFile.WriteString('LOGIN', 'USERNAME', LoginEdit.Text);
      SettingsFile.WriteInteger('Params', 'WebServer', pbWebServer.ItemIndex);
    finally
      FreeAndNil(SettingsFile);
    end;

    // загрузили конфиг
    //DM.DownloadConfig;

    SwitchToForm(tiMain, nil);
  finally
    vsbMain.Enabled := True;
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

    vsbMain.Enabled := false;
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
        TDialogService.ShowMessage(ErrorMessage);
        exit;
      end;
    except on E: Exception do
      begin
        Wait(False);
        ErrorMessage := 'Нет связи с сервером. Продолжение работы невозможно. ';
        TDialogService.ShowMessage(ErrorMessage+#13#10 + GetTextMessage(E));
        exit;
      end;
      //
    end;

    {$IFDEF ANDROID}
    DM.CheckUpdate; // проверка небходимости обновления
    {$ENDIF}

    // загрузили конфиг
    //DM.DownloadConfig;

  finally
    if (ErrorMessage <> '') and (tcMain.ActiveTab <> tiStart) then
      ReturnPriorForm
    else if (ErrorMessage = '') and (tcMain.ActiveTab = tiStart) then
    begin
      SwitchToForm(tiMain, nil);
    end;
    vsbMain.Enabled := True;
  end;
end;

procedure TfrmMain.pbPULOrderByChange(Sender: TObject);
begin
//  if DM.cdsProductionUnionList.Active then ShowProductionUnionList;
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  ppActions.IsOpen := False;

  if (tcMain.ActiveTab = tiProductionUnionScan) then
  begin
    // Изменить позицию комплектующих
//    if TButton(Sender).Tag = 1 then
//    begin
//      ShowEditProductionUnionItem(DM.cdsProductionUnionListTopId.AsInteger);
//    end else
//    // Удаление позиции комплектующих
//    if TButton(Sender).Tag = 2 then
//      TDialogService.MessageDialog('Удалить сборку Узла / Лодки'#13#10'№ п/п = <' + DM.cdsProductionUnionListTopOrdUser.AsString + '>'#13#10 +
//                                   'документ = <' + DM.cdsProductionUnionListTopInvNumberFull.AsString + '>'#13#10 +
//                                   'кол-во = <' + DM.cdsProductionUnionListTopAmount.AsString + '>'#13#10 +
//                                   'для <' + DM.cdsProductionUnionListTopGoodsCode.AsString + '>'#13#10 +
//                                   'артикул <' + DM.cdsProductionUnionListTopArticle.AsString + '>'#13#10 +
//                                   '<' + DM.cdsProductionUnionListTopGoodsName.AsString + '> ?',
//           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteProductionUnionGoods)
//    ;
  end else if (tcMain.ActiveTab = tiProductionUnionList) then
  begin
//    // Изменить позицию комплектующих
//    if TButton(Sender).Tag = 1 then
//    begin
//      ShowEditProductionUnionItem(DM.cdsProductionUnionListId.AsInteger);
//    end else
//    // Удаление позиции комплектующего
//    if TButton(Sender).Tag = 2 then
//      TDialogService.MessageDialog('Удалить сборку Узла / Лодки'#13#10'№ п/п = <' + DM.cdsProductionUnionListOrdUser.AsString +'>'#13#10 +
//                                   'документ = <' + DM.cdsProductionUnionListInvNumberFull.AsString + '>'#13#10 +
//                                   'кол-во = <' + DM.cdsProductionUnionListAmount.AsString + '>'#13#10 +
//                                   'для <' + DM.cdsProductionUnionListGoodsCode.AsString + '>'#13#10 +
//                                   'артикул <' + DM.cdsProductionUnionListArticle.AsString + '>'#13#10 +
//                                   '<' + DM.cdsProductionUnionListGoodsName.AsString + '> ?',
//           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ErasedProductionUnionList)
//    else
//    // Востановление позиции комплектующего
//    if TButton(Sender).Tag = 3  then
//    begin
//      TDialogService.MessageDialog('Отменить удаление сборки Узла / Лодки'#13#10'№ п/п = <' + DM.cdsProductionUnionListOrdUser.AsString +'>'#13#10 +
//                                   'документ = <' + DM.cdsProductionUnionListInvNumberFull.AsString + '>'#13#10 +
//                                   'кол-во = <' + DM.cdsProductionUnionListAmount.AsString + '>'#13#10 +
//                                   'для <' + DM.cdsProductionUnionListGoodsCode.AsString + '>'#13#10 +
//                                   'артикул <' + DM.cdsProductionUnionListArticle.AsString + '>'#13#10 +
//                                   '<' + DM.cdsProductionUnionListGoodsName.AsString + '> ?',
//           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, UnErasedProductionUnionList)
//    end;
  end;

  if (TButton(Sender).Tag = 7) and sbBack.Visible  then sbBackClick(Sender);
end;

procedure TfrmMain.rbWebServerClick(Sender: TObject);
  var SettingsFile : TIniFile;
      I: Integer;
      Res: TArray<string>;
begin
  ppWebServer.IsOpen := False;
  FPasswordLabelClick := 0;

  while pbWebServer.Items.Count > 1 do pbWebServer.Items.Delete(1);

  Res := TRegEx.Split(WebServer, ';');

  for I := Low(Res) to High(Res) do pbWebServer.Items.Add(Res[I]);
  pbWebServer.ItemIndex := 0;
end;

// Обрабатываем отсканированный товар для производства
procedure TfrmMain.OnScanProductionUnion(Sender: TObject; AData_String: String);
  var ID: Integer;
begin

  FisScanOk := True;

  if COPY(AData_String, 1, LengTh(FItemBarCodePref)) = FItemBarCodePref then // Если штрих сборки
  begin

    if Length(AData_String) > 12 then AData_String := Copy(AData_String, 1, Length(AData_String) - 1);

    if not TryStrToInt(COPY(AData_String, Length(FItemBarCodePref) + 1, 9), Id) then
    begin
      TDialogService.MessageDialog('Не правельный штрихкод ' + AData_String,
        TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes], TMsgDlgBtn.mbYes, 0, ProductionUnionOpen);

      Exit;
    end;

    //ProcessOrderInternal(ID);

  end else TDialogService.MessageDialog('Не правельный штрихкод ' + AData_String,
             TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes], TMsgDlgBtn.mbYes, 0, ProductionUnionOpen);
end;

end.
