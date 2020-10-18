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
  cxCurrencyEdit, cxSplitter, cxButtonEdit, ExternalLoad;

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
    actShowAllErased: TBooleanStoredProcAction;
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
    optProdOptPatternName: TcxGridDBColumn;
    colPriceOut: TcxGridDBColumn;
    optPriceIn: TcxGridDBColumn;
    optProdOptionsName: TcxGridDBColumn;
    colPartNumber: TcxGridDBColumn;
    optComment: TcxGridDBColumn;
    optInsertDate: TcxGridDBColumn;
    optInsertName: TcxGridDBColumn;
    optIsErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxGridProdColorItems: TcxGrid;
    cxGridDBTableViewProdColorItems: TcxGridDBTableView;
    colCode: TcxGridDBColumn;
    colProdColorPatternName: TcxGridDBColumn;
    colProdColorName: TcxGridDBColumn;
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
    InsertRecordProdColorItems: TInsertRecord;
    bbInsertRecordProdColorItems: TdxBarButton;
    actUpdateDataSetProdColorItems: TdsdUpdateDataSet;
    spInsertUpdateProdColorItems: TdsdStoredProc;
    actUpdateDataSetProdOptItems: TdsdUpdateDataSet;
    spInsertUpdateProdOptItems: TdsdStoredProc;
    InsertRecordProdOptItems: TInsertRecord;
    bbInsertRecordProdOptItems: TdxBarButton;
    spErasedColor: TdsdStoredProc;
    spUnErasedColor: TdsdStoredProc;
    spErasedOpt: TdsdStoredProc;
    spUnErasedOpt: TdsdStoredProc;
    actSetErasedColor: TdsdUpdateErased;
    actSetErasedOpt: TdsdUpdateErased;
    actSetUnErasedOpt: TdsdUpdateErased;
    actSetUnErasedColor: TdsdUpdateErased;
    bbSetErasedColor: TdxBarButton;
    bbSetUnErasedColor: TdxBarButton;
    bbSetErasedOpt: TdxBarButton;
    bbSetUnErasedOpt: TdxBarButton;
    actChoiceFormProdColor: TOpenChoiceForm;
    FormParams: TdsdFormParams;
    spGetImportSettingId: TdsdStoredProc;
    actGetImportSetting: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actStartLoad: TMultiAction;
    bbStartLoad: TdxBarButton;
    actChoiceFormProdColorGroup: TOpenChoiceForm;
    actChoiceFormProdOptions: TOpenChoiceForm;
    actShowAllOptItems: TBooleanStoredProcAction;
    actShowAllColorItems: TBooleanStoredProcAction;
    bbShowAllColorItems: TdxBarButton;
    bbShowAllOptItems: TdxBarButton;
    ProdColorName: TcxGridDBColumn;
    colNPP: TcxGridDBColumn;
    colColor_fon: TcxGridDBColumn;
    optColor_fon: TcxGridDBColumn;
    BarSubItemBoat: TdxBarSubItem;
    BarSubItemColor: TdxBarSubItem;
    BarSubItemOption: TdxBarSubItem;
    actShowAllBoatSale: TBooleanStoredProcAction;
    bbShowAllBoatSale: TdxBarButton;
    isSale: TcxGridDBColumn;
    actChoiceFormProdColorPattern: TOpenChoiceForm;
    actChoiceFormProdOptPattern: TOpenChoiceForm;
    PriceIn: TcxGridDBColumn;
    PriceOut: TcxGridDBColumn;
    PriceIn2: TcxGridDBColumn;
    PriceOut2: TcxGridDBColumn;
    PriceIn3: TcxGridDBColumn;
    PriceOut3: TcxGridDBColumn;
    optNPP: TcxGridDBColumn;
    Color_fon: TcxGridDBColumn;
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
