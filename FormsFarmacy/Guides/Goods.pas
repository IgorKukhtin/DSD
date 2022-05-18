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
    GoodsAnalog: TcxGridDBColumn;
    spGetImportSetting_Goods_Price: TdsdStoredProc;
    actGetImportSetting_Goods_Price: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    spUpdate_Goods_Analog: TdsdStoredProc;
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
    bbUpdateNot_Yes: TdxBarButton;
    bbUpdateNot_No: TdxBarButton;
    bbUpdateNot_v2_Yes: TdxBarButton;
    bbUpdateNot_v2_No: TdxBarButton;
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
    bbUpdate_isNot_Sun_v4_yes: TdxBarButton;
    bbUpdate_isNot_Sun_v4_No: TdxBarButton;
    bbUpdateGoods_KoeffSUN: TdxBarButton;
    spUpdate_isInvisibleSUN: TdsdStoredProc;
    bbUpdateGoods_LimitSUN: TdxBarButton;
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
    dxBarSubItem4: TdxBarSubItem;
    bbUpdate_inPresent_Revert: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    isOnlySP: TcxGridDBColumn;
    spUpdate_isOnlySP_Revert: TdsdStoredProc;
    maUpdate_isOnlySP: TMultiAction;
    actExecUpdate_isOnlySP: TdsdExecStoredProc;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    isUkrainianTranslation: TcxGridDBColumn;
    actDialogPercentMarkup: TExecuteDialog;
    macPercentMarkup: TMultiAction;
    actStoredProcPercentMarkup: TdsdExecStoredProc;
    spUpdatePercentMarkup: TdsdStoredProc;
    dxBarButton13: TdxBarButton;
    MakerName: TcxGridDBColumn;
    FormDispensingName: TcxGridDBColumn;
    NumberPlates: TcxGridDBColumn;
    QtyPackage: TcxGridDBColumn;
    isRecipe: TcxGridDBColumn;
    actUpdateAdditional: TdsdInsertUpdateAction;
    bbUpdateAdditional: TdxBarButton;
    ProtocolOpenMainForm: TdsdOpenForm;
    dxBarButton14: TdxBarButton;
    spUpdateGoodsAdditional: TdsdStoredProc;
    actUpdateGoodsAdditional: TdsdExecStoredProc;
    actDialogGoodsAdditional: TExecuteDialog;
    dxBarButton15: TdxBarButton;
    mactUpdateGoodsAdditional: TMultiAction;
    dxBarButton16: TdxBarButton;
    dxBarButton17: TdxBarButton;
    actUpdate_isFirst_No: TdsdExecStoredProc;
    mactUpdate_isFirst_Yes: TMultiAction;
    spUpdate_isFirst_No: TdsdStoredProc;
    spUpdate_isFirst_Yes: TdsdStoredProc;
    spUpdate_isSecond_No: TdsdStoredProc;
    spUpdate_isSecond_Yes: TdsdStoredProc;
    actUpdate_isFirst_Yes: TdsdExecStoredProc;
    mactUpdate_isFirst_No: TMultiAction;
    actUpdate_isSecond_Yes: TdsdExecStoredProc;
    mactUpdate_isSecond_Yes: TMultiAction;
    actUpdate_isSecond_No: TdsdExecStoredProc;
    mactUpdate_isSecond_No: TMultiAction;
    dxBarButton18: TdxBarButton;
    bbtUpdate_isFirst_Yes: TdxBarButton;
    bbUpdate_isSecond_Yes: TdxBarButton;
    bbUpdate_isFirst_No: TdxBarButton;
    bbUpdate_isSecond_No: TdxBarButton;
    MakerPromoName: TcxGridDBColumn;
    mactUpdate_Published_Revert: TMultiAction;
    actUpdate_Published_Revert: TdsdExecStoredProc;
    spUpdate_Published_Revert: TdsdStoredProc;
    dxBarButton19: TdxBarButton;
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
