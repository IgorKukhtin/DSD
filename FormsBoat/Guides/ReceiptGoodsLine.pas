unit ReceiptGoodsLine;

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
  Vcl.ExtCtrls, cxContainer, cxTextEdit, cxLabel, dsdGuides, cxMaskEdit;

type
  TReceiptGoodsLineForm = class(TParentForm)
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
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    actChoiceGuides: TdsdChoiceGuides;
    DBViewAddOn: TdsdDBViewAddOn;
    actProtocol: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    actShowAllErased: TBooleanStoredProcAction;
    bbShowAllErased: TdxBarButton;
    spUnErased: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    cxTopSplitter: TcxSplitter;
    cxRightSplitter: TcxSplitter;
    actInsertRecordGoods: TInsertRecord;
    bbInsertRecordProdColorItems: TdxBarButton;
    actUpdateDataSet_Child1: TdsdUpdateDataSet;
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
    cxSplitter1: TcxSplitter;
    actChoiceFormGoods_2: TOpenChoiceForm;
    actChoiceFormProdColorPattern_2: TOpenChoiceForm;
    actUpdateDataSet_Child2: TdsdUpdateDataSet;
    InsertRecordProdColorPattern: TInsertRecord;
    actSetErasedProdColorPattern: TdsdUpdateErased;
    actUnErasedProdColorPattern: TdsdUpdateErased;
    bbInsertRecordProdColorPattern: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    bbSetErasedProdColorPattern: TdxBarButton;
    bbUnErasedProdColorPattern: TdxBarButton;
    actShowAll_ch2: TBooleanStoredProcAction;
    bbShowAll_ch1: TdxBarButton;
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
    actChoiceFormMaterialOptions_1: TOpenChoiceForm;
    actChoiceFormMaterialOptions_2: TOpenChoiceForm;
    actChoiceFormProdOptions_ñomment: TOpenChoiceForm;
    lbReceiptLevel: TcxLabel;
    edReceiptLevel: TcxButtonEdit;
    GuidesReceiptLevel: TdsdGuides;
    actChoiceFormGoodsChild_1: TOpenChoiceForm;
    actChoiceFormReceiptLevel_ch2: TOpenChoiceForm;
    actChoiceFormGoodsChild_2: TOpenChoiceForm;
    actInsertUpdate_Unit: TdsdExecStoredProc;
    macInsertUpdate_Unit_list: TMultiAction;
    macInsertUpdate_Unit: TMultiAction;
    bbInsertUpdate_Unit: TdxBarButton;
    PanelMaster: TPanel;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    isMain: TcxGridDBColumn;
    Code: TcxGridDBColumn;
    UserCode: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    ColorPatternName: TcxGridDBColumn;
    Article: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    ProdColorName: TcxGridDBColumn;
    Comment_goods: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    BasisPrice: TcxGridDBColumn;
    BasisPriceWVAT: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    InsertDate: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    UpdateName: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    NPP_ch1: TcxGridDBColumn;
    DescName_ch1: TcxGridDBColumn;
    GoodsGroupNameFull_ch1: TcxGridDBColumn;
    GoodsGroupName_ch1: TcxGridDBColumn;
    ObjectCode_ch1: TcxGridDBColumn;
    ReceiptLevelName_ch1: TcxGridDBColumn;
    Article_ch1: TcxGridDBColumn;
    Article_all_ch1: TcxGridDBColumn;
    ObjectName_ch1: TcxGridDBColumn;
    ProdColorName_ch1: TcxGridDBColumn;
    MaterialOptionsName_ch1: TcxGridDBColumn;
    Comment_goods_ch1: TcxGridDBColumn;
    MeasureName_ch1: TcxGridDBColumn;
    Value_ch1: TcxGridDBColumn;
    Value_service_ch1: TcxGridDBColumn;
    ForCount_ch1: TcxGridDBColumn;
    EKPrice_ch1: TcxGridDBColumn;
    EKPriceWVAT_ch1: TcxGridDBColumn;
    EKPrice_summ_ch1: TcxGridDBColumn;
    EKPriceWVAT_summ_ch1: TcxGridDBColumn;
    Comment_ch1: TcxGridDBColumn;
    InsertDate_ch1: TcxGridDBColumn;
    InsertName_ch1: TcxGridDBColumn;
    UpdateDate_ch1: TcxGridDBColumn;
    UpdateName_ch1: TcxGridDBColumn;
    isErased_ch1: TcxGridDBColumn;
    GoodsChildName_ch1: TcxGridDBColumn;
    ProdColorGroupName_ch2: TcxGridDBColumn;
    ProdColorPatternName_ch2: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    Panel3: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReceiptGoodsLineForm);

end.
