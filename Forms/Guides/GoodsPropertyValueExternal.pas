unit GoodsPropertyValueExternal;

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
  TGoodsPropertyValueExternalForm = class(TParentForm)
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
    BarCode: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    Name: TcxGridDBColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Amount: TcxGridDBColumn;
    Article: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    BarCodeGLN: TcxGridDBColumn;
    ArticleGLN: TcxGridDBColumn;
    GoodsPropertyName: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindChoiceForm: TOpenChoiceForm;
    GoodsChoiceForm: TOpenChoiceForm;
    GoodsKindName: TcxGridDBColumn;
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
    GoodsBoxChoiceForm: TOpenChoiceForm;
    BoxName: TcxGridDBColumn;
    WeightOnBox: TcxGridDBColumn;
    CountOnBox: TcxGridDBColumn;
    spUpdateisWeigth: TdsdStoredProc;
    actUpdateisWeigth: TdsdDataSetRefresh;
    bbUpdateisWeigth: TdxBarButton;
    isWeigth: TcxGridDBColumn;
    NameExternal: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsPropertyValueExternalForm);

end.
