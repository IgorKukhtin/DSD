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
  FMX.Platform, System.Math.Vectors, FMX.ListBox,
  FMX.DateTimeCtrls, FMX.Controls3D, FMX.Layers3D, FMX.Menus, Generics.Collections,
  FMX.Gestures, System.Actions, FMX.ActnList, System.ImageList, FMX.ImgList,
  FMX.Grid.Style, FMX.Media, FMX.Surfaces, FMX.VirtualKeyboard, FMX.SearchBox, IniFiles,
  FMX.Ani, FMX.DialogService, FMX.Utils, FMX.Styles, FMX.ComboEdit, DateUtils
  {$IFDEF ANDROID}
  ,System.Permissions,Androidapi.JNI.Os,
  FMX.Helpers.Android, Androidapi.Helpers,
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

  sContract = 'Договор %s - %s';
  sPriceWithVAT = 'Цены с НДС';
  sPriceWithoutVAT = 'Цены без НДС';
  sCostWithExtraCharge = 'Стоимость с наценкой';
  sCostWithDiscount = 'Стоимость со скидкой';
  sTotalCostWithVAT = 'Общая стоимость (с НДС)';
  sTotalWeight = 'Общий вес';
  sPaidKindChangeQuestion = 'Изменить форму оплаты на "%s"?';
  sPaidKindRepeatQuestion = 'Форма оплаты будет "%s". Продолжить?';

type
  TFormStackItem = record
    PageIndex: Integer;
    Data: TObject;
  end;

  TListType = (ltJuridicals, ltPartners);

  TJuridicalItem = record
    Id: Integer;
    Name: string;
    ContractIds: string;

    constructor Create(AId: Integer; AName: string; AContractIds: string);
  end;

  TContractItem = record
    Id: Integer;
    Name: string;

    constructor Create(AId: Integer; AName: string);
  end;

  TPartnerItem = record
    Id: Integer;
    Name: string;
    ContractIds: string;

    constructor Create(AId: integer; AName: string; AContractIds: string);
  end;

  TLocationData = record
    Latitude: TLocationDegrees;
    Longitude: TLocationDegrees;
    Address: string;
    VisitTime: TDateTime;

    constructor Create(ALatitude, ALongitude: TLocationDegrees; AVisitTime: TDateTime; AAddress: string);
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
    WebServerLayout11: TLayout;
    WebServerLabel: TLabel;
    WebServerLayout12: TLayout;
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
    bMinusAmount: TButton;
    VertScrollBox4: TVertScrollBox;
    Label19: TLabel;
    Label28: TLabel;
    lPartnerAddress: TLabel;
    lPartnerName: TLabel;
    lwOrderExternalList: TListView;
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
    bsPhotos: TBindSourceDB;
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
    bAddStoreRealItem: TButton;
    Image14: TImage;
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
    Panel26: TPanel;
    Label20: TLabel;
    eReturnComment: TEdit;
    bsReturnIn: TBindSourceDB;
    bSyncData: TButton;
    pProgress: TPanel;
    Layout6: TLayout;
    pieProgress: TPie;
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
    eSyncDateOut: TEdit;
    bsStoreRealItems: TBindSourceDB;
    bsOrderExternalItems: TBindSourceDB;
    bsReturnInItems: TBindSourceDB;
    bsGoodsItems: TBindSourceDB;
    bsPriceListGoods: TBindSourceDB;
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
    bsPromoGoods: TBindSourceDB;
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
    Layout14: TLayout;
    Label46: TLabel;
    cbContracts: TComboBox;
    Panel30: TPanel;
    bPrintJuridicalCollation: TButton;
    tiPrintJuridicalCollation: TTabItem;
    lwJuridicalCollation: TListView;
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
    lServerVersion: TLayout;
    Label48: TLabel;
    eServerVersion: TEdit;
    bUpdateProgram: TButton;
    Layout16: TLayout;
    Layout17: TLayout;
    Layout18: TLayout;
    Layout19: TLayout;
    Layout20: TLayout;
    Label50: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    Label51: TLabel;
    Label52: TLabel;
    bsJuridicalCollationDocItems: TBindSourceDB;
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
    lOperDateOrder: TLabel;
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
    Layout35: TLayout;
    Label78: TLabel;
    lPartnerAddressGPS: TLabel;
    tiPhotoDocs: TTabItem;
    lwPhotoDocs: TListView;
    bshotoGroupDocs: TBindSourceDB;
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
    pAdminPassword: TPanel;
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
    Panel38: TPanel;
    Panel39: TPanel;
    Label86: TLabel;
    Label87: TLabel;
    Panel40: TPanel;
    eCashComment: TEdit;
    bsCash: TBindSourceDB;
    tiCashDocs: TTabItem;
    lwCashDocs: TListView;
    Panel42: TPanel;
    Label85: TLabel;
    deCashDate: TDateEdit;
    Panel43: TPanel;
    eCashInvNumber: TEdit;
    Label88: TLabel;
    Panel44: TPanel;
    Panel45: TPanel;
    swPaidKindO: TSwitch;
    lPaidKindFO: TLabel;
    lPaidKindSO: TLabel;
    Panel46: TPanel;
    swPaidKindR: TSwitch;
    lPaidKindFR: TLabel;
    lPaidKindSR: TLabel;
    Panel47: TPanel;
    swPaidKindC: TSwitch;
    lPaidKindFC: TLabel;
    lPaidKindSC: TLabel;
    eCashAmount: TLabel;
    Panel48: TPanel;
    Line1: TLine;
    Panel49: TPanel;
    cbFullGoodsInfo: TCheckBox;
    tiPriceListItemsFull: TTabItem;
    lwPriceListFullGoods: TListView;
    Popup4: TPopup;
    Panel50: TPanel;
    Label89: TLabel;
    Button43: TButton;
    Button44: TButton;
    Button45: TButton;
    Button46: TButton;
    Button47: TButton;
    Button48: TButton;
    Button49: TButton;
    Button50: TButton;
    Button51: TButton;
    Button52: TButton;
    Button53: TButton;
    Button54: TButton;
    Button55: TButton;
    Button56: TButton;
    Label90: TLabel;
    dsGoodsFullForPrice: TBindSourceDB;

    pBackup_two: TPanel;
    GridPanelLayout15_two: TGridPanelLayout;
    bBackup_two: TButton;
    GridPanelLayout16_two: TGridPanelLayout;
    Label91_two: TLabel;
    Label92_two: TLabel;
    bRestore_two: TButton;
    GridPanelLayout17_two: TGridPanelLayout;
    Label93_two: TLabel;
    Label94_two: TLabel;
    Panel52_two: TPanel;
    pOptimizeDB_two: TPanel;
    GridPanelLayout18_two: TGridPanelLayout;
    bOptimizeDB_two: TButton;
    Panel57_two: TPanel;

    pBackup: TPanel;
    GridPanelLayout15: TGridPanelLayout;
    bBackup: TButton;
    GridPanelLayout16: TGridPanelLayout;
    Label91: TLabel;
    Label92: TLabel;
    bRestore: TButton;
    GridPanelLayout17: TGridPanelLayout;
    Label93: TLabel;
    Label94: TLabel;
    Panel52: TPanel;
    pCashTotal: TPanel;
    lTotalCash: TLabel;
    bCashTotal: TButton;
    tiReportTotalCash: TTabItem;
    Panel53: TPanel;
    bTotalCash: TButton;
    Panel54: TPanel;
    VertScrollBox10: TVertScrollBox;
    Layout8: TLayout;
    Label95: TLabel;
    deStartTC: TDateEdit;
    Layout9: TLayout;
    Layout41: TLayout;
    Label96: TLabel;
    deEndTC: TDateEdit;
    Layout42: TLayout;
    Layout45: TLayout;
    Label99: TLabel;
    Layout48: TLayout;
    cbPaidKindTC: TComboBox;
    lReturnDayCount: TLayout;
    lCriticalWeight: TLayout;
    Label97: TLabel;
    LabelCriticalWeight: TLabel;
    eReturnDayCount: TEdit;
    eCriticalWeight: TEdit;
    CurWebServerLayout12: TLayout;
    CurWebServerEdit: TEdit;
    CurWebServerLayout11: TLayout;
    Label98: TLabel;
    bCopyServer: TButton;
    Image21: TImage;
    Image20: TImage;
    Panel55: TPanel;
    CurWebServerLayout: TLayout;
    WebServerLayout: TLayout;
    Layout43: TLayout;
    Panel56: TPanel;
    bPartnerJuridicalCollation: TButton;
    bAdmin: TButton;
    Image22: TImage;
    pAdmin: TPanel;
    bSelectJuridicals: TButton;
    Image23: TImage;
    tiJuridicalCollationItems: TTabItem;
    lwJuridicalCollationItems: TListView;
    bsJuridicalCollationItems: TBindSourceDB;
    eJuridicals: TEdit;
    ePartners: TEdit;
    bSelectPartners: TButton;
    Image24: TImage;
    Pie1: TPie;
    Circle1: TCircle;
    pieAllProgress: TPie;
    pOptimizeDB: TPanel;
    GridPanelLayout18: TGridPanelLayout;
    bOptimizeDB: TButton;
    Panel57: TPanel;
    Layout44: TLayout;
    Label100: TLabel;
    lShortName: TLabel;
    tiDocItems: TTabItem;
    lwDocItems: TListView;
    Panel51: TPanel;
    lDocData: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    bsJuridicalCollation: TBindSourceDB;
    Layout46: TLayout;
    Label103: TLabel;
    lChangePercent: TLabel;
    lDocPartnerName: TLabel;
    lDocInfo: TLabel;
    bSyncReturnIn: TButton;
    Panel58: TPanel;
    lTotalPriceReturn: TLabel;
    lPriceWithPercentReturn: TLabel;
    lTotalWeightReturn: TLabel;
    Panel59: TPanel;
    lTotalPriceDoc: TLabel;
    lPriceWithPercentDoc: TLabel;
    lTotalWeightDoc: TLabel;
    lDocBranch: TLabel;
    lDocContract: TLabel;
    LocationSensor1: TLocationSensor;
    LinkListControlToField2: TLinkListControlToField;
    LinkListControlToField9: TLinkListControlToField;
    LinkListControlToField5: TLinkListControlToField;
    LinkListControlToField11: TLinkListControlToField;
    LinkListControlToField10: TLinkListControlToField;
    LinkListControlToField15: TLinkListControlToField;
    LinkListControlToField8: TLinkListControlToField;
    LinkListControlToField16: TLinkListControlToField;
    LinkListControlToField17: TLinkListControlToField;
    LinkFillControlToField: TLinkFillControlToField;
    LinkListControlToField14: TLinkListControlToField;
    LinkListControlToField12: TLinkListControlToField;
    LinkListControlToField18: TLinkListControlToField;
    LinkListControlToField19: TLinkListControlToField;
    LinkListControlToField13: TLinkListControlToField;
    LinkListControlToField20: TLinkListControlToField;
    LinkListControlToField3: TLinkListControlToField;
    LinkListControlToField4: TLinkListControlToField;
    LinkListControlToField7: TLinkListControlToField;
    LinkListControlToField6: TLinkListControlToField;
    LinkListControlToField1: TLinkListControlToField;
    tiSubjectDoc: TTabItem;
    Panel60: TPanel;
    btCloseSubjectDoc: TButton;
    bSaveSubjectDoc: TButton;
    iwSubjectDoc: TListView;
    eSubjectDoc: TEdit;
    bsSubDataSource: TBindSourceDB;
    LinkListControlToField21: TLinkListControlToField;
    bClearSubjectDoc: TButton;
    bSubjectDoc: TButton;
    TimerPopupClose: TTimer;
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
    procedure lwCashListItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure lwCashDocsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lwCashDocsItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure swPaidKindOClick(Sender: TObject);
    procedure swPaidKindRClick(Sender: TObject);
    procedure swPaidKindCClick(Sender: TObject);
    procedure eCashAmountClick(Sender: TObject);
    procedure ppEnterAmountClosePopup(Sender: TObject);
    procedure bBackupClick(Sender: TObject);
    procedure bRestoreClick(Sender: TObject);
    procedure bBackupClick_two(Sender: TObject);
    procedure bRestoreClick_two(Sender: TObject);
    procedure bCashTotalClick(Sender: TObject);
    procedure bTotalCashClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bCopyServerClick(Sender: TObject);
    procedure bPartnerJuridicalCollationClick(Sender: TObject);
    procedure bAdminClick(Sender: TObject);
    procedure bSelectJuridicalsClick(Sender: TObject);
    procedure lwJuridicalCollationItemsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bSelectPartnersClick(Sender: TObject);
    procedure bOptimizeDBClick(Sender: TObject);
    procedure bOptimizeDBClick_two(Sender: TObject);
    procedure LinkListControlToField14FilledListItem(Sender: TObject;
      const AEditor: IBindListEditorItem);
    procedure lwJuridicalCollationItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure bSyncReturnInClick(Sender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
    procedure tiSubjectDocClick(Sender: TObject);
    procedure Button57Click(Sender: TObject);
    procedure bSaveSubjectDocClick(Sender: TObject);
    procedure eSubjectDocClick(Sender: TObject);
    procedure btCloseSubjectDocClick(Sender: TObject);
    procedure bClearSubjectDocClick(Sender: TObject);
    procedure bSubjectDocClick(Sender: TObject);
    procedure TimerPopupCloseTimer(Sender: TObject);
  private
    { Private declarations }
    FFormsStack: TStack<TFormStackItem>;
    FListType: TListType;
    FJuridicalIndex: integer;
    FJuridicalList: TList<TJuridicalItem>;
    FPartnerIndex: integer;
    FPartnerList: TList<TPartnerItem>;
    FAllContractList: TList<TContractItem>;
    FContractIdList: TList<integer>;
    FPaidKindIdList: TList<integer>;

    FCanEditPartner : boolean;

    FCurCoordinatesSet: boolean;
    FCurCoordinatesMsg: String;
    FServiceNameMsg: String;
    FCurCoordinates: TLocationCoord2D;
    FSensorCoordinates: TLocationCoord2D;
    FMapLoaded: Boolean;
    //FWebGMap: TTMSFMXWebGMaps;

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
    FUseAdminRights: boolean;
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

    FEditCashAmount: boolean;
    FCashAmountValue: Double;

    FPhotoPath: boolean;

    FSubjectDocItem: String;

    FReturnInSubjectDocId: Integer;
    FReturnInSubjectDocName: String;

    FPaidKindChangedO: boolean;
    FPaidKindChangedR: boolean;
    FPaidKindChangedC: boolean;

    FPermissionState: boolean;

    procedure SetCashAmountValue(Value: Double);

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
    procedure ChangePaidKindOrderExtrernal(Sender: TObject; const AResult: TModalResult);
    procedure ChangePaidKindOrderExtrernalRepeat(const AResult: TModalResult);
    procedure ChangePaidKindReturnIn(Sender: TObject; const AResult: TModalResult);
    procedure ChangePaidKindReturnInRepeat(const AResult: TModalResult);
    procedure ChangePaidKindCash(Sender: TObject; const AResult: TModalResult);
    procedure ChangePaidKindCashRepeat(const AResult: TModalResult);
    procedure SetPartnerCoordinates(const AResult: TModalResult);
    procedure BackupDB(const AResult: TModalResult);
    procedure RestoreDB(const AResult: TModalResult);

    function GetAddress(const Latitude, Longitude: Double): string;
    procedure WebGMapDownloadFinish(Sender: TObject);
    procedure GetPartnerMap(GPSN, GPSE: Double; Address: string);

    procedure ChangeStatusIcon(ACurItem: TListViewItem);
    procedure DeleteButtonHide(AItem: TListViewItem);
    procedure ChangeTaskView(AItem: TListViewItem);

    procedure Wait(AWait: Boolean);
    procedure ClearListSearch(AList: TListView);
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
    procedure CalculateDocCashTotal;
    procedure ShowDocuments;
    procedure ShowPriceLists;
    procedure ShowPriceListItems(FullInfo: boolean);
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

    procedure BuildJuridicalCollationList(AListType: TListType);
    procedure ChangeJuridicalCollationIndex(AListType: TListType; AIndex: integer);

    procedure PrepareCamera;
    procedure CameraFree;
    procedure ScaleImage(const Margins: Integer);
    procedure GetImage;
    procedure PlayAudio;
    procedure CameraComponentSampleBufferReady(Sender: TObject; const ATime: TMediaTime);

    procedure GetCurrentCoordinates;

    procedure AddComboItem(AComboBox: TComboBox; AText: string); overload;
    procedure MobileIdle(Sender: TObject; var Done: Boolean);

    property CashAmountValue: Double read FCashAmountValue write SetCashAmountValue;

    function MyRound_2 (Value : Double) : Double;
  public
    { Public declarations }
    FMarkerList: TList<TLocationData>;

    function GetCoordinates(const Address: string; out Coordinates: TLocationCoord2D): Boolean;
    procedure ShowBigMap;

    function fOptimizeDB : Boolean;

    property ReturnInSubjectDocId: Integer read FReturnInSubjectDocId;
    property ReturnInSubjectDocName: String read FReturnInSubjectDocName;

  end;

var
  frmMain: TfrmMain;

implementation

uses
  uConstants, System.IOUtils, FMX.Authentication, FMX.Storage, FMX.CommonData, uDM, FMX.CursorUtils,
  uNetwork, System.StrUtils, uIntf, Math;

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

function TfrmMain.MyRound_2 (Value : Double) : Double;
var t1, t2 : Integer;
begin
    t1:= TRUNC (Value);
    t2:= ROUND (Value * 100) - t1 * 100;
    Result:= t1 + t2 / 100
end;

{ TJuridicalItem }
constructor TJuridicalItem.Create(AId: Integer; AName: string; AContractIds: string);
begin
  Id := AId;
  Name := AName;
  ContractIds := AContractIds;
end;

{ TContractItem }
constructor TContractItem.Create(AId: Integer; AName: string);
begin
  Id := AId;
  Name := AName;
end;

{ TPartnerItem }
constructor TPartnerItem.Create(AId: integer; AName: string; AContractIds: string);
begin
  Id := AId;
  Name := AName;
  ContractIds := AContractIds;
end;

{ TLocationData }
constructor TLocationData.Create(ALatitude, ALongitude: TLocationDegrees; AVisitTime: TDateTime; AAddress: string);
begin
  Latitude := ALatitude;
  Longitude := ALongitude;
  VisitTime := AVisitTime;
  Address := AAddress;
end;

procedure TfrmMain.MobileIdle(Sender: TObject; var Done: Boolean);
var
  NewPaidKindName: string;
begin
  if FPaidKindChangedO then
  begin
    FPaidKindChangedO := false;

    if not swPaidKindO.IsChecked then
      NewPaidKindName := lPaidKindFO.Text
    else
      NewPaidKindName := lPaidKindSO.Text;

    TDialogService.MessageDialog(Format(sPaidKindChangeQuestion, [NewPaidKindName]),
      TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ChangePaidKindOrderExtrernal, TObject(PChar(NewPaidKindName)));
  end;

  if FPaidKindChangedR then
  begin
    FPaidKindChangedR := false;

    if not swPaidKindR.IsChecked then
      NewPaidKindName := lPaidKindFR.Text
    else
      NewPaidKindName := lPaidKindSR.Text;

    TDialogService.MessageDialog(Format(sPaidKindChangeQuestion, [NewPaidKindName]),
      TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ChangePaidKindReturnIn, TObject(PChar(NewPaidKindName)));
  end;

  if FPaidKindChangedC then
  begin
    FPaidKindChangedC := false;

    if not swPaidKindC.IsChecked then
      NewPaidKindName := lPaidKindFC.Text
    else
      NewPaidKindName := lPaidKindSC.Text;

    TDialogService.MessageDialog(Format(sPaidKindChangeQuestion, [NewPaidKindName]),
      TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ChangePaidKindCash, TObject(PChar(NewPaidKindName)));
  end;
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
  Application.OnIdle := MobileIdle;

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
    ScreenService.SetSupportedScreenOrientations(OrientSet);
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
  FCurCoordinatesMsg := '';
  FServiceNameMsg    := '';

  FJuridicalList := TList<TJuridicalItem>.Create;
  FPartnerList := TList<TPartnerItem>.Create;
  FAllContractList := TList<TContractItem>.Create;
  FContractIdList := TList<integer>.Create;
  FPaidKindIdList := TList<integer>.Create;

  FEditCashAmount := false;
  FSensorCoordinates := TLocationCoord2D.Create(0, 0);
  FPermissionState := True;

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

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
//  if Assigned(FWebGMap) then
//  try
//    FWebGMap.Visible := False;
//    FreeAndNil(FWebGMap);
//  except
//    // buggy piece of shit
//  end;

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
      if pAdminPassword.Visible then
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

procedure TfrmMain.FormShow(Sender: TObject);
begin
  //
  SwitchToForm(tiStart, nil);
  ChangeMainPageUpdate(tcMain);
end;

// отображение на карты всех ТТ
procedure TfrmMain.lbiShowAllOnMapClick(Sender: TObject);
begin
  ppPartner.IsOpen := False;

  DM.ShowAllPartnerOnMap;
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
  if (AEditor.CurrentIndex > -1) and Assigned(lwOrderExternalItems) and
    Assigned(lwOrderExternalItems.Items[AEditor.CurrentIndex]) and
    Assigned(lwOrderExternalItems.Items[AEditor.CurrentIndex].Objects) and
    Assigned(lwOrderExternalItems.Items[AEditor.CurrentIndex].Objects.FindDrawable('DeleteButton'))
  then
    lwOrderExternalItems.Items[AEditor.CurrentIndex].Objects.FindDrawable('DeleteButton').Visible := FCanEditDocument;
end;

procedure TfrmMain.LinkListControlToFieldReturnInItemsFilledListItem(Sender: TObject;
  const AEditor: IBindListEditorItem);
begin
  if (AEditor.CurrentIndex > -1) and Assigned(lwReturnInItems) and
    Assigned(lwReturnInItems.Items[AEditor.CurrentIndex]) and
    Assigned(lwReturnInItems.Items[AEditor.CurrentIndex].Objects) and
    Assigned(lwReturnInItems.Items[AEditor.CurrentIndex].Objects.FindDrawable('DeleteButton'))
  then
    lwReturnInItems.Items[AEditor.CurrentIndex].Objects.FindDrawable('DeleteButton').Visible := FCanEditDocument;
end;

procedure TfrmMain.LinkListControlToField14FilledListItem(Sender: TObject;
  const AEditor: IBindListEditorItem);
var
  DocType, Debet, Kredit: TListItemDrawable;
  DocColor: TAlphaColor;
begin
  if (AEditor.CurrentIndex > -1) and Assigned(lwJuridicalCollation) and
    Assigned(lwJuridicalCollation.Items[AEditor.CurrentIndex]) and
    Assigned(lwJuridicalCollation.Items[AEditor.CurrentIndex].Objects) then
  begin
    DocType := lwJuridicalCollation.Items[AEditor.CurrentIndex].Objects.FindDrawable('DocType');

    if Assigned(DocType) then
    begin
      if Pos('Продажа', (DocType as TListItemText).Text) > 0 then
        DocColor := TAlphaColors.Green
      else if Pos('Возврат от покупателя', (DocType as TListItemText).Text) > 0 then
        DocColor := TAlphaColors.Blue
      else if (Pos('Расчетный счет', (DocType as TListItemText).Text) > 0) or
              (Pos('Касса', (DocType as TListItemText).Text) > 0) then
        DocColor := TAlphaColors.Brown
      else
        DocColor := TAlphaColors.Red;

      Debet := lwJuridicalCollation.Items[AEditor.CurrentIndex].Objects.FindDrawable('Debet');
      if Assigned(Debet) then
        (Debet as TListItemText).TextColor := DocColor;

      Kredit := lwJuridicalCollation.Items[AEditor.CurrentIndex].Objects.FindDrawable('Kredit');
      if Assigned(Kredit) then
        (Kredit as TListItemText).TextColor := DocColor;
    end;
  end;
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
  if (AEditor.CurrentIndex > -1) and Assigned(lwStoreRealItems) and
    Assigned(lwStoreRealItems.Items[AEditor.CurrentIndex]) and
    Assigned(lwStoreRealItems.Items[AEditor.CurrentIndex].Objects) and
    Assigned(lwStoreRealItems.Items[AEditor.CurrentIndex].Objects.FindDrawable('DeleteButton'))
  then
    lwStoreRealItems.Items[AEditor.CurrentIndex].Objects.FindDrawable('DeleteButton').Visible := FCanEditDocument;
end;

procedure TfrmMain.LinkListControlToFieldTasksFilledListItem(Sender: TObject;
  const AEditor: IBindListEditorItem);
begin
  ChangeTaskView(lwTasks.Items[AEditor.CurrentIndex])
end;

procedure TfrmMain.LocationSensor1LocationChanged(Sender: TObject;
  const OldLocation, NewLocation: TLocationCoord2D);
begin
  FSensorCoordinates := TLocationCoord2D.Create(NewLocation.Latitude, NewLocation.Longitude);
end;

// проверка логина и пароля
procedure TfrmMain.LogInButtonClick(Sender: TObject);
var
  ErrorMessage: String;
  SettingsFile : TIniFile;
  NeedSync : boolean;
begin
  NeedSync := not assigned(gc_User) or SyncCheckBox.IsChecked;

  if not FPermissionState then
  begin
    ShowMessage('Необходимые разрешения не предоставлены');
    exit;
  end;

  // !!!Optimize!!!
  if SyncCheckBox.IsChecked = TRUE then
     fOptimizeDB;

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
        ShowMessage('Нет связи с сервером. Продолжение работы невозможно'+#13#10 + GetTextMessage(E));
        exit;
      end;
    end;
    //
  end;

  // !!!Optimize!!!
  //if SyncCheckBox.IsChecked = TRUE then
  //   fOptimizeDB;

  // сохранение координат при логине и запуск таймера
  tSavePathTimer(tSavePath);

  if not gc_User.Local then
  begin
    if not DM.GetConfigurationInfo then
      Exit;

    if NeedSync then
      DM.SynchronizeWithMainDatabase
    {$IFDEF ANDROID}
    else
      DM.CheckUpdate; // проверка небходимости обновления
    {$ENDIF}
  end;

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

  if  Assigned(AItem.Objects.FindDrawable('StatusId')) then ChangeStatusIcon(AItem);

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

  if  Assigned(AItem.Objects.FindDrawable('StatusId')) then ChangeStatusIcon(AItem);

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

  if  Assigned(AItem.Objects.FindDrawable('StatusId')) then ChangeStatusIcon(AItem);

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

procedure TfrmMain.ChangeJuridicalCollationIndex(AListType: TListType; AIndex: integer);
var
  i, OldIndex, DefIndex, OldContractId: integer;
begin
  case AListType of
    ltJuridicals:
    begin
      OldIndex := FJuridicalIndex;

      FJuridicalIndex := AIndex;

      if OldIndex <> FJuridicalIndex then
      begin
        eJuridicals.Text := FJuridicalList[FJuridicalIndex].Name;

        with DM.qrySelect do
        begin
          FPartnerList.Clear;

          FPartnerList.Add(TPartnerItem.Create(0, 'все', ''));

          Open(
             ' SELECT '
           + '         Object_Partner.Id '
           + '       , Object_Partner.Address '
           + '       , group_concat(distinct Object_Contract.Id) AS ContractIds '
           + ' FROM  Object_Partner  '
           + '       LEFT JOIN Object_Contract  ON Object_Contract.Id = Object_Partner.ContractId  '
           + ' WHERE Object_Partner.JuridicalId = ' + IntToStr(FJuridicalList[FJuridicalIndex].Id)
           + '   AND Object_Partner.isErased    = 0 '
           + ' GROUP BY Address '
              );

          First;
          while not Eof do
          begin
            FPartnerList.Add(TPartnerItem.Create(FieldByName('Id').AsInteger, FieldByName('ADDRESS').AsString, FieldByName('ContractIds').AsString));

            Next;
          end;
          Close;

          // все договора юридического лица
          FAllContractList.Clear;

          Open(
             ' SELECT '
           + '         distinct Id '
           + '       , ContractTagName || '' '' || ValueData AS ContractName '
           + ' FROM  Object_Contract '
           + ' WHERE Id in (' + FJuridicalList[FJuridicalIndex].ContractIds + ') '
              );

          First;
          while not Eof do
          begin
            FAllContractList.Add(TContractItem.Create(FieldByName('Id').AsInteger, FieldByName('ContractName').AsString));

            Next;
          end;

          Close;
        end;

        FPartnerIndex := -1;
        DefIndex := 0;
        if FFirstSet then
          for i := 0 to FPartnerList.Count - 1 do
            if FPartnerList[i].Id = FPartnerRJC then
            begin
              DefIndex := i;
              break;
            end;
        ChangeJuridicalCollationIndex(ltPartners, DefIndex);
      end;
    end;
    ltPartners:
    begin
      OldIndex := FPartnerIndex;

      FPartnerIndex := AIndex;

      if OldIndex <> FPartnerIndex then
      begin
        ePartners.Text := FPartnerList[FPartnerIndex].Name;

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
          if (FPartnerIndex <= 0) or
             (pos(IntToStr(FAllContractList[i].Id) + ',', FPartnerList[FPartnerIndex].ContractIds) > 0) or
             (pos(',' + IntToStr(FAllContractList[i].Id), FPartnerList[FPartnerIndex].ContractIds) > 0) or
             (IntToStr(FAllContractList[i].Id) = FPartnerList[FPartnerIndex].ContractIds) then
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
  end;
end;

procedure TfrmMain.lwJuridicalCollationItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  lDocData.Text := DM.cdsJuridicalCollationDocType.AsString + ' №' + DM.cdsJuridicalCollationDocNum.AsString +
    ' от ' + FormatDateTime('dd.mm.yyyy', DM.cdsJuridicalCollationDocDate.AsDateTime);
  lDocInfo.Text := DM.cdsJuridicalCollationPaidKindShow.AsString;
  lDocBranch.Text := DM.cdsJuridicalCollationFromToName.AsString;

  DM.tblObject_Contract.Open;
  if DM.tblObject_Contract.Locate('Id', FContractIdList[cbContracts.ItemIndex], []) then
    if DM.tblObject_ContractChangePercent.AsFloat < -0.0001 then
      lDocInfo.Text := lDocInfo.Text + '; Скидка: ' + FormatFloat(',0.##', Abs(DM.tblObject_ContractChangePercent.AsFloat)) + ' %';
  DM.tblObject_Contract.Close;

  DM.GenerateJuridicalCollationDocItems(DM.cdsJuridicalCollationDocId.AsInteger);
  SwitchToForm(tiDocItems, nil);
end;

procedure TfrmMain.lwJuridicalCollationItemsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  ChangeJuridicalCollationIndex(FListType, StrToIntDef(TListItemText(AItem.Objects.FindDrawable('Index')).Text, 0));

  ReturnPriorForm;
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
var
  PartnerCount, PartnerName: TListItemDrawable;
  PartnerColor: TAlphaColor;
begin
  // установка иконки аддресса
  TListItemImage(AItem.Objects.FindDrawable('imAddress')).ImageIndex := 2;
  // установка иконки договора
  TListItemImage(AItem.Objects.FindDrawable('imContact')).ImageIndex := 3;

  if Assigned(AItem) and Assigned(AItem.Objects) then
  begin
    PartnerCount := AItem.Objects.FindDrawable('PartnerCount');
    PartnerColor := TAlphaColors.Black;
    if Assigned(PartnerCount) then
      if StrToIntDef((PartnerCount as TListItemText).Text, 0) > 0 then
        PartnerColor := TAlphaColors.Green;

    PartnerName := AItem.Objects.FindDrawable('Name');
    if Assigned(PartnerName) then
    begin
      (PartnerName as TListItemText).TextColor := PartnerColor;
      (PartnerName as TListItemText).SelectedTextColor := PartnerColor;
    end;
  end;

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
  ShowPriceListItems(cbFullGoodsInfo.IsChecked);
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
  end
  else
  // вызов основания возврата
  if (ItemObject.Name = 'SubjectDocName') and FCanEditDocument then
  begin

    FSubjectDocItem := 'ReturnInItem';

    DM.GenerateReturnInSubjectDoc;

    if DM.cdsReturnInItemsSubjectDocId.AsInteger <> 0 then DM.qrySubjectDoc.Locate('Id', DM.cdsReturnInItemsSubjectDocId.AsInteger, []);

    SwitchToForm(tiSubjectDoc, Nil);
  end;
end;

procedure TfrmMain.lwReturnInItemsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  // установки иконки для кнопки удаления
  TListItemImage(AItem.Objects.FindDrawable('DeleteButton')).ImageIndex := 0;

  if  Assigned(AItem.Objects.FindDrawable('StatusId')) then ChangeStatusIcon(AItem);

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

  if  Assigned(AItem.Objects.FindDrawable('StatusId')) then ChangeStatusIcon(AItem);

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

  if  Assigned(AItem.Objects.FindDrawable('StatusId')) then ChangeStatusIcon(AItem);

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

  if  Assigned(AItem.Objects.FindDrawable('StatusId')) then ChangeStatusIcon(AItem);

  AItem.Objects.FindDrawable('DeleteButton').Visible := FCanEditDocument;
end;

// ввод числа (для редактирования количества товара)
procedure TfrmMain.b0Click(Sender: TObject);
begin
  if lAmount.Text = '0' then
    lAmount.Text := '';

  lAmount.Text := lAmount.Text + TButton(Sender).Text;
end;

procedure TfrmMain.SetCashAmountValue(Value: Double);
begin
  FCashAmountValue := Value;
  eCashAmount.Text := FormatFloat(',0.##', FCashAmountValue);
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
  PaidKindId: integer;
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

    if not swPaidKindO.IsChecked then
      PaidKindId := DM.tblObject_ConstPaidKindId_First.AsInteger
    else
      PaidKindId := DM.tblObject_ConstPaidKindId_Second.AsInteger;

    if DM.SaveOrderExternal(deOrderDate.Date, PaidKindId, eOrderComment.Text,
      FOrderTotalPrice, FOrderTotalCountKg, DelItems, AResult = mrNone, ErrMes) then
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
  PaidKindId: integer;
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

    if not swPaidKindR.IsChecked then
      PaidKindId := DM.tblObject_ConstPaidKindId_First.AsInteger
    else
      PaidKindId := DM.tblObject_ConstPaidKindId_Second.AsInteger;

    if DM.SaveReturnIn(deReturnDate.Date, PaidKindId, eReturnComment.Text, FReturnInSubjectDocId, FReturnInSubjectDocName,
      FReturnInTotalPrice, FReturnInTotalCountKg, DelItems, AResult = mrNone, ErrMes) then
    begin
      if FEditDocuments then
        ChangeReturnInDoc;

      ShowMessage('Сохранение возврата прошло успешно.');

      ReturnPriorForm;
    end else
      TDialogService.MessageDialog(ErrMes, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
  end;
end;

{ резервное копирование БД}
procedure TfrmMain.BackupDB(const AResult: TModalResult);
begin
  if AResult <> mrNo then
  begin
    try
      if FileExists(TPath.Combine(TPath.GetSharedDocumentsPath, DataBaseFileName)) then
        TFile.Delete(TPath.Combine(TPath.GetSharedDocumentsPath, DataBaseFileName));

      TFile.Copy(TPath.Combine(TPath.GetDocumentsPath, DataBaseFileName), TPath.Combine(TPath.GetSharedDocumentsPath, DataBaseFileName));

      ShowMessage('Резервное копирование успешно выполнено');
    except
      TDialogService.MessageDialog('Не удалось удалить старую резервную копию. Возможно файл занят другим приложением.',
        TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
    end;
  end;
end;

{ востановление БД из резервной копии}
procedure TfrmMain.RestoreDB(const AResult: TModalResult);
begin
  if AResult <> mrNo then
  begin
    DM.conMain.Close;
    try
      try
        TFile.Copy(TPath.Combine(TPath.GetSharedDocumentsPath, DataBaseFileName), TPath.Combine(TPath.GetDocumentsPath, DataBaseFileName), true);

        ShowMessage('Востановление резервной копии успешно выполнено');
      except

        TDialogService.MessageDialog('Не удалось востановить резервную копию.',
          TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
      end;
    finally
      DM.conMain.Open;
      DM.tblObject_Const.Open;
    end;
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
  ClearListSearch(lwPromoGoods);
  DM.qryPromoGoods.Close;
//or
//  DM.qryPromoGoods.SQL.Text := 'select G.OBJECTCODE, G.VALUEDATA GoodsName, T.VALUEDATA TradeMarkName, ' +
//    'CASE WHEN PG.GOODSKINDID = 0 THEN ''все виды'' ELSE GK.VALUEDATA END KindName, ' +
//    '''Скидка '' || PG.TAXPROMO || ''%'' Tax, ' +
//    '''Акционная цена: '' || PG.PRICEWITHOUTVAT || '' (с НДС '' || PG.PRICEWITHVAT || '') за '' || M.VALUEDATA Price, ' +
//    '''Акция заканчивается '' || strftime(''%d.%m.%Y'',P.ENDSALE) Termin, P.ID PromoId ' +
//    'from MOVEMENTITEM_PROMOGOODS PG ' +
//    'JOIN MOVEMENT_PROMO P ON P.ID = PG.MOVEMENTID AND :PROMODATE BETWEEN P.STARTSALE AND P.ENDSALE ' +
//    'LEFT JOIN OBJECT_GOODS G ON G.ID = PG.GOODSID ' +
//    'LEFT JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
//    'LEFT JOIN OBJECT_TRADEMARK T ON T.ID = G.TRADEMARKID ' +
//    'LEFT JOIN OBJECT_GOODSKIND GK ON GK.ID = PG.GOODSKINDID ' +
//    'ORDER BY G.VALUEDATA, P.ENDSALE';
//or


  DM.qryPromoGoods.SQL.Text :=
      ' SELECT '
    + '         Object_Goods.ObjectCode '
    + '       , Object_Goods.ValueData       AS GoodsName '
    + '       , Object_TradeMark.ValueData   AS TradeMarkName '
    + '       , CASE WHEN MovementItem_PromoGoods.GoodsKindId = 0 THEN ''все виды'' ELSE Object_GoodsKind.ValueData END AS KindName '
    + '       , ''Скидка '' || MovementItem_PromoGoods.TaxPromo || ''%''                    AS Tax '
    + '       , ''Акционная цена: '' || MovementItem_PromoGoods.PriceWithOutVAT || '' (с НДС '' || MovementItem_PromoGoods.PriceWithVAT || '') за '' || Object_Measure.ValueData AS Price '
    + '       , ''Акция заканчивается '' || strftime(''%d.%m.%Y'',Movement_Promo.EndSale)   AS Termin '
    + '       , Movement_Promo.Id            AS PromoId '
    + ' FROM  MovementItem_PromoGoods  '
    + '       JOIN Movement_Promo ON Movement_Promo.Id = MovementItem_PromoGoods.MovementId '
    + '                          AND :PROMODATE BETWEEN Movement_Promo.StartSale AND Movement_Promo.EndSale '
    + '       LEFT JOIN Object_Goods     ON Object_Goods.Id     = MovementItem_PromoGoods.GoodsId '
    + '       LEFT JOIN Object_Measure   ON Object_Measure.Id   = Object_Goods.MeasureId '
    + '       LEFT JOIN Object_TradeMark ON Object_TradeMark.Id = Object_Goods.TradeMarkId '
    + '       LEFT JOIN Object_GoodsKind ON Object_GoodsKind.Id = MovementItem_PromoGoods.GoodsKindId '
    + ' ORDER BY Object_Goods.ValueData, Movement_Promo.EndSale ';
  DM.qryPromoGoods.ParamByName('PROMODATE').AsDate := dePromoGoodsDate.Date;
  DM.qryPromoGoods.Open;

  lwPromoGoods.ScrollViewPos := 0;
end;

// начитка торговых точек, участвующих в акциях
procedure TfrmMain.dePromoPartnerDateChange(Sender: TObject);
begin
  DM.qryPromoPartners.Close;
//or
//  DM.qryPromoPartners.SQL.Text := 'SELECT J.VALUEDATA PartnerName, OP.ADDRESS, ' +
//    'CASE WHEN PP.CONTRACTID = 0 THEN ''все договора'' ELSE C.CONTRACTTAGNAME || '' '' || C.VALUEDATA END ContractName, ' +
//    'PP.PARTNERID, PP.CONTRACTID, group_concat(distinct PP.MOVEMENTID) PromoIds ' +
//    'from MOVEMENTITEM_PROMOPARTNER PP ' +
//    'JOIN MOVEMENT_PROMO P ON P.ID = PP.MOVEMENTID AND :PROMODATE BETWEEN P.STARTSALE AND P.ENDSALE ' +
//    'LEFT JOIN OBJECT_PARTNER OP ON OP.ID = PP.PARTNERID AND (OP.CONTRACTID = PP.CONTRACTID OR PP.CONTRACTID = 0) ' +
//    'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = OP.JURIDICALID AND J.CONTRACTID = OP.CONTRACTID ' +
//    'LEFT JOIN OBJECT_CONTRACT C ON C.ID = PP.CONTRACTID ' +
//    'GROUP BY PP.PARTNERID, PP.CONTRACTID ' +
//    'ORDER BY J.VALUEDATA, OP.ADDRESS';
//or
  DM.qryPromoPartners.SQL.Text :=
     ' SELECT  '
   + '        Object_Juridical.ValueData AS PartnerName '
   + '       , Object_Partner.Address '
   + '       , CASE WHEN MovementItem_PromoPartner.ContractId = 0 THEN ''все договора'' ELSE Object_Contract.ContractTagName || '' '' || Object_Contract.ValueData END AS ContractName '
   + '       , MovementItem_PromoPartner.PartnerId '
   + '       , MovementItem_PromoPartner.ContractId '
   + '       , group_concat(distinct MovementItem_PromoPartner.MovementId) AS PromoIds  '
   + ' FROM  MovementItem_PromoPartner  '
   + '       JOIN Movement_Promo ON Movement_Promo.Id = MovementItem_PromoPartner.MovementId  '
   + '                          AND :PROMODATE BETWEEN Movement_Promo.StartSale AND Movement_Promo.EndSale  '
   + '       LEFT JOIN Object_Partner   ON Object_Partner.Id           = MovementItem_PromoPartner.PartnerId  '
   + '                                 AND (Object_Partner.ContractId  = MovementItem_PromoPartner.ContractId  '
   + '                                  OR MovementItem_PromoPartner.ContractId = 0)  '
   + '       LEFT JOIN Object_Juridical ON Object_Juridical.Id         = Object_Partner.JuridicalId  '
   + '                                 AND Object_Juridical.ContractId = Object_Partner.ContractId  '
   + '       LEFT JOIN Object_Contract  ON Object_Contract.Id          = MovementItem_PromoPartner.ContractId  '
   + ' GROUP BY MovementItem_PromoPartner.PartnerId, MovementItem_PromoPartner.ContractId  '
   + ' ORDER BY Object_Juridical.ValueData, Object_Partner.Address ';
  DM.qryPromoPartners.ParamByName('PROMODATE').AsDate := dePromoPartnerDate.Date;
  DM.qryPromoPartners.Open;

  lwPromoPartners.ScrollViewPos := 0;
end;

{ создание новых или редактирование ранее введенных "остатков" }
procedure TfrmMain.CreateEditStoreReal(const AResult: TModalResult);
begin
  if (AResult = mrNone) or (AResult = mrYes) then
  begin
    ClearListSearch(lwStoreRealItems);
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

{ создание новых или редактирование ранее введенных "заявок" }
procedure TfrmMain.CreateEditOrderExtrernal(New: boolean);
begin
  ClearListSearch(lwOrderExternalItems);
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
    lOrderPrice.Text := 'Цена';

  lPaidKindFO.Text := DM.tblObject_ConstPaidKindName_First.AsString;
  lPaidKindSO.Text := DM.tblObject_ConstPaidKindName_Second.AsString;
  swPaidKindO.IsChecked := not (DM.cdsOrderExternalPaidKindId.AsInteger = DM.tblObject_ConstPaidKindId_First.AsInteger);

  FCanEditDocument := not DM.cdsOrderExternalisSync.AsBoolean;

  RecalculateTotalPriceAndWeight;

  pSaveOrderExternal.Visible := FCanEditDocument;
  bAddOrderItem.Visible := FCanEditDocument;
  eOrderComment.ReadOnly := not FCanEditDocument;
  deOrderDate.ReadOnly := not FCanEditDocument;
  swPaidKindO.Enabled := FCanEditDocument;

  lwOrderExternalItems.ScrollViewPos := 0;

  SwitchToForm(tiOrderExternal, nil);
end;

{ создание новых или редактирование ранее введенных "возвратов" }
procedure TfrmMain.CreateEditReturnIn(New: boolean);
begin
  ClearListSearch(lwReturnInItems);
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
  FReturnInSubjectDocId := DM.cdsReturnInSubjectDocId.AsInteger;
  if FReturnInSubjectDocId <> 0 then
    eSubjectDoc.Text := DM.cdsReturnInSubjectDocName.AsString
  else eSubjectDoc.Text := 'Без основания';
  FReturnInSubjectDocName := eSubjectDoc.Text;
  FCanEditDocument := not DM.cdsReturnInisSync.AsBoolean;

  RecalculateReturnInTotalPriceAndWeight;

  if DM.cdsReturnInPriceWithVAT.AsBoolean then
    lReturnInPrice.Text := 'Цена (с НДС)'
  else
    lReturnInPrice.Text := 'Цена (без НДС)';

  lPaidKindFR.Text := DM.tblObject_ConstPaidKindName_First.AsString;
  lPaidKindSR.Text := DM.tblObject_ConstPaidKindName_Second.AsString;
  swPaidKindR.IsChecked := not (DM.cdsReturnInPaidKindId.AsInteger = DM.tblObject_ConstPaidKindId_First.AsInteger);

  pSaveReturnIn.Visible := FCanEditDocument;
  bAddReturnInItem.Visible := FCanEditDocument;
  bSyncReturnIn.Visible := FCanEditDocument;
  eReturnComment.ReadOnly := not FCanEditDocument;
  deReturnDate.ReadOnly := not FCanEditDocument;
  swPaidKindR.Enabled := FCanEditDocument;
  eSubjectDoc.Enabled := FCanEditDocument;

  lwReturnInItems.ScrollViewPos := 0;
  SwitchToForm(tiReturnIn, nil);

  if FReturnInSubjectDocId = 0 then eSubjectDocClick(Nil);
end;

{ создание новых или редактирование ранее введенных "оплат" }
procedure TfrmMain.CreateEditMovementCash(New: boolean);
begin
  vsbMain.Enabled := false;

  if New then
  begin
    FOldCashId := -1;
    eCashInvNumber.Text := '';
    deCashDate.Date := Date();
    CashAmountValue := 0;
    eCashComment.Text := '';
    FCanEditDocument := true;
    swPaidKindC.IsChecked := not (DM.qryPartnerPaidKindId.AsInteger = DM.tblObject_ConstPaidKindId_First.AsInteger);
  end
  else
  begin
    FOldCashId := DM.qryCashId.AsInteger;
    eCashInvNumber.Text := DM.qryCashInvNumberSale.AsString;
    deCashDate.Date := DM.qryCashOperDate.AsDateTime;
    CashAmountValue := DM.qryCashAmount.AsFloat;
    eCashComment.Text := DM.qryCashComment.AsString;
    FCanEditDocument := not DM.qryCashisSync.AsBoolean;
    swPaidKindC.IsChecked := not (DM.qryCashPAIDKINDID.AsInteger = DM.tblObject_ConstPaidKindId_First.AsInteger);
  end;

  lPaidKindFC.Text := DM.tblObject_ConstPaidKindName_First.AsString;
  lPaidKindSC.Text := DM.tblObject_ConstPaidKindName_Second.AsString;

  eCashComment.ReadOnly := not FCanEditDocument;
  swPaidKindC.Enabled := FCanEditDocument;
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

procedure TfrmMain.ChangePaidKindOrderExtrernal(Sender: TObject; const AResult: TModalResult);
begin
  if AResult = mrYes then
    TDialogService.MessageDialog(Format(sPaidKindRepeatQuestion, [string(PChar(Sender))]),
      TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ChangePaidKindOrderExtrernalRepeat)
  else
    swPaidKindO.IsChecked := not swPaidKindO.IsChecked;
end;

procedure TfrmMain.ChangePaidKindOrderExtrernalRepeat(const AResult: TModalResult);
begin
  if AResult = mrNo then
    swPaidKindO.IsChecked := not swPaidKindO.IsChecked;
end;

procedure TfrmMain.ChangePaidKindReturnIn(Sender: TObject; const AResult: TModalResult);
begin
  if AResult = mrYes then
    TDialogService.MessageDialog(Format(sPaidKindRepeatQuestion, [string(PChar(Sender))]),
      TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ChangePaidKindReturnInRepeat)
  else
    swPaidKindR.IsChecked := not swPaidKindR.IsChecked;
end;

procedure TfrmMain.ChangePaidKindReturnInRepeat(const AResult: TModalResult);
begin
  if AResult = mrNo then
    swPaidKindR.IsChecked := not swPaidKindR.IsChecked;
end;

procedure TfrmMain.ChangePaidKindCash(Sender: TObject; const AResult: TModalResult);
begin
  if AResult = mrYes then
    TDialogService.MessageDialog(Format(sPaidKindRepeatQuestion, [string(PChar(Sender))]),
      TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, ChangePaidKindCashRepeat)
  else
    swPaidKindC.IsChecked := not swPaidKindC.IsChecked;
end;

procedure TfrmMain.ChangePaidKindCashRepeat(const AResult: TModalResult);
begin
  if AResult = mrNo then
    swPaidKindC.IsChecked := not swPaidKindC.IsChecked;
end;

procedure TfrmMain.eCashAmountClick(Sender: TObject);
begin
  // вызов формы для редактирования суммы оплаты
  if FCanEditDocument then
  begin
    FEditCashAmount := true;
    pEnterMovmentCash.Visible := false;
    lAmount.Text := '0';
    lMeasure.Text := '';

    ppEnterAmount.IsOpen := true;
  end;
end;

// проверка и корректировка введенной координаты GPS
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
  Id, ContractId: integer;
  AddressOnMap: string;
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

      if DM.qryPartnerShortAddress.AsString <> '' then
         AddressOnMap := DM.qryPartnerShortAddress.AsString
       else
         AddressOnMap := DM.qryPartnerAddress.AsString;

      GetPartnerMap(FCurCoordinates.Latitude, FCurCoordinates.Longitude, AddressOnMap);
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

  bsGoodsItems.DataSet := DataSetCache.ActiveDataSet;

  SwitchToForm(tiGoodsItems, DM.qryGoodsItems);
end;

// переход на форму выбора товаров для возврата
procedure TfrmMain.bAddReturnInItemClick(Sender: TObject);
begin
  if FReturnInSubjectDocId = 0 then
  begin
    ShowMessage('Не заполнена основание возврата.'#13#10#13#10'Добвлять товар запрещено.');
    Exit;
  end;

  DM.GenerateReturnInItemsList;

  lPromoPrice.Visible := false;
  pShowOnlyPromo.Visible := false;

  bsGoodsItems.DataSet := DataSetCache.ActiveDataSet;

  SwitchToForm(tiGoodsItems, DM.qryGoodsItems);
end;

// переход на форму выбора товаров для ввода остатков
procedure TfrmMain.bAddStoreRealItemClick(Sender: TObject);
begin
  DM.GenerateStoreRealItemsList;

  lPromoPrice.Visible := false;
  pShowOnlyPromo.Visible := false;

  bsGoodsItems.DataSet := DataSetCache.ActiveDataSet;

  SwitchToForm(tiGoodsItems, DM.qryGoodsItems);
end;

procedure TfrmMain.bAdminClick(Sender: TObject);
begin
  if not FUseAdminRights then
  begin
    ePassword.Text := '';
    vsbMain.Enabled := false;
    pAdminPassword.Visible := true;
  end
  else
  begin
    FUseAdminRights := false;
    pBackup.Visible := false;
    pOptimizeDB.Visible := false;
  end;
end;

procedure TfrmMain.bBackupClick(Sender: TObject);
var
  Mes: string;
begin
  if FileExists(TPath.Combine(TPath.GetSharedDocumentsPath, DataBaseFileName)) then
    Mes := 'Резервная копия уже существует. Перезаписать резервную копию базы данных?'
  else
    Mes := 'Выполнить резервное копирование базы данных?';

  TDialogService.MessageDialog(Mes,
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, BackupDB);
end;
procedure TfrmMain.bBackupClick_two(Sender: TObject);
var
  Mes: string;
begin
  if FileExists(TPath.Combine(TPath.GetSharedDocumentsPath, DataBaseFileName)) then
    Mes := 'Резервная копия уже существует. Перезаписать резервную копию базы данных?'
  else
    Mes := 'Выполнить резервное копирование базы данных?';

  TDialogService.MessageDialog(Mes,
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, BackupDB);
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
  pAdminPassword.Visible := false;
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

procedure TfrmMain.bClearSubjectDocClick(Sender: TObject);
begin
  if FSubjectDocItem = 'ReturnIn' then
  begin
    ShowMessage('Необходимо выбрать Основание возврата.');
    Exit;
//    FReturnInSubjectDocId := 0;
//    FReturnInSubjectDocName := 'Без основания';
  end else if FSubjectDocItem = 'ReturnInItem' then
  begin
    DM.cdsReturnInItems.Edit;
    DM.cdsReturnInItemsSubjectDocId.AsInteger := FReturnInSubjectDocId;
    DM.cdsReturnInItemsSubjectDocName.AsString := FReturnInSubjectDocName; //'Без основания';
    DM.cdsReturnInItems.Post;
  end;

  ReturnPriorForm;
end;

// присвоение количества товаров
procedure TfrmMain.bEnterAmountClick(Sender: TObject);
var
  MovementItemId: Integer;
begin
  if TimerPopupClose.Enabled then Exit;

  if FEditCashAmount then
  begin
    CashAmountValue := StrToFloatDef(lAmount.Text, 0);
  end
  else
  if tcMain.ActiveTab = tiOrderExternal then
  begin
    DM.cdsOrderItems.Edit;
    DM.cdsOrderItemsCount.AsFloat := StrToFloatDef(lAmount.Text, 0);
    DM.cdsOrderItems.Post;

    if (DM.cdsOrderItemsCount.AsCurrency > 0) or (DM.cdsOrderItemsRecommendCount.AsCurrency > 0) then
    begin
      DM.conMain.StartTransaction;
      try
        DM.tblMovementItem_OrderExternal.Open;

        if DM.cdsOrderItemsId.AsInteger = -1 then // новая запись
        begin
          MovementItemId := DM.InsertOrderExternalItem(DM.cdsOrderExternalId.AsInteger, DM.cdsOrderItemsGoodsId.AsInteger, DM.cdsOrderItemsKindId.AsInteger,
            DM.cdsOrderItemsCount.AsCurrency, DM.cdsOrderItemsPrice.AsCurrency, DM.cdsOrderExternalChangePercent.AsCurrency);

          DM.cdsOrderItems.Edit;
          DM.cdsOrderItemsId.AsInteger := MovementItemId;
          DM.cdsOrderItems.Post;
        end else
          DM.UpdateOrderExternalItem(DM.cdsOrderItemsId.AsInteger, DM.cdsOrderItemsCount.AsCurrency,
            DM.cdsOrderItemsPrice.AsCurrency, DM.cdsOrderExternalChangePercent.AsCurrency);

        DM.conMain.Commit;
      except
        DM.conMain.Rollback;
        raise;
      end;
    end;

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

  TimerPopupClose.Enabled := True;
end;

procedure TfrmMain.bEnterServerClick(Sender: TObject);
begin
  if not FUseAdminRights then
  begin
    ePassword.Text := '';
    vsbMain.Enabled := false;
    pAdminPassword.Visible := true;
  end
  else
  begin
    FUseAdminRights := false;
    WebServerLayout.Height := 0;
    CurWebServerLayout.Height := 0;
    if High(gc_WebServers) > 0 then gc_WebService := gc_WebServers[0]
    else gc_WebService := '';
    //
    pBackup_two.Visible := false;
    pOptimizeDB_two.Visible := false;
  end;
end;

// добавление количества товаров к введенным ранее
procedure TfrmMain.bAddAmountClick(Sender: TObject);
var
  MovementItemId: Integer;
begin
  if TimerPopupClose.Enabled then Exit;

  if FEditCashAmount then
  begin
    CashAmountValue := CashAmountValue + StrToFloatDef(lAmount.Text, 0);
  end
  else
  if tcMain.ActiveTab = tiOrderExternal then
  begin
    DM.cdsOrderItems.Edit;
    DM.cdsOrderItemsCount.AsFloat := DM.cdsOrderItemsCount.AsFloat + StrToFloatDef(lAmount.Text, 0);
    DM.cdsOrderItems.Post;

    if (DM.cdsOrderItemsCount.AsCurrency > 0) or (DM.cdsOrderItemsRecommendCount.AsCurrency > 0) then
    begin
      DM.conMain.StartTransaction;
      try
        DM.tblMovementItem_OrderExternal.Open;

        if DM.cdsOrderItemsId.AsInteger = -1 then // новая запись
        begin
          MovementItemId := DM.InsertOrderExternalItem(DM.cdsOrderExternalId.AsInteger, DM.cdsOrderItemsGoodsId.AsInteger, DM.cdsOrderItemsKindId.AsInteger,
            DM.cdsOrderItemsCount.AsCurrency, DM.cdsOrderItemsPrice.AsCurrency, DM.cdsOrderExternalChangePercent.AsCurrency);

          DM.cdsOrderItems.Edit;
          DM.cdsOrderItemsId.AsInteger := MovementItemId;
          DM.cdsOrderItems.Post;
        end else
          DM.UpdateOrderExternalItem(DM.cdsOrderItemsId.AsInteger, DM.cdsOrderItemsCount.AsCurrency,
            DM.cdsOrderItemsPrice.AsCurrency, DM.cdsOrderExternalChangePercent.AsCurrency);

        DM.conMain.Commit;
      except
        DM.conMain.Rollback;
        raise;
      end;
    end;

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

  TimerPopupClose.Enabled := True;
end;

// отнимание количества товаров от введенных ранее
procedure TfrmMain.bMinusAmountClick(Sender: TObject);
var
  NewVal: Double;
  MovementItemId: Integer;
begin
  if TimerPopupClose.Enabled then Exit;

  if FEditCashAmount then
  begin
    NewVal := CashAmountValue - StrToFloatDef(lAmount.Text, 0);
    if NewVal > 0 then
      CashAmountValue := NewVal
    else
      CashAmountValue := 0;
  end
  else
  if tcMain.ActiveTab = tiOrderExternal then
  begin
    DM.cdsOrderItems.Edit;
    NewVal := DM.cdsOrderItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0);
    if NewVal > 0 then
      DM.cdsOrderItemsCount.AsFloat := NewVal
    else
      DM.cdsOrderItemsCount.AsFloat := 0;
    DM.cdsOrderItems.Post;

    if (DM.cdsOrderItemsCount.AsCurrency > 0) or (DM.cdsOrderItemsRecommendCount.AsCurrency > 0) then
    begin
      DM.conMain.StartTransaction;
      try
        DM.tblMovementItem_OrderExternal.Open;

        if DM.cdsOrderItemsId.AsInteger = -1 then // новая запись
        begin
          MovementItemId := DM.InsertOrderExternalItem(DM.cdsOrderExternalId.AsInteger, DM.cdsOrderItemsGoodsId.AsInteger, DM.cdsOrderItemsKindId.AsInteger,
            DM.cdsOrderItemsCount.AsCurrency, DM.cdsOrderItemsPrice.AsCurrency, DM.cdsOrderExternalChangePercent.AsCurrency);

          DM.cdsOrderItems.Edit;
          DM.cdsOrderItemsId.AsInteger := MovementItemId;
          DM.cdsOrderItems.Post;
        end else
          DM.UpdateOrderExternalItem(DM.cdsOrderItemsId.AsInteger, DM.cdsOrderItemsCount.AsCurrency,
            DM.cdsOrderItemsPrice.AsCurrency, DM.cdsOrderExternalChangePercent.AsCurrency);

        DM.conMain.Commit;
      except
        DM.conMain.Rollback;
        raise;
      end;
    end;

    RecalculateTotalPriceAndWeight;
  end
  else
  if tcMain.ActiveTab = tiStoreReal then
  begin
    DM.cdsStoreRealItems.Edit;
    NewVal := DM.cdsStoreRealItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0);
    if NewVal > 0 then
      DM.cdsStoreRealItemsCount.AsFloat := NewVal
    else
      DM.cdsStoreRealItemsCount.AsFloat := 0;
    DM.cdsStoreRealItems.Post;
  end
  else
  if tcMain.ActiveTab = tiReturnIn then
  begin
    DM.cdsReturnInItems.Edit;
    NewVal := DM.cdsReturnInItemsCount.AsFloat - StrToFloatDef(lAmount.Text, 0);
    if NewVal > 0 then
      DM.cdsReturnInItemsCount.AsFloat := NewVal
    else
      DM.cdsReturnInItemsCount.AsFloat := 0;
    DM.cdsReturnInItems.Post;

    RecalculateReturnInTotalPriceAndWeight;
  end;

  TimerPopupClose.Enabled := True;
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

procedure TfrmMain.btCloseSubjectDocClick(Sender: TObject);
begin
  ReturnPriorForm;
end;

procedure TfrmMain.bTotalCashClick(Sender: TObject);
var
  TotalAmount: Currency;
begin
  TotalAmount := 0;

  with DM.qrySelect do
  begin
    Close;

    SQL.Text :=
         ' SELECT '
       + '         Movement_Cash.Amount '
       + ' FROM  Movement_Cash '
       + ' WHERE DATE(Movement_Cash.OperDate) BETWEEN :STARTDATE AND :ENDDATE '
       + ' AND Movement_Cash.StatusId <> ' + DM.tblObject_ConstStatusId_Erased.AsString;

    if cbPaidKindTC.ItemIndex > 0 then
    begin
      SQL.Text := SQL.Text
        + ' AND Movement_Cash.PaidKindId = ' + IntToStr(FPaidKindIdList[cbPaidKindTC.ItemIndex]);
    end;

    ParamByName('STARTDATE').AsDate := deStartTC.Date;
    ParamByName('ENDDATE').AsDate := deEndTC.Date;

    Open;

    First;
    while not Eof do
    begin
      TotalAmount := TotalAmount + FieldByName('Amount').AsFloat;

      Next;
    end;

    Close;
  end;

  TDialogService.MessageDialog('Оплата за период : ' + FormatFloat(',0.00', TotalAmount),
        TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
end;

// вызов обновления программы
procedure TfrmMain.bUpdateProgramClick(Sender: TObject);
begin
  DM.UpdateProgram(mrYes);
end;

procedure TfrmMain.Button57Click(Sender: TObject);
begin
  ReturnPriorForm;
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
var
  CriticalOverDays: Integer;
  CriticalDebtSum: Double;
begin
  CriticalOverDays := DM.tblObject_ConstCriticalOverDays.AsInteger;
  CriticalDebtSum := DM.tblObject_ConstCriticalDebtSum.AsFloat;

  if (DM.qryPartnerOverDays.AsInteger >= CriticalOverDays) and (DM.qryPartnerDebtSum.AsFloat > CriticalDebtSum) then
    TDialogService.MessageDialog(Format('У контрагента "' + DM.qryPartnerName.AsString
      + '" просроченный долг >= %d день. '
      + sLineBreak + 'Формирование заявки невозможно.', [CriticalOverDays]),
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil)
  else
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
  pAdminPassword.Visible := false;

  FUseAdminRights := true;
  if tcMain.ActiveTab = tiInformation then
  begin
    pBackup.Visible := true;
    pOptimizeDB.Visible := true;
  end
  else
  begin
    pBackup_two.Visible := true;
    pOptimizeDB_two.Visible := true;
    LogInButton.Position.X := bRestore_two.Position.X;
    LogInButton.Position.Y := bOptimizeDB_two.Position.Y-25;
    //LogInButton.Size.Height := bOptimizeDB_two.Size.Height;
    //LogInButton.Size.Width  := bRestore_two.Size.Width;
    // exit;
    //
    WebServerLayout.Height := 75;
    WebServerEdit.Text := FTemporaryServer;
    CurWebServerLayout.Height := 75;
    CurWebServerEdit.Text := gc_WebService;
    gc_WebService := '';
  end;
end;

function TfrmMain.fOptimizeDB : Boolean;
var str_day:string;
begin
  Result:= false;
  //
  try
    DM.conMain.ExecSQL('pragma integrity_check');
    DM.conMain.ExecSQL('VACUUM');

    //!!! MOVEMENT_ROUTEMEMBER !!!
    DM.conMain.ExecSQL('DELETE FROM MOVEMENT_ROUTEMEMBER WHERE ISSYNC = 1');
    //
    str_day:= chr(39) + '-44 DAY' + chr(39);
    //MOVEMENT_ORDEREXTERNAL
    DM.conMain.ExecSQL('DELETE FROM MOVEMENTITEM_ORDEREXTERNAL WHERE MOVEMENTID IN (SELECT Id FROM MOVEMENT_ORDEREXTERNAL WHERE ISSYNC = 1 AND OPERDATE < DATE(CURRENT_DATE, ' + str_day +'))');
    DM.conMain.ExecSQL('DELETE FROM MOVEMENT_ORDEREXTERNAL WHERE ISSYNC = 1 AND OPERDATE < DATE(CURRENT_DATE, ' + str_day +') AND NOT EXISTS (SELECT 1 FROM MOVEMENTITEM_ORDEREXTERNAL WHERE MOVEMENTID = MOVEMENT_ORDEREXTERNAL.Id)');
    //MOVEMENTITEM_RETURNIN
    DM.conMain.ExecSQL('DELETE FROM MOVEMENTITEM_RETURNIN      WHERE MOVEMENTID IN (SELECT Id FROM MOVEMENT_RETURNIN      WHERE ISSYNC = 1 AND OPERDATE < DATE(CURRENT_DATE, ' + str_day +'))');
    DM.conMain.ExecSQL('DELETE FROM MOVEMENT_RETURNIN      WHERE ISSYNC = 1 AND OPERDATE < DATE(CURRENT_DATE, ' + str_day +') AND NOT EXISTS (SELECT 1 FROM MOVEMENTITEM_RETURNIN      WHERE MOVEMENTID = MOVEMENT_RETURNIN.Id)');
    //MOVEMENTITEM_STOREREAL
    DM.conMain.ExecSQL('DELETE FROM MOVEMENTITEM_STOREREAL     WHERE MOVEMENTID IN (SELECT Id FROM MOVEMENT_STOREREAL     WHERE ISSYNC = 1 AND OPERDATE < DATE(CURRENT_DATE, ' + str_day +'))');
    DM.conMain.ExecSQL('DELETE FROM MOVEMENT_STOREREAL     WHERE ISSYNC = 1 AND OPERDATE < DATE(CURRENT_DATE, ' + str_day +') AND NOT EXISTS (SELECT 1 FROM MOVEMENTITEM_STOREREAL     WHERE MOVEMENTID = MOVEMENT_STOREREAL.Id)');
    //MOVEMENTITEM_TASK
    DM.conMain.ExecSQL('DELETE FROM MOVEMENTITEM_TASK          WHERE MOVEMENTID IN (SELECT Id FROM MOVEMENT_TASK          WHERE                OPERDATE < DATE(CURRENT_DATE, ' + str_day +'))');
    DM.conMain.ExecSQL('DELETE FROM MOVEMENT_TASK          WHERE                OPERDATE < DATE(CURRENT_DATE, ' + str_day +') AND NOT EXISTS (SELECT 1 FROM MOVEMENTITEM_TASK          WHERE MOVEMENTID = MOVEMENT_TASK.Id)');
    //MOVEMENTITEM_VISIT
    DM.conMain.ExecSQL('DELETE FROM MOVEMENTITEM_VISIT         WHERE MOVEMENTID IN (SELECT Id FROM MOVEMENT_VISIT         WHERE ISSYNC = 1 AND OPERDATE < DATE(CURRENT_DATE, ' + str_day +')) AND ISSYNC = 1');
    DM.conMain.ExecSQL('DELETE FROM MOVEMENT_VISIT         WHERE ISSYNC = 1 AND OPERDATE < DATE(CURRENT_DATE, ' + str_day +') AND NOT EXISTS (SELECT 1 FROM MOVEMENTITEM_VISIT         WHERE MOVEMENTID = MOVEMENT_VISIT.Id)');
    //MOVEMENT_CASH
    DM.conMain.ExecSQL('DELETE FROM MOVEMENT_CASH          WHERE ISSYNC = 1 AND OPERDATE < DATE(CURRENT_DATE, ' + str_day +')');
    //
    //
    DM.conMain.ExecSQL('DELETE FROM Object_GoodsByGoodsKind WHERE isErased = 1');
    DM.conMain.ExecSQL('DELETE FROM Object_GoodsListSale WHERE isErased = 1');

    DM.conMain.ExecSQL('DELETE FROM OBJECT_PARTNER'
     + ' WHERE  OBJECT_PARTNER.ISERASED = 1'
     + '    AND NOT EXISTS (SELECT 1 FROM  MOVEMENT_ORDEREXTERNAL WHERE MOVEMENT_ORDEREXTERNAL.PARTNERID = OBJECT_PARTNER.ID AND MOVEMENT_ORDEREXTERNAL.CONTRACTID = OBJECT_PARTNER.CONTRACTID)'
     + '    AND NOT EXISTS (SELECT 1 FROM  MOVEMENT_RETURNIN WHERE MOVEMENT_RETURNIN.PARTNERID = OBJECT_PARTNER.ID AND MOVEMENT_RETURNIN.CONTRACTID = OBJECT_PARTNER.CONTRACTID)'
     + '    AND NOT EXISTS (SELECT 1 FROM  MOVEMENT_CASH WHERE MOVEMENT_CASH.PARTNERID = OBJECT_PARTNER.ID AND MOVEMENT_CASH.CONTRACTID = OBJECT_PARTNER.CONTRACTID)'
     + '    AND NOT EXISTS (SELECT 1 FROM  MOVEMENT_STOREREAL WHERE MOVEMENT_STOREREAL.PARTNERID = OBJECT_PARTNER.ID)'
     + '    AND NOT EXISTS (SELECT 1 FROM  MOVEMENT_VISIT WHERE MOVEMENT_VISIT.PARTNERID = OBJECT_PARTNER.ID)'
     + '    AND NOT EXISTS (SELECT 1 FROM  MOVEMENTITEM_TASK WHERE MOVEMENTITEM_TASK.PARTNERID = OBJECT_PARTNER.ID)');

    DM.conMain.ExecSQL('pragma integrity_check');
    DM.conMain.ExecSQL('VACUUM');

    Result:= true;

  except
    on E: Exception do
      Showmessage(GetTextMessage(E));
  end;
end;
procedure TfrmMain.bOptimizeDBClick(Sender: TObject);
begin
  if fOptimizeDB  then
    ShowMessage('Оптимизация базы данных успешно завершена');
end;
procedure TfrmMain.bOptimizeDBClick_two(Sender: TObject);
begin
  if fOptimizeDB  then
    ShowMessage('Оптимизация базы данных успешно завершена');
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
procedure TfrmMain.bPartnerJuridicalCollationClick(Sender: TObject);
var
  OldJuridicalRJC, OldPartnerRJC, OldContractRJC, OldPaidKindRJC: integer;
begin
  OldJuridicalRJC := FJuridicalRJC;
  OldPartnerRJC := FPartnerRJC;
  OldContractRJC := FContractRJC;
  OldPaidKindRJC := FPaidKindRJC;

  FJuridicalRJC := DM.qryPartnerJuridicalId.AsInteger;
  FPartnerRJC := DM.qryPartnerId.AsInteger;
  FContractRJC := DM.qryPartnerCONTRACTID.AsInteger;
  FPaidKindRJC := DM.qryPartnerPaidKindId.AsInteger;
  try
    bReportJuridicalCollationClick(bReportJuridicalCollation);
  finally
    FJuridicalRJC := OldJuridicalRJC;
    FPartnerRJC := OldPartnerRJC;
    FContractRJC := OldContractRJC;
    FPaidKindRJC := OldPaidKindRJC;
  end;
end;

procedure TfrmMain.bPartnersClick(Sender: TObject);
begin
  ShowPartners(9, 'Все ТТ');
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
           FJuridicalList[FJuridicalIndex].Id,
           FPartnerList[FPartnerIndex].Id,
           FContractIdList[cbContracts.ItemIndex],
           FPaidKindIdList[cbPaidKind.ItemIndex]);

  lCaption.Text := 'Акт сверки для "' + FJuridicalList[FJuridicalIndex].Name + '" за период с ' +
    FormatDateTime('DD.MM.YYYY', deStartRJC.Date) +  ' по ' + FormatDateTime('DD.MM.YYYY', deEndRJC.Date) +
    '. Форма оплаты: ' + cbPaidKind.Items[cbPaidKind.ItemIndex];
  SwitchToForm(tiPrintJuridicalCollation, nil);

  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  SettingsFile := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'settings.ini'));
  {$ELSE}
  SettingsFile := TIniFile.Create(TPath.Combine(ExtractFilePath(ParamStr(0)), 'settings.ini'));
  {$ENDIF}
  try
    SettingsFile.WriteString('REPORT', 'StartRJC', FormatDateTime('DD.MM.YYYY', deStartRJC.Date));
    SettingsFile.WriteString('REPORT', 'EndRJC', FormatDateTime('DD.MM.YYYY', deEndRJC.Date));
    SettingsFile.WriteInteger('REPORT', 'JuridicalRJC', FJuridicalList[FJuridicalIndex].Id);
    SettingsFile.WriteInteger('REPORT', 'PartnerRJC', FPartnerList[FPartnerIndex].Id);
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
  CalculateDocCashTotal;
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
        RouteQuery.Open('SELECT * FROM ' + TableName + ' WHERE GPSN <> 0 AND GPSE <> 0')
      else
        RouteQuery.Open('SELECT * FROM ' + TableName
                     + ' WHERE date(InsertDate) = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', deDatePath.Date))
                     + '   AND GPSN <> 0 AND GPSE <> 0');
    except
      on E: Exception do
        Showmessage(GetTextMessage(E));
    end;

    RouteQuery.First;
    while not RouteQuery.EOF do
    begin
      FMarkerList.Add(TLocationData.Create(RouteQuery.FieldByName('GPSN').AsFloat,
        RouteQuery.FieldByName('GPSE').AsFloat, RouteQuery.FieldByName('INSERTDATE').AsDateTime, ''));

      RouteQuery.Next;
    end;

//    if Assigned(FWebGMap) then
//    try
//      FWebGMap.Visible := False;
//      FreeAndNil(FWebGMap);
//    except
//      // buggy piece of shit
//    end;
//
//    FMapLoaded := False;
//
//    FWebGMap := TTMSFMXWebGMaps.Create(Self);
//    FWebGMap.OnDownloadFinish := WebGMapDownloadFinish;
//    FWebGMap.Align := TAlignLayout.Client;
//    FWebGMap.MapOptions.ZoomMap := 14;
//    FWebGMap.Parent := pPathOnMap;
//    FWebGMap.APIKey := DM.tblObject_ConstAPIKey.AsString;
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
  i, NewJuridicalIndex: integer;
begin
  SwitchToForm(tiReportJuridicalCollation, nil);

  FFirstSet := true; // для востановления сохраненных значений ТТ и договоров при первом открытии

  // заполнение списка юридических лиц
  FJuridicalList.Clear;

  with DM.qrySelect do
  begin
    Open(
       ' SELECT '
     + '         Id '
     + '       , ValueData '
     + '       , group_concat(distinct ContractId) AS ContractIds '
     + ' FROM  Object_Juridical '
     + ' WHERE isErased = 0 '
     + ' GROUP BY Id  '
     + ' ORDER BY ValueData '
        );
    First;

    while not Eof do
    begin
      FJuridicalList.Add(TJuridicalItem.Create(FieldByName('Id').AsInteger,
        FieldByName('ValueData').AsString, FieldByName('ContractIds').AsString));

      Next;
    end;

    Close;
  end;

  FJuridicalIndex := -1;
  NewJuridicalIndex := 0;
  for i := 0 to FJuridicalList.Count - 1 do
    if FJuridicalList[i].Id = FJuridicalRJC then
    begin
      NewJuridicalIndex := i;
      break;
    end;
  ChangeJuridicalCollationIndex(ltJuridicals, NewJuridicalIndex);

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

procedure TfrmMain.bRestoreClick(Sender: TObject);
begin
  if FileExists(TPath.Combine(TPath.GetSharedDocumentsPath, DataBaseFileName)) then
    TDialogService.MessageDialog('Востановить резервную копию базы данных? Текущая база данных будет потеряна!',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, RestoreDB)
  else
    TDialogService.MessageDialog('Резервная копия не найдена',
        TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
end;
procedure TfrmMain.bRestoreClick_two(Sender: TObject);
begin
  if FileExists(TPath.Combine(TPath.GetSharedDocumentsPath, DataBaseFileName)) then
    TDialogService.MessageDialog('Востановить резервную копию базы данных? Текущая база данных будет потеряна!',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0, RestoreDB)
  else
    TDialogService.MessageDialog('Резервная копия не найдена',
        TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
end;

// переход на форму отображение маршрутов
procedure TfrmMain.bRouteClick(Sender: TObject);
begin
  FCanEditPartner := false;

  SwitchToForm(tiRoutes, nil);
end;

procedure TfrmMain.bSaveCashClick(Sender: TObject);
var
  PaidKindId: integer;
begin
  if FCanEditDocument then
  begin
    if CashAmountValue = 0 then
    begin
      ShowMessage('Необходимо ввести сумму оплаты');
      exit;
    end;

    if not swPaidKindC.IsChecked then
      PaidKindId := DM.tblObject_ConstPaidKindId_First.AsInteger
    else
      PaidKindId := DM.tblObject_ConstPaidKindId_Second.AsInteger;

    DM.SaveCash(FOldCashId, PaidKindId, eCashInvNumber.Text, deCashDate.Date, CashAmountValue, eCashComment.Text);

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

procedure TfrmMain.bCashTotalClick(Sender: TObject);
begin
  lCaption.Text := bCashTotal.Text;

  deStartTC.Date := Date();
  deEndTC.Date := Date();

  // заполнение списка форм оплаты
  cbPaidKindTC.Items.Clear;
  FPaidKindIdList.Clear;
  AddComboItem(cbPaidKindTC, 'все');
  FPaidKindIdList.Add(0);
  AddComboItem(cbPaidKindTC, DM.tblObject_ConstPaidKindName_First.AsString);
  FPaidKindIdList.Add(DM.tblObject_ConstPaidKindId_First.AsInteger);
  AddComboItem(cbPaidKindTC, DM.tblObject_ConstPaidKindName_Second.AsString);
  FPaidKindIdList.Add(DM.tblObject_ConstPaidKindId_Second.AsInteger);

  // по умолчанию ставим Наличку
  cbPaidKindTC.ItemIndex := 2;

  SwitchToForm(tiReportTotalCash, nil);
end;

{ заполнение списка юридических лиц }
procedure TfrmMain.BuildJuridicalCollationList(AListType: TListType);
var
  i: integer;
  NewItem: TListViewItem;
begin
  lwJuridicalCollationItems.BeginUpdate;
  try
    lwJuridicalCollationItems.Items.Clear;

    case AListType of
      ltJuridicals:
      begin
        for i := 0 to FJuridicalList.Count - 1 do
        begin
          NewItem := lwJuridicalCollationItems.Items.Add;
          NewItem.Text := FJuridicalList[i].Name;
          TListItemText(NewItem.Objects.FindDrawable('Value')).Text := FJuridicalList[i].Name;
          TListItemText(NewItem.Objects.FindDrawable('Index')).Text := IntToStr(i);
        end;
      end;
      ltPartners:
      begin
        for i := 0 to FPartnerList.Count - 1 do
        begin
          NewItem := lwJuridicalCollationItems.Items.Add;
          NewItem.Text := FPartnerList[i].Name;
          TListItemText(NewItem.Objects.FindDrawable('Value')).Text := FPartnerList[i].Name;
          TListItemText(NewItem.Objects.FindDrawable('Index')).Text := IntToStr(i);
        end;
      end;
    end;
  finally
    lwJuridicalCollationItems.EndUpdate;
  end;
end;

procedure TfrmMain.bSelectJuridicalsClick(Sender: TObject);
begin
  ClearListSearch(lwJuridicalCollationItems);

  FListType := ltJuridicals;
  BuildJuridicalCollationList(FListType);

  lwJuridicalCollationItems.ScrollViewPos := 0;
  lCaption.Text := 'Выбор юридического лица для акта сверки';
  SwitchToForm(tiJuridicalCollationItems, nil);
end;

procedure TfrmMain.bSelectPartnersClick(Sender: TObject);
begin
  ClearListSearch(lwJuridicalCollationItems);

  FListType := ltPartners;
  BuildJuridicalCollationList(FListType);

  lwJuridicalCollationItems.ScrollViewPos := 0;
  lCaption.Text := 'Выбор торговой точки для акта сверки';
  SwitchToForm(tiJuridicalCollationItems, nil);
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

        qrySavePhoto.SQL.Text := 'Insert into MovementItem_Visit (MovementId, GUID, Photo, Comment, InsertDate, GPSN, GPSE, AddressByGPS, isErased, isSync) ' +
          'Values (:MovementId, :GUID, :Photo, :Comment, :InsertDate, :GPSN, :GPSE, :AddressByGPS, 0, 0)';
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
          qrySavePhoto.Params[7].Value := GetAddress(FCurCoordinates.Latitude, FCurCoordinates.Longitude)
                                + ' = ' + FServiceNameMsg + ' / ' + FCurCoordinatesMsg
                                ;
        end
        else
        begin
          qrySavePhoto.Params[5].Value := 0;
          qrySavePhoto.Params[6].Value := 0;
          qrySavePhoto.Params[7].Value := ''
                                        + '=' + FCurCoordinatesMsg
                                        ;
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
      Showmessage(GetTextMessage(E));
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

procedure TfrmMain.bSaveSubjectDocClick(Sender: TObject);
begin
  if FSubjectDocItem = 'ReturnIn' then
  begin
    FReturnInSubjectDocId := DM.qrySubjectDocId.AsInteger;
    if FReturnInSubjectDocId = 0 then FReturnInSubjectDocName := 'Без основания'
    else FReturnInSubjectDocName := DM.qrySubjectDocValueData.AsString;
  end else if FSubjectDocItem = 'ReturnInItem' then
  begin
    DM.cdsReturnInItems.Edit;
    DM.cdsReturnInItemsSubjectDocId.AsInteger := DM.qrySubjectDocId.AsInteger;
    if DM.cdsReturnInItemsSubjectDocId.AsInteger = 0 then DM.cdsReturnInItemsSubjectDocName.AsString := 'Без основания'
    else DM.cdsReturnInItemsSubjectDocName.AsString := DM.qrySubjectDocValueData.AsString;
    DM.cdsReturnInItems.Post;
  end;

  ReturnPriorForm;
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

procedure TfrmMain.bSubjectDocClick(Sender: TObject);
begin
  DM.GenerateReturnInSubjectDoc;

  SwitchToForm(tiSubjectDoc, Nil);
end;

// переход на форму синхронизации
procedure TfrmMain.bSyncClick(Sender: TObject);
begin
  cbLoadData.IsChecked := false;
  cbUploadData.IsChecked := true;

  SwitchToForm(tiSync, nil);
end;

// вызов синхронизации с главной БД
procedure TfrmMain.bSyncDataClick(Sender: TObject);
begin
  DM.SynchronizeWithMainDatabase(cbLoadData.IsChecked, cbUploadData.IsChecked);
end;

procedure TfrmMain.bSyncReturnInClick(Sender: TObject);
var
  i: integer;
  ErrMes: string;
  DelItems: string;
  PaidKindId: integer;
begin
  DelItems := '';
  if FDeletedRI.Count > 0 then
  begin
    DelItems := IntToStr(FDeletedRI[0]);
    for i := 1 to FDeletedRI.Count - 1 do
      DelItems := ',' + IntToStr(FDeletedRI[i]);
  end;

  if not swPaidKindR.IsChecked then
    PaidKindId := DM.tblObject_ConstPaidKindId_First.AsInteger
  else
    PaidKindId := DM.tblObject_ConstPaidKindId_Second.AsInteger;

  if DM.SaveReturnIn(deReturnDate.Date, PaidKindId, eReturnComment.Text, FReturnInSubjectDocId, FReturnInSubjectDocName,
    FReturnInTotalPrice, FReturnInTotalCountKg, DelItems, True, ErrMes, True) then
  begin
    if FEditDocuments then
      ChangeReturnInDoc;

    ShowMessage('Сохранение возврата прошло успешно.');

    ReturnPriorForm;
  end else
    TDialogService.MessageDialog(ErrMes, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil);
end;

// выход с формы фотографирования без сохранения
procedure TfrmMain.bClosePhotoClick(Sender: TObject);
begin
  CameraFree;
  ReturnPriorForm;
end;

procedure TfrmMain.bCopyServerClick(Sender: TObject);
begin
  WebServerEdit.Text := CurWebServerEdit.Text;
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
  AddressOnMap: string;
begin
  // карта с координатами ТТ
  if tcPartnerInfo.ActiveTab = tiPartnerMap then
  begin
    if DM.qryPartnerShortAddress.AsString <> '' then
      AddressOnMap := DM.qryPartnerShortAddress.AsString
    else
      AddressOnMap := DM.qryPartnerAddress.AsString;

    if (DM.qryPartnerGPSN.AsFloat <> 0) and (DM.qryPartnerGPSE.AsFloat <> 0) then
      GetPartnerMap(DM.qryPartnerGPSN.AsFloat, DM.qryPartnerGPSE.AsFloat, AddressOnMap)
    else
    begin
      if GetCoordinates(DM.qryPartnerAddress.AsString, Coordinates) then
        GetPartnerMap(Coordinates.Latitude, Coordinates.Longitude, AddressOnMap)
      else
        GetPartnerMap(0, 0, '');
    end;
  end
  else
  begin
    tErrorMap.Enabled := false;

//    if Assigned(FWebGMap) then
//    begin
//      try
//        FWebGMap.Visible := false;
//        FreeAndNil(FWebGMap);
//      except
//      end;
//    end;
  end;
end;

procedure TfrmMain.tErrorMapTimer(Sender: TObject);
begin
  tErrorMap.Enabled := false;

  FMapLoaded := true;

//  if Assigned(FWebGMap) then
//  begin
//    try
//      FWebGMap.Visible := false;
//      FreeAndNil(FWebGMap);
//    except
//    end;
//  end;

  pMapButtons.Enabled := true;
  bRefreshMapScreen.Visible := true;
  bSetPartnerCoordinate.Visible := false;
  lNoMap.Visible := true;
  lNoMap.Text := 'Не удалось загрузить карту с расположением ТТ';
end;

procedure TfrmMain.TimerPopupCloseTimer(Sender: TObject);
begin
  TimerPopupClose.Enabled := False;
  ppEnterAmount.IsOpen := false;
end;

procedure TfrmMain.tiSubjectDocClick(Sender: TObject);
begin

end;

// таймер сохранения маршрута контрагента - сохраняет текущие координаты какждые 5 минут
procedure TfrmMain.tSavePathTimer(Sender: TObject);
var
  GlobalId : TGUID;
begin
  tSavePath.Enabled := false;
  try
    if not DM.IsUploadRouteMember then
    begin
      GetCurrentCoordinates;
      if FCurCoordinatesSet then
      begin
        DM.tblMovement_RouteMember.Open;

        DM.tblMovement_RouteMember.Append;
        CreateGUID(GlobalId);
        DM.tblMovement_RouteMemberGUID.AsString := GUIDToString(GlobalId);
        DM.tblMovement_RouteMemberGPSN.AsFloat := FCurCoordinates.Latitude;
        DM.tblMovement_RouteMemberGPSE.AsFloat := FCurCoordinates.Longitude;
        DM.tblMovement_RouteMemberAddressByGPS.AsString := GetAddress(FCurCoordinates.Latitude, FCurCoordinates.Longitude)
                                                         + ' = ' + FServiceNameMsg + ' / ' + FCurCoordinatesMsg
                                                        ;
        DM.tblMovement_RouteMemberInsertDate.AsDateTime := Now();
        DM.tblMovement_RouteMemberisSync.AsBoolean := false;
        DM.tblMovement_RouteMember.Post;

        DM.tblMovement_RouteMember.Close;
      end
      else
      begin
        DM.tblMovement_RouteMember.Open;

        DM.tblMovement_RouteMember.Append;
        CreateGUID(GlobalId);
        DM.tblMovement_RouteMemberGUID.AsString := GUIDToString(GlobalId);
        DM.tblMovement_RouteMemberGPSN.AsFloat := 0;
        DM.tblMovement_RouteMemberGPSE.AsFloat := 0;
        DM.tblMovement_RouteMemberAddressByGPS.AsString := FCurCoordinatesMsg;
        DM.tblMovement_RouteMemberInsertDate.AsDateTime := Now();
        DM.tblMovement_RouteMemberisSync.AsBoolean := false;
        DM.tblMovement_RouteMember.Post;

        DM.tblMovement_RouteMember.Close;
      end;
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
  {$IFDEF ANDROID}
  var Geocoder: JGeocoder;
      Address: JAddress;
      AddressList: JList;
  {$ENDIF}
begin
  {$IFDEF ANDROID}
  try
    geocoder:= TJGeocoder.JavaClass.init(SharedActivityContext);
    if not Assigned(geocoder) then
    begin
       //raise Exception.Create('Could not access Geocoder');
       Result :=  '';
       FCurCoordinatesMsg:= ' нет доступа к службе Адреса - geocoder для: '+FloatToStr(Latitude)+', '+FloatToStr(Longitude)+'';
       exit;
    end;
    //пробуем определить 1 возможный адрес местоположения
    AddressList:=geocoder.getFromLocation(Latitude, Longitude,1);
    if AddressList.size > 0 then
    begin
       Address:=TJAddress.Wrap((AddressList.get(0) as ILocalObject).GetObjectID);
       if not Assigned(Address) then
       begin
         //raise Exception.Create('Could not access Address');
         FCurCoordinatesMsg:= ' ошибка в службе при раскодировании Адреса для: '+FloatToStr(Latitude)+', '+FloatToStr(Longitude);
         //пустые данные
         Result := '';
       end
       else begin
         //выводим данные
         Result := JStringToString(Address.getAddressLine(0));
         FCurCoordinatesMsg:= ' ' + FloatToStr(Latitude)+', '+FloatToStr(Longitude);
       end
    end else
    begin
      Result :=  FormatFloat('0.00000###', Latitude)+', '+FormatFloat('0.00000###', Longitude);
      FCurCoordinatesMsg:= ' не раскодирован Адрес для '+FloatToStr(Latitude)+', '+FloatToStr(Longitude)+''
    end;
  except
    Result :=  FormatFloat('0.00000###', Latitude)+', '+FormatFloat('0.00000###', Longitude);
    FCurCoordinatesMsg:= ' ошибка в службе при определении Адреса для: '+FloatToStr(Latitude)+', '+FloatToStr(Longitude)+''
  end;
  {$ELSE}
  Result := '';
  {$ENDIF}
end;

function TfrmMain.GetCoordinates(const Address: string; out Coordinates: TLocationCoord2D): Boolean;
begin
  try
//    WebGMapsGeocoder.Address:= Address;
//    if WebGMapsGeocoder.LaunchGeocoding = erOk then
//    begin
//      Coordinates := TLocationCoord2D.Create(WebGMapsGeocoder.ResultLatitude, WebGMapsGeocoder.ResultLongitude);
//      Result := True;
//    end
//    else
      Result := False;
  except
    Result := False;
  end;
end;

// завершение загрузки карты (с установкой маркеров при необходимости)
procedure TfrmMain.WebGMapDownloadFinish(Sender: TObject);
var
  i : integer; Location: TLocationCoord2D;

  function IsDelta(ALatitude, ALongitude : Double) : boolean;
  begin
    Result := Sqrt(Sqr(Location.Latitude - ALatitude) + Sqr(Location.Longitude - ALongitude)) > 0.003;
  end;

begin
//  if Assigned(FWebGMap) and not FMapLoaded then
//  begin
//    tErrorMap.Enabled := false;
//    FMapLoaded := True;
//
//    FWebGMap.Markers.Clear;
//
//    if FMarkerList.Count > 0 then
//    begin
//      Location := TLocationCoord2D.Create(FMarkerList[0].Latitude, FMarkerList[0].Longitude);
//      for i := 0 to FMarkerList.Count - 1 do if (i = 0) or IsDelta(FMarkerList[I].Latitude, FMarkerList[I].Longitude) then
//      begin
//        Location := TLocationCoord2D.Create(FMarkerList[I].Latitude, FMarkerList[i].Longitude);
//        with FWebGMap.Markers.Add(FMarkerList[i].Latitude, FMarkerList[i].Longitude, FMarkerList[i].Address, '', True, True, False, True, False, 0, TMarkerIconColor.icDefault, -1, -1, -1, -1) do
//          if tcMain.ActiveTab = tiPathOnMap then
//            MapLabel.Text := IntToStr(i + 1) + ') ' + FormatDateTime('DD.MM.YYYY hh:mm:ss', FMarkerList[i].VisitTime)
//          else
//            MapLabel.Text := Title;
//      end;
//
//      FWebGMap.MapPanTo(FWebGMap.Markers[0].Latitude, FWebGMap.Markers[0].Longitude);
//    end;
//
//    pMapButtons.Enabled := true;
//  end;
end;

// переход на форму отображения большой карты
procedure TfrmMain.ShowBigMap;
begin
  SwitchToForm(tiMap, nil);

  FMapLoaded := False;

//  FWebGMap := TTMSFMXWebGMaps.Create(Self);
//  FWebGMap.OnDownloadFinish := WebGMapDownloadFinish;
//  FWebGMap.Align := TAlignLayout.Client;
//  FWebGMap.MapOptions.ZoomMap := 13;
//  FWebGMap.Parent := tiMap;
//  FWebGMap.APIKey := DM.tblObject_ConstAPIKey.AsString;
end;

// вызов карты с координатами ТТ
procedure TfrmMain.GetPartnerMap(GPSN, GPSE: Double; Address: string);
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
      FMarkerList.Add(TLocationData.Create(GPSN, GPSE, 0, Address));
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

//    FWebGMap := TTMSFMXWebGMaps.Create(Self);
//    FWebGMap.Align := TAlignLayout.Client;
//    {FWebGMap.ControlsOptions.PanControl.Visible := false;
//    FWebGMap.ControlsOptions.ZoomControl.Visible := false;
//    FWebGMap.ControlsOptions.MapTypeControl.Visible := false;
//    FWebGMap.ControlsOptions.ScaleControl.Visible := false;
//    FWebGMap.ControlsOptions.StreetViewControl.Visible := false;
//    FWebGMap.ControlsOptions.OverviewMapControl.Visible := false;
//    FWebGMap.ControlsOptions.RotateControl.Visible := false;
//    }
//    FWebGMap.MapOptions.ZoomMap := 18;
//    FWebGMap.Parent := pMap;
//    FWebGMap.APIKey := DM.tblObject_ConstAPIKey.AsString;
//    FWebGMap.OnDownloadFinish := WebGMapDownloadFinish;
//    if SetCordinate then
//    begin
//      FWebGMap.CurrentLocation.Latitude := Coordinates.Latitude;
//      FWebGMap.CurrentLocation.Longitude := Coordinates.Longitude;
//    end;

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

procedure TfrmMain.ClearListSearch(AList: TListView);
var
  i: integer;
begin
  for I := 0 to AList.Controls.Count-1 do
    if AList.Controls[I].ClassType = TSearchBox then
    begin
      TSearchBox(AList.Controls[I]).Text := '';
      break;
    end;
end;

// обработка изменения закладки (формы)
procedure TfrmMain.ChangeMainPageUpdate(Sender: TObject);
var
  TaskCount : integer;
begin
  FUseAdminRights := false;

//  if Assigned(FWebGMap) then
//  try
//    FWebGMap.Visible := False;
//    FreeAndNil(FWebGMap);
//  except
//    // buggy piece of shit
//  end;

  { настройка панели возврата }
  if (tcMain.ActiveTab = tiStart) or (tcMain.ActiveTab = tiGoodsItems) or (tcMain.ActiveTab = tiSubjectDoc) or (tcMain.ActiveTab = tiCamera)  then
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

    if tcMain.ActiveTab = tiInformation then
      pAdmin.Visible := true
    else
      pAdmin.Visible := false;

    if tcMain.ActiveTab = tiPartnerInfo then
    begin
      if DM.qryPartnerIsOrderMin.AsBoolean = TRUE
      then
         lCaption.Text := DM.qryPartnerFullName.AsString + ' (+)мин.заказ'
      else
         lCaption.Text := DM.qryPartnerFullName.AsString + ' (-)мин.заказ';
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
    if tcMain.ActiveTab = tiDocItems then
      lCaption.Text := 'Акт сверки, содержимое документа'
    else
    if tcMain.ActiveTab = tiNewPartner then
      lCaption.Text := 'Ввод новой ТТ'
    else
    if tcMain.ActiveTab = tiOrderExternal then
      if DM.qryPartnerIsOrderMin.AsBoolean = TRUE
      then
         lCaption.Text := DM.cdsOrderExternalPartnerFullName.AsString + ' (+)мин.заказ'
      else
         lCaption.Text := DM.cdsOrderExternalPartnerFullName.AsString + ' (-)мин.заказ'
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
    ClearListSearch(lwGoodsItems);

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
    SetLength(gc_WebServers, 1);

    if DM.tblObject_ConstWebService_two.AsString <> '' then
      SetLength(gc_WebServers, 2);

    if DM.tblObject_ConstWebService_three.AsString <> '' then
      SetLength(gc_WebServers_r, 1);

    if DM.tblObject_ConstWebService_four.AsString <> '' then
      SetLength(gc_WebServers_r, 2);

    gc_WebServers[0] := DM.tblObject_ConstWebService.AsString;

    if DM.tblObject_ConstWebService_two.AsString <> '' then
      gc_WebServers[1] := DM.tblObject_ConstWebService_two.AsString;

    if DM.tblObject_ConstWebService_three.AsString <> '' then
      gc_WebServers_r[0] := DM.tblObject_ConstWebService_three.AsString;

    if DM.tblObject_ConstWebService_four.AsString <> '' then
      gc_WebServers_r[1] := DM.tblObject_ConstWebService_four.AsString;

    gc_WebService := gc_WebServers[0];

    if FTemporaryServer = '' then
      FTemporaryServer := gc_WebServers[0];

    WebServerLayout.Height := 0;
    CurWebServerLayout.Height := 0;
    SyncLayout.Visible := true;
    //
    pBackup_two.Visible := false;
    pOptimizeDB_two.Visible := false;
  end
  else
  begin
    FreeAndNil(gc_User);
    SetLength(gc_WebServers, 0);
    gc_WebService := '';

    WebServerLayout.Height := 75;
    CurWebServerLayout.Height := 0;
    SyncLayout.Visible := false;
  end;
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

  with DM.tblObject_Partner do
  begin
    Filter := 'isErased = 0';
    Filtered := True;
    Open;

    First;
    while not Eof do
    begin
      Schedule := FieldByName('Schedule').AsString;
      if Schedule.Length <> 13 then
      begin
        ShowMessage('Ошибка в структуре поля Schedule');
        Exit;
      end
      else
      begin
        for i := 1 to 7 do
          if Schedule[2 * i - 2 + Low(string)] = 't' then
            Inc(DaysCount[i]);
      end;
      Inc(DaysCount[8]);

      Next;
    end;

    Close;
    Filtered := False;
    Filter := '';
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
//or
//    Open('SELECT Id, ValueData, group_concat(distinct CONTRACTID) ContractIds from OBJECT_JURIDICAL ' +
//      'where ISERASED = 0 GROUP BY ID order by ValueData');
//or
    Open(
       ' SELECT '
     + '         Id '
     + '       , ValueData '
     + '       , group_concat(distinct ContractId) AS ContractIds '
     + ' FROM  Object_Juridical '
     + ' WHERE isErased = 0 '
     + ' GROUP BY Id '
     + ' ORDER BY ValueData '
        );
    First;

    while not Eof do
    begin
      AddComboItem(cbNewPartnerJuridical, FieldByName('ValueData').AsString);
      FJuridicalList.Add(TJuridicalItem.Create(FieldByName('Id').AsInteger,
        FieldByName('ValueData').AsString, FieldByName('ContractIds').AsString));

      Next;
    end;

    Close;
  end;

  SwitchToForm(tiNewPartner, nil);
end;

procedure TfrmMain.eSubjectDocClick(Sender: TObject);
begin
  FSubjectDocItem := 'ReturnIn';

  DM.GenerateReturnInSubjectDoc;

  if FReturnInSubjectDocId <> 0 then DM.qrySubjectDoc.Locate('Id', FReturnInSubjectDocId, []);

  SwitchToForm(tiSubjectDoc, Nil);
end;

// переход на форму отображения списка ТТ, которые необходимо посетить в указаный день
procedure TfrmMain.ShowPartners(Day : integer; Caption : string);
var
  sQuery, CurGPSN, CurGPSE : string;
  I: Integer;
  lDay: TLabel;
begin
  if Day < 9 then
    for I := 0 to Pred(ComponentCount) do
      if (Components[I] is TLabel) then
      begin
        lDay := Components[I] as TLabel;
        if (lDay.Tag = Day) and (lDay.Text = '0') then
          Exit;
      end;

  ClearListSearch(lwPartner);

  GetCurrentCoordinates;

  lDayInfo.Text := 'МАРШРУТ: ' + Caption;
  DM.qryPartner.Close;

  sQuery := ReplaceStr(BasePartnerQuery, 'CURRENT_DATE', 'DATE (''' + FormatDateTime('yyyy-mm-dd', Date) + ''')');

  if Day < 8 then
//or    sQuery := sQuery + ' and lower(substr(P.SCHEDULE, ' + IntToStr(2 * Day - 1) + ', 1)) = ''t''';
    sQuery := sQuery + ' and lower(substr(Object_Partner.Schedule, ' + IntToStr(2 * Day - 1) + ', 1)) = ''t''';

  if FCurCoordinatesSet then
  begin
    CurGPSN := FloatToStr(FCurCoordinates.Latitude);
    CurGPSE := FloatToStr(FCurCoordinates.Longitude);
    CurGPSN := StringReplace(CurGPSN, ',', '.', [rfReplaceAll]);
    CurGPSE := StringReplace(CurGPSE, ',', '.', [rfReplaceAll]);
//or
//    sQuery := sQuery + ' order by ((IFNULL(P.GPSN, 0) - ' + CurGPSN + ') * ' + LatitudeRatio + ') * ' +
//      '((IFNULL(P.GPSN, 0) - ' + CurGPSN + ') * ' + LatitudeRatio + ') + ' +
//      '((IFNULL(P.GPSE, 0) - ' + CurGPSE + ') * ' + LongitudeRatio + ') * ' +
//      '((IFNULL(P.GPSE, 0) - ' + CurGPSE + ') * ' + LongitudeRatio + ')' +
//      ', Name';
//or
    sQuery := sQuery + ' order by ((IFNULL(Object_Partner.GPSN, 0) - ' + CurGPSN + ') * ' + LatitudeRatio + ') * ' +
      '((IFNULL(Object_Partner.GPSN, 0) - ' + CurGPSN + ') * ' + LatitudeRatio + ') + ' +
      '((IFNULL(Object_Partner.GPSE, 0) - ' + CurGPSE + ') * ' + LongitudeRatio + ') * ' +
      '((IFNULL(Object_Partner.GPSE, 0) - ' + CurGPSE + ') * ' + LongitudeRatio + ')' +
      ', Name, Address';



  end
  else
    sQuery := sQuery + ' order by Name, Address';

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
  lShortName.Text := DM.qryPartnerShortName.AsString;
  lPartnerAddress.Text := DM.qryPartnerAddress.AsString;
  if (DM.qryPartnerGPSN.AsFloat <> 0) and (DM.qryPartnerGPSE.AsFloat <> 0) then
    lPartnerAddressGPS.Text := GetAddress(DM.qryPartnerGPSN.AsFloat, DM.qryPartnerGPSE.AsFloat)
  else
    lPartnerAddressGPS.Text := '-';

  lContractName.Text := DM.qryPartnerContractName.AsString;

  if DM.qryPartnerChangePercent.AsFloat < -0.0001 then
    lChangePercent.Text := FormatFloat(',0.##', Abs(DM.qryPartnerChangePercent.AsFloat)) + '%'
  else
    lChangePercent.Text := '-';

  if DM.qryPartnerisOperDateOrder.AsBoolean then
    lOperDateOrder.Text := 'по дате заявки'
  else
    lOperDateOrder.Text := 'по дате отгрузки';

  // информация о долгах ТТ
  if DM.qryPartnerPaidKindId.AsInteger = DM.tblObject_ConstPaidKindId_First.AsInteger then // БН
  begin
    lContractName.Text := DM.tblObject_ConstPaidKindName_First.AsString + ' - ' + DM.qryPartnerContractName.AsString;

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

    DM.qrySelect.Open(
       ' SELECT '
     + '         SUM(DebtSum) '
     + '       , SUM(OverSum) '
     + '       , MAX(OverDays) '
     + ' FROM  Object_Juridical '
     + ' WHERE Id = ' + DM.qryPartnerJuridicalId.AsString
     + ' GROUP BY Id '
                     );

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
    lContractName.Text := DM.tblObject_ConstPaidKindName_Second.AsString + ' - ' + DM.qryPartnerContractName.AsString;

    gbPartnerDebt.Text := 'Долги ТТ по выбранному контракту';
    lPartnerDebt.Text := FormatFloat(',0.##', DM.qryPartnerDebtSum.AsFloat);
    lPartnerOver.Text := FormatFloat(',0.##', DM.qryPartnerOverSum.AsFloat);
    lPartnerOverDay.Text := DM.qryPartnerOverDays.AsString;

    DM.qrySelect.Open(
       ' SELECT  '
     + '         SUM(DebtSum) '
     + '       , SUM(OverSum) '
     + '       , MAX(OverDays) '
     + ' FROM  Object_Partner '
     + ' WHERE Id = ' + DM.qryPartnerId.AsString
     + ' GROUP BY Id '
                     );

    gbPartnerAllDebt.Text := 'Долги ТТ по всем контрактам';
    lPartnerAllDebt.Text := FormatFloat(',0.##', DM.qrySelect.Fields[0].AsFloat);
    lPartnerAllOver.Text := FormatFloat(',0.##', DM.qrySelect.Fields[1].AsFloat);
    lPartnerAllOverDay.Text := DM.qrySelect.Fields[2].AsString;

    DM.qrySelect.Close;
  end
  else  // нет договора
  begin
    lContractName.Text := DM.qryPartnerContractName.AsString;
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
  TListItemText(CurItem.Objects.FindDrawable('SubjectDocName')).Text := DM.cdsReturnInSubjectDocName.AsString;

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
      TListItemText(NewItem.Objects.FindDrawable('SubjectDocName')).Text := DM.cdsReturnInSubjectDocName.AsString;
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

  CalculateDocCashTotal;
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

{ вычисление итоговой суммы оплат за товары }
procedure TfrmMain.CalculateDocCashTotal;
var
  TotalAmount: Currency;
begin
  TotalAmount := 0;
  DM.qryCash.First;

  while not DM.qryCash.Eof do
  begin
    if DM.qryCashStatusId.AsInteger <> DM.tblObject_ConstStatusId_Erased.AsInteger then
      TotalAmount := TotalAmount + DM.qryCashAmount.AsFloat;

    DM.qryCash.Next;
  end;

  lTotalCash.Text := 'Итого : ' + FormatFloat(',0.00', TotalAmount);
end;

// переход на форму отображения документов
procedure TfrmMain.ShowDocuments;
begin
  FEditDocuments := true;

  deStartDoc.Date := Date();
  deEndDoc.Date := IncDay(Date(), DM.tblObject_ConstOperDate_diff.AsInteger);

  bRefreshDocClick(bRefreshDoc);

  SwitchToForm(tiDocuments, nil);
  tcDocuments.ActiveTab := tiStoreRealDocs;
end;

// начитка и отображение прайс-листов
procedure TfrmMain.ShowPriceLists;
begin
//or
//  DM.qryPriceList.Open('SELECT ID, VALUEDATA, PRICEWITHVAT, VATPERCENT from OBJECT_PRICELIST where ISERASED = 0');
//or
  DM.qryPriceList.Open(
       ' SELECT  '
     + '         Id '
     + '       , ValueData '
     + '       , PriceWithVAT '
     + '       , VATPercent  '
     + ' FROM  Object_PriceList '
     + ' WHERE isErased = 0 '
                      );

  lwPriceList.ScrollViewPos := 0;
  SwitchToForm(tiPriceList, DM.qryPriceList);
end;

// начитка и отображение товаров по выбраному працс-листу
procedure TfrmMain.ShowPriceListItems(FullInfo: boolean);
begin
  lCaption.Text := 'Прайс-лист "' + DM.qryPriceListValueData.AsString + '"';

  if FullInfo then
  begin
    ClearListSearch(lwPriceListFullGoods);

    DM.qryGoodsFullForPriceList.Open(
        ' SELECT '
      + '         Object_Goods.ID '
      + '       , Object_Goods.ObjectCode '
      + '       , Object_Goods.ValueData                 AS GoodsName '
      + '       , Object_GoodsKind.ValueData             AS KindName '
      + '       , Object_PriceListItems.OrderPrice       AS OrderPrice '
      + '       , Object_PriceListItems.SalePrice        AS SalePrice '
      + '       , Object_PriceListItems.ReturnPrice      AS ReturnPrice '
      + '       , Object_Measure.ValueData               AS Measure '
      + '       , Object_PriceListItems.OrderStartDate   AS OrderStartDate '
      + '       , Object_PriceListItems.OrderEndDate     AS OrderEndDate '
      + '       , Object_PriceListItems.SaleStartDate    AS SaleStartDate '
      + '       , Object_PriceListItems.SaleEndDate      AS SaleEndDate '
      + '       , Object_PriceListItems.ReturnStartDate  AS ReturnStartDate '
      + '       , Object_PriceListItems.ReturnEndDate    AS ReturnEndDate '
      + '       , Object_TradeMark.ValueData             AS TradeMarkName '
      + ' FROM  Object_PriceListItems '
      + '       JOIN Object_Goods                 ON Object_Goods.ID                  = Object_PriceListItems.GoodsId '
      + '                                        AND Object_Goods.isErased            = 0 '
      + '       LEFT JOIN Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.GoodsId  = Object_Goods.ID '
      + '                                        AND Object_GoodsByGoodsKind.isErased = 0 '
      + '       LEFT JOIN Object_GoodsKind        ON Object_GoodsKind.ID              = COALESCE(NULLIF(Object_PriceListItems.GoodsKindId, 0), Object_GoodsByGoodsKind.GoodsKindId) '
      + '       LEFT JOIN Object_Measure          ON Object_Measure.ID                = Object_Goods.MeasureId '
      + '       LEFT JOIN Object_TradeMark        ON Object_TradeMark.ID              = Object_Goods.TradeMarkId '
      + ' WHERE Object_PriceListItems.PriceListId = ' + DM.qryPriceListId.AsString
      + ' ORDER BY Object_Goods.ValueData '
                              );

    lwPriceListFullGoods.ScrollViewPos := 0;
    SwitchToForm(tiPriceListItemsFull, DM.qryGoodsFullForPriceList);
  end
  else
  begin
    ClearListSearch(lwPriceListGoods);

    DM.qryGoodsForPriceList.Open(
        ' SELECT '
      + '         Object_Goods.ID '
      + '       , Object_Goods.ObjectCode '
      + '       , Object_Goods.ValueData                 AS GoodsName '
      + '       , Object_GoodsKind.ValueData             AS KindName '
      + '       , Object_PriceListItems.OrderPrice       AS Price '
      + '       , Object_Measure.ValueData               AS Measure '
      + '       , Object_PriceListItems.OrderStartDate   AS StartDate '
      + '       , Object_TradeMark.ValueData             AS TradeMarkName '
      + ' FROM  Object_PriceListItems '
      + '       JOIN Object_Goods                 ON Object_Goods.ID                  = Object_PriceListItems.GoodsId '
      + '                                        AND Object_Goods.isErased            = 0 '
      + '       LEFT JOIN Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.GoodsId  = Object_Goods.ID '
      + '                                        AND Object_GoodsByGoodsKind.isErased = 0 '
      + '       LEFT JOIN Object_GoodsKind        ON Object_GoodsKind.ID              = COALESCE(NULLIF(Object_PriceListItems.GoodsKindId, 0), Object_GoodsByGoodsKind.GoodsKindId) '
      + '       LEFT JOIN Object_Measure          ON Object_Measure.ID                = Object_Goods.MeasureId '
      + '       LEFT JOIN Object_TradeMark        ON Object_TradeMark.ID              = Object_Goods.TradeMarkId '
      + ' WHERE Object_PriceListItems.PriceListId = ' + DM.qryPriceListId.AsString
      + ' ORDER BY Object_Goods.ValueData '
                              );

    lwPriceListGoods.ScrollViewPos := 0;
    SwitchToForm(tiPriceListItems, DM.qryGoodsForPriceList);
  end;
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
  ClearListSearch(lwPromoGoods);
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
      ' SELECT '
    + '         Object_Goods.ObjectCode '
    + '       , Object_Goods.ValueData         AS GoodsName '
    + '       , Object_TradeMark.ValueData     AS TradeMarkName '
    + '       , CASE WHEN MovementItem_PromoGoods.GoodsKindId = 0 THEN ''все виды'' ELSE Object_GoodsKind.ValueData END  AS KindName '
    + '       , ''Скидка '' || MovementItem_PromoGoods.TaxPromo || ''%''                     AS Tax '
    + '       , ''Акционная цена: '' || MovementItem_PromoGoods.PriceWithOutVAT || '' (с НДС '' || MovementItem_PromoGoods.PriceWithVAT || '') за '' || Object_Measure.ValueData   AS Price '
    + '       , ''Акция заканчивается '' || strftime(''%d.%m.%Y'', Movement_Promo.EndSale)   AS Termin '
    + '       , Movement_Promo.Id              AS PromoId '
    + ' FROM  MovementItem_PromoGoods '
    + '       JOIN Movement_Promo        ON Movement_Promo.Id   = MovementItem_PromoGoods.MovementId '
    + '       LEFT JOIN Object_Goods     ON Object_Goods.Id     = MovementItem_PromoGoods.GoodsId '
    + '       LEFT JOIN Object_Measure   ON Object_Measure.Id   = Object_Goods.MeasureId '
    + '       LEFT JOIN Object_TradeMark ON Object_TradeMark.Id = Object_Goods.TradeMarkId '
    + '       LEFT JOIN Object_GoodsKind ON Object_GoodsKind.Id = MovementItem_PromoGoods.GoodsKindId '
    + ' WHERE MovementItem_PromoGoods.MovementId IN (' + DM.qryPromoPartnersPromoIds.AsString + ') '
    + ' ORDER BY Object_Goods.ValueData, Movement_Promo.EndSale ';
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
//or
//  DM.qryPromoPartners.SQL.Text := 'select J.VALUEDATA PartnerName, OP.ADDRESS, ' +
//    'CASE WHEN PP.CONTRACTID = 0 THEN ''все договора'' ELSE C.CONTRACTTAGNAME || '' '' || C.VALUEDATA END ContractName, ' +
//    'PP.PARTNERID, PP.CONTRACTID, group_concat(distinct PP.MOVEMENTID) PromoIds ' +
//    'from MOVEMENTITEM_PROMOPARTNER PP ' +
//    'LEFT JOIN OBJECT_PARTNER OP ON OP.ID = PP.PARTNERID AND (OP.CONTRACTID = PP.CONTRACTID OR PP.CONTRACTID = 0) ' +
//    'LEFT JOIN OBJECT_JURIDICAL J ON J.ID = OP.JURIDICALID AND J.CONTRACTID = OP.CONTRACTID ' +
//    'LEFT JOIN OBJECT_CONTRACT C ON C.ID = PP.CONTRACTID ' +
//    'WHERE PP.MOVEMENTID = :PROMOID ' +
//    'GROUP BY PP.PARTNERID, PP.CONTRACTID ' +
//    'ORDER BY J.VALUEDATA, OP.ADDRESS';
//or


  DM.qryPromoPartners.SQL.Text :=
      ' SELECT '
    + '         Object_JurIdical.ValueData AS PartnerName '
    + '       , Object_Partner.Address '
    + '       , CASE WHEN MovementItem_PromoPartner.ContractId = 0 THEN ''все договора'' ELSE Object_Contract.ContractTagName || '' '' || Object_Contract.ValueData END AS ContractName '
    + '       , MovementItem_PromoPartner.PartnerId '
    + '       , MovementItem_PromoPartner.ContractId '
    + '       , group_concat(distinct MovementItem_PromoPartner.MovementId) AS PromoIds '
    + ' FROM  MovementItem_PromoPartner '
    + '       LEFT JOIN Object_Partner   ON Object_Partner.Id                      = MovementItem_PromoPartner.PartnerId '
    + '                                  AND (Object_Partner.ContractId            = MovementItem_PromoPartner.ContractId '
    + '                                    OR MovementItem_PromoPartner.ContractId = 0) '
    + '       LEFT JOIN Object_JurIdical ON Object_JurIdical.Id                    = Object_Partner.JurIdicalId '
    + '                                 AND Object_JurIdical.ContractId            = Object_Partner.ContractId '
    + '       LEFT JOIN Object_Contract  ON Object_Contract.Id                     = MovementItem_PromoPartner.ContractId '
    + ' WHERE MovementItem_PromoPartner.MovementId = :PROMOId '
    + ' GROUP BY MovementItem_PromoPartner.PartnerId, MovementItem_PromoPartner.ContractId '
    + ' ORDER BY Object_JurIdical.ValueData, Object_Partner.Address ';
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
//or
//  DM.qryPhotos.Open('SELECT Id, Photo, Comment, isErased, isSync from MovementItem_Visit where MovementId = ' + IntToStr(GroupId) +
//    ' and isErased = 0');
//or
  DM.qryPhotos.Open(
     ' SELECT '
   + '         Id '
   + '       , Photo '
   + '       , Comment '
   + '       , isErased '
   + '       , isSync  '
   + ' FROM  MovementItem_Visit '
   + ' WHERE MovementId = ' + IntToStr(GroupId)
   + '   and isErased = 0 '
                   );

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
  pBackup.Visible := false;
  pOptimizeDB.Visible := false;

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
  eWebService.Text := DM.tblObject_ConstWebService.AsString
            + ' ; ' + DM.tblObject_ConstWebService_two.AsString
            + ' ; ' + DM.tblObject_ConstWebService_three.AsString
            + ' ; ' + DM.tblObject_ConstWebService_four.AsString
    ;

  if not SameText(gc_WebService, DM.tblObject_ConstWebService.AsString) then
  begin
    lCurWebService.Height := 60;
    eCurWebService.Text := gc_WebService;
    if High(gc_WebServers) > 1 then eCurWebService.Text := eCurWebService.Text+ ' ; ' + gc_WebServers[1];
    if High(gc_WebServers_r) > 0 then eCurWebService.Text := eCurWebService.Text+ ' ; ' + gc_WebServers_r[0];
    if High(gc_WebServers_r) > 1 then eCurWebService.Text := eCurWebService.Text+ ' ; ' + gc_WebServers_r[1];
  end
  else
    lCurWebService.Height := 0;
  eSyncDateIn.Text := FormatDateTime('DD.MM.YYYY hh:nn:ss', DM.tblObject_ConstSyncDateIn.AsDateTime);
  eSyncDateOut.Text := FormatDateTime('DD.MM.YYYY hh:nn:ss', DM.tblObject_ConstSyncDateOut.AsDateTime);

  eReturnDayCount.Text :=  DM.tblObject_ConstReturnDayCount.AsString;

  eCriticalWeight.Text :=  DM.tblObject_ConstCriticalWeight.AsString;

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
  ClearListSearch(lwStoreRealItems);

  for i := 0 to FCheckedGooodsItems.Count - 1 do
    DM.AddedGoodsToStoreReal(FCheckedGooodsItems[i]);

  FCheckedGooodsItems.Clear;
end;

// добавление новых товаров в завку на товары
procedure TfrmMain.AddedNewOrderItems;
var
  i: integer;
begin
  ClearListSearch(lwOrderExternalItems);

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
  ClearListSearch(lwReturnInItems);

  for i := 0 to FCheckedGooodsItems.Count - 1 do
    DM.AddedGoodsToReturnIn(FCheckedGooodsItems[i]);

  if FReturnInSubjectDocName <> eSubjectDoc.Text then eSubjectDoc.Text := FReturnInSubjectDocName;

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
      if DM.cdsOrderItemsisChangePercent.AsBoolean
      then
        PriceWithPercent := MyRound_2 (DM.cdsOrderItemsCount.AsFloat
                                     * MyRound_2 (DM.cdsOrderItemsPrice.AsFloat * (1 + DM.cdsOrderExternalChangePercent.AsCurrency/100)))
      else
        PriceWithPercent := MyRound_2 (DM.cdsOrderItemsPrice.AsFloat * DM.cdsOrderItemsCount.AsFloat);

      TotalPriceWithPercent := TotalPriceWithPercent + PriceWithPercent;

      if DM.cdsOrderExternalPriceWithVAT.AsBoolean then
        FOrderTotalPrice := FOrderTotalPrice + PriceWithPercent
      else
        //добавить НДС - потом, на всю сумму
        // FOrderTotalPrice := FOrderTotalPrice + PriceWithPercent * (100 + DM.cdsOrderExternalVATPercent.AsCurrency) / 100;
        FOrderTotalPrice := FOrderTotalPrice + PriceWithPercent;

      if FormatFloat('0.##', DM.cdsOrderItemsWeight.AsFloat) <> '0' then
        FOrderTotalCountKg := FOrderTotalCountKg + DM.cdsOrderItemsWeight.AsFloat * DM.cdsOrderItemsCount.AsFloat
      else
        FOrderTotalCountKg := FOrderTotalCountKg + DM.cdsOrderItemsCount.AsFloat;

      DM.cdsOrderItems.Next;
    end;

    //добавили НДС - на всю сумму
    if DM.cdsOrderExternalPriceWithVAT.AsBoolean = FALSE
    then
       FOrderTotalPrice := MyRound_2 (FOrderTotalPrice * (1 + DM.cdsOrderExternalVATPercent.AsCurrency / 100));

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
      lPriceWithPercent.Text := Format('%s (', [sCostWithExtraCharge]) +
        FormatFloat(',0.00', DM.cdsOrderExternalChangePercent.AsCurrency) + '%) : ' + FormatFloat(',0.00', TotalPriceWithPercent)
    else
      lPriceWithPercent.Text := Format('%s (', [sCostWithDiscount]) +
        FormatFloat(',0.00', -DM.cdsOrderExternalChangePercent.AsCurrency) + '%) : ' + FormatFloat(',0.00', TotalPriceWithPercent);
  end;

  lTotalPrice.Text := Format('%s : ', [sTotalCostWithVAT]) + FormatFloat(',0.00', FOrderTotalPrice);

  lTotalWeight.Text := Format('%s : ', [sTotalWeight]) + FormatFloat(',0.00', FOrderTotalCountKg);
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
      // сумма по строкам - округление до 2-х знаков
      if DM.cdsReturnInChangePercent.AsCurrency <> 0
      then
        PriceWithPercent :=  MyRound_2 (DM.cdsReturnInItemsCount.AsFloat
                                      * MyRound_2(DM.cdsReturnInItemsPrice.AsFloat * (1 + DM.cdsReturnInChangePercent.AsCurrency/100)))
      else
        PriceWithPercent :=  MyRound_2 (DM.cdsReturnInItemsCount.AsFloat
                                      * DM.cdsReturnInItemsPrice.AsFloat);

      TotalPriceWithPercent := TotalPriceWithPercent + PriceWithPercent;

      if DM.cdsReturnInPriceWithVAT.AsBoolean then
        FReturnInTotalPrice := FReturnInTotalPrice + PriceWithPercent
      else
         //добавить НДС - потом, на всю сумму
         //FReturnInTotalPrice := FReturnInTotalPrice + PriceWithPercent * (100 + DM.cdsReturnInVATPercent.AsCurrency) / 100;
         FReturnInTotalPrice := FReturnInTotalPrice + PriceWithPercent;

      if FormatFloat('0.##', DM.cdsReturnInItemsWeight.AsFloat) <> '0' then
        FReturnInTotalCountKg := FReturnInTotalCountKg + DM.cdsReturnInItemsWeight.AsFloat * DM.cdsReturnInItemsCount.AsFloat
      else
        FReturnInTotalCountKg := FReturnInTotalCountKg + DM.cdsReturnInItemsCount.AsFloat;

      DM.cdsReturnInItems.Next;
    end;
    //добавили НДС - на всю сумму
    if DM.cdsReturnInPriceWithVAT.AsBoolean = FALSE
    then
      FReturnInTotalPrice := MyRound_2 (FReturnInTotalPrice * (1 + DM.cdsReturnInVATPercent.AsCurrency / 100));

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
      lPriceWithPercentReturn.Text := Format('%s (', [sCostWithExtraCharge]) +
        FormatFloat(',0.00', DM.cdsReturnInChangePercent.AsCurrency) + '%) : ' + FormatFloat(',0.00', TotalPriceWithPercent)
    else
      lPriceWithPercentReturn.Text := Format('%s (', [sCostWithDiscount]) +
        FormatFloat(',0.00', -DM.cdsReturnInChangePercent.AsCurrency) + '%) : ' + FormatFloat(',0.00', TotalPriceWithPercent);
  end;

  lTotalPriceReturn.Text := Format('%s : ', [sTotalCostWithVAT]) + FormatFloat(',0.00', FReturnInTotalPrice);

  lTotalWeightReturn.Text := Format('%s : ', [sTotalWeight]) + FormatFloat(',0.00', FReturnInTotalCountKg);
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

procedure TfrmMain.swPaidKindCClick(Sender: TObject);
begin
  FPaidKindChangedC := true;
end;

procedure TfrmMain.swPaidKindOClick(Sender: TObject);
begin
  FPaidKindChangedO := true;
end;

procedure TfrmMain.swPaidKindRClick(Sender: TObject);
begin
  FPaidKindChangedR := true;
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

  if tcMain.ActiveTab = tiGoodsItems then
    bsGoodsItems.DataSet := DM.qryGoodsItems;

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
          (Item.Data as TDataSet).Close;
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
      Showmessage(GetTextMessage(E));
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

procedure TfrmMain.ppEnterAmountClosePopup(Sender: TObject);
begin
  if FEditCashAmount then
  begin
    pEnterMovmentCash.Visible := true;
    FEditCashAmount := false;
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
  TimeGPS : Int64;
{$ENDIF}
begin
  FCurCoordinatesSet := false;
  FCurCoordinatesMsg := '_';
  FServiceNameMsg    := '?';

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
          if LocationManager.isProviderEnabled(TJLocationManager.JavaClass.GPS_PROVIDER) then
          begin
            LastLocation := LocationManager.getLastKnownLocation(TJLocationManager.JavaClass.GPS_PROVIDER);
            if Assigned(LastLocation) then
            begin
              TimeGPS := LastLocation.getTime;
              FCurCoordinates := TLocationCoord2D.Create(LastLocation.getLatitude, LastLocation.getLongitude);
              FServiceNameMsg:= 'gps';
              FCurCoordinatesSet := true;
            end
          end;

          //получаем последнее местоположение зафиксированное с помощью координат wi-fi и мобильных сетей
          if not FCurCoordinatesSet
          then
          if locationManager.isProviderEnabled(TJLocationManager.JavaClass.NETWORK_PROVIDER) then
          begin
            LastLocation := LocationManager.getLastKnownLocation(TJLocationManager.JavaClass.NETWORK_PROVIDER);
            if Assigned(LastLocation) and (not FCurCoordinatesSet or (TimeGPS < LastLocation.getTime)) then
            begin
              FCurCoordinates := TLocationCoord2D.Create(LastLocation.getLatitude, LastLocation.getLongitude);
              FServiceNameMsg:= 'net';
              FCurCoordinatesSet := true;
            end
          end;

          if not FCurCoordinatesSet then FCurCoordinatesMsg:= 'на телефоне не запущен Сервис или нет доступа к GPS или NETWORK сетям'
        end
        else
        begin
           FCurCoordinatesMsg:= 'нет доступа Сервиса к Менеджеру GPS';
          //raise Exception.Create('Could not access Location Manager');
        end;
    end
    else
    begin
      FCurCoordinatesMsg:= 'не запущен Сервис GPS';
      //raise Exception.Create('Could not locate Location Service');
    end;
  except
      FCurCoordinatesMsg:= 'ошибка при обращении к Сервису GPS';
  end;
  {$ELSE}
  if (FSensorCoordinates.Latitude <> 0) and (FSensorCoordinates.Longitude <> 0) then
  begin
    FCurCoordinates := TLocationCoord2D.Create(FSensorCoordinates.Latitude, FSensorCoordinates.Longitude);
    FCurCoordinatesSet := true;
    Exit;
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
