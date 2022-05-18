unit ReceiptProdModel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, ParentForm, dsdDB, dsdAction, dsdAddOn, dxBarExtItems,
  cxGridBandedTableView, cxGridDBBandedTableView, cxCheckBox, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCurrencyEdit, cxSplitter, cxButtonEdit, ExternalLoad, Vcl.Menus,
  Vcl.ExtCtrls, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit, cxLabel;

type
  TReceiptProdModelForm = class(TParentForm)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    MasterCDS: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    spSelect: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    bbEdit: TdxBarButton;
    actSetErased: TdsdUpdateErased;
    actSetUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    actGridToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    spErased: TdsdStoredProc;
    bbChoice: TdxBarButton;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    actChoiceGuides: TdsdChoiceGuides;
    DBViewAddOn: TdsdDBViewAddOn;
    actProtocol: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    actShowAllErased: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    Comment: TcxGridDBColumn;
    spUnErased: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    UserCode: TcxGridDBColumn;
    BrandName: TcxGridDBColumn;
    ModelName: TcxGridDBColumn;
    EngineName: TcxGridDBColumn;
    ProdColorPatternCDS: TClientDataSet;
    ProdColorPatternDS: TDataSource;
    dsdDBViewAddOnProdColorPattern: TdsdDBViewAddOn;
    cxGridProdColorPattern: TcxGrid;
    cxGridDBTableViewProdColorPattern: TcxGridDBTableView;
    ProdColorPatternName_ch2: TcxGridDBColumn;
    Value_ch2: TcxGridDBColumn;
    Comment_ch2: TcxGridDBColumn;
    InsertDate_ch2: TcxGridDBColumn;
    InsertName_ch2: TcxGridDBColumn;
    isErased_ch2: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxGridGoods: TcxGrid;
    cxGridDBTableViewGoods: TcxGridDBTableView;
    ObjectName_ch1: TcxGridDBColumn;
    Comment_ch1: TcxGridDBColumn;
    InsertDate_ch1: TcxGridDBColumn;
    InsertName_ch1: TcxGridDBColumn;
    isErased_ch1: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    cxTopSplitter: TcxSplitter;
    cxRightSplitter: TcxSplitter;
    GoodsCDS: TClientDataSet;
    GoodsDS: TDataSource;
    dsdDBViewAddOnGoods: TdsdDBViewAddOn;
    spSelect_Goods: TdsdStoredProc;
    spSelect_ProdColorPattern: TdsdStoredProc;
    actInsertRecordGoods: TInsertRecord;
    bbInsertRecordProdColorItems: TdxBarButton;
    actUpdateDataSetGoods: TdsdUpdateDataSet;
    spInsertUpdate_Goods: TdsdStoredProc;
    spInsertUpdate_ProdColorPattern: TdsdStoredProc;
    bbInsertRecordProdOptItems: TdxBarButton;
    spErasedGoods: TdsdStoredProc;
    spUnErasedGoods: TdsdStoredProc;
    spErasedProdColorPattern: TdsdStoredProc;
    spUnErasedProdColorPattern: TdsdStoredProc;
    actSetErasedGoods: TdsdUpdateErased;
    actSetUnErasedGoods: TdsdUpdateErased;
    bbSetErasedColor: TdxBarButton;
    bbSetUnErasedColor: TdxBarButton;
    bbSetErasedOpt: TdxBarButton;
    bbSetUnErasedOpt: TdxBarButton;
    FormParams: TdsdFormParams;
    spGetImportSettingId: TdsdStoredProc;
    actGetImportSetting: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    actChoiceFormGoods: TOpenChoiceForm;
    bbShowAllColorItems: TdxBarButton;
    bbShowAllOptItems: TdxBarButton;
    NPP_ch1: TcxGridDBColumn;
    BarSubItemBoat: TdxBarSubItem;
    BarSubItemColor: TdxBarSubItem;
    BarSubItemOption: TdxBarSubItem;
    bbShowAllBoatSale: TdxBarButton;
    isMain: TcxGridDBColumn;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    PopupMenuColor: TPopupMenu;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PopupMenuOption: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    Value_ch1: TcxGridDBColumn;
    PanelMaster: TPanel;
    PanelGoods: TPanel;
    PanelProdColorPattern: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    actChoiceFormReceiptLevel_ch1: TOpenChoiceForm;
    lbReceiptLevel: TcxLabel;
    edReceiptLevel: TcxButtonEdit;
    GuidesReceiptLevel: TdsdGuides;
    bbReceiptLevelLabel: TdxBarControlContainerItem;
    bbReceiptLevel: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    Color_value_ch1: TcxGridDBColumn;
    Color_Level_ch1: TcxGridDBColumn;
    Bold_isReceiptGoods_ch1: TcxGridDBColumn;
    lbModel: TcxLabel;
    edModel: TcxButtonEdit;
    GuidesModel: TdsdGuides;
    bbModelLabel: TdxBarControlContainerItem;
    bbModel: TdxBarControlContainerItem;
    PartnerName_ch1: TcxGridDBColumn;
    UnitName_ch1: TcxGridDBColumn;
    PartnerName_ch3: TcxGridDBColumn;
    UnitName_ch3: TcxGridDBColumn;
    Article_all_ch1: TcxGridDBColumn;
    bbSearchArticleLabel: TdxBarControlContainerItem;
    bbSearchArticle: TdxBarControlContainerItem;
    lbSearchArticle: TcxLabel;
    edSearchArticle: TcxTextEdit;
    FieldFilter_Article: TdsdFieldFilter;
    isCheck_ch1: TcxGridDBColumn;
    OperDate_protocol_ch1: TcxGridDBColumn;
    UserName_protocol_ch1: TcxGridDBColumn;
    Color_isCheck_ch1: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsColorCDS: TClientDataSet;
    spSelectPrintStructureGoods: TdsdStoredProc;
    actPrintStructureGoods: TdsdPrintAction;
    bbPrintStructureGoods: TdxBarButton;
    spSelectPrintStructure: TdsdStoredProc;
    actPrintStructure: TdsdPrintAction;
    bbPrintStructure: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    actInsertRecordGoods_limit: TInsertRecord;
    actChoiceFormGoods_limit: TOpenChoiceForm;
    bbInsertRecordGoods_limit: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReceiptProdModelForm);

end.
