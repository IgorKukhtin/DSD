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
  FMX.ListView, uDM, FMX.Media,  Winsoft.FireMonkey.Obr, System.ImageList, FMX.ImgList,
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
    tiInventory: TTabItem;
    Panel2: TPanel;
    Label11: TLabel;
    edInventoryInvNumber: TEdit;
    edInventoryStatus: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    edInventoryUnit: TEdit;
    edInventoryOperDate: TEdit;
    imInventoryStatus: TImage;
    BindSourceDB2: TBindSourceDB;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    BindSourceDB3: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    tiInventoryScan: TTabItem;
    tiGoods: TTabItem;
    pGoods: TPanel;
    lwGoods: TListView;
    BindSourceDB4: TBindSourceDB;
    LinkListControlToField3: TLinkListControlToField;
    bGoodsChoice: TSpeedButton;
    Image13: TImage;
    Panel3: TPanel;
    bInventScanSearch: TSpeedButton;
    lwInventoryScan: TListView;
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
    tiProductionUnionEdit: TTabItem;
    lGoodsSelect: TLabel;
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
    tiInventoryItemEdit: TTabItem;
    bInventScanAmount: TSpeedButton;
    bInventScanMode: TSpeedButton;
    edIIEGoodsGroup: TEdit;
    Label14: TLabel;
    edIIEPartnerName: TEdit;
    Label15: TLabel;
    edIIEArticle: TEdit;
    Label16: TLabel;
    edIIEGoodsCode: TEdit;
    Label25: TLabel;
    Label26: TLabel;
    edIIEAmountDiff: TEdit;
    Label27: TLabel;
    edIIEAmountRemains: TEdit;
    Label28: TLabel;
    edIIETotalCountEnter: TEdit;
    Label29: TLabel;
    edIIEAmount: TEdit;
    Label30: TLabel;
    edIIEPartionCell: TEdit;
    Label32: TLabel;
    edIIEPartNumber: TEdit;
    Label33: TLabel;
    bIIEOk: TButton;
    bIIECancel: TButton;
    BindSourceDB7: TBindSourceDB;
    LinkControlToField11: TLinkControlToField;
    LinkControlToField12: TLinkControlToField;
    LinkControlToField13: TLinkControlToField;
    LinkControlToField14: TLinkControlToField;
    LinkControlToField16: TLinkControlToField;
    LinkControlToField17: TLinkControlToField;
    LinkControlToField18: TLinkControlToField;
    LinkControlToField20: TLinkControlToField;
    LinkControlToField21: TLinkControlToField;
    pInventoryItemEdit: TPanel;
    tiDictList: TTabItem;
    Panel5: TPanel;
    bDictChoice: TSpeedButton;
    Image23: TImage;
    lDictListSelect: TLabel;
    lwDictList: TListView;
    BindSourceDB8: TBindSourceDB;
    LinkListControlToField5: TLinkListControlToField;
    bIIEOpenDictPartionCell: TEditButton;
    Image25: TImage;
    lMain: TLayout;
    lAddConfig: TLayout;
    Label34: TLabel;
    bIIEOpenDictGoods: TEditButton;
    Image26: TImage;
    bViewInventory: TSpeedButton;
    bInventScanSN: TSpeedButton;
    ppActions: TPopup;
    RectangleActions: TRectangle;
    rbWebServerTest: TRadioButton;
    rbWebServerMain: TRadioButton;
    edIIEGoodsName: TMemo;
    LinkControlToField1: TLinkControlToField;
    Edit1: TEdit;
    pbILErased: TPopupBox;
    pbILAllUser: TPopupBox;
    pbILOrderBy: TPopupBox;
    llwInventoryList: TLabel;
    TimerRefresh: TTimer;
    LinkControlToField15: TLinkControlToField;
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
    lwInventoryList: TListView;
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
    Layout14: TLayout;
    Label18: TLabel;
    cbDictGoodsArticle: TCheckBox;
    cbDictCode: TCheckBox;
    cbDictGoodsEAN: TCheckBox;
    cbDictGoodsCode: TCheckBox;
    bInventScanNull: TSpeedButton;
    tiSendScan: TTabItem;
    Panel6: TPanel;
    bSendScanSearch: TSpeedButton;
    bSendScanAmount: TSpeedButton;
    bSendScanMode: TSpeedButton;
    bViewSend: TSpeedButton;
    bSendScanSN: TSpeedButton;
    bSendScanNull: TSpeedButton;
    lwSendScan: TListView;
    tiSendItemEdit: TTabItem;
    Panel7: TPanel;
    edSIEAmountRemains: TEdit;
    edSIEArticle: TEdit;
    edSIEGoodsCode: TEdit;
    edSIEGoodsGroup: TEdit;
    edSIEAmount: TEdit;
    edSIEPartionCell: TEdit;
    bSIEOpenDictPartionCell: TEditButton;
    Image10: TImage;
    edSIEPartnerName: TEdit;
    edSIEPartNumber: TEdit;
    edSIETotalCountEnter: TEdit;
    Label19: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    bSIECancel: TButton;
    bSIEOk: TButton;
    edSIEGoodsName: TMemo;
    Edit12: TEdit;
    bSIEOpenDictGoods: TEditButton;
    Image11: TImage;
    BindSourceDB9: TBindSourceDB;
    LinkControlToField19: TLinkControlToField;
    LinkControlToField22: TLinkControlToField;
    LinkControlToField23: TLinkControlToField;
    LinkControlToField24: TLinkControlToField;
    LinkControlToField25: TLinkControlToField;
    LinkControlToField26: TLinkControlToField;
    LinkControlToField27: TLinkControlToField;
    LinkControlToField28: TLinkControlToField;
    LinkControlToField29: TLinkControlToField;
    LinkControlToField30: TLinkControlToField;
    edSIEFromName: TEdit;
    bSIEFromName: TEditButton;
    Image14: TImage;
    Label39: TLabel;
    edSIEToName: TEdit;
    bSIEToName: TEditButton;
    Image15: TImage;
    Label45: TLabel;
    LinkControlToField31: TLinkControlToField;
    LinkControlToField32: TLinkControlToField;
    tiSendList: TTabItem;
    lwSendList: TListView;
    Panel8: TPanel;
    pbSLErased: TPopupBox;
    pbSLAllUser: TPopupBox;
    pbSLOrderBy: TPopupBox;
    llwSendList: TLabel;
    BindSourceDB10: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    BindSourceDB11: TBindSourceDB;
    LinkListControlToField6: TLinkListControlToField;
    edSIEInvNumber_OrderClient: TEdit;
    Label46: TLabel;
    LinkControlToField33: TLinkControlToField;
    edSSInvNumber_OrderClient: TEdit;
    Label47: TLabel;
    Panel9: TPanel;
    bSendScanClear: TSpeedButton;
    Image16: TImage;
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
    tiOrderInternalChoice: TTabItem;
    Panel4: TPanel;
    bOrderInternalChoice: TSpeedButton;
    Image17: TImage;
    lOrderInternalChoice: TLabel;
    lwOrderInternalChoice: TListView;
    LinkListControlToField9: TLinkListControlToField;
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
    procedure ShowGoods;
    procedure ShowDictList(ADictType : TDictType);
    procedure ShowOrderInternalChoice;
    procedure ShowSendScan;
    procedure ShowProductionUnionScan;
    procedure ShowInventoryScan;
    procedure ShowInventory;
    procedure ShowInventoryItemEdit;
    procedure ShowSendItemEdit;
    procedure ShowProductionUnionList;
    procedure ShowSend;
    procedure ShowEditInventoryItemEdit;
    procedure ShowEditInventoryListEdit;
    procedure ShowEditSendItemEdit;
    procedure ShowEditSendListEdit;
    procedure ShowEditProductionUnionItem(AId: Integer);
    procedure bInfoClick(Sender: TObject);
    procedure sbScanClick(Sender: TObject);
    procedure OnScanResultDetails(Sender: TObject; AAction, ASource, ALabel_Type, AData_String: String);
    procedure OnScanResultLogin(Sender: TObject; AData_String: String);
    procedure OnScanResultGoods(Sender: TObject; AData_String: String);
    procedure OnScanResultInventoryScan(Sender: TObject; AData_String: String);
    procedure OnScanResultSendScan(Sender: TObject; AData_String: String);
    procedure OnScanProductionUnion(Sender: TObject; AData_String: String);
    procedure bLogInClick(Sender: TObject);
    procedure bUpdateProgramClick(Sender: TObject);
    procedure CameraScanBarCodeSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure OnObrBarcodeDetected(Sender: TObject);
    procedure sbIlluminationModeClick(Sender: TObject);
    procedure bGoodsClick(Sender: TObject);
    procedure bGoodsRefreshClick(Sender: TObject);
    procedure bGoodsChoiceClick(Sender: TObject);
    procedure bInventScanSearchClick(Sender: TObject);
    procedure ed�mountChangeTracking(Sender: TObject);
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

    procedure SetisDictGoodsArticle(Values : boolean);
    procedure SetisDictGoodsCode(Values : boolean);
    procedure SetisDictGoodsEAN(Values : boolean);
    procedure SetisDictCode(Values : boolean);

    procedure b0Click(Sender: TObject);
    procedure bDotClick(Sender: TObject);
    procedure bClearAmountClick(Sender: TObject);
    procedure bEnterAmountClick(Sender: TObject);
    procedure bAddAmountClick(Sender: TObject);
    procedure bMinusAmountClick(Sender: TObject);
    procedure bUploadClick(Sender: TObject);
    procedure bProductionUnionScanClick(Sender: TObject);
    procedure lwDictListSearchChange(Sender: TObject);
    procedure lwGoodsSearchChange(Sender: TObject);
    procedure lwInventorySearchListChange(Sender: TObject);
    procedure cbSearchTypeGoodsChange(Sender: TObject);
    procedure pPasswordClick(Sender: TObject);
    procedure bpProductionUnionClick(Sender: TObject);
    procedure bInventScanModeClick(Sender: TObject);
    procedure bIIECancelClick(Sender: TObject);
    procedure bIIEOkClick(Sender: TObject);
    procedure bIIEOpenDictPartionCellClick(Sender: TObject);
    procedure bDictChoiceClick(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure bIIEOpenDictGoodsClick(Sender: TObject);
    procedure bViewInventoryClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure rbWebServerClick(Sender: TObject);
    procedure pbILErasedChange(Sender: TObject);
    procedure TimerRefreshTimer(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure TimerInfoViewTimer(Sender: TObject);
    procedure lwInventoryListGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lwInventoryListDblClick(Sender: TObject);
    procedure lwInventoryScanDblClick(Sender: TObject);
    procedure lwInventoryScanGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lwDictListGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lwGoodsGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lwDictListDblClick(Sender: TObject);
    procedure lwGoodsDblClick(Sender: TObject);
    procedure sbRefreshClick(Sender: TObject);
    procedure lwInventoryListFilter(Sender: TObject; const AFilter,
      AValue: string; var Accept: Boolean);
    procedure lwGoodsFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure lwDictListFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure bSendScanClick(Sender: TObject);
    procedure bInventoryScanClick(Sender: TObject);
    procedure bSendScanSearchClick(Sender: TObject);
    procedure bSendScanModeClick(Sender: TObject);
    procedure bSIEOpenDictPartionCellClick(Sender: TObject);
    procedure bSIEOpenDictGoodsClick(Sender: TObject);
    procedure bSIECancelClick(Sender: TObject);
    procedure bSIEOkClick(Sender: TObject);
    procedure bSIEFromNameClick(Sender: TObject);
    procedure bSIEToNameClick(Sender: TObject);
    procedure bViewSendClick(Sender: TObject);
    procedure lwSendListDblClick(Sender: TObject);
    procedure lwSendListFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure lwSendListGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lwSendScanDblClick(Sender: TObject);
    procedure lwSendScanGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure pbSLOrderByChange(Sender: TObject);
    procedure edSSInvNumber_OrderClientClick(Sender: TObject);
    procedure bSendScanClearClick(Sender: TObject);
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
    procedure lwOrderInternalChoiceFilter(Sender: TObject; const AFilter,
      AValue: string; var Accept: Boolean);
    procedure lwOrderInternalChoiceGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure lwOrderInternalChoiceDblClick(Sender: TObject);
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
    FisTestWebServer: boolean;
    FPasswordLabelClick: Integer;
    FINIFile: string;
    FPermissionState: boolean;
    // ���� ������ Zebra
    FisZebraScaner: boolean;
    // ������������ � ����� ������ ������ ����������
    FisCameraScaner: boolean;
    // ��������� ������ ��� ��������� ������
    FisOpenScanChangingMode: boolean;
    // �������� ������ ���������
    FisHideIlluminationButton: boolean;
    // �������� ������ ������������ ����� ���� �������
    FisHideScanButton: boolean;

    // ������ � ����������� �������������
    // �������
    FisDictGoodsArticle: Boolean;
    // Interne Nr (Code)
    FisDictGoodsCode: Boolean;
    // Interne Nr
    FisDictGoodsEAN: Boolean;

    // ***** ������ � ��������� ������������
    // Interne Nr (Code)
    FisDictCode: Boolean;


    // ��������� ����� ���� �������
    FisBecomeForeground: Boolean;
    FDateDownloadDict: TDateTime;

    // ��� ������������
    FScanType : Integer;
    FisNextScan : Boolean;
    FisScanOk : Boolean;
    FGoodsId: Integer;

    FDictUpdateId: Integer;
    FDictUpdateDataSet: TDataSet;
    FDictUpdateField: String;

    FDataSetRefresh: TDataSetRefresh;

    FIsUpdate: Boolean;
    FOldControl: TControl;
    FCuurControl: TControl;

    // ���������
    FBarCodePref: String;
    FDocBarCodePref: String;
    FItemBarCodePref: String;
    FArticleSeparators: String;
    FCaptionFontSize: Single;

    // ���������� ��������
    FActiveTabPrew: TTabItem;

    // ����� ����������
    FOrderClientId: Integer;
    FOrderClientInvNumber: String;
    FOrderClientInvNumberFull: String;

    // ����� ������������
    FOrderInternal: Integer;
    FProductionUnion: Integer;

    {$IF DEFINED(iOS) or DEFINED(ANDROID)}
    procedure CalcContentBoundsProc(Sender: TObject;
                                    var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
    {$ENDIF}
    procedure SwitchToForm(const TabItem: TTabItem; const Data: TObject);
    procedure ReturnPriorForm(const OmitOnChange: Boolean = False);
    procedure DeleteInventoryGoods(const AResult: TModalResult);
    procedure ErasedInventoryList(const AResult: TModalResult);
    procedure UnErasedInventoryList(const AResult: TModalResult);
    procedure DeleteSendGoods(const AResult: TModalResult);
    procedure ErasedSendList(const AResult: TModalResult);
    procedure UnErasedSendList(const AResult: TModalResult);
    procedure BackInventoryScan(const AResult: TModalResult);
    procedure DownloadDict(const AResult: TModalResult);
    procedure UploadAllData(const AResult: TModalResult);
    procedure CreateInventory(const AResult: TModalResult);
    procedure ProductionUnionInsert(const AResult: TModalResult);
    procedure ProductionUnionOpen(const AResult: TModalResult);
    procedure DeleteProductionUnionGoods(const AResult: TModalResult);
    procedure ErasedProductionUnionList(const AResult: TModalResult);
    procedure UnErasedProductionUnionList(const AResult: TModalResult);
    procedure NoBarCodeNextScan(const AResult: TModalResult);

    procedure InputOrderClient(const AResult: TModalResult; const AValues: array of string);

    {$IF DEFINED(ANDROID)}
    function HandleAppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
    {$ENDIF}

    procedure Wait(AWait: Boolean);
  public
    { Public declarations }
    procedure SetInventScanButton;
    procedure SetSendScanButton;
    procedure SetProductionUnionScanButton;
    { ����� ������������� �� ��������� }
    function SearchByBarcode(AData_String: String) : Integer;
    procedure ProcessOrderInternal(ID: Integer);

    procedure NextScan;

    property DateDownloadDict: TDateTime read FDateDownloadDict write SetDateDownloadDict;
    property BarCodePref: String read FBarCodePref write SetBarCodePref;
    property DocBarCodePref: String read FDocBarCodePref write SetDocBarCodePref;
    property ItemBarCodePref: String read FItemBarCodePref write SetItemBarCodePref;
    property ArticleSeparators: String read FArticleSeparators write SetArticleSeparators;

    // ������������ � ����� ������ ������ ����������
    property isCameraScaner: boolean read FisCameraScaner write SetisCameraScaner;
    // ��������� ������ ��� ��������� ������
    property isOpenScanChangingMode: boolean read FisOpenScanChangingMode write SetisOpenScanChangingMode;
    // �������� ������ ���������
    property isHideIlluminationButton: boolean read FisHideIlluminationButton write SetisHideIlluminationButton;
    // �������� ������ ������������ ����� ���� �������
    property isHideScanButton: boolean read FisHideScanButton write SetisHideScanButton;
    // ��������� �������� ��� ������ ������������
    property isIlluminationMode: boolean read GetisIlluminationMode write SetisIlluminationMode;

    // ������ � ����������� �������������
    // �������
    property isDictGoodsArticle: Boolean read FisDictGoodsArticle write SetisDictGoodsArticle;
    // Interne Nr (Code)
    property isDictGoodsCode: Boolean read FisDictGoodsCode write SetisDictGoodsCode;
    // Interne Nr
    property isDictGoodsEAN: Boolean read FisDictGoodsEAN write SetisDictGoodsEAN;

    // ����� ����������
    property OrderClientId: Integer read FOrderClientId;
    property OrderClientInvNumber: String read FOrderClientInvNumber;
    property OrderClientInvNumberFull: String read FOrderClientInvNumberFull;

    // ***** ������ � ��������� ������������
    // Interne Nr (Code)
    property isDictCode: Boolean read FisDictCode write SetisDictCode;

  end;

var
  frmMain: TfrmMain;

implementation

uses System.IOUtils, System.Math, System.RegularExpressions, FMX.SearchBox, FMX.Authentication, FMX.Storage,
     FMX.CommonData, FMX.CursorUtils;

{$R *.fmx}

var  ScanThread: TThread;
     ScanDATA: String;
     ScanSymbologyName: String;

const
  WebServer : string = 'Internal - http://291.168.0.50/projectBoat_utf8/index.php;External - http://217.92.58.239:11011/projectBoat_utf8/index.php';
  WebServerTest : string = 'External - http://in.mer-lin.org.ua/projectboat_test/index.php';
  MainWidth = 336;

type
  { ����� ��� ��������� ��������� }
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

// ������� ����� �/�� ����� ��������
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
  FDataSetRefresh := dsrNone;
  FBarCodePref := '0000';
  FDocBarCodePref := '2230';
  FItemBarCodePref := '2240';
  FOrderClientId := 0;
  FOrderClientInvNumber := '';
  FOrderClientInvNumberFull := '';
  nWebServer:= 0;


  GetSearshBox(lwDictList).OnChangeTracking := lwDictListSearchChange;
  GetSearshBox(lwGoods).OnChangeTracking := lwGoodsSearchChange;
  GetSearshBox(lwInventoryList).OnChangeTracking := lwInventorySearchListChange;

  bInventScanMode.StyledSettings := [TStyledSetting.Family];
  bInventScanAmount.StyledSettings := [TStyledSetting.Family];
  bInventScanSN.StyledSettings := [TStyledSetting.Family];
  bInventScanNull.StyledSettings := [TStyledSetting.Family];
  bInventScanSearch.StyledSettings := [TStyledSetting.Family];
  bViewInventory.StyledSettings := [TStyledSetting.Family];

  bSendScanMode.StyledSettings := [TStyledSetting.Family];
  bSendScanAmount.StyledSettings := [TStyledSetting.Family];
  bSendScanSN.StyledSettings := [TStyledSetting.Family];
  bSendScanNull.StyledSettings := [TStyledSetting.Family];
  bSendScanSearch.StyledSettings := [TStyledSetting.Family];
  bViewSend.StyledSettings := [TStyledSetting.Family];

  FFormsStack := TStack<TFormStackItem>.Create;

  FDataWedgeBarCode := TDataWedgeBarCode.Create(Nil);
  FCaptionFontSize := lCaption.TextSettings.Font.Size;

  // �������� ������� �������
  {$IF DEFINED(ANDROID)}
  FisZebraScaner := Pos('Zebra', JStringToString(TJBuild.JavaClass.MANUFACTURER)) > 0;
  {$ELSE}
  FisZebraScaner := False;
  {$ENDIF}

  // ��������� ����������
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

  // ��������� �������� �� ini �����
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  FINIFile := TPath.Combine(TPath.GetDocumentsPath, 'settings.ini');
  {$ELSE}
  FINIFile := TPath.Combine(ExtractFilePath(ParamStr(0)), 'settings.ini');
  {$ENDIF}

  SettingsFile := TIniFile.Create(FINIFile);
  try
    LoginEdit.Text := SettingsFile.ReadString('LOGIN', 'USERNAME', '');
    FisTestWebServer := SettingsFile.ReadBool('Params', 'isTestWebServer', False);

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

    FisDictGoodsArticle := SettingsFile.ReadBool('Params', 'isDictGoodsArticle', True);
    FisDictGoodsCode := SettingsFile.ReadBool('Params', 'isDictGoodsCode', False);
    FisDictGoodsEAN := SettingsFile.ReadBool('Params', 'isDictGoodsEAN', False);
    FisDictCode := SettingsFile.ReadBool('Params', 'isDictCode', False);

    nWebServer := SettingsFile.ReadInteger('Params', 'WebServer', nWebServer);

  finally
    FreeAndNil(SettingsFile);
  end;

  if FisTestWebServer then Res := TRegEx.Split(WebServerTest, ';')
  else Res := TRegEx.Split(WebServer, ';');

  for I := Low(Res) to High(Res) do pbWebServer.Items.Add(Res[I]);

  if pbWebServer.Items.Count > nWebServer then pbWebServer.ItemIndex := nWebServer
  else pbWebServer.ItemIndex := 0;

  if FisTestWebServer then
    PasswordLabel.Text := '������ (�������� ������)'
  else PasswordLabel.Text := '������';

  FPermissionState := True;
  // ��������� ������������� ��������� ������ ��������
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
  begin
    OrientSet := [TScreenOrientation.Portrait];
    ScreenService.SetSupportedScreenOrientations(OrientSet);
  end;
  // ������� ������ ��� ����������
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
    FIsUpdate := DM.IsUpdate;
    DM.IsUpdate := False;
    FOldControl := FCuurControl;
    FCuurControl := ActiveControl;
  end;
end;

procedure TfrmMain.SetDateDownloadDict(Values : TDateTime);
  var SettingsFile : TIniFile;
begin
  // �������� � ini �����
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
  // �������� � ini �����
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
  // �������� � ini �����
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
  // �������� � ini �����
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
  // �������� � ini �����
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
  // �������� � ini �����
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
  // �������� � ini �����
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
  // �������� � ini �����
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
  // �������� � ini �����
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
  // �������� � ini �����
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FDataWedgeBarCode.isIllumination := Values;
    SettingsFile.WriteBool('DataWedge', 'isIlluminationMode', FDataWedgeBarCode.isIllumination);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.SetisDictGoodsArticle(Values : boolean);
  var SettingsFile : TIniFile;
begin
  // �������� � ini �����
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FisDictGoodsArticle := Values;
    SettingsFile.WriteBool('Params', 'isDictGoodsArticle', FisDictGoodsArticle);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.SetisDictGoodsCode(Values : boolean);
  var SettingsFile : TIniFile;
begin
  // �������� � ini �����
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FisDictGoodsCode := Values;
    SettingsFile.WriteBool('Params', 'isDictGoodsCode', FisDictGoodsCode);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.SetisDictGoodsEAN(Values : boolean);
  var SettingsFile : TIniFile;
begin
  // �������� � ini �����
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FisDictGoodsEAN := Values;
    SettingsFile.WriteBool('Params', 'isDictGoodsEAN', FisDictGoodsEAN);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.SetisDictCode(Values : boolean);
  var SettingsFile : TIniFile;
begin
  // �������� � ini �����
  SettingsFile := TIniFile.Create(FINIFile);
  try
    FisDictCode := Values;
    SettingsFile.WriteBool('Params', 'isDictCode', FisDictCode);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

procedure TfrmMain.bDictChoiceClick(Sender: TObject);
begin
  if DM.qurDictList.IsEmpty then Exit;

  if Assigned(FDictUpdateDataSet) and (FDictUpdateField <> '') then
  begin

    FDictUpdateDataSet.Edit;
    if Assigned(FDictUpdateDataSet.Fields.FindField(FDictUpdateField + 'Id')) then
      FDictUpdateDataSet.FieldByName(FDictUpdateField + 'Id').AsVariant := DM.qurDictListId.AsVariant;
    if Assigned(FDictUpdateDataSet.Fields.FindField(FDictUpdateField + 'Code')) then
      FDictUpdateDataSet.FieldByName(FDictUpdateField + 'Code').AsVariant := DM.qurDictListCode.AsVariant;
    if Assigned(FDictUpdateDataSet.Fields.FindField(FDictUpdateField + 'Name')) then
      FDictUpdateDataSet.FieldByName(FDictUpdateField + 'Name').AsVariant := DM.qurDictListName.AsVariant;
    FDictUpdateDataSet.Post;
    sbBackClick(Sender);

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

// ���� ����� (��� �������������� ���������� �������������)
procedure TfrmMain.b0Click(Sender: TObject);
begin
  if lAmount.Text = '0' then
    lAmount.Text := '';

  lAmount.Text := lAmount.Text + TButton(Sender).Text;
end;

// ������� ���������� �������������
procedure TfrmMain.bClearAmountClick(Sender: TObject);
begin
  lAmount.Text := '0';
end;

procedure TfrmMain.bAddAmountClick(Sender: TObject);
begin
//  if tcMain.ActiveTab = tiInventoryScan then DM.UpdateInventoryGoods(DM.qryInventoryGoodsAmount.AsFloat + StrToFloatDef(lAmount.Text, 0));

  ppEnterAmount.IsOpen := false;
end;

// ��������� ���������� ������������� �� ��������� �����
procedure TfrmMain.bMinusAmountClick(Sender: TObject);
begin
//  if tcMain.ActiveTab = tiInventoryScan then DM.UpdateInventoryGoods(DM.qryInventoryGoodsAmount.AsFloat - StrToFloatDef(lAmount.Text, 0));

  ppEnterAmount.IsOpen := false;
end;

procedure TfrmMain.bOrderInternalChoiceClick(Sender: TObject);
  var Id: Integer;
begin
  if DM.cdsOrderInternalChoice.IsEmpty then Exit;
  Id := DM.cdsOrderInternalChoiceID.AsInteger;
  sbBackClick(Sender);
  ProcessOrderInternal(Id);
end;

// ������ ���� / �����
procedure TfrmMain.bProductionUnionScanClick(Sender: TObject);
begin
  FScanType := 0;
  ShowProductionUnionScan;
end;

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
  ShowOrderInternalChoice;
  bOrderInternalChoice.Visible := True;
end;

// ���������� ���������� �������������
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
  if (AResult = mrYes) and (FOrderInternal <> 0) then
  begin
    try
      if DM.InsertProductionUnion(FOrderInternal, ScanId) then
      begin
        if tcMain.ActiveTab = tiProductionUnionEdit then ReturnPriorForm;
        if DM.cdsProductionUnionItemEdit.Active then
        begin
          bpProductionUnion.Visible := False;
          if FisNextScan and FisScanOk and not FisZebraScaner then
          begin
            DM.cdsProductionUnionItemEdit.Close;
            NextScan;
          end else DM.GetProductionUnionItem(ScanId)
        end else if FScanType <> 3 then
          ShowEditProductionUnionItem(ScanId);
      end;
    except
      on E : Exception do
      begin
        TDialogService.ShowMessage('������ �������� ������ ����/�����'+#13#10 + GetTextMessage(E));
      end;
    end;
  end;
end;

procedure TfrmMain.ProductionUnionOpen(const AResult: TModalResult);
begin
  if (FProductionUnion <> 0) and (FScanType <> 3) then
    ShowEditProductionUnionItem(FProductionUnion)
  else NextScan;
end;

procedure TfrmMain.DeleteProductionUnionGoods(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.SetErasedProductionUnion(DM.cdsProductionUnionListTop);
    DM.DownloadProductionUnionListTop;
  end;
end;

procedure TfrmMain.ErasedProductionUnionList(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.SetErasedProductionUnion(DM.cdsProductionUnionList);
  end;
end;

procedure TfrmMain.UnErasedProductionUnionList(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.CompleteProductionUnion(DM.cdsProductionUnionList);
  end;
end;

procedure TfrmMain.NoBarCodeNextScan(const AResult: TModalResult);
begin
  NextScan;
end;

// ������������ ��������� ������
procedure TfrmMain.bpProductionUnionCancelClick(Sender: TObject);
begin
  DM.cdsProductionUnionItemEdit.Close;
  ReturnPriorForm;
end;

procedure TfrmMain.bpProductionUnionClick(Sender: TObject);
begin
  TDialogService.MessageDialog('����������� �������� ������ ����/�����?',
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ProductionUnionInsert)
end;

// ������� �� �������� ����� � ����������� � � ���� ����������� ����
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

procedure TfrmMain.TimerRefreshTimer(Sender: TObject);
begin
  TimerRefresh.Enabled := False;
  case FDataSetRefresh of
    dsrDict :
      begin
        DM.FilterDict := GetSearshBox(lwDictList).Text;
        DM.LoadDictList;
      end;
    dsrGoods :
      begin
        DM.FilterGoods := GetSearshBox(lwGoods).Text;
        DM.LoadGoodsList;
      end;
    dsrInventoryList : ShowInventory;
  end;
  FDataSetRefresh := dsrNone;
end;

procedure TfrmMain.TimerTorchModeTimer(Sender: TObject);
begin
  TimerTorchMode.Enabled := False;
  if ScanCamera.HasFlash and isIlluminationMode then
    ScanCamera.TorchMode := TTorchMode.ModeOn;
end;

// ������� �� ���������� ����� �� ����� ����������� ����, � ��������� � �� �����
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

// ��������� ��������� �������� (�����)
procedure TfrmMain.CameraScanBarCodeSampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  if ScanCamera.Active and not Assigned(ScanThread)  then
  begin
    ScanCamera.SampleBufferToBitmap(imgCameraScanBarCode.Bitmap, True);
    ScanThread := TScanThread.Create(False);
  end;
end;

procedure TfrmMain.cbSearchTypeGoodsChange(Sender: TObject);
begin
  ShowGoods;
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

procedure TfrmMain.SetInventScanButton;
begin
  bInventScanMode.ImageIndex := 13;
  bInventScanMode.TextSettings.FontColor := bInventScanSearch.TextSettings.FontColor;
  bInventScanMode.TextSettings.Font.Style := bInventScanSearch.TextSettings.Font.Style;
  bInventScanMode.TextSettings.Font.Size := bInventScanSearch.TextSettings.Font.Size;
  bInventScanAmount.ImageIndex := 13;
  bInventScanAmount.TextSettings.FontColor := bInventScanSearch.TextSettings.FontColor;
  bInventScanAmount.TextSettings.Font.Style := bInventScanSearch.TextSettings.Font.Style;
  bInventScanAmount.TextSettings.Font.Size := bInventScanSearch.TextSettings.Font.Size;
  bInventScanSN.ImageIndex := 13;
  bInventScanSN.TextSettings.FontColor := bInventScanSearch.TextSettings.FontColor;
  bInventScanSN.TextSettings.Font.Style := bInventScanSearch.TextSettings.Font.Style;
  bInventScanSN.TextSettings.Font.Size := bInventScanSearch.TextSettings.Font.Size;
  bInventScanNull.ImageIndex := 13;
  bInventScanNull.TextSettings.FontColor := bInventScanSearch.TextSettings.FontColor;
  bInventScanNull.TextSettings.Font.Style := bInventScanSearch.TextSettings.Font.Style;
  bInventScanNull.TextSettings.Font.Size := bInventScanSearch.TextSettings.Font.Size;


  case FScanType of
    0 : begin
          bInventScanMode.ImageIndex := 12;
          bInventScanMode.TextSettings.FontColor := TAlphaColorRec.Peru;
          bInventScanMode.TextSettings.Font.Style := [TFontStyle.fsBold];
          bInventScanMode.TextSettings.Font.Size := bInventScanSearch.TextSettings.Font.Size + 1;
        end;
    1 : begin
          bInventScanAmount.ImageIndex := 12;
          bInventScanAmount.TextSettings.FontColor := TAlphaColorRec.Peru;
          bInventScanAmount.TextSettings.Font.Style := [TFontStyle.fsBold];
          bInventScanAmount.TextSettings.Font.Size := bInventScanSearch.TextSettings.Font.Size + 1;
        end;
    2 : begin
          bInventScanSN.ImageIndex := 12;
          bInventScanSN.TextSettings.FontColor := TAlphaColorRec.Peru;
          bInventScanSN.TextSettings.Font.Style := [TFontStyle.fsBold];
          bInventScanSN.TextSettings.Font.Size := bInventScanSearch.TextSettings.Font.Size + 1;
        end;
    3 : begin
          bInventScanNull.ImageIndex := 12;
          bInventScanNull.TextSettings.FontColor := TAlphaColorRec.Peru;
          bInventScanNull.TextSettings.Font.Style := [TFontStyle.fsBold];
          bInventScanNull.TextSettings.Font.Size := bInventScanSearch.TextSettings.Font.Size + 1;
        end;
  end;
end;

procedure TfrmMain.SetSendScanButton;
begin
  bSendScanMode.ImageIndex := 13;
  bSendScanMode.TextSettings.FontColor := bSendScanSearch.TextSettings.FontColor;
  bSendScanMode.TextSettings.Font.Style := bSendScanSearch.TextSettings.Font.Style;
  bSendScanMode.TextSettings.Font.Size := bSendScanSearch.TextSettings.Font.Size;
  bSendScanAmount.ImageIndex := 13;
  bSendScanAmount.TextSettings.FontColor := bSendScanSearch.TextSettings.FontColor;
  bSendScanAmount.TextSettings.Font.Style := bSendScanSearch.TextSettings.Font.Style;
  bSendScanAmount.TextSettings.Font.Size := bSendScanSearch.TextSettings.Font.Size;
  bSendScanSN.ImageIndex := 13;
  bSendScanSN.TextSettings.FontColor := bSendScanSearch.TextSettings.FontColor;
  bSendScanSN.TextSettings.Font.Style := bSendScanSearch.TextSettings.Font.Style;
  bSendScanSN.TextSettings.Font.Size := bSendScanSearch.TextSettings.Font.Size;
  bSendScanNull.ImageIndex := 13;
  bSendScanNull.TextSettings.FontColor := bSendScanSearch.TextSettings.FontColor;
  bSendScanNull.TextSettings.Font.Style := bSendScanSearch.TextSettings.Font.Style;
  bSendScanNull.TextSettings.Font.Size := bSendScanSearch.TextSettings.Font.Size;


  case FScanType of
    0 : begin
          bSendScanMode.ImageIndex := 12;
          bSendScanMode.TextSettings.FontColor := TAlphaColorRec.Peru;
          bSendScanMode.TextSettings.Font.Style := [TFontStyle.fsBold];
          bSendScanMode.TextSettings.Font.Size := bSendScanSearch.TextSettings.Font.Size + 1;
        end;
    1 : begin
          bSendScanAmount.ImageIndex := 12;
          bSendScanAmount.TextSettings.FontColor := TAlphaColorRec.Peru;
          bSendScanAmount.TextSettings.Font.Style := [TFontStyle.fsBold];
          bSendScanAmount.TextSettings.Font.Size := bSendScanSearch.TextSettings.Font.Size + 1;
        end;
    2 : begin
          bSendScanSN.ImageIndex := 12;
          bSendScanSN.TextSettings.FontColor := TAlphaColorRec.Peru;
          bSendScanSN.TextSettings.Font.Style := [TFontStyle.fsBold];
          bSendScanSN.TextSettings.Font.Size := bSendScanSearch.TextSettings.Font.Size + 1;
        end;
    3 : begin
          bSendScanNull.ImageIndex := 12;
          bSendScanNull.TextSettings.FontColor := TAlphaColorRec.Peru;
          bSendScanNull.TextSettings.Font.Style := [TFontStyle.fsBold];
          bSendScanNull.TextSettings.Font.Size := bSendScanSearch.TextSettings.Font.Size + 1;
        end;
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

  bGoodsChoice.Visible := False;

  { ��������� ������ �������� }
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
      DM.qurGoodsEAN.Close;
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
      lCaption.Text := '����������';
      FDataWedgeBarCode.OnScanResultDetails := OnScanResultDetails;
    end
    else
    if tcMain.ActiveTab = tiGoods then
    begin
      lCaption.Text := '�������������';
      bGoodsChoice.Visible := False;
      FDataWedgeBarCode.OnScanResult := OnScanResultGoods;
      GetSearshBox(lwGoods).SetFocus;
      GetSearshBox(lwGoods).SelectAll;
      sbRefresh.Visible := True;
    end
    else
    if tcMain.ActiveTab = tiDictList then
    begin
      lCaption.Text := '����� �� �����������'#13#10 + DictTypeName[Ord(DM.DictType)];
      bDictChoice.Visible := Assigned(FDictUpdateDataSet);
      GetSearshBox(lwDictList).SetFocus;
      GetSearshBox(lwDictList).SelectAll;
      sbRefresh.Visible := True;
    end
    else
    if tcMain.ActiveTab = tiOrderInternalChoice then
    begin
      lCaption.Text := '������ ������ �� ������.';
      bOrderInternalChoice.Visible := False;
      GetSearshBox(lwOrderInternalChoice).SetFocus;
      GetSearshBox(lwOrderInternalChoice).SelectAll;
      sbRefresh.Visible := True;
    end
    else
    if tcMain.ActiveTab = tiScanBarCode then
    begin
      lCaption.Text := '������ ���������';

      //��������� ������
      ScanCamera.Quality := FMX.Media.TVideoCaptureQuality.MediumQuality;
      ScanCamera.Kind := FMX.Media.TCameraKind.BackCamera;
      ScanCamera.FocusMode := FMX.Media.TFocusMode.ContinuousAutoFocus;
      ScanCamera.OnSampleBufferReady := CameraScanBarCodeSampleBufferReady;
      ScanCamera.Active := True;
      //������ ��������� � ���������
      if ScanCamera.HasFlash and isIlluminationMode then TimerTorchMode.Enabled := True;
    end else
    if tcMain.ActiveTab = tiInventory then
    begin
      lCaption.Text := '��������������';
      sbRefresh.Visible := True;
    end else
    if tcMain.ActiveTab = tiInventoryScan then
    begin
      lCaption.TextSettings.Font.Size := FCaptionFontSize - 4;
      lCaption.Text := '��������������'#13'������������/����� �������������';
      DM.OpenInventoryGoods;
      SetInventScanButton;
      FDataWedgeBarCode.OnScanResult := OnScanResultInventoryScan;
      sbRefresh.Visible := True;
      if FActiveTabPrew = tiMain then DM.DownloadRemains;
      NextScan;
    end
    else
    if tcMain.ActiveTab = tiSendScan then
    begin
      lCaption.TextSettings.Font.Size := FCaptionFontSize - 4;
      lCaption.Text := '����������'#13'������������/����� �������������';
      DM.OpenSendGoods;
      SetSendScanButton;
      FDataWedgeBarCode.OnScanResult := OnScanResultSendScan;
      sbRefresh.Visible := True;
      NextScan;
    end
    else
    if tcMain.ActiveTab = tiInventoryItemEdit then
    begin
      lCaption.Text := '�������� � ��������������';
      case FScanType of
        1 : begin
              edIIEAmount.SetFocus;
              edIIEAmount.SelectAll;
            end;
        2 : begin
              edIIEPartNumber.SetFocus;
              edIIEPartNumber.SelectAll;
            end;
      end;
      sbRefresh.Visible := True;
    end
    else
    if tcMain.ActiveTab = tiSendItemEdit then
    begin
      if DM.cdsSendItemEditId.AsInteger = 0 then
      begin
        lCaption.Text := '�������� � �����������';
        case FScanType of
          1 : begin
                edSIEAmount.SetFocus;
                edSIEAmount.SelectAll;
              end;
          2 : begin
                edSIEPartNumber.SetFocus;
                edSIEPartNumber.SelectAll;
              end;
        end;
      end else lCaption.Text := '�������������� �����������';
      sbRefresh.Visible := True;
    end
     else
    if tcMain.ActiveTab = tiSendList then
    begin
      lCaption.Text := '�����������';
      sbRefresh.Visible := True;
    end
    else
    if tcMain.ActiveTab = tiProductionUnionScan then
    begin
      lCaption.Text := '������ ���� / �����';
      SetProductionUnionScanButton;
      sbRefresh.Visible := True;
      DM.DownloadProductionUnionListTop;
      FDataWedgeBarCode.OnScanResult := OnScanProductionUnion;
      NextScan;
    end else
    if tcMain.ActiveTab = tiProductionUnionList then
    begin
      lCaption.Text := '�������� ����������� - �������';
      sbRefresh.Visible := True;
    end  else
    if tcMain.ActiveTab = tiProductionUnionEdit then
    begin
      lCaption.Text := '�������������� c����� ���� / �����';
      sbRefresh.Visible := True;
    end;

    if (tcMain.ActiveTab = tiInformation) or (tcMain.ActiveTab = tiInventoryScan) or (tcMain.ActiveTab = tiGoods) or (tcMain.ActiveTab = tiProductionUnionScan) or (tcMain.ActiveTab = tiSendScan) then
    begin
      sbScan.Visible := FisZebraScaner and not FisCameraScaner and not FisHideScanButton or not FisZebraScaner or FisCameraScaner;
    end else sbScan.Visible := false;

    if (tcMain.ActiveTab = tiInformation) or (tcMain.ActiveTab = tiInventoryScan) or (tcMain.ActiveTab = tiGoods) or (tcMain.ActiveTab = tiProductionUnionScan) or (tcMain.ActiveTab = tiScanBarCode) then
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

procedure TfrmMain.InputOrderClient(const AResult: TModalResult; const AValues: array of string);
  var InvNumber, InvNumberFull: String; ID: Integer;
begin

  if (AResult = mrOk) and (AValues[0] <> FOrderClientInvNumberFull) then
  begin
    if Trim(AValues[0]) = '' then
    begin
      FOrderClientId := 0;
      FOrderClientInvNumber := '';
      FOrderClientInvNumberFull := '';
      edSSInvNumber_OrderClient.Text := '';
      bSendScanClear.Visible := False;
    end else if DM.GetOrderClient('', Trim(AValues[0]), Id, InvNumber, InvNumberFull) then
    begin
      FOrderClientId := Id;
      FOrderClientInvNumber := InvNumber;
      FOrderClientInvNumberFull := InvNumberFull;
      edSSInvNumber_OrderClient.Text := InvNumberFull;
      bSendScanClear.Visible := True;
    end else
    begin
      FOrderClientId := 0;
      FOrderClientInvNumber := '';
      FOrderClientInvNumberFull := '';
      edSSInvNumber_OrderClient.Text := '';
      bSendScanClear.Visible := False;
    end;
  end;

  lwSendScan.SetFocus;
end;

procedure TfrmMain.edSSInvNumber_OrderClientClick(Sender: TObject);
begin
  edSSInvNumber_OrderClient.SetFocus;
  TDialogService.InputQuery('���� � ���. ������', ['� ���. ������'], [FOrderClientInvNumberFull], InputOrderClient);
end;

procedure TfrmMain.ed�mountChangeTracking(Sender: TObject);
Var FEdit : TEdit;
    FFloat : Single;
begin
  If Not (Sender is TEdit) Then // ��������� �� �� ������������ ������ ����
    Exit;
  FEdit:=(Sender as TEdit); // ��� ��������...
  FEdit.Text:=FEdit.Text.Replace(' ',''); // ������� ��������� �������
  if (FEdit.Text.IsEmpty) or (FEdit.Text.Equals('-')) then // ���� ����� (������ �� ������� ��� ��� �������) ��� ������ �����, ������ �� ������
    Exit;
  if FormatSettings.DecimalSeparator = '.' then
    FEdit.Text:=FEdit.Text.Replace(',', FormatSettings.DecimalSeparator) // �������� ������� �� ��������� �����������
  else FEdit.Text:=FEdit.Text.Replace('.', FormatSettings.DecimalSeparator); // �������� ����� �� ��������� �����������
  if FEdit.Text.Equals(FormatSettings.DecimalSeparator) then // ���� ������ �����������, ��������� ����� ��� ���� ��� ������� (�� �����������)
  begin
    FEdit.Text:='0,';
    FEdit.CaretPosition:=FEdit.CaretPosition+1; // ��� ����� ������ ��������� ����� ���� � �������
  end;
  if (Pos(FormatSettings.DecimalSeparator, FEdit.Text) > 0) and
     (Length(Copy(FEdit.Text,  Pos(FormatSettings.DecimalSeparator, FEdit.Text) + 1, Length(FEdit.Text))) > 4) then
    FEdit.Text:=FEdit.TagString // ���� ����� ������ ����� �������, ��������������� �� ���������� ���������
  else if TryStrToFloat(FEdit.Text,FFloat) Then // ������� ������������� � �����
    FEdit.TagString:=FEdit.Text // ���� �������, ��������� � ��������� ���������
  Else
    FEdit.Text:=FEdit.TagString; // ���� �� �������, ��������������� �� ���������� ���������
end;

// ������� ���������� ��� ���������
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

  // ��������� ������ ��� ��������� ������
  cbOpenScanChangingMode.IsChecked := FisOpenScanChangingMode;
  // �������� ������ ���������
  cbHideIlluminationButton.IsChecked := FisHideIlluminationButton;
  // �������� ������ ������������ ����� ���� �������
  cbHideScanButton.IsChecked := FisHideScanButton;
  // ��������� ��������
  cblluminationMode.IsChecked := isIlluminationMode;

  cbDictGoodsArticle.IsChecked:= FisDictGoodsArticle;
  cbDictGoodsCode.IsChecked:= FisDictGoodsCode;
  cbDictGoodsEAN.IsChecked:= FisDictGoodsEAN;
  cbDictCode.IsChecked:= FisDictCode;

  SwitchToForm(tiInformation, nil);
end;

procedure TfrmMain.lwDictListSearchChange(Sender: TObject);
begin
  TimerRefresh.Enabled := False;
  FDataSetRefresh := dsrDict;
  TimerRefresh.Enabled := True;
end;

procedure TfrmMain.lwDictListDblClick(Sender: TObject);
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  var Handled: Boolean;
      GestureEventInfo: TGestureEventInfo;
  {$ENDIF}
begin
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  Handled := False;
  lwDictListGesture(Sender, GestureEventInfo, Handled)
  {$ENDIF}
end;

procedure TfrmMain.lwDictListFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TfrmMain.lwDictListGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var I: Integer;
begin
  if ppActions.IsOpen or Handled then Exit;
  if not bDictChoice.Visible then Exit;


  // ������� ���
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // �����������
  if (tcMain.ActiveTab = tiDictList) and DM.qurDictList.Active and not DM.qurDictList.IsEmpty then
  begin
    btaCancel.Visible := True;
    //btaClose.Visible := True;
    btaOk.Visible := bDictChoice.Visible;
    ppActions.Height := 2;
    for I := 0 to ComponentCount - 1 do
      if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      begin
        ppActions.Height := ppActions.Height + TButton(Components[I]).Height;
      end;
    ppActions.IsOpen := True;
  end;
end;

procedure TfrmMain.lwGoodsSearchChange(Sender: TObject);
begin
  TimerRefresh.Enabled := False;
  DM.FilterGoods := TSearchBox(Sender).Text;
  FDataSetRefresh := dsrGoods;
  TimerRefresh.Enabled := True;
end;

procedure TfrmMain.lwGoodsDblClick(Sender: TObject);
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  var Handled: Boolean;
      GestureEventInfo: TGestureEventInfo;
  {$ENDIF}
begin
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  Handled := False;
  lwGoodsGesture(Sender, GestureEventInfo, Handled)
  {$ENDIF}
end;

procedure TfrmMain.lwGoodsFilter(Sender: TObject; const AFilter, AValue: string;
  var Accept: Boolean);
begin
  Accept := True;
end;

procedure TfrmMain.lwGoodsGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var I: Integer;
begin
  if ppActions.IsOpen or Handled then Exit;
  if not bGoodsChoice.Visible then Exit;

  // ������� ���
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // ���������� �������������
  if (tcMain.ActiveTab = tiGoods) and DM.qurGoodsList.Active and not DM.qurGoodsList.IsEmpty then
  begin
    btaCancel.Visible := True;
    //btaClose.Visible := True;
    btaOk.Visible := bGoodsChoice.Visible;
    ppActions.Height := 2;
    for I := 0 to ComponentCount - 1 do
      if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      begin
        ppActions.Height := ppActions.Height + TButton(Components[I]).Height;
      end;
    ppActions.IsOpen := True;
  end;
end;

procedure TfrmMain.lwInventorySearchListChange(Sender: TObject);
begin
  TimerRefresh.Enabled := False;
  FDataSetRefresh := dsrInventoryList;
  TimerRefresh.Enabled := True;
end;

procedure TfrmMain.lwOrderInternalChoiceDblClick(Sender: TObject);
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  var Handled: Boolean;
      GestureEventInfo: TGestureEventInfo;
  {$ENDIF}
begin
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  Handled := False;
  lwOrderInternalChoiceGesture(Sender, GestureEventInfo, Handled)
  {$ENDIF}
end;

procedure TfrmMain.lwOrderInternalChoiceFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TfrmMain.lwOrderInternalChoiceGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var I: Integer;
begin
  if ppActions.IsOpen or Handled then Exit;
  if not bDictChoice.Visible then Exit;


  // ������� ���
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // �����������
  if (tcMain.ActiveTab = tiOrderInternalChoice) and DM.cdsOrderInternalChoice.Active and not DM.cdsOrderInternalChoice.IsEmpty then
  begin
    btaCancel.Visible := True;
    //btaClose.Visible := True;
    btaOk.Visible := bDictChoice.Visible;
    ppActions.Height := 2;
    for I := 0 to ComponentCount - 1 do
      if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      begin
        ppActions.Height := ppActions.Height + TButton(Components[I]).Height;
      end;
    ppActions.IsOpen := True;
  end;
end;

procedure TfrmMain.lwSendListDblClick(Sender: TObject);
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  var Handled: Boolean;
      GestureEventInfo: TGestureEventInfo;
  {$ENDIF}
begin
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  Handled := False;
  lwSendListGesture(Sender, GestureEventInfo, Handled)
  {$ENDIF}
end;

procedure TfrmMain.lwSendListFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TfrmMain.lwSendListGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var I: Integer;
begin
  if ppActions.IsOpen or Handled then Exit;

  // ������� ���
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // �������������� ��������������
  if (tcMain.ActiveTab = tiSendList) and DM.cdsSendList.Active and not DM.cdsSendList.IsEmpty then
  begin
    btaCancel.Visible := True;
    btaEraseRecord.Visible := not DM.cdsSendListisErased.AsBoolean;
    btaUnEraseRecord.Visible := DM.cdsSendListisErased.AsBoolean;
    btaEditRecord.Visible :=  not DM.cdsSendListisErased.AsBoolean;
    ppActions.Height := 2;
    for I := 0 to ComponentCount - 1 do
      if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      begin
        ppActions.Height := ppActions.Height + TButton(Components[I]).Height;
      end;
    ppActions.IsOpen := True;
  end;
end;

procedure TfrmMain.lwSendScanDblClick(Sender: TObject);
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  var Handled: Boolean;
      GestureEventInfo: TGestureEventInfo;
  {$ENDIF}
begin
  {$IF not DEFINED(iOS) and not DEFINED(ANDROID)}
  Handled := False;
  lwSendScanGesture(Sender, GestureEventInfo, Handled)
  {$ENDIF}
end;

procedure TfrmMain.lwSendScanGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var I: Integer;
begin
  if ppActions.IsOpen or Handled then Exit;

  // ������� ���
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // �������������� � ������������� �����������
  if (tcMain.ActiveTab = tiSendScan) and DM.cdsSendListTop.Active and not DM.cdsSendListTop.IsEmpty then
  begin
    btaCancel.Visible := True;
    btaErrorInfo.Visible := DM.cdsSendListTopError.AsString <> '';
    btaEraseRecord.Visible := True;
    btaEditRecord.Visible := True;
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

procedure TfrmMain.lwInventoryListFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TfrmMain.lwInventoryListGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var I: Integer;
begin
  if ppActions.IsOpen or Handled then Exit;

  // ������� ���
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // �������������� ��������������
  if (tcMain.ActiveTab = tiInventory) and DM.cdsInventoryList.Active and not DM.cdsInventoryList.IsEmpty then
  begin
    btaCancel.Visible := True;
    btaEraseRecord.Visible := not DM.cdsInventoryListisErased.AsBoolean;
    btaUnEraseRecord.Visible := DM.cdsInventoryListisErased.AsBoolean;
    btaEditRecord.Visible :=  not DM.cdsInventoryListisErased.AsBoolean;
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

  // ������� ���
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // �������������� � ������������� ��������������
  if (tcMain.ActiveTab = tiInventoryScan) and DM.cdsInventoryListTop.Active and not DM.cdsInventoryListTop.IsEmpty then
  begin
    btaCancel.Visible := True;
    btaErrorInfo.Visible := DM.cdsInventoryListTopError.AsString <> '';
    btaEraseRecord.Visible := True;
    btaEditRecord.Visible := True;
    ppActions.Height := 2;
    for I := 0 to ComponentCount - 1 do
      if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      begin
        ppActions.Height := ppActions.Height + TButton(Components[I]).Height;
      end;
    ppActions.IsOpen := True;
  end;
end;

// ������� ���������� ����������� �������������
procedure TfrmMain.ShowGoods;
begin
  DM.FilterGoods := GetSearshBox(lwGoods).Text;
  DM.LoadGoodsList;
  if tcMain.ActiveTab <> tiGoods then SwitchToForm(tiGoods, nil);
end;

// ������� ���������� ����������� �������������
procedure TfrmMain.ShowOrderInternalChoice;
begin
  DM.DownloadOrderInternalChoice(0, GetSearshBox(lwOrderInternalChoice).Text);
  if tcMain.ActiveTab <> tiOrderInternalChoice then SwitchToForm(tiOrderInternalChoice, nil);
end;

// ������� ���������� �����������
procedure TfrmMain.ShowDictList(ADictType : TDictType);
begin
  DM.DictType := ADictType;
  DM.FilterDict := '';
  if ADictType = dtGoods then
  begin
    if GetSearshBox(lwGoods).Text <> '' then
      GetSearshBox(lwGoods).Text := '';
    DM.LoadGoodsList;
    if tcMain.ActiveTab <> tiGoods then
    begin
      if FDictUpdateId <> 0 then  DM.qurGoodsList.Locate('Id', FDictUpdateId, []);
      SwitchToForm(tiGoods, nil);
    end;
  end else
  begin
    if GetSearshBox(lwDictList).Text <> '' then
      GetSearshBox(lwDictList).Text := '';
    DM.LoadDictList;
    if tcMain.ActiveTab <> tiDictList then
    begin
      if FDictUpdateId <> 0 then  DM.qurDictList.Locate('Id', FDictUpdateId, []);
      SwitchToForm(tiDictList, nil);
    end;
  end;
end;

// ������� ���������� ������� ��������������
procedure TfrmMain.ShowInventoryScan;
begin
  if DM.GetInventoryActive(False) then
  begin
    SwitchToForm(tiInventoryScan, nil);
  end else TDialogService.MessageDialog('�������������� �� "������ ���������" �� �������.'#13#13'������� ?',
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, CreateInventory);
end;

// ������� ���������� ������ ��������������
procedure TfrmMain.ShowInventoryItemEdit;
begin
  if FGoodsId = 0 then Exit;

  if not DM.GetMIInventory(FGoodsId, 0, '', 1) then
  begin
     if not DM.LoadGoodsListId(FGoodsId) then Exit;

     DM.cdsInventoryItemEdit.Close;
     DM.cdsInventoryItemEdit.CreateDataSet;
     DM.cdsInventoryItemEdit.Insert;

     DM.cdsInventoryItemEditId.AsInteger := 0;
     DM.cdsInventoryItemEditGoodsId.AsInteger := FGoodsId;
     DM.cdsInventoryItemEditGoodsCode.AsInteger := DM.qurGoodsListCode.AsInteger;
     DM.cdsInventoryItemEditGoodsName.AsString := DM.qurGoodsListName.AsString;
     DM.cdsInventoryItemEditArticle.AsString := DM.qurGoodsListArticle.AsString;
     DM.cdsInventoryItemEditPartNumber.AsString := '';
     DM.cdsInventoryItemEditGoodsGroupName.AsString := DM.qurGoodsListGoodsGroupName.AsString;
     DM.cdsInventoryItemEditAmount.AsFloat := 1;

     DM.GetMIInventoryGoods(DM.cdsInventoryItemEdit);

     DM.cdsInventoryItemEdit.Post;
  end;

  if FScanType = 3 then
  begin

    FisScanOk := DM.UploadMIInventory;
    DM.cdsInventoryItemEdit.Close;
    NextScan;

  end else if DM.cdsInventoryItemEdit.Active then
    SwitchToForm(tiInventoryItemEdit, nil);
end;

// ������� ���������� ������ �����������
procedure TfrmMain.ShowSendItemEdit;
begin
  if not DM.cdsSendItemEdit.Active or DM.cdsSendItemEdit.IsEmpty then
  begin
    if FGoodsId = 0 then Exit;

    if not DM.GetMISend(FGoodsId, 0, '', 1) then
    begin
       if not DM.LoadGoodsListId(FGoodsId) then Exit;

       DM.cdsSendItemEdit.Close;
       DM.cdsSendItemEdit.CreateDataSet;
       DM.cdsSendItemEdit.Insert;

       DM.cdsSendItemEditId.AsInteger := 0;
       DM.cdsSendItemEditGoodsId.AsInteger := FGoodsId;
       DM.cdsSendItemEditGoodsCode.AsInteger := DM.qurGoodsListCode.AsInteger;
       DM.cdsSendItemEditGoodsName.AsString := DM.qurGoodsListName.AsString;
       DM.cdsSendItemEditArticle.AsString := DM.qurGoodsListArticle.AsString;
       DM.cdsSendItemEditPartNumber.AsString := '';
       DM.cdsSendItemEditGoodsGroupName.AsString := DM.qurGoodsListGoodsGroupName.AsString;
       DM.cdsSendItemEditAmount.AsFloat := 1;
       DM.cdsSendItemEditMovementId_OrderClient.AsInteger := FOrderClientId;
       DM.cdsSendItemEditInvNumber_OrderClient.AsString := FOrderClientInvNumberFull;

       DM.GetMISendGoods(DM.cdsSendItemEdit);

       DM.cdsSendItemEdit.Post;
    end;
  end;

  if FScanType = 3 then
  begin

    FisScanOk := DM.UploadMISend;
    DM.cdsSendItemEdit.Close;

    NextScan;

  end else if DM.cdsSendItemEdit.Active then
    SwitchToForm(tiSendItemEdit, nil);
end;

// ������� ���������� ������� �����������
procedure TfrmMain.ShowProductionUnionList;
begin

  if not DM.DownloadProductionUnionList(pbPULOrderBy.ItemIndex > 0, pbPULAllUser.ItemIndex > 0, pbPULErased.ItemIndex > 0, GetSearshBox(lwProductionUnionList).Text) then Exit;

  if tcMain.ActiveTab <> tiProductionUnionList then SwitchToForm(tiProductionUnionList, nil);
end;

// ������� ���������� ������� �����������
procedure TfrmMain.ShowSend;
begin

  if not DM.DownloadSendList(pbSLOrderBy.ItemIndex > 0, pbSLAllUser.ItemIndex > 0, pbSLErased.ItemIndex > 0, GetSearshBox(lwProductionUnionList).Text) then Exit;

  if tcMain.ActiveTab <> tiSendList then SwitchToForm(tiSendList, nil);
end;

// �������� �� �������������� ����� ��������� ������
procedure TfrmMain.ShowEditInventoryItemEdit;
begin
  if not DM.cdsInventoryListTop.Active and not DM.cdsInventoryListTop.IsEmpty then Exit;

   DM.cdsInventoryItemEdit.Close;
   DM.cdsInventoryItemEdit.CreateDataSet;
   DM.cdsInventoryItemEdit.Insert;

   DM.cdsInventoryItemEditLocalId.AsInteger := DM.cdsInventoryListTopLocalId.AsInteger;
   DM.cdsInventoryItemEditId.AsInteger := DM.cdsInventoryListTopId.AsInteger;
   DM.cdsInventoryItemEditGoodsId.AsInteger := DM.cdsInventoryListTopGoodsId.AsInteger;
   DM.cdsInventoryItemEditGoodsCode.AsInteger := DM.cdsInventoryListTopGoodsCode.AsInteger;
   DM.cdsInventoryItemEditGoodsName.AsString := DM.cdsInventoryListTopGoodsName.AsString;
   DM.cdsInventoryItemEditArticle.AsString := DM.cdsInventoryListTopArticle.AsString;
   DM.cdsInventoryItemEditPartNumber.AsString := DM.cdsInventoryListTopPartNumber.AsString;
   DM.cdsInventoryItemEditGoodsGroupName.AsString := DM.cdsInventoryListTopGoodsGroupName.AsString;
   DM.cdsInventoryItemEditAmount.AsFloat := DM.cdsInventoryListTopAmount.AsFloat;
   DM.cdsInventoryItemEditPartionCellName.AsString := DM.cdsInventoryListTopPartionCellName.AsString;

   DM.GetMIInventoryGoods(DM.cdsInventoryItemEdit);

   DM.cdsInventoryItemEdit.Post;

  if DM.cdsInventoryItemEdit.Active then
    SwitchToForm(tiInventoryItemEdit, nil);
  lCaption.Text := '�������������� ��������������';
end;

// �������� �� �������������� ����� ��������� ������
procedure TfrmMain.ShowEditInventoryListEdit;
begin
  if not DM.cdsInventoryList.Active and not DM.cdsInventoryList.IsEmpty then Exit;

   DM.cdsInventoryItemEdit.Close;
   DM.cdsInventoryItemEdit.CreateDataSet;
   DM.cdsInventoryItemEdit.Insert;

   DM.cdsInventoryItemEditLocalId.AsInteger := 0;
   DM.cdsInventoryItemEditId.AsInteger := DM.cdsInventoryListId.AsInteger;
   DM.cdsInventoryItemEditGoodsId.AsInteger := DM.cdsInventoryListGoodsId.AsInteger;
   DM.cdsInventoryItemEditGoodsCode.AsInteger := DM.cdsInventoryListGoodsCode.AsInteger;
   DM.cdsInventoryItemEditGoodsName.AsString := DM.cdsInventoryListGoodsName.AsString;
   DM.cdsInventoryItemEditArticle.AsString := DM.cdsInventoryListArticle.AsString;
   DM.cdsInventoryItemEditPartNumber.AsString := DM.cdsInventoryListPartNumber.AsString;
   DM.cdsInventoryItemEditGoodsGroupName.AsString := DM.cdsInventoryListGoodsGroupName.AsString;
   DM.cdsInventoryItemEditAmount.AsFloat := DM.cdsInventoryListAmount.AsFloat;
   DM.cdsInventoryItemEditPartionCellName.AsString := DM.cdsInventoryListPartionCellName.AsString;
   DM.cdsInventoryItemEditTotalCount.AsFloat := DM.cdsInventoryListTotalCount.AsFloat - DM.cdsInventoryItemEditAmount.AsFloat;
   DM.cdsInventoryItemEditAmountRemains.AsFloat := DM.cdsInventoryListAmountRemains.AsFloat;

   DM.GetMIInventoryGoods(DM.cdsInventoryItemEdit);

   DM.cdsInventoryItemEdit.Post;

  if DM.cdsInventoryItemEdit.Active then
    SwitchToForm(tiInventoryItemEdit, nil);
  lCaption.Text := '�������������� ��������������';
end;

// �������� �� �������������� ����� ��������� ������
procedure TfrmMain.ShowEditSendItemEdit;
begin
  if not DM.cdsSendListTop.Active and not DM.cdsSendListTop.IsEmpty then Exit;

   DM.cdsSendItemEdit.Close;
   DM.cdsSendItemEdit.CreateDataSet;
   DM.cdsSendItemEdit.Insert;

   DM.cdsSendItemEditLocalId.AsInteger := DM.cdsSendListTopLocalId.AsInteger;
   DM.cdsSendItemEditId.AsInteger := DM.cdsSendListTopId.AsInteger;
   DM.cdsSendItemEditGoodsId.AsInteger := DM.cdsSendListTopGoodsId.AsInteger;
   DM.cdsSendItemEditGoodsCode.AsInteger := DM.cdsSendListTopGoodsCode.AsInteger;
   DM.cdsSendItemEditGoodsName.AsString := DM.cdsSendListTopGoodsName.AsString;
   DM.cdsSendItemEditArticle.AsString := DM.cdsSendListTopArticle.AsString;
   DM.cdsSendItemEditPartNumber.AsString := DM.cdsSendListTopPartNumber.AsString;
   DM.cdsSendItemEditGoodsGroupName.AsString := DM.cdsSendListTopGoodsGroupName.AsString;
   DM.cdsSendItemEditAmount.AsFloat := DM.cdsSendListTopAmount.AsFloat;
   DM.cdsSendItemEditPartionCellName.AsString := DM.cdsSendListTopPartionCellName.AsString;
   DM.cdsSendItemEditFromId.AsInteger := DM.cdsSendListTopFromId.AsInteger;
   DM.cdsSendItemEditFromCode.AsInteger := DM.cdsSendListTopFromCode.AsInteger;
   DM.cdsSendItemEditFromName.AsString := DM.cdsSendListTopFromName.AsString;
   DM.cdsSendItemEditToId.AsInteger := DM.cdsSendListTopToId.AsInteger;
   DM.cdsSendItemEditToCode.AsInteger := DM.cdsSendListTopToCode.AsInteger;
   DM.cdsSendItemEditToName.AsString := DM.cdsSendListTopToName.AsString;
   DM.cdsSendItemEditMovementId_OrderClient.AsInteger := DM.cdsSendListTopMovementId_OrderClient.AsInteger;
   DM.cdsSendItemEditInvNumber_OrderClient.AsString := DM.cdsSendListTopInvNumber_OrderClient.AsString;

   DM.GetMISendGoods(DM.cdsSendItemEdit);

   DM.cdsSendItemEdit.Post;

  if DM.cdsSendItemEdit.Active then
    SwitchToForm(tiSendItemEdit, nil);
  lCaption.Text := '�������������� �����������';
end;

// �������� �� �������������� ����� ��������� ������
procedure TfrmMain.ShowEditSendListEdit;
begin
  if not DM.cdsSendList.Active and not DM.cdsSendList.IsEmpty then Exit;

   DM.cdsSendItemEdit.Close;
   DM.cdsSendItemEdit.CreateDataSet;
   DM.cdsSendItemEdit.Insert;

   DM.cdsSendItemEditLocalId.AsInteger := 0;
   DM.cdsSendItemEditId.AsInteger := DM.cdsSendListId.AsInteger;
   DM.cdsSendItemEditGoodsId.AsInteger := DM.cdsSendListGoodsId.AsInteger;
   DM.cdsSendItemEditGoodsCode.AsInteger := DM.cdsSendListGoodsCode.AsInteger;
   DM.cdsSendItemEditGoodsName.AsString := DM.cdsSendListGoodsName.AsString;
   DM.cdsSendItemEditArticle.AsString := DM.cdsSendListArticle.AsString;
   DM.cdsSendItemEditPartNumber.AsString := DM.cdsSendListPartNumber.AsString;
   DM.cdsSendItemEditGoodsGroupName.AsString := DM.cdsSendListGoodsGroupName.AsString;
   DM.cdsSendItemEditAmount.AsFloat := DM.cdsSendListAmount.AsFloat;
   DM.cdsSendItemEditPartionCellName.AsString := DM.cdsSendListPartionCellName.AsString;
   DM.cdsSendItemEditTotalCount.AsFloat := DM.cdsSendListTotalCount.AsFloat - DM.cdsSendItemEditAmount.AsFloat;
   DM.cdsSendItemEditAmountRemains.AsFloat := DM.cdsSendListAmountRemains.AsFloat;
   DM.cdsSendItemEditFromId.AsInteger := DM.cdsSendListFromId.AsInteger;
   DM.cdsSendItemEditFromCode.AsInteger := DM.cdsSendListFromCode.AsInteger;
   DM.cdsSendItemEditFromName.AsString := DM.cdsSendListFromName.AsString;
   DM.cdsSendItemEditToId.AsInteger := DM.cdsSendListToId.AsInteger;
   DM.cdsSendItemEditToCode.AsInteger := DM.cdsSendListToCode.AsInteger;
   DM.cdsSendItemEditToName.AsString := DM.cdsSendListToName.AsString;
   DM.cdsSendItemEditMovementId_OrderClient.AsInteger := DM.cdsSendListMovementId_OrderClient.AsInteger;
   DM.cdsSendItemEditInvNumber_OrderClient.AsString := DM.cdsSendListInvNumber_OrderClient.AsString;

   DM.GetMISendGoods(DM.cdsSendItemEdit);

   DM.cdsSendItemEdit.Post;

  if DM.cdsSendItemEdit.Active then
    SwitchToForm(tiSendItemEdit, nil);
  lCaption.Text := '�������������� �����������';
end;

// �������� �� �������������� ����� ��������� ������ ������ ���� / �����
procedure TfrmMain.ShowEditProductionUnionItem(AId: Integer);
begin
  if AID = 0 then Exit;

  bpProductionUnion.Visible := False;

  if  DM.GetProductionUnionItem(AId) then
    SwitchToForm(tiProductionUnionEdit, nil);
end;

// ������ ���� / �����
procedure TfrmMain.ShowProductionUnionScan;
begin
  SwitchToForm(tiProductionUnionScan, nil);
end;

// ������������ ��������������
procedure TfrmMain.ShowSendScan;
begin
  SwitchToForm(tiSendScan, nil);
end;

procedure TfrmMain.bSendScanModeClick(Sender: TObject);
begin
  FGoodsId := 0;
  FScanType := TSpinEditButton(Sender).Tag;
  SetSendScanButton;
  if FisOpenScanChangingMode then sbScanClick(Sender);
end;

procedure TfrmMain.bSendScanClearClick(Sender: TObject);
begin
  FOrderClientId := 0;
  FOrderClientInvNumber := '';
  FOrderClientInvNumberFull := '';
  edSSInvNumber_OrderClient.Text := '';
  bSendScanClear.Visible := False;
end;

procedure TfrmMain.bSendScanClick(Sender: TObject);
begin
  FOrderClientId := 0;
  FOrderClientInvNumber := '';
  FOrderClientInvNumberFull := '';
  edSSInvNumber_OrderClient.Text := '';
  bSendScanClear.Visible := False;
  FScanType := 0;
  ShowSendScan;
end;

// ����� ������������� ��� ������� � �����������
procedure TfrmMain.bSendScanSearchClick(Sender: TObject);
  var I: Integer;
begin
  FisNextScan := False;
  FisScanOk := False;
  ShowGoods;
  bGoodsChoice.Visible := True;
  for I := 0 to High(lwGoods.ItemAppearanceObjects.ItemObjects.Objects) do
    if (TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Name = 'RemainsLabel') or
       (TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Name = 'Remains') then
       TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Visible := False;
end;

procedure TfrmMain.bSIECancelClick(Sender: TObject);
begin
  DM.cdsSendItemEdit.Close;
  ReturnPriorForm;
end;

procedure TfrmMain.bSIEFromNameClick(Sender: TObject);
begin
  FDictUpdateId := DM.cdsSendItemEditFromId.AsInteger;
  FDictUpdateDataSet := DM.cdsSendItemEdit;
  FDictUpdateField := 'From';
  ShowDictList(dtUnit);
end;

procedure TfrmMain.bSIEOkClick(Sender: TObject);
begin

  if DM.cdsSendList.Active then
  begin
    if (FScanType = 2) and (Trim(DM.cdsSendItemEditPartNumber.AsString) = '') then
    begin
      TDialogService.ShowMessage('�� �������� �������� �����.');
      edIIEPartNumber.SetFocus;
      Exit;
    end;
  end;

  if DM.cdsSendItemEdit.State in dsEditModes then DM.cdsSendItemEdit.Post;

  if FIsUpdate and (FOldControl = edSIEPartNumber) then
  begin
    lInfoView.Text := '������� ��������';
    FIsUpdate := False;
    ppInfoView.IsOpen := True;
    TimerInfoView.Enabled := True;
    Exit;
  end;

  if DM.cdsSendItemEditFromId.AsInteger = 0 then
  begin
    TDialogService.ShowMessage('�� ��������� ������������� <�� ����>.');
    edIIEPartNumber.SetFocus;
    Exit;
  end;

  if DM.cdsSendItemEditToId.AsInteger = 0 then
  begin
    TDialogService.ShowMessage('�� ��������� ������������� <����>.');
    edIIEPartNumber.SetFocus;
    Exit;
  end;

  if DM.cdsSendItemEditToId.AsInteger = DM.cdsSendItemEditFromId.AsInteger then
  begin
    TDialogService.ShowMessage('������������� <�� ����> � <����> ������ ����������.');
    edIIEPartNumber.SetFocus;
    Exit;
  end;

  if DM.UploadMISend then
    if not DM.cdsSendList.Active and not DM.isSendGoodsSend then DM.UploadSendGoods;


  DM.cdsSendItemEdit.Close;
  FisScanOk := not DM.cdsSendList.Active;
  ReturnPriorForm;

  if tcMain.ActiveTab = tiSendList then DM.DownloadSendList(pbSLOrderBy.ItemIndex > 0, pbSLAllUser.ItemIndex > 0, pbSLErased.ItemIndex > 0, GetSearshBox(lwSendList).Text);
end;

procedure TfrmMain.bSIEOpenDictGoodsClick(Sender: TObject);
  var I: Integer;
begin
  FDictUpdateId := DM.cdsSendItemEditGoodsId.AsInteger;
  FDictUpdateDataSet := DM.cdsSendItemEdit;
  FDictUpdateField := 'Goods';
  ShowDictList(dtGoods);
  for I := 0 to High(lwGoods.ItemAppearanceObjects.ItemObjects.Objects) do
    if (TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Name = 'RemainsLabel') or
       (TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Name = 'Remains') then
       TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Visible := False;
  bGoodsChoice.Visible := True;
end;

procedure TfrmMain.bSIEOpenDictPartionCellClick(Sender: TObject);
begin
  FDictUpdateId := DM.cdsSendItemEditPartionCellId.AsInteger;
  FDictUpdateDataSet := DM.cdsSendItemEdit;
  FDictUpdateField := 'PartionCell';
  ShowDictList(dtPartionCell);
end;

procedure TfrmMain.bSIEToNameClick(Sender: TObject);
begin
  FDictUpdateId := DM.cdsSendItemEditToId.AsInteger;
  FDictUpdateDataSet := DM.cdsSendItemEdit;
  FDictUpdateField := 'To';
  ShowDictList(dtUnit);
end;

// ������� ���������� ������� ��������������
procedure TfrmMain.ShowInventory;
begin
  if not DM.cdsInventory.Active then Exit;
  if DM.cdsInventory.IsEmpty then Exit;
  if DM.cdsInventoryId.AsInteger = 0 then Exit;

  imInventoryStatus.MultiResBitmap.Assign(ilPartners.Source.Items[DM.cdsInventoryStatusId.AsInteger].MultiResBitmap);

  if not DM.DownloadInventoryList(pbILOrderBy.ItemIndex > 0, pbILAllUser.ItemIndex > 0, pbILErased.ItemIndex > 0, GetSearshBox(lwInventoryList).Text) then Exit;

  if tcMain.ActiveTab <> tiInventory then SwitchToForm(tiInventory, nil);
end;

// ������� �� ����� ������� ��������������
procedure TfrmMain.bInventoryScanClick(Sender: TObject);
begin
  FScanType := 0;
  ShowInventoryScan;
end;

// ����� ������������� ��� ������� � ��������������
procedure TfrmMain.bInventScanSearchClick(Sender: TObject);
  var I: Integer;
begin
  FisNextScan := False;
  FisScanOk := False;
  ShowGoods;
  bGoodsChoice.Visible := True;
  for I := 0 to High(lwGoods.ItemAppearanceObjects.ItemObjects.Objects) do
    if (TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Name = 'RemainsLabel') or
       (TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Name = 'Remains') then
       TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Visible := True;
end;

procedure TfrmMain.bInventScanModeClick(Sender: TObject);
begin
  FGoodsId := 0;
  FScanType := TSpinEditButton(Sender).Tag;
  SetInventScanButton;
  if FisOpenScanChangingMode then sbScanClick(Sender);
end;

// ����� ��������������
procedure TfrmMain.bGoodsChoiceClick(Sender: TObject);
begin
  if lwGoods.ItemCount = 0 then Exit;

  if (FActiveTabPrew = tiInventoryScan)  then
  begin
    sbBackClick(Sender);
    FGoodsId := DM.qurGoodsListId.AsInteger;
    ShowInventoryItemEdit;
  end else if (FActiveTabPrew = tiSendScan)  then
  begin
    sbBackClick(Sender);
    FGoodsId := DM.qurGoodsListId.AsInteger;
    ShowSendItemEdit;
  end else if Assigned(FDictUpdateDataSet) and (FDictUpdateField <> '') then
  begin
    FDictUpdateDataSet.Edit;
    if Assigned(FDictUpdateDataSet.Fields.FindField(FDictUpdateField + 'Id')) then
      FDictUpdateDataSet.FieldByName(FDictUpdateField + 'Id').AsVariant := DM.qurGoodsListId.AsVariant;
    if Assigned(FDictUpdateDataSet.Fields.FindField(FDictUpdateField + 'Code')) then
      FDictUpdateDataSet.FieldByName(FDictUpdateField + 'Code').AsVariant := DM.qurGoodsListCode.AsVariant;
    if Assigned(FDictUpdateDataSet.Fields.FindField(FDictUpdateField + 'Name')) then
      FDictUpdateDataSet.FieldByName(FDictUpdateField + 'Name').AsVariant := DM.qurGoodsListName.AsVariant;
    if Assigned(FDictUpdateDataSet.Fields.FindField(FDictUpdateField + 'Name')) then
      FDictUpdateDataSet.FieldByName(FDictUpdateField + 'GroupName').AsVariant := DM.qurGoodsListGoodsGroupName.AsVariant;

    if (tcMain.ActiveTab = tiInventoryItemEdit) then DM.GetMIInventoryGoods(FDictUpdateDataSet);
    if (tcMain.ActiveTab = tiSendItemEdit) then DM.GetMISendGoods(FDictUpdateDataSet);

    FDictUpdateDataSet.Post;
    sbBackClick(Sender);
  end;

end;

// ������� �� ����� ����������� �������������
procedure TfrmMain.bGoodsClick(Sender: TObject);
  var I: Integer;
begin
  GetSearshBox(lwGoods).Text := '';
  for I := 0 to High(lwGoods.ItemAppearanceObjects.ItemObjects.Objects) do
    if (TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Name = 'RemainsLabel') or
       (TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Name = 'Remains') then
       TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Visible := False;
  ShowGoods;
end;

// ���������� �������������
procedure TfrmMain.bGoodsRefreshClick(Sender: TObject);
begin
  TDialogService.MessageDialog('��������� ���������� �������������?',
       TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DownloadDict)
end;

// ������ ���������� � ��������������
procedure TfrmMain.bIIECancelClick(Sender: TObject);
begin
  DM.cdsInventoryItemEdit.Close;
  ReturnPriorForm;
end;

// ���������� � ��������������
procedure TfrmMain.bIIEOkClick(Sender: TObject);
begin

  if DM.cdsInventoryList.Active then
  begin
    if (FScanType = 2) and (Trim(DM.cdsInventoryItemEditPartNumber.AsString) = '') then
    begin
      TDialogService.ShowMessage('�� �������� �������� �����.');
      edIIEPartNumber.SetFocus;
      Exit;
    end;
  end;

  if DM.cdsInventoryItemEdit.State in dsEditModes then DM.cdsInventoryItemEdit.Post;

  if FIsUpdate and (FOldControl = edIIEPartNumber) then
  begin
    lInfoView.Text := '������� ��������';
    FIsUpdate := False;
    ppInfoView.IsOpen := True;
    TimerInfoView.Enabled := True;
    Exit;
  end;

  if DM.UploadMIInventory then
    if not DM.cdsInventoryList.Active and not DM.isInventoryGoodsSend then DM.UploadInventoryGoods;

  DM.cdsInventoryItemEdit.Close;
  FisScanOk := not DM.cdsInventoryList.Active;
  ReturnPriorForm;

  if tcMain.ActiveTab = tiInventory then DM.DownloadInventoryList(pbILOrderBy.ItemIndex > 0, pbILAllUser.ItemIndex > 0, pbILErased.ItemIndex > 0, GetSearshBox(lwInventoryList).Text);
end;

procedure TfrmMain.bIIEOpenDictGoodsClick(Sender: TObject);
  var I: Integer;
begin
  FDictUpdateId := DM.cdsInventoryItemEditGoodsId.AsInteger;
  FDictUpdateDataSet := DM.cdsInventoryItemEdit;
  FDictUpdateField := 'Goods';
  ShowDictList(dtGoods);
  for I := 0 to High(lwGoods.ItemAppearanceObjects.ItemObjects.Objects) do
    if (TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Name = 'RemainsLabel') or
       (TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Name = 'Remains') then
       TTextObjectAppearance(lwGoods.ItemAppearanceObjects.ItemObjects.Objects[I]).Visible := True;
  bGoodsChoice.Visible := True;
end;

procedure TfrmMain.bIIEOpenDictPartionCellClick(Sender: TObject);
begin
  FDictUpdateId := DM.cdsInventoryItemEditPartionCellId.AsInteger;
  FDictUpdateDataSet := DM.cdsInventoryItemEdit;
  FDictUpdateField := 'PartionCell';
  ShowDictList(dtPartionCell);
end;

// ������� �� ����� ����������� ����������
procedure TfrmMain.bInfoClick(Sender: TObject);
begin
  ShowInformation;
end;

// ������� �� ����� ������
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
  if not DM.isInventoryGoodsSend or not DM.isSendGoodsSend then
    TDialogService.MessageDialog('��������� ��� ������������� ������?',
       TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, UploadAllData)
  else TDialogService.ShowMessage('��� ������ ��� ��������.');
end;

procedure TfrmMain.bViewInventoryClick(Sender: TObject);
begin
  ShowInventory;
end;

procedure TfrmMain.bViewProductionUnionClick(Sender: TObject);
begin
  ShowProductionUnionList;
end;

procedure TfrmMain.bViewSendClick(Sender: TObject);
begin
  ShowSend;
end;

procedure TfrmMain.OnCloseDialog(const AResult: TModalResult);
begin
  if AResult = mrOK then
    Close;
end;

// ��������� ������� ������ �������� �� ���������� �����
procedure TfrmMain.sbBackClick(Sender: TObject);
begin
  // ���� ������� ����� �� �������� ������
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
  end else if (tcMain.ActiveTab = tiDictList)  then
  begin
    FDictUpdateId := 0;
    FDictUpdateDataSet := Nil;
    FDictUpdateField := '';
    DM.qurDictList.Close;
  end else if (tcMain.ActiveTab = tiOrderInternalChoice)  then
  begin
    DM.cdsOrderInternalChoice.Close;
  end else if (tcMain.ActiveTab = tiGoods)  then
  begin
    DM.FilterGoodsEAN := False;
  end
  else if (tcMain.ActiveTab = tiInventory)  then
  begin
    DM.cdsInventoryList.Close;
  end
  else if (tcMain.ActiveTab = tiInventoryScan)  then
  begin
    if not DM.isInventoryGoodsSend then
    begin
      TDialogService.MessageDialog('��������� ��������� � �������������� ������ �� ������?', TMsgDlgType.mtWarning,
        [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, BackInventoryScan);
    end;

    DM.cdsInventoryListTop.Close;
    DM.qurGoodsEAN.Close;
  end else if tcMain.ActiveTab = tiInventoryItemEdit then
  begin
    DM.cdsInventoryItemEdit.Close;
    FisNextScan := False;
    FisScanOk := False;
  end else if tcMain.ActiveTab = tiSendItemEdit then
  begin
    DM.cdsSendItemEdit.Close;
    FisNextScan := False;
    FisScanOk := False;
  end
  else if (tcMain.ActiveTab = tiSendList)  then
  begin
    DM.cdsSendList.Close;
  end else if tcMain.ActiveTab = tiProductionUnionEdit then
  begin
    DM.cdsProductionUnionItemEdit.Close;
  end else if tcMain.ActiveTab = tiInformation then
  begin

    // ������������ � ����� ������ ������ ����������
    if isCameraScaner <> rbCameraScaner.IsChecked then
      isCameraScaner := rbCameraScaner.IsChecked;
    // ��������� ������ ��� ��������� ������
    if isOpenScanChangingMode <> cbOpenScanChangingMode.IsChecked then
      isOpenScanChangingMode := cbOpenScanChangingMode.IsChecked;
    // �������� ������ ���������
    if isHideIlluminationButton <> cbHideIlluminationButton.IsChecked then
      isHideIlluminationButton := cbHideIlluminationButton.IsChecked;
    // �������� ������ ������������ ����� ���� �������
    if isHideScanButton <> cbHideScanButton.IsChecked then
      isHideScanButton := cbHideScanButton.IsChecked;
    // ��������� ��������
    if isIlluminationMode <> cblluminationMode.IsChecked then
      isIlluminationMode := cblluminationMode.IsChecked;

    if cbDictGoodsArticle.IsChecked <> FisDictGoodsArticle then
      isDictGoodsArticle := cbDictGoodsArticle.IsChecked;
    if cbDictGoodsCode.IsChecked <> FisDictGoodsCode then
      isDictGoodsCode := cbDictGoodsCode.IsChecked;
    if cbDictGoodsEAN.IsChecked <> FisDictGoodsEAN then
      isDictGoodsEAN := cbDictGoodsEAN.IsChecked;
    if cbDictCode.IsChecked <> FisDictCode then
      isDictCode := cbDictCode.IsChecked;

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

  if tcMain.ActiveTab = tiGoods then
  begin
    lwGoods.SetFocus;
    TDialogService.MessageDialog('��������� ���������� �������������?',
         TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DownloadDict);
  end else if tcMain.ActiveTab = tiDictList then
  begin
    lwDictList.SetFocus;
    TDialogService.MessageDialog('��������� ��� �����������?',
         TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DownloadDict);
  end else if tcMain.ActiveTab = tiInventory then
  begin
    ShowInventory;
  end else if tcMain.ActiveTab = tiInventoryScan then
  begin
    DM.OpenInventoryGoods;
  end else if (tcMain.ActiveTab = tiInventoryItemEdit) then
  begin
    DM.cdsInventoryItemEdit.Edit;
    try
      DM.GetMIInventoryGoods(DM.cdsInventoryItemEdit);
    finally
      DM.cdsInventoryItemEdit.Post;
    end;
  end else if tcMain.ActiveTab = tiSendScan then
  begin
    DM.OpenSendGoods;
  end else if (tcMain.ActiveTab = tiSendItemEdit) then
  begin
    DM.cdsSendItemEdit.Edit;
    try
      DM.GetMISendGoods(DM.cdsSendItemEdit);
    finally
      DM.cdsSendItemEdit.Post;
    end;
  end else if tcMain.ActiveTab = tiSendList then
  begin
    ShowSend;
  end else if tcMain.ActiveTab = tiProductionUnionScan then
  begin
    DM.DownloadProductionUnionListTop;
  end else if tcMain.ActiveTab = tiProductionUnionList then
  begin
    ShowProductionUnionList;
  end;
end;

// ��������� ������������
procedure TfrmMain.NextScan;
begin
  FGoodsId := 0;
  FOrderInternal := 0;
  FProductionUnion := 0;
  if FisNextScan and FisScanOk and not FisZebraScaner then sbScanClick(Nil);
  FisScanOk := False;
end;

// �������� ������
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
  // ������� �� ���������� ����� ��� ������� "������" �� ��������
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
      if tcMain.ActiveTab = tiInventoryItemEdit then
        exit
      else
      if tcMain.ActiveTab = tiSendItemEdit then
        exit
      else
      if tcMain.ActiveTab = tiStart then
        TDialogService.MessageDialog('������� ���������?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], TMsgDlgBtn.mbCancel, -1, OnCloseDialog)
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

  // ������� ���
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // �������������� � ������������� �����������
  if (tcMain.ActiveTab = tiProductionUnionList) and DM.cdsProductionUnionList.Active and not DM.cdsProductionUnionList.IsEmpty then
  begin
    btaCancel.Visible := True;
    btaEraseRecord.Visible := DM.cdsProductionUnionListStatusCode.AsInteger <> 3;
    btaUnEraseRecord.Visible := DM.cdsProductionUnionListStatusCode.AsInteger = 3;
    btaEditRecord.Visible := DM.cdsProductionUnionListStatusCode.AsInteger <> 3;
    ppActions.Height := 2;
    for I := 0 to ComponentCount - 1 do
      if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      begin
        ppActions.Height := ppActions.Height + TButton(Components[I]).Height;
      end;
    ppActions.IsOpen := True;
  end;

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

  // ������� ���
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TButton) and TButton(Components[I]).Visible and (TButton(Components[I]).Parent = RectangleActions) then
      TButton(Components[I]).Visible := False;

  // �������������� � ������������� �����������
  if (tcMain.ActiveTab = tiProductionUnionScan) and DM.cdsProductionUnionListTop.Active and not DM.cdsProductionUnionListTop.IsEmpty then
  begin
    btaCancel.Visible := True;
    btaEraseRecord.Visible := True;
    btaEditRecord.Visible := True;
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
      TDialogService.ShowMessage('����������� ���������� �� �������������');
      exit;
    end;

    if FisTestWebServer then Res := TRegEx.Split(WebServerTest, ';')
    else Res := TRegEx.Split(WebServer, ';');

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

      if TButton(Sender).Tag = 1 then
      begin
        FDataWedgeBarCode.OnScanResult := OnScanResultLogin;
        sbScanClick(Sender);
        Wait(False);
        Exit;
      end else ErrorMessage := TAuthentication.CheckLogin(TStorageFactory.GetStorage, LoginEdit.Text, PasswordEdit.Text, gc_User);

      if Assigned(gc_User) then lUser.Text := gc_User.Login;
      if FisTestWebServer then lUser.Text := lUser.Text + ' (�������� ������)';

      Wait(False);

      if ErrorMessage <> '' then
      begin
        TDialogService.ShowMessage(ErrorMessage);
        exit;
      end;
    except on E: Exception do
      begin
        Wait(False);

        TDialogService.ShowMessage('��� ����� � ��������. ����������� ������ ����������. '+#13#10 + GetTextMessage(E));
        Exit;
      end;
      //
    end;

    {$IFDEF ANDROID}
    DM.CheckUpdate; // �������� ������������ ����������
    {$ENDIF}

    // ���������� ������ � ��� ������� � ini �����
    SettingsFile := TIniFile.Create(FINIFile);
    try
      SettingsFile.WriteString('LOGIN', 'USERNAME', LoginEdit.Text);
      SettingsFile.WriteInteger('Params', 'WebServer', pbWebServer.ItemIndex);
    finally
      FreeAndNil(SettingsFile);
    end;

    // ��������� ������
    DM.DownloadConfig;

    SwitchToForm(tiMain, nil);
    if (frmMain.DateDownloadDict < IncDay(Now, - 1)) then DM.DownloadDict else DM.DownloadRemains;
  finally
    vsbMain.Enabled := True;
  end;
end;

// ������� ��������������
procedure TfrmMain.BackInventoryScan(const AResult: TModalResult);
begin
  if AResult = mrYes then DM.UploadInventoryGoods;
end;

procedure TfrmMain.DeleteInventoryGoods(const AResult: TModalResult);
begin
  if AResult = mrYes then DM.DeleteInventoryGoods;
end;

procedure TfrmMain.ErasedInventoryList(const AResult: TModalResult);
begin
  if AResult = mrYes then DM.ErasedInventoryList;
end;

procedure TfrmMain.UnErasedInventoryList(const AResult: TModalResult);
begin
  if AResult = mrYes then DM.UnErasedInventoryList;
end;

procedure TfrmMain.DeleteSendGoods(const AResult: TModalResult);
begin
  if AResult = mrYes then DM.DeleteSendGoods;
end;

procedure TfrmMain.ErasedSendList(const AResult: TModalResult);
begin
  if AResult = mrYes then DM.ErasedSendList;
end;

procedure TfrmMain.UnErasedSendList(const AResult: TModalResult);
begin
  if AResult = mrYes then DM.UnErasedSendList;
end;

procedure TfrmMain.DownloadDict(const AResult: TModalResult);
begin
  if AResult = mrYes then DM.DownloadDict;
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
      if FisTestWebServer then lUser.Text := lUser.Text + ' (�������� ������)';

      Wait(False);

      if ErrorMessage <> '' then
      begin
        TDialogService.ShowMessage(ErrorMessage);
        exit;
      end;
    except on E: Exception do
      begin
        Wait(False);
        ErrorMessage := '��� ����� � ��������. ����������� ������ ����������. ';
        TDialogService.ShowMessage(ErrorMessage+#13#10 + GetTextMessage(E));
        exit;
      end;
      //
    end;

    {$IFDEF ANDROID}
    DM.CheckUpdate; // �������� ������������ ����������
    {$ENDIF}

    // ��������� ������
    DM.DownloadConfig;

  finally
    if (ErrorMessage <> '') and (tcMain.ActiveTab <> tiStart) then
      ReturnPriorForm
    else if (ErrorMessage = '') and (tcMain.ActiveTab = tiStart) then
    begin
      SwitchToForm(tiMain, nil);
      if (frmMain.DateDownloadDict < IncDay(Now, - 1)) then DM.DownloadDict else DM.DownloadRemains;
    end;
    vsbMain.Enabled := True;
  end;
end;

procedure TfrmMain.pbILErasedChange(Sender: TObject);
begin
  if DM.cdsInventoryList.Active then ShowInventory;
end;

procedure TfrmMain.pbPULOrderByChange(Sender: TObject);
begin
  if DM.cdsProductionUnionList.Active then ShowProductionUnionList;
end;

procedure TfrmMain.pbSLOrderByChange(Sender: TObject);
begin
  if DM.cdsSendList.Active then ShowSend;
end;

// ���� �� ������ ��� ��������� �������
procedure TfrmMain.pPasswordClick(Sender: TObject);
begin
  Inc(FPasswordLabelClick);
  if FPasswordLabelClick = 3 then
  begin
    FPasswordLabelClick := 0;
    rbWebServerMain.IsChecked := not FisTestWebServer;
    rbWebServerTest.IsChecked := FisTestWebServer;
    if LoginEdit.Text = '�����' then ppWebServer.IsOpen := True;
  end;
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  ppActions.IsOpen := False;

  if (tcMain.ActiveTab = tiGoods) then
  begin
    if TButton(Sender).Tag = 5 then bGoodsChoiceClick(Sender);
  end else if (tcMain.ActiveTab = tiDictList) then
  begin
    if TButton(Sender).Tag = 5 then bDictChoiceClick(Sender);
  end else if (tcMain.ActiveTab = tiOrderInternalChoice) then
  begin
    if TButton(Sender).Tag = 5 then bOrderInternalChoiceClick(Sender)
  end else if (tcMain.ActiveTab = tiInventoryScan) then
  begin
    // �������� ������� �������������
    if TButton(Sender).Tag = 1 then
    begin
      ShowEditInventoryItemEdit;
    end else
    // �������� ������� �������������
    if TButton(Sender).Tag = 2 then
      TDialogService.MessageDialog('�������'#13#10'� �/� = <' + IfThen(DM.cdsInventoryListTopOrdUser.AsString = '', '�� ������������', DM.cdsInventoryListTopOrdUser.AsString) + '>'#13#10 +
                                   '���-�� = <' + DM.cdsInventoryListTopAmount.AsString + '>'#13#10 +
                                   '��� <' + DM.cdsInventoryListTopGoodsCode.AsString + '>'#13#10 +
                                   '������� <' + DM.cdsInventoryListTopArticle.AsString + '>'#13#10 +
                                   '<' + DM.cdsInventoryListTopGoodsName.AsString + '>'#13#10 +
                                   '�� ���������?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteInventoryGoods)
    else
    // ���������� �� ������
    if TButton(Sender).Tag = 4  then
    begin
       TDialogService.ShowMessage(DM.cdsInventoryListTopError.AsString);
    end;
  end else if (tcMain.ActiveTab = tiInventory) then
  begin
    // �������� ������� �������������
    if TButton(Sender).Tag = 1 then
    begin
      ShowEditInventoryListEdit;
    end else
    // �������� ������� ��������������
    if TButton(Sender).Tag = 2 then
      TDialogService.MessageDialog('�������'#13#10'� �/� = <' + DM.cdsInventoryListOrdUser.AsString +'>'#13#10 +
                                   '���-�� = <' + DM.cdsInventoryListAmount.AsString + '>'#13#10 +
                                   '��� <' + DM.cdsInventoryListGoodsCode.AsString + '>'#13#10 +
                                   '������� <' + DM.cdsInventoryListArticle.AsString + '>'#13#10 +
                                   '<' + DM.cdsInventoryListGoodsName.AsString + '>'#13#10 +
                                   '�� ���������?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ErasedInventoryList)
    else
    // ������������� ������� ��������������
    if TButton(Sender).Tag = 3  then
    begin
      TDialogService.MessageDialog('�������� ��������'#13#10'� �/� = <' + DM.cdsInventoryListOrdUser.AsString +'>'#13#10 +
                                   '���-�� = <' + DM.cdsInventoryListAmount.AsString + '>'#13#10 +
                                   '��� <' + DM.cdsInventoryListGoodsCode.AsString + '>'#13#10 +
                                   '������� <' + DM.cdsInventoryListArticle.AsString + '>'#13#10 +
                                   '<' + DM.cdsInventoryListGoodsName.AsString + '>'#13#10 +
                                   '� ���������?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, UnErasedInventoryList)
    end;
  end else if (tcMain.ActiveTab = tiSendScan) then
  begin
    // �������� ������� �������������
    if TButton(Sender).Tag = 1 then
    begin
      ShowEditSendItemEdit;
    end else
    // �������� ������� �������������
    if TButton(Sender).Tag = 2 then
      TDialogService.MessageDialog('�������'#13#10'� �/� = <' + IfThen(DM.cdsSendListTopOrdUser.AsString = '', '�� ������������', DM.cdsSendListTopOrdUser.AsString) + '>'#13#10 +
                                   '���-�� = <' + DM.cdsSendListTopAmount.AsString + '>'#13#10 +
                                   '��� <' + DM.cdsSendListTopGoodsCode.AsString + '>'#13#10 +
                                   '������� <' + DM.cdsSendListTopArticle.AsString + '>'#13#10 +
                                   '<' + DM.cdsSendListTopGoodsName.AsString + '>'#13#10 +
                                   '�� ���������?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteSendGoods)
    else
    // ���������� �� ������
    if TButton(Sender).Tag = 4  then
    begin
       TDialogService.ShowMessage(DM.cdsSendListTopError.AsString);
    end;
  end else if (tcMain.ActiveTab = tiSendList) then
  begin
    // �������� ������� �������������
    if TButton(Sender).Tag = 1 then
    begin
      ShowEditSendListEdit;
    end else
    // �������� ������� ��������������
    if TButton(Sender).Tag = 2 then
      TDialogService.MessageDialog('�������'#13#10'� �/� = <' + DM.cdsSendListOrdUser.AsString +'>'#13#10 +
                                   '���-�� = <' + DM.cdsSendListAmount.AsString + '>'#13#10 +
                                   '��� <' + DM.cdsSendListGoodsCode.AsString + '>'#13#10 +
                                   '������� <' + DM.cdsSendListArticle.AsString + '>'#13#10 +
                                   '<' + DM.cdsSendListGoodsName.AsString + '>'#13#10 +
                                   '�� ���������?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ErasedSendList)
    else
    // ������������� ������� ��������������
    if TButton(Sender).Tag = 3  then
    begin
      TDialogService.MessageDialog('�������� ��������'#13#10'� �/� = <' + DM.cdsSendListOrdUser.AsString +'>'#13#10 +
                                   '���-�� = <' + DM.cdsSendListAmount.AsString + '>'#13#10 +
                                   '��� <' + DM.cdsSendListGoodsCode.AsString + '>'#13#10 +
                                   '������� <' + DM.cdsSendListArticle.AsString + '>'#13#10 +
                                   '<' + DM.cdsSendListGoodsName.AsString + '>'#13#10 +
                                   '� ���������?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, UnErasedSendList)
    end;
  end else if (tcMain.ActiveTab = tiProductionUnionScan) then
  begin
    // �������� ������� �������������
    if TButton(Sender).Tag = 1 then
    begin
      ShowEditProductionUnionItem(DM.cdsProductionUnionListTopId.AsInteger);
    end else
    // �������� ������� �������������
    if TButton(Sender).Tag = 2 then
      TDialogService.MessageDialog('������� ������ ���� / �����'#13#10'� �/� = <' + DM.cdsProductionUnionListTopOrdUser.AsString + '>'#13#10 +
                                   '�������� = <' + DM.cdsProductionUnionListTopInvNumberFull.AsString + '>'#13#10 +
                                   '���-�� = <' + DM.cdsProductionUnionListTopAmount.AsString + '>'#13#10 +
                                   '��� <' + DM.cdsProductionUnionListTopGoodsCode.AsString + '>'#13#10 +
                                   '������� <' + DM.cdsProductionUnionListTopArticle.AsString + '>'#13#10 +
                                   '<' + DM.cdsProductionUnionListTopGoodsName.AsString + '> ?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteProductionUnionGoods)
    ;
  end else if (tcMain.ActiveTab = tiProductionUnionList) then
  begin
    // �������� ������� �������������
    if TButton(Sender).Tag = 1 then
    begin
      ShowEditProductionUnionItem(DM.cdsProductionUnionListId.AsInteger);
    end else
    // �������� ������� ��������������
    if TButton(Sender).Tag = 2 then
      TDialogService.MessageDialog('������� ������ ���� / �����'#13#10'� �/� = <' + DM.cdsProductionUnionListOrdUser.AsString +'>'#13#10 +
                                   '�������� = <' + DM.cdsProductionUnionListInvNumberFull.AsString + '>'#13#10 +
                                   '���-�� = <' + DM.cdsProductionUnionListAmount.AsString + '>'#13#10 +
                                   '��� <' + DM.cdsProductionUnionListGoodsCode.AsString + '>'#13#10 +
                                   '������� <' + DM.cdsProductionUnionListArticle.AsString + '>'#13#10 +
                                   '<' + DM.cdsProductionUnionListGoodsName.AsString + '> ?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ErasedProductionUnionList)
    else
    // ������������� ������� ��������������
    if TButton(Sender).Tag = 3  then
    begin
      TDialogService.MessageDialog('�������� �������� ������ ���� / �����'#13#10'� �/� = <' + DM.cdsProductionUnionListOrdUser.AsString +'>'#13#10 +
                                   '�������� = <' + DM.cdsProductionUnionListInvNumberFull.AsString + '>'#13#10 +
                                   '���-�� = <' + DM.cdsProductionUnionListAmount.AsString + '>'#13#10 +
                                   '��� <' + DM.cdsProductionUnionListGoodsCode.AsString + '>'#13#10 +
                                   '������� <' + DM.cdsProductionUnionListArticle.AsString + '>'#13#10 +
                                   '<' + DM.cdsProductionUnionListGoodsName.AsString + '> ?',
           TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, UnErasedProductionUnionList)
    end;
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

  FisTestWebServer := TRadioButton(Sender).Tag = 1;

  // �������� � ini �����
  SettingsFile := TIniFile.Create(FINIFile);
  try
    SettingsFile.WriteBool('Params', 'isTestWebServer', FisTestWebServer);
    FisTestWebServer := SettingsFile.ReadBool('Params', 'isTestWebServer', False);
  finally
    FreeAndNil(SettingsFile);
  end;

  if FisTestWebServer then
    PasswordLabel.Text := '������ (�������� ������)'
  else PasswordLabel.Text := '������';

  while pbWebServer.Items.Count > 1 do pbWebServer.Items.Delete(1);

  if FisTestWebServer then Res := TRegEx.Split(WebServerTest, ';')
  else Res := TRegEx.Split(WebServer, ';');

  for I := Low(Res) to High(Res) do pbWebServer.Items.Add(Res[I]);
  pbWebServer.ItemIndex := 0;
end;

procedure TfrmMain.OnScanResultGoods(Sender: TObject; AData_String: String);
  var S: String;
begin
  S := AData_String;
  while COPY(S, 1, 1) = '0' do S := COPY(S, 2, Length(S));

  GetSearshBox(lwGoods).Text := S;
end;

// ����� ������������� �� ���������
function TfrmMain.SearchByBarcode(AData_String: String) : Integer;
  var nId, nCount: Integer; Data_String: String;
begin

  Result := 0;
  Data_String := AData_String;


  if Length(Data_String) > 12 then
    Data_String := Copy(Data_String, 1, Length(Data_String) - 1);

  if Data_String = '' then Exit;

  // � ������ ���� �� ������� ���������� �� ������ ������
  if DM.GetGoodsBarcode(Data_String, nId, nCount) then
  begin
    if nCount = 1 then
    begin
      FGoodsId := nId;
      Result := 1;
    end else if nCount > 1 then
    begin
      GetSearshBox(lwGoods).Text := Data_String;
      DM.FilterGoodsEAN := True;
      Result := 2;
    end else
    begin
      Result := 3;
      TDialogService.ShowMessage('�������� �/� <' + AData_String + '> �� ������.', NoBarCodeNextScan)
    end;
    Exit;
  end;

  // ���� � �������� �� ����� ���� ��������
  DM.LoadGoodsEAN(Data_String);

  if DM.qurGoodsEAN.Active then
  begin
    if  DM.qurGoodsEAN.RecordCount = 1 then
    begin
      FGoodsId := DM.qurGoodsEANId.AsInteger;
      Result := 1;
    end else if DM.qurGoodsEAN.RecordCount > 1 then
    begin
      GetSearshBox(lwGoods).Text := Data_String;
      DM.FilterGoodsEAN := True;
      Result := 2;
    end else
    begin
      Result := 3;
      TDialogService.ShowMessage('�������� �/� <' + AData_String + '> �� ������.', NoBarCodeNextScan);
    end;
  end;
end;

// �������� ������ �� ����������� ������
procedure TfrmMain.ProcessOrderInternal(ID: Integer);
begin
  if DM.DownloadOrderInternal(Id) then
  begin
    FOrderInternal := Id;

    if DM.cdsProductionUnionItemEditId.AsInteger = 0 then
    begin
      if FScanType <> 3 then
      begin
        bpProductionUnion.Visible := (DM.cdsProductionUnionItemEditId.AsInteger = 0) and (DM.cdsProductionUnionItemEdit.RecordCount = 1);
        SwitchToForm(tiProductionUnionEdit, nil);
      end else
      begin
        ProductionUnionInsert(mrYes);
        NextScan;
      end;
    end else
    begin
      FOrderInternal := 0;
      FProductionUnion := DM.cdsProductionUnionItemEditId.AsInteger;
      TDialogService.MessageDialog('�� ������ ��� ������� ������ ����/�����'#13#10#13#10 + DM.cdsProductionUnionItemEditInvNumberFull.AsString,
        TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes], TMsgDlgBtn.mbYes, 0, ProductionUnionOpen)
    end;
  end;
end;

// ������������ ��������������� ������������� ��� ��������������
procedure TfrmMain.OnScanResultInventoryScan(Sender: TObject; AData_String: String);
begin
  FisScanOk := True;

  case SearchByBarcode(AData_String) of
    1 : ShowInventoryItemEdit;
    2 : bInventScanSearchClick(Sender);
    3 : ;
    else NextScan;
  end;
end;

// ������������ ��������������� ������������� ��� �����������
procedure TfrmMain.OnScanResultSendScan(Sender: TObject; AData_String: String);
  var InvNumber, InvNumberFull: String; ID: Integer;
begin

  // ���� ����� ��� ���������
  if COPY(AData_String, 1, LengTh(FDocBarCodePref)) = FDocBarCodePref then
  begin
    try
      if DM.GetOrderClient(AData_String, '', Id, InvNumber, InvNumberFull) then
      begin
        FOrderClientId := Id;
        FOrderClientInvNumber := InvNumber;
        FOrderClientInvNumberFull := InvNumberFull;
        edSSInvNumber_OrderClient.Text := InvNumberFull;
        bSendScanClear.Visible := True;
      end;
    except
      on E : Exception do TDialogService.ShowMessage(GetTextMessage(E));
    end;
  end else if COPY(AData_String, 1, LengTh(FItemBarCodePref)) = FItemBarCodePref then // ���� ����� ������
  begin

    FisScanOk := True;

    if Length(AData_String) > 12 then AData_String := Copy(AData_String, 1, Length(AData_String) - 1);

    if not TryStrToInt(COPY(AData_String, Length(FItemBarCodePref) + 1, 9), Id) then
    begin
      TDialogService.ShowMessage('�� ���������� �������� ' + AData_String);
      Exit;
    end;

    if DM.GetBarcodeSendOrderInternal(Id) then ShowSendItemEdit;
  end else
  begin
    FisScanOk := True;
    case SearchByBarcode(AData_String) of
      1 : ShowSendItemEdit;
      2 : bSendScanSearchClick(Sender);
      3 : ;
      else NextScan;
    end;
  end;
end;

// ������������ ��������������� ����� ��� ������������
procedure TfrmMain.OnScanProductionUnion(Sender: TObject; AData_String: String);
  var ID: Integer;
begin

  FisScanOk := True;

  if COPY(AData_String, 1, LengTh(FItemBarCodePref)) = FItemBarCodePref then // ���� ����� ������
  begin

    if Length(AData_String) > 12 then AData_String := Copy(AData_String, 1, Length(AData_String) - 1);

    if not TryStrToInt(COPY(AData_String, Length(FItemBarCodePref) + 1, 9), Id) then
    begin
      TDialogService.MessageDialog('�� ���������� �������� ' + AData_String,
        TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes], TMsgDlgBtn.mbYes, 0, ProductionUnionOpen);

      Exit;
    end;

    ProcessOrderInternal(ID);

  end else TDialogService.MessageDialog('�� ���������� �������� ' + AData_String,
             TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes], TMsgDlgBtn.mbYes, 0, ProductionUnionOpen);
end;

end.
