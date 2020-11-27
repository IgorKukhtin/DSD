unit PromoManager;

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
  cxCheckBox, cxEditRepositoryItems;

type
  TPromoManagerForm = class(TAncestorDocumentForm)
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
    cxLabel7: TcxLabel;
    deStartSale: TcxDateEdit;
    cxLabel8: TcxLabel;
    deEndSale: TcxDateEdit;
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
    edPersonal: TcxButtonEdit;
    GuidesPersonal: TdsdGuides;
    GuidesUnit: TdsdGuides;
    edUnit: TcxButtonEdit;
    cxLabel17: TcxLabel;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    PriceWithOutVAT: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    AmountReal: TcxGridDBColumn;
    AmountPlanMin: TcxGridDBColumn;
    AmountPlanMax: TcxGridDBColumn;
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
    spInsertUpdateMIPartner: TdsdStoredProc;
    dsdDBViewAddOnPartner: TdsdDBViewAddOn;
    bbInsertRecordPartner: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    actUpdateDSPartner: TdsdUpdateDataSet;
    Panel1: TPanel;
    cxSplitter1: TcxSplitter;
    cxPageControl1: TcxPageControl;
    tsPartner: TcxTabSheet;
    cxPageControl2: TcxPageControl;
    tsConditionPromo: TcxTabSheet;
    cxGridConditionPromo: TcxGrid;
    grtvConditionPromo: TcxGridDBTableView;
    cp_isErased: TcxGridDBColumn;
    ConditionPromoName: TcxGridDBColumn;
    cp_Amount: TcxGridDBColumn;
    grlConditionPromo: TcxGridLevel;
    ConditionPromoDS: TDataSource;
    ConditionPromoCDS: TClientDataSet;
    spSelect_MovementItem_PromoCondition: TdsdStoredProc;
    spInsertUpdateMICondition: TdsdStoredProc;
    spUnErasedMICondition: TdsdStoredProc;
    spErasedMICondition: TdsdStoredProc;
    actUpdateConditionDS: TdsdUpdateDataSet;
    actInsertCondition: TInsertRecord;
    actErasedCondition: TdsdUpdateErased;
    actUnErasedCondition: TdsdUpdateErased;
    actConditionPromoChoiceForm: TOpenChoiceForm;
    bbInsertCondition: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dsdDBViewAddOnConditionPromo: TdsdDBViewAddOn;
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
    pmCondition: TPopupMenu;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    PrintHead: TClientDataSet;
    spSelect_Movement_Promo_Print: TdsdStoredProc;
    Juridical_Name: TcxGridDBColumn;
    Retail_Name: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    actContractChoiceForm: TOpenChoiceForm;
    cxLabel18: TcxLabel;
    edCommentMain: TcxTextEdit;
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
    cp_Comment: TcxGridDBColumn;
    IsErasedAdvertising: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    GoodComment: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    TradeMark: TcxGridDBColumn;
    AmountRealWeight: TcxGridDBColumn;
    AmountPlanMinWeight: TcxGridDBColumn;
    AmountPlanMaxWeight: TcxGridDBColumn;
    AmountOrder: TcxGridDBColumn;
    AmountOrderWeight: TcxGridDBColumn;
    AmountOut: TcxGridDBColumn;
    AmountOutWeight: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    AmountInWeight: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    spUpdate_Movement_Promo_Data: TdsdStoredProc;
    actUpdate_Movement_Promo_Data: TdsdExecStoredProc;
    mactUpdate_Movement_Promo_Data: TMultiAction;
    dxBarButton11: TdxBarButton;
    tsPromoPartnerList: TcxTabSheet;
    PartnerListCDS: TClientDataSet;
    PartnerLisrDS: TDataSource;
    spSelect_MovementItem_PromoPartner: TdsdStoredProc;
    dsdDBViewAddOnPartnerList: TdsdDBViewAddOn;
    actPartnerListRefresh: TdsdDataSetRefresh;
    mactAddAllPartner: TMultiAction;
    actChoiceRetailForm: TOpenChoiceForm;
    actInsertUpdate_Movement_PromoPartnerFromRetail: TdsdExecStoredProc;
    spInsertUpdate_Movement_PromoPartnerFromRetail: TdsdStoredProc;
    dxBarButton12: TdxBarButton;
    deEndReturn: TcxDateEdit;
    cxLabel3: TcxLabel;
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
    cbChecked: TcxCheckBox;
    cbPromo: TcxCheckBox;
    deMonthPromo: TcxDateEdit;
    cxLabel19: TcxLabel;
    cxLabel20: TcxLabel;
    deCheck: TcxDateEdit;
    RetailName_inf: TcxGridDBColumn;
    bbInsertUpdateMISignYes: TdxBarButton;
    bbInsertUpdateMISignNo: TdxBarButton;
    cxLabel21: TcxLabel;
    edstrSign: TcxTextEdit;
    edstrSignNo: TcxTextEdit;
    cxLabel22: TcxLabel;
    actRefresh_Get: TdsdDataSetRefresh;
    CalcCDS: TClientDataSet;
    CalcDS: TDataSource;
    dsdDBViewAddOnCalc: TdsdDBViewAddOn;
    spSelectCalc: TdsdStoredProc;
    calcSummaProfit: TcxGridDBColumn;
    Color_PriceIn: TcxGridDBColumn;
    spInsertUpdate_Calc: TdsdStoredProc;
    actUpdateCalcDS: TdsdUpdateDataSet;
    bbPrint_Calc: TdxBarButton;
    actPrint_Calc: TdsdPrintAction;
    calcGroupNum: TcxGridDBColumn;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    AmountRetInWeight: TcxGridDBColumn;
    AmountRetIn: TcxGridDBColumn;
    GoodsKindName_List: TcxGridDBColumn;
    dsdDBViewAddOnPlan: TdsdDBViewAddOn;
    actGoodsKindCompleteChoiceForm: TOpenChoiceForm;
    PriceTender: TcxGridDBColumn;
    actUserChoice: TOpenChoiceForm;
    actUpdateDataSetMessage: TdsdUpdateDataSet;
    edPromoStateKind: TcxButtonEdit;
    cxLabel23: TcxLabel;
    GuidesPromoStateKind: TdsdGuides;
    PromoStateKindDS: TDataSource;
    PromoStateKindDCS: TClientDataSet;
    dsdDBViewAddOnPromoStateKind: TdsdDBViewAddOn;
    spSelectMIPromoStateKind: TdsdStoredProc;
    spInsertUpdate_MI_PromoStateKind: TdsdStoredProc;
    actPromoStateKindChoice: TOpenChoiceForm;
    actUpdatePromoStateKindDS: TdsdUpdateDataSet;
    calcTaxRetIn: TcxGridDBColumn;
    dsdDBViewAddOnCalc2: TdsdDBViewAddOn;
    spSelectCalc2: TdsdStoredProc;
    spInsertUpdate_Calc2: TdsdStoredProc;
    CalcCDS2: TClientDataSet;
    CalcDS2: TDataSource;
    calcTaxPromo: TcxGridDBColumn;
    calcText: TcxGridDBColumn;
    actUpdateCalcDS2: TdsdUpdateDataSet;
    calcSummaProfit_Condition: TcxGridDBColumn;
    calcTaxPromo_Condition: TcxGridDBColumn;
    cbisTaxPromo: TcxCheckBox;
    cbisTaxPromo_Condition: TcxCheckBox;
    actInsertRecordPromoStateKind: TInsertRecord;
    actMISetErasedPromoStateKind: TdsdUpdateErased;
    actMISetUnErasedPromoStateKind: TdsdUpdateErased;
    spErasedPromoStateKind: TdsdStoredProc;
    spUnErasedPromoStateKind: TdsdStoredProc;
    bbInsertRecordPromoStateKind: TdxBarButton;
    bbSetErasedPromoStateKind: TdxBarButton;
    bbSetUnErasedPromoStateKind: TdxBarButton;
    actOpenProtocoPromoStateKind1: TdsdOpenForm;
    bbProtocoPromoStateKind: TdxBarButton;
    cxLabel25: TcxLabel;
    edSignInternal: TcxButtonEdit;
    GuidesSignInternal: TdsdGuides;
    actOpenProtocoPromoStateKind: TdsdOpenForm;
    cbPromoStateKind: TcxCheckBox;
    PromoStateKindPopupMenu: TPopupMenu;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    actPrint_Calc2: TdsdPrintAction;
    bbPrint_Calc2: TdxBarButton;
    spUpdate_Movement_isTaxPromo: TdsdStoredProc;
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
    spUpdate_PromoStateKind: TdsdStoredProc;
    actUpdateMovement_PromoStateKind: TdsdExecStoredProc;
    bbUpdateMovement_Checked: TdxBarButton;
    bbUpdateMovement_Correction: TdxBarButton;
    actPromoManagerDialog: TExecuteDialog;
    macUpdatePromoStateKind_Complete: TMultiAction;
    actGetPromoStateKind_Complete: TdsdDataSetRefresh;
    macUpdatePromoStateKind_Return: TMultiAction;
    cxGridCalc2: TcxGrid;
    cxGridDBTableViewCalc2: TcxGridDBTableView;
    ccText: TcxGridDBColumn;
    ññNum: TcxGridDBColumn;
    ññGoodsCode: TcxGridDBColumn;
    ññGoodsName: TcxGridDBColumn;
    ccMeasureName: TcxGridDBColumn;
    ññGoodsKindName: TcxGridDBColumn;
    ññGoodsKindCompleteName: TcxGridDBColumn;
    ññPriceIn: TcxGridDBColumn;
    ññTaxRetIn: TcxGridDBColumn;
    ññContractCondition: TcxGridDBColumn;
    ññAmountSale: TcxGridDBColumn;
    ññAmountSaleWeight: TcxGridDBColumn;
    ññSummaSale: TcxGridDBColumn;
    ññPrice: TcxGridDBColumn;
    ññTaxPromo_Condition: TcxGridDBColumn;
    ññPriceWithVAT: TcxGridDBColumn;
    ññSummaProfit: TcxGridDBColumn;
    ññTaxPromo: TcxGridDBColumn;
    ññSummaProfit_Condition: TcxGridDBColumn;
    ññColor_PriceIn: TcxGridDBColumn;
    ññColor_RetIn: TcxGridDBColumn;
    ññColor_ContractCond: TcxGridDBColumn;
    ññColor_AmountSale: TcxGridDBColumn;
    ññColor_SummaSale: TcxGridDBColumn;
    ññColor_Price: TcxGridDBColumn;
    ññColor_PriceWithVAT: TcxGridDBColumn;
    ññColor_PromoCond: TcxGridDBColumn;
    ññColor_SummaProfit: TcxGridDBColumn;
    ññGroupNum: TcxGridDBColumn;
    cxGridLevel5: TcxGridLevel;
    cxSplitter5: TcxSplitter;
    grPartnerList: TcxGrid;
    grtvPartnerList: TcxGridDBTableView;
    PartnerListRetailName: TcxGridDBColumn;
    PartnerListJuridicalName: TcxGridDBColumn;
    PartnerListCode: TcxGridDBColumn;
    PartnerListName: TcxGridDBColumn;
    PartnerListAreaName: TcxGridDBColumn;
    PartnerListContractCode: TcxGridDBColumn;
    PartnerListContractName: TcxGridDBColumn;
    PartnerListContractTagName: TcxGridDBColumn;
    PartnerListIsErased: TcxGridDBColumn;
    grlPartnerList: TcxGridLevel;
    cxGridPromoStateKind: TcxGrid;
    cxGridDBTableViewPromoStateKind: TcxGridDBTableView;
    psOrd: TcxGridDBColumn;
    psisQuickly: TcxGridDBColumn;
    psPromoStateKindName: TcxGridDBColumn;
    psComment: TcxGridDBColumn;
    psInsertName: TcxGridDBColumn;
    psInsertDate: TcxGridDBColumn;
    psIsErased: TcxGridDBColumn;
    cxGridLevel4: TcxGridLevel;
    cxSplitter4: TcxSplitter;
    actPrint_CalcAll: TdsdPrintAction;
    spSelectCalc_Print: TdsdStoredProc;
    bbPrint_CalcAll: TdxBarButton;
    spGetPromoStateKind: TdsdStoredProc;
    actGetPromoStateKind_Return: TdsdDataSetRefresh;
    cxEditRepository1: TcxEditRepository;
    cxEditRepository1CurrencyItem1: TcxEditRepositoryCurrencyItem;
    cxEditRepository1CurrencyItem2: TcxEditRepositoryCurrencyItem;
    Repository: TcxGridDBColumn;
    Repository2: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoManagerForm);

end.
