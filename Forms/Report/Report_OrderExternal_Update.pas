unit Report_OrderExternal_Update;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxGridChartView, cxGridDBChartView, cxSplitter;

type
  TReport_OrderExternal_UpdateForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    AmountSh: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    CarInfoName: TcxGridDBColumn;
    actPrint_byByer: TdsdPrintAction;
    RouteName: TcxGridDBColumn;
    edTo: TcxButtonEdit;
    cxLabel8: TcxLabel;
    GuidesTo: TdsdGuides;
    actPrint_byPack: TdsdPrintAction;
    actPrint_byProduction: TdsdPrintAction;
    actPrint_byType: TdsdPrintAction;
    actPrint_byRoute: TdsdPrintAction;
    actPrint_byRouteItog: TdsdPrintAction;
    actPrint_byCross: TdsdPrintAction;
    HeaderCDS: TClientDataSet;
    ItemsCDS: TClientDataSet;
    Amount: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint_byProductionDozakaz: TdsdPrintAction;
    actPrint_byType_Group: TdsdPrintAction;
    AmountWeight: TcxGridDBColumn;
    actPrint_byRouteGroup: TdsdPrintAction;
    mactOpenDocument: TMultiAction;
    actMovementCheck: TdsdExecStoredProc;
    actOpenForm: TdsdOpenForm;
    bbOpenDocument: TdxBarButton;
    getMovementCheck: TdsdStoredProc;
    CountPartner: TcxGridDBColumn;
    actOpenChoiceCarInfoForm: TOpenChoiceForm;
    spUpdate_CarInfo: TdsdStoredProc;
    macUpdate_CarInfo_list: TMultiAction;
    actUpdate_CarInfo: TdsdExecStoredProc;
    macUpdate_CarInfo: TMultiAction;
    bbUpdate_CarInfo: TdxBarButton;
    Days: TcxGridDBColumn;
    Times: TcxGridDBColumn;
    DayOfWeekName: TcxGridDBColumn;
    DayOfWeekName_Partner: TcxGridDBColumn;
    DayOfWeekName_CarInfo: TcxGridDBColumn;
    edIsDate_CarInfo: TcxCheckBox;
    actRefresh_Car: TdsdDataSetRefresh;
    spUpdate_CarInfo_grid: TdsdStoredProc;
    actUpdate_CarInfo_grid: TdsdExecStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    cxSplitter1: TcxSplitter;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    dgOperDate_CarInfo_str: TcxGridDBChartDataGroup;
    serCount_Partner: TcxGridDBChartSeries;
    serAmountWeight: TcxGridDBChartSeries;
    grChartLevel1: TcxGridLevel;
    grDayOfWeekName_CarInfo: TcxGridDBChartDataGroup;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_OrderExternal_UpdateForm);

end.
