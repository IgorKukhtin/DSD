unit GoodsCash;

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
  TGoodsCashForm = class(TAncestorGuidesForm)
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
    UpdateDataSet: TdsdUpdateDataSet;
    IsClose: TcxGridDBColumn;
    IsTop: TcxGridDBColumn;
    isFirst: TcxGridDBColumn;
    Color_calc: TcxGridDBColumn;
    RetailCode: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    bbPublished: TdxBarButton;
    isSp: TcxGridDBColumn;
    MorionCode: TcxGridDBColumn;
    BarCode: TcxGridDBColumn;
    bbLabel3: TdxBarControlContainerItem;
    bbContract: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    macUpdateNDS: TMultiAction;
    macSimpleUpdateNDS: TMultiAction;
    actUpdateNDS: TdsdExecStoredProc;
    bbUpdateNDS: TdxBarButton;
    bbUpdate_CountPrice: TdxBarButton;
    DoesNotShare: TcxGridDBColumn;
    spUpdate_Goods_DoesNotShare: TdsdStoredProc;
    bbStartLoad: TdxBarButton;
    AllowDivision: TcxGridDBColumn;
    spUpdate_Goods_AllowDivision: TdsdStoredProc;
    NotTransferTime: TcxGridDBColumn;
    bbUpdateNotMarion_Yes: TdxBarButton;
    bbUpdateNotMarion_No: TdxBarButton;
    macUpdateNot_No: TMultiAction;
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
    bbUpdate_inTop_Yes: TdxBarButton;
    bbUpdate_inTop_No: TdxBarButton;
    bbUpdate_isNot_Sun_v4_yes: TdxBarButton;
    bbUpdate_isNot_Sun_v4_No: TdxBarButton;
    bbUpdateGoods_KoeffSUN: TdxBarButton;
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
    spUpdate_inPresent_Revert: TdsdStoredProc;
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
    dxBarButton13: TdxBarButton;
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
    dxBarButton18: TdxBarButton;
    bbtUpdate_isFirst_Yes: TdxBarButton;
    bbUpdate_isSecond_Yes: TdxBarButton;
    bbUpdate_isFirst_No: TdxBarButton;
    bbUpdate_isSecond_No: TdxBarButton;
    MakerPromoName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsCashForm);

end.
