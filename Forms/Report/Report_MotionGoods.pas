unit Report_MotionGoods;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, dsdAddOn,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit, dsdGuides,
  cxButtonEdit, ChoicePeriod, cxLabel, dxBarExtItems;

type
  TReport_MotionGoodsForm = class(TParentForm)
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    dsdStoredProc: TdsdStoredProc;
    CountStart: TcxGridDBColumn;
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    CountIncome: TcxGridDBColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    LocationName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    PartionGoodsName: TcxGridDBColumn;
    AssetName: TcxGridDBColumn;
    SummStart: TcxGridDBColumn;
    SummIncome: TcxGridDBColumn;
    CountEnd: TcxGridDBColumn;
    SummEnd: TcxGridDBColumn;
    CountSendIn: TcxGridDBColumn;
    SummSendIn: TcxGridDBColumn;
    CountSendOut: TcxGridDBColumn;
    SummSendOut: TcxGridDBColumn;
    CountSale: TcxGridDBColumn;
    SummSale: TcxGridDBColumn;
    CountReturnOut: TcxGridDBColumn;
    SummReturnOut: TcxGridDBColumn;
    CountReturnIn: TcxGridDBColumn;
    SummReturnIn: TcxGridDBColumn;
    CountLoss: TcxGridDBColumn;
    SummLoss: TcxGridDBColumn;
    CountInventory: TcxGridDBColumn;
    SummInventory: TcxGridDBColumn;
    PriceStart: TcxGridDBColumn;
    GoodsGroupGuides: TdsdGuides;
    LocationGuides: TdsdGuides;
    edGoodsGroup: TcxButtonEdit;
    edUnitGroup: TcxButtonEdit;
    PeriodChoice: TPeriodChoice;
    bbDialogForm: TdxBarButton;
    edGoods: TcxButtonEdit;
    RefreshDispatcher: TRefreshDispatcher;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    PriceIncome: TcxGridDBColumn;
    PriceSendIn: TcxGridDBColumn;
    PriceSendOut: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    PriceReturnOut: TcxGridDBColumn;
    PriceReturnIn: TcxGridDBColumn;
    PriceLoss: TcxGridDBColumn;
    PriceInventory: TcxGridDBColumn;
    PriceEnd: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    UnitGroupGuides: TdsdGuides;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    GoodsGuides: TdsdGuides;
    edLocation: TcxButtonEdit;
    cxLabel4: TcxLabel;
    MeasureName: TcxGridDBColumn;
    Weight: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    dxBarStatic1: TdxBarStatic;
    LocationDescName: TcxGridDBColumn;
    LocationCode: TcxGridDBColumn;
    CarCode: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    PriceSendOnPriceIn: TcxGridDBColumn;
    PriceSendOnPriceOut: TcxGridDBColumn;
    CountSendOnPriceIn: TcxGridDBColumn;
    SummSendOnPriceIn: TcxGridDBColumn;
    CountSendOnPriceOut: TcxGridDBColumn;
    SummSendOnPriceOut: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_MotionGoodsForm);

end.
