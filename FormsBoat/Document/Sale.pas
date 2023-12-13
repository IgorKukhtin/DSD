unit Sale;

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
  cxImageComboBox, cxSplitter, cxBlobEdit, Vcl.StdCtrls, cxButtons;

type
  TSaleForm = class(TParentForm)
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
    actUnCompleteMovement: TChangeGuidesStatus;
    actCompleteMovement: TChangeGuidesStatus;
    actDeleteMovement: TChangeGuidesStatus;
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
    actInsertRecordGoods: TInsertRecord;
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
    OperPrice: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    SummWithVAT: TcxGridDBColumn;
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
    actPrintAgilis: TdsdPrintAction;
    actPrintStructure: TdsdPrintAction;
    actPrintOrderConfirmation: TdsdPrintAction;
    bbPrintStructure: TdxBarButton;
    bbPrintTender: TdxBarButton;
    actInsertRecordInfo: TInsertRecord;
    actUpdateDataSetInfoDS: TdsdUpdateDataSet;
    bbInsertRecordInfo: TdxBarButton;
    actRefreshInfo: TdsdDataSetRefresh;
    actMovementProtocolInfoOpenForm: TdsdOpenForm;
    bbProtocolInfoOpen: TdxBarButton;
    spInsert_MI_byOrderClient: TdsdStoredProc;
    actInsert_MI_byOrderClient: TdsdExecStoredProc;
    bbInsert_MI_byOrderClient: TdxBarButton;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    actSetErasedChild: TdsdUpdateErased;
    bbSetErasedChild: TdxBarButton;
    getMovementForm: TdsdStoredProc;
    actOpenForm: TdsdOpenForm;
    bbOpenDocument: TdxBarButton;
    macErasedMI_Master_list: TMultiAction;
    macErasedMI_Master: TMultiAction;
    bbErasedMI_Master: TdxBarButton;
    cxLabel15: TcxLabel;
    ceParent: TcxButtonEdit;
    cxLabel9: TcxLabel;
    ceComment_parent: TcxTextEdit;
    GuidesParent: TdsdGuides;
    EngineNum: TcxGridDBColumn;
    EngineName: TcxGridDBColumn;
    actPartionGoodsChoiceForm: TOpenChoiceForm;
    actInsertRecordPartion: TInsertRecord;
    macInsertRecordPartion: TMultiAction;
    bbInsertRecordPartion: TdxBarButton;
    bbPartionGoodsChoiceForm: TdxBarButton;
    edVATPercent: TcxCurrencyEdit;
    cxLabel29: TcxLabel;
    cbPriceWithVAT: TcxCheckBox;
    cxLabel23: TcxLabel;
    edTaxKind: TcxButtonEdit;
    GuidesTaxKind: TdsdGuides;
    cxLabel14: TcxLabel;
    edInfo_TaxKind: TcxTextEdit;
    cxLabel31: TcxLabel;
    cxLabel32: TcxLabel;
    cxLabel8: TcxLabel;
    edBasis_summ_orig: TcxCurrencyEdit;
    edBasis_summ2_orig: TcxCurrencyEdit;
    edBasis_summ1_orig: TcxCurrencyEdit;
    cxLabel33: TcxLabel;
    cxLabel34: TcxLabel;
    edDiscountTax: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    cxLabel21: TcxLabel;
    cxLabel22: TcxLabel;
    edSummDiscount3: TcxCurrencyEdit;
    edSummDiscount2: TcxCurrencyEdit;
    edSummDiscount1: TcxCurrencyEdit;
    cxLabel38: TcxLabel;
    cxLabel39: TcxLabel;
    edBasis_summ: TcxCurrencyEdit;
    edSummDiscount_total: TcxCurrencyEdit;
    cxLabel26: TcxLabel;
    cxLabel40: TcxLabel;
    edSummTax: TcxCurrencyEdit;
    cxLabel27: TcxLabel;
    cxLabel28: TcxLabel;
    edVATPercent_order: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    cxLabel30: TcxLabel;
    edDiscountNextTax: TcxCurrencyEdit;
    edSummReal: TcxCurrencyEdit;
    edTransportSumm_load: TcxCurrencyEdit;
    edBasis_summ_transport: TcxCurrencyEdit;
    edBasisWVAT_summ_transport: TcxCurrencyEdit;
    actFormClose: TdsdFormClose;
    Panel_btn: TPanel;
    btnInsertUpdateMovement: TcxButton;
    btntAdd_limit: TcxButton;
    btnCompleteMovement: TcxButton;
    btnUnCompleteMovement: TcxButton;
    btnSetErased: TcxButton;
    btnShowAll: TcxButton;
    btnInsertAction: TcxButton;
    btnUpdateAction: TcxButton;
    btnCompleteMovement_andSave: TcxButton;
    btnFormClose: TcxButton;
    bbsView: TdxBarSubItem;
    dxBarStatic1: TdxBarStatic;
    dxBarSeparator1: TdxBarSeparator;
    bbsDoc: TdxBarSubItem;
    bbsGoods: TdxBarSubItem;
    bbsPartion: TdxBarSubItem;
    bbsOpenForm: TdxBarSubItem;
    bbsProtocol: TdxBarSubItem;
    mactCompleteMovement_andSave: TMultiAction;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSaleForm);

end.
