unit Report_PharmacyPerformance;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, dsdGuides, cxButtonEdit, dxBarExtItems,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, cxPivotGridChartConnection,
  cxCustomPivotGrid, cxDBPivotGrid, cxGridChartView, cxGridDBChartView,
  cxSplitter, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
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
  dxSkinXmas2008Blue;

type
  TReport_PharmacyPerformanceForm = class(TAncestorReportForm)
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    bbStart: TdxBarControlContainerItem;
    dxBarControlContainerItem3: TdxBarControlContainerItem;
    dxBarControlContainerItem4: TdxBarControlContainerItem;
    UnitName: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    PercMarkup: TcxGridDBColumn;
    tsPivot: TcxTabSheet;
    cxSplitter1: TcxSplitter;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    dgUnit: TcxGridDBChartDataGroup;
    grChartLevel1: TcxGridLevel;
    cxDBPivotGrid1: TcxDBPivotGrid;
    pcolUnitName: TcxDBPivotGridField;
    pcolCountCheck: TcxDBPivotGridField;
    pcolTotalSumm: TcxDBPivotGridField;
    pcoCountCheckSecond: TcxDBPivotGridField;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actQuasiSchedule: TBooleanStoredProcAction;
    bbQuasiSchedule: TdxBarButton;
    cxLabel4: TcxLabel;
    bb122: TdxBarControlContainerItem;
    bbEnd: TdxBarControlContainerItem;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    pcoTotalSummSecond: TcxDBPivotGridField;
    actPrint: TdsdPrintAction;
    bbactPrint: TdxBarButton;
    bbGridToExcel1: TdxBarButton;
    deEnd2: TcxDateEdit;
    cxLabel3: TcxLabel;
    deStart2: TcxDateEdit;
    cxLabel5: TcxLabel;
    PeriodChoice2: TPeriodChoice;
    cbSeasonalityCoefficient: TcxCheckBox;
    serTotalSummSecond: TcxGridDBChartSeries;
    serAverageCheckSecond: TcxGridDBChartSeries;
    serPercMarkupSecond: TcxGridDBChartSeries;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_PharmacyPerformanceForm: TReport_PharmacyPerformanceForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_PharmacyPerformanceForm);

end.
