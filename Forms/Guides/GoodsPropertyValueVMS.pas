unit GoodsPropertyValueVMS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTLData, cxDBTL, cxMaskEdit, ParentForm, dsdDB, dsdAction,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinsdxBarPainter, dxBarExtItems,
  dsdAddOn, cxCheckBox, dxSkinscxPCPainter, cxButtonEdit, cxContainer,
  dsdGuides, cxTextEdit, cxLabel, cxCurrencyEdit;

type
  TGoodsPropertyValueVMSForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    dsdStoredProc: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    spErasedUnErased: TdsdStoredProc;
    dsdChoiceGuides: TdsdChoiceGuides;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    bbChoiceGuides: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    ceBarCode: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    ceName: TcxGridDBColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    ceAmount: TcxGridDBColumn;
    clArticle: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    clBarCodeGLN: TcxGridDBColumn;
    clArticleGLN: TcxGridDBColumn;
    clGoodsPropertyName: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    GoodsKindChoiceForm: TOpenChoiceForm;
    GoodsChoiceForm: TOpenChoiceForm;
    clGoodsKindName: TcxGridDBColumn;
    GoodsPropertyChoiceForm: TOpenChoiceForm;
    GroupName: TcxGridDBColumn;
    bbBarCCItem1: TdxBarControlContainerItem;
    bbBarCCItem2: TdxBarControlContainerItem;
    cxLabel6: TcxLabel;
    ceGoodsProperty: TcxButtonEdit;
    dsdGoodsPropertyGuides: TdsdGuides;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    BarCodeShort: TcxGridDBColumn;
    BoxCount: TcxGridDBColumn;
    CodeSticker: TcxGridDBColumn;
    Quality2: TcxGridDBColumn;
    Quality10: TcxGridDBColumn;
    spUpdateSh_Yes: TdsdStoredProc;
    spUpdateSh_No: TdsdStoredProc;
    spUpdateNom_Yes: TdsdStoredProc;
    spUpdateNom_No: TdsdStoredProc;
    spUpdateVes_Yes: TdsdStoredProc;
    spUpdateVes_No: TdsdStoredProc;
    actUpdateSh_Yes: TdsdDataSetRefresh;
    actUpdateSh_No: TdsdDataSetRefresh;
    actUpdateNom_Yes: TdsdDataSetRefresh;
    actUpdateNom_No: TdsdDataSetRefresh;
    actUpdateVes_Yes: TdsdDataSetRefresh;
    actUpdateVes_No: TdsdDataSetRefresh;
    macListUpdateSh_Yes: TMultiAction;
    macListUpdateSh_No: TMultiAction;
    macListUpdateNom_Yes: TMultiAction;
    macListUpdateNom_No: TMultiAction;
    macListUpdateVes_Yes: TMultiAction;
    macListUpdateVes_No: TMultiAction;
    macUpdateSh_Yes: TMultiAction;
    macUpdateSh_No: TMultiAction;
    macUpdateNom_Yes: TMultiAction;
    macUpdateNom_No: TMultiAction;
    macUpdateVes_Yes: TMultiAction;
    macUpdateVes_No: TMultiAction;
    bbUpdateSh_Yes: TdxBarButton;
    bbUpdateSh_No: TdxBarButton;
    bbUpdateNom_Yes: TdxBarButton;
    bbUpdateNom_No: TdxBarButton;
    bbUpdateVes_Yes: TdxBarButton;
    bbUpdateVes_No: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsPropertyValueVMSForm);

end.
