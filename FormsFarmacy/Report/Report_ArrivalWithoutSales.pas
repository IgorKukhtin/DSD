unit Report_ArrivalWithoutSales;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dsdGuides, cxButtonEdit, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  dxSkinsdxBarPainter, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxGridBandedTableView, cxGridDBBandedTableView, cxSplitter, dsdTranslator;

type
  TReport_ArrivalWithoutSalesForm = class(TAncestorReportForm)
    dxBarButton1: TdxBarButton;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actRefreshIsPartion: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshPartionPrice: TdsdDataSetRefresh;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actRefreshJuridical: TdsdDataSetRefresh;
    actUpdateMainDS: TdsdUpdateDataSet;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    CheckSum: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountCheck: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    actMoneyBoxSun: TdsdOpenForm;
    bbMoneyBoxSun: TdxBarButton;
    ctMinSale: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxGridMain: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    mUnitName: TcxGridDBColumn;
    mAmountIn: TcxGridDBColumn;
    mAmount: TcxGridDBColumn;
    mAmountCheck: TcxGridDBColumn;
    mCheckSum: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    DetailDS: TDataSource;
    DetailDCS: TClientDataSet;
    DBViewAddOnMain: TdsdDBViewAddOn;
    actGridMainToExcel: TdsdGridToExcel;
    dxBarButton2: TdxBarButton;
    OperDateInLast: TcxGridDBColumn;
    AmountInLast: TcxGridDBColumn;
    PriceInLast: TcxGridDBColumn;
    cbConsecutiveParishes: TcxCheckBox;
    actGoodsPartionHistory: TdsdOpenForm;
    dxBarButton3: TdxBarButton;
    cePriceIn: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_ArrivalWithoutSalesForm)

end.
