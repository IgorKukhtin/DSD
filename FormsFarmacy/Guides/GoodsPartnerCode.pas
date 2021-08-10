unit GoodsPartnerCode;

interface

uses
  DataModul, Winapi.Windows, ParentForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxCurrencyEdit, cxCheckBox,
  dsdAddOn, dsdDB, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  Vcl.Controls, cxGrid, AncestorGuides, cxPCdxBarPopupMenu, Vcl.Menus, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, cxContainer, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxLabel, dsdGuides, cxSplitter, Vcl.DBActns, dxBarBuiltInMenu,
  cxNavigator, ExternalLoad, dxSkinscxPCPainter, dxSkinsdxBarPainter,
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
  dxSkinXmas2008Blue, Vcl.ExtCtrls;

type
  TGoodsPartnerCodeForm = class(TAncestorGuidesForm)
    GoodsCodeInt: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    edPartnerCode: TcxButtonEdit;
    cxLabel1: TcxLabel;
    PartnerCodeGuides: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    RefreshDispatcher: TRefreshDispatcher;
    mactDelete: TMultiAction;
    GoodsMainName: TcxGridDBColumn;
    GoodsMainCode: TcxGridDBColumn;
    MakerName: TcxGridDBColumn;
    spDeleteLink: TdsdStoredProc;
    actDeleteLink: TdsdExecStoredProc;
    DataSetPost: TDataSetPost;
    mactSetLink: TMultiAction;
    DataSetEdit: TDataSetEdit;
    OpenChoiceForm: TOpenChoiceForm;
    spInserUpdateGoodsLink: TdsdStoredProc;
    actSetLink: TdsdExecStoredProc;
    bbSetLink: TdxBarButton;
    bbLabel: TdxBarControlContainerItem;
    bbPartnerCode: TdxBarControlContainerItem;
    dsdUpdateDataSet: TdsdUpdateDataSet;
    MinimumLot: TcxGridDBColumn;
    spUpdate_Goods_MinimumLot: TdsdStoredProc;
    spDelete_ObjectFloat_Goods_MinimumLot: TdsdStoredProc;
    actStartLoad: TMultiAction;
    actDelete_ObjectFloat_Goods_MinimumLot: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    spGetImportSetting_Goods_MinimumLot: TdsdStoredProc;
    actGetImportSetting_Goods_MinimumLot: TdsdExecStoredProc;
    bbStartLoad: TdxBarButton;
    FormParams: TdsdFormParams;
    IsUpload: TcxGridDBColumn;
    spUpdate_Goods_IsUpload: TdsdStoredProc;
    spGetImportSetting_Goods_IsUpload: TdsdStoredProc;
    spDelete_ObjectBoolean_Goods_IsUpload: TdsdStoredProc;
    actStartLoadIsUpload: TMultiAction;
    actGetImportSetting_Goods_IsUpload: TdsdExecStoredProc;
    actDelete_ObjectFloat_Goods_IsUpload: TdsdExecStoredProc;
    actDoLoadIsUpload: TExecuteImportSettingsAction;
    dxBarButton2: TdxBarButton;
    spUpdate_Goods_Promo: TdsdStoredProc;
    UpdateName: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    spUpdate_Goods_IsSpecCondition: TdsdStoredProc;
    isSpecCondition: TcxGridDBColumn;
    actDoLoadIsSpecCondition: TExecuteImportSettingsAction;
    actDelete_ObjectFloat_Goods_IsSpecCondition: TdsdExecStoredProc;
    actGetImportSetting_Goods_IsSpecCondition: TdsdExecStoredProc;
    actStartLoadIsSpecCondition: TMultiAction;
    bbSpecCondition: TdxBarButton;
    spGetImportSetting_Goods_IsSpecCondition: TdsdStoredProc;
    spDelete_ObjectBoolean_Goods_IsSpecCondition: TdsdStoredProc;
    actShowErased: TBooleanStoredProcAction;
    spErasedUnErasedGoods: TdsdStoredProc;
    dsdSetErasedGoogs: TdsdUpdateErased;
    dsdSetUnErasedGoods: TdsdUpdateErased;
    bbSetErasedGoogs: TdxBarButton;
    bbSetUnErasedGoods: TdxBarButton;
    bbShowErased: TdxBarButton;
    isErased: TcxGridDBColumn;
    CommonCode: TcxGridDBColumn;
    ConditionsKeepChoiceForm: TOpenChoiceForm;
    actDoLoadConditionsKeep: TExecuteImportSettingsAction;
    actGetImportSetting_Goods_ConditionsKeep: TdsdExecStoredProc;
    actStartLoadConditionsKeep: TMultiAction;
    spUpdate_Goods_ConditionsKeep: TdsdStoredProc;
    spGetImportSetting_Goods_ConditionsKeep: TdsdStoredProc;
    bbStartLoadConditionsKeep: TdxBarButton;
    bbIsUpdate: TdxBarControlContainerItem;
    cbUpdate: TcxCheckBox;
    spUpdate_Goods_isUploadBadm: TdsdStoredProc;
    isUploadTeva: TcxGridDBColumn;
    spUpdate_Goods_isUploadTeva: TdsdStoredProc;
    AreaName: TcxGridDBColumn;
    Panel: TPanel;
    cxLabel6: TcxLabel;
    edArea: TcxButtonEdit;
    GuidesArea: TdsdGuides;
    ProtocolOpenTwoForm: TdsdOpenForm;
    bbProtocolOpenTwoForm: TdxBarButton;
    spUpdate_Goods_isUploadYuriFarm: TdsdStoredProc;
    isUploadYuriFarm: TcxGridDBColumn;
    spUpdate_Goods_Promo_True: TdsdStoredProc;
    spUpdate_Goods_Promo_False: TdsdStoredProc;
    actUpdate_Goods_Promo_True: TMultiAction;
    actExecUpdate_Goods_Promo_True: TdsdExecStoredProc;
    actUpdate_Goods_Promo_False: TMultiAction;
    actExecUpdate_Goods_Promo_False: TdsdExecStoredProc;
    bbUpdate_Goods_Promo_True: TdxBarButton;
    bbUpdate_Goods_Promo_False: TdxBarButton;
    DiscountExternalName: TcxGridDBColumn;
    DiscountExternalChoiceForm: TOpenChoiceForm;
    spUpdate_Goods_DiscountExternal: TdsdStoredProc;
    dxBarSubItem1: TdxBarSubItem;
    actStartLoadAction: TMultiAction;
    actGetImportSetting_Goods_Action: TdsdExecStoredProc;
    actDoLoadAction: TExecuteImportSettingsAction;
    spGetImportSetting_Goods_Àction: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsPartnerCodeForm);

end.
