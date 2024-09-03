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
    cxGridPartner: TcxGrid;
    cxGridDBTableViewPartner: TcxGridDBTableView;
    isErased: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    PartnerDescName: TcxGridDBColumn;
    cxGridLevelPartner: TcxGridLevel;
    spSelect_Movement_PromoPartner: TdsdStoredProc;
    PartnerCDS: TClientDataSet;
    PartnerDS: TDataSource;
    actInsertRecordPartner: TInsertRecord;
    actErasedPartner: TdsdUpdateErased;
    actUnErasedPartner: TdsdUpdateErased;
    actPromoPartnerChoiceForm: TOpenChoiceForm;
    spErasedMIPartner: TdsdStoredProc;
    spUnErasedMIPartner: TdsdStoredProc;
    dsdDBViewAddOnPartner: TdsdDBViewAddOn;
    bbInsertRecordPartner: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    actUpdateDSPartner: TdsdUpdateDataSet;
    Panel1: TPanel;
    cxPageControl1: TcxPageControl;
    tsPartner: TcxTabSheet;
    ConditionPromoDS: TDataSource;
    ConditionPromoCDS: TClientDataSet;
    actUpdateConditionDS: TdsdUpdateDataSet;
    actInsertCondition: TInsertRecord;
    actErasedCondition: TdsdUpdateErased;
    actUnErasedCondition: TdsdUpdateErased;
    actConditionPromoChoiceForm: TOpenChoiceForm;
    bbInsertCondition: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    pmPartner: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    PrintHead: TClientDataSet;
    spSelect_Movement_Promo_Print: TdsdStoredProc;
    Juridical_Name: TcxGridDBColumn;
    Retail_Name: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    actContractChoiceForm: TOpenChoiceForm;
    AdvertisingCDS: TClientDataSet;
    AdvertisingDS: TDataSource;
    pmAdvertising: TPopupMenu;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    spErasedAdvertising: TdsdStoredProc;
    spUnErasedAdvertising: TdsdStoredProc;
    spInsertUpdateMIAdvertising: TdsdStoredProc;
    spSelect_Movement_PromoAdvertising: TdsdStoredProc;
    actInsertRecordAdvertising: TInsertRecord;
    actErasedAdvertising: TdsdUpdateErased;
    actunErasedAdvertising: TdsdUpdateErased;
    actAdvertisingChoiceForm: TOpenChoiceForm;
    actUpdateDSAdvertising: TdsdUpdateDataSet;
    cxPageControl3: TcxPageControl;
    tsAdvertising: TcxTabSheet;
    grAdvertising: TcxGrid;
    grtvAdvertising: TcxGridDBTableView;
    AdvertisingCode: TcxGridDBColumn;
    AdvertisingName: TcxGridDBColumn;
    CommentAdvertising: TcxGridDBColumn;
    grlAdvertising: TcxGridLevel;
    cxSplitter3: TcxSplitter;
    IsErasedAdvertising: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    GoodComment: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    TradeMarkName: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    spUpdate_Movement_Promo_Data: TdsdStoredProc;
    actUpdate_Movement_Promo_Data: TdsdExecStoredProc;
    mactUpdate_Movement_Promo_Data: TMultiAction;
    dxBarButton11: TdxBarButton;
    tsPromoPartnerList: TcxTabSheet;
    grPartnerList: TcxGrid;
    grtvPartnerList: TcxGridDBTableView;
    PartnerListRetailName: TcxGridDBColumn;
    PartnerListJuridicalName: TcxGridDBColumn;
    PartnerListCode: TcxGridDBColumn;
    PartnerListName: TcxGridDBColumn;
    PartnerListAreaName: TcxGridDBColumn;
    grlPartnerList: TcxGridLevel;
    PartnerListCDS: TClientDataSet;
    PartnerLisrDS: TDataSource;
    spSelect_MovementItem_PromoPartner: TdsdStoredProc;
    PartnerListContractCode: TcxGridDBColumn;
    PartnerListContractName: TcxGridDBColumn;
    PartnerListContractTagName: TcxGridDBColumn;
    PartnerListIsErased: TcxGridDBColumn;
    dsdDBViewAddOnPartnerList: TdsdDBViewAddOn;
    actPartnerListRefresh: TdsdDataSetRefresh;
    mactAddAllPartner: TMultiAction;
    actChoiceRetailForm: TOpenChoiceForm;
    actInsertUpdate_Movement_PromoPartnerFromRetail: TdsdExecStoredProc;
    dxBarButton12: TdxBarButton;
    actPartnerProtocolOpenForm: TdsdOpenForm;
    actConditionPromoProtocolOpenForm: TdsdOpenForm;
    bbPartnerProtocol: TdxBarButton;
    bbPartnerListProtocol: TdxBarButton;
    bbAdvertisingProtocol: TdxBarButton;
    actAdvertisingProtocolOpenForm: TdsdOpenForm;
    spInsertUpdate_MI_Param: TdsdStoredProc;
    actInsertUpdate_MI_Param: TdsdExecStoredProc;
    macInsertUpdate_MI_Param: TMultiAction;
    bbInsertUpdate_MI_Param: TdxBarButton;
    RetailName_inf: TcxGridDBColumn;
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
    bbPrint_Calc: TdxBarButton;
    actPrint_Calc: TdsdPrintAction;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    actUpdatePlanDS: TdsdUpdateDataSet;
    actGoodsKindCompleteChoiceForm: TOpenChoiceForm;
    cxSplitter4: TcxSplitter;
    cxSplitter2: TcxSplitter;
    spInsertUpdateMIMessage: TdsdStoredProc;
    actUserChoice: TOpenChoiceForm;
    actUpdateDataSetMessage: TdsdUpdateDataSet;
    PromoStateKindDCS: TClientDataSet;
    actPromoStateKindChoice: TOpenChoiceForm;
    actUpdatePromoStateKindDS: TdsdUpdateDataSet;
    actUpdateCalcDS2: TdsdUpdateDataSet;
    actInsertRecordPromoStateKind: TInsertRecord;
    actMISetErasedPromoStateKind: TdsdUpdateErased;
    actMISetUnErasedPromoStateKind: TdsdUpdateErased;
    bbInsertRecordPromoStateKind: TdxBarButton;
    bbSetErasedPromoStateKind: TdxBarButton;
    bbSetUnErasedPromoStateKind: TdxBarButton;
    bbProtocoPromoStateKind: TdxBarButton;
    cxLabel25: TcxLabel;
    edSignInternal: TcxButtonEdit;
    GuidesSignInternal: TdsdGuides;
    actOpenProtocoPromoStateKind: TdsdOpenForm;
    actPrint_Calc2: TdsdPrintAction;
    bbPrint_Calc2: TdxBarButton;
    actUpdate_Movement_isTaxPromo: TdsdExecStoredProc;
    bbUpdate_Movement_isTaxPromo: TdxBarButton;
    bbOpenReport_SaleReturn_byPromo: TdxBarButton;
    actOpenReport_SaleReturn_byPromo: TdsdOpenForm;
    bsGoods: TdxBarSubItem;
    bsPartner: TdxBarSubItem;
    bsConditionPromo: TdxBarSubItem;
    bsAdvertising: TdxBarSubItem;
    bsPromoStateKind: TdxBarSubItem;
    bsCalc: TdxBarSubItem;
    bsSign: TdxBarSubItem;
    dxBarSeparator1: TdxBarSeparator;
    actUpdate_SignInternal_One: TdsdExecStoredProc;
    actUpdate_SignInternal_Two: TdsdExecStoredProc;
    bbUpdate_SignInternal_One: TdxBarButton;
    bbUpdate_SignInternal_Two: TdxBarButton;
    spUpdate_SignInternal_One: TdsdStoredProc;
    spUpdate_SignInternal_Two: TdsdStoredProc;
    actPrint_CalcAll: TdsdPrintAction;
    bbPrint_CalcAll: TdxBarButton;
    cxEditRepository1: TcxEditRepository;
    cxEditRepository1CurrencyItem1: TcxEditRepositoryCurrencyItem;
    cxEditRepository1CurrencyItem2: TcxEditRepositoryCurrencyItem;
    cxLabel24: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    macChangePercent: TMultiAction;
    actUpdateChangePercent: TdsdUpdateDataSet;
    spUpdate_Movement_ChangePercent: TdsdStoredProc;
    actChangePercentDialog: TExecuteDialog;
    bbChangePercent: TdxBarButton;
    dsdDBViewAddOnAdvertising: TdsdDBViewAddOn;
    spUpdate_PromoPartner_ChangePercent: TdsdStoredProc;
    actUpdate_MI_ContractCondition: TdsdExecStoredProc;
    bbUpdate_MI_ContractCondition: TdxBarButton;
    actInsertUpdate_MI_PriceCalc: TdsdExecStoredProc;
    macUpdate_calc: TMultiAction;
    actRefreshCalc: TdsdDataSetRefresh;
    actOpenFormPromoContractBonus_Detail: TdsdOpenForm;
    bbOpenFormPromoContractBonus_Detail: TdxBarButton;
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
    bbInvoice: TdxBarSubItem;
    bbInsertInvoice: TdxBarButton;
    bbUpdateInvoice: TdxBarButton;
    bbCompleteInvoice: TdxBarButton;
    bbUnCompleteInvoice: TdxBarButton;
    bbSetErasedInvoice: TdxBarButton;
    actRefreshInvoice: TdsdDataSetRefresh;
    actInsUpPromoStat_Master_calc: TdsdExecStoredProc;
    macInsUpPromoStat_Master_calc: TMultiAction;
    bbInsUpPromoStat_Master_calc: TdxBarButton;
    actInsUpPromoPlan_Master_calc: TdsdExecStoredProc;
    macInsUpPromoPlan_Master_calc: TMultiAction;
    bbInsUpPromoPlan_Master_calc: TdxBarButton;
    actInsUpPromoPlan_Child_calc: TdsdExecStoredProc;
    macInsUpPromoPlan_Child_calc: TMultiAction;
    bbInsUpPromoPlan_Child_calc: TdxBarButton;
    actChoiceTradeMark: TOpenChoiceForm;
    actChoiceGoodsGroupProperty: TOpenChoiceForm;
    actChoiceGoodsGroupDirection: TOpenChoiceForm;
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
