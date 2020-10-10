unit Product;

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
  cxCurrencyEdit, cxSplitter;

type
  TProductForm = class(TParentForm)
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
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    Comment: TcxGridDBColumn;
    spUnErased: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    Hours: TcxGridDBColumn;
    DateStart: TcxGridDBColumn;
    DateBegin: TcxGridDBColumn;
    DateSale: TcxGridDBColumn;
    Article: TcxGridDBColumn;
    CIN: TcxGridDBColumn;
    EngineNum: TcxGridDBColumn;
    BrandName: TcxGridDBColumn;
    ModelName: TcxGridDBColumn;
    EngineName: TcxGridDBColumn;
    ProdOptItemsCDS: TClientDataSet;
    ProdOptItemsDS: TDataSource;
    dsdDBViewAddOnProdOptItems: TdsdDBViewAddOn;
    cxGridProdOptItems: TcxGrid;
    cxGridDBTableViewProdOptItems: TcxGridDBTableView;
    optCode: TcxGridDBColumn;
    optName: TcxGridDBColumn;
    colPriceOut: TcxGridDBColumn;
    optPriceIn: TcxGridDBColumn;
    optProdOptions: TcxGridDBColumn;
    colPartNumber: TcxGridDBColumn;
    optComment: TcxGridDBColumn;
    optInsertDate: TcxGridDBColumn;
    optInsertName: TcxGridDBColumn;
    OptisErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxGridProdColorItems: TcxGrid;
    cxGridDBTableViewProdColorItems: TcxGridDBTableView;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colProdColor: TcxGridDBColumn;
    colProdColorGroupName: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    colInsertDate: TcxGridDBColumn;
    colInsertName: TcxGridDBColumn;
    colisErased: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    cxTopSplitter: TcxSplitter;
    cxRightSplitter: TcxSplitter;
    ProdColorItemsCDS: TClientDataSet;
    ProdColorItemsDS: TDataSource;
    dsdDBViewAddOnProdColorItems: TdsdDBViewAddOn;
    spSelect_ProdColorItems: TdsdStoredProc;
    spSelect_ProdOptItems: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductForm);

end.
