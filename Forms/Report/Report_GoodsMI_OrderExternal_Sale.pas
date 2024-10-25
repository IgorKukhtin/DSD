unit Report_GoodsMI_OrderExternal_Sale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TReport_GoodsMI_OrderExternal_SaleForm = class(TAncestorReportForm)
    GoodsGroupName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    AmountSumm1: TcxGridDBColumn;
    Amount_Weight1: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    Amount_Sh1: TcxGridDBColumn;
    RouteSortingName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    AmountSummTotal: TcxGridDBColumn;
    AmountSumm2: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount_Weight2: TcxGridDBColumn;
    Amount_Sh2: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    actPrint_byByer: TdsdPrintAction;
    bbPrintPrint_byByer: TdxBarButton;
    RouteName: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    bbPrint_byPack: TdxBarButton;
    cxLabel13: TcxLabel;
    edRouteSorting: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edRoute: TcxButtonEdit;
    GuidesRouteSorting: TdsdGuides;
    GuidesRoute: TdsdGuides;
    cxLabel3: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    edTo: TcxButtonEdit;
    cxLabel8: TcxLabel;
    GuidesTo: TdsdGuides;
    Amount_Weight_Itog: TcxGridDBColumn;
    Amount_Sh_Itog: TcxGridDBColumn;
    Amount_Weight_Dozakaz: TcxGridDBColumn;
    Amount_Sh_Dozakaz: TcxGridDBColumn;
    AmountSumm_Dozakaz: TcxGridDBColumn;
    Amount_Order: TcxGridDBColumn;
    actPrint_byPack: TdsdPrintAction;
    actPrint_byProduction: TdsdPrintAction;
    bbPrint_byProduction: TdxBarButton;
    actPrint_byType: TdsdPrintAction;
    bbPrint_byType: TdxBarButton;
    actPrint_byRoute: TdsdPrintAction;
    bbPrint_byRoute: TdxBarButton;
    Amount_WeightSK: TcxGridDBColumn;
    FromCode: TcxGridDBColumn;
    actPrint_byRouteItog: TdsdPrintAction;
    bbPrint_byRouteItog: TdxBarButton;
    InfoMoneyName: TcxGridDBColumn;
    cbByDoc: TcxCheckBox;
    AmountSale_Weight: TcxGridDBColumn;
    AmountSale_Sh: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    OperDatePartner: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    SumSale: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    Article: TcxGridDBColumn;
    InvNumberOrderPartner: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    CountDiff_B: TcxGridDBColumn;
    CountDiff_M: TcxGridDBColumn;
    WeightDiff_B: TcxGridDBColumn;
    WeightDiff_M: TcxGridDBColumn;
    Amount_Dozakaz: TcxGridDBColumn;
    AmountSale: TcxGridDBColumn;
    AmountTax: TcxGridDBColumn;
    DiffTax: TcxGridDBColumn;
    isPrint_M: TcxGridDBColumn;
    actRefreshDoc: TdsdDataSetRefresh;
    Diff_M: TcxGridDBColumn;
    InvNumber_Order: TcxGridDBColumn;
    CountPrint_M: TcxGridDBColumn;
    bbPrintNew: TdxBarButton;
    TotalCount_Diff: TcxGridDBColumn;
    TotalWeight_Diff: TcxGridDBColumn;
    TotalAmountTax: TcxGridDBColumn;
    TotalWeightTax: TcxGridDBColumn;
    AmountSale_Weight_M: TcxGridDBColumn;
    Amount_Weight_M: TcxGridDBColumn;
    Amount_Weight_Dozakaz_M: TcxGridDBColumn;
    OperDate_CarInfo: TcxGridDBColumn;
    OperDate_CarInfo_date: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    getMovementSaleForm: TdsdStoredProc;
    getMovementOrderForm: TdsdStoredProc;
    actMovementOrderForm: TdsdExecStoredProc;
    actMovementSaleForm: TdsdExecStoredProc;
    actOpenFormSale: TdsdOpenForm;
    macOpenDocumentSale: TMultiAction;
    macOpenDocumentOrder: TMultiAction;
    bbOpenDocumentOrder: TdxBarButton;
    bbOpenDocumentSale: TdxBarButton;
    actOpenFormOrder: TdsdOpenForm;
    GoodsBoxName_short: TcxGridDBColumn;
    AmountBox: TcxGridDBColumn;
    BoxCount: TcxGridDBColumn;
    cbbyPromo: TcxCheckBox;
    MovementPromo_order: TcxGridDBColumn;
    MovementPromo_sale: TcxGridDBColumn;
    actRefreshPromo: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
    RegisterClass(TReport_GoodsMI_OrderExternal_SaleForm);
end.
