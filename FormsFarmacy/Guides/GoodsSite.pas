unit GoodsSite;

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
  TGoodsSiteForm = class(TAncestorGuidesForm)
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
    spUpdate_Goods_Published: TdsdStoredProc;
    actPublished: TdsdExecStoredProc;
    actSimplePublishedList: TMultiAction;
    actPublishedList: TMultiAction;
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
    spUpdate_Goods_isNotUploadSites: TdsdStoredProc;
    bbStartLoad: TdxBarButton;
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
    dxBarButton2: TdxBarButton;
    bsUpdate: TdxBarSubItem;
    bbUpdateInvisibleSUN: TdxBarButton;
    bbUpdateisSupplementSUN1: TdxBarButton;
    bbUpdateExceptionUKTZED: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarSubItem3: TdxBarSubItem;
    dxBarSubItem4: TdxBarSubItem;
    bbUpdate_inPresent_Revert: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    spUpdate_isMultiplicityError_Revert: TdsdStoredProc;
    dxBarButton12: TdxBarButton;
    dxBarButton13: TdxBarButton;
    NumberPlates: TcxGridDBColumn;
    QtyPackage: TcxGridDBColumn;
    isRecipe: TcxGridDBColumn;
    actUpdateAdditional: TdsdInsertUpdateAction;
    bbUpdateAdditional: TdxBarButton;
    ProtocolOpenMainForm: TdsdOpenForm;
    dxBarButton14: TdxBarButton;
    spUpdateGoodsAdditional: TdsdStoredProc;
    dxBarButton15: TdxBarButton;
    isExpDateExcSite: TcxGridDBColumn;
    mactUpdate_isExpDateExcSite: TMultiAction;
    actExecUpdate_isExpDateExcSite: TdsdExecStoredProc;
    spUpdate_inExpDateExcSite_Revert: TdsdStoredProc;
    dxBarButton16: TdxBarButton;
    isHideOnTheSite: TcxGridDBColumn;
    DiscontSiteStart: TcxGridDBColumn;
    DiscontSiteEnd: TcxGridDBColumn;
    DiscontAmountSite: TcxGridDBColumn;
    DiscontPercentSite: TcxGridDBColumn;
    actSiteDiscontDialog: TExecuteDialog;
    mactSiteDiscont: TMultiAction;
    spUpdate_SiteDiscont: TdsdStoredProc;
    actUpdate_SiteDiscont: TdsdExecStoredProc;
    dxBarButton17: TdxBarButton;
    dxBarButton18: TdxBarButton;
    bbtUpdate_isFirst_Yes: TdxBarButton;
    bbUpdate_isSecond_Yes: TdxBarButton;
    bbUpdate_isFirst_No: TdxBarButton;
    bbUpdate_isSecond_No: TdxBarButton;
    MakerPromoName: TcxGridDBColumn;
    actUpdateGoodsAdditional: TdsdExecStoredProc;
    actDialogGoodsAdditional: TExecuteDialog;
    mactUpdateGoodsAdditional: TMultiAction;
    MakerName: TcxGridDBColumn;
    FormDispensingName: TcxGridDBColumn;
    spUpdate_Published_Revert: TdsdStoredProc;
    mactUpdate_Published_Revert: TMultiAction;
    actUpdate_Published_Revert: TdsdExecStoredProc;
    dxBarButton19: TdxBarButton;
    dxBarButton20: TdxBarButton;
    dxBarSubItem5: TdxBarSubItem;
    spSite_Param: TdsdStoredProc;
    actFD_DownloadPublishedSite: TdsdForeignData;
    actSite_Param: TdsdExecStoredProc;
    isPublishedSite: TcxGridDBColumn;
    dxBarButton21: TdxBarButton;
    spUpdate_PublishedSite: TdsdStoredProc;
    actUpdate_PublishedSite: TdsdExecStoredProc;
    actFD_DownloadPublishedSiteOne: TdsdForeignData;
    dxBarButton22: TdxBarButton;
    actFD_UpdatePublishedSite_Revert: TdsdForeignData;
    actFD_UpdatePublishedSite_Yes: TdsdForeignData;
    actFD_UpdatePublishedSite_No: TdsdForeignData;
    mactUpdatePublishedSite_Yes: TMultiAction;
    mactDoUpdatePublishedSite_Yes: TMultiAction;
    mactUpdatePublishedSite_Revert: TMultiAction;
    mactFD_DownloadPublishedSiteOne: TMultiAction;
    dxBarButton23: TdxBarButton;
    mactUpdatePublishedSite_No: TMultiAction;
    mactDoUpdatePublishedSite_No: TMultiAction;
    dxBarButton24: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    spUpdate_Published_Yes: TdsdStoredProc;
    spUpdate_Published_No: TdsdStoredProc;
    actUpdate_Published_Yes: TdsdExecStoredProc;
    actUpdate_Published_No: TdsdExecStoredProc;
    mactUpdate_Published_Yes: TMultiAction;
    mactUpdate_Published_No: TMultiAction;
    mactUpdatePublishedSiteAll_Yes: TMultiAction;
    mactUpdatePublishedSiteAll_No: TMultiAction;
    dxBarButton25: TdxBarButton;
    dxBarButton26: TdxBarButton;
    dxBarSeparator2: TdxBarSeparator;
    dxBarSeparator3: TdxBarSeparator;
    spUpdate_PublishedAll: TdsdStoredProc;
    actFD_UpdatePublishedSiteHide: TdsdForeignData;
    mactUpdatePublishedSiteHide: TMultiAction;
    isNotUploadSites: TcxGridDBColumn;
    dxBarSeparator4: TdxBarSeparator;
    MakerNameUkr: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsSiteForm);

end.
