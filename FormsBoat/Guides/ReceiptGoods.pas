unit ReceiptGoods;

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
  Vcl.ExtCtrls, cxContainer, cxTextEdit, cxLabel;

type
  TReceiptGoodsForm = class(TParentForm)
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
    bbShowAllErased: TdxBarButton;
    Comment: TcxGridDBColumn;
    spUnErased: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    UserCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    cxGridCh1: TcxGrid;
    cxGridDBTableViewCh1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxTopSplitter: TcxSplitter;
    cxRightSplitter: TcxSplitter;
    Child1CDS: TClientDataSet;
    Child1DS: TDataSource;
    dsdDBViewAddOnGoods: TdsdDBViewAddOn;
    spSelect_child2: TdsdStoredProc;
    actInsertRecordGoods: TInsertRecord;
    bbInsertRecordProdColorItems: TdxBarButton;
    actUpdateDataSet_Child1: TdsdUpdateDataSet;
    spInsertUpdate_Child1: TdsdStoredProc;
    bbInsertRecordProdOptItems: TdxBarButton;
    spErasedGoods: TdsdStoredProc;
    spUnErasedGoods: TdsdStoredProc;
    actSetErasedGoods: TdsdUpdateErased;
    actSetUnErasedGoods: TdsdUpdateErased;
    bbSetErasedColor: TdxBarButton;
    bbSetUnErasedColor: TdxBarButton;
    bbSetErasedOpt: TdxBarButton;
    bbSetUnErasedOpt: TdxBarButton;
    FormParams: TdsdFormParams;
    spGetImportSettingId: TdsdStoredProc;
    bbStartLoad: TdxBarButton;
    actChoiceFormGoods_1: TOpenChoiceForm;
    bbShowAllColorItems: TdxBarButton;
    bbShowAllOptItems: TdxBarButton;
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
    PanelMaster: TPanel;
    PanelGoods: TPanel;
    Panel3: TPanel;
    Panel1: TPanel;
    Child2CDS: TClientDataSet;
    Child2DS: TDataSource;
    dsdDBViewAddOnCh2: TdsdDBViewAddOn;
    spSelect_child1: TdsdStoredProc;
    Panel2: TPanel;
    cxGridCh2: TcxGrid;
    cxGridDBTableViewCh2: TcxGridDBTableView;
    NPP_ch2: TcxGridDBColumn;
    GoodsGroupNameFull_ch2: TcxGridDBColumn;
    GoodsGroupName_2: TcxGridDBColumn;
    Article_2: TcxGridDBColumn;
    GoodsCode_ch2: TcxGridDBColumn;
    GoodsName_ch2: TcxGridDBColumn;
    ProdColorName_ch2: TcxGridDBColumn;
    MeasureName_ch2: TcxGridDBColumn;
    Value_ch2: TcxGridDBColumn;
    EKPrice_ch2: TcxGridDBColumn;
    EKPriceWVAT_ch2: TcxGridDBColumn;
    EKPrice_summ_ch2: TcxGridDBColumn;
    EKPriceWVAT_summ_ch2: TcxGridDBColumn;
    Comment_ch2: TcxGridDBColumn;
    isErased_ch2: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    Panel4: TPanel;
    spInsertUpdate_Child2: TdsdStoredProc;
    ProdColorPatternName_ch2: TcxGridDBColumn;
    actChoiceFormGoods_2: TOpenChoiceForm;
    actChoiceFormProdColorPattern_2: TOpenChoiceForm;
    actUpdateDataSet_Child2: TdsdUpdateDataSet;
    DescName_ch1: TcxGridDBColumn;
    InsertRecordProdColorPattern: TInsertRecord;
    actSetErasedProdColorPattern: TdsdUpdateErased;
    spErasedProdColorPattern: TdsdStoredProc;
    spUnErasedProdColorPattern: TdsdStoredProc;
    actUnErasedProdColorPattern: TdsdUpdateErased;
    bbInsertRecordProdColorPattern: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    bbSetErasedProdColorPattern: TdxBarButton;
    bbUnErasedProdColorPattern: TdxBarButton;
    actShowAll_ch2: TBooleanStoredProcAction;
    bbShowAll_ch1: TdxBarButton;
    isEnabled_ch2: TcxGridDBColumn;
    Color_value_ch1: TcxGridDBColumn;
    Color_Level_ch1: TcxGridDBColumn;
    actChoiceFormProdColor_goods_2: TOpenChoiceForm;
    spGetImportSettingId_Osculati: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSettingId: TdsdExecStoredProc;
    mactStartLoad: TMultiAction;
    spSelectPrintStructureGoods: TdsdStoredProc;
    actPrintStructureGoods: TdsdPrintAction;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsColorCDS: TClientDataSet;
    spSelectPrintStructure: TdsdStoredProc;
    actPrintStructure: TdsdPrintAction;
    bbPrintStructure: TdxBarButton;
    Panel5: TPanel;
    lbSearchArticle: TcxLabel;
    edSearchArticle: TcxTextEdit;
    FieldFilter_Article: TdsdFieldFilter;
    actInsertRecordGoods_limit: TInsertRecord;
    actChoiceFormGoods_limit: TOpenChoiceForm;
    bbInsertRecordGood: TdxBarButton;
    bbBarSeparetor: TdxBarSeparator;
    actGridCh1ToExcel: TdsdGridToExcel;
    bbGridCh1ToExcel: TdxBarButton;
    actInsertEnter: TdsdInsertUpdateAction;
    bbInsertEnter: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    MaterialOptionsName_ch1: TcxGridDBColumn;
    actChoiceFormMaterialOptions_1: TOpenChoiceForm;
    actChoiceFormMaterialOptions_2: TOpenChoiceForm;
    MaterialOptionsName: TcxGridDBColumn;
    ProdColorName_pcp: TcxGridDBColumn;
    ColorPatternName_ch2: TcxGridDBColumn;
    ProdColorPatternName_all_ch2: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReceiptGoodsForm);

end.
