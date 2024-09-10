unit PromoTrade;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxSplitter, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox, cxEditRepositoryItems, cxImageComboBox, dsdCommon;

type
  TPromoTradeForm = class(TAncestorDocumentForm)
    GuidesPriceList: TdsdGuides;
    edPriceList: TcxButtonEdit;
    cxLabel11: TcxLabel;
    GuidesPromoKind: TdsdGuides;
    cxLabel4: TcxLabel;
    edPromoKind: TcxButtonEdit;
    cxLabel5: TcxLabel;
    deStartPromo: TcxDateEdit;
    cxLabel6: TcxLabel;
    deEndPromo: TcxDateEdit;
    cxLabel9: TcxLabel;
    deOperDateStart: TcxDateEdit;
    cxLabel10: TcxLabel;
    deOperDateEnd: TcxDateEdit;
    edCostPromo: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    edComment: TcxTextEdit;
    GuidesPersonalTrade: TdsdGuides;
    cxLabel14: TcxLabel;
    edPersonalTrade: TcxButtonEdit;
    cxLabel16: TcxLabel;
    edPromoItem: TcxButtonEdit;
    GuidesPromoItem: TdsdGuides;
    GuidesContract: TdsdGuides;
    edContract: TcxButtonEdit;
    cxLabel17: TcxLabel;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    actGoodsChoiceForm: TOpenChoiceForm;
    InsertRecord: TInsertRecord;
    actGoodsKindChoiceForm: TOpenChoiceForm;
    bbInsertRecord: TdxBarButton;
    cxGridMov1: TcxGrid;
    cxGridDBTableViewMov1: TcxGridDBTableView;
    OperDate_ch1: TcxGridDBColumn;
    StatusCode_ch1: TcxGridDBColumn;
    cxGridLevelMov1: TcxGridLevel;
    spSelect_Movement_Mov1: TdsdStoredProc;
    Mov1CDS: TClientDataSet;
    Mov1DS: TDataSource;
    actInsertRecordPartner: TInsertRecord;
    actErasedPartner: TdsdUpdateErased;
    actUnErasedPartner: TdsdUpdateErased;
    actPromoPartnerChoiceForm: TOpenChoiceForm;
    dsdDBViewAddOnPartner: TdsdDBViewAddOn;
    actUpdateDSPartner: TdsdUpdateDataSet;
    Panel1: TPanel;
    cxPageControl1: TcxPageControl;
    tsPartner: TcxTabSheet;
    actUpdateConditionDS: TdsdUpdateDataSet;
    actInsertCondition: TInsertRecord;
    actErasedCondition: TdsdUpdateErased;
    actUnErasedCondition: TdsdUpdateErased;
    actConditionPromoChoiceForm: TOpenChoiceForm;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    PrintHead: TClientDataSet;
    spSelect_Movement_Promo_Print: TdsdStoredProc;
    actContractChoiceForm: TOpenChoiceForm;
    Mov2CDS: TClientDataSet;
    Mov2DS: TDataSource;
    spErasedAdvertising: TdsdStoredProc;
    spUnErasedAdvertising: TdsdStoredProc;
    spInsertUpdateMIAdvertising: TdsdStoredProc;
    spSelect_Movement_Mov2: TdsdStoredProc;
    actInsertRecordAdvertising: TInsertRecord;
    actErasedAdvertising: TdsdUpdateErased;
    actunErasedAdvertising: TdsdUpdateErased;
    actAdvertisingChoiceForm: TOpenChoiceForm;
    actUpdateDSAdvertising: TdsdUpdateDataSet;
    cxPageControl3: TcxPageControl;
    tsAdvertising: TcxTabSheet;
    cxGridMov2: TcxGrid;
    cxGridDBTableViewMov2: TcxGridDBTableView;
    StatusCode_ch2: TcxGridDBColumn;
    cxGridLevelMov2: TcxGridLevel;
    cxSplitter3: TcxSplitter;
    GoodComment: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    TradeMarkName: TcxGridDBColumn;
    InvNumber_ch1: TcxGridDBColumn;
    actUpdate_Movement_Promo_Data: TdsdExecStoredProc;
    mactUpdate_Movement_Promo_Data: TMultiAction;
    dsdDBViewAddOnPartnerList: TdsdDBViewAddOn;
    actPartnerListRefresh: TdsdDataSetRefresh;
    mactAddAllPartner: TMultiAction;
    actChoiceRetailForm: TOpenChoiceForm;
    actInsertUpdate_Movement_PromoPartnerFromRetail: TdsdExecStoredProc;
    actPartnerProtocolOpenForm: TdsdOpenForm;
    actConditionPromoProtocolOpenForm: TdsdOpenForm;
    actAdvertisingProtocolOpenForm: TdsdOpenForm;
    actInsertUpdate_MI_Param: TdsdExecStoredProc;
    macInsertUpdate_MI_Param: TMultiAction;
    spInsertUpdateMISign_No: TdsdStoredProc;
    spInsertUpdateMISign_Yes: TdsdStoredProc;
    actInsertUpdateMISignNo: TdsdExecStoredProc;
    actInsertUpdateMISignYes: TdsdExecStoredProc;
    bbInsertUpdateMISignYes: TdxBarButton;
    bbInsertUpdateMISignNo: TdxBarButton;
    cxLabel21: TcxLabel;
    edStrSign: TcxTextEdit;
    edStrSignNo: TcxTextEdit;
    cxLabel22: TcxLabel;
    mactInsertUpdateMISignYes: TMultiAction;
    mactInsertUpdateMISignNo: TMultiAction;
    actRefresh_Get: TdsdDataSetRefresh;
    SignCDS: TClientDataSet;
    SignDS: TDataSource;
    dsdDBViewAddOnSign: TdsdDBViewAddOn;
    spSelectMISign: TdsdStoredProc;
    actUpdateCalcDS: TdsdUpdateDataSet;
    actPrint_Calc: TdsdPrintAction;
    actOpenReportForm: TdsdOpenForm;
    actUpdatePlanDS: TdsdUpdateDataSet;
    actGoodsKindCompleteChoiceForm: TOpenChoiceForm;
    cxSplitter4: TcxSplitter;
    cxSplitter2: TcxSplitter;
    spInsertUpdateMIMessage: TdsdStoredProc;
    actUserChoice: TOpenChoiceForm;
    actUpdateDataSetMessage: TdsdUpdateDataSet;
    actPromoStateKindChoice: TOpenChoiceForm;
    actUpdatePromoStateKindDS: TdsdUpdateDataSet;
    actUpdateCalcDS2: TdsdUpdateDataSet;
    actInsertRecordPromoStateKind: TInsertRecord;
    actMISetErasedPromoStateKind: TdsdUpdateErased;
    actMISetUnErasedPromoStateKind: TdsdUpdateErased;
    cxLabel25: TcxLabel;
    edSignInternal: TcxButtonEdit;
    GuidesSignInternal: TdsdGuides;
    actOpenProtocoPromoStateKind: TdsdOpenForm;
    actPrint_Calc2: TdsdPrintAction;
    actUpdate_Movement_isTaxPromo: TdsdExecStoredProc;
    actOpenReport_SaleReturn_byPromo: TdsdOpenForm;
    bsGoods: TdxBarSubItem;
    bsSign: TdxBarSubItem;
    dxBarSeparator1: TdxBarSeparator;
    actUpdate_SignInternal_One: TdsdExecStoredProc;
    actUpdate_SignInternal_Two: TdsdExecStoredProc;
    bbUpdate_SignInternal_One: TdxBarButton;
    bbUpdate_SignInternal_Two: TdxBarButton;
    spUpdate_SignInternal_One: TdsdStoredProc;
    spUpdate_SignInternal_Two: TdsdStoredProc;
    actPrint_CalcAll: TdsdPrintAction;
    cxEditRepository1: TcxEditRepository;
    cxEditRepository1CurrencyItem1: TcxEditRepositoryCurrencyItem;
    cxEditRepository1CurrencyItem2: TcxEditRepositoryCurrencyItem;
    cxLabel24: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    macChangePercent: TMultiAction;
    actUpdateChangePercent: TdsdUpdateDataSet;
    actChangePercentDialog: TExecuteDialog;
    dsdDBViewAddOnAdvertising: TdsdDBViewAddOn;
    actUpdate_MI_ContractCondition: TdsdExecStoredProc;
    actInsertUpdate_MI_PriceCalc: TdsdExecStoredProc;
    macUpdate_calc: TMultiAction;
    actRefreshCalc: TdsdDataSetRefresh;
    actOpenFormPromoContractBonus_Detail: TdsdOpenForm;
    actUpdate_SignInternal_Three: TdsdExecStoredProc;
    spUpdate_SignInternal_Three: TdsdStoredProc;
    bbUpdate_SignInternal_Three: TdxBarButton;
    dxBarSeparator2: TdxBarSeparator;
    actUpdateMovement_PromoStateKind: TdsdExecStoredProc;
    actPromoManagerDialog: TExecuteDialog;
    actGetPromoStateKind_Return: TdsdDataSetRefresh;
    actGetPromoStateKind_Complete: TdsdDataSetRefresh;
    macUpdatePromoStateKind_Return: TMultiAction;
    macUpdatePromoStateKind_Complete: TMultiAction;
    bbUpdatePromoStateKind_Complete: TdxBarButton;
    bbUpdatePromoStateKind_Return: TdxBarButton;
    dxBarSeparator3: TdxBarSeparator;
    actErasedInvoice: TdsdUpdateErased;
    actUnErasedInvoice: TdsdUpdateErased;
    actInsertInvoice: TdsdInsertUpdateAction;
    actUpdateInvoice: TdsdInsertUpdateAction;
    actUnCompleteInvoice: TdsdChangeMovementStatus;
    actSetErasedInvoice: TdsdChangeMovementStatus;
    actCompleteInvoice: TdsdChangeMovementStatus;
    actRefreshInvoice: TdsdDataSetRefresh;
    actInsUpPromoStat_Master_calc: TdsdExecStoredProc;
    macInsUpPromoStat_Master_calc: TMultiAction;
    actInsUpPromoPlan_Master_calc: TdsdExecStoredProc;
    macInsUpPromoPlan_Master_calc: TMultiAction;
    actInsUpPromoPlan_Child_calc: TdsdExecStoredProc;
    macInsUpPromoPlan_Child_calc: TMultiAction;
    actChoiceTradeMark: TOpenChoiceForm;
    actChoiceGoodsGroupProperty: TOpenChoiceForm;
    actChoiceGoodsGroupDirection: TOpenChoiceForm;
    InvNumber_ch2: TcxGridDBColumn;
    OperDate_ch2: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoTradeForm);

end.
