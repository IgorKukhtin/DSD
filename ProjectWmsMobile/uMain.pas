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
  FMX.ListBox, FMX.ExtCtrls, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, System.StrUtils,
  FMX.Grid.Style, FMX.Grid
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
    bChoiceCellScan: TButton;
    Image1: TImage;
    lChoiceCel: TLabel;
    bInventoryScan: TButton;
    Image2: TImage;
    lInventoryCel: TLabel;
    bProductionScan: TButton;
    Image4: TImage;
    lProduction: TLabel;
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
    tiChoiceCelEdit: TTabItem;
    pPassword: TPanel;
    Rectangle1: TRectangle;
    pChoiceCelEdit: TPanel;
    Label20: TLabel;
    edCCEPartionGoodsDate_next: TEdit;
    edCCEPartionGoodsDate: TEdit;
    Label21: TLabel;
    edCCEGoodsCode: TEdit;
    Label24: TLabel;
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
    tiChoiceCelScan: TTabItem;
    tiChoiceCelList: TTabItem;
    Panel10: TPanel;
    bChoiceCelScanSearch: TSpeedButton;
    bChoiceCelScanMode: TSpeedButton;
    bViewChoiceCel: TSpeedButton;
    bChoiceCelScanNull: TSpeedButton;
    lwChoiceCelScan: TListView;
    Panel11: TPanel;
    pbChoiceCelErased: TPopupBox;
    pbChoiceCelAllUser: TPopupBox;
    pbChoiceCelOrderBy: TPopupBox;
    llwChoiceCelList: TLabel;
    lwChoiceCelList: TListView;
    Label17: TLabel;
    edCCEChoiceCellName: TEdit;
    edCCEGoodsName: TMemo;
    Label49: TLabel;
    edCCEChoiceCellCode: TEdit;
    Label50: TLabel;
    edCCEGoodsKindName: TEdit;
    Label22: TLabel;
    bpChoiceCelCancel: TButton;
    bpChoiceCel: TButton;
    ScanCamera: TCameraComponent;
    TimerTorchMode: TTimer;
    PanelMain: TPanel;
    iScanBarCodePanel: TPanel;
    WebServerLayout11: TLayout;
    WebServerLabel: TLabel;
    WebServerLayout12: TLayout;
    pbWebServer: TPopupBox;
    BindSourceDB1: TBindSourceDB;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    LinkControlToField7: TLinkControlToField;
    LinkControlToField6: TLinkControlToField;
    BindSourceDB2: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    BindSourceDB3: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    TempEdit: TEdit;
    tiInventoryScan: TTabItem;
    Panel2: TPanel;
    bInventoryScanSearch: TSpeedButton;
    TempEditInventory: TEdit;
    bInventoryScanMode: TSpeedButton;
    bViewInventory: TSpeedButton;
    bInventoryScanNull: TSpeedButton;
    lwInventoryScan: TListView;
    tiInventoryEdit: TTabItem;
    Panel3: TPanel;
    Label1: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Edit5: TEdit;
    Memo1: TMemo;
    Label13: TLabel;
    Edit6: TEdit;
    Label14: TLabel;
    Edit7: TEdit;
    Label15: TLabel;
    bpInventoryCancel: TButton;
    bpInventory: TButton;
    tiInventoryList: TTabItem;
    Panel4: TPanel;
    pbInventoryErased: TPopupBox;
    pbInventoryAllUser: TPopupBox;
    pbInventoryOrderBy: TPopupBox;
    llwInventoryList: TLabel;
    lwInventoryList: TListView;
    BindSourceDB4: TBindSourceDB;
    BindSourceDB5: TBindSourceDB;
    BindSourceDB6: TBindSourceDB;
    LinkListControlToField3: TLinkListControlToField;
    LinkListControlToField4: TLinkListControlToField;
    LinkControlToField8: TLinkControlToField;
    LinkControlToField9: TLinkControlToField;
    LinkControlToField10: TLinkControlToField;
    Edit1: TEdit;
    Label16: TLabel;
    Edit8: TEdit;
    Label18: TLabel;
    LinkControlToField11: TLinkControlToField;
    LinkControlToField12: TLinkControlToField;
    LinkControlToField13: TLinkControlToField;
    LinkControlToField14: TLinkControlToField;
    LinkControlToField15: TLinkControlToField;
    LinkControlToField16: TLinkControlToField;
    lvBox: TListView;
    Label19: TLabel;
    Label23: TLabel;

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
    procedure ShowChoiceCelScan;
    procedure ShowChoiceCelList;
    procedure ShowInventoryList;
    procedure ShowEditChoiceCelItem(AId: Integer);
    procedure ShowEditInventoryItem(AId: Integer);
    procedure bInfoClick(Sender: TObject);
    procedure sbScanClick(Sender: TObject);
    procedure OnScanResultDetails(Sender: TObject; AAction, ASource, ALabel_Type, AData_String: String);
    procedure OnScanResultLogin(Sender: TObject; AData_String: String);
    procedure OnScanChoiceCel(Sender: TObject; AData_String: String);
    procedure OnScanInventory(Sender: TObject; AData_String: String);
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
    procedure bpChoiceCelClick(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure btnCancelClick(Sender: TObject);
    procedure rbWebServerClick(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure TimerInfoViewTimer(Sender: TObject);
    procedure sbRefreshClick(Sender: TObject);
    procedure lwChoiceCelScanDblClick(Sender: TObject);
    procedure lwChoiceCelScanGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure bChoiceCelScanModeClick(Sender: TObject);
    procedure bViewChoiceCelClick(Sender: TObject);
    procedure lwChoiceCelListGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lwChoiceCelListDblClick(Sender: TObject);
    procedure bpChoiceCelCancelClick(Sender: TObject);
    procedure pbChoiceCelOrderByChange(Sender: TObject);
    procedure bChoiceCelScanSearchClick(Sender: TObject);
    procedure TimerTorchModeTimer(Sender: TObject);
    procedure bChoiceCellScanClick(Sender: TObject);
    procedure bInventoryScanClick(Sender: TObject);
    procedure pbInventoryOrderByChange(Sender: TObject);
    procedure bViewInventoryClick(Sender: TObject);
    procedure bpInventoryCancelClick(Sender: TObject);
    procedure bInventoryScanSearchClick(Sender: TObject);
    procedure lwInventoryScanDblClick(Sender: TObject);
    procedure lwInventoryScanGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lwInventoryListGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lwInventoryListDblClick(Sender: TObject);
    procedure bpInventoryClick(Sender: TObject);
    procedure bInventoryScanModeClick(Sender: TObject);
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

    // Найденное место отбора
    FChoiceCelId: Integer;
    FChoiceCelBarCode: String;

    // Найденное инвентаризации
    FInventoryMovementItemId: Integer;
    FInventoryBarCode: String;

    {$IF DEFINED(iOS) or DEFINED(ANDROID)}
    procedure CalcContentBoundsProc(Sender: TObject;
                                    var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
    {$ENDIF}
    procedure SwitchToForm(const TabItem: TTabItem; const Data: TObject);
    procedure ReturnPriorForm(const OmitOnChange: Boolean = False);
    procedure ChoiceCelConfirm(const AResult: TModalResult);
    procedure InventoryConfirm(const AResult: TModalResult);
    procedure ErasedChoiceCelTop(const AResult: TModalResult);
    procedure ErasedChoiceCelList(const AResult: TModalResult);
    procedure UnErasedChoiceCelList(const AResult: TModalResult);
    procedure UnErasedChoiceCelTop(const AResult: TModalResult);

    procedure ErasedInventoryTop(const AResult: TModalResult);
    procedure ErasedInventoryList(const AResult: TModalResult);
    procedure UnErasedInventoryList(const AResult: TModalResult);
    procedure UnErasedInventoryTop(const AResult: TModalResult);

    procedure InputChoiceCel(const AResult: TModalResult; const AValues: array of string);
    procedure InputInventory(const AResult: TModalResult; const AValues: array of string);

    {$IF DEFINED(ANDROID)}
    function HandleAppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
    {$ENDIF}

    procedure Wait(AWait: Boolean);
    // Заполнение ящиков
    procedure AddlvBox(AName, ACount, AWeight: String);

  public
    { Public declarations }
    procedure SetChoiceCelScanButton;
    procedure SetInventoryScanButton;
    procedure ProcessChoiceCel(ABarCode: String);
    procedure ProcessInventory(ABarCode: String);

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

// Сканирование Места отбора
procedure TfrmMain.bChoiceCellScanClick(Sender: TObject);
begin
  FScanType := 0;
  SwitchToForm(tiChoiceCelScan, nil);
end;

// Сборка Места отбора
procedure TfrmMain.bChoiceCelScanModeClick(Sender: TObject);
begin
  FScanType := TSpinEditButton(Sender).Tag;
  SetChoiceCelScanButton;
  if FisOpenScanChangingMode then sbScanClick(Sender);
end;

procedure TfrmMain.InputChoiceCel(const AResult: TModalResult; const AValues: array of string);
begin
  try
    if (AResult = mrOk) and (AValues[0] <> '') then
    begin

      OnScanChoiceCel(Nil, AValues[0]);
    end;
  finally
    TempEdit.Visible := False;
  end;
end;

procedure TfrmMain.InputInventory(const AResult: TModalResult; const AValues: array of string);
begin
  try
    if (AResult = mrOk) and (AValues[0] <> '') then
    begin

      OnScanInventory(Nil, AValues[0]);
    end;
  finally
    TempEditInventory.Visible := False;
  end;
end;


procedure TfrmMain.bChoiceCelScanSearchClick(Sender: TObject);
begin
  TempEdit.Visible := True;
  TempEdit.SetFocus;
  TDialogService.InputQuery('Ввод № док. заказа', ['№ док. заказа'], [''], InputChoiceCel);
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

procedure TfrmMain.ChoiceCelConfirm(const AResult: TModalResult);
begin
  if (AResult = mrYes) and (FChoiceCelBarCode <> '') and DM.cdsChoiceCelEdit.Active and
     (DM.cdsChoiceCelEdit.RecordCount = 1) then
  begin
    try
      DM.ConfirmChoiceCel(FChoiceCelBarCode);
    except
      on E : Exception do
      begin
        TDialogService.ShowMessage('Ошибка подтверждения'+#13#10 + GetTextMessage(E));
      end;
    end;
  end;
end;

procedure TfrmMain.InventoryConfirm(const AResult: TModalResult);
begin
  if (AResult = mrYes) and (FInventoryMovementItemId <> 0) and DM.cdsInventoryEdit.Active and
     (DM.cdsInventoryEdit.RecordCount = 1) then
  begin
    try
      DM.ConfirmInventory(FInventoryMovementItemId);
    except
      on E : Exception do
      begin
        TDialogService.ShowMessage('Ошибка подтверждения'+#13#10 + GetTextMessage(E));
      end;
    end;
  end;
end;

procedure TfrmMain.ErasedChoiceCelTop(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.SetErasedChoiceCel(DM.cdsChoiceCelListTop);
    DM.DownloadChoiceCelListTop;
  end;
end;

procedure TfrmMain.ErasedChoiceCelList(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.SetErasedChoiceCel(DM.cdsChoiceCelList);
  end;
end;

procedure TfrmMain.UnErasedChoiceCelList(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.SetUnErasedChoiceCel(DM.cdsChoiceCelList);
  end;
end;

procedure TfrmMain.UnErasedChoiceCelTop(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.SetUnErasedChoiceCel(DM.cdsChoiceCelListTop);
  end;
end;

procedure TfrmMain.ErasedInventoryTop(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.SetErasedInventory(DM.cdsInventoryListTop);
    DM.DownloadInventoryListTop;
  end;
end;

procedure TfrmMain.ErasedInventoryList(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.SetErasedInventory(DM.cdsInventoryList);
  end;
end;

procedure TfrmMain.UnErasedInventoryList(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.SetUnErasedInventory(DM.cdsInventoryList);
  end;
end;

procedure TfrmMain.UnErasedInventoryTop(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.SetUnErasedInventory(DM.cdsInventoryListTop);
  end;
end;

// Формирование документа сборки
procedure TfrmMain.bpChoiceCelCancelClick(Sender: TObject);
begin
  DM.cdsChoiceCelEdit.Close;
  ReturnPriorForm;
end;

procedure TfrmMain.bpChoiceCelClick(Sender: TObject);
begin
  ChoiceCelConfirm(mrYes);
  ReturnPriorForm;
//  TDialogService.MessageDialog('Подтвердить?',
//    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ChoiceCelConfirm)
end;

procedure TfrmMain.bpInventoryCancelClick(Sender: TObject);
begin
  DM.cdsInventoryEdit.Close;
  ReturnPriorForm;
end;

procedure TfrmMain.bpInventoryClick(Sender: TObject);
begin
  InventoryConfirm(mrYes);
  ReturnPriorForm;
//  TDialogService.MessageDialog('Подтвердить?',
//    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, InventoryConfirm)
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

procedure TfrmMain.SetChoiceCelScanButton;
begin
  bChoiceCelScanMode.ImageIndex := 13;
  bChoiceCelScanMode.TextSettings.FontColor := bChoiceCelScanSearch.TextSettings.FontColor;
  bChoiceCelScanMode.TextSettings.Font.Style := bChoiceCelScanSearch.TextSettings.Font.Style;
  bChoiceCelScanMode.TextSettings.Font.Size := bChoiceCelScanSearch.TextSettings.Font.Size;
  bChoiceCelScanNull.ImageIndex := 13;
  bChoiceCelScanNull.TextSettings.FontColor := bChoiceCelScanSearch.TextSettings.FontColor;
  bChoiceCelScanNull.TextSettings.Font.Style := bChoiceCelScanSearch.TextSettings.Font.Style;
  bChoiceCelScanNull.TextSettings.Font.Size := bChoiceCelScanSearch.TextSettings.Font.Size;


  case FScanType of
    0 : begin
          bChoiceCelScanMode.ImageIndex := 12;
          bChoiceCelScanMode.TextSettings.FontColor := TAlphaColorRec.Peru;
          bChoiceCelScanMode.TextSettings.Font.Style := [TFontStyle.fsBold];
          bChoiceCelScanMode.TextSettings.Font.Size := bChoiceCelScanSearch.TextSettings.Font.Size + 1;
        end;
    3 : begin
          bChoiceCelScanNull.ImageIndex := 12;
          bChoiceCelScanNull.TextSettings.FontColor := TAlphaColorRec.Peru;
          bChoiceCelScanNull.TextSettings.Font.Style := [TFontStyle.fsBold];
          bChoiceCelScanNull.TextSettings.Font.Size := bChoiceCelScanSearch.TextSettings.Font.Size + 1;
        end;
  end;
end;

procedure TfrmMain.SetInventoryScanButton;
begin
  bInventoryScanMode.ImageIndex := 13;
  bInventoryScanMode.TextSettings.FontColor := bInventoryScanSearch.TextSettings.FontColor;
  bInventoryScanMode.TextSettings.Font.Style := bInventoryScanSearch.TextSettings.Font.Style;
  bInventoryScanMode.TextSettings.Font.Size := bInventoryScanSearch.TextSettings.Font.Size;
  bInventoryScanNull.ImageIndex := 13;
  bInventoryScanNull.TextSettings.FontColor := bInventoryScanSearch.TextSettings.FontColor;
  bInventoryScanNull.TextSettings.Font.Style := bInventoryScanSearch.TextSettings.Font.Style;
  bInventoryScanNull.TextSettings.Font.Size := bInventoryScanSearch.TextSettings.Font.Size;


  case FScanType of
    0 : begin
          bInventoryScanMode.ImageIndex := 12;
          bInventoryScanMode.TextSettings.FontColor := TAlphaColorRec.Peru;
          bInventoryScanMode.TextSettings.Font.Style := [TFontStyle.fsBold];
          bInventoryScanMode.TextSettings.Font.Size := bInventoryScanSearch.TextSettings.Font.Size + 1;
        end;
    3 : begin
          bInventoryScanNull.ImageIndex := 12;
          bInventoryScanNull.TextSettings.FontColor := TAlphaColorRec.Peru;
          bInventoryScanNull.TextSettings.Font.Style := [TFontStyle.fsBold];
          bInventoryScanNull.TextSettings.Font.Size := bInventoryScanSearch.TextSettings.Font.Size + 1;
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
    bLogIn.Enabled := False;
    bChoiceCellScan.Enabled := False;
    bRelogin.Enabled := False;
    sbScan.Enabled := False;
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
          bLogIn.Enabled := True;
          bChoiceCellScan.Enabled := True;
          bRelogin.Enabled := True;
          sbScan.Enabled := True;
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
    FDataWedgeBarCode.OnScanResult := OnScanResultLogin;
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
      lCaption.Text := 'Wms Mobile'
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
    if tcMain.ActiveTab = tiChoiceCelScan then
    begin
      lCaption.Text := 'Сканирование "Места отбора"';
      SetChoiceCelScanButton;
      sbRefresh.Visible := True;
      DM.DownloadChoiceCelListTop;
      FDataWedgeBarCode.OnScanResult := OnScanChoiceCel;
      NextScan;
    end else
    if tcMain.ActiveTab = tiChoiceCelList then
    begin
      lCaption.Text := 'Просмотр док-тов "Места отбора"';
      sbRefresh.Visible := True;
    end  else
    if tcMain.ActiveTab = tiChoiceCelEdit then
    begin
      lCaption.Text := 'Подтверждение "Места отбора"';
    end else
    if tcMain.ActiveTab = tiInventoryScan then
    begin
      lCaption.Text := 'Сканирование "Инвентаризации"';
      SetInventoryScanButton;
      sbRefresh.Visible := True;
      DM.DownloadInventoryListTop;
      FDataWedgeBarCode.OnScanResult := OnScanInventory;
      NextScan;
    end else
    if tcMain.ActiveTab = tiInventoryList then
    begin
      lCaption.Text := 'Просмотр док-тов "Инвентаризации"';
      sbRefresh.Visible := True;
    end  else
    if tcMain.ActiveTab = tiInventoryEdit then
    begin
      lCaption.Text := 'Подтверждение "Инвентаризации"';
    end;

    if (tcMain.ActiveTab = tiInformation) or (tcMain.ActiveTab = tiChoiceCelScan) or (tcMain.ActiveTab = tiInventoryScan) then
    begin
      sbScan.Visible := FisZebraScaner and not FisCameraScaner and not FisHideScanButton or not FisZebraScaner or FisCameraScaner;
    end else sbScan.Visible := false;

    if (tcMain.ActiveTab = tiInformation) or (tcMain.ActiveTab = tiChoiceCelScan) or (tcMain.ActiveTab = tiInventoryScan) or (tcMain.ActiveTab = tiScanBarCode) then
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
procedure TfrmMain.ShowChoiceCelList;
begin

  if not DM.DownloadChoiceCelList(pbChoiceCelOrderBy.ItemIndex > 0, pbChoiceCelAllUser.ItemIndex > 0, pbChoiceCelErased.ItemIndex > 0, GetSearshBox(lwChoiceCelList).Text) then Exit;

  if tcMain.ActiveTab <> tiChoiceCelList then SwitchToForm(tiChoiceCelList, nil);
end;

// начитка информации журнала инвентаризаций
procedure TfrmMain.ShowInventoryList;
begin

  if not DM.DownloadInventoryList(pbInventoryOrderBy.ItemIndex > 0, pbInventoryAllUser.ItemIndex > 0, pbInventoryErased.ItemIndex > 0, GetSearshBox(lwInventoryList).Text) then Exit;

  if tcMain.ActiveTab <> tiInventoryList then SwitchToForm(tiInventoryList, nil);
end;

// открытие на редактирование ранее введенной строки Сборка Узла / Лодки
procedure TfrmMain.ShowEditChoiceCelItem(AId: Integer);
begin
  if AID = 0 then Exit;

  bpChoiceCel.Visible := False;

//  if  DM.GetChoiceCelItem(AId) then
//    SwitchToForm(tiChoiceCelEdit, nil);
end;

procedure TfrmMain.ShowEditInventoryItem(AId: Integer);
begin
  if AID = 0 then Exit;

  bpInventory.Visible := False;

//  if  DM.GetChoiceCelItem(AId) then
//    SwitchToForm(tiChoiceCelEdit, nil);
end;

// Сборка Узла / Лодки
procedure TfrmMain.ShowChoiceCelScan;
begin
  SwitchToForm(tiChoiceCelScan, nil);
end;

// переход на форму отображения информации
procedure TfrmMain.bInfoClick(Sender: TObject);
begin
  ShowInformation;
end;

procedure TfrmMain.bInventoryScanClick(Sender: TObject);
begin
  FScanType := 0;
  SwitchToForm(tiInventoryScan, nil);
end;

procedure TfrmMain.bInventoryScanModeClick(Sender: TObject);
begin
  FScanType := TSpinEditButton(Sender).Tag;
  SetInventoryScanButton;
  if FisOpenScanChangingMode then sbScanClick(Sender);
end;

procedure TfrmMain.bInventoryScanSearchClick(Sender: TObject);
begin
  TempEditInventory.Visible := True;
  TempEditInventory.SetFocus;
  TDialogService.InputQuery('Ввод № паспорта', ['№ паспорта'], [''], InputInventory);
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

procedure TfrmMain.bViewChoiceCelClick(Sender: TObject);
begin
  ShowChoiceCelList;
end;

procedure TfrmMain.bViewInventoryClick(Sender: TObject);
begin
  ShowInventoryList;
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

  if tcMain.ActiveTab = tiChoiceCelScan then
  begin
  //  DM.DownloadChoiceCelListTop;
  end else if tcMain.ActiveTab = tiChoiceCelList then
  begin
    ShowChoiceCelList;
  end else if tcMain.ActiveTab = tiInventoryScan then
  begin
  //  DM.DownloadInventoryTop;
  end else if tcMain.ActiveTab = tiInventoryList then
  begin
    ShowInventoryList;
  end;
end;

// Следующее сканирование
procedure TfrmMain.NextScan;
begin
  FChoiceCelId:= 0;
  FChoiceCelBarCode:= '';
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
  else if tcMain.ActiveTab <> tiScanBarCode then SwitchToForm(tiScanBarCode, nil);
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

procedure TfrmMain.lwChoiceCelListDblClick(Sender: TObject);
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  var Handled: Boolean;
      GestureEventInfo: TGestureEventInfo;
  {$ENDIF}
begin
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  Handled := False;
  lwChoiceCelListGesture(Sender, GestureEventInfo, Handled)
  {$ENDIF}
end;

procedure TfrmMain.lwChoiceCelListGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var I: Integer;
begin
  if ppActions.IsOpen or Handled then Exit;

  // Сскроем все
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // Редактирование
  if (tcMain.ActiveTab = tiChoiceCelList) and DM.cdsChoiceCelList.Active and not DM.cdsChoiceCelList.IsEmpty then
  begin
    btaCancel.Visible := True;
    btaEraseRecord.Visible := DM.cdsChoiceCelListErasedCode.AsInteger <> 10;
    btaUnEraseRecord.Visible := not btaEraseRecord.Visible;
    ppActions.Height := 2;
    for I := 0 to ComponentCount - 1 do
      if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      begin
        ppActions.Height := ppActions.Height + TButton(Components[I]).Height;
      end;
    ppActions.IsOpen := True;
  end;

end;

procedure TfrmMain.lwChoiceCelScanDblClick(Sender: TObject);
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  var Handled: Boolean;
      GestureEventInfo: TGestureEventInfo;
  {$ENDIF}
begin
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  Handled := False;
  lwChoiceCelScanGesture(Sender, GestureEventInfo, Handled)
  {$ENDIF}
end;

procedure TfrmMain.lwChoiceCelScanGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var I: Integer;
begin
  if ppActions.IsOpen or Handled then Exit;

  // Сскроем все
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // Редактирование
  if (tcMain.ActiveTab = tiChoiceCelScan) and DM.cdsChoiceCelListTop.Active and not DM.cdsChoiceCelListTop.IsEmpty then
  begin
    btaCancel.Visible := True;
    btaEraseRecord.Visible := True;
    ppActions.Height := 2;
    for I := 0 to ComponentCount - 1 do
      if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      begin
        ppActions.Height := ppActions.Height + TButton(Components[I]).Height;
      end;
    ppActions.IsOpen := True;
  end;
end;

procedure TfrmMain.lwInventoryListDblClick(Sender: TObject);
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  var Handled: Boolean;
      GestureEventInfo: TGestureEventInfo;
  {$ENDIF}
begin
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  Handled := False;
  lwInventoryListGesture(Sender, GestureEventInfo, Handled)
  {$ENDIF}
end;

procedure TfrmMain.lwInventoryListGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var I: Integer;
begin
  if ppActions.IsOpen or Handled then Exit;

  // Сскроем все
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // Редактирование
  if (tcMain.ActiveTab = tiInventoryList) and DM.cdsInventoryList.Active and not DM.cdsInventoryList.IsEmpty then
  begin
    btaCancel.Visible := True;
    btaEraseRecord.Visible := DM.cdsInventoryListErasedCode.AsInteger <> 10;
    btaUnEraseRecord.Visible := not btaEraseRecord.Visible;
    ppActions.Height := 2;
    for I := 0 to ComponentCount - 1 do
      if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      begin
        ppActions.Height := ppActions.Height + TButton(Components[I]).Height;
      end;
    ppActions.IsOpen := True;
  end;

end;

procedure TfrmMain.lwInventoryScanDblClick(Sender: TObject);
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  var Handled: Boolean;
      GestureEventInfo: TGestureEventInfo;
  {$ENDIF}
begin
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  Handled := False;
  lwInventoryScanGesture(Sender, GestureEventInfo, Handled)
  {$ENDIF}
end;

procedure TfrmMain.lwInventoryScanGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var I: Integer;
begin
  if ppActions.IsOpen or Handled then Exit;

  // Сскроем все
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // Редактирование
  if (tcMain.ActiveTab = tiInventoryScan) and DM.cdsInventoryListTop.Active and not DM.cdsInventoryListTop.IsEmpty then
  begin
    btaCancel.Visible := True;
    btaEraseRecord.Visible := DM.cdsInventoryListTopErasedCode.AsInteger <> 10;
    btaUnEraseRecord.Visible := not btaEraseRecord.Visible;
    ppActions.Height := 2;
    for I := 0 to ComponentCount - 1 do
      if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      begin
        ppActions.Height := ppActions.Height + TButton(Components[I]).Height;
      end;
    ppActions.IsOpen := True;
  end;
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
  Res: TArray<string>;
begin

  FDataWedgeBarCode.OnScanResult := Nil;

  try

    if gc_WebService = '' then
    begin
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
    end;

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

procedure TfrmMain.pbChoiceCelOrderByChange(Sender: TObject);
begin
  if DM.cdsChoiceCelList.Active then ShowChoiceCelList;
end;

procedure TfrmMain.pbInventoryOrderByChange(Sender: TObject);
begin
  if DM.cdsInventoryList.Active then ShowInventoryList;
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  ppActions.IsOpen := False;

  if (tcMain.ActiveTab = tiChoiceCelScan) then
  begin
    // Изменить позицию
    if TButton(Sender).Tag = 1 then
    begin
      ShowEditChoiceCelItem(DM.cdsChoiceCelListTopId.AsInteger);
    end else
    // Удаление позиции
    if TButton(Sender).Tag = 2 then
      TDialogService.MessageDialog('Удалить Места отбора'#13#10'Ячейка отбора = <' + DM.cdsChoiceCelListTopChoiceCellName.AsString + '>'#13#10 +
                                   'документ = <' + DM.cdsChoiceCelListTopInvNumber.AsString + '>'#13#10 +
                                   'вид товара <' + DM.cdsChoiceCelListTopGoodsKindName.AsString + '>'#13#10 +
                                   '<' + DM.cdsChoiceCelListTopGoodsName.AsString + '> ?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ErasedChoiceCelTop);
    // Востановление позиции
    if TButton(Sender).Tag = 3  then
    begin
      TDialogService.MessageDialog('Отменить удаление Места отбора'#13#10'Ячейка отбора = <' + DM.cdsChoiceCelListTopChoiceCellName.AsString + '>'#13#10 +
                                   'документ = <' + DM.cdsChoiceCelListTopInvNumber.AsString + '>'#13#10 +
                                   'вид товара <' + DM.cdsChoiceCelListTopGoodsKindName.AsString + '>'#13#10 +
                                   '<' + DM.cdsChoiceCelListTopGoodsName.AsString + '> ?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, UnErasedChoiceCelTop)
    end;
  end else if (tcMain.ActiveTab = tiChoiceCelList) then
  begin
    // Изменить позицию
    if TButton(Sender).Tag = 1 then
    begin
      ShowEditChoiceCelItem(DM.cdsChoiceCelListId.AsInteger);
    end else
    // Удаление позиции
    if TButton(Sender).Tag = 2 then
      TDialogService.MessageDialog('Удалить Места отбора'#13#10'Ячейка отбора = <' + DM.cdsChoiceCelListChoiceCellName.AsString + '>'#13#10 +
                                   'документ = <' + DM.cdsChoiceCelListInvNumber.AsString + '>'#13#10 +
                                   'вид товара <' + DM.cdsChoiceCelListGoodsKindName.AsString + '>'#13#10 +
                                   '<' + DM.cdsChoiceCelListGoodsName.AsString + '> ?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ErasedChoiceCelList)
    else
    // Востановление позиции
    if TButton(Sender).Tag = 3  then
    begin
      TDialogService.MessageDialog('Отменить удаление Места отбора'#13#10'Ячейка отбора = <' + DM.cdsChoiceCelListChoiceCellName.AsString + '>'#13#10 +
                                   'документ = <' + DM.cdsChoiceCelListInvNumber.AsString + '>'#13#10 +
                                   'вид товара <' + DM.cdsChoiceCelListGoodsKindName.AsString + '>'#13#10 +
                                   '<' + DM.cdsChoiceCelListGoodsName.AsString + '> ?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, UnErasedChoiceCelList)
    end  else
    // Удаление позиции
    if TButton(Sender).Tag = 2 then
      TDialogService.MessageDialog('Удалить Места отбора'#13#10'Ячейка отбора = <' + DM.cdsChoiceCelListTopChoiceCellName.AsString + '>'#13#10 +
                                   'документ = <' + DM.cdsChoiceCelListTopInvNumber.AsString + '>'#13#10 +
                                   'вид товара <' + DM.cdsChoiceCelListTopGoodsKindName.AsString + '>'#13#10 +
                                   '<' + DM.cdsChoiceCelListTopGoodsName.AsString + '> ?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ErasedChoiceCelTop);
    // Востановление позиции
    if TButton(Sender).Tag = 3  then
    begin
      TDialogService.MessageDialog('Отменить удаление Места отбора'#13#10'Ячейка отбора = <' + DM.cdsChoiceCelListTopChoiceCellName.AsString + '>'#13#10 +
                                   'документ = <' + DM.cdsChoiceCelListTopInvNumber.AsString + '>'#13#10 +
                                   'вид товара <' + DM.cdsChoiceCelListTopGoodsKindName.AsString + '>'#13#10 +
                                   '<' + DM.cdsChoiceCelListTopGoodsName.AsString + '> ?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, UnErasedChoiceCelTop)
    end;
  end else if (tcMain.ActiveTab = tiInventoryScan) then
  begin
    // Изменить позицию
    if TButton(Sender).Tag = 1 then
    begin
      ShowEditInventoryItem(DM.cdsInventoryListTopMovementItemId.AsInteger);
    end else
    // Удаление позиции
    if TButton(Sender).Tag = 2 then
      TDialogService.MessageDialog('Удалить ?'#13#10'(' + DM.cdsInventoryListTopGoodsCode.AsString + ') ' +
                                                          DM.cdsInventoryListTopGoodsName.AsString + #13#10 +
                                   'вид <' + DM.cdsInventoryListTopGoodsKindName.AsString + '>' + #13#10 +
                                   'вес нетто = <' + DM.cdsInventoryListTopAmount.AsString + '>'#13#10 +
                                   'партия = <' + DM.cdsInventoryListTopPartionGoodsDate.AsString + '>'#13#10 +
                                   '№ паспорта = <' + DM.cdsInventoryListTopPartionNum.AsString + '>'#13#10 +
                                   'ящиков = <' + DM.cdsInventoryListTopCountTare_calc.AsString + '>'#13#10 +
                                   '<' + DM.cdsInventoryListTopBoxName_1.AsString + '>'#13#10,
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ErasedInventoryTop);
    // Востановление позиции
    if TButton(Sender).Tag = 3  then
    begin
      TDialogService.MessageDialog('Отменить удаление ?'#13#10'(' + DM.cdsInventoryListTopGoodsCode.AsString + ') ' +
                                                                    DM.cdsInventoryListTopGoodsName.AsString + #13#10 +
                                   'вид <' + DM.cdsInventoryListTopGoodsKindName.AsString + '>' + #13#10 +
                                   'вес нетто = <' + DM.cdsInventoryListTopAmount.AsString + '>'#13#10 +
                                   'партия = <' + DM.cdsInventoryListTopPartionGoodsDate.AsString + '>'#13#10 +
                                   '№ паспорта = <' + DM.cdsInventoryListTopPartionNum.AsString + '>'#13#10 +
                                   'ящиков = <' + DM.cdsInventoryListTopCountTare_calc.AsString + '>'#13#10 +
                                   '<' + DM.cdsInventoryListTopBoxName_1.AsString + '>'#13#10,
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, UnErasedInventoryTop)
    end;
  end else if (tcMain.ActiveTab = tiInventoryList) then
  begin
    // Изменить позицию
    if TButton(Sender).Tag = 1 then
    begin
      ShowEditInventoryItem(DM.cdsInventoryListMovementItemId.AsInteger);
    end else
    // Удаление позиции
    if TButton(Sender).Tag = 2 then
      TDialogService.MessageDialog('Удалить ?'#13#10'(' + DM.cdsInventoryListGoodsCode.AsString + ') ' +
                                                          DM.cdsInventoryListGoodsName.AsString + #13#10 +
                                   'вид <' + DM.cdsInventoryListGoodsKindName.AsString + '>' + #13#10 +
                                   'вес нетто = <' + DM.cdsInventoryListAmount.AsString + '>'#13#10 +
                                   'партия = <' + DM.cdsInventoryListPartionGoodsDate.AsString + '>'#13#10 +
                                   '№ паспорта = <' + DM.cdsInventoryListPartionNum.AsString + '>'#13#10 +
                                   'ящиков = <' + DM.cdsInventoryListCountTare_calc.AsString + '>'#13#10 +
                                   'поддон = <' + DM.cdsInventoryListBoxName_1.AsString + '>',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ErasedInventoryList)
    else
    // Востановление позиции
    if TButton(Sender).Tag = 3  then
    begin
      TDialogService.MessageDialog('Отменить удаление ?'#13#10'(' + DM.cdsInventoryListGoodsCode.AsString + ') ' +
                                                                    DM.cdsInventoryListGoodsName.AsString + #13#10 +
                                   'вид <' + DM.cdsInventoryListGoodsKindName.AsString + '>' + #13#10 +
                                   'вес нетто = <' + DM.cdsInventoryListAmount.AsString + '>'#13#10 +
                                   'партия = <' + DM.cdsInventoryListPartionGoodsDate.AsString + '>'#13#10 +
                                   '№ паспорта = <' + DM.cdsInventoryListPartionNum.AsString + '>'#13#10 +
                                   'ящиков = <' + DM.cdsInventoryListCountTare_calc.AsString + '>'#13#10 +
                                   '<' + DM.cdsInventoryListBoxName_1.AsString + '>',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, UnErasedInventoryList)
    end;
  end;

  if (TButton(Sender).Tag = 7) and sbBack.Visible  then sbBackClick(Sender);
end;

procedure TfrmMain.rbWebServerClick(Sender: TObject);
  var I: Integer;
      Res: TArray<string>;
begin
  ppWebServer.IsOpen := False;
  FPasswordLabelClick := 0;

  while pbWebServer.Items.Count > 1 do pbWebServer.Items.Delete(1);

  Res := TRegEx.Split(WebServer, ';');

  for I := Low(Res) to High(Res) do pbWebServer.Items.Add(Res[I]);
  pbWebServer.ItemIndex := 0;
end;

// Обработка Места отбора
procedure TfrmMain.ProcessChoiceCel(ABarCode: String);
begin

  FChoiceCelId := 0;
  FChoiceCelBarCode := '';
  if Trim(ABarCode) = '' then Exit;

  if DM.DownloadChoiceCelBarCode(ABarCode) then
  begin

    if DM.cdsChoiceCelEdit.RecordCount = 0 then
    begin
      TDialogService.ShowMessage('По коду или штрих коду '#13#10#13#10 + ABarCode + #13#10#13#10'Место отбора не найден');
    end else if DM.cdsChoiceCelEdit.RecordCount > 1 then
    begin
      TDialogService.ShowMessage('По коду или штрих коду '#13#10#13#10 + ABarCode + #13#10#13#10'Найдено более одно Место отбора.');
    end;

    FChoiceCelId := DM.cdsChoiceCelEditChoiceCellId.AsInteger;
    FChoiceCelBarCode := Trim(ABarCode);

    if FChoiceCelId <> 0 then
    begin
      if FScanType <> 3 then
      begin
        SwitchToForm(tiChoiceCelEdit, nil);
      end else
      begin
        ChoiceCelConfirm(mrYes);
        DM.DownloadChoiceCelListTop;
        NextScan;
      end;
    end else if FScanType = 3 then NextScan;
  end;
end;

// Заполнение ящиков
procedure TfrmMain.AddlvBox(AName, ACount, AWeight: String);
begin
  with TListViewItem(TAppearanceListViewItems(lvBox.Items.AddItem(0))) do
  begin
    Data['Name'] := AName;
    Data['Count'] := ACount;
    Data['Weight'] := AWeight;
  end;
end;

// Обработка Инвентаризации
procedure TfrmMain.ProcessInventory(ABarCode: String);
begin

  FInventoryMovementItemId := 0;
  FInventoryBarCode := '';
  if Trim(ABarCode) = '' then Exit;

  if DM.DownloadInventoryBarCode(ABarCode) then
  begin

    if DM.cdsInventoryEdit.RecordCount = 0 then
    begin
      TDialogService.ShowMessage('По коду или штрих коду '#13#10#13#10 + ABarCode + #13#10#13#10'Место отбора не найден');
    end else if DM.cdsInventoryEdit.RecordCount > 1 then
    begin
      TDialogService.ShowMessage('По коду или штрих коду '#13#10#13#10 + ABarCode + #13#10#13#10'Найдено более одно Место отбора.');
    end;

    FInventoryMovementItemId := DM.cdsInventoryEditMovementItemId.AsInteger;
    FInventoryBarCode := Trim(ABarCode);

    if FInventoryMovementItemId <> 0 then
    begin
      if FScanType <> 3 then
      begin
        SwitchToForm(tiInventoryEdit, nil);
        lvBox.Items.Clear;
        if dm.cdsInventoryEditWeightTare_5.AsInteger > 0 then
          AddlvBox(dm.cdsInventoryEditBoxName_5.AsString, dm.cdsInventoryEditCountTare_5.AsString, dm.cdsInventoryEditWeightTare_5.AsString);
        if dm.cdsInventoryEditWeightTare_4.AsInteger > 0 then
          AddlvBox(dm.cdsInventoryEditBoxName_4.AsString, dm.cdsInventoryEditCountTare_4.AsString, dm.cdsInventoryEditWeightTare_4.AsString);
        if dm.cdsInventoryEditWeightTare_3.AsInteger > 0 then
          AddlvBox(dm.cdsInventoryEditBoxName_3.AsString, dm.cdsInventoryEditCountTare_3.AsString, dm.cdsInventoryEditWeightTare_3.AsString);
        AddlvBox(dm.cdsInventoryEditBoxName_2.AsString, dm.cdsInventoryEditCountTare_2.AsString, dm.cdsInventoryEditWeightTare_2.AsString);
        AddlvBox(dm.cdsInventoryEditBoxName_1.AsString, dm.cdsInventoryEditCountTare_1.AsString, dm.cdsInventoryEditWeightTare_1.AsString);
      end else
      begin
        InventoryConfirm(mrYes);
        DM.DownloadInventoryListTop;
        NextScan;
      end;
    end else if FScanType = 3 then NextScan;
  end;
end;

// Обрабатываем отсканированный
procedure TfrmMain.OnScanChoiceCel(Sender: TObject; AData_String: String);
begin
  FisScanOk := True;
  ProcessChoiceCel(AData_String);
end;

// Обрабатываем отсканированный
procedure TfrmMain.OnScanInventory(Sender: TObject; AData_String: String);
begin
  FisScanOk := True;
  ProcessInventory(AData_String);
end;

end.
