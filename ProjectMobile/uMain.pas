unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.Client, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.Layouts, FMX.TabControl, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, System.Rtti,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.Grid, FMX.Objects, FMX.ExtCtrls, FMX.ListView.Types, FMX.ListView,
  System.Sensors, System.Sensors.Components, FMX.WebBrowser, FMX.Memo,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ScrollBox,
  FMX.Platform, FMX.TMSWebGMaps, System.Math.Vectors, FMX.TMSWebGMapsGeocoding,
  FMX.TMSWebGMapsCommon, FMX.TMSWebGMapsReverseGeocoding, FMX.ListBox,
  FMX.DateTimeCtrls, FMX.Controls3D, FMX.Layers3D, FMX.Menus, Generics.Collections,
  FMX.Gestures, System.Actions, FMX.ActnList, System.ImageList, FMX.ImgList,
  FMX.Grid.Style, FMX.Media, FMX.Surfaces, FMX.VirtualKeyboard, FMX.SearchBox, IniFiles,
  FMX.Ani, FMX.DialogService, FMX.Utils, FMX.Styles, FMX.ComboEdit
  {$IFDEF ANDROID}
  ,FMX.Helpers.Android, Androidapi.Helpers,
  Androidapi.JNI.Location, Androidapi.JNIBridge,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  AndroidApi.JNI.WebKit
  {$ENDIF};

const
  // коефициенты для расчета растояния
  LatitudeRatio = '111.194926645';
  LongitudeRatio = '70.158308514';
  // размер шрифта по умолчанию
  DefaultSize = 11;

type
  TFormStackItem = record
    PageIndex: Integer;
    Data: TObject;
  end;

  TJuridicalItem = record
    Id: Integer;
    ContractIds: string;

    constructor Create(AId: Integer; AContractIds: string);
  end;

  TContractItem = record
    Id: Integer;
    Name: string;

    constructor Create(AId: Integer; AName: string);
  end;

  TPartnerItem = record
    Id: Integer;
    ContractIds: string;

    constructor Create(AId: integer; AContractIds: string);
  end;

  TLocationData = record
    Latitude: TLocationDegrees;
    Longitude: TLocationDegrees;
    VisitTime: TDateTime;

    constructor Create(ALatitude, ALongitude: TLocationDegrees; AVisitTime: TDateTime);
  end;

  TfrmMain = class(TForm)
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
    Layout5: TLayout;
    LogInButton: TButton;
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    tiMain: TTabItem;
    WebServerLayout1: TLayout;
    WebServerLabel: TLabel;
    WebServerLayout2: TLayout;
    WebServerEdit: TEdit;
    SyncLayout: TLayout;
    SyncCheckBox: TCheckBox;
    tiRoutes: TTabItem;
    VertScrollBox1: TVertScrollBox;
    tiPartners: TTabItem;
    pBack: TPanel;
    sbBack: TSpeedButton;
    Panel5: TPanel;
    lDayInfo: TLabel;
    lCaption: TLabel;
    blMain: TBindingsList;
    tiPartnerInfo: TTabItem;
    pPartnerInfo: TPanel;
    tiSync: TTabItem;
    imLogo: TImage;
    vsbMain: TVertScrollBox;
    bMonday: TButton;
    bFriday: TButton;
    bThursday: TButton;
    bWednesday: TButton;
    bTuesday: TButton;
    bSaturday: TButton;
    bAllDays: TButton;
    bSunday: TButton;
    lMondayCount: TLabel;
    lAllDaysCount: TLabel;
    lFridayCount: TLabel;
    lSaturdayCount: TLabel;
    lSundayCount: TLabel;
    lThursdayCount: TLabel;
    lTuesdayCount: TLabel;
    lWednesdayCount: TLabel;
    Image7: TImage;
    tcPartnerInfo: TTabControl;
    tiInfo: TTabItem;
    tiOrders: TTabItem;
    tiStoreReals: TTabItem;
    aiWait: TAniIndicator;
    sbPartnerMenu: TSpeedButton;
    Image8: TImage;
    ppPartner: TPopup;
    lbPartnerMenu: TListBox;
    ibiNewPartner: TListBoxItem;
    lbiSummery: TListBoxItem;
    lbiShowAllOnMap: TListBoxItem;
    lbiReports: TListBoxItem;
    tiMap: TTabItem;
    gmPartnerInfo: TGestureManager;
    acMain: TActionList;
    ChangePartnerInfoLeft: TChangeTabAction;
    ChangePartnerInfoRight: TChangeTabAction;
    ChangeMainPage: TChangeTabAction;
    tiHandbook: TTabItem;
    VertScrollBox2: TVertScrollBox;
    bPriceList: TButton;
    sbMain: TStyleBook;
    bRoute: TButton;
    bPartners: TButton;
    tiPriceList: TTabItem;
    tiPriceListItems: TTabItem;
    tiOrderExternal: TTabItem;
    VertScrollBox3: TVertScrollBox;
    tiGoodsItems: TTabItem;
    Panel3: TPanel;
    bCancelOI: TButton;
    bSaveOI: TButton;
    Panel4: TPanel;
    lwPartner: TListView;
    bsPartner: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    ilPartners: TImageList;
    pOrderTotals: TPanel;
    lTotalPrice: TLabel;
    pSaveOrderExternal: TPanel;
    Panel9: TPanel;
    Label11: TLabel;
    deOrderDate: TDateEdit;
    lTotalWeight: TLabel;
    tiCamera: TTabItem;
    Panel10: TPanel;
    imgCameraPreview: TImage;
    Panel11: TPanel;
    tiPhotos: TTabItem;
    Panel12: TPanel;
    Panel13: TPanel;
    bAddedPhotoGroup: TButton;
    bCapture: TButton;
    bSavePartnerPhoto: TButton;
    bClosePhoto: TButton;
    lwPartnerPhotoGroups: TListView;
    lwOrderExternalItems: TListView;
    LinkListControlToFieldOrderExternalItems: TLinkListControlToField;
    Panel14: TPanel;
    lOrderPrice: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label21: TLabel;
    bAddOrderItem: TButton;
    Image10: TImage;
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
    lwGoodsItems: TListView;
    Popup1: TPopup;
    Panel15: TPanel;
    Label12: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Label23: TLabel;
    Panel16: TPanel;
    Label24: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    LinkFillControlToField1: TLinkFillControlToField;
    bMinusAmount: TButton;
    VertScrollBox4: TVertScrollBox;
    Label19: TLabel;
    Label28: TLabel;
    lPartnerAddress: TLabel;
    lPartnerName: TLabel;
    lwOrderExternalList: TListView;
    LinkListControlToFieldOrderExternal: TLinkListControlToField;
    pNewOrderExternal: TPanel;
    bNewOrderExternal: TButton;
    tSavePath: TTimer;
    tiPathOnMap: TTabItem;
    Panel18: TPanel;
    Label26: TLabel;
    deDatePath: TDateEdit;
    pPathOnMap: TPanel;
    cbShowAllPath: TCheckBox;
    bRefreshPathOnMap: TButton;
    Image13: TImage;
    tiReturnIns: TTabItem;
    tiPhotosList: TTabItem;
    lwPhotos: TListView;
    pAddPhoto: TPanel;
    bAddedPhoto: TButton;
    pNewPhotoGroup: TPanel;
    bSavePG: TButton;
    bCanclePG: TButton;
    ePhotoGroupName: TEdit;
    Label29: TLabel;
    bsPhotoGroups: TBindSourceDB;
    LinkListControlToField6: TLinkListControlToField;
    bsPhotos: TBindSourceDB;
    LinkListControlToField7: TLinkListControlToField;
    bsOrderExternal: TBindSourceDB;
    tiPhotoEdit: TTabItem;
    Panel19: TPanel;
    bSavePhotoComment: TButton;
    Panel20: TPanel;
    Label30: TLabel;
    ePhotoCommentEdit: TEdit;
    imPhoto: TImage;
    lwStoreRealList: TListView;
    Panel21: TPanel;
    bNewStoreReal: TButton;
    tiStoreReal: TTabItem;
    VertScrollBox5: TVertScrollBox;
    pSaveStoreReal: TPanel;
    bSaveStoreRealUnComplete: TButton;
    lwStoreRealItems: TListView;
    Panel24: TPanel;
    Label33: TLabel;
    eStoreRealComment: TEdit;
    bsStoreReals: TBindSourceDB;
    LinkListControlToFieldStoreReal: TLinkListControlToField;
    bAddStoreRealItem: TButton;
    Image14: TImage;
    LinkListControlToFieldStoreRealItems: TLinkListControlToField;
    lPriceWithPercent: TLabel;
    pPhotoComment: TPanel;
    bSavePhoto: TButton;
    bCancelPhoto: TButton;
    ePhotoComment: TEdit;
    Label15: TLabel;
    lPromoPrice: TLabel;
    pShowOnlyPromo: TPanel;
    cbOnlyPromo: TCheckBox;
    lwReturnInList: TListView;
    Panel2: TPanel;
    bNewReturnIn: TButton;
    tiReturnIn: TTabItem;
    lwReturnInItems: TListView;
    Panel6: TPanel;
    lReturnInPrice: TLabel;
    Label34: TLabel;
    bAddReturnInItem: TButton;
    Image9: TImage;
    pSaveReturnIn: TPanel;
    Panel22: TPanel;
    Label35: TLabel;
    deReturnDate: TDateEdit;
    pReturnInTotals: TPanel;
    lTotalPriceReturn: TLabel;
    lTotalWeightReturn: TLabel;
    lPriceWithPercentReturn: TLabel;
    Panel26: TPanel;
    Label20: TLabel;
    eReturnComment: TEdit;
    LinkListControlToFieldReturnInItems: TLinkListControlToField;
    bsReturnIn: TBindSourceDB;
    LinkListControlToFieldReturnIn: TLinkListControlToField;
    bSyncData: TButton;
    pProgress: TPanel;
    Layout6: TLayout;
    pieProgress: TPie;
    pieAllProgress: TPie;
    Pie3: TPie;
    lProgress: TLabel;
    lProgressName: TLabel;
    Panel25: TPanel;
    Panel27: TPanel;
    cbLoadData: TCheckBox;
    cbUploadData: TCheckBox;
    tErrorMap: TTimer;
    lwPriceListGoods: TListView;
    Popup2: TPopup;
    Panel28: TPanel;
    Label10: TLabel;
    Button1: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Button28: TButton;
    Label13: TLabel;
    bPromoPartners: TButton;
    tiPromoPartners: TTabItem;
    tiPromoGoods: TTabItem;
    lwPriceList: TListView;
    bsPriceList: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    tiInformation: TTabItem;
    VertScrollBox6: TVertScrollBox;
    lUnitRet: TLayout;
    Label36: TLabel;
    UnitNameRet: TEdit;
    lMember: TLayout;
    Label37: TLabel;
    eMemberName: TEdit;
    lSyncDateIn: TLayout;
    Label38: TLabel;
    eSyncDateIn: TEdit;
    lWebService: TLayout;
    Label39: TLabel;
    eWebService: TEdit;
    lCash: TLayout;
    Label40: TLabel;
    eCashName: TEdit;
    lUnit: TLayout;
    Label22: TLabel;
    eUnitName: TEdit;
    lMobileVersion: TLayout;
    Label31: TLabel;
    eMobileVersion: TEdit;
    lSyncDateOut: TLayout;
    Label32: TLabel;
    SyncDateOut: TEdit;
    bsStoreRealItems: TBindSourceDB;
    bsOrderExternalItems: TBindSourceDB;
    bsReturnInItems: TBindSourceDB;
    bsGoodsItems: TBindSourceDB;
    bsPriceListGoods: TBindSourceDB;
    LinkListControlToField12: TLinkListControlToField;
    lwPromoGoods: TListView;
    Popup3: TPopup;
    Panel29: TPanel;
    Label17: TLabel;
    Button29: TButton;
    Button30: TButton;
    Button31: TButton;
    Button32: TButton;
    Button33: TButton;
    Button34: TButton;
    Button35: TButton;
    Button36: TButton;
    Button37: TButton;
    Button38: TButton;
    Button39: TButton;
    Button40: TButton;
    Button41: TButton;
    Button42: TButton;
    Label18: TLabel;
    bPromoGoods: TButton;
    lwPromoPartners: TListView;
    pPromoPartnerDate: TPanel;
    Label41: TLabel;
    dePromoPartnerDate: TDateEdit;
    pPromoGoodsDate: TPanel;
    Label42: TLabel;
    dePromoGoodsDate: TDateEdit;
    bsPromoPartners: TBindSourceDB;
    LinkListControlToField4: TLinkListControlToField;
    bsPromoGoods: TBindSourceDB;
    LinkListControlToField13: TLinkListControlToField;
    tiReports: TTabItem;
    bReportJuridicalCollation: TButton;
    tiReportJuridicalCollation: TTabItem;
    VertScrollBox7: TVertScrollBox;
    Layout7: TLayout;
    Label43: TLabel;
    deStartRJC: TDateEdit;
    Layout10: TLayout;
    Layout11: TLayout;
    Label44: TLabel;
    deEndRJC: TDateEdit;
    Layout12: TLayout;
    Layout13: TLayout;
    Label45: TLabel;
    cbJuridicals: TComboBox;
    Layout14: TLayout;
    Label46: TLabel;
    cbContracts: TComboBox;
    Panel30: TPanel;
    bPrintJuridicalCollation: TButton;
    tiPrintJuridicalCollation: TTabItem;
    lwJuridicalCollation: TListView;
    LinkListControlToField14: TLinkListControlToField;
    Panel31: TPanel;
    Layout15: TLayout;
    Label47: TLabel;
    cbPaidKind: TComboBox;
    Panel32: TPanel;
    lStartRemains: TLabel;
    lEndRemains: TLabel;
    lTotalDebit: TLabel;
    lTotalKredit: TLabel;
    VertScrollBox8: TVertScrollBox;
    bHandBook: TButton;
    Image1: TImage;
    Label1: TLabel;
    bVisit: TButton;
    Image2: TImage;
    Label5: TLabel;
    bTasks: TButton;
    Image5: TImage;
    Label6: TLabel;
    bReport: TButton;
    Image6: TImage;
    Label7: TLabel;
    bSync: TButton;
    Image3: TImage;
    Label8: TLabel;
    bInfo: TButton;
    Image4: TImage;
    lTasks: TLabel;
    tiPartnerTasks: TTabItem;
    tTasks: TTimer;
    tiTasks: TTabItem;
    lwTasks: TListView;
    Panel33: TPanel;
    bsTasks: TBindSourceDB;
    LinkListControlToFieldTasks: TLinkListControlToField;
    pTaskComment: TPanel;
    bSaveTask: TButton;
    bCancelTask: TButton;
    eTaskComment: TEdit;
    Label9: TLabel;
    rbAllTask: TRadioButton;
    rbOpenTask: TRadioButton;
    rbCloseTask: TRadioButton;
    bRefreshTasks: TButton;
    Image17: TImage;
    cbUseDateTask: TCheckBox;
    deDateTask: TDateEdit;
    lwPartnerTasks: TListView;
    LinkListControlToField16: TLinkListControlToField;
    lServerVersion: TLayout;
    Label48: TLabel;
    eServerVersion: TEdit;
    bUpdateProgram: TButton;
    Circle1: TCircle;
    Layout16: TLayout;
    Layout17: TLayout;
    Layout18: TLayout;
    Layout19: TLayout;
    cbPartners: TComboBox;
    Layout20: TLayout;
    Label50: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    Label51: TLabel;
    Label52: TLabel;
    bsJuridicalCollation: TBindSourceDB;
    GridPanelLayout2: TGridPanelLayout;
    GridPanelLayout3: TGridPanelLayout;
    tiNewPartner: TTabItem;
    VertScrollBox9: TVertScrollBox;
    Panel34: TPanel;
    bSaveNewPartner: TButton;
    Layout21: TLayout;
    Layout22: TLayout;
    Label53: TLabel;
    cSelectJuridical: TCheckBox;
    cbNewPartnerJuridical: TComboBox;
    eNewPartnerJuridical: TEdit;
    Layout23: TLayout;
    Layout24: TLayout;
    Label54: TLabel;
    Layout25: TLayout;
    Layout26: TLayout;
    Label55: TLabel;
    eNewPartnerAddress: TEdit;
    Layout27: TLayout;
    GridPanelLayout4: TGridPanelLayout;
    Label56: TLabel;
    Label57: TLabel;
    GridPanelLayout5: TGridPanelLayout;
    eNewPartnerGPSN: TEdit;
    eNewPartnerGPSE: TEdit;
    bNewPartnerGPS: TButton;
    Label49: TLabel;
    lPartnerKind: TLabel;
    Label59: TLabel;
    lPartnerDebt: TLabel;
    Label61: TLabel;
    lPartnerOver: TLabel;
    Label63: TLabel;
    lPartnerOverDay: TLabel;
    Layout28: TLayout;
    Layout29: TLayout;
    Layout30: TLayout;
    Layout31: TLayout;
    Layout32: TLayout;
    Layout33: TLayout;
    WebGMapsReverseGeocoder: TTMSFMXWebGMapsReverseGeocoding;
    Panel35: TPanel;
    Label58: TLabel;
    eOrderComment: TEdit;
    GridPanelLayout6: TGridPanelLayout;
    bSaveStoreRealComplete: TButton;
    GridPanelLayout7: TGridPanelLayout;
    Label60: TLabel;
    Label62: TLabel;
    GridPanelLayout8: TGridPanelLayout;
    Label64: TLabel;
    Label65: TLabel;
    GridPanelLayout9: TGridPanelLayout;
    bSaveOrderExternalUnComplete: TButton;
    GridPanelLayout10: TGridPanelLayout;
    Label66: TLabel;
    Label67: TLabel;
    bSaveOrderExternalComplete: TButton;
    GridPanelLayout11: TGridPanelLayout;
    Label68: TLabel;
    Label69: TLabel;
    GridPanelLayout12: TGridPanelLayout;
    bSaveReturnInUnComplete: TButton;
    GridPanelLayout13: TGridPanelLayout;
    Label70: TLabel;
    Label71: TLabel;
    bSaveReturnInComplete: TButton;
    GridPanelLayout14: TGridPanelLayout;
    Label72: TLabel;
    Label73: TLabel;
    bDocuments: TButton;
    Image18: TImage;
    Label74: TLabel;
    bRelogin: TButton;
    Image19: TImage;
    Label75: TLabel;
    tiDocuments: TTabItem;
    tcDocuments: TTabControl;
    tiStoreRealDocs: TTabItem;
    lwStoreRealDocs: TListView;
    tiOrderDocs: TTabItem;
    lwOrderDocs: TListView;
    tiReturnInDocs: TTabItem;
    lwReturnInDocs: TListView;
    Panel41: TPanel;
    bRefreshDoc: TButton;
    Image16: TImage;
    Layout34: TLayout;
    Label76: TLabel;
    deStartDoc: TDateEdit;
    Label77: TLabel;
    deEndDoc: TDateEdit;
    tiPartnerMap: TTabItem;
    pMap: TPanel;
    lNoMap: TLabel;
    bRefreshMapScreen: TButton;
    Image15: TImage;
    pMapButtons: TPanel;
    bSetPartnerCoordinate: TButton;
    Image11: TImage;
    WebGMapsGeocoder: TTMSFMXWebGMapsGeocoding;
    Layout35: TLayout;
    Label78: TLabel;
    lPartnerAddressGPS: TLabel;
    tiPhotoDocs: TTabItem;
    lwPhotoDocs: TListView;
    bshotoGroupDocs: TBindSourceDB;
    LinkListControlToField3: TLinkListControlToField;
    imCapture: TImage;
    imRevert: TImage;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel17: TPanel;
    Panel23: TPanel;
    Image12: TImage;
    Panel36: TPanel;
    Layout36: TLayout;
    Label79: TLabel;
    lContractName: TLabel;
    Layout37: TLayout;
    gbPartnerDebt: TGroupBox;
    gbPartnerAllDebt: TGroupBox;
    Layout38: TLayout;
    Label80: TLabel;
    lPartnerAllOver: TLabel;
    Layout39: TLayout;
    Label82: TLabel;
    lPartnerAllDebt: TLabel;
    Layout40: TLayout;
    Label84: TLabel;
    lPartnerAllOverDay: TLabel;
    lCurWebService: TLayout;
    Label81: TLabel;
    eCurWebService: TEdit;
    bPathonMap: TButton;
    bPathonMapbyPhoto: TButton;
    bEnterServer: TButton;
    Image20: TImage;
    pTemporaryServerPassword: TPanel;
    bOkPassword: TButton;
    bCancelPassword: TButton;
    ePassword: TEdit;
    Label83: TLabel;
    tiCash: TTabItem;
    lwCashList: TListView;
    Panel37: TPanel;
    bNewCash: TButton;
    pEnterMovmentCash: TPanel;
    bSaveCash: TButton;
    bCancelCash: TButton;
    eCashAmount: TEdit;
    Panel38: TPanel;
    Panel39: TPanel;
    Label86: TLabel;
    Label87: TLabel;
    Panel40: TPanel;
    eCashComment: TEdit;
    bsCash: TBindSourceDB;
    LinkListControlToFieldCash: TLinkListControlToField;
    tiCashDocs: TTabItem;
    lwCashDocs: TListView;
    Panel42: TPanel;
    Label85: TLabel;
    deCashDate: TDateEdit;
    procedure LogInButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bInfoClick(Sender: TObject);
    procedure bVisitClick(Sender: TObject);
    procedure sbBackClick(Sender: TObject);
    procedure lwPartnerItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bMondayClick(Sender: TObject);
    procedure sbPartnerMenuClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbiShowAllOnMapClick(Sender: TObject);
    procedure ChangePartnerInfoLeftUpdate(Sender: TObject);
    procedure ChangePartnerInfoRightUpdate(Sender: TObject);
    procedure ChangeMainPageUpdate(Sender: TObject);
    procedure bHandBookClick(Sender: TObject);
    procedure bRouteClick(Sender: TObject);
    procedure bPartnersClick(Sender: TObject);
    procedure bPriceListClick(Sender: TObject);
    procedure lwPriceListItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bNewOrderExternalClick(Sender: TObject);
    procedure lwGoodsItemsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwGoodsItemsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwGoodsItemsFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure bCancelOIClick(Sender: TObject);
    procedure bSaveOIClick(Sender: TObject);
    procedure bAddedPhotoGroupClick(Sender: TObject);
    procedure bCaptureClick(Sender: TObject);
    procedure bSavePartnerPhotoClick(Sender: TObject);
    procedure bClosePhotoClick(Sender: TObject);
    procedure bAddOrderItemClick(Sender: TObject);
    procedure lwOrderExternalItemsItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure b0Click(Sender: TObject);
    procedure bClearAmountClick(Sender: TObject);
    procedure bEnterAmountClick(Sender: TObject);
    procedure bAddAmountClick(Sender: TObject);
    procedure lwOrderExternalItemsFilter(Sender: TObject; const AFilter,
      AValue: string; var Accept: Boolean);
    procedure bMinusAmountClick(Sender: TObject);
    procedure lwOrderExternalListItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure bSetPartnerCoordinateClick(Sender: TObject);
    procedure tSavePathTimer(Sender: TObject);
    procedure cbShowAllPathChange(Sender: TObject);
    procedure bRefreshPathOnMapClick(Sender: TObject);
    procedure bPathonMapClick(Sender: TObject);
    procedure bAddedPhotoClick(Sender: TObject);
    procedure bCanclePGClick(Sender: TObject);
    procedure bSavePGClick(Sender: TObject);
    procedure lwPartnerPhotoGroupsItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure lwPhotosUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwOrderExternalItemsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwOrderExternalListUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwPartnerUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwPhotosItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure bSavePhotoCommentClick(Sender: TObject);
    procedure lwStoreRealListUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwStoreRealListItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure lwStoreRealItemsFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure lwStoreRealItemsItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure lwStoreRealItemsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bNewStoreRealClick(Sender: TObject);
    procedure bSaveStoreRealUnCompleteClick(Sender: TObject);
    procedure bAddStoreRealItemClick(Sender: TObject);
    procedure lwPartnerPhotoGroupsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure lwPriceListGoodsFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure bSavePhotoClick(Sender: TObject);
    procedure bCancelPhotoClick(Sender: TObject);
    procedure cbOnlyPromoChange(Sender: TObject);
    procedure lwReturnInListItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure lwReturnInListUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bAddReturnInItemClick(Sender: TObject);
    procedure bNewReturnInClick(Sender: TObject);
    procedure bSyncDataClick(Sender: TObject);
    procedure bSyncClick(Sender: TObject);
    procedure tErrorMapTimer(Sender: TObject);
    procedure bRefreshMapScreenClick(Sender: TObject);
    procedure bTasksClick(Sender: TObject);
    procedure bPromoPartnersClick(Sender: TObject);
    procedure lwPromoGoodsFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure lwPromoPartnersUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure dePromoPartnerDateChange(Sender: TObject);
    procedure lwPromoPartnersItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bPromoGoodsClick(Sender: TObject);
    procedure dePromoGoodsDateChange(Sender: TObject);
    procedure lwPromoGoodsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwPromoGoodsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bReportClick(Sender: TObject);
    procedure bReportJuridicalCollationClick(Sender: TObject);
    procedure cbJuridicalsChange(Sender: TObject);
    procedure bPrintJuridicalCollationClick(Sender: TObject);
    procedure bReloginClick(Sender: TObject);
    procedure tTasksTimer(Sender: TObject);
    procedure bCancelTaskClick(Sender: TObject);
    procedure bSaveTaskClick(Sender: TObject);
    procedure lwTasksItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure LinkListControlToFieldTasksFilledListItem(Sender: TObject;
      const AEditor: IBindListEditorItem);
    procedure cbUseDateTaskChange(Sender: TObject);
    procedure bRefreshTasksClick(Sender: TObject);
    procedure lwPartnerTasksUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwPartnerTasksItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure bUpdateProgramClick(Sender: TObject);
    procedure cbPartnersChange(Sender: TObject);
    procedure cSelectJuridicalChange(Sender: TObject);
    procedure ibiNewPartnerClick(Sender: TObject);
    procedure bNewPartnerGPSClick(Sender: TObject);
    procedure bSaveNewPartnerClick(Sender: TObject);
    procedure eNewPartnerGPSNValidate(Sender: TObject; var Text: string);
    procedure LinkListControlToFieldStoreRealFilledListItem(Sender: TObject;
      const AEditor: IBindListEditorItem);
    procedure LinkListControlToFieldOrderExternalFilledListItem(Sender: TObject;
      const AEditor: IBindListEditorItem);
    procedure LinkListControlToFieldReturnInFilledListItem(Sender: TObject;
      const AEditor: IBindListEditorItem);
    procedure bSaveOrderExternalUnCompleteClick(Sender: TObject);
    procedure bSaveReturnInUnCompleteClick(Sender: TObject);
    procedure lwReturnInItemsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure LinkListControlToFieldStoreRealItemsFilledListItem(
      Sender: TObject; const AEditor: IBindListEditorItem);
    procedure LinkListControlToFieldOrderExternalItemsFilledListItem(Sender: TObject;
      const AEditor: IBindListEditorItem);
    procedure LinkListControlToFieldReturnInItemsFilledListItem(Sender: TObject;
      const AEditor: IBindListEditorItem);
    procedure lwReturnInItemsItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure lwReturnInItemsFilter(Sender: TObject; const AFilter,
      AValue: string; var Accept: Boolean);
    procedure lwTasksUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bDocumentsClick(Sender: TObject);
    procedure lwStoreRealDocsItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure lwStoreRealDocsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bRefreshDocClick(Sender: TObject);
    procedure lwOrderDocsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwOrderDocsItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure lwReturnInDocsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwReturnInDocsItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure tcPartnerInfoChange(Sender: TObject);
    procedure lwPhotoDocsItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure imCaptureClick(Sender: TObject);
    procedure lwPartnerFilter(Sender: TObject; const AFilter, AValue: string;
      var Accept: Boolean);
    procedure bPathonMapbyPhotoClick(Sender: TObject);
    procedure bCancelPasswordClick(Sender: TObject);
    procedure bOkPasswordClick(Sender: TObject);
    procedure bEnterServerClick(Sender: TObject);
    procedure lwCashListUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bNewCashClick(Sender: TObject);
    procedure bCancelCashClick(Sender: TObject);
    procedure bSaveCashClick(Sender: TObject);
    procedure LinkListControlToFieldCashFilledListItem(Sender: TObject;
      const AEditor: IBindListEditorItem);
    procedure bDotClick(Sender: TObject);
    procedure eCashAmountValidate(Sender: TObject; var Text: string);
    procedure lwCashListItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure lwCashDocsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwCashDocsItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    { Private declarations }
    FFormsStack: TStack<TFormStackItem>;
    FJuridicalList: TList<TJuridicalItem>;
    FPartnerList: TList<TPartnerItem>;
    FAllContractList: TList<TContractItem>;
    FContractIdList: TList<integer>;
    FPaidKindIdList: TList<integer>;

    FCanEditPartner : boolean;

    FCurCoordinatesSet: boolean;
    FCurCoordinates: TLocationCoord2D;
    FMapLoaded: Boolean;
    FMarkerList: TList<TLocationData>;
    FWebGMap: TTMSFMXWebGMaps;

    FCheckedGooodsItems: TList<String>;
    FDeletedOI: TList<Integer>;
    FOrderTotalCountKg : Currency;
    FOrderTotalPrice : Currency;
    FDeletedSRI: TList<Integer>;
    FDeletedRI: TList<Integer>;
    FReturnInTotalCountKg : Currency;
    FReturnInTotalPrice : Currency;

    FCameraZoomDistance: Integer;
    CameraComponent : TCameraComponent;

    FTemporaryServer: string;
    FUseTemporaryServer: boolean;
    FFirstSet: boolean;
    FStartRJC: string;
    FEndRJC: string;
    FJuridicalRJC: integer;
    FPartnerRJC: integer;
    FContractRJC: integer;
    FPaidKindRJC: integer;

    FOldCashId: integer;

    FDeafultStyleName: string;

    FCanEditDocument: boolean;

    FEditDocuments: boolean;

    FPhotoPath: boolean;

    procedure OnCloseDialog(const AResult: TModalResult);
    procedure BackResult(const AResult: TModalResult);
    procedure SaveOrderExtrernal(const AResult: TModalResult);
    procedure SaveStoreReal(const AResult: TModalResult);
    procedure SaveReturnIn(const AResult: TModalResult);
    procedure DeleteOrderExtrernal(const AResult: TModalResult);
    procedure DeleteStoreReal(const AResult: TModalResult);
    procedure DeleteReturnIn(const AResult: TModalResult);
    procedure DeleteMovementCash(const AResult: TModalResult);
    procedure DeletePhotoGroup(const AResult: TModalResult);
    procedure DeletePhotoGroupDoc(const AResult: TModalResult);
    procedure DeletePhoto(const AResult: TModalResult);
    procedure CreateEditStoreReal(const AResult: TModalResult);
    procedure CreateEditOrderExtrernal(New: boolean);
    procedure CreateEditReturnIn(New: boolean);
    procedure CreateEditMovementCash(New: boolean);
    procedure SetPartnerCoordinates(const AResult: TModalResult);

    function GetAddress(const Latitude, Longitude: Double): string;
    function GetCoordinates(const Address: string; out Coordinates: TLocationCoord2D): Boolean;
    procedure WebGMapDownloadFinish(Sender: TObject);
    procedure ShowBigMap;
    procedure GetPartnerMap(GPSN, GPSE: Double);

    procedure ChangeStatusIcon(ACurItem: TListViewItem);
    procedure DeleteButtonHide(AItem: TListViewItem);
    procedure ChangeTaskView(AItem: TListViewItem);

    procedure Wait(AWait: Boolean);
    procedure CheckDataBase;
    procedure GetVistDays;
    procedure EnterNewPartner;
    procedure ShowPartners(Day : integer; Caption : string);
    procedure ShowPartnerInfo;
    procedure ChangeStoreRealDoc;
    procedure BuildStoreRealDocsList;
    procedure ChangeOrderExternalDoc;
    procedure BuildOrderExternalDocsList;
    procedure ChangeReturnInDoc;
    procedure BuildReturnInDocsList;
    procedure ChangeCashDoc;
    procedure BuildCashDocsList;
    procedure ShowDocuments;
    procedure ShowPriceLists;
    procedure ShowPriceListItems;
    procedure ShowPromoPartners;
    procedure ShowPromoGoodsByPartner;
    procedure ShowPromoGoods;
    procedure ShowPromoPartnersByGoods;
    procedure ShowPathOnmap;
    procedure ShowPhotos(GroupId: integer);
    procedure ShowPhoto;
    procedure ShowInformation;
    procedure ShowTasks(ShowAll: boolean = true);
    procedure AddedNewStoreRealItems;
    procedure AddedNewOrderItems;
    procedure AddedNewReturnInItems;
    procedure RecalculateTotalPriceAndWeight;
    procedure RecalculateReturnInTotalPriceAndWeight;
    procedure SwitchToForm(const TabItem: TTabItem; const Data: TObject);
    procedure ReturnPriorForm(const OmitOnChange: Boolean = False);


    procedure PrepareCamera;
    procedure CameraFree;
    procedure ScaleImage(const Margins: Integer);
    procedure GetImage;
    procedure PlayAudio;
    procedure CameraComponentSampleBufferReady(Sender: TObject; const ATime: TMediaTime);

    procedure GetCurrentCoordinates;

    procedure AddComboItem(AComboBox: TComboBox; AText: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uConstants, System.IOUtils, Authentication, Storage, CommonData, uDM, CursorUtils,
  uNetwork;

{$R *.fmx}

function CorrectPassword : string;
begin
    { Obscure the 'cupcdvum' password a little. }
    {Result := 'um';
    Result := 'dv' + Result;
    Result := 'pc' + Result;
    Result := 'cu' + Result; }
    Result := '111';
end;

{ TJuridicalItem }
constructor TJuridicalItem.Create(AId: Integer; AContractIds: string);
begin
  Id := AId;
  ContractIds := AContractIds;
end;

{ TContractItem }
constructor TContractItem.Create(AId: Integer; AName: string);
begin
  Id := AId;
  Name := AName;
end;

{ TPartnerItem }
constructor TPartnerItem.Create(AId: integer; AContractIds: string);
begin
  Id := AId;
  ContractIds := AContractIds;
end;

{ TLocationData }
constructor TLocationData.Create(ALatitude, ALongitude: TLocationDegrees; AVisitTime: TDateTime);
begin
  Latitude := ALatitude;
  Longitude := ALongitude;
  VisitTime := AVisitTime;
end;

{ TfrmMain }
procedure TfrmMain.FormCreate(Sender: TObject);
var
  {$IFDEF ANDROID}
  ScreenService: IFMXScreenService;
  OrientSet: TScreenOrientations;
  {$ENDIF}
  SettingsFile : TIniFile;
begin
  FormatSettings.DecimalSeparator := '.';

  // получение настроек из ini файла
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  SettingsFile := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'settings.ini'));
  {$ELSE}
  SettingsFile := TIniFile.Create('settings.ini');
  {$ENDIF}
  try
    LoginEdit.Text := SettingsFile.ReadString('LOGIN', 'USERNAME', '');
    FTemporaryServer := SettingsFile.ReadString('LOGIN', 'TemporaryServer', '');

    // for reports
    FStartRJC := SettingsFile.ReadString('REPORT', 'StartRJC', '');
    FEndRJC := SettingsFile.ReadString('REPORT', 'EndRJC', '');
    FJuridicalRJC := SettingsFile.ReadInteger('REPORT', 'JuridicalRJC', -1);
    FPartnerRJC := SettingsFile.ReadInteger('REPORT', 'PartnerRJC', -1);
    FContractRJC := SettingsFile.ReadInteger('REPORT', 'ContractRJC', -1);
    FPaidKindRJC := SettingsFile.ReadInteger('REPORT', 'PaidKindRJC', -1);

    FDeafultStyleName := SettingsFile.ReadString('STYLES', 'GLOBAL', 'Default');
  finally
    FreeAndNil(SettingsFile);
  end;

  // установка вертикального положения экрана телефона
  {$IFDEF ANDROID}
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
  begin
    OrientSet := [TScreenOrientation.Portrait];
    ScreenService.SetScreenOrientation(OrientSet);
  end;
  {$ENDIF}

  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  bAddedPhoto.Enabled := true;
  bSetPartnerCoordinate.Enabled := true;
  {$ELSE}
  bAddedPhoto.Enabled := false;
  bSetPartnerCoordinate.Enabled := false;
  {$ENDIF}

  FFormsStack := TStack<TFormStackItem>.Create;
  FMarkerList := TList<TLocationData>.Create;
  FCheckedGooodsItems := TList<String>.Create;
  FDeletedOI := TList<Integer>.Create;
  FDeletedSRI := TList<Integer>.Create;
  FDeletedRI := TList<Integer>.Create;
  FCurCoordinatesSet := false;

  FJuridicalList := TList<TJuridicalItem>.Create;
  FPartnerList := TList<TPartnerItem>.Create;
  FAllContractList := TList<TContractItem>.Create;
  FContractIdList := TList<integer>.Create;
  FPaidKindIdList := TList<integer>.Create;

  SwitchToForm(tiStart, nil);
  ChangeMainPageUpdate(tcMain);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FWebGMap) then
  try
    FWebGMap.Visible := False;
    FreeAndNil(FWebGMap);
  except
    // buggy piece of shit
  end;

  FFormsStack.Free;
  FMarkerList.Free;
  FCheckedGooodsItems.Free;
  FDeletedSRI.Free;
  FDeletedRI.Free;
  FDeletedOI.Free;

  FJuridicalList.Free;
  FPartnerList.Free;
  FAllContractList.Free;
  FContractIdList.Free;
  FPaidKindIdList.Free;
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
      if ppPartner.IsOpen then
        ppPartner.IsOpen := false
      else
      if pTemporaryServerPassword.Visible then
        bCancelPasswordClick(bCancelPassword)
      else
      if pEnterMovmentCash.Visible then
        bCancelCashClick(bCancelCash)
      else
      if pNewPhotoGroup.Visible then
        bCanclePGClick(bCanclePG)
      else
      if pPhotoComment.Visible then
        bCancelPhotoClick(bCancelPhoto)
      else
      if pTaskComment.Visible then
        bCancelTaskClick(bCancelTask)
      else
      if tcMain.ActiveTab = tiStart then
        TDialogService.MessageDialog('Закрыть программу?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], TMsgDlgBtn.mbCancel, -1, OnCloseDialog)
      else
      if tcMain.ActiveTab = tiGoodsItems then
        bCancelOIClick(bCancelOI)
      else
      if tcMain.ActiveTab = tiCamera then
        bClosePhotoClick(bClosePhoto)
      else
      if tcMain.ActiveTab = tiMain then
        bReloginClick(bRelogin)
      else
        sbBackClick(sbBack);
    end;
  end;
end;

// отображение на карты всех ТТ
procedure TfrmMain.lbiShowAllOnMapClick(Sender: TObject);
var
  Coordinates: TLocationCoord2D;
begin
  FMarkerList.Clear;

  with DM.qryPartner do
  begin
    DisableConstraints;
    First;

    while not EOF do
    begin
       if (DM.qryPartnerGPSN.AsFloat <> 0) and (DM.qryPartnerGPSE.AsFloat <> 0) then
         FMarkerList.Add(TLocationData.Create(DM.qryPartnerGPSN.AsFloat, DM.qryPartnerGPSE.AsFloat, 0))
       else
       if GetCoordinates(DM.qryPartnerAddress.AsString, Coordinates) then
         FMarkerList.Add(TLocationData.Create(Coordinates.Latitude, Coordinates.Longitude, 0));

      Next;
    end;

    EnableConstraints;
  end;

  LastDelimiter(' ', lDayInfo.Text);
  if pos('Все ТТ', lDayInfo.Text) = 0 then
    lCaption.Text := 'Карта (Все ТТ за ' + AnsiLowerCase(Copy(lDayInfo.Text, LastDelimiter(' ', lDayInfo.Text) + 1)) + ')'
  else
    lCaption.Text := 'Карта (Все ТТ)';
  ShowBigMap;

  ppPartner.IsOpen := False;
end;

{ изменение иконки статуса }
procedure TfrmMain.ChangeStatusIcon(ACurItem: TListViewItem);
begin
  if StrToIntDef(TListItemText(ACurItem.Objects.FindDrawable('StatusId')).Text, 0) = DM.tblObject_ConstStatusId_Complete.AsInteger then
    TListItemImage(ACurItem.Objects.FindDrawable('StatusIcon')).ImageIndex := 5
  else
  if StrToIntDef(TListItemText(ACurItem.Objects.FindDrawable('StatusId')).Text, 0) = DM.tblObject_ConstStatusId_UnComplete.AsInteger then
    TListItemImage(ACurItem.Objects.FindDrawable('StatusIcon')).ImageIndex := 6
  else
    TListItemImage(ACurItem.Objects.FindDrawable('StatusIcon')).ImageIndex := 7;
end;

{ изменение видимости кнопки удаления }
procedure TfrmMain.DeleteButtonHide(AItem: TListViewItem);
begin
  if Assigned(AItem.Objects.FindDrawable('DeleteButton')) then
  begin
    AItem.Objects.FindDrawable('DeleteButton').Visible := true;

    if not (StrToIntDef(TListItemText(AItem.Objects.FindDrawable('StatusId')).Text, 0) in
       [DM.tblObject_ConstStatusId_Complete.AsInteger, DM.tblObject_ConstStatusId_UnComplete.AsInteger]) or
       SameText(TListItemText(AItem.Objects.FindDrawable('isSync')).Text, 'true')
    then
      AItem.Objects.FindDrawable('DeleteButton').Visible := false;
  end;
end;

procedure TfrmMain.ChangeTaskView(AItem: TListViewItem);
begin
  if SameText(TListItemText(AItem.Objects.FindDrawable('Closed')).Text, 'False') then
    TListItemImage(AItem.Objects.FindDrawable('CloseButton')).ImageIndex := 1
  else
    TListItemImage(AItem.Objects.FindDrawable('CloseButton')).ImageIndex := 4;

  if TListItemText(AItem.Objects.FindDrawable('PartnerName')).Text = '' then
  begin
    AItem.Height := 100;
    AItem.Objects.FindDrawable('CloseButton').PlaceOffset.Y := 20;
  end
  else
  begin
    AItem.Height := 140;
    AItem.Objects.FindDrawable('CloseButton').PlaceOffset.Y := 40;
  end;
end;

// установить иконку статуса "заявок на товары"
procedure TfrmMain.LinkListControlToFieldOrderExternalItemsFilledListItem(Sender: TObject;
  const AEditor: IBindListEditorItem);
begin
  lwOrderExternalItems.Items[AEditor.CurrentIndex].Objects.FindDrawable('DeleteButton').Visible := FCanEditDocument;
end;

procedure TfrmMain.LinkListControlToFieldReturnInItemsFilledListItem(Sender: TObject;
  const AEditor: IBindListEditorItem);
begin
  lwReturnInItems.Items[AEditor.CurrentIndex].Objects.FindDrawable('DeleteButton').Visible := FCanEditDocument;
end;

procedure TfrmMain.LinkListControlToFieldCashFilledListItem(Sender: TObject;
  const AEditor: IBindListEditorItem);
var
  CurItem: TListViewItem;
begin
  CurItem := lwCashList.Items[AEditor.CurrentIndex];
  ChangeStatusIcon(CurItem);
  DeleteButtonHide(CurItem);
end;

procedure TfrmMain.LinkListControlToFieldOrderExternalFilledListItem(
  Sender: TObject; const AEditor: IBindListEditorItem);
var
  CurItem: TListViewItem;
begin
  CurItem := lwOrderExternalList.Items[AEditor.CurrentIndex];
  ChangeStatusIcon(CurItem);
  DeleteButtonHide(CurItem);
end;

// установить иконку статуса "возврата товара"
procedure TfrmMain.LinkListControlToFieldReturnInFilledListItem(Sender: TObject;
  const AEditor: IBindListEditorItem);
var
  CurItem: TListViewItem;
begin
  CurItem := lwReturnInList.Items[AEditor.CurrentIndex];
  ChangeStatusIcon(CurItem);
  DeleteButtonHide(CurItem);
end;

// установить иконку статуса "остатков"
procedure TfrmMain.LinkListControlToFieldStoreRealFilledListItem(
  Sender: TObject; const AEditor: IBindListEditorItem);
var
  CurItem: TListViewItem;
begin
  CurItem := lwStoreRealList.Items[AEditor.CurrentIndex];
  ChangeStatusIcon(CurItem);
  DeleteButtonHide(CurItem);
end;

procedure TfrmMain.LinkListControlToFieldStoreRealItemsFilledListItem(
  Sender: TObject; const AEditor: IBindListEditorItem);
begin
  lwStoreRealItems.Items[AEditor.CurrentIndex].Objects.FindDrawable('DeleteButton').Visible := FCanEditDocument;
end;

procedure TfrmMain.LinkListControlToFieldTasksFilledListItem(Sender: TObject;
  const AEditor: IBindListEditorItem);
begin
  ChangeTaskView(lwTasks.Items[AEditor.CurrentIndex])
end;

// проверка логина и пароля
procedure TfrmMain.LogInButtonClick(Sender: TObject);
var
  ErrorMessage: String;
  SettingsFile : TIniFile;
  NeedSync : boolean;
begin
  NeedSync := not assigned(gc_User) or SyncCheckBox.IsChecked;

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
  except
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
      ShowMessage('Нет связи с сервером. Продолжение работы невозможно');
      exit;
    end;
  end;

  // сохранение координат при логине и запуск таймера
  tSavePathTimer(tSavePath);

  DM.GetConfigurationInfo;
  if (not gc_User.Local) and NeedSync then
  begin
    DM.SynchronizeWithMainDatabase;
  end
  else
    DM.CheckUpdate; // проверка небходимости обновления

  // сохранение логина в ini файле
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  SettingsFile := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'settings.ini'));
  {$ELSE}
  SettingsFile := TIniFile.Create('settings.ini');
  {$ENDIF}
  try
    SettingsFile.WriteString('LOGIN', 'USERNAME', LoginEdit.Text);
    if FUseTemporaryServer then
    begin
      SettingsFile.WriteString('LOGIN', 'TemporaryServer', WebServerEdit.Text);
      FTemporaryServer := WebServerEdit.Text;
    end;
  finally
    FreeAndNil(SettingsFile);
  end;

  bSync.Enabled := not gc_User.Local;

  SwitchToForm(tiMain, nil);
end;

// условия фильтра для товаров из прайс листа
procedure TfrmMain.lwPriceListGoodsFilter(Sender: TObject; const AFilter, AValue: string;
  var Accept: Boolean);
begin
  if Trim(AFilter) <> '' then
    Accept :=  AValue.ToUpper.Contains(AFilter.ToUpper)
  else
    Accept := true;
end;

// условия фильтра для товаров выбраных для заявки на поставку
procedure TfrmMain.lwOrderDocsItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  DM.cdsOrderExternal.Locate('Id', StrToIntDef(TListItemText(lwOrderDocs.Items[ItemIndex].Objects.FindDrawable('Id')).Text, 0), []);

  if (ItemObject <> nil) and (ItemObject.Name = 'DeleteButton') then // удаление заявки на поставку
  begin
    TDialogService.MessageDialog('Удалить заявку "' + DM.cdsOrderExternalPartnerName.AsString +
      '" на ' + FormatDateTime('DD.MM.YYYY', DM.cdsOrderExternalOperDate.AsDateTime) + '?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteOrderExtrernal);
  end
  else
  // вызов формы редакирования выбранной заявки на поставку
  begin
    CreateEditOrderExtrernal(false);
  end;
end;

procedure TfrmMain.lwOrderDocsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  DeleteButtonHide(AItem);
end;

procedure TfrmMain.lwOrderExternalItemsFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  if Trim(AFilter) <> '' then
    Accept :=  AValue.ToUpper.Contains(AFilter.ToUpper)
  else
    Accept := true;
end;

procedure TfrmMain.lwOrderExternalItemsItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
    exit;

  if ItemObject.Name = 'DeleteButton' then // удаление выбранного товара из завки на поставку
  begin
    if DM.cdsOrderItemsId.AsInteger <> -1 then
      FDeletedOI.Add(DM.cdsOrderItemsId.AsInteger);
    DM.cdsOrderItems.Delete;

    RecalculateTotalPriceAndWeight;
  end
  else
  // вызов формы для редактирования количества выбранного товара
  if ((ItemObject.Name = 'Count') or (ItemObject.Name = 'Measure')) and FCanEditDocument then
  begin
    lAmount.Text := '0';
    lMeasure.Text := DM.cdsOrderItemsMeasure.AsString;

    ppEnterAmount.IsOpen := true;
  end;
end;

procedure TfrmMain.lwOrderExternalItemsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // установки иконки для кнопки удаления
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;

  AItem.Objects.FindDrawable('DeleteButton').Visible := FCanEditDocument;
end;

procedure TfrmMain.lwOrderExternalListItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (ItemObject <> nil) and (ItemObject.Name = 'DeleteButton') then // удаление заявки на поставку
  begin
    TDialogService.MessageDialog('Удалить заявку на ' + FormatDateTime('DD.MM.YYYY', DM.cdsOrderExternalOperDate.AsDateTime) + '?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteOrderExtrernal);
  end
  else
  // вызов формы редакирования выбранной заявки на поставку
  begin
    CreateEditOrderExtrernal(false);
  end;
end;

procedure TfrmMain.lwOrderExternalListUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // установки иконки для кнопки удаления
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;

  DeleteButtonHide(AItem);
end;

// условия фильтра для товаров, выбираемых для завок на поставку или возврат или ввода остатков
procedure TfrmMain.lwCashDocsItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  DM.qryCash.Locate('Id', StrToIntDef(TListItemText(lwCashDocs.Items[ItemIndex].Objects.FindDrawable('Id')).Text, 0), []);

  if (ItemObject <> nil) and (ItemObject.Name = 'DeleteButton') then // удаление оплаты
  begin
    TDialogService.MessageDialog('Удалить оплату "' + DM.qryCashPartnerName.AsString +
      '" от ' + FormatDateTime('DD.MM.YYYY', DM.qryCashOperDate.AsDateTime) + '?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteMovementCash);
  end
  else
  // вызов формы редакирования выбранной оплаты
  begin
    CreateEditMovementCash(false);
  end;
end;

procedure TfrmMain.lwCashDocsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  DeleteButtonHide(AItem);
end;

procedure TfrmMain.lwCashListItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (ItemObject <> nil) and (ItemObject.Name = 'DeleteButton') then // удалить выбранную оплату
  begin
    TDialogService.MessageDialog('Удалить оплату от ' + FormatDateTime('DD.MM.YYYY', DM.qryCashOperDate.AsDateTime) + '?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteMovementCash);
  end
  else
  // показать информацию по выбранной оплате
  begin
    CreateEditMovementCash(false);
  end;
end;

procedure TfrmMain.lwCashListUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // установить иконку кнопки удаления
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;

  DeleteButtonHide(AItem);
end;

procedure TfrmMain.lwGoodsItemsFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
var
  GoodsName : string;
  IsPromo : boolean;
begin
  if copy(AValue, Length(AValue), 1) = '1' then
    IsPromo := true
  else
    IsPromo := false;

  if Trim(AFilter) <> '' then
  begin
    GoodsName := copy(AValue, 1, Length(AValue) - 2);
    Accept := GoodsName.ToUpper.Contains(AFilter.ToUpper);
  end
  else
    Accept := true;

  if cbOnlyPromo.Visible and cbOnlyPromo.IsChecked then
    Accept := Accept and IsPromo;
end;

procedure TfrmMain.lwGoodsItemsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if (AItem.Objects.FindDrawable('IsSelected') as TListItemDrawable).Visible then
  begin
    // удаление товара из перечня выбранных
    (AItem.Objects.FindDrawable('IsSelected') as TListItemDrawable).Visible := False;
    FCheckedGooodsItems.Remove((AItem.Objects.FindDrawable('FullInfo') as TListItemDrawable).Data.AsString);
  end
  else
  begin
    // добавление товара в перечень выбранных
    (AItem.Objects.FindDrawable('IsSelected') as TListItemDrawable).Visible := True;
    FCheckedGooodsItems.Add((AItem.Objects.FindDrawable('FullInfo') as TListItemDrawable).Data.AsString);
  end;
end;

procedure TfrmMain.lwGoodsItemsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // отображать акционную цену только когда отображается соответсвующая шапка (только для завки на товары)
  (AItem.Objects.FindDrawable('PromoPrice') as TListItemDrawable).Visible := lPromoPrice.Visible;
  // отобразить "галочку" для выбранных товаров
  (AItem.Objects.FindDrawable('IsSelected') as TListItemDrawable).Visible := FCheckedGooodsItems.Contains((AItem.Objects.FindDrawable('FullInfo') as TListItemDrawable).Data.AsString);
end;

procedure TfrmMain.lwPartnerFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  if Trim(AFilter) <> '' then
    Accept :=  AValue.ToUpper.Contains(AFilter.ToUpper)
  else
    Accept := true;
end;

procedure TfrmMain.lwPartnerItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // начитка и отображение информации о торговой точке
  ShowPartnerInfo;
end;

procedure TfrmMain.lwPartnerPhotoGroupsItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (ItemObject <> nil) and (ItemObject.Name = 'DeleteButton') then // удаление выбранной группы фотографий
  begin
    TDialogService.MessageDialog('Удалить фотографии "' + DM.qryPhotoGroupsComment.AsString +
      '" за ' + FormatDateTime('DD.MM.YYYY', DM.qryPhotoGroupsOperDate.AsDateTime) + '?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeletePhotoGroup);
  end
  else
  begin
    // отображение фотографий выбранной группы
    ShowPhotos(DM.qryPhotoGroupsId.AsInteger);
  end;
end;

procedure TfrmMain.lwPartnerPhotoGroupsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // установка иконки кнопки удаления
  if Assigned(AItem.Objects.FindDrawable('DeleteButton')) then
    TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
end;

procedure TfrmMain.lwPartnerTasksItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  // отметить задание как выполненное (с вводом коментария)
  if (ItemObject <> nil) and (ItemObject.Name = 'CloseButton') then
  begin
    eTaskComment.Text := DM.cdsTasksComment.AsString;

    vsbMain.Enabled := false;
    pTaskComment.Visible := true;
  end;
end;

procedure TfrmMain.lwPartnerTasksUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // установки иконки для кнопки "закрыть задание"
  TListItemImage(AItem.Objects.FindDrawable('CloseButton')).ImageIndex := 4;
end;

procedure TfrmMain.lwPartnerUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // установка иконки аддресса
  TListItemImage(AItem.Objects.FindDrawable('imAddress')).ImageIndex := 2;
  // установка иконки договора
  TListItemImage(AItem.Objects.FindDrawable('imContact')).ImageIndex := 3;
end;

procedure TfrmMain.lwPhotoDocsItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (ItemObject <> nil) and (ItemObject.Name = 'DeleteButton') then // удаление выбранной группы фотографий
  begin
    TDialogService.MessageDialog('Удалить фотографии "' + DM.qryPhotoGroupDocsPartnerName.AsString +
      '" за ' + FormatDateTime('DD.MM.YYYY', DM.qryPhotoGroupDocsOperDate.AsDateTime) + '?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeletePhotoGroupDoc);
  end
  else
  begin
    // отображение фотографий выбранной группы
    ShowPhotos(DM.qryPhotoGroupDocsId.AsInteger);
  end;
end;

procedure TfrmMain.lwPhotosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (ItemObject <> nil) then
  begin
    // удалить фотографию
    if ItemObject.Name = 'DeleteButton' then
    begin
      TDialogService.MessageDialog('Удалить фотографию "' + DM.qryPhotosComment.AsString +
        '"?',
        TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeletePhoto);
    end
    else
    // просмотр фотографии с возможностью редактирования комментария
    if ItemObject.Name = 'EditButton' then
      ShowPhoto;
  end;
end;

procedure TfrmMain.lwPhotosUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // установка иконки кнопки удаления
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
  // установка иконки кнопки редактирования
  TListItemImage(AItem.Objects.FindDrawable('EditButton')).ImageIndex := 1;
end;

procedure TfrmMain.lwPriceListItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // начитка и отображение товаров выбранного прайс-листа
  ShowPriceListItems;
end;

// условия фильтра для акционных товаров
procedure TfrmMain.lwPromoGoodsFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  if Trim(AFilter) <> '' then
    Accept :=  AValue.ToUpper.Contains(AFilter.ToUpper)
  else
    Accept := true;
end;

// показать торговые точки на которых продается выбранный акционнный товар
procedure TfrmMain.lwPromoGoodsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if pPromoGoodsDate.Visible then
    ShowPromoPartnersByGoods;
end;

procedure TfrmMain.lwPromoGoodsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // показать символ "детали" если мы показываем все акионные товары (без привязки к ТТ)
  AItem.Objects.FindDrawable('Details').Visible := pPromoGoodsDate.Visible;
end;

// показать акционные товары которые продаются на выбраной ТТ
procedure TfrmMain.lwPromoPartnersItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if pPromoPartnerDate.Visible then
    ShowPromoGoodsByPartner;
end;

procedure TfrmMain.lwPromoPartnersUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // показать символ "детали" если мы показываем все ТТ(без привязки к товарам)
  AItem.Objects.FindDrawable('Details').Visible := pPromoPartnerDate.Visible;

  // установка иконки адреса
  TListItemImage(AItem.Objects.FindDrawable('imAddress')).ImageIndex := 2;
  // установка иконки договора
  TListItemImage(AItem.Objects.FindDrawable('imContact')).ImageIndex := 3;
end;

procedure TfrmMain.lwReturnInDocsItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  DM.cdsReturnIn.Locate('Id', StrToIntDef(TListItemText(lwReturnInDocs.Items[ItemIndex].Objects.FindDrawable('Id')).Text, 0), []);

  if (ItemObject <> nil) and (ItemObject.Name = 'DeleteButton') then // удалить выбранный возврат товаров
  begin
    TDialogService.MessageDialog('Удалить возврат "' + DM.cdsReturnInPartnerName.AsString +
      '" за ' + FormatDateTime('DD.MM.YYYY', DM.cdsReturnInOperDate.AsDateTime) + '?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteReturnIn);
  end
  else
  // показать информацию по выбранному возврат товаров
  begin
    CreateEditReturnIn(false);
  end;
end;

procedure TfrmMain.lwReturnInDocsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  DeleteButtonHide(AItem);
end;

procedure TfrmMain.lwReturnInItemsFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  if Trim(AFilter) <> '' then
    Accept :=  AValue.ToUpper.Contains(AFilter.ToUpper)
  else
    Accept := true;
end;

procedure TfrmMain.lwReturnInItemsItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
    exit;

  if ItemObject.Name = 'DeleteButton' then // удаление выбранного товара из завки на поставку
  begin
    if DM.cdsReturnInItemsId.AsInteger <> -1 then
      FDeletedOI.Add(DM.cdsReturnInItemsId.AsInteger);
    DM.cdsReturnInItems.Delete;

    RecalculateReturnInTotalPriceAndWeight;
  end
  else
  // вызов формы для редактирования количества выбранного товара
  if ((ItemObject.Name = 'Count') or (ItemObject.Name = 'Measure')) and FCanEditDocument then
  begin
    lAmount.Text := '0';
    lMeasure.Text := DM.cdsReturnInItemsMeasure.AsString;

    ppEnterAmount.IsOpen := true;
  end;
end;

procedure TfrmMain.lwReturnInItemsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // установки иконки для кнопки удаления
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;

  AItem.Objects.FindDrawable('DeleteButton').Visible := FCanEditDocument;
end;

procedure TfrmMain.lwReturnInListItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (ItemObject <> nil) and (ItemObject.Name = 'DeleteButton') then // удалить выбранную заявку на возврат товаров
  begin
    TDialogService.MessageDialog('Удалить возврат за ' + FormatDateTime('DD.MM.YYYY', DM.cdsReturnInOperDate.AsDateTime) + '?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteReturnIn);
  end
  else
  // показать информацию по выбранной заявке на возврат товара
  begin
    CreateEditReturnIn(false);
  end;
end;

procedure TfrmMain.lwReturnInListUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // установить иконку кнопки удаления
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;

  DeleteButtonHide(AItem);
end;

// условия фильтра товаров, по которым указывается остаток
procedure TfrmMain.lwStoreRealDocsItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  DM.cdsStoreReals.Locate('Id', StrToIntDef(TListItemText(lwStoreRealDocs.Items[ItemIndex].Objects.FindDrawable('Id')).Text, 0), []);

  if (ItemObject <> nil) and (ItemObject.Name = 'DeleteButton') then // удалить выбранные "остатки"
  begin
    TDialogService.MessageDialog('Удалить остатки "' + DM.cdsStoreRealsPartnerName.AsString +
      '" за ' + FormatDateTime('DD.MM.YYYY', DM.cdsStoreRealsOperDate.AsDateTime) + '?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteStoreReal);
  end
  else
  // вызов формы для редактирования "остатков"
  begin
    CreateEditStoreReal(mrYes);
  end;
end;

procedure TfrmMain.lwStoreRealDocsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  DeleteButtonHide(AItem);
end;

procedure TfrmMain.lwStoreRealItemsFilter(Sender: TObject; const AFilter,
  AValue: string; var Accept: Boolean);
begin
  if Trim(AFilter) <> '' then
    Accept :=  AValue.ToUpper.Contains(AFilter.ToUpper)
  else
    Accept := true;
end;

procedure TfrmMain.lwStoreRealItemsItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject = nil then
    exit;

  if ItemObject.Name = 'DeleteButton' then // удалить товар из списка остатков
  begin
    if DM.cdsStoreRealItemsId.AsInteger <> -1 then
      FDeletedSRI.Add(DM.cdsStoreRealItemsId.AsInteger);
    DM.cdsStoreRealItems.Delete;


    RecalculateTotalPriceAndWeight;
  end
  else
  // вызов формы для редактирования количества остатков выбранного товара
  if ((ItemObject.Name = 'Count') or (ItemObject.Name = 'Measure')) and FCanEditDocument then
  begin
    lAmount.Text := '0';
    lMeasure.Text := DM.cdsStoreRealItemsMeasure.AsString;

    ppEnterAmount.IsOpen := true;
  end;
end;

procedure TfrmMain.lwStoreRealListItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (ItemObject <> nil) and (ItemObject.Name = 'DeleteButton') then // удалить выбранные "остатки"
  begin
    TDialogService.MessageDialog('Удалить остатки за ' + FormatDateTime('DD.MM.YYYY', DM.cdsStoreRealsOperDate.AsDateTime) + '?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, DeleteStoreReal);
  end
  else
  // вызов формы для редактирования "остатков"
  begin
    CreateEditStoreReal(mrYes);
  end;
end;

procedure TfrmMain.lwStoreRealListUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // установить иконку кнопки удаления
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;

  DeleteButtonHide(AItem);
end;

procedure TfrmMain.lwTasksItemClickEx(const Sender: TObject; ItemIndex: Integer;
  const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
begin
  // отметить задание как выполненное (после ввода коментария)
  if (ItemObject <> nil) and (ItemObject.Name = 'CloseButton') then
  begin
    eTaskComment.Text := DM.cdsTasksComment.AsString;

    vsbMain.Enabled := false;
    pTaskComment.Visible := true;
  end;
end;

procedure TfrmMain.lwTasksUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  ChangeTaskView(AItem);
end;

procedure TfrmMain.lwStoreRealItemsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // установить иконку кнопки удаления
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
  TListItemText(AItem.Objects.FindDrawable('Lable')).Text := 'Фактический остаток';

  AItem.Objects.FindDrawable('DeleteButton').Visible := FCanEditDocument;
end;

// ввод числа (для редактирования количества товара)
procedure TfrmMain.b0Click(Sender: TObject);
begin
  if lAmount.Text = '0' then
    lAmount.Text := '';

  lAmount.Text := lAmount.Text + TButton(Sender).Text;
end;

procedure TfrmMain.OnCloseDialog(const AResult: TModalResult);
begin
  if AResult = mrOK then
    Close;
end;

procedure TfrmMain.BackResult(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    if (tcMain.ActiveTab = tiStoreReal) and (DM.cdsStoreRealsId.AsInteger = -1) then
    begin
      DM.cdsStoreReals.Delete;
      DM.cdsStoreReals.First;
    end;

    if (tcMain.ActiveTab = tiOrderExternal) and (DM.cdsOrderExternalId.AsInteger = -1) then
    begin
      DM.cdsOrderExternal.Delete;
      DM.cdsOrderExternal.First;
    end;

    if (tcMain.ActiveTab = tiReturnIn) and (DM.cdsReturnInId.AsInteger = -1) then
    begin
      DM.cdsReturnIn.Delete;
      DM.cdsReturnIn.First;
    end;

    ReturnPriorForm;
  end;
end;

{ сохранение заявки на товары }
procedure TfrmMain.SaveOrderExtrernal(const AResult: TModalResult);
var
  i : integer;
  ErrMes: string;
  DelItems: string;
begin
  if AResult <> mrNo then
  begin
    DelItems := '';
    if FDeletedOI.Count > 0 then
    begin
      DelItems := IntToStr(FDeletedOI[0]);
      for i := 1 to FDeletedOI.Count - 1 do
        DelItems := ',' + IntToStr(FDeletedOI[i]);
    end;

    if DM.SaveOrderExternal(deOrderDate.Date, eOrderComment.Text,
      FOrderTotalPrice, FOrderTotalCountKg, DelItems, AResult = mrNone ,ErrMes) then
    begin
      if FEditDocuments then
        ChangeOrderExternalDoc;

      ShowMessage('Сохранение заявки прошло успешно.');
      ReturnPriorForm;
    end
    else
      TDialogService.MessageDialog(ErrMes, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
  end;
end;

{ сохранение "остатков" }
procedure TfrmMain.SaveStoreReal(const AResult: TModalResult);
var
  i : integer;
  ErrMes: string;
  DelItems: string;
begin
  if AResult <> mrNo then
  begin
    DelItems := '';
    if FDeletedSRI.Count > 0 then
    begin
      DelItems := IntToStr(FDeletedSRI[0]);
      for i := 1 to FDeletedSRI.Count - 1 do
        DelItems := ',' + IntToStr(FDeletedSRI[i]);
    end;

    if DM.SaveStoreReal(eStoreRealComment.Text, DelItems, AResult = mrNone, ErrMes) then
    begin
      if FEditDocuments then
        ChangeStoreRealDoc;

      ShowMessage('Сохранение остатков прошло успешно.');
      ReturnPriorForm;
    end
    else
      TDialogService.MessageDialog(ErrMes, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
  end;
end;

{ сохранение "возвратов" }
procedure TfrmMain.SaveReturnIn(const AResult: TModalResult);
var
  i: integer;
  ErrMes: string;
  DelItems: string;
begin
  if AResult <> mrNo then
  begin
    DelItems := '';
    if FDeletedRI.Count > 0 then
    begin
      DelItems := IntToStr(FDeletedRI[0]);
      for i := 1 to FDeletedRI.Count - 1 do
        DelItems := ',' + IntToStr(FDeletedRI[i]);
    end;

    if DM.SaveReturnIn(deReturnDate.Date, eReturnComment.Text,
      FReturnInTotalPrice, FReturnInTotalCountKg, DelItems, AResult = mrNone, ErrMes) then
    begin
      if FEditDocuments then
        ChangeReturnInDoc;

      ShowMessage('Сохранение возврата прошло успешно.');
      ReturnPriorForm;
    end
    else
      TDialogService.MessageDialog(ErrMes, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
  end;
end;

{ удаление заявки на товары }
procedure TfrmMain.DeleteOrderExtrernal(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.conMain.ExecSQL('update MOVEMENT_ORDEREXTERNAL set STATUSID = ' + DM.tblObject_ConstStatusId_Erased.AsString +
      ' where ID = ' + DM.cdsOrderExternalId.AsString);

    DM.cdsOrderExternal.Edit;
    DM.cdsOrderExternalStatusId.AsInteger := DM.tblObject_ConstStatusId_Erased.AsInteger;
    DM.cdsOrderExternalStatus.AsString := DM.tblObject_ConstStatusName_Erased.AsString;
    DM.cdsOrderExternal.Post;

    if FEditDocuments then
      ChangeOrderExternalDoc;
  end;
end;

{ удаление "остатков" }
procedure TfrmMain.DeleteStoreReal(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.conMain.ExecSQL('update Movement_StoreReal set STATUSID = ' + DM.tblObject_ConstStatusId_Erased.AsString +
      ' where ID = ' + DM.cdsStoreRealsId.AsString);

    DM.cdsStoreReals.Edit;
    DM.cdsStoreRealsStatusId.AsInteger := DM.tblObject_ConstStatusId_Erased.AsInteger;
    DM.cdsStoreRealsStatus.AsString := DM.tblObject_ConstStatusName_Erased.AsString;
    DM.cdsStoreReals.Post;

    if FEditDocuments then
      ChangeStoreRealDoc;
  end;
end;

{ удаление "возвратов" }
procedure TfrmMain.DeleteReturnIn(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.conMain.ExecSQL('update Movement_ReturnIn set STATUSID = ' + DM.tblObject_ConstStatusId_Erased.AsString +
      ' where ID = ' + DM.cdsReturnInId.AsString);

    DM.cdsReturnIn.Edit;
    DM.cdsReturnInStatusId.AsInteger := DM.tblObject_ConstStatusId_Erased.AsInteger;
    DM.cdsReturnInStatus.AsString := DM.tblObject_ConstStatusName_Erased.AsString;
    DM.cdsReturnIn.Post;

    if FEditDocuments then
      ChangeReturnInDoc;
  end;
end;

{ удаление "оплаты" }
procedure TfrmMain.DeleteMovementCash(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.qryCash.Edit;
    DM.qryCashStatusId.AsInteger := DM.tblObject_ConstStatusId_Erased.AsInteger;
    DM.qryCash.Post;

    if FEditDocuments then
      ChangeCashDoc;
  end;
end;

{ удаление группы фотографий }
procedure TfrmMain.DeletePhotoGroup(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.qryPhotoGroups.Edit;
    DM.qryPhotoGroupsStatusId.AsInteger := DM.tblObject_ConstStatusId_Erased.AsInteger;
    DM.qryPhotoGroupsIsSync.AsBoolean := false;
    DM.qryPhotoGroups.Post;

    DM.qryPhotoGroups.Refresh;
  end;
end;

{ удаление группы фотографий (документы) }
procedure TfrmMain.DeletePhotoGroupDoc(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.qryPhotoGroupDocs.Edit;
    DM.qryPhotoGroupDocsStatusId.AsInteger := DM.tblObject_ConstStatusId_Erased.AsInteger;
    DM.qryPhotoGroupDocsIsSync.AsBoolean := false;
    DM.qryPhotoGroupDocs.Post;

    DM.qryPhotoGroupDocs.Refresh;
  end;
end;

{ удаление фотографии }
procedure TfrmMain.DeletePhoto(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin
    DM.qryPhotos.Edit;
    DM.qryPhotosisErased.AsBoolean := true;
    DM.qryPhotosisSync.AsBoolean := false;
    DM.qryPhotos.Post;

    DM.qryPhotos.Refresh;
  end;
end;

// начитка акционных товаров
procedure TfrmMain.dePromoGoodsDateChange(Sender: TObject);
begin
  DM.qryPromoGoods.Close;
  DM.qryPromoGoods.SQL.Text := 'select G.OBJECTCODE, G.VALUEDATA GoodsName, T.VALUEDATA TradeMarkName, ' +
    'CASE WHEN PG.GOODSKINDID = 0 THEN ''все виды'' ELSE GK.VALUEDATA END KindName, ' +
    '''Скидка '' || PG.TAXPROMO || ''%'' Tax, ' +
    '''Акционная цена: '' || PG.PRICEWITHOUTVAT || '' (с НДС '' || PG.PRICEWITHVAT || '') за '' || M.VALUEDATA Price, ' +
    '''Акция заканчивается '' || strftime(''%d.%m.%Y'',P.ENDSALE) Termin, P.ID PromoId ' +
    'from MOVEMENTITEM_PROMOGOODS PG ' +
    'JOIN MOVEMENT_PROMO P ON P.ID = PG.MOVEMENTID AND :PROMODATE BETWEEN P.STARTSALE AND P.ENDSALE ' +
    'LEFT JOIN OBJECT_GOODS G ON G.ID = PG.GOODSID ' +
    'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
    'LEFT JOIN OBJECT_TRADEMARK T ON T.ID = G.TRADEMARKID ' +
    'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = PG.GOODSKINDID ' +
    'ORDER BY G.VALUEDATA, P.ENDSALE';
  DM.qryPromoGoods.ParamByName('PROMODATE').AsDate := dePromoGoodsDate.Date;
  DM.qryPromoGoods.Open;

  lwPromoGoods.ScrollViewPos := 0;
end;

// начитка торговых точек, участвующих в акциях
procedure TfrmMain.dePromoPartnerDateChange(Sender: TObject);
begin
  DM.qryPromoPartners.Close;
  DM.qryPromoPartners.SQL.Text := 'select J.VALUEDATA PartnerName, OP.ADDRESS, ' +
    'CASE WHEN PP.CONTRACTID = 0 THEN ''все договора'' ELSE C.CONTRACTTAGNAME || '' '' || C.VALUEDATA END ContractName, ' +
    'PP.PARTNERID, PP.CONTRACTID, group_concat(distinct PP.MOVEMENTID) PromoIds ' +
    'from MOVEMENTITEM_PROMOPARTNER PP ' +
    'JOIN MOVEMENT_PROMO P ON P.ID = PP.MOVEMENTID AND :PROMODATE BETWEEN P.STARTSALE AND P.ENDSALE ' +
    'LEFT JOIN OBJECT_PARTNER OP ON OP.ID = PP.PARTNERID AND (OP.CONTRACTID = PP.CONTRACTID OR PP.CONTRACTID = 0) ' +
    'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = OP.JURIDICALID AND J.CONTRACTID = OP.CONTRACTID ' +
    'LEFT JOIN OBJECT_CONTRACT C ON C.ID = PP.CONTRACTID ' +
    'GROUP BY PP.PARTNERID, PP.CONTRACTID ' +
    'ORDER BY J.VALUEDATA, OP.ADDRESS';
  DM.qryPromoPartners.ParamByName('PROMODATE').AsDate := dePromoPartnerDate.Date;
  DM.qryPromoPartners.Open;

  lwPromoPartners.ScrollViewPos := 0;
end;

{ создание новых или редактирование ранее введенных "остатков" }
procedure TfrmMain.CreateEditStoreReal(const AResult: TModalResult);
begin
  if (AResult = mrNone) or (AResult = mrYes) then
  begin
    FDeletedSRI.Clear;
    FCheckedGooodsItems.Clear;

    if AResult = mrNone then // ввод нового остатка
    begin
      DM.NewStoreReal;

      DM.DefaultStoreRealItems;
    end
    else
    begin
      DM.LoadStoreRealItems(DM.cdsStoreRealsId.AsInteger);
    end;

    eStoreRealComment.Text := DM.cdsStoreRealsComment.AsString;
    FCanEditDocument := not DM.cdsStoreRealsisSync.AsBoolean;

    pSaveStoreReal.Visible := FCanEditDocument;
    bAddStoreRealItem.Visible := FCanEditDocument;
    eStoreRealComment.ReadOnly := not FCanEditDocument;

    lwStoreRealItems.ScrollViewPos := 0;
    SwitchToForm(tiStoreReal, nil);
  end;
end;

{ создание новых или редактирование ранее введенных "остатков" }
procedure TfrmMain.CreateEditOrderExtrernal(New: boolean);
begin
  FDeletedOI.Clear;
  FCheckedGooodsItems.Clear;

  if New then
  begin
    DM.NewOrderExternal;

    DM.DefaultOrderExternalItems;
  end
  else
  begin
    DM.LoadOrderExtrenalItems(DM.cdsOrderExternalId.AsInteger);
  end;

  deOrderDate.Date := DM.cdsOrderExternalOperDate.AsDateTime;
  eOrderComment.Text := DM.cdsOrderExternalComment.AsString;

  if DM.cdsOrderExternalPriceWithVAT.AsBoolean then
    lOrderPrice.Text := 'Цена (с НДС)'
  else
    lOrderPrice.Text := 'Цена (без НДС)';

  FCanEditDocument := not DM.cdsOrderExternalisSync.AsBoolean;

  RecalculateTotalPriceAndWeight;

  pSaveOrderExternal.Visible := FCanEditDocument;
  bAddOrderItem.Visible := FCanEditDocument;
  eOrderComment.ReadOnly := not FCanEditDocument;
  deOrderDate.ReadOnly := not FCanEditDocument;

  lwOrderExternalItems.ScrollViewPos := 0;
  SwitchToForm(tiOrderExternal, nil);
end;

{ создание новых или редактирование ранее введенных "возвратов" }
procedure TfrmMain.CreateEditReturnIn(New: boolean);
begin
  FDeletedRI.Clear;
  FCheckedGooodsItems.Clear;

  if New then
  begin
    DM.NewReturnIn;

    DM.DefaultReturnInItems;
  end
  else
  begin
    DM.LoadReturnInItems(DM.cdsReturnInId.AsInteger);
  end;

  deReturnDate.Date := DM.cdsReturnInOperDate.AsDateTime;
  eReturnComment.Text := DM.cdsReturnInComment.AsString;
  FCanEditDocument := not DM.cdsReturnInisSync.AsBoolean;

  RecalculateReturnInTotalPriceAndWeight;

  if DM.cdsReturnInPriceWithVAT.AsBoolean then
    lReturnInPrice.Text := 'Цена (с НДС)'
  else
    lReturnInPrice.Text := 'Цена (без НДС)';

  pSaveReturnIn.Visible := FCanEditDocument;
  bAddReturnInItem.Visible := FCanEditDocument;
  eReturnComment.ReadOnly := not FCanEditDocument;
  deReturnDate.ReadOnly := not FCanEditDocument;

  lwReturnInItems.ScrollViewPos := 0;
  SwitchToForm(tiReturnIn, nil);
end;

{ создание новых или редактирование ранее введенных "оплат" }
procedure TfrmMain.CreateEditMovementCash(New: boolean);
begin
  vsbMain.Enabled := false;

  if New then
  begin
    FOldCashId := -1;
    deCashDate.Date := Date();
    eCashAmount.Text := '';
    eCashComment.Text := '';
    FCanEditDocument := true;
  end
  else
  begin
    FOldCashId := DM.qryCashId.AsInteger;
    deCashDate.Date := DM.qryCashOperDate.AsDateTime;
    eCashAmount.Text := FormatFloat(',0.##', DM.qryCashAmount.AsFloat);
    eCashComment.Text := DM.qryCashComment.AsString;
    FCanEditDocument := not DM.qryCashisSync.AsBoolean;
  end;

  eCashAmount.ReadOnly := not FCanEditDocument;
  eCashComment.ReadOnly := not FCanEditDocument;
  if FCanEditDocument then
  begin
    bCancelCash.Visible := true;
    bSaveCash.Text := 'Сохранить';
  end
  else
  begin
    bCancelCash.Visible := false;
    bSaveCash.Text := 'Закрыть';
  end;

  pEnterMovmentCash.Visible := true;
end;


// проверка и корректировка введенной координаты GPS
procedure TfrmMain.eCashAmountValidate(Sender: TObject; var Text: string);
var
  str : string;
begin
  try
    Text := Trim(Text);
    if Text.Length > 0 then
      StrToFloat(Text);
  except
    ShowMessage('Неправильный формат суммы (n.nn)');

    // пытаемся исправить на правильное значение
    str := StringReplace(Text, ',', '.', [rfReplaceAll]);
    str := StringReplace(str, '-', '', [rfReplaceAll]);
    str := StringReplace(str, ' ', '', [rfReplaceAll]);
    str := StringReplace(str, '.', ';', []);
    str := StringReplace(str, '.', '', [rfReplaceAll]);
    str := StringReplace(str, ';', '.', []);
    if (str.Length > 0) and (str[Low(str)] = '.') then
      str := '0' + str;

    Text := str;
  end;
end;

procedure TfrmMain.eNewPartnerGPSNValidate(Sender: TObject; var Text: string);
var
  str : string;
begin
  try
    Text := Trim(Text);
    if Text.Length > 0 then
      StrToFloat(Text);
  except
    ShowMessage('Неправильный формат координаты (nn.nnnnnn)');

    // пытаемся исправить на правильное значение
    str := StringReplace(Text, ',', '.', [rfReplaceAll]);
    str := StringReplace(str, '-', '', [rfReplaceAll]);
    str := StringReplace(str, ' ', '', [rfReplaceAll]);
    str := StringReplace(str, '.', ';', []);
    str := StringReplace(str, '.', '', [rfReplaceAll]);
    str := StringReplace(str, ';', '.', []);
    if (str.Length > 0) and (str[Low(str)] = '.') then
      str := '0' + str;

    Text := str;
  end;
end;

// присвоение текущих координат выбраной ТТ и сохранение в БД
procedure TfrmMain.SetPartnerCoordinates(const AResult: TModalResult);
var
  Id, ContractId : integer;
begin
  if AResult = mrYes then
  begin
    GetCurrentCoordinates;
    if FCurCoordinatesSet then
    begin
      DM.conMain.ExecSQL('update OBJECT_PARTNER set GPSN = ' + FloatToStr(FCurCoordinates.Latitude) +
        ', GPSE = ' + FloatToStr(FCurCoordinates.Longitude) +
        ' where ID = ' + DM.qryPartnerId.AsString + ' and CONTRACTID = ' + DM.qryPartnerCONTRACTID.AsString);
      Id := DM.qryPartnerId.AsInteger;
      ContractId := DM.qryPartnerCONTRACTID.AsInteger;
      DM.qryPartner.Refresh;
      DM.qryPartner.Locate('Id;ContractId', VarArrayOf([Id, ContractId]), []);

      GetPartnerMap(FCurCoordinates.Latitude, FCurCoordinates.Longitude);
    end
    else
      ShowMessage('Не удалось получить текущие координаты');
  end;
end;

// обработка нажатия кнопки возврата на предидущую форму
procedure TfrmMain.sbBackClick(Sender: TObject);
var
  Mes : string;
begin
  if (tcMain.ActiveTab = tiOrderExternal) and FCanEditDocument then
  begin
    if DM.cdsOrderExternalId.AsInteger = -1 then
      Mes := 'Выйти без сохранения заявки?'
    else
      Mes := 'Выйти из редактирования без сохранения?';

    TDialogService.MessageDialog(Mes, TMsgDlgType.mtWarning,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, BackResult);
  end
  else
  if (tcMain.ActiveTab = tiStoreReal) and FCanEditDocument then
  begin
    if DM.cdsStoreRealsId.AsInteger = -1 then
      Mes := 'Выйти без сохранения остатков?'
    else
      Mes := 'Выйти из редактирования без сохранения?';

    TDialogService.MessageDialog(Mes, TMsgDlgType.mtWarning,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, BackResult);
  end
  else
  if (tcMain.ActiveTab = tiReturnIn) and FCanEditDocument then
  begin
    if DM.cdsReturnInId.AsInteger = -1 then
      Mes := 'Выйти без сохранения возврата?'
    else
      Mes := 'Выйти из редактирования без сохранения?';

    TDialogService.MessageDialog(Mes, TMsgDlgType.mtWarning,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, BackResult);
  end
  else
    ReturnPriorForm;
end;

// вызов меню для торговых точек
procedure TfrmMain.sbPartnerMenuClick(Sender: TObject);
begin
  ppPartner.IsOpen := true;
  lbPartnerMenu.ItemIndex := -1;
end;

// переход на форму фотографирования
procedure TfrmMain.bAddedPhotoClick(Sender: TObject);
begin
  PrepareCamera;
end;

// ввод названия группы фотографий
procedure TfrmMain.bAddedPhotoGroupClick(Sender: TObject);
begin
  vsbMain.Enabled := false;
  ePhotoGroupName.Text := '';
  pNewPhotoGroup.Visible := true;
end;

// переход на форму выбора товаров для заявки на товары
procedure TfrmMain.bAddOrderItemClick(Sender: TObject);
begin
  DM.GenerateOrderExtrenalItemsList;

  lPromoPrice.Visible := true;
  pShowOnlyPromo.Visible := true;

  SwitchToForm(tiGoodsItems, DM.qryGoodsItems);
end;

// переход на форму выбора товаров для возврата
procedure TfrmMain.bAddReturnInItemClick(Sender: TObject);
begin
  DM.GenerateReturnInItemsList;

  lPromoPrice.Visible := false;
  pShowOnlyPromo.Visible := false;

  SwitchToForm(tiGoodsItems, DM.qryGoodsItems);
end;

// переход на форму выбора товаров для ввода остатков
procedure TfrmMain.bAddStoreRealItemClick(Sender: TObject);
begin
  DM.GenerateStoreRealItemsList;

  lPromoPrice.Visible := false;
  pShowOnlyPromo.Visible := false;

  SwitchToForm(tiGoodsItems, DM.qryGoodsItems);
end;

// отмена выбора товаров
procedure TfrmMain.bCancelCashClick(Sender: TObject);
begin
  vsbMain.Enabled := true;
  pEnterMovmentCash.Visible := false;
end;

procedure TfrmMain.bCancelOIClick(Sender: TObject);
begin
  FCheckedGooodsItems.Clear;

  ReturnPriorForm;
end;

// отмена сохранения фотографии
procedure TfrmMain.bCancelPasswordClick(Sender: TObject);
begin
  vsbMain.Enabled := true;
  pTemporaryServerPassword.Visible := false;
end;

procedure TfrmMain.bCancelPhotoClick(Sender: TObject);
begin
  vsbMain.Enabled := true;
  pPhotoComment.Visible := false;
end;

// отмена "выолнения" задания
procedure TfrmMain.bCancelTaskClick(Sender: TObject);
begin
  vsbMain.Enabled := true;
  pTaskComment.Visible := false;
end;

// отмена сохранения группы фотографий
procedure TfrmMain.bCanclePGClick(Sender: TObject);
begin
  vsbMain.Enabled := true;
  pNewPhotoGroup.Visible := false;
end;

// очистка количества товаров
procedure TfrmMain.bClearAmountClick(Sender: TObject);
begin
  lAmount.Text := '0';
end;

// присвоение количества товаров
procedure TfrmMain.bEnterAmountClick(Sender: TObject);
begin
  if tcMain.ActiveTab = tiOrderExternal then
  begin
    DM.cdsOrderItems.Edit;
    DM.cdsOrderItemsCount.AsFloat := StrToFloatDef(lAmount.Text, 0);
    DM.cdsOrderItems.Post;

    RecalculateTotalPriceAndWeight;
  end
  else
  if tcMain.ActiveTab = tiStoreReal then
  begin
    DM.cdsStoreRealItems.Edit;
    DM.cdsStoreRealItemsCount.AsFloat := StrToFloatDef(lAmount.Text, 0);
    DM.cdsStoreRealItems.Post;
  end
  else
  if tcMain.ActiveTab = tiReturnIn then
  begin
    DM.cdsReturnInItems.Edit;
    DM.cdsReturnInItemsCount.AsFloat := StrToFloatDef(lAmount.Text, 0);
    DM.cdsReturnInItems.Post;

    RecalculateReturnInTotalPriceAndWeight;
  end;

  ppEnterAmount.IsOpen := false;
end;

procedure TfrmMain.bEnterServerClick(Sender: TObject);
begin
  if not FUseTemporaryServer then
  begin
    ePassword.Text := '';
    vsbMain.Enabled := false;
    pTemporaryServerPassword.Visible := true;
  end
  else
  begin
    FUseTemporaryServer := false;
    WebServerLayout1.Height := 0;
    WebServerLayout2.Height := 0;
    gc_WebService := gc_WebServers[0];
  end;
end;

// добавление количества товаров к введенным ранее
procedure TfrmMain.bAddAmountClick(Sender: TObject);
begin
  if tcMain.ActiveTab = tiOrderExternal then
  begin
    DM.cdsOrderItems.Edit;
    DM.cdsOrderItemsCount.AsFloat := DM.cdsOrderItemsCount.AsFloat + StrToFloatDef(lAmount.Text, 0);
    DM.cdsOrderItems.Post;

    RecalculateTotalPriceAndWeight;
  end
  else
  if tcMain.ActiveTab = tiStoreReal then
  begin
    DM.cdsStoreRealItems.Edit;
    DM.cdsStoreRealItemsCount.AsFloat := DM.cdsStoreRealItemsCount.AsFloat + StrToFloatDef(lAmount.Text, 0);
    DM.cdsStoreRealItems.Post;
  end
  else
  if tcMain.ActiveTab = tiReturnIn then
  begin
    DM.cdsReturnInItems.Edit;
    DM.cdsReturnInItemsCount.AsFloat := DM.cdsReturnInItemsCount.AsFloat + StrToFloatDef(lAmount.Text, 0);
    DM.cdsReturnInItems.Post;

    RecalculateReturnInTotalPriceAndWeight;
  end;

  ppEnterAmount.IsOpen := false;
end;

// отнимание количества товаров от введенных ранее
procedure TfrmMain.bMinusAmountClick(Sender: TObject);
begin
  if tcMain.ActiveTab = tiOrderExternal then
  begin
    DM.cdsOrderItems.Edit;
    if DM.cdsOrderItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0) > 0 then
      DM.cdsOrderItemsCount.AsFloat := DM.cdsOrderItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0)
    else
      DM.cdsOrderItemsCount.AsFloat := 0;
    DM.cdsOrderItems.Post;

    RecalculateTotalPriceAndWeight;
  end
  else
  if tcMain.ActiveTab = tiStoreReal then
  begin
    DM.cdsStoreRealItems.Edit;
    if DM.cdsStoreRealItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0) > 0 then
      DM.cdsStoreRealItemsCount.AsFloat := DM.cdsStoreRealItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0)
    else
      DM.cdsStoreRealItemsCount.AsFloat := 0;
    DM.cdsStoreRealItems.Post;
  end
  else
  if tcMain.ActiveTab = tiReturnIn then
  begin
    DM.cdsReturnInItems.Edit;
    if DM.cdsReturnInItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0) > 0 then
      DM.cdsReturnInItemsCount.AsFloat := DM.cdsReturnInItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0)
    else
      DM.cdsReturnInItemsCount.AsFloat := 0;
    DM.cdsReturnInItems.Post;

    RecalculateReturnInTotalPriceAndWeight;
  end;

  ppEnterAmount.IsOpen := false;
end;

// переход на форму справочников
procedure TfrmMain.bHandBookClick(Sender: TObject);
begin
  FCanEditPartner := false;

  SwitchToForm(tiHandbook, nil);
end;

// переход на форму заданий
procedure TfrmMain.bTasksClick(Sender: TObject);
begin
  if pos('(', lTasks.Text) > 0 then
    ShowTasks(false)
  else
    ShowTasks(true);
end;

// вызов обновления программы
procedure TfrmMain.bUpdateProgramClick(Sender: TObject);
begin
  DM.UpdateProgram(mrYes);
end;

// отображения ТТ которые необходимо посетить в выбранные день недели
procedure TfrmMain.bMondayClick(Sender: TObject);
begin
  ShowPartners(TButton(Sender).Tag, TButton(Sender).Text);
end;

// переход на форму ввода новой заявки на товары
procedure TfrmMain.bNewCashClick(Sender: TObject);
begin
  CreateEditMovementCash(true);
end;

procedure TfrmMain.bNewOrderExternalClick(Sender: TObject);
begin
  CreateEditOrderExtrernal(true);
end;

// переход на форму ввода новых "остатков"
procedure TfrmMain.bNewStoreRealClick(Sender: TObject);
var
  FindRec: boolean;
  Mes: string;
begin
  FindRec := false;
  if DM.cdsStoreReals.Locate('OperDate', Date(), []) then
    FindRec := true;

  if FindRec then
  begin
    if DM.cdsStoreRealsisSync.AsBoolean then
      Mes := 'Остатки на сегодняшнее число уже введены и переданы в центр. Перейти к их просмотру?'
    else
      Mes := 'Остатки на сегодняшнее число уже введены. Перейти к их редактированию?';

    TDialogService.MessageDialog(Mes,
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbYes, 0, CreateEditStoreReal);
  end
  else
    CreateEditStoreReal(mrNone);
end;

procedure TfrmMain.bOkPasswordClick(Sender: TObject);
begin
  if ePassword.Text <> CorrectPassword then
  begin
    TDialogService.MessageDialog('Введен неправильный пароль', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
    exit;
  end;

  vsbMain.Enabled := true;
  pTemporaryServerPassword.Visible := false;

  WebServerLayout1.Height := 25;
  WebServerLayout2.Height := 60;
  WebServerEdit.Text := FTemporaryServer;
  gc_WebService := '';
  FUseTemporaryServer := true;
end;

// переход на форму ввода нового возврата товаров
procedure TfrmMain.bNewReturnInClick(Sender: TObject);
begin
  CreateEditReturnIn(true);
end;

// получение текущех координат для новой ТТ
procedure TfrmMain.bNewPartnerGPSClick(Sender: TObject);
begin
  GetCurrentCoordinates;
  if FCurCoordinatesSet then
  begin
    eNewPartnerGPSN.Text := FormatFloat('0.000000', FCurCoordinates.Latitude);
    eNewPartnerGPSE.Text := FormatFloat('0.000000', FCurCoordinates.Longitude);
  end
  else
    ShowMessage('Не удалось получить текущие координаты');
end;

// переход на форму отображения все торговых точек
procedure TfrmMain.bPartnersClick(Sender: TObject);
begin
  ShowPartners(8, 'Все ТТ');
end;

// переход на форму отображения маршрута контрагента
procedure TfrmMain.bPathonMapbyPhotoClick(Sender: TObject);
begin
  FPhotoPath := true;
  lCaption.Text := 'Маршрут торгового агента по фотографиям';

  ShowPathOnMap;
end;

procedure TfrmMain.bPathonMapClick(Sender: TObject);
begin
  FPhotoPath := false;
  lCaption.Text := 'Маршрут торгового агента';

  ShowPathOnMap;
end;

// переход на форму отображения прайс-листов
procedure TfrmMain.bPriceListClick(Sender: TObject);
begin
  ShowPriceLists;
end;

// формирование и отображение акта сверки
procedure TfrmMain.bPrintJuridicalCollationClick(Sender: TObject);
var
  SettingsFile : TIniFile;
begin
  lStartRemains.Text := 'Сальдо на начало периода: 0';
  lEndRemains.Text := 'Сальдо на конец периода: 0';
  lTotalDebit.Text := '0';
  lTotalKredit.Text := '0';

  DM.GenerateJuridicalCollation(deStartRJC.Date, deEndRJC.Date,
           FJuridicalList[cbJuridicals.ItemIndex].Id,
           FPartnerList[cbPartners.ItemIndex].Id,
           FContractIdList[cbContracts.ItemIndex],
           FPaidKindIdList[cbPaidKind.ItemIndex]);

  lCaption.Text := 'Акт сверки для "' + cbJuridicals.Items[cbJuridicals.ItemIndex] + '" за период с ' +
    FormatDateTime('DD.MM.YYYY', deStartRJC.Date) +  ' по ' + FormatDateTime('DD.MM.YYYY', deEndRJC.Date) +
    '. Форма оплаты: ' + cbPaidKind.Items[cbPaidKind.ItemIndex];
  SwitchToForm(tiPrintJuridicalCollation, nil);

  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  SettingsFile := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'settings.ini'));
  {$ELSE}
  SettingsFile := TIniFile.Create('settings.ini');
  {$ENDIF}
  try
    SettingsFile.WriteString('REPORT', 'StartRJC', FormatDateTime('DD.MM.YYYY', deStartRJC.Date));
    SettingsFile.WriteString('REPORT', 'EndRJC', FormatDateTime('DD.MM.YYYY', deEndRJC.Date));
    SettingsFile.WriteInteger('REPORT', 'JuridicalRJC', FJuridicalList[cbJuridicals.ItemIndex].Id);
    SettingsFile.WriteInteger('REPORT', 'PartnerRJC', FPartnerList[cbPartners.ItemIndex].Id);
    SettingsFile.WriteInteger('REPORT', 'ContractRJC', FContractIdList[cbContracts.ItemIndex]);
    SettingsFile.WriteInteger('REPORT', 'PaidKindRJC', FPaidKindIdList[cbPaidKind.ItemIndex]);
  finally
    FreeAndNil(SettingsFile);
  end;
end;

// переход на форму отображения всех акционных товаров
procedure TfrmMain.bPromoGoodsClick(Sender: TObject);
begin
  ShowPromoGoods;
end;

// переход на форму отображения всех ТТ, участвующих в акции
procedure TfrmMain.bPromoPartnersClick(Sender: TObject);
begin
  ShowPromoPartners;
end;

// обновления координат ТТ
procedure TfrmMain.bRefreshDocClick(Sender: TObject);
begin
  // документы по остаткам
  DM.LoadAllStoreReals(deStartDoc.Date, deEndDoc.Date);
  BuildStoreRealDocsList;

  // документы по заявкам на товары
  DM.LoadAllOrderExternal(deStartDoc.Date, deEndDoc.Date);
  BuildOrderExternalDocsList;

  // документы по возвратам
  DM.LoadAllReturnIn(deStartDoc.Date, deEndDoc.Date);
  BuildReturnInDocsList;

  // фотографии
  DM.LoadAllPhotoGroups(deStartDoc.Date, deEndDoc.Date);

  // оплаты
  DM.LoadAllCash(deStartDoc.Date, deEndDoc.Date);
  BuildCashDocsList;
end;

procedure TfrmMain.bRefreshMapScreenClick(Sender: TObject);
begin
  tcPartnerInfoChange(tcPartnerInfo);
end;

// обновления карты с маршрутом контрагента
procedure TfrmMain.bRefreshPathOnMapClick(Sender: TObject);
var
  RouteQuery: TFDQuery;
  TableName: string;
begin
  FMarkerList.Clear;

  if FPhotoPath then
    TableName := 'MovementItem_Visit'
  else
    TableName := 'Movement_RouteMember';

  RouteQuery := TFDQuery.Create(nil);
  try
    RouteQuery.Connection := DM.conMain;
    try
      if cbShowAllPath.IsChecked then
        RouteQuery.Open('select * from ' + TableName)
      else
        RouteQuery.Open('select * from ' + TableName + ' where date(InsertDate) = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', deDatePath.Date)));
    except
      on E: Exception do
        Showmessage(E.Message);
    end;

    RouteQuery.First;
    while not RouteQuery.EOF do
    begin
      FMarkerList.Add(TLocationData.Create(RouteQuery.FieldByName('GPSN').AsFloat,
        RouteQuery.FieldByName('GPSE').AsFloat, RouteQuery.FieldByName('INSERTDATE').AsDateTime));

      RouteQuery.Next;
    end;

    if Assigned(FWebGMap) then
    try
      FWebGMap.Visible := False;
      FreeAndNil(FWebGMap);
    except
      // buggy piece of shit
    end;

    FMapLoaded := False;

    FWebGMap := TTMSFMXWebGMaps.Create(Self);
    FWebGMap.OnDownloadFinish := WebGMapDownloadFinish;
    FWebGMap.Align := TAlignLayout.Client;
    FWebGMap.MapOptions.ZoomMap := 14;
    FWebGMap.Parent := pPathOnMap;
  finally
    FreeAndNil(RouteQuery);
  end;
end;

// обновление списка задач контрагента
procedure TfrmMain.bRefreshTasksClick(Sender: TObject);
var
  Mode: TActiveMode;
begin
  if rbAllTask.IsChecked then
    Mode := amAll
  else
  if rbOpenTask.IsChecked then
    Mode := amOpen
  else
    Mode := amClose;

  if cbUseDateTask.IsChecked then
    DM.LoadTasks(Mode, true, deDateTask.Date)
  else
    DM.LoadTasks(Mode, true);

  lwTasks.ScrollViewPos := 0;
end;

// возврат на форму логина
procedure TfrmMain.bReloginClick(Sender: TObject);
begin
  ReturnPriorForm;
end;

// переход на форму отображения информации
procedure TfrmMain.bInfoClick(Sender: TObject);
begin
  ShowInformation;
end;

// переход на форму отчетов
procedure TfrmMain.bReportClick(Sender: TObject);
begin
  bReportJuridicalCollation.Enabled := not gc_User.Local;

  SwitchToForm(tiReports, nil);
end;

// переход на форму ввода пераметров акта сверки
procedure TfrmMain.bReportJuridicalCollationClick(Sender: TObject);
var
  i: integer;
begin
  SwitchToForm(tiReportJuridicalCollation, nil);

  FFirstSet := true; // для востановления сохраненных значений ТТ и договоров при первом открытии

  // заполнение списка юридических лиц
  cbJuridicals.Items.Clear;
  FJuridicalList.Clear;

  with DM.qrySelect do
  begin
    Open('select Id, ValueData, group_concat(distinct CONTRACTID) ContractIds from OBJECT_JURIDICAL ' +
      'where ISERASED = 0 GROUP BY ID order by ValueData');
    First;

    while not Eof do
    begin
      AddComboItem(cbJuridicals, FieldByName('ValueData').AsString);
      FJuridicalList.Add(TJuridicalItem.Create(FieldByName('Id').AsInteger, FieldByName('ContractIds').AsString));

      Next;
    end;

    Close;
  end;

  for i := 0 to FPartnerList.Count - 1 do
    if FJuridicalList[i].Id = FJuridicalRJC then
    begin
      cbJuridicals.ItemIndex := i;
    end;
  if cbJuridicals.ItemIndex < 0 then
    cbJuridicals.ItemIndex := 0;

  if FStartRJC = '' then
    deStartRJC.Date := Date()
  else
    deStartRJC.Date := StrToDate(FStartRJC);
  
  if FEndRJC = '' then
    deEndRJC.Date := Date()
  else
    deEndRJC.Date := StrToDate(FEndRJC);

  // заполнение списка форм оплаты
  cbPaidKind.Items.Clear;
  FPaidKindIdList.Clear;
  AddComboItem(cbPaidKind, 'все');
  FPaidKindIdList.Add(0);
  AddComboItem(cbPaidKind, DM.tblObject_ConstPaidKindName_First.AsString);
  FPaidKindIdList.Add(DM.tblObject_ConstPaidKindId_First.AsInteger);
  AddComboItem(cbPaidKind, DM.tblObject_ConstPaidKindName_Second.AsString);
  FPaidKindIdList.Add(DM.tblObject_ConstPaidKindId_Second.AsInteger);

  cbPaidKind.ItemIndex := FPaidKindIdList.IndexOf(FPaidKindRJC);
  if cbPaidKind.ItemIndex < 0 then
    cbPaidKind.ItemIndex := 0;

  FFirstSet := false;
end;

// переход на форму отображение маршрутов
procedure TfrmMain.bRouteClick(Sender: TObject);
begin
  FCanEditPartner := false;

  SwitchToForm(tiRoutes, nil);
end;

procedure TfrmMain.bSaveCashClick(Sender: TObject);
begin
  if FCanEditDocument then
  begin
    if Trim(eCashAmount.Text) = '' then
    begin
      ShowMessage('Необходимо ввести сумму оплаты');
      exit;
    end;

    if StrToFloatDef(eCashAmount.Text, 0) = 0 then
    begin
      ShowMessage('Необходимо ввести корректную сумму оплаты больше 0');
      exit;
    end;

    DM.SaveCash(FOldCashId, deCashDate.Date, StrToFloat(eCashAmount.Text), eCashComment.Text);

    DM.qryCash.Refresh;

    if FEditDocuments then
      ChangeCashDoc;
  end;

  vsbMain.Enabled := true;
  pEnterMovmentCash.Visible := false;
end;

// сохранение новой ТТ
procedure TfrmMain.bSaveNewPartnerClick(Sender: TObject);
var
  JuridicalId: integer;
  JuridicalName: string;
  ErrMes: string;
begin
  if ((cSelectJuridical.IsChecked) and (cbNewPartnerJuridical.ItemIndex < 0)) or
     ((not cSelectJuridical.IsChecked) and (Trim(eNewPartnerJuridical.Text) = '')) then
  begin
    ShowMessage('Необходимо ввести юридическое лицо или выбрать из уже существующих');
    exit;
  end;

  if Trim(eNewPartnerAddress.Text) = '' then
  begin
    ShowMessage('Необходимо ввести адрес торговой точки');
    exit;
  end;

  if cSelectJuridical.IsChecked then
  begin
    JuridicalId := FJuridicalList[cbNewPartnerJuridical.ItemIndex].Id;
    JuridicalName := cbNewPartnerJuridical.Items[cbNewPartnerJuridical.ItemIndex];
  end
  else
  begin
    JuridicalId := -1;
    JuridicalName := Trim(eNewPartnerJuridical.Text);
  end;

  if DM.CreateNewPartner(JuridicalId, JuridicalName, Trim(eNewPartnerAddress.Text),
    StrToFloatDef(eNewPartnerGPSN.Text, 0), StrToFloatDef(eNewPartnerGPSE.Text, 0), ErrMes) then
  begin
     ShowMessage('Сохранение новой торговой точки прошло успешно.');
     DM.qryPartner.Refresh;
     ReturnPriorForm;
   end
   else
     ShowMessage('Ошибка при сохранении: ' + ErrMes);
end;

// подтверждения выбора товаров для заявки, остатков или возврата
procedure TfrmMain.bSaveOIClick(Sender: TObject);
begin
  ReturnPriorForm;
end;

// сделать/отменить снимок (фотография)
procedure TfrmMain.bCaptureClick(Sender: TObject);
begin
  if CameraComponent.Active then
  begin
    CameraComponent.Active := False;
    PlayAudio;
    imCapture.Visible := false;
    imRevert.Visible := true;
    bSavePartnerPhoto.Enabled := true;
  end
  else
  begin
    ScaleImage(0);
    CameraComponent.Active := True;
    imCapture.Visible := true;
    imRevert.Visible := false;
    bSavePartnerPhoto.Enabled := false;
  end;
end;

// ввод коментария к фотографии перед сохранением
procedure TfrmMain.bSavePartnerPhotoClick(Sender: TObject);
begin
  vsbMain.Enabled := false;
  pPhotoComment.Visible := true;
end;

// сохранение группы фотографий
procedure TfrmMain.bSavePGClick(Sender: TObject);
begin
  DM.SavePhotoGroup(ePhotoGroupName.Text);

  DM.qryPhotoGroups.Refresh;

  vsbMain.Enabled := true;
  pNewPhotoGroup.Visible := false;
end;

// сохранить фотографию
procedure TfrmMain.bSavePhotoClick(Sender: TObject);
var
  BlobStream : TMemoryStream;
  Surf : TBitmapSurface;
  qrySavePhoto : TFDQuery;
  GlobalId : TGUID;
begin
  try
    BlobStream := TMemoryStream.Create;
    aiWait.Visible := true;
    aiWait.Enabled := true;
    Application.ProcessMessages;

    Surf := TBitmapSurface.Create;
    try
      Surf.Assign(imgCameraPreview.Bitmap);

      if not TBitmapCodecManager.SaveToStream( BlobStream, Surf, '.jpg') then
        raise EBitmapSavingFailed.Create('Error saving Bitmap to jpg');

      BlobStream.Seek(0, 0);

      qrySavePhoto := TFDQuery.Create(nil);
      try
        qrySavePhoto.Connection := DM.conMain;

        qrySavePhoto.SQL.Text := 'Insert into MovementItem_Visit (MovementId, GUID, Photo, Comment, InsertDate, GPSN, GPSE, isErased, isSync) ' +
          'Values (:MovementId, :GUID, :Photo, :Comment, :InsertDate, :GPSN, :GPSE, 0, 0)';
        qrySavePhoto.Params[0].Value := DM.qryPhotoGroupsId.AsInteger;
        CreateGUID(GlobalId);
        qrySavePhoto.Params[1].Value := GUIDToString(GlobalId);
        qrySavePhoto.Params[2].LoadFromStream(BlobStream, ftBlob);
        qrySavePhoto.Params[3].Value := ePhotoComment.Text;
        qrySavePhoto.Params[4].Value := Now();

        GetCurrentCoordinates;
        if FCurCoordinatesSet then
        begin
          qrySavePhoto.Params[5].Value := FCurCoordinates.Latitude;
          qrySavePhoto.Params[6].Value := FCurCoordinates.Longitude;
        end
        else
        begin
          qrySavePhoto.Params[5].Value := 0;
          qrySavePhoto.Params[6].Value := 0;
        end;

        qrySavePhoto.ExecSQL;

        ShowMessage('Фотография успешно сохранена');

        DM.qryPhotos.Refresh;
      finally
        FreeAndNil(qrySavePhoto);
      end;
    finally
      aiWait.Visible := false;
      aiWait.Enabled := false;
      Application.ProcessMessages;
      FreeAndNil(BlobStream);
      Surf.Free;
    end;
  Except
    on E: Exception do
      Showmessage(E.Message);
  end;

  vsbMain.Enabled := true;
  pPhotoComment.Visible := false;

  CameraFree;
  ReturnPriorForm;
end;

// сохранение изменения коментария к фотографии
procedure TfrmMain.bSavePhotoCommentClick(Sender: TObject);
begin
  DM.qryPhotos.Edit;
  DM.qryPhotosComment.AsString := ePhotoCommentEdit.Text;
  DM.qryPhotosisSync.AsBoolean := false;
  DM.qryPhotos.Post;

  ReturnPriorForm;
end;

// сохранение заявки на товары
procedure TfrmMain.bSaveOrderExternalUnCompleteClick(Sender: TObject);
begin
  if Sender = bSaveOrderExternalUnComplete then
    TDialogService.MessageDialog('Документ не проведен и не будет участвовать в синхронизации. Продолжить?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, SaveOrderExtrernal)
  else
    SaveOrderExtrernal(mrNone);
end;

// сохранение "возврата"
procedure TfrmMain.bSaveReturnInUnCompleteClick(Sender: TObject);
begin
  if Sender = bSaveReturnInUnComplete then
    TDialogService.MessageDialog('Документ не проведен и не будет участвовать в синхронизации. Продолжить?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, SaveReturnIn)
  else
    SaveReturnIn(mrNone);
end;

// сохранение "остатков"
procedure TfrmMain.bSaveStoreRealUnCompleteClick(Sender: TObject);
begin
  if Sender = bSaveStoreRealUnComplete then
    TDialogService.MessageDialog('Документ не проведен и не будет участвовать в синхронизации. Продолжить?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, SaveStoreReal)
  else
    SaveStoreReal(mrNone);
end;

// сохранение отметки про выполнение задания
procedure TfrmMain.bSaveTaskClick(Sender: TObject);
begin
  if DM.CloseTask(DM.cdsTasksId.AsInteger, eTaskComment.Text) then
  begin
    if tcMain.ActiveTab = tiTasks then
    begin
      DM.cdsTasks.Edit;
      DM.cdsTasksClosed.AsBoolean := true;
      DM.cdsTasks.Post;
    end
    else
    if tcMain.ActiveTab = tiPartnerInfo then
    begin
      DM.cdsTasks.Delete;
      if DM.cdsTasks.RecordCount = 0 then
      begin
        tiPartnerTasks.Visible := false;
        tcPartnerInfo.ActiveTab := tiInfo;
      end;
    end;
  end;

  vsbMain.Enabled := true;
  pTaskComment.Visible := false;
end;

// запрос на изменение координа ТТ
procedure TfrmMain.bSetPartnerCoordinateClick(Sender: TObject);
var
  Mes : string;
begin
  if (DM.qryPartnerGPSN.AsFloat <> 0) and (DM.qryPartnerGPSE.AsFloat <> 0) then
    Mes := 'Изменить прежние координаты ТТ на текущие?'
  else
    Mes := 'Назназить ТТ текущие координаты?';

  TDialogService.MessageDialog(Mes, TMsgDlgType.mtWarning,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, SetPartnerCoordinates);
end;

// переход на форму синхронизации
procedure TfrmMain.bSyncClick(Sender: TObject);
begin
  SwitchToForm(tiSync, nil);
end;

// вызов синхронизации с главной БД
procedure TfrmMain.bSyncDataClick(Sender: TObject);
begin
  DM.SynchronizeWithMainDatabase(cbLoadData.IsChecked, cbUploadData.IsChecked);
end;

// выход с формы фотографирования без сохранения
procedure TfrmMain.bClosePhotoClick(Sender: TObject);
begin
  CameraFree;
  ReturnPriorForm;
end;

procedure TfrmMain.bDocumentsClick(Sender: TObject);
begin
  // начитка и отображение документов
  ShowDocuments;
end;

procedure TfrmMain.bDotClick(Sender: TObject);
begin
  if lAmount.Text = '' then
    lAmount.Text := '0.'
  else
  if pos('.', lAmount.Text) = 0 then
    lAmount.Text := lAmount.Text + TButton(Sender).Text;
end;

// переход на форму визитов (дни недели в которые надо посетить ТТ)
procedure TfrmMain.bVisitClick(Sender: TObject);
begin
  FCanEditPartner := true;

  SwitchToForm(tiRoutes, nil);
end;

procedure TfrmMain.tcPartnerInfoChange(Sender: TObject);
var
  Coordinates: TLocationCoord2D;
begin
  // карта с координатами ТТ
  if tcPartnerInfo.ActiveTab = tiPartnerMap then
  begin
    if (DM.qryPartnerGPSN.AsFloat <> 0) and (DM.qryPartnerGPSE.AsFloat <> 0) then
      GetPartnerMap(DM.qryPartnerGPSN.AsFloat, DM.qryPartnerGPSE.AsFloat)
    else
    begin
      if GetCoordinates(DM.qryPartnerAddress.AsString, Coordinates) then
        GetPartnerMap(Coordinates.Latitude, Coordinates.Longitude)
      else
        GetPartnerMap(0, 0);
    end;
  end
  else
  begin
    tErrorMap.Enabled := false;

    if Assigned(FWebGMap) then
    begin
      try
        FWebGMap.Visible := false;
        FreeAndNil(FWebGMap);
      except
      end;
    end;
  end;
end;

procedure TfrmMain.tErrorMapTimer(Sender: TObject);
begin
  tErrorMap.Enabled := false;

  FMapLoaded := true;

  if Assigned(FWebGMap) then
  begin
    try
      FWebGMap.Visible := false;
      FreeAndNil(FWebGMap);
    except
    end;
  end;

  pMapButtons.Enabled := true;
  bRefreshMapScreen.Visible := true;
  bSetPartnerCoordinate.Visible := false;
  lNoMap.Visible := true;
  lNoMap.Text := 'Не удалось загрузить карту с расположением ТТ';
end;

// таймер сохранения маршрута контрагента - сохраняет текущие координаты какждые 5 минут
procedure TfrmMain.tSavePathTimer(Sender: TObject);
var
  GlobalId : TGUID;
begin
  tSavePath.Enabled := false;
  try
    GetCurrentCoordinates;
    if FCurCoordinatesSet then
    begin
      DM.tblMovement_RouteMember.Open;

      DM.tblMovement_RouteMember.Append;
      CreateGUID(GlobalId);
      DM.tblMovement_RouteMemberGUID.AsString := GUIDToString(GlobalId);
      DM.tblMovement_RouteMemberGPSN.AsFloat := FCurCoordinates.Latitude;
      DM.tblMovement_RouteMemberGPSE.AsFloat := FCurCoordinates.Longitude;
      DM.tblMovement_RouteMemberInsertDate.AsDateTime := Now();
      DM.tblMovement_RouteMemberisSync.AsBoolean := false;
      DM.tblMovement_RouteMember.Post;

      DM.tblMovement_RouteMember.Close;
    end;
  finally
    tSavePath.Enabled := true;
  end;
end;

// таймер для мигания вкладки задания ТТ
procedure TfrmMain.tTasksTimer(Sender: TObject);
begin
  tTasks.Enabled := false;

  if tiPartnerTasks.Visible and (tcPartnerInfo.ActiveTab <> tiPartnerTasks) then
  begin
    if tiPartnerTasks.TextSettings.FontColor = TAlphaColors.Black then
      tiPartnerTasks.TextSettings.FontColor := TAlphaColors.Red
    else
      tiPartnerTasks.TextSettings.FontColor := TAlphaColors.Black;
  end
  else
    tiPartnerTasks.TextSettings.FontColor := TAlphaColors.Black;

  tTasks.Enabled := true;
end;

// получения адреса по координатам
function TfrmMain.GetAddress(const Latitude, Longitude: Double): string;
  function PrependIfNotEmpty(const Prefix, Subject: string): string;
  begin
    if Subject.IsEmpty then
      Result := ''
    else
      Result := Prefix+Subject;
  end;
begin
  try
    WebGMapsReverseGeocoder.Latitude := Latitude;
    WebGMapsReverseGeocoder.Longitude := Longitude;
    if WebGMapsReverseGeocoder.LaunchReverseGeocoding = erOk then
      begin
        Result := WebGMapsReverseGeocoder.ResultAddress.Street +
                  PrependIfNotEmpty(', ', WebGMapsReverseGeocoder.ResultAddress.StreetNumber) +
                  PrependIfNotEmpty(', ', WebGMapsReverseGeocoder.ResultAddress.City) +
                  PrependIfNotEmpty(', ', WebGMapsReverseGeocoder.ResultAddress.Region) +
                  PrependIfNotEmpty(', ', WebGMapsReverseGeocoder.ResultAddress.Country);
      end
    else
      Result :=  FormatFloat('0.000000', Latitude)+'N '+FormatFloat('0.000000', Longitude)+'E';
  except
    Result :=  FormatFloat('0.000000', Latitude)+'N '+FormatFloat('0.000000', Longitude)+'E';
  end;
end;

function TfrmMain.GetCoordinates(const Address: string; out Coordinates: TLocationCoord2D): Boolean;
begin
  try
    WebGMapsGeocoder.Address:= Address;
    if WebGMapsGeocoder.LaunchGeocoding = erOk then
    begin
      Coordinates := TLocationCoord2D.Create(WebGMapsGeocoder.ResultLatitude, WebGMapsGeocoder.ResultLongitude);
      Result := True;
    end
    else
      Result := False;
  except
    Result := False;
  end;
end;

// завершение загрузки карты (с установкой маркеров при необходимости)
procedure TfrmMain.WebGMapDownloadFinish(Sender: TObject);
var
  i : integer;
begin
  if Assigned(FWebGMap) and not FMapLoaded then
  begin
    tErrorMap.Enabled := false;
    FMapLoaded := True;

    FWebGMap.Markers.Clear;

    if FMarkerList.Count > 0 then
    begin
      for i := 0 to FMarkerList.Count - 1 do
      begin
        with FWebGMap.Markers.Add(FMarkerList[i].Latitude, FMarkerList[i].Longitude, GetAddress(FMarkerList[i].Latitude, FMarkerList[i].Longitude), '', True, True, False, True, False, 0, TMarkerIconColor.icDefault, -1, -1, -1, -1) do
          if tcMain.ActiveTab = tiPathOnMap then
            MapLabel.Text := IntToStr(i + 1) + ') ' + FormatDateTime('DD.MM.YYYY hh:mm:ss', FMarkerList[i].VisitTime)
          else
            MapLabel.Text := Title;
      end;

      FWebGMap.MapPanTo(FWebGMap.Markers[0].Latitude, FWebGMap.Markers[0].Longitude);
    end;

    pMapButtons.Enabled := true;
  end;
end;

// переход на форму отображения большой карты
procedure TfrmMain.ShowBigMap;
begin
  SwitchToForm(tiMap, nil);

  FMapLoaded := False;

  FWebGMap := TTMSFMXWebGMaps.Create(Self);
  FWebGMap.OnDownloadFinish := WebGMapDownloadFinish;
  FWebGMap.Align := TAlignLayout.Client;
  FWebGMap.MapOptions.ZoomMap := 13;
  FWebGMap.Parent := tiMap;
end;

// вызов карты с координатами ТТ и дальнейшем получением скриншота этой карты
procedure TfrmMain.GetPartnerMap(GPSN, GPSE: Double);
var
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  MobileNetworkStatus : TMobileNetworkStatus;
  {$ENDIF}
  isConnected : boolean;
  SetCordinate: boolean;
  Coordinates: TLocationCoord2D;
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  isConnected := false;
  try
    MobileNetworkStatus := TMobileNetworkStatus.Create;
    try
      isConnected := MobileNetworkStatus.isConnected;
    finally
      FreeAndNil(MobileNetworkStatus);
    end;
  except
  end;
  {$ELSE}
  isConnected := true;
  {$ENDIF}

  if isConnected then
  begin
    SetCordinate := true;
    FMarkerList.Clear;

    if (GPSN <> 0) and (GPSE <> 0) then
    begin
      Coordinates := TLocationCoord2D.Create(GPSN, GPSE);
      FMarkerList.Add(TLocationData.Create(GPSN, GPSE, 0));
    end
    else
    begin
      GetCurrentCoordinates;
      if FCurCoordinatesSet then
        Coordinates := TLocationCoord2D.Create(FCurCoordinates.Latitude, FCurCoordinates.Longitude)
      else
        SetCordinate := false;
    end;


    FMapLoaded := False;

    FWebGMap := TTMSFMXWebGMaps.Create(Self);
    FWebGMap.Align := TAlignLayout.Client;
    {FWebGMap.ControlsOptions.PanControl.Visible := false;
    FWebGMap.ControlsOptions.ZoomControl.Visible := false;
    FWebGMap.ControlsOptions.MapTypeControl.Visible := false;
    FWebGMap.ControlsOptions.ScaleControl.Visible := false;
    FWebGMap.ControlsOptions.StreetViewControl.Visible := false;
    FWebGMap.ControlsOptions.OverviewMapControl.Visible := false;
    FWebGMap.ControlsOptions.RotateControl.Visible := false;
    }
    FWebGMap.MapOptions.ZoomMap := 18;
    FWebGMap.Parent := pMap;
    FWebGMap.OnDownloadFinish := WebGMapDownloadFinish;
    if SetCordinate then
    begin
      FWebGMap.CurrentLocation.Latitude := Coordinates.Latitude;
      FWebGMap.CurrentLocation.Longitude := Coordinates.Longitude;
    end;

    pMapButtons.Enabled := false;
    bSetPartnerCoordinate.Visible := true;
    bRefreshMapScreen.Visible := false;
    lNoMap.Visible := false;

    tErrorMap.Enabled := true;
  end
  else
  begin
    pMapButtons.Enabled := true;
    bSetPartnerCoordinate.Visible := false;
    bRefreshMapScreen.Visible := true;
    lNoMap.Visible := true;
    lNoMap.Text := 'Без соединения с интернет нельзя получить карту с расположением ТТ';
  end;
end;

// перевод формы в/из режим ожидания
procedure TfrmMain.Wait(AWait: Boolean);
begin
  LogInButton.Enabled := not AWait;
  LoginEdit.Enabled := not AWait;
  PasswordEdit.Enabled := not AWait;
  WebServerEdit.Enabled := not AWait;
  SyncCheckBox.Enabled := not AWait;

  if AWait then
    Screen_Cursor_crHourGlass
  else
    Screen_Cursor_crDefault;

  Application.ProcessMessages;
end;

// обработка изменения закладки (формы)
procedure TfrmMain.ChangeMainPageUpdate(Sender: TObject);
var
  i, TaskCount : integer;
begin
  if Assigned(FWebGMap) then
  try
    FWebGMap.Visible := False;
    FreeAndNil(FWebGMap);
  except
    // buggy piece of shit
  end;

  { настройка панели возврата }
  if (tcMain.ActiveTab = tiStart) or (tcMain.ActiveTab = tiGoodsItems) or (tcMain.ActiveTab = tiCamera)  then
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

    if tcMain.ActiveTab = tiPartnerInfo then
    begin
      lCaption.Text := DM.qryPartnerFullName.AsString;
    end
    else
    if tcMain.ActiveTab = tiMain then
      lCaption.Text := 'Alan Mobile'
    else
    if tcMain.ActiveTab = tiRoutes then
      lCaption.Text := 'Маршруты'
    else
    if tcMain.ActiveTab = tiPartners then
      lCaption.Text := 'Торговые точки'
    else
    if tcMain.ActiveTab = tiHandbook then
      lCaption.Text := 'Справочники'
    else
    if tcMain.ActiveTab = tiPriceList then
      lCaption.Text := 'Прайс-лист'
    else
    if (tcMain.ActiveTab = tiPromoPartners) and (pPromoPartnerDate.Visible) then
      lCaption.Text := 'Торговые точки, участвующие в акциях'
    else
    if (tcMain.ActiveTab = tiPromoGoods) and (pPromoGoodsDate.Visible) then
      lCaption.Text := 'Акционные товары'
    else
    if tcMain.ActiveTab = tiSync then
      lCaption.Text := 'Синхронизация'
    else
    if tcMain.ActiveTab = tiInformation then
      lCaption.Text := 'Информация'
    else
    if tcMain.ActiveTab = tiTasks then
      lCaption.Text := 'Задания'
    else
    if tcMain.ActiveTab = tiDocuments then
      lCaption.Text := 'Документы'
    else
    if tcMain.ActiveTab = tiReports then
      lCaption.Text := 'Отчеты'
    else
    if tcMain.ActiveTab = tiReportJuridicalCollation then
      lCaption.Text := 'Акт сверки'
    else
    if tcMain.ActiveTab = tiNewPartner then
      lCaption.Text := 'Ввод новой ТТ'
    else
    if tcMain.ActiveTab = tiOrderExternal then
      lCaption.Text := DM.cdsOrderExternalPartnerFullName.AsString
    else
    if tcMain.ActiveTab = tiStoreReal then
      lCaption.Text := DM.cdsStoreRealsPartnerFullName.AsString
    else
    if tcMain.ActiveTab = tiReturnIn then
      lCaption.Text := DM.cdsReturnInPartnerFullName.AsString;
  end;

  if tcMain.ActiveTab = tiMain then
  begin
    TaskCount := DM.LoadTasks(amOpen, false);
    if TaskCount > 0 then
      lTasks.Text := 'Задания (' + IntToStr(TaskCount) + ')'
    else
      lTasks.Text := 'Задания';
  end;

  if tcMain.ActiveTab = tiPartners then
    sbPartnerMenu.Visible := true
  else
    sbPartnerMenu.Visible := false;

  if tcMain.ActiveTab = tiPartnerInfo then
    tTasks.Enabled := true
  else
    tTasks.Enabled := false;

  if tcMain.ActiveTab = tiStart then
    CheckDataBase;

  if tcMain.ActiveTab = tiRoutes then
    GetVistDays;

  if tcMain.ActiveTab = tiStoreReal then
    AddedNewStoreRealItems;

  if tcMain.ActiveTab = tiOrderExternal then
    AddedNewOrderItems;

  if tcMain.ActiveTab = tiReturnIn then
    AddedNewReturnInItems;

  if tcMain.ActiveTab = tiGoodsItems then
  begin
    for I := 0 to lwGoodsItems.Controls.Count-1 do
    if lwGoodsItems.Controls[I].ClassType = TSearchBox then
    begin
      TSearchBox(lwGoodsItems.Controls[I]).Text := '';
    end;

    lwGoodsItems.ScrollViewPos := 0;
  end;
end;

// реализация перехода между закладками ТТ с помощью движения пальца
procedure TfrmMain.ChangePartnerInfoLeftUpdate(Sender: TObject);
begin
  if tcPartnerInfo.TabIndex < tcPartnerInfo.TabCount - 1 then
    ChangePartnerInfoLeft.Tab := tcPartnerInfo.Tabs[tcPartnerInfo.TabIndex + 1]
  else
    ChangePartnerInfoLeft.Tab := nil;
end;

// реализация перехода между закладками ТТ с помощью движения пальца
procedure TfrmMain.ChangePartnerInfoRightUpdate(Sender: TObject);
begin
  if tcPartnerInfo.TabIndex > 0 then
    ChangePartnerInfoRight.Tab := tcPartnerInfo.Tabs[tcPartnerInfo.TabIndex - 1]
  else
    ChangePartnerInfoRight.Tab := nil;
end;

// проверка локальной БД (получения настроек конекта с центральной БД)
procedure TfrmMain.CheckDataBase;
begin
  PasswordEdit.Text := '';

  if not DM.Connected then
  begin
    LogInButton.Enabled := false;
    ShowMessage('Ошибка соединения с локальной БД. Обратитесь к разработчику.');
    exit;
  end;

  if DM.tblObject_Const.Active then
    DM.tblObject_Const.Close;
  DM.tblObject_Const.Open;

  if (DM.tblObject_Const.RecordCount > 0) and (DM.tblObject_ConstWebService.AsString <> '') then
  begin
    gc_User := TUser.Create(DM.tblObject_ConstUserLogin.AsString, DM.tblObject_ConstUserPassword.AsString);
    gc_WebServers := DM.tblObject_ConstWebService.AsString.Split([';']);
    gc_WebService := gc_WebServers[0];

    if FTemporaryServer = '' then
      FTemporaryServer := gc_WebServers[0];

    WebServerLayout1.Height := 0;
    WebServerLayout2.Height := 0;
    SyncLayout.Visible := true;
  end
  else
  begin
    FreeAndNil(gc_User);
    SetLength(gc_WebServers, 0);
    gc_WebService := '';

    WebServerLayout1.Height := 25;
    WebServerLayout2.Height := 60;
    SyncLayout.Visible := false;
  end;

  FUseTemporaryServer := false;
end;

// формирования перечня дней на которые запланированы визиты в ТТ (с количеством ТТ)
procedure TfrmMain.GetVistDays;
var
  i, Num : integer;
  DaysCount : array[1..8] of integer;
  Schedule : string;
begin
  for i := 1 to 8 do
   DaysCount[i] := 0;

  with DM.qryPartner do
  begin
    SQL.Text := BasePartnerQuery + ' GROUP BY P.Id';
    ParamByName('DefaultPriceList').AsInteger := DM.tblObject_ConstPriceListId_def.AsInteger;
    Open;

    First;
    while not EOF do
    begin
      Schedule := FieldbyName('Schedule').AsString;
      if Schedule.Length <> 13 then
      begin
        ShowMessage('Ошибка в структуре поля Schedule');
        exit;
      end
      else
      begin
        for i := 1 to 7 do
          if Schedule[2 * i - 2 + Low(string)] = 't' then
            inc(DaysCount[i]);
      end;
      inc(DaysCount[8]);

      Next;
    end;
    Close;
  end;

  Num := 1;
  if DaysCount[1] > 0 then
  begin
    bMonday.Height := 55;
    bMonday.Text := '  ' + IntToStr(Num) + '. Понедельник';
    lMondayCount.Text := IntToStr(DaysCount[1]);
    inc(Num);
  end
  else
    bMonday.Height := 0;


  if DaysCount[2] > 0 then
  begin
    bTuesday.Height := 55;
    bTuesday.Text := '  ' + IntToStr(Num) + '. Вторник';
    lTuesdayCount.Text := IntToStr(DaysCount[2]);
    inc(Num);
  end
  else
    bTuesday.Height := 0;

  if DaysCount[3] > 0 then
  begin
    bWednesday.Height := 55;
    bWednesday.Text := '  ' + IntToStr(Num) + '. Среда';
    lWednesdayCount.Text := IntToStr(DaysCount[3]);
    inc(Num);
  end
  else
    bWednesday.Height := 0;

  if DaysCount[4] > 0 then
  begin
    bThursday.Height := 55;
    bThursday.Text := '  ' + IntToStr(Num) + '. Четверг';
    lThursdayCount.Text := IntToStr(DaysCount[4]);
    inc(Num);
  end
  else
    bThursday.Height := 0;

  if DaysCount[5] > 0 then
  begin
    bFriday.Height := 55;
    bFriday.Text := '  ' + IntToStr(Num) + '. Пятница';
    lFridayCount.Text := IntToStr(DaysCount[5]);
    inc(Num);
  end
  else
    bFriday.Height := 0;

  if DaysCount[6] > 0 then
  begin
    bSaturday.Height := 55;
    bSaturday.Text := '  ' + IntToStr(Num) + '. Суббота';
    lSaturdayCount.Text := IntToStr(DaysCount[6]);
    inc(Num);
  end
  else
    bSaturday.Height := 0;

  if DaysCount[7] > 0 then
  begin
    bSunday.Height := 55;
    bSunday.Text := '  ' + IntToStr(Num) + '. Воскресенье';
    lSundayCount.Text := IntToStr(DaysCount[7]);
  end
  else
    bSunday.Height := 0;

  lAllDaysCount.Text := IntToStr(DaysCount[8]);
end;

// переход на форму ввода новой ТТ
procedure TfrmMain.ibiNewPartnerClick(Sender: TObject);
begin
  ppPartner.IsOpen := False;

  EnterNewPartner;
end;

procedure TfrmMain.imCaptureClick(Sender: TObject);
begin

end;

// начитка справочников для ввода новой ТТ
procedure TfrmMain.EnterNewPartner;
begin
  cSelectJuridical.IsChecked := false;
  cSelectJuridicalChange(cSelectJuridical);

  eNewPartnerJuridical.Text := '';
  cbNewPartnerJuridical.ItemIndex := -1;
  eNewPartnerAddress.Text := '';
  eNewPartnerGPSN.Text := '';
  eNewPartnerGPSE.Text := '';

  // заполнение списка юридических лиц
  cbNewPartnerJuridical.Items.Clear;
  FJuridicalList.Clear;

  with DM.qrySelect do
  begin
    Open('select Id, ValueData, group_concat(distinct CONTRACTID) ContractIds from OBJECT_JURIDICAL ' +
      'where ISERASED = 0 GROUP BY ID order by ValueData');
    First;

    while not Eof do
    begin
      AddComboItem(cbNewPartnerJuridical, FieldByName('ValueData').AsString);
      FJuridicalList.Add(TJuridicalItem.Create(FieldByName('Id').AsInteger, FieldByName('ContractIds').AsString));

      Next;
    end;

    Close;
  end;

  SwitchToForm(tiNewPartner, nil);
end;

// переход на форму отображения списка ТТ, которые необходимо посетить в указаный день
procedure TfrmMain.ShowPartners(Day : integer; Caption : string);
var
  sQuery, CurGPSN, CurGPSE : string;
begin
  GetCurrentCoordinates;

  lDayInfo.Text := 'МАРШРУТ: ' + Caption;
  DM.qryPartner.Close;

  sQuery := BasePartnerQuery;

  if Day < 8 then
    sQuery := sQuery + ' and lower(substr(P.SCHEDULE, ' + IntToStr(2 * Day - 1) + ', 1)) = ''t''';

  if FCurCoordinatesSet then
  begin
    CurGPSN := FloatToStr(FCurCoordinates.Latitude);
    CurGPSE := FloatToStr(FCurCoordinates.Longitude);
    CurGPSN := StringReplace(CurGPSN, ',', '.', [rfReplaceAll]);
    CurGPSE := StringReplace(CurGPSE, ',', '.', [rfReplaceAll]);

    sQuery := sQuery + ' order by ((IFNULL(P.GPSN, 0) - ' + CurGPSN + ') * ' + LatitudeRatio + ') * ' +
      '((IFNULL(P.GPSN, 0) - ' + CurGPSN + ') * ' + LatitudeRatio + ') + ' +
      '((IFNULL(P.GPSE, 0) - ' + CurGPSE + ') * ' + LongitudeRatio + ') * ' +
      '((IFNULL(P.GPSE, 0) - ' + CurGPSE + ') * ' + LongitudeRatio + ')' +
      ', Name';
  end
  else
    sQuery := sQuery + ' order by Name';

  DM.qryPartner.SQL.Text := sQuery;
  DM.qryPartner.ParamByName('DefaultPriceList').AsInteger := DM.tblObject_ConstPriceListId_def.AsInteger;
  DM.qryPartner.Open;

  lwPartner.ScrollViewPos := 0;
  SwitchToForm(tiPartners, DM.qryPartner);
end;

// переход на форму отображения информации по выбранной ТТ
procedure TfrmMain.ShowPartnerInfo;
begin
  // показывать или нет закладку с заданиями
  if DM.LoadTasks(amOpen, true, 0, DM.qryPartnerId.AsInteger) > 0 then
    tiPartnerTasks.Visible := true
  else
    tiPartnerTasks.Visible := false;

  // общая информация о ТТ
  lPartnerName.Text := DM.qryPartnerName.AsString;
  lPartnerAddress.Text := DM.qryPartnerAddress.AsString;
  if (DM.qryPartnerGPSN.AsFloat <> 0) and (DM.qryPartnerGPSE.AsFloat <> 0) then
    lPartnerAddressGPS.Text := GetAddress(DM.qryPartnerGPSN.AsFloat, DM.qryPartnerGPSE.AsFloat)
  else
    lPartnerAddressGPS.Text := '-';

  lContractName.Text := DM.qryPartnerContractName.AsString;

  // информация о долгах ТТ
  if DM.qryPartnerPaidKindId.AsInteger = DM.tblObject_ConstPaidKindId_First.AsInteger then // БН
  begin
    lPartnerKind.Text := DM.tblObject_ConstPaidKindName_First.AsString;

    gbPartnerDebt.Text := 'Долги юр.лица по выбранному контракту';
    if not DM.qryPartnerDebtSumJ.IsNull then
      lPartnerDebt.Text := FormatFloat(',0.##', DM.qryPartnerDebtSumJ.AsFloat)
    else
      lPartnerDebt.Text := '-';
    if not DM.qryPartnerOverSumJ.IsNull then
      lPartnerOver.Text := FormatFloat(',0.##', DM.qryPartnerOverSumJ.AsFloat)
    else
      lPartnerOver.Text := '-';
    if not DM.qryPartnerOverDaysJ.IsNull then
      lPartnerOverDay.Text := DM.qryPartnerOverDaysJ.AsString
    else
      lPartnerOverDay.Text := '-';

    DM.qrySelect.Open('select SUM(DEBTSUM), SUM(OVERSUM), MAX(OVERDAYS) from OBJECT_JURIDICAL WHERE ID = ' + DM.qryPartnerJuridicalId.AsString + ' GROUP BY ID');

    gbPartnerAllDebt.Text := 'Долги юр.лица по всем контрактам';
    if not DM.qrySelect.Fields[0].IsNull then
      lPartnerAllDebt.Text := FormatFloat(',0.##', DM.qrySelect.Fields[0].AsFloat)
    else
      lPartnerAllDebt.Text := '-';
    if not DM.qrySelect.Fields[1].IsNull then
      lPartnerAllOver.Text := FormatFloat(',0.##', DM.qrySelect.Fields[1].AsFloat)
    else
      lPartnerAllOver.Text := '-';
    if not DM.qrySelect.Fields[2].IsNull then
      lPartnerAllOverDay.Text := DM.qrySelect.Fields[2].AsString
    else
      lPartnerAllOverDay.Text := '-';

    DM.qrySelect.Close;
  end
  else
  if DM.qryPartnerPaidKindId.AsInteger = DM.tblObject_ConstPaidKindId_Second.AsInteger then // Нал
  begin
    lPartnerKind.Text := DM.tblObject_ConstPaidKindName_Second.AsString;

    gbPartnerDebt.Text := 'Долги ТТ по выбранному контракту';
    lPartnerDebt.Text := FormatFloat(',0.##', DM.qryPartnerDebtSum.AsFloat);
    lPartnerOver.Text := FormatFloat(',0.##', DM.qryPartnerOverSum.AsFloat);
    lPartnerOverDay.Text := DM.qryPartnerOverDays.AsString;

    DM.qrySelect.Open('select SUM(DEBTSUM), SUM(OVERSUM), MAX(OVERDAYS) from OBJECT_PARTNER WHERE ID = ' + DM.qryPartnerId.AsString + ' GROUP BY ID');

    gbPartnerAllDebt.Text := 'Долги ТТ по всем контрактам';
    lPartnerAllDebt.Text := FormatFloat(',0.##', DM.qrySelect.Fields[0].AsFloat);
    lPartnerAllOver.Text := FormatFloat(',0.##', DM.qrySelect.Fields[1].AsFloat);
    lPartnerAllOverDay.Text := DM.qrySelect.Fields[2].AsString;

    DM.qrySelect.Close;
  end
  else  // нет договора
  begin
    lPartnerKind.Text := '-';
    lPartnerDebt.Text := '-';
    lPartnerOver.Text := '-';
    lPartnerOverDay.Text := '-';
  end;

  FEditDocuments := false;

  // остатки по ТТ
  DM.LoadStoreReals;

  // заявки на товары по ТТ
  DM.LoadOrderExternal;

  // возвраты по ТТ
  DM.LoadReturnIn;

  // приходы денег по ТТ
  DM.LoadCash;


  // фотографии ТТ
  DM.LoadPhotoGroups;

  SwitchToForm(tiPartnerInfo, nil);
  tcPartnerInfo.ActiveTab := tiInfo;
end;

procedure TfrmMain.ChangeStoreRealDoc;
var
  CurItem: TListViewItem;
begin
  CurItem := lwStoreRealDocs.Items[lwStoreRealDocs.Selected.Index];
  TListItemText(CurItem.Objects.FindDrawable('StatusId')).Text := DM.cdsStoreRealsStatusId.AsString;
  TListItemText(CurItem.Objects.FindDrawable('Status')).Text := DM.cdsStoreRealsStatus.AsString;

  ChangeStatusIcon(CurItem);
  DeleteButtonHide(CurItem);
end;

{ заполнение списка документов остатков }
procedure TfrmMain.BuildStoreRealDocsList;
var
  OldPartnerId: integer;
  NewItem: TListViewItem;
begin
  OldPartnerId := -1;

  lwStoreRealDocs.BeginUpdate;
  DM.cdsStoreReals.First;
  try
    lwStoreRealDocs.Items.Clear;

    while not DM.cdsStoreReals.Eof do
    begin
      if OldPartnerId <> DM.cdsStoreRealsPartnerId.AsInteger then
      begin
        NewItem := lwStoreRealDocs.Items.Add;
        NewItem.Text := DM.cdsStoreRealsPartnerName.AsString;
        NewItem.Detail := DM.cdsStoreRealsAddress.AsString;
        NewItem.Purpose := TListItemPurpose.Header;

        OldPartnerId := DM.cdsStoreRealsPartnerId.AsInteger;
      end;

      NewItem := lwStoreRealDocs.Items.Add;
      NewItem.Text := DM.cdsStoreRealsName.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Name')).Text := DM.cdsStoreRealsName.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Status')).Text := DM.cdsStoreRealsStatus.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Id')).Text := DM.cdsStoreRealsId.AsString;
      TListItemText(NewItem.Objects.FindDrawable('StatusId')).Text := DM.cdsStoreRealsStatusId.AsString;
      TListItemText(NewItem.Objects.FindDrawable('isSync')).Text := DM.cdsStoreRealsisSync.AsString;

      // установить иконку кнопки удаления
      TListItemImage(NewItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
      ChangeStatusIcon(NewItem);
      DeleteButtonHide(NewItem);

      DM.cdsStoreReals.Next;
    end;
  finally
    lwStoreRealDocs.EndUpdate;
  end;
end;

procedure TfrmMain.ChangeOrderExternalDoc;
var
  CurItem: TListViewItem;
begin
  CurItem := lwOrderDocs.Items[lwOrderDocs.Selected.Index];
  TListItemText(CurItem.Objects.FindDrawable('StatusId')).Text := DM.cdsOrderExternalStatusId.AsString;
  TListItemText(CurItem.Objects.FindDrawable('Status')).Text := DM.cdsOrderExternalStatus.AsString;
  TListItemText(CurItem.Objects.FindDrawable('Name')).Text := DM.cdsOrderExternalName.AsString;
  TListItemText(CurItem.Objects.FindDrawable('Price')).Text := DM.cdsOrderExternalPrice.AsString;
  TListItemText(CurItem.Objects.FindDrawable('Weight')).Text := DM.cdsOrderExternalWeight.AsString;

  ChangeStatusIcon(CurItem);
  DeleteButtonHide(CurItem);
end;

{ заполнение списка документов заявок на товары }
procedure TfrmMain.BuildOrderExternalDocsList;
var
  OldPartnerId, OldContractId: integer;
  NewItem: TListViewItem;
begin
  OldPartnerId := -1;
  OldContractId := -1;

  lwOrderDocs.BeginUpdate;
  DM.cdsOrderExternal.First;
  try
    lwOrderDocs.Items.Clear;

    while not DM.cdsOrderExternal.Eof do
    begin
      if (OldPartnerId <> DM.cdsOrderExternalPartnerId.AsInteger) or
         (OldContractId <> DM.cdsOrderExternalContractId.AsInteger) then
      begin
        NewItem := lwOrderDocs.Items.Add;
        NewItem.Text := DM.cdsOrderExternalPartnerName.AsString;
        NewItem.Detail := DM.cdsOrderExternalAddress.AsString + chr(13) + chr(10) +
          DM.cdsOrderExternalContractName.AsString;
        NewItem.Purpose := TListItemPurpose.Header;

        OldPartnerId := DM.cdsOrderExternalPartnerId.AsInteger;
        OldContractId := DM.cdsOrderExternalContractId.AsInteger;
      end;

      NewItem := lwOrderDocs.Items.Add;
      NewItem.Text := DM.cdsOrderExternalName.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Name')).Text := DM.cdsOrderExternalName.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Price')).Text := DM.cdsOrderExternalPrice.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Weight')).Text := DM.cdsOrderExternalWeight.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Status')).Text := DM.cdsOrderExternalStatus.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Id')).Text := DM.cdsOrderExternalId.AsString;
      TListItemText(NewItem.Objects.FindDrawable('StatusId')).Text := DM.cdsOrderExternalStatusId.AsString;
      TListItemText(NewItem.Objects.FindDrawable('isSync')).Text := DM.cdsOrderExternalisSync.AsString;

      // установить иконку кнопки удаления
      TListItemImage(NewItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
      ChangeStatusIcon(NewItem);
      DeleteButtonHide(NewItem);

      DM.cdsOrderExternal.Next;
    end;
  finally
    lwOrderDocs.EndUpdate;
  end;
end;

procedure TfrmMain.ChangeReturnInDoc;
var
  CurItem: TListViewItem;
begin
  CurItem := lwReturnInDocs.Items[lwReturnInDocs.Selected.Index];
  TListItemText(CurItem.Objects.FindDrawable('StatusId')).Text := DM.cdsReturnInStatusId.AsString;
  TListItemText(CurItem.Objects.FindDrawable('Status')).Text := DM.cdsReturnInStatus.AsString;
  TListItemText(CurItem.Objects.FindDrawable('Price')).Text := DM.cdsReturnInPrice.AsString;
  TListItemText(CurItem.Objects.FindDrawable('Weight')).Text := DM.cdsReturnInWeight.AsString;

  ChangeStatusIcon(CurItem);
  DeleteButtonHide(CurItem);
end;

{ заполнение списка документов возврата товаров }
procedure TfrmMain.BuildReturnInDocsList;
var
  OldPartnerId, OldContractId: integer;
  NewItem: TListViewItem;
begin
  OldPartnerId := -1;
  OldContractId := -1;

  lwReturnInDocs.BeginUpdate;
  DM.cdsReturnIn.First;
  try
    lwReturnInDocs.Items.Clear;

    while not DM.cdsReturnIn.Eof do
    begin
      if (OldPartnerId <> DM.cdsReturnInPartnerId.AsInteger) or
         (OldContractId <> DM.cdsReturnInContractId.AsInteger) then
      begin
        NewItem := lwReturnInDocs.Items.Add;
        NewItem.Text := DM.cdsReturnInPartnerName.AsString;
        NewItem.Detail := DM.cdsReturnInAddress.AsString + chr(13) + chr(10) +
          DM.cdsReturnInContractName.AsString;
        NewItem.Purpose := TListItemPurpose.Header;

        OldPartnerId := DM.cdsReturnInPartnerId.AsInteger;
        OldContractId := DM.cdsReturnInContractId.AsInteger;
      end;

      NewItem := lwReturnInDocs.Items.Add;
      NewItem.Text := DM.cdsReturnInName.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Id')).Text := DM.cdsReturnInId.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Name')).Text := DM.cdsReturnInName.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Price')).Text := DM.cdsReturnInPrice.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Weight')).Text := DM.cdsReturnInWeight.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Status')).Text := DM.cdsReturnInStatus.AsString;
      TListItemText(NewItem.Objects.FindDrawable('StatusId')).Text := DM.cdsReturnInStatusId.AsString;
      TListItemText(NewItem.Objects.FindDrawable('isSync')).Text := DM.cdsReturnInisSync.AsString;

      // установить иконку кнопки удаления
      TListItemImage(NewItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
      ChangeStatusIcon(NewItem);
      DeleteButtonHide(NewItem);

      DM.cdsReturnIn.Next;
    end;
  finally
    lwReturnInDocs.EndUpdate;
  end;
end;

procedure TfrmMain.ChangeCashDoc;
var
  CurItem: TListViewItem;
begin
  CurItem := lwCashDocs.Items[lwCashDocs.Selected.Index];
  TListItemText(CurItem.Objects.FindDrawable('StatusId')).Text := DM.qryCashStatusId.AsString;
  TListItemText(CurItem.Objects.FindDrawable('Status')).Text := DM.qryCashStatus.AsString;
  TListItemText(CurItem.Objects.FindDrawable('Amount')).Text := DM.qryCashAmountShow.AsString;

  ChangeStatusIcon(CurItem);
  DeleteButtonHide(CurItem);
end;

{ заполнение списка документов оплат за товары }
procedure TfrmMain.BuildCashDocsList;
var
  OldPartnerId, OldContractId: integer;
  NewItem: TListViewItem;
begin
  OldPartnerId := -1;
  OldContractId := -1;

  lwCashDocs.BeginUpdate;
  DM.qryCash.First;
  try
    lwCashDocs.Items.Clear;

    while not DM.qryCash.Eof do
    begin
      if (OldPartnerId <> DM.qryCashPartnerId.AsInteger) or
         (OldContractId <> DM.qryCashContractId.AsInteger) then
      begin
        NewItem := lwCashDocs.Items.Add;
        NewItem.Text := DM.qryCashPartnerName.AsString;
        NewItem.Detail := DM.qryCashAddress.AsString + chr(13) + chr(10) +
          DM.qryCashContractName.AsString;
        NewItem.Purpose := TListItemPurpose.Header;

        OldPartnerId := DM.qryCashPartnerId.AsInteger;
        OldContractId := DM.qryCashContractId.AsInteger;
      end;

      NewItem := lwCashDocs.Items.Add;
      NewItem.Text := DM.qryCashName.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Name')).Text := DM.qryCashName.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Amount')).Text := DM.qryCashAmountShow.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Status')).Text := DM.qryCashStatus.AsString;
      TListItemText(NewItem.Objects.FindDrawable('Id')).Text := DM.qryCashId.AsString;
      TListItemText(NewItem.Objects.FindDrawable('StatusId')).Text := DM.qryCashStatusId.AsString;
      TListItemText(NewItem.Objects.FindDrawable('isSync')).Text := DM.qryCashisSync.AsString;

      // установить иконку кнопки удаления
      TListItemImage(NewItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;
      ChangeStatusIcon(NewItem);
      DeleteButtonHide(NewItem);

      DM.qryCash.Next;
    end;
  finally
    lwCashDocs.EndUpdate;
  end;
end;

// переход на форму отображения документов
procedure TfrmMain.ShowDocuments;
begin
  FEditDocuments := true;

  deStartDoc.Date := Date();
  deEndDoc.Date := Date();

  bRefreshDocClick(bRefreshDoc);

  SwitchToForm(tiDocuments, nil);
  tcDocuments.ActiveTab := tiStoreRealDocs;
end;

// начитка и отображение прайс-листов
procedure TfrmMain.ShowPriceLists;
begin
  DM.qryPriceList.Open('select ID, VALUEDATA, PRICEWITHVAT, VATPERCENT from OBJECT_PRICELIST where ISERASED = 0');

  lwPriceList.ScrollViewPos := 0;
  SwitchToForm(tiPriceList, DM.qryPriceList);
end;

// начитка и отображение товаров по выбраному працс-листу
procedure TfrmMain.ShowPriceListItems;
begin
  lCaption.Text := 'Прайс-лист "' + DM.qryPriceListValueData.AsString + '"';
//or
//  DM.qryGoodsForPriceList.Open('select G.ID, G.OBJECTCODE, G.VALUEDATA GoodsName, GK.VALUEDATA KindName, ' +
//    'PLI.ORDERPRICE Price, M.VALUEDATA Measure, PLI.ORDERSTARTDATE StartDate, T.VALUEDATA TradeMarkName ' +
//    'FROM OBJECT_PRICELISTITEMS PLI ' +
//    'JOIN OBJECT_GOODS G ON G.ID = PLI.GOODSID AND G.ISERASED = 0 ' +
//    'LEFT JOIN OBJECT_GOODSBYGOODSKIND GLK ON GLK.GOODSID = G.ID ' +
//    'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = GLK.GOODSKINDID ' +
//    'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
//    'LEFT JOIN OBJECT_TRADEMARK T ON T.ID = G.TRADEMARKID ' +
//    'WHERE PLI.PRICELISTID = ' + DM.qryPriceListId.AsString + ' ORDER BY G.VALUEDATA');
//or


  DM.qryGoodsForPriceList.Open(
      'select '
    + '   Object_Goods.ID'
    + ' , Object_Goods.ObjectCode'
    + ' , Object_Goods.ValueData AS GoodsName'
    + ' , Object_GoodsKind.ValueData AS KindName'
    + ' , Object_PriceListItems.OrderPrice AS Price'
    + ' , Object_Measure.ValueData AS Measure'
    + ' , Object_PriceListItems.OrderStartDate AS StartDate'
    + ' , Object_TradeMark.ValueData AS TradeMarkName'
    + 'FROM Object_PriceListItems'
    + '    JOIN Object_Goods ON Object_Goods.ID = Object_PriceListItems.GoodsId'
    + '                     AND Object_Goods.isErased = 0'
    + '    LEFT JOIN Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.GoodsId = Object_Goods.ID'
    + '    LEFT JOIN Object_GoodsKind ON Object_GoodsKind.ID = Object_GoodsByGoodsKind.GoodsKindId'
    + '    LEFT JOIN Object_Measure ON Object_Measure.ID = Object_Goods.MeasureId'
    + '    LEFT JOIN Object_TradeMark ON Object_TradeMark.ID = Object_Goods.TradeMarkId'
    + 'WHERE Object_PriceListItems.PriceListId = ' + DM.qryPriceListId.AsString
    + 'ORDER BY Object_Goods.ValueData'
    );

  lwPriceListGoods.ScrollViewPos := 0;
  SwitchToForm(tiPriceListItems, DM.qryGoodsForPriceList);
end;

// начитка и отображение ТТ, участвующих в акциях
procedure TfrmMain.ShowPromoPartners;
begin
  pPromoPartnerDate.Visible := true;
  dePromoPartnerDate.Date := Date();
  dePromoPartnerDateChange(dePromoPartnerDate);

  SwitchToForm(tiPromoPartners, DM.qryPromoPartners);
end;

// начитка и отображение акционных товаров в выбраной ТТ
procedure TfrmMain.ShowPromoGoodsByPartner;
begin
  lCaption.Text := 'Акционные товары для ' + DM.qryPromoPartnersPartnerName.AsString;
  pPromoGoodsDate.Visible := false;
//or
//  DM.qryPromoGoods.SQL.Text := 'select G.OBJECTCODE, G.VALUEDATA GoodsName, T.VALUEDATA TradeMarkName, ' +
//    'CASE WHEN PG.GOODSKINDID = 0 THEN ''все виды'' ELSE GK.VALUEDATA END KindName, ' +
//    '''Скидка '' || PG.TAXPROMO || ''%'' Tax, ' +
//    '''Акционная цена: '' || PG.PRICEWITHOUTVAT || '' (с НДС '' || PG.PRICEWITHVAT || '') за '' || M.VALUEDATA Price, ' +
//    '''Акция заканчивается '' || strftime(''%d.%m.%Y'',P.ENDSALE) Termin, P.ID PromoId ' +
//    'from MOVEMENTITEM_PROMOGOODS PG ' +
//    'JOIN MOVEMENT_PROMO P ON P.ID = PG.MOVEMENTID ' +
//    'LEFT JOIN OBJECT_GOODS G ON G.ID = PG.GOODSID ' +
//    'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
//    'LEFT JOIN OBJECT_TRADEMARK T ON T.ID = G.TRADEMARKID ' +
//    'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = PG.GOODSKINDID ' +
//    'WHERE PG.MOVEMENTID IN (' + DM.qryPromoPartnersPromoIds.AsString + ') ' +
//    'ORDER BY G.VALUEDATA, P.ENDSALE';
//or


  DM.qryPromoGoods.SQL.Text :=
      'select '
    + '   Object_Goods.ObjectCode'
    + ' , Object_Goods.ValueData AS GoodsName'
    + ' , Object_TradeMark.ValueData AS TradeMarkName'
    + ' , CASE WHEN MovementItem_PromoGoods.GoodsKindId = 0 THEN ''все виды'' ELSE Object_GoodsKind.ValueData END AS KindName'
    + ' , ''Скидка '' || MovementItem_PromoGoods.TaxPromo || ''%'' AS Tax'
    + ' , ''Акционная цена: '' || MovementItem_PromoGoods.PriceWithOutVAT || '' (с НДС '' || MovementItem_PromoGoods.PriceWithVAT || '') за '' || Object_Measure.ValueData AS Price'
    + ' , ''Акция заканчивается '' || strftime(''%d.%m.%Y'', Movement_Promo.EndSale) AS Termin'
    + ' , Movement_Promo.Id AS PromoId'
    + 'from'
    + '         MovementItem_PromoGoods'
    + '    JOIN Movement_Promo ON Movement_Promo.Id = MovementItem_PromoGoods.MovementId'
    + '    LEFT JOIN Object_Goods ON Object_Goods.Id = MovementItem_PromoGoods.GoodsId'
    + '    LEFT JOIN Object_Measure ON Object_Measure.Id = Object_Goods.MeasureId'
    + '    LEFT JOIN Object_TradeMark ON Object_TradeMark.Id = Object_Goods.TradeMarkId'
    + '    LEFT JOIN Object_GoodsKind ON Object_GoodsKind.Id = MovementItem_PromoGoods.GoodsKindId'
    + 'WHERE MovementItem_PromoGoods.MovementId IN (' + DM.qryPromoPartnersPromoIds.AsString + ')'
    + 'ORDER BY Object_Goods.ValueData, Movement_Promo.EndSale';
  DM.qryPromoGoods.Open;

  lwPromoGoods.ScrollViewPos := 0;
  SwitchToForm(tiPromoGoods, DM.qryPromoGoods);
end;

// начитка и отображение всех акционных товаров
procedure TfrmMain.ShowPromoGoods;
begin
  pPromoGoodsDate.Visible := true;
  dePromoGoodsDate.Date := Date();
  dePromoGoodsDateChange(dePromoGoodsDate);

  SwitchToForm(tiPromoGoods, DM.qryPromoGoods);
end;

// начитка и отображение ТТ, в кторых продается выбранный акционный товар
procedure TfrmMain.ShowPromoPartnersByGoods;
begin
  lCaption.Text := 'ТТ с акционными "' + DM.qryPromoGoodsGoodsName.AsString + '"';
  pPromoPartnerDate.Visible := false;

  DM.qryPromoPartners.SQL.Text := 'select J.VALUEDATA PartnerName, OP.ADDRESS, ' +
    'CASE WHEN PP.CONTRACTID = 0 THEN ''все договора'' ELSE C.CONTRACTTAGNAME || '' '' || C.VALUEDATA END ContractName, ' +
    'PP.PARTNERID, PP.CONTRACTID, group_concat(distinct PP.MOVEMENTID) PromoIds ' +
    'from MOVEMENTITEM_PROMOPARTNER PP ' +
    'LEFT JOIN OBJECT_PARTNER OP ON OP.ID = PP.PARTNERID AND (OP.CONTRACTID = PP.CONTRACTID OR PP.CONTRACTID = 0) ' +
    'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = OP.JURIDICALID AND J.CONTRACTID = OP.CONTRACTID ' +
    'LEFT JOIN OBJECT_CONTRACT C ON C.ID = PP.CONTRACTID ' +
    'WHERE PP.MOVEMENTID = :PROMOID ' +
    'GROUP BY PP.PARTNERID, PP.CONTRACTID ' +
    'ORDER BY J.VALUEDATA, OP.ADDRESS';
  DM.qryPromoPartners.ParamByName('PROMOID').AsInteger := DM.qryPromoGoodsPromoId.AsInteger;
  DM.qryPromoPartners.Open;

  lwPromoPartners.ScrollViewPos := 0;
  SwitchToForm(tiPromoPartners, DM.qryPromoPartners);
end;

// отображение маршрута контрагента
procedure TfrmMain.ShowPathOnmap;
begin
  deDatePath.Date := Date();

  SwitchToForm(tiPathOnMap, nil);

  bRefreshPathOnMapClick(nil);
end;

// начитка фотографий выбранной группы
procedure TfrmMain.ShowPhotos(GroupId: integer);
begin
  DM.qryPhotos.Open('select Id, Photo, Comment, isErased, isSync from MovementItem_Visit where MovementId = ' + IntToStr(GroupId) +
    ' and isErased = 0');

  pAddPhoto.Visible := not FEditDocuments;

  SwitchToForm(tiPhotosList, DM.qryPhotos);
end;

// отображение выбраной фотографии
procedure TfrmMain.ShowPhoto;
var
  BlobStream: TStream;
begin
  ePhotoCommentEdit.Text := DM.qryPhotosComment.AsString;

  BlobStream := DM.qryPhotos.CreateBlobStream(DM.qryPhotosPhoto, TBlobStreamMode.bmRead);
  try
    imPhoto.Bitmap.LoadFromStream(BlobStream);
  finally
    BlobStream.Free;
  end;

  SwitchToForm(tiPhotoEdit, nil);
end;

// начитка информации про программу
procedure TfrmMain.ShowInformation;
var
  Res : integer;
begin
  eMobileVersion.Text := DM.GetCurrentVersion;

  Res := DM.CompareVersion(eMobileVersion.Text, DM.tblObject_ConstMobileVersion.AsString);
  if Res > 0 then
  begin
    lServerVersion.Height := 60;
    eServerVersion.Text := DM.tblObject_ConstMobileVersion.AsString;

    {$IFDEF ANDROID}
    bUpdateProgram.Visible := true
    {$ELSE}
    bUpdateProgram.Visible := false;
    {$ENDIF}
  end
  else
    lServerVersion.Height := 0;

  eUnitName.Text := DM.tblObject_ConstUnitName.AsString;
  UnitNameRet.Text := DM.tblObject_ConstUnitName_ret.AsString;
  eCashName.Text := DM.tblObject_ConstCashName.AsString;
  eMemberName.Text := DM.tblObject_ConstMemberName.AsString;
  eWebService.Text := DM.tblObject_ConstWebService.AsString;
  if not SameText(gc_WebService, DM.tblObject_ConstWebService.AsString) then
  begin
    lCurWebService.Height := 60;
    eCurWebService.Text := gc_WebService;
  end
  else
    lCurWebService.Height := 0;
  eSyncDateIn.Text := FormatDateTime('DD.MM.YYYY hh:nn:ss', DM.tblObject_ConstSyncDateIn.AsDateTime);
  SyncDateOut.Text := FormatDateTime('DD.MM.YYYY hh:nn:ss', DM.tblObject_ConstSyncDateOut.AsDateTime);

  SwitchToForm(tiInformation, nil);
end;

// начитка и отображение заданий контрагента
procedure TfrmMain.ShowTasks(ShowAll: boolean = true);
begin
  if ShowAll then
    rbAllTask.IsChecked := true
  else
    rbOpenTask.IsChecked := true;
  cbUseDateTask.IsChecked := false;
  deDateTask.Enabled := false;
  deDateTask.Date := Date();

  bRefreshTasksClick(bRefreshTasks);

  SwitchToForm(tiTasks, nil);
end;

// добавление новых товаров в "остатки"
procedure TfrmMain.AddedNewStoreRealItems;
var
  i: integer;
begin
  for i := 0 to FCheckedGooodsItems.Count - 1 do
    DM.AddedGoodsToStoreReal(FCheckedGooodsItems[i]);

  FCheckedGooodsItems.Clear;
end;

// добавление новых товаров в завку на товары
procedure TfrmMain.AddedNewOrderItems;
var
  i: integer;
begin
  for i := 0 to FCheckedGooodsItems.Count - 1 do
    DM.AddedGoodsToOrderExternal(FCheckedGooodsItems[i]);

  RecalculateTotalPriceAndWeight;

  FCheckedGooodsItems.Clear;
end;

// добавление новых товаров для возврата
procedure TfrmMain.AddedNewReturnInItems;
var
  i: integer;
begin
  for i := 0 to FCheckedGooodsItems.Count - 1 do
    DM.AddedGoodsToReturnIn(FCheckedGooodsItems[i]);

  RecalculateReturnInTotalPriceAndWeight;

  FCheckedGooodsItems.Clear;
end;

// пересчет общей цены и веса выбранных товаров для заявки
procedure TfrmMain.RecalculateTotalPriceAndWeight;
var
 TotalPriceWithPercent, PriceWithPercent : Currency;
 b : TBookmark;
begin
  TotalPriceWithPercent := 0;
  FOrderTotalPrice := 0;
  FOrderTotalCountKg := 0;

  DM.cdsOrderItems.DisableControls;
  b := DM.cdsOrderItems.Bookmark;
  try
    DM.cdsOrderItems.First;
    while not DM.cdsOrderItems.Eof do
    begin
      if DM.cdsOrderItemsisChangePercent.AsBoolean then
        PriceWithPercent := DM.cdsOrderItemsPrice.AsFloat * DM.cdsOrderItemsCount.AsFloat *
          (100 + DM.cdsOrderExternalChangePercent.AsCurrency) / 100
      else
        PriceWithPercent := DM.cdsOrderItemsPrice.AsFloat * DM.cdsOrderItemsCount.AsFloat;

      TotalPriceWithPercent := TotalPriceWithPercent + PriceWithPercent;

      if DM.cdsOrderExternalPriceWithVAT.AsBoolean then
        FOrderTotalPrice := FOrderTotalPrice + PriceWithPercent
      else
        FOrderTotalPrice := FOrderTotalPrice + PriceWithPercent * (100 + DM.cdsOrderExternalVATPercent.AsCurrency) / 100;

      if FormatFloat('0.##', DM.cdsOrderItemsWeight.AsFloat) <> '0' then
        FOrderTotalCountKg := FOrderTotalCountKg + DM.cdsOrderItemsWeight.AsFloat * DM.cdsOrderItemsCount.AsFloat
      else
        FOrderTotalCountKg := FOrderTotalCountKg + DM.cdsOrderItemsCount.AsFloat;

      DM.cdsOrderItems.Next;
    end;
  finally
    DM.cdsOrderItems.GotoBookmark(b);
    DM.cdsOrderItems.EnableControls;
  end;

  if DM.cdsOrderExternalChangePercent.AsCurrency = 0 then
  begin
    lPriceWithPercent.Visible := false;
    pOrderTotals.Height := 50;
  end
  else
  begin
    lPriceWithPercent.Visible := true;
    pOrderTotals.Height := 70;

    if DM.cdsOrderExternalChangePercent.AsCurrency > 0 then
      lPriceWithPercent.Text := ' Стоимость с учетом наценки (' +
        FormatFloat(',0.00', DM.cdsOrderExternalChangePercent.AsCurrency) + '%) : ' + FormatFloat(',0.00', TotalPriceWithPercent)
    else
      lPriceWithPercent.Text := ' Стоимость с учетом скидки (' +
        FormatFloat(',0.00', -DM.cdsOrderExternalChangePercent.AsCurrency) + '%) : ' + FormatFloat(',0.00', TotalPriceWithPercent);
  end;

  lTotalPrice.Text := 'Общая стоимость (с учетом НДС) : ' + FormatFloat(',0.00', FOrderTotalPrice);

  lTotalWeight.Text := 'Общий вес : ' + FormatFloat(',0.00', FOrderTotalCountKg);
end;

// пересчет общей цены и веса для выбранных товаров для возврата
procedure TfrmMain.RecalculateReturnInTotalPriceAndWeight;
var
 TotalPriceWithPercent, PriceWithPercent : Currency;
 b : TBookmark;
begin
  TotalPriceWithPercent := 0;
  FReturnInTotalPrice := 0;
  FReturnInTotalCountKg := 0;

  DM.cdsReturnInItems.DisableControls;
  b := DM.cdsReturnInItems.Bookmark;
  try
    DM.cdsReturnInItems.First;
    while not DM.cdsReturnInItems.Eof do
    begin
      PriceWithPercent := DM.cdsReturnInItemsPrice.AsFloat * DM.cdsReturnInItemsCount.AsFloat *
        (100 + DM.cdsReturnInChangePercent.AsCurrency) / 100;

      TotalPriceWithPercent := TotalPriceWithPercent + PriceWithPercent;

      if DM.cdsReturnInPriceWithVAT.AsBoolean then
        FReturnInTotalPrice := FReturnInTotalPrice + PriceWithPercent
      else
        FReturnInTotalPrice := FReturnInTotalPrice + PriceWithPercent * (100 + DM.cdsReturnInVATPercent.AsCurrency) / 100;

      if FormatFloat('0.##', DM.cdsReturnInItemsWeight.AsFloat) <> '0' then
        FReturnInTotalCountKg := FReturnInTotalCountKg + DM.cdsReturnInItemsWeight.AsFloat * DM.cdsReturnInItemsCount.AsFloat
      else
        FReturnInTotalCountKg := FReturnInTotalCountKg + DM.cdsReturnInItemsCount.AsFloat;

      DM.cdsReturnInItems.Next;
    end;
  finally
    DM.cdsReturnInItems.GotoBookmark(b);
    DM.cdsReturnInItems.EnableControls;
  end;

  if DM.cdsReturnInChangePercent.AsCurrency = 0 then
  begin
    lPriceWithPercentReturn.Visible := false;
    pReturnInTotals.Height := 50;
  end
  else
  begin
    lPriceWithPercentReturn.Visible := true;
    pReturnInTotals.Height := 70;

    if DM.cdsReturnInChangePercent.AsCurrency > 0 then
      lPriceWithPercentReturn.Text := ' Стоимость с учетом наценки (' +
        FormatFloat(',0.00', DM.cdsReturnInChangePercent.AsCurrency) + '%) : ' + FormatFloat(',0.00', TotalPriceWithPercent)
    else
      lPriceWithPercentReturn.Text := ' Стоимость с учетом скидки (' +
        FormatFloat(',0.00', -DM.cdsReturnInChangePercent.AsCurrency) + '%) : ' + FormatFloat(',0.00', TotalPriceWithPercent);
  end;

  lTotalPriceReturn.Text := 'Общая стоимость (с учетом НДС) : ' + FormatFloat(',0.00', FReturnInTotalPrice);

  lTotalWeightReturn.Text := 'Общий вес : ' + FormatFloat(',0.00', FReturnInTotalCountKg);
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
  if tcMain.ActiveTab = tiOrderExternal then
  begin
    DM.cdsOrderItems.EmptyDataSet;
    DM.cdsOrderItems.Close;
  end;

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

      try
        if Item.Data <> nil then
          TFDQuery(Item.Data).Close;
      except
      end;
    end
  else
    raise Exception.Create('Forms stack underflow');
end;

// переход на формцу фотографирования с созданием компонента для фотографирования
procedure TfrmMain.PrepareCamera;
begin
  SwitchToForm(tiCamera, nil);

  FCameraZoomDistance := 0;

  try
    CameraComponent := TCameraComponent.Create(nil);
    CameraComponent.OnSampleBufferReady := CameraComponentSampleBufferReady;
    if CameraComponent.HasFlash then
      CameraComponent.FlashMode := FMX.Media.TFlashMode.AutoFlash;
    CameraComponent.Active := false;
    bCaptureClick(bCapture);
  except
    CameraFree;
    ShowMessage('Ошибка инициализации камеры. Повторите попытку');
  end;
end;

// освобождение компонента для фотографирования
procedure TfrmMain.CameraFree;
begin
  try
    if Assigned(CameraComponent) then
    begin
      CameraComponent.Active := False;
      FreeAndNil(CameraComponent);
    end;
  except
    On E: Exception do
      Showmessage(E.Message);
  end;
end;

// показывать только акционные товары
procedure TfrmMain.cbOnlyPromoChange(Sender: TObject);
var
  i : integer;
  oldValue : string;
begin
  for I := 0 to lwGoodsItems.Controls.Count-1 do
    if lwGoodsItems.Controls[I].ClassType = TSearchBox then
    begin
      oldValue := TSearchBox(lwGoodsItems.Controls[I]).Text;
      TSearchBox(lwGoodsItems.Controls[I]).Text := '!';
      TSearchBox(lwGoodsItems.Controls[I]).Text := oldValue;
    end;
end;

// перключатель между вводом нового юр.лица и выбором из уже существующих
procedure TfrmMain.cSelectJuridicalChange(Sender: TObject);
begin
  if cSelectJuridical.IsChecked then
  begin
    eNewPartnerJuridical.Visible := false;
    cbNewPartnerJuridical.Visible := true;
  end
  else
  begin
    cbNewPartnerJuridical.Visible := false;
    eNewPartnerJuridical.Visible := true;
  end;
end;

// изменение юридического лица с начиткой ТТ и договор для нового выбраного юр.лица
procedure TfrmMain.cbJuridicalsChange(Sender: TObject);
var
  i: integer;
begin
  if cbJuridicals.Items.Count > 0 then
  begin

    with DM.qrySelect do
    begin
      cbPartners.Items.Clear;
      FPartnerList.Clear;

      AddComboItem(cbPartners, 'все');
      FPartnerList.Add(TPartnerItem.Create(0, ''));

      Open('select P.ID, P.ADDRESS, group_concat(distinct C.ID) ContractIds from OBJECT_PARTNER P ' +
           'LEFT JOIN OBJECT_CONTRACT C ON C.ID = P.CONTRACTID ' +
           'WHERE P.JURIDICALID = ' + IntToStr(FJuridicalList[cbJuridicals.ItemIndex].Id) +
           ' AND P.ISERASED = 0 GROUP BY ADDRESS');

      First;
      while not Eof do
      begin
        AddComboItem(cbPartners, FieldByName('ADDRESS').AsString);
        FPartnerList.Add(TPartnerItem.Create(FieldByName('Id').AsInteger, FieldByName('ContractIds').AsString));

        Next;
      end;

      // все договора юридического лица
      FAllContractList.Clear;

      Open('select distinct ID, CONTRACTTAGNAME || '' '' || VALUEDATA ContractName from OBJECT_CONTRACT ' +
        'where ID in (' + FJuridicalList[cbJuridicals.ItemIndex].ContractIds + ')');

      First;
      while not Eof do
      begin
        FAllContractList.Add(TContractItem.Create(FieldByName('Id').AsInteger, FieldByName('ContractName').AsString));

        Next;
      end;

      Close;
    end;

    if FFirstSet then
      for i := 0 to FPartnerList.Count - 1 do
        if FPartnerList[i].Id = FPartnerRJC then
        begin
          cbPartners.ItemIndex := i;
        end;
    if cbPartners.ItemIndex < 0 then
      cbPartners.ItemIndex := 0;
  end;
end;

// изменение ТТ с фильтрацией договоров юр.лица только выбраной ТТ
procedure TfrmMain.cbPartnersChange(Sender: TObject);
var
  i: integer;
  OldContractId, DefIndex: integer;
begin
  if cbPartners.Items.Count > 0 then
  begin
    DefIndex := 0;
    OldContractId := -1;
    if cbContracts.ItemIndex > 0 then
      OldContractId := FContractIdList[cbContracts.ItemIndex];

    cbContracts.Items.Clear;
    FContractIdList.Clear;

    AddComboItem(cbContracts, 'все');
    FContractIdList.Add(0);

    for i := 0 to FAllContractList.Count - 1 do
    begin
      if (cbPartners.ItemIndex <= 0) or
         (pos(IntToStr(FAllContractList[i].Id) + ',', FPartnerList[cbPartners.ItemIndex].ContractIds) > 0) or
         (pos(',' + IntToStr(FAllContractList[i].Id), FPartnerList[cbPartners.ItemIndex].ContractIds) > 0) then
      begin
        AddComboItem(cbContracts, FAllContractList[i].Name);
        FContractIdList.Add(FAllContractList[i].Id);
        if FAllContractList[i].Id = OldContractId then
          DefIndex := FContractIdList.Count - 1;
      end;
    end;

    if FFirstSet then
      cbContracts.ItemIndex := FContractIdList.IndexOf(FContractRJC);

    if cbContracts.ItemIndex < 0 then
      cbContracts.ItemIndex := DefIndex;
  end;
end;

// отображать маршрут контрагента за все время или за конкретную дату
procedure TfrmMain.cbShowAllPathChange(Sender: TObject);
begin
  deDatePath.Enabled := not cbShowAllPath.IsChecked;
end;

// отображать задания контрагента за все время или за конкретную дату
procedure TfrmMain.cbUseDateTaskChange(Sender: TObject);
begin
  deDateTask.Enabled := cbUseDateTask.IsChecked;
end;

// сохранение фотографии из "компонента камеры" в Image
procedure TfrmMain.GetImage;
begin
  CameraComponent.SampleBufferToBitmap(imgCameraPreview.Bitmap, True);
end;

procedure TfrmMain.ScaleImage(const Margins: Integer);
begin
  imgCameraPreview.Margins.Left := 5 + Margins;
  imgCameraPreview.Margins.Right := 5 + Margins;
  imgCameraPreview.Margins.Top := 5 + Margins;
  imgCameraPreview.Margins.Bottom := 5 + Margins;
end;

// звук фотографирования
procedure TfrmMain.PlayAudio;
var
  MediaPlayer: TMediaPlayer;
  TmpFile: string;
begin
  MediaPlayer := TMediaPlayer.Create(nil);
  try
    TmpFile := TPath.Combine(TPath.GetDocumentsPath, 'CameraClick.mp3');
    if FileExists(TmpFile) then
    begin
      MediaPlayer.FileName := TmpFile;
      if MediaPlayer.Media <> nil then
      begin
        MediaPlayer.Play;
        sleep(1000);
        MediaPlayer.Stop;
      end;
    end;
  except
  end;
end;

procedure TfrmMain.CameraComponentSampleBufferReady
  (Sender: TObject; const ATime: TMediaTime);
begin
  TThread.Synchronize(TThread.CurrentThread, GetImage);
  if (imgCameraPreview.Width = 0) or (imgCameraPreview.Height = 0) then
    Showmessage('Image is zero!');
end;

// получение текущих координат
procedure TfrmMain.GetCurrentCoordinates;
{$IFDEF ANDROID}
var
  LastLocation: JLocation;
  LocManagerObj: JObject;
  LocationManager: JLocationManager;
{$ENDIF}
begin
  FCurCoordinatesSet := false;

  {$IFDEF ANDROID}
  try
    //запрашиваем сервис Location
    LocManagerObj := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.LOCATION_SERVICE);
    if Assigned(LocManagerObj) then
    begin
      //получаем LocationManager
      LocationManager := TJLocationManager.Wrap((LocManagerObj as ILocalObject).GetObjectID);
      if Assigned(LocationManager) then
      begin
        //получаем последнее местоположение зафиксированное с помощью координат wi-fi и мобильных сетей
        LastLocation := LocationManager.getLastKnownLocation(TJLocationManager.JavaClass.NETWORK_PROVIDER);
        if Assigned(LastLocation) then
        begin
          FCurCoordinates := TLocationCoord2D.Create(LastLocation.getLatitude, LastLocation.getLongitude);
          FCurCoordinatesSet := true;
        end;
      end
      else
      begin
        //raise Exception.Create('Could not access Location Manager');
      end;
    end
    else
    begin
      //raise Exception.Create('Could not locate Location Service');
    end;
  except
  end;
  {$ENDIF}
end;

// добавление елемента в combobox
procedure TfrmMain.AddComboItem(AComboBox: TComboBox; AText: string);
var
  lbi: TListBoxItem;
begin
  lbi := TListBoxItem.Create(AComboBox);
  lbi.Parent := AComboBox;
  lbi.Text := AText;
  lbi.Font.Size := DefaultSize;
  lbi.StyledSettings := lbi.StyledSettings - [TStyledSetting.Size];

  AComboBox.AddObject(lbi);
end;

end.
