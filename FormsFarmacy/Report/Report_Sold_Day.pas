unit Report_Sold_Day;

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
  TReport_Sold_DayForm = class(TAncestorReportForm)
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    cxLabel3: TcxLabel;
    dxBarControlContainerItem3: TdxBarControlContainerItem;
    ceUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    rdUnit: TRefreshDispatcher;
    dxBarControlContainerItem4: TdxBarControlContainerItem;
    PlanDate: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    PlanAmount: TcxGridDBColumn;
    PlanAmountAccum: TcxGridDBColumn;
    FactAmount: TcxGridDBColumn;
    FactAmountAccum: TcxGridDBColumn;
    DiffAmount: TcxGridDBColumn;
    DiffAmountAccum: TcxGridDBColumn;
    PercentMake: TcxGridDBColumn;
    PercentMakeAccum: TcxGridDBColumn;
    tsPivot: TcxTabSheet;
    cxSplitter1: TcxSplitter;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    dgDate: TcxGridDBChartDataGroup;
    dgUnit: TcxGridDBChartDataGroup;
    serPlanAmount: TcxGridDBChartSeries;
    serPlanAmountAccum: TcxGridDBChartSeries;
    serFactAmount: TcxGridDBChartSeries;
    serFactAmountAccum: TcxGridDBChartSeries;
    grChartLevel1: TcxGridLevel;
    cxDBPivotGrid1: TcxDBPivotGrid;
    pcolPlanDate: TcxDBPivotGridField;
    pcolWeek: TcxDBPivotGridField;
    pcolUnitName: TcxDBPivotGridField;
    pcolPlanAmount: TcxDBPivotGridField;
    pcolFactAmount: TcxDBPivotGridField;
    pcolDiffAmount: TcxDBPivotGridField;
    pcolDayOfWeek: TcxDBPivotGridField;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actQuasiSchedule: TBooleanStoredProcAction;
    bbQuasiSchedule: TdxBarButton;
    actGridToExcelPivot: TdsdGridToExcel;
    bbGridToExcelPivot: TdxBarButton;
    UnitJuridical: TcxGridDBColumn;
    pcolUnitJuridical: TcxDBPivotGridField;
    ProvinceCityName: TcxGridDBColumn;
    dxBarControlContainerItem5: TdxBarControlContainerItem;
    actNoStaticCodes: TBooleanStoredProcAction;
    bbNoStaticCodes: TdxBarButton;
    actSP: TBooleanStoredProcAction;
    dxBarButton1: TdxBarButton;
    FactAmountSale: TcxGridDBColumn;
    pcolFactAmountSale: TcxDBPivotGridField;
    grChartItog: TcxGrid;
    cxGridDBChartView1: TcxGridDBChartView;
    cxGridDBChart_PlanDate: TcxGridDBChartDataGroup;
    cxGridDBChart_FactAmount: TcxGridDBChartSeries;
    cxGridLevel1: TcxGridLevel;
    cxSplitter2: TcxSplitter;
    ChartItogDS: TDataSource;
    ChartItogCDS: TClientDataSet;
    pcolFactAmountSaleIC: TcxDBPivotGridField;
    FactAmountSaleIC: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Sold_DayForm: TReport_Sold_DayForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Sold_DayForm);

end.
