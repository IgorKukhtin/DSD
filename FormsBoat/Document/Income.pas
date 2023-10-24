unit Income;

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
  cxImageComboBox, cxSplitter, Vcl.StdCtrls, cxButtons;

type
  TIncomeForm = class(TParentForm)
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
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    OperPrice: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrintStiker: TdxBarButton;
    CountForPrice: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edOperDatePartner: TcxDateEdit;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    HeaderSaver: THeaderSaver;
    edInvNumberPartner: TcxTextEdit;
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
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    cxLabel11: TcxLabel;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    IsErased: TcxGridDBColumn;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    actUnCompleteMovement: TChangeGuidesStatus;
    actCompleteMovement: TChangeGuidesStatus;
    actDeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    Comment: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    GuidesFrom: TdsdGuides;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    actOpenFormProtocol: TdsdOpenForm;
    bbOpenFormProtocol: TdxBarButton;
    GoodsGroupNameFull: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    bbCalcAmountPartner: TdxBarControlContainerItem;
    spInsertMaskMIMaster: TdsdStoredProc;
    actInsertMask: TdsdExecStoredProc;
    bbInsertMask_2: TdxBarButton;
    actGoodsChoiceForm: TOpenChoiceForm;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    spInsertUpdateMovement_Params: TdsdStoredProc;
    bbInsertRecordCost: TdxBarButton;
    bbCompleteCost: TdxBarButton;
    bbUnCompleteCost: TdxBarButton;
    bbSetErasedCost: TdxBarButton;
    actShowErasedCost: TBooleanStoredProcAction;
    bbShowErasedCost: TdxBarButton;
    spUpdateOrder: TdsdStoredProc;
    bbInsertAction: TdxBarButton;
    bbPrintSticker: TdxBarButton;
    bbPrintStickerTermo: TdxBarButton;
    bbMIContainerCost: TdxBarButton;
    actOpenFormInvoice: TdsdOpenForm;
    bbOpenFormInvoice: TdxBarButton;
    bbOpenFormService: TdxBarButton;
    cxLabel10: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    spUnComplete_IncomeCost: TdsdStoredProc;
    spComplete_IncomeCost: TdsdStoredProc;
    spSetErased_IncomeCost: TdsdStoredProc;
    spSelect_IncomeCost_byParent: TdsdStoredProc;
    spInsertUpdate_IncomeCost: TdsdStoredProc;
    CostDS: TDataSource;
    CostCDS: TClientDataSet;
    actUpdateClientDataCost: TdsdUpdateDataSet;
    actCompleteCost: TdsdChangeMovementStatus;
    actSetErasedCost: TdsdChangeMovementStatus;
    actUnCompleteCost: TdsdChangeMovementStatus;
    actInsertRecordCost: TInsertRecord;
    actCostJournalChoiceForm: TOpenChoiceForm;
    actOpenFormProtocol_Cost: TdsdOpenForm;
    bbOpenFormProtocol_Cost: TdxBarButton;
    CostPrice: TcxGridDBColumn;
    AmountNotVAT_Master: TcxGridDBColumn;
    PartnerCode_Master: TcxGridDBColumn;
    OperPrice_cost: TcxGridDBColumn;
    TotalSumm_cost: TcxGridDBColumn;
    Summ_cost: TcxGridDBColumn;
    cxLabel12: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel13: TcxLabel;
    edInsertName: TcxButtonEdit;
    InfoMoneyGroupName_Master: TcxGridDBColumn;
    InfoMoneyDestinationName_Master: TcxGridDBColumn;
    InfoMoneyName_Master: TcxGridDBColumn;
    VATPercent_Master: TcxGridDBColumn;
    cxGridChild: TcxGrid;
    cxGridDBTableViewChild: TcxGridDBTableView;
    GoodsCode_ch2: TcxGridDBColumn;
    GoodsName_ch2: TcxGridDBColumn;
    MeasureName_ch2: TcxGridDBColumn;
    Article_ch2: TcxGridDBColumn;
    Amount_ch2: TcxGridDBColumn;
    InvNumber_OrderClientFull_ch2: TcxGridDBColumn;
    IsErased_ch2: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    cxTopSplitter: TcxSplitter;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    ChildViewAddOn: TdsdDBViewAddOn;
    spSelectMIChild: TdsdStoredProc;
    spInsertUpdateReceiptChild: TdsdStoredProc;
    Amount_unit: TcxGridDBColumn;
    spErasedMIchild: TdsdStoredProc;
    actSetErasedChild: TdsdUpdateErased;
    bbSetErasedChild: TdxBarButton;
    InvNumber_OrderPartner_Full_ch2: TcxGridDBColumn;
    CIN_ch2: TcxGridDBColumn;
    ProductName_ch2: TcxGridDBColumn;
    BrandName_ch2: TcxGridDBColumn;
    actOpenFormOrderPartner: TdsdOpenForm;
    actOpenFormOrderClient: TdsdOpenForm;
    bbOpenFormOrderPartner: TdxBarButton;
    bbOpenFormOrderClient: TdxBarButton;
    EngineNum_ch2: TcxGridDBColumn;
    EngineName_ch2: TcxGridDBColumn;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    spSelectPrintSticker: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    actUpdateAction: TdsdInsertUpdateAction;
    bbUpdateAction: TdxBarButton;
    SummIn: TcxGridDBColumn;
    DiscountTax: TcxGridDBColumn;
    OperPrice_orig: TcxGridDBColumn;
    actUpdateActionMovement: TdsdInsertUpdateAction;
    bbUpdateActionMovement: TdxBarButton;
    cxLabel9: TcxLabel;
    ceDiscountTax: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    ceSummTaxPVAT: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    ceSummTaxMVAT: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    cxLabel18: TcxLabel;
    cxLabel19: TcxLabel;
    ceSummInsur: TcxCurrencyEdit;
    ceSummPack: TcxCurrencyEdit;
    ceSummPost: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    ceTotalDiscountTax: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    ceTotalSummTaxPVAT: TcxCurrencyEdit;
    cxLabel22: TcxLabel;
    ceTotalSummTaxMVAT: TcxCurrencyEdit;
    EnterMoveNext: TEnterMoveNext;
    mactUpdateActionMovement: TMultiAction;
    actInsertAction: TdsdInsertUpdateAction;
    EKPrice_orig: TcxGridDBColumn;
    EKPrice_discount: TcxGridDBColumn;
    TotalSummIn: TcxGridDBColumn;
    lbSearchArticle: TcxLabel;
    edSearchArticle: TcxTextEdit;
    actChoiceGuides: TdsdChoiceGuides;
    FieldFilter_Article: TdsdFieldFilter;
    actPrintStickerOne: TdsdPrintAction;
    spSelectPrintStickerOne: TdsdStoredProc;
    bbPrintStickerOne: TdxBarButton;
    ExecuteDialogPrint: TExecuteDialog;
    macPrintStiker: TMultiAction;
    macPrintStikerOne: TMultiAction;
    cbPrice: TcxCheckBox;
    Panel1: TPanel;
    actAdd_limit: TdsdInsertUpdateAction;
    mactAdd_limit: TMultiAction;
    actRefreshMI: TdsdDataSetRefresh;
    bbAdd_limit: TdxBarButton;
    macInsertAction: TMultiAction;
    macUpdateAction: TMultiAction;
    cxLabel8: TcxLabel;
    ceTotalSummMVAT: TcxCurrencyEdit;
    cxLabel23: TcxLabel;
    ceSumm2: TcxCurrencyEdit;
    cxLabel24: TcxLabel;
    ceSumm3: TcxCurrencyEdit;
    cxLabel25: TcxLabel;
    ceTotalSumm: TcxCurrencyEdit;
    macInsertMask: TMultiAction;
    actInsertMaskAction: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    spUnErasedMIchild: TdsdStoredProc;
    actSetUnErasedChild: TdsdUpdateErased;
    bbSetUnErasedChild: TdxBarButton;
    cxLabel26: TcxLabel;
    edTaxKind: TcxButtonEdit;
    GuidesTaxKind: TdsdGuides;
    cxLabel27: TcxLabel;
    edInvNumberPack: TcxTextEdit;
    cxLabel28: TcxLabel;
    edInvNumberInvoice: TcxTextEdit;
    isReceiptGoods: TcxGridDBColumn;
    ArticleVergl: TcxGridDBColumn;
    isProdOptions: TcxGridDBColumn;
    lbSearchName: TcxLabel;
    edSearchName: TcxTextEdit;
    spUpdate_summ_before: TdsdStoredProc;
    spUpdate_summ_after: TdsdStoredProc;
    actUpdate_summ_after: TdsdInsertUpdateGuides;
    HeaderExit11: THeaderExit;
    HeaderExit: THeaderExit;
    actUpdate_summ_before: TdsdDataSetRefresh;
    HeaderSaver1: THeaderSaver;
    bbsView: TdxBarSubItem;
    bbsDoc: TdxBarSubItem;
    bbsGoods: TdxBarSubItem;
    Separator_1: TdxBarSeparator;
    bbsReserv: TdxBarSubItem;
    bbsCost: TdxBarSubItem;
    bbsOpenForm: TdxBarSubItem;
    bbsPrint: TdxBarSubItem;
    bbsProtocol: TdxBarSubItem;
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
    actCompleteMovement_andSave: TChangeGuidesStatus;
    actSaveMovement: TChangeGuidesStatus;
    actFormClose: TdsdFormClose;
    btnFormClose: TcxButton;
    actInsertGoods1: TdsdInsertUpdateAction;
    actInsertAddLimit_Goods1_NO: TdsdInsertUpdateAction;
    macInsertAddLimit_Goods1: TMultiAction;
    bbInsertAddLimit_Goods1: TdxBarButton;
    bbInsertAddLimit_Goods2: TdxBarButton;
    actInsertGoods111: TdsdInsertUpdateAction;
    actOpenFormInsertGoods1: TdsdOpenForm;
    actOpenFormsInsertLimit_Goods1: TdsdOpenForm;
    edGoodsId1: TcxCurrencyEdit;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomeForm);

end.
