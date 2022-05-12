unit GoodsWages;

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
  TGoodsWagesForm = class(TAncestorGuidesForm)
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
    bbPublished: TdxBarButton;
    MorionCode: TcxGridDBColumn;
    bbLabel3: TdxBarControlContainerItem;
    bbContract: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    bbUpdateNDS: TdxBarButton;
    bbUpdate_CountPrice: TdxBarButton;
    bbStartLoad: TdxBarButton;
    bbUpdateNotMarion_Yes: TdxBarButton;
    bbUpdateNotMarion_No: TdxBarButton;
    actUpdateNot_No: TdsdExecStoredProc;
    actUpdateNot_Yes: TdsdExecStoredProc;
    actSimpleUpdateNot_No: TMultiAction;
    actSimpleUpdateNot_Yes: TMultiAction;
    macUpdateNot_No: TMultiAction;
    macUpdateNot_Yes: TMultiAction;
    bbUpdateNot_Yes: TdxBarButton;
    bbUpdateNot_No: TdxBarButton;
    bbUpdateNot_v2_Yes: TdxBarButton;
    bbUpdateNot_v2_No: TdxBarButton;
    bbUpdate_isSun_v3_yes: TdxBarButton;
    bbUpdate_isSun_v3_No: TdxBarButton;
    bbSetClose: TdxBarButton;
    bbClearClose: TdxBarButton;
    bbinResolution_224_No: TdxBarButton;
    bbisResolution_224_Yes: TdxBarButton;
    actGoodsTopDialog: TExecuteDialog;
    bbUpdate_inTop_Yes: TdxBarButton;
    bbUpdate_inTop_No: TdxBarButton;
    bbUpdate_isNot_Sun_v4_yes: TdxBarButton;
    bbUpdate_isNot_Sun_v4_No: TdxBarButton;
    bbUpdateGoods_KoeffSUN: TdxBarButton;
    actUpdate_Goods_LimitSun: TdsdDataSetRefresh;
    ExecuteDialogGoods_LimitSum: TExecuteDialog;
    bbUpdateGoods_LimitSUN: TdxBarButton;
    actUpdate_GoodsPairSun: TdsdDataSetRefresh;
    ExecuteDialogGoodsPairSun: TExecuteDialog;
    macUpdate_GoodsPairSun: TMultiAction;
    bbUpdate_GoodsPairSun: TdxBarButton;
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
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    dxBarButton13: TdxBarButton;
    dxBarSubItem5: TdxBarSubItem;
    dxBarButton14: TdxBarButton;
    dxBarButton15: TdxBarButton;
    dxBarButton16: TdxBarButton;
    dxBarButton17: TdxBarButton;
    dxBarButton18: TdxBarButton;
    dxBarButton19: TdxBarButton;
    dxBarButton20: TdxBarButton;
    dxBarButton21: TdxBarButton;
    dxBarSubItem6: TdxBarSubItem;
    dxBarButton22: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsWagesForm);

end.
