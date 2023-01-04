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
    bbPrintAgilis: TdxBarButton;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    HeaderSaver: THeaderSaver;
    spGet: TdsdStoredProc;
    RefreshAddOn: TRefreshAddOn;
    GridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    SetErased: TdsdUpdateErased;
    SetUnErased: TdsdUpdateErased;
    actShowErased: TBooleanStoredProcAction;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    cxLabel11: TcxLabel;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    GuidesFrom: TdsdGuides;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbMovementItemProtocol: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrintOld: TdsdStoredProc;
    bbCalcAmountPartner: TdxBarControlContainerItem;
    actGoodsKindChoice: TOpenChoiceForm;
    spInsertMaskMIMaster: TdsdStoredProc;
    actAddMask: TdsdExecStoredProc;
    bbAddMask: TdxBarButton;
    actGoodsChoiceForm: TOpenChoiceForm;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    bbInsertRecord: TdxBarButton;
    bbCompleteCost: TdxBarButton;
    bbactUnCompleteCost: TdxBarButton;
    bbactSetErasedCost: TdxBarButton;
    actShowErasedCost: TBooleanStoredProcAction;
    bbShowErasedCost: TdxBarButton;
    InsertRecordGoods: TInsertRecord;
    bbInsertRecordGoods: TdxBarButton;
    bbPrintSticker: TdxBarButton;
    bbPrintStickerTermo: TdxBarButton;
    bbMIContainerCost: TdxBarButton;
    actCheckDescService: TdsdExecStoredProc;
    actCheckDescTransport: TdsdExecStoredProc;
    actOpenFormService: TdsdOpenForm;
    actOpenFormTransport: TdsdOpenForm;
    macOpenFormService: TMultiAction;
    macOpenFormTransport: TMultiAction;
    bbOpenFormTransport: TdxBarButton;
    bbOpenFormService: TdxBarButton;
    Panel1: TPanel;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
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
    IsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    cxLabel17: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel18: TcxLabel;
    edInsertName: TcxButtonEdit;
    PrintItemsColorCDS: TClientDataSet;
    spSelectPrintOffer: TdsdStoredProc;
    spSelectPrintStructure: TdsdStoredProc;
    spSelectPrintOrderConfirmation: TdsdStoredProc;
    actPrintAgilis: TdsdPrintAction;
    actPrintStructure: TdsdPrintAction;
    actPrintOrderConfirmation: TdsdPrintAction;
    bbPrintStructure: TdxBarButton;
    bbPrintTender: TdxBarButton;
    spSelectMI_Child: TdsdStoredProc;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    actDBViewAddOnChild: TdsdDBViewAddOn;
    InsertRecordInfo: TInsertRecord;
    actUpdateDataSetInfoDS: TdsdUpdateDataSet;
    bbInsertRecordInfo: TdxBarButton;
    actRefreshInfo: TdsdDataSetRefresh;
    actMovementProtocolInfoOpenForm: TdsdOpenForm;
    bbProtocolInfoOpen: TdxBarButton;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    Article_ch3: TcxGridDBColumn;
    GoodsCode_ch3: TcxGridDBColumn;
    GoodsName_ch3: TcxGridDBColumn;
    AmountReserv_ch3: TcxGridDBColumn;
    Amount_ch3: TcxGridDBColumn;
    isErased_ch3: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    spInsert_MI_byOrderClient: TdsdStoredProc;
    actInsert_MI_byOrderClient: TdsdExecStoredProc;
    bbInsert_MI_byOrderClient: TdxBarButton;
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
    actChoiceFormOrderClient: TOpenChoiceForm;
    macInsert_MI_byorderclient: TMultiAction;
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
    actReceiptServiceChoiceForm: TOpenChoiceForm;
    actPersonalChoiceForm: TOpenChoiceForm;
    spSelectMI_Detail: TdsdStoredProc;
    cxGrid_Detail: TcxGrid;
    cxGridDBTableView_Det: TcxGridDBTableView;
    Article_ch4: TcxGridDBColumn;
    GoodsName_ch4: TcxGridDBColumn;
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
    InsertRecordDetail: TInsertRecord;
    spErasedMIDetail: TdsdStoredProc;
    SetErasedDetail: TdsdUpdateErased;
    SetUnErasedDetail: TdsdUpdateErased;
    spUnErasedMIDetail: TdsdStoredProc;
    bbInsertRecordDetail: TdxBarButton;
    bbSetErasedDetail: TdxBarButton;
    bbSetUnErasedDetail: TdxBarButton;
    cxTopSplitter: TcxSplitter;
    cxSplitter2: TcxSplitter;
    SetUnErasedChild: TdsdUpdateErased;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    bbSetUnErasedChild: TdxBarButton;
    InsertRecordBoat: TInsertRecord;
    actOrderClientInsertBoatForm: TOpenChoiceForm;
    bbb: TdxBarButton;
    actUpdateRecordBoat2: TOpenChoiceForm;
    actUpdateRecordBoat: TdsdInsertUpdateAction;
    bbUpdateRecordBoat: TdxBarButton;
    bbChoiceFormOrderClientItem: TdxBarButton;

  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderInternalForm);

end.
