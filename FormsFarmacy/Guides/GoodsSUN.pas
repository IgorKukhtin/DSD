unit GoodsSUN;

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
  TGoodsSUNForm = class(TAncestorGuidesForm)
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    NDSKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    spRefreshOneRecord: TdsdDataSetRefresh;
    mactAfterInsert: TMultiAction;
    FormParams: TdsdFormParams;
    spRefreshOnInsert: TdsdExecStoredProc;
    IsClose: TcxGridDBColumn;
    IsTop: TcxGridDBColumn;
    isFirst: TcxGridDBColumn;
    Color_calc: TcxGridDBColumn;
    RetailCode: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    bbPublished: TdxBarButton;
    isSp: TcxGridDBColumn;
    MorionCode: TcxGridDBColumn;
    bbLabel3: TdxBarControlContainerItem;
    bbContract: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    bbUpdateNDS: TdxBarButton;
    bbUpdate_CountPrice: TdxBarButton;
    bbStartLoad: TdxBarButton;
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
    bbSetClose: TdxBarButton;
    bbClearClose: TdxBarButton;
    isResolution_224: TcxGridDBColumn;
    DateUpdateClose: TcxGridDBColumn;
    bbinResolution_224_No: TdxBarButton;
    bbisResolution_224_Yes: TdxBarButton;
    actGoodsTopDialog: TExecuteDialog;
    bbUpdate_inTop_Yes: TdxBarButton;
    bbUpdate_inTop_No: TdxBarButton;
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
    isInvisibleSUN: TcxGridDBColumn;
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
    isSupplementSUN1: TcxGridDBColumn;
    actUpdateisSupplementSUN1: TMultiAction;
    execUpdate_SupplementSUN1: TdsdExecStoredProc;
    spUpdate_isSupplementSUN1_Revert: TdsdStoredProc;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    bsUpdate: TdxBarSubItem;
    bbUpdateInvisibleSUN: TdxBarButton;
    bbUpdateisSupplementSUN1: TdxBarButton;
    bbUpdateExceptionUKTZED: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarSubItem3: TdxBarSubItem;
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
    KoeffSUN_Supplementv1: TcxGridDBColumn;
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
    UnitSupplementSUN1OutName: TcxGridDBColumn;
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
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    isUkrainianTranslation: TcxGridDBColumn;
    PairSunAmount: TcxGridDBColumn;
    dxBarButton13: TdxBarButton;
    UnitSupplementSUN2OutName: TcxGridDBColumn;
    actSetUnitSupplementSUN2Out: TMultiAction;
    actExecSetUnitSupplementSUN2Out: TdsdExecStoredProc;
    actClearUnitSupplementSUN2Out: TMultiAction;
    actExecClearUnitSupplementSUN2Out: TdsdExecStoredProc;
    dxBarSubItem5: TdxBarSubItem;
    dxBarButton14: TdxBarButton;
    dxBarButton15: TdxBarButton;
    spSetUnitSupplementSUN2Out: TdsdStoredProc;
    spClearUnitSupplementSUN2Out: TdsdStoredProc;
    isSupplementSmudge: TcxGridDBColumn;
    spUpdate_inSupplementSmudge: TdsdStoredProc;
    mactUpdate_inSupplementSmudge: TMultiAction;
    execUpdate_inSupplementSmudge: TdsdExecStoredProc;
    dxBarButton16: TdxBarButton;
    SupplementMin: TcxGridDBColumn;
    actExecuteDialog_SupplementMin: TExecuteDialog;
    mactUpdate_SupplementMin: TMultiAction;
    actExec_Update_SupplementMin: TdsdExecStoredProc;
    spUpdate_SupplementMin: TdsdStoredProc;
    dxBarButton17: TdxBarButton;
    SupplementMinPP: TcxGridDBColumn;
    spUpdate_SupplementMinPP: TdsdStoredProc;
    actExecuteDialog_SupplementMinPP: TExecuteDialog;
    mactUpdate_SupplementMinPP: TMultiAction;
    actExec_Update_SupplementMinPP: TdsdExecStoredProc;
    dxBarButton18: TdxBarButton;
    isAllowedPlatesSUN: TcxGridDBColumn;
    spUpdate_inAllowedPlatesSUN_Revert: TdsdStoredProc;
    mactUpdate_inAllowedPlatesSUN_Revert: TMultiAction;
    actUpdate_inAllowedPlatesSUN_Revert: TdsdExecStoredProc;
    dxBarButton19: TdxBarButton;
    isColdSUNCK: TcxGridDBColumn;
    isColdSUN: TcxGridDBColumn;
    spUpdate_isColdSUN: TdsdStoredProc;
    mactUpdate_isColdSUN: TMultiAction;
    actUpdate_isColdSUN: TdsdExecStoredProc;
    dxBarButton20: TdxBarButton;
    isSupplementSUN2: TcxGridDBColumn;
    actUpdateisSupplementSUN2: TMultiAction;
    execUpdate_SupplementSUN2: TdsdExecStoredProc;
    dxBarButton21: TdxBarButton;
    spUpdate_isSupplementSUN2_Revert: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsSUNForm);

end.
