unit OrderInternalPackRemains;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxSplitter,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TOrderInternalPackRemainsForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintDetail: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTax: TdxBarButton;
    bbPrintRemains: TdxBarButton;
    AmountSecond: TcxGridDBColumn;
    spUpdateAmountRemains: TdsdStoredProc;
    spUpdateAmountPartner: TdsdStoredProc;
    spUpdateAmountForecast: TdsdStoredProc;
    actUpdateAmountRemains: TdsdExecStoredProc;
    MultiAmountRemain: TMultiAction;
    edOperDatePartner: TcxDateEdit;
    cxLabel10: TcxLabel;
    cxLabel18: TcxLabel;
    edDayCount: TcxCurrencyEdit;
    edOperDateStart: TcxDateEdit;
    cxLabel19: TcxLabel;
    cxLabel20: TcxLabel;
    edOperDateEnd: TcxDateEdit;
    Remains: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    AmountForecast: TcxGridDBColumn;
    bbMultiAmountRemain: TdxBarButton;
    actUpdateAmountPartner: TdsdExecStoredProc;
    MultiAmountPartner: TMultiAction;
    actUpdateAmountForecast: TdsdExecStoredProc;
    MultiAmountForecast: TMultiAction;
    actUpdateAmountAll: TMultiAction;
    bbMultiAmountPartner: TdxBarButton;
    bbMultiAmountForecast: TdxBarButton;
    bbUpdateAmountAll: TdxBarButton;
    MeasureName: TcxGridDBColumn;
    ReceiptCode: TcxGridDBColumn;
    ReceiptName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    CountForecast: TcxGridDBColumn;
    CountForecastOrder: TcxGridDBColumn;
    AmountPartnerPrior: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    DayCountForecast: TcxGridDBColumn;
    DayCountForecastOrder: TcxGridDBColumn;
    GoodsCode_basis: TcxGridDBColumn;
    GoodsName_basis: TcxGridDBColumn;
    MeasureName_basis: TcxGridDBColumn;
    isCheck_basis: TcxGridDBColumn;
    ReceiptCode_basis: TcxGridDBColumn;
    ReceiptName_basis: TcxGridDBColumn;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    cxGridChild: TcxGrid;
    cxGridDBTableViewChild: TcxGridDBTableView;
    ñhGoodsCode: TcxGridDBColumn;
    ñhGoodsName: TcxGridDBColumn;
    ñhMeasureName: TcxGridDBColumn;
    ñhIsErased: TcxGridDBColumn;
    cxGridLevelChild: TcxGridLevel;
    ChildDBViewAddOn: TdsdDBViewAddOn;
    cxBottomSplitter: TcxSplitter;
    ñhGoodsKindName: TcxGridDBColumn;
    ñhContainerId: TcxGridDBColumn;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    tsTotal: TcxTabSheet;
    cxGridChildTotal: TcxGrid;
    cxGridDBTableViewChildTotal: TcxGridDBTableView;
    cxGridLevelChildTotal: TcxGridLevel;
    ChildTotalCDS: TClientDataSet;
    ChildTotalDS: TDataSource;
    ChildTotalDBViewAddOn: TdsdDBViewAddOn;
    chtContainerId: TcxGridDBColumn;
    chtGoodsKindName_pf: TcxGridDBColumn;
    chtGoodsKindCompleteName_pf: TcxGridDBColumn;
    chtPartionDate_pf: TcxGridDBColumn;
    chtRemains_CEH: TcxGridDBColumn;
    chtRemains_CEH_Next: TcxGridDBColumn;
    chtRemains_pack: TcxGridDBColumn;
    chtPartionGoods_start: TcxGridDBColumn;
    chtTermProduction: TcxGridDBColumn;
    Remains_CEH: TcxGridDBColumn;
    Remains_CEH_Next: TcxGridDBColumn;
    Income_CEH: TcxGridDBColumn;
    chtIncome_CEH: TcxGridDBColumn;
    spUpdateMIMasterChildTotal: TdsdStoredProc;
    actUpdateChildTotalDS: TdsdUpdateDataSet;
    mactUpdateAmount_to: TMultiAction;
    mactUpdateAmountGrid_to: TMultiAction;
    actUpdateAmount_to: TdsdExecStoredProc;
    spUpdateAmount_to: TdsdStoredProc;
    actUpdateAmountAll_to: TdsdExecStoredProc;
    spUpdateAmountAll_to: TdsdStoredProc;
    mactUpdateAmountSecond_to: TMultiAction;
    mactUpdateAmountSecondGrid_to: TMultiAction;
    actUpdateAmountSecond_to: TdsdExecStoredProc;
    actUpdateAmountSecondAll_to: TdsdExecStoredProc;
    spUpdateAmountSecond_to: TdsdStoredProc;
    spUpdateAmountSecondAll_to: TdsdStoredProc;
    bbUpdateAmount_to: TdxBarButton;
    bbUpdateAmountSecond_to: TdxBarButton;
    AmountTotal: TcxGridDBColumn;
    chtAmountTotal: TcxGridDBColumn;
    Amount_result: TcxGridDBColumn;
    Amount_result_two: TcxGridDBColumn;
    chAmountPackTotal: TcxGridDBColumn;
    AmountPartnerPriorTotal: TcxGridDBColumn;
    AmountPartnerTotal: TcxGridDBColumn;
    chRemains: TcxGridDBColumn;
    Remains_pack: TcxGridDBColumn;
    Income_PACK_from: TcxGridDBColumn;
    chtId: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    chId: TcxGridDBColumn;
    Num: TcxGridDBColumn;
    chAmountPack_calc: TcxGridDBColumn;
    chAmountSecondPack_calc: TcxGridDBColumn;
    chAmountPackTotal_calc: TcxGridDBColumn;
    mactUpdateAmountSecondCEH_to: TMultiAction;
    mactUpdateAmountSecondCEHGrid_to: TMultiAction;
    actUpdateAmountSecondCEH_to: TdsdExecStoredProc;
    spUpdateAmountSecondCEH_to: TdsdStoredProc;
    bbtUpdateAmountSecondCEH_to: TdxBarButton;
    chtRemains_CEH_err: TcxGridDBColumn;
    chtRemains_err: TcxGridDBColumn;
    chDayCountForecast_calc: TcxGridDBColumn;
    chtDayCountForecast_calc: TcxGridDBColumn;
    chtIncome_PACK_to: TcxGridDBColumn;
    Income_PACK_to: TcxGridDBColumn;
    spUpdateAmountSecond_toPACK: TdsdStoredProc;
    spUpdateAmount_toPACK: TdsdStoredProc;
    actUpdateAmount_toPACK: TdsdExecStoredProc;
    actUpdateAmountSecond_toPACK: TdsdExecStoredProc;
    bbUpdateAmount_toPACK: TdxBarButton;
    bbUpdateAmountSecond_toPACK: TdxBarButton;
    actGridTotalToExcel: TdsdGridToExcel;
    bbGridTotalToExcel: TdxBarButton;
    spSelectPrintRemains: TdsdStoredProc;
    actPrintRemains: TdsdPrintAction;
    Amount_result_pack: TcxGridDBColumn;
    AmountPartnerNextPromo: TcxGridDBColumn;
    spInsertUpdateMIChild: TdsdStoredProc;
    actUpdateChildDS: TdsdUpdateDataSet;
    AmountForecastOrder: TcxGridDBColumn;
    AmountForecastOrderPromo_noERR: TcxGridDBColumn;
    mactUpdateAmountNext_to: TMultiAction;
    mactUpdateAmountNextSecond_to: TMultiAction;
    mactUpdateAmountNextSecondCEH_to: TMultiAction;
    actUpdateAmountNextAll_to: TdsdExecStoredProc;
    mactUpdateAmountNextGrid_to: TMultiAction;
    actUpdateAmountNext_to: TdsdExecStoredProc;
    actUpdateAmountNextSecondAll_to: TdsdExecStoredProc;
    actUpdateAmountNextSecond_to: TdsdExecStoredProc;
    mactUpdateAmountNextSecondGrid_to: TMultiAction;
    mactUpdateAmountNextSecondCEHGrid_to: TMultiAction;
    actUpdateAmountNextSecondCEH_to: TdsdExecStoredProc;
    spUpdateAmountNext_to: TdsdStoredProc;
    spUpdateAmountNextSecond_to: TdsdStoredProc;
    spUpdateAmountNextSecondCEH_to: TdsdStoredProc;
    spUpdateAmountNextAll_to: TdsdStoredProc;
    bbUpdateAmountNext_to: TdxBarButton;
    bbUpdateAmountNextSecond_to: TdxBarButton;
    bbUpdateAmountNextSecondCEH_to: TdxBarButton;
    actPrintDetail: TdsdPrintAction;
    chAmountPackAllTotal: TcxGridDBColumn;
    chAmountPackAllTotal_calc: TcxGridDBColumn;
    spUpdateAmountNextSecondAll_to: TdsdStoredProc;
    DayCountForecast_calc: TcxGridDBColumn;
    AmountPartnerNext: TcxGridDBColumn;
    cbPrintMinus: TcxCheckBox;
    actPrintDiff: TdsdPrintAction;
    bbPrintDiff: TdxBarButton;
    Plan1: TcxGridDBColumn;
    Promo1: TcxGridDBColumn;
    DayCountForecast_new: TcxGridDBColumn;
    chDayCountForecast_new_new: TcxGridDBColumn;
    actGridChildToExcel: TdsdGridToExcel;
    bbGridChildToExcel: TdxBarButton;
    chAmount_result_pack_pack: TcxGridDBColumn;
    actProtocolChild: TdsdOpenForm;
    actProtocolTotal: TdsdOpenForm;
    bbProtocolChild: TdxBarButton;
    bbProtocolTotal: TdxBarButton;
    chGoodsCode_packTo: TcxGridDBColumn;
    chGoodsName_packTo: TcxGridDBColumn;
    chGoodsKindName_packTo: TcxGridDBColumn;
    tsAll: TcxTabSheet;
    cxGridPlan: TcxGrid;
    cxGridDBTableViewPlan: TcxGridDBTableView;
    plNum: TcxGridDBColumn;
    plGoodsGroupNameFull_Master: TcxGridDBColumn;
    plUnitCode: TcxGridDBColumn;
    plUnitName: TcxGridDBColumn;
    plisCheck_basis: TcxGridDBColumn;
    plGoodsCode_basis: TcxGridDBColumn;
    plGoodsName_basis: TcxGridDBColumn;
    plMeasureName_basis: TcxGridDBColumn;
    ploutGoodsCode_Master: TcxGridDBColumn;
    ploutGoodsName_Master: TcxGridDBColumn;
    ploutGoodsKindName_Master: TcxGridDBColumn;
    ploutMeasureName: TcxGridDBColumn;
    cxGridLevelPlan: TcxGridLevel;
    PlanDS: TDataSource;
    PlanCDS: TClientDataSet;
    dsdDBViewAddOnPlan: TdsdDBViewAddOn;
    actGridPlanToExcel: TdsdGridToExcel;
    bbGridPlanToExcel: TdxBarButton;
    spSelectPrintRemainsLess: TdsdStoredProc;
    actPrintRemainsLess: TdsdPrintAction;
    bbPrintRemainsLess: TdxBarButton;
    actPrintRemainsLessUpak: TdsdPrintAction;
    bbPrintRemainsLessUpak: TdxBarButton;
    spUpdate_MI_IsCalculated_Yes: TdsdStoredProc;
    spUpdate_MI_IsCalculated_No: TdsdStoredProc;
    actUpdate_MI_IsCalculated_No: TdsdExecStoredProc;
    actUpdate_MI_IsCalculated_Yes: TdsdExecStoredProc;
    macUpdate_MI_IsCalculated_No: TMultiAction;
    macUpdate_MI_IsCalculated_Yes: TMultiAction;
    actRefreshMI: TdsdDataSetRefresh;
    macUpdate_MI_IsCalculated_Yes_list: TMultiAction;
    macUpdate_MI_IsCalculated_No_list: TMultiAction;
    bbUpdate_MI_IsCalculated_Yes: TdxBarButton;
    bbUpdate_MI_IsCalculated_No: TdxBarButton;
    isCalculated_ch: TcxGridDBColumn;
    AmountPartnerTotal_diff: TcxGridDBColumn;
    Income_CEH_diff: TcxGridDBColumn;
    chAmountPartnerTotal_diff: TcxGridDBColumn;
    RemainsRK: TcxGridDBColumn;
    chRemainsRK: TcxGridDBColumn;
    chtRemainsRK: TcxGridDBColumn;
    tsDetail: TcxTabSheet;
    cxGrid_Det: TcxGrid;
    cxGridDBTableView_Det: TcxGridDBTableView;
    GoodsCode_ch3: TcxGridDBColumn;
    GoodsName_ch3: TcxGridDBColumn;
    GoodsKindName_ch3: TcxGridDBColumn;
    isCalculated_ch3: TcxGridDBColumn;
    GoodsCode_basis_ch3: TcxGridDBColumn;
    GoodsName_basis_ch3: TcxGridDBColumn;
    InsertDate_ch3: TcxGridDBColumn;
    InsertName_ch3: TcxGridDBColumn;
    UpdateDate_ch3: TcxGridDBColumn;
    UpdateName_ch3: TcxGridDBColumn;
    Amount_ch3: TcxGridDBColumn;
    AmountPack_ch3: TcxGridDBColumn;
    AmountPackSecond_ch3: TcxGridDBColumn;
    AmountPack_calc_ch3: TcxGridDBColumn;
    AmountPackSecond_calc_ch3: TcxGridDBColumn;
    AmountPackNext_ch3: TcxGridDBColumn;
    AmountPackNextSecond_ch3: TcxGridDBColumn;
    AmountPackNext_calc_ch3: TcxGridDBColumn;
    AmountPackNextSecond_calc_ch3: TcxGridDBColumn;
    isErased_ch3: TcxGridDBColumn;
    cxGridLevel_Det: TcxGridLevel;
    DetailDS: TDataSource;
    DetailCDS: TClientDataSet;
    spSelect_Detail: TdsdStoredProc;
    dsdDBViewAddOnDetail: TdsdDBViewAddOn;
    actProtocolDetail: TdsdOpenForm;
    bbProtocolDetail: TdxBarButton;
    AmountPack: TcxGridDBColumn;
    AmountPackSecond: TcxGridDBColumn;
    AmountPack_calc: TcxGridDBColumn;
    AmountSecondPack_calc: TcxGridDBColumn;
    AmountPackNext: TcxGridDBColumn;
    AmountPackNextSecond: TcxGridDBColumn;
    AmountPackNext_calc: TcxGridDBColumn;
    AmountPackNextSecond_calc: TcxGridDBColumn;
    AmountPack_dt: TcxGridDBColumn;
    AmountPackSecond_dt: TcxGridDBColumn;
    AmountPack_calc_dt: TcxGridDBColumn;
    AmountSecondPack_calc_dt: TcxGridDBColumn;
    AmountPackNext_dt: TcxGridDBColumn;
    AmountPackNextSecond_dt: TcxGridDBColumn;
    AmountPackNext_calc_dt: TcxGridDBColumn;
    AmountPackNextSecond_calc_dt: TcxGridDBColumn;
    chAmountPack_dt: TcxGridDBColumn;
    chAmountPackSecond_dt: TcxGridDBColumn;
    chAmountPack_calc_dt: TcxGridDBColumn;
    chAmountSecondPack_calc_dt: TcxGridDBColumn;
    chAmountPackNext_dt: TcxGridDBColumn;
    chAmountPackNextSecond_dt: TcxGridDBColumn;
    chAmountPackNext_calc_dt: TcxGridDBColumn;
    chAmountPackNextSecond_calc_dt: TcxGridDBColumn;
    AmountPack_diff_ch3: TcxGridDBColumn;
    AmountPackSecond_diff_ch3: TcxGridDBColumn;
    AmountPack_calc_diff_ch3: TcxGridDBColumn;
    AmountPackSecond_calc_diff_ch3: TcxGridDBColumn;
    AmountPackNext_diff_ch3: TcxGridDBColumn;
    AmountPackNextSecond_diff_ch3: TcxGridDBColumn;
    AmountPackNext_calc_diff_ch3: TcxGridDBColumn;
    AmountPackNextSecond_calc_diff_ch3: TcxGridDBColumn;
    actPrintRemains_fact2: TdsdPrintAction;
    bbPrintRemains_fact2: TdxBarButton;
    spSelectPrintRemains_fact2: TdsdStoredProc;
    chGoodsCode_complete: TcxGridDBColumn;
    chGoodsName_complete: TcxGridDBColumn;
    chGoodsKindName_complete: TcxGridDBColumn;
    actOpenFormOrderInternalPackRem: TdsdInsertUpdateAction;
    bbOrderInternalPackRem: TdxBarButton;
    KeyId: TcxGridDBColumn;
    chKeyId: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TOrderInternalPackRemainsForm);

end.
