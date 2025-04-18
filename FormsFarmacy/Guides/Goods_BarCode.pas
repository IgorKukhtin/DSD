unit Goods_BarCode;

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
  dxSkinXmas2008Blue, cxSplitter;

type
  TGoods_BarCodeForm = class(TAncestorGuidesForm)
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    NDS: TcxGridDBColumn;
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
    MinimumLot: TcxGridDBColumn;
    UpdateDataSet: TdsdUpdateDataSet;
    spUpdate_Goods_BarCode: TdsdStoredProc;
    IsClose: TcxGridDBColumn;
    IsTop: TcxGridDBColumn;
    PercentMarkup: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    isFirst: TcxGridDBColumn;
    Color_calc: TcxGridDBColumn;
    RetailCode: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    bbPublished: TdxBarButton;
    isMarketToday: TcxGridDBColumn;
    isSp: TcxGridDBColumn;
    LastPriceDate: TcxGridDBColumn;
    CountPrice: TcxGridDBColumn;
    MorionCode: TcxGridDBColumn;
    BarCode: TcxGridDBColumn;
    OrdBar: TcxGridDBColumn;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chBarCode: TcxGridDBColumn;
    chisErrorBarCode: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    spSelect_Object_Goods_BarCode: TdsdStoredProc;
    DetailDS: TDataSource;
    DetailDCS: TClientDataSet;
    isErrorBarCode: TcxGridDBColumn;
    BarCode_Color: TcxGridDBColumn;
    spInsertUpdate_Goods_BarCode: TdsdStoredProc;
    UpdateDataSetDetail: TdsdUpdateDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoods_BarCodeForm);

end.
