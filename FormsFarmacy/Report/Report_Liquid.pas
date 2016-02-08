unit Report_Liquid;

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
  dxSkinsdxBarPainter;

type
  TReport_LiquidForm = class(TAncestorReportForm)
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    bbStart: TdxBarControlContainerItem;
    cxLabel3: TcxLabel;
    dxBarControlContainerItem3: TdxBarControlContainerItem;
    ceUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    rdUnit: TRefreshDispatcher;
    dxBarControlContainerItem4: TdxBarControlContainerItem;
    colOperDate: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    StartSum: TcxGridDBColumn;
    EndSum: TcxGridDBColumn;
    SummaIncome: TcxGridDBColumn;
    tsPivot: TcxTabSheet;
    cxSplitter1: TcxSplitter;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    dgDate: TcxGridDBChartDataGroup;
    dgUnit: TcxGridDBChartDataGroup;
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
    clSummaSale: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    bb: TdxBarControlContainerItem;
    bbEnd: TdxBarControlContainerItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_LiquidForm: TReport_LiquidForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_LiquidForm);

end.
