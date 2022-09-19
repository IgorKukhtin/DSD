unit Report_ConductedSalesMobile;

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
  TReport_ConductedSalesMobileForm = class(TAncestorReportForm)
    OperDate: TcxGridDBColumn;
    CountCheck: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    dgDate: TcxGridDBChartDataGroup;
    serPlanAmount: TcxGridDBChartSeries;
    grChartLevel1: TcxGridLevel;
    bbQuasiSchedule: TdxBarButton;
    bbGridToExcelPivot: TdxBarButton;
    FormParams: TdsdFormParams;
    dxBarContainerItem1: TdxBarContainerItem;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_ConductedSalesMobileForm: TReport_ConductedSalesMobileForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_ConductedSalesMobileForm);

end.
