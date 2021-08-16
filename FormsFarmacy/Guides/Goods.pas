unit Goods;

interface

uses
  DataModul, Winapi.Windows, ParentForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxCurrencyEdit, cxCheckBox,
  dsdAddOn, dsdDB, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  Vcl.Controls, cxGrid, AncestorGuides, cxPCdxBarPopupMenu, Vcl.Menus, cxPC,
  Vcl.DBActns, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxLabel, Vcl.StdCtrls, ExternalLoad, cxBlobEdit, cxMemo;

type
  TGoodsForm = class(TAncestorGuidesForm)
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    NDSKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    spRefreshOneRecord: TdsdDataSetRefresh;
    spGet: TdsdStoredProc;
    mactAfterInsert: TMultiAction;
    DataSetInsert1: TDataSetInsert;
    DataSetPost1: TDataSetPost;
    FormParams: TdsdFormParams;
    spGetOnInsert: TdsdStoredProc;
    spRefreshOnInsert: TdsdExecStoredProc;
    InsertRecord1: TInsertRecord;
    MinimumLot: TcxGridDBColumn;
    UpdateDataSet: TdsdUpdateDataSet;
    spUpdate_Goods_MinimumLot: TdsdStoredProc;
    IsClose: TcxGridDBColumn;
    IsTop: TcxGridDBColumn;
    PercentMarkup: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    isFirst: TcxGridDBColumn;
    spUpdate_Goods_isFirst: TdsdStoredProc;
    Color_calc: TcxGridDBColumn;
    RetailCode: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    spUpdate_Goods_isSecond: TdsdStoredProc;
    spUpdate_Goods_Published: TdsdStoredProc;
    actPublished: TdsdExecStoredProc;
    actSimplePublishedList: TMultiAction;
    actPublishedList: TMultiAction;
    bbPublished: TdxBarButton;
    isMarketToday: TcxGridDBColumn;
    isSp: TcxGridDBColumn;
    LastPriceDate: TcxGridDBColumn;
    CountPrice: TcxGridDBColumn;
    MorionCode: TcxGridDBColumn;
    BarCode: TcxGridDBColumn;
    CountDays: TcxGridDBColumn;
    spUpdate_Goods_LastPriceOld: TdsdStoredProc;
    bbLabel3: TdxBarControlContainerItem;
    bbContract: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    spUpdate_Goods_NDS: TdsdStoredProc;
    macUpdateNDS: TMultiAction;
    macSimpleUpdateNDS: TMultiAction;
    actUpdateNDS: TdsdExecStoredProc;
    bbUpdateNDS: TdxBarButton;
    spUpdate_CountPrice: TdsdStoredProc;
    actUpdate_CountPrice: TdsdExecStoredProc;
    bbUpdate_CountPrice: TdxBarButton;
    isNotUploadSites: TcxGridDBColumn;
    spUpdate_Goods_isNotUploadSites: TdsdStoredProc;
    DoesNotShare: TcxGridDBColumn;
    spUpdate_Goods_DoesNotShare: TdsdStoredProc;
    GoodsAnalog: TcxGridDBColumn;
    spGetImportSetting_Goods_Price: TdsdStoredProc;
    actGetImportSetting_Goods_Price: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    AllowDivision: TcxGridDBColumn;
    spUpdate_Goods_AllowDivision: TdsdStoredProc;
    spUpdate_Goods_Analog: TdsdStoredProc;
    NotTransferTime: TcxGridDBColumn;
    actUpdateNotMarion_Yes: TdsdExecStoredProc;
    spUpdateNotMarion_Yes: TdsdStoredProc;
    actSimpleUpdateNotMarion_Yes: TMultiAction;
    macUpdateNotMarion_Yes: TMultiAction;
    spUpdateNotMarion_No: TdsdStoredProc;
    actUpdateNotMarion_No: TdsdExecStoredProc;
    actSimpleUpdateNotMarion_No: TMultiAction;
    macUpdateNotMarion_No: TMultiAction;
    bbUpdateNotMarion_Yes: TdxBarButton;
    bbUpdateNotMarion_No: TdxBarButton;
    spUpdateNot_Yes: TdsdStoredProc;
    spUpdateNot_No: TdsdStoredProc;
    actUpdateNot_No: TdsdExecStoredProc;
    actUpdateNot_Yes: TdsdExecStoredProc;
    actSimpleUpdateNot_No: TMultiAction;
    actSimpleUpdateNot_Yes: TMultiAction;
    macUpdateNot_No: TMultiAction;
    macUpdateNot_Yes: TMultiAction;
    bbUpdateNot_Yes: TdxBarButton;
    bbUpdateNot_No: TdxBarButton;
    spUpdate_Goods_isNot: TdsdStoredProc;
    spUpdate_isNOT_v2_Yes: TdsdStoredProc;
    spUpdate_isNot_v2_No: TdsdStoredProc;
    actUpdate_isNOT_v2_Yes: TdsdExecStoredProc;
    actSimpleUpdateNot_v2_Yes: TMultiAction;
    macUpdateNot_v2_Yes: TMultiAction;
    actUpdate_isSun_v2_No: TdsdExecStoredProc;
    actSimpleUpdateNot_v2_No: TMultiAction;
    macUpdateNot_v2_No: TMultiAction;
    bbUpdateNot_v2_Yes: TdxBarButton;
    bbUpdateNot_v2_No: TdxBarButton;
    spUpdate_isSun_v3_No: TdsdStoredProc;
    spUpdate_isSun_v3_yes: TdsdStoredProc;
    actUpdate_isSun_v3_No: TdsdExecStoredProc;
    actSimpleUpdate_isSUN_v3_No: TMultiAction;
    macUpdate_isSun_v3_No: TMultiAction;
    actUpdate_isSun_v3_yes: TdsdExecStoredProc;
    actSimpleUpdate_isSUN_v3_yes: TMultiAction;
    macUpdate_isSun_v3_yes: TMultiAction;
    bbUpdate_isSun_v3_yes: TdxBarButton;
    bbUpdate_isSun_v3_No: TdxBarButton;
    actSetClose: TMultiAction;
    maSetClose: TMultiAction;
    actUpdate_isClose_Yes: TdsdExecStoredProc;
    actClearClose: TMultiAction;
    maClearClose: TMultiAction;
    actUpdate_isClose_No: TdsdExecStoredProc;
    spUpdate_isClose_No: TdsdStoredProc;
    spUpdate_isClose_Yes: TdsdStoredProc;
    bbSetClose: TdxBarButton;
    bbClearClose: TdxBarButton;
    isResolution_224: TcxGridDBColumn;
    DateUpdateClose: TcxGridDBColumn;
    spUpdate_inResolution_224: TdsdStoredProc;
    actisResolution_224_Yes: TMultiAction;
    mainResolution_224_Yes: TMultiAction;
    actUpdate_inResolution_224_Yes: TdsdExecStoredProc;
    actinResolution_224_No: TMultiAction;
    mainResolution_224_No: TMultiAction;
    actUpdate_inResolution_224_No: TdsdExecStoredProc;
    spUpdate_inResolution_224_Yes: TdsdStoredProc;
    spUpdate_inResolution_224_No: TdsdStoredProc;
    bbinResolution_224_No: TdxBarButton;
    bbisResolution_224_Yes: TdxBarButton;
    actGoodsTopDialog: TExecuteDialog;
    actUpdate_inTop_Yes: TMultiAction;
    maUpdate_inTop_Yes: TMultiAction;
    actExecUpdate_inTop_Yes: TdsdExecStoredProc;
    actUpdate_inTop_No: TMultiAction;
    maUpdate_inTop_No: TMultiAction;
    actExecUpdate_inTop_No: TdsdExecStoredProc;
    spUpdate_Goods_inTop_No: TdsdStoredProc;
    spUpdate_Goods_inTop_Yes: TdsdStoredProc;
    bbUpdate_inTop_Yes: TdxBarButton;
    bbUpdate_inTop_No: TdxBarButton;
    GoodsAnalogATC: TcxGridDBColumn;
    GoodsActiveSubstance: TcxGridDBColumn;
    spUpdate_isNot_v4_No: TdsdStoredProc;
    spUpdate_isNOT_v4_Yes: TdsdStoredProc;
    actUpdate_isNot_Sun_v4_No: TdsdExecStoredProc;
    actSimpleUpdateNot_v4_No: TMultiAction;
    macUpdate_isNot_Sun_v4_No: TMultiAction;
    actUpdate_isNot_Sun_v4_Yes: TdsdExecStoredProc;
    actSimpleUpdateNot_v4_yes: TMultiAction;
    macUpdate_isNot_Sun_v4_yes: TMultiAction;
    bbUpdate_isNot_Sun_v4_yes: TdxBarButton;
    bbUpdate_isNot_Sun_v4_No: TdxBarButton;
    spUpdate_Goods_KoeffSUN: TdsdStoredProc;
    actUpdate_Goods_KoeffSUN: TdsdDataSetRefresh;
    ExecuteDialogGoods_KoeffSUN: TExecuteDialog;
    macUpdateGoods_KoeffSUN_list: TMultiAction;
    macUpdateGoods_KoeffSUN: TMultiAction;
    bbUpdateGoods_KoeffSUN: TdxBarButton;
    spUpdate_isInvisibleSUN: TdsdStoredProc;
    actUpdateInvisibleSUN: TMultiAction;
    ExecUpdate_isInvisibleSUN: TdsdExecStoredProc;
    spUpdate_isInvisibleSUN_Revert: TdsdStoredProc;
    spUpdate_Goods_LimitSun_T: TdsdStoredProc;
    actUpdate_Goods_LimitSun: TdsdDataSetRefresh;
    ExecuteDialogGoods_LimitSum: TExecuteDialog;
    macUpdateGoods_LimitSUN_list: TMultiAction;
    macUpdateGoods_LimitSUN: TMultiAction;
    bbUpdateGoods_LimitSUN: TdxBarButton;
    GoodsPairSunName: TcxGridDBColumn;
    spUpdate_GoodsPairSun: TdsdStoredProc;
    actUpdate_GoodsPairSun: TdsdDataSetRefresh;
    GoodsPairSunCode: TcxGridDBColumn;
    ExecuteDialogGoodsPairSun: TExecuteDialog;
    macUpdate_GoodsPairSun: TMultiAction;
    bbUpdate_GoodsPairSun: TdxBarButton;
    PairSunDate: TcxGridDBColumn;
    actUpdateisSupplementSUN1: TMultiAction;
    execUpdate_SupplementSUN1: TdsdExecStoredProc;
    spUpdate_isSupplementSUN1_Revert: TdsdStoredProc;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    isExceptionUKTZED: TcxGridDBColumn;
    actUpdateExceptionUKTZED: TMultiAction;
    execUpdate_ExceptionUKTZED: TdsdExecStoredProc;
    spUpdate_inExceptionUKTZED_Revert: TdsdStoredProc;
    dxBarButton2: TdxBarButton;
    isPresent: TcxGridDBColumn;
    bsUpdate: TdxBarSubItem;
    bbUpdateInvisibleSUN: TdxBarButton;
    bbUpdateisSupplementSUN1: TdxBarButton;
    bbUpdateExceptionUKTZED: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarSubItem3: TdxBarSubItem;
    actUpdate_inPresent_Revert: TMultiAction;
    execUpdate_inPresent_Revert: TdsdExecStoredProc;
    spUpdate_inPresent_Revert: TdsdStoredProc;
    dxBarSubItem4: TdxBarSubItem;
    bbUpdate_inPresent_Revert: TdxBarButton;
    SummaWages: TcxGridDBColumn;
    PercentWages: TcxGridDBColumn;
    actExec_Update_SummaWages: TdsdExecStoredProc;
    actExecuteDialog_Update_SummaWages: TExecuteDialog;
    actExec_Update_PercentWages: TdsdExecStoredProc;
    actExecuteDialogUpdate_PercentWages: TExecuteDialog;
    actUpdate_SummaWages: TMultiAction;
    actUpdate_PercentWages: TMultiAction;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    spUpdate_SummaWages: TdsdStoredProc;
    spUpdate_PercentWages: TdsdStoredProc;
    actGetImportSetting_Goods_inSupplementSUN1: TdsdExecStoredProc;
    actDoLoadinSupplementSUN1: TExecuteImportSettingsAction;
    macLoadinSupplementSUN1: TMultiAction;
    spGetImportSetting_Goods_inSupplementSUN1: TdsdStoredProc;
    dxBarButton5: TdxBarButton;
    SummaWagesStore: TcxGridDBColumn;
    PercentWagesStore: TcxGridDBColumn;
    actUpdate_SummaWagesStore: TMultiAction;
    actExec_Update_SummaWagesStore: TdsdExecStoredProc;
    actExecuteDialog_Update_SummaWagesStore: TExecuteDialog;
    actUpdate_PercentWagesStore: TMultiAction;
    actExec_Update_PercentWagesStore: TdsdExecStoredProc;
    actExecuteDialogUpdate_PercentWagesStore: TExecuteDialog;
    spUpdate_PercentWagesStore: TdsdStoredProc;
    spUpdate_SummaWagesStore: TdsdStoredProc;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    actSetUnitSupplementSUN1Out: TMultiAction;
    actClearUnitSupplementSUN1Out: TMultiAction;
    actChoiceUnitSupplementSUN1Out: TOpenChoiceForm;
    actExecSetUnitSupplementSUN1Out: TdsdExecStoredProc;
    actExecClearUnitSupplementSUN1Out: TdsdExecStoredProc;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    spSetUnitSupplementSUN1Out: TdsdStoredProc;
    spClearUnitSupplementSUN1Out: TdsdStoredProc;
    isOnlySP: TcxGridDBColumn;
    spUpdate_isOnlySP_Revert: TdsdStoredProc;
    maUpdate_isOnlySP: TMultiAction;
    actExecUpdate_isOnlySP: TdsdExecStoredProc;
    dxBarButton10: TdxBarButton;
    Multiplicity: TcxGridDBColumn;
    actUpdate_Multiplicity: TMultiAction;
    actExecUpfdate_Multiplicity: TdsdExecStoredProc;
    astExecuteDialogMultiplicity: TExecuteDialog;
    dxBarButton11: TdxBarButton;
    spUpdate_Multiplicity: TdsdStoredProc;
    isMultiplicityError: TcxGridDBColumn;
    maUpdate_isMultiplicityError: TMultiAction;
    actExecUpdate_isMultiplicityError: TdsdExecStoredProc;
    spUpdate_isMultiplicityError_Revert: TdsdStoredProc;
    dxBarButton12: TdxBarButton;
    isUkrainianTranslation: TcxGridDBColumn;
    PairSunAmount: TcxGridDBColumn;
    actDialogPercentMarkup: TExecuteDialog;
    macPercentMarkup: TMultiAction;
    actStoredProcPercentMarkup: TdsdExecStoredProc;
    spUpdatePercentMarkup: TdsdStoredProc;
    dxBarButton13: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsForm);

end.
