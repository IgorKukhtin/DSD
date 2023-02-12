unit OrderInternal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdDB, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Datasnap.DBClient, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dxBar, Vcl.ExtCtrls, cxContainer, cxLabel, cxTextEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxButtonEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdGuides, Vcl.Menus, cxPCdxBarPopupMenu, cxPC, frxClass, frxDBSet,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit,
  cxImageComboBox, cxSplitter, cxBlobEdit;

type
  TOrderInternalForm = class(TParentForm)
    FormParams: TdsdFormParams;
    spSelectMI: TdsdStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    DataPanel: TPanel;
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    GuidesTo: TdsdGuides;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    HeaderSaver: THeaderSaver;
    spGet: TdsdStoredProc;
    RefreshAddOn: TRefreshAddOn;
    actGridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    actSetErased: TdsdUpdateErased;
    actSetUnErased: TdsdUpdateErased;
    actShowErased: TBooleanStoredProcAction;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    cxLabel11: TcxLabel;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    ceStatus: TcxButtonEdit;
    GuidesFrom: TdsdGuides;
    bbMIContainer: TdxBarButton;
    actMIMasterProtocolOpenForm: TdsdOpenForm;
    bbMovementItemProtocol: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spInsertMaskMIMaster: TdsdStoredProc;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    bbShowErasedCost: TdxBarButton;
    actInsertRecordGoods: TInsertRecord;
    bbInsertRecordGoods: TdxBarButton;
    bbPrintSticker: TdxBarButton;
    bbMIContainerCost: TdxBarButton;
    Panel1: TPanel;
    cxGrid_Master: TcxGrid;
    cxGrid_MasterDBTableView: TcxGridDBTableView;
    GoodsGroupNameFull: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    DescName: TcxGridDBColumn;
    Article: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    cxGrid_MasterLevel: TcxGridLevel;
    cxLabel17: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel18: TcxLabel;
    edInsertName: TcxButtonEdit;
    PrintItemsColorCDS: TClientDataSet;
    spSelectPrintOffer: TdsdStoredProc;
    spSelectPrintStructure: TdsdStoredProc;
    spSelectPrintOrderConfirmation: TdsdStoredProc;
    spSelectMI_Child: TdsdStoredProc;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    actDBViewAddOnChild: TdsdDBViewAddOn;
    bbMIChildProtocolOpenForm: TdxBarButton;
    cxGrid_Child: TcxGrid;
    cxGridDBTableView_child: TcxGridDBTableView;
    Article_ch3: TcxGridDBColumn;
    GoodsCode_ch3: TcxGridDBColumn;
    GoodsName_ch3: TcxGridDBColumn;
    AmountReserv_ch3: TcxGridDBColumn;
    Amount_ch3: TcxGridDBColumn;
    isErased_ch3: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    spInsert_MI_byOrderClient: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    SetErasedChild: TdsdUpdateErased;
    bbSetErasedChild: TdxBarButton;
    getMovementForm: TdsdStoredProc;
    actOpenForm: TdsdOpenForm;
    bbOpenDocument: TdxBarButton;
    macErasedMI_Master_list: TMultiAction;
    macErasedMI_Master: TMultiAction;
    bbErasedMI_Master: TdxBarButton;
    AmountSend_ch3: TcxGridDBColumn;
    actChoiceFormOrderClientItem: TOpenChoiceForm;
    UnitName_ch3: TcxGridDBColumn;
    cxLabel15: TcxLabel;
    cxLabel6: TcxLabel;
    edProduct: TcxButtonEdit;
    GuidesProduct: TdsdGuides;
    edOrderClient: TcxButtonEdit;
    GuidesOrderClient: TdsdGuides;
    spSelectPrint: TdsdStoredProc;
    isEnabled: TcxGridDBColumn;
    Comment_goods: TcxGridDBColumn;
    ProdColorName_goods: TcxGridDBColumn;
    ProdColorName_goods_ch3: TcxGridDBColumn;
    Comment_goods_ch3: TcxGridDBColumn;
    DetailCDS: TClientDataSet;
    DetailDS: TDataSource;
    DetailViewAddOn: TdsdDBViewAddOn;
    actChoiceFormReceiptService: TOpenChoiceForm;
    actPersonalChoiceForm: TOpenChoiceForm;
    spSelectMI_Detail: TdsdStoredProc;
    cxGrid_Detail: TcxGrid;
    cxGridDBTableView_Det: TcxGridDBTableView;
    Article_ch4: TcxGridDBColumn;
    ReceiptServiceCode_ch4: TcxGridDBColumn;
    ReceiptServiceName_ch4: TcxGridDBColumn;
    PersonalCode_ch4: TcxGridDBColumn;
    PersonalName_ch4: TcxGridDBColumn;
    Amount_ch4: TcxGridDBColumn;
    OperPrice_ch4: TcxGridDBColumn;
    Hours_ch4: TcxGridDBColumn;
    Summ_ch4: TcxGridDBColumn;
    Comment_ch4: TcxGridDBColumn;
    isErased_ch4: TcxGridDBColumn;
    cxGridLevel_Det: TcxGridLevel;
    spInsertUpdateMIDetail: TdsdStoredProc;
    actUpdateDetailDS: TdsdUpdateDataSet;
    actInsertRecordDetail: TInsertRecord;
    spErasedMIDetail: TdsdStoredProc;
    actSetErasedDetail: TdsdUpdateErased;
    actSetUnErasedDetail: TdsdUpdateErased;
    spUnErasedMIDetail: TdsdStoredProc;
    bbSetErasedDetail: TdxBarButton;
    bbSetUnErasedDetail: TdxBarButton;
    cxTopSplitter: TcxSplitter;
    cxSplitter2: TcxSplitter;
    SetUnErasedChild: TdsdUpdateErased;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    bbSetUnErasedChild: TdxBarButton;
    actInsertRecordBoat: TInsertRecord;
    actChoiceFormOrderClient: TOpenChoiceForm;
    bbb: TdxBarButton;
    bbUpdateRecordBoat: TdxBarButton;
    bbChoiceFormOrderClientItem: TdxBarButton;
    cxTabSheet1: TcxTabSheet;
    cxGrid2: TcxGrid;
    cxGridDBTableView_DetAll: TcxGridDBTableView;
    Amount_ch5: TcxGridDBColumn;
    isErased_ch5: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DetailCDS_All: TClientDataSet;
    DetailDS_All: TDataSource;
    DetailViewAddOn_All: TdsdDBViewAddOn;
    spSelectMI_DetailAll: TdsdStoredProc;
    acChoiceFormOrderInternalMaster_DetAll: TOpenChoiceForm;
    actPersonalChoiceForm_DetAll: TOpenChoiceForm;
    actChoiceFormReceiptService_DetAll: TOpenChoiceForm;
    spInsertUpdateMIDetailAll: TdsdStoredProc;
    bbInsertRecordDetailAll: TdxBarButton;
    actUpdateDetailDS_All: TdsdUpdateDataSet;
    spErasedMIDetailAll: TdsdStoredProc;
    actSetErasedDetail_All: TdsdUpdateErased;
    SetUnErasedDetail_All: TdsdUpdateErased;
    spUnErasedMIDetail_All: TdsdStoredProc;
    bbSetErasedDetail_All: TdxBarButton;
    bbSetUnErasedDetail_All: TdxBarButton;
    actInsertRecordDetailAll: TInsertRecord;
    actMIChildProtocolOpenForm: TdsdOpenForm;
    actMIDetailProtocolOpenForm: TdsdOpenForm;
    actMIDetailAllProtocolOpenForm: TdsdOpenForm;
    bbInsertRecordDetail: TdxBarButton;
    bbMIDetailProtocolOpenForm: TdxBarButton;
    bbMIDetailAllProtocolOpenForm: TdxBarButton;
    Article_ReceiptService_ch5: TcxGridDBColumn;
    ReceiptServiceCode_ch5: TcxGridDBColumn;
    BarSubItemBoat: TdxBarSubItem;
    BarSubItemGoods: TdxBarSubItem;
    BarSubItemGoodsSep2: TdxBarSeparator;
    BarSubItemGoodsSep1: TdxBarSeparator;
    BarSubItemGoodsChild: TdxBarSubItem;
    BarSubItemReceiptService: TdxBarSubItem;
    actSetErased_boat: TdsdUpdateErased;
    actSetUnErased_boat: TdsdUpdateErased;
    bbSetErased_boat: TdxBarButton;
    bbSetUnErased_boat: TdxBarButton;
    actMIMasterBoatProtocolOpenForm: TdsdOpenForm;
    bbMIMasterBoatProtocolOpenForm: TdxBarButton;
    BarSubItemBoatSep1: TdxBarSeparator;
    BarSubItemBoatSep2: TdxBarSeparator;
    bbChoiceFormReceiptService: TdxBarButton;
    bbChoiceFormReceiptService_DetAll: TdxBarButton;
    BarSubItemDetailSep1: TdxBarSeparator;
    BarSubItemDetailSep2: TdxBarSeparator;
    actInsertRecordChild: TInsertRecord;
    acChoiceFormGoods_child: TOpenChoiceForm;
    bbInsertRecordChild: TdxBarButton;
    bbOpenGoodsChoiceForm: TdxBarButton;
    BarSubItemChildSep1: TdxBarSeparator;
    BarSubItemChildSep2: TdxBarSeparator;
    actUpdateChildDS: TdsdUpdateDataSet;
    spInsertUpdateMIChild: TdsdStoredProc;

  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderInternalForm);

end.
