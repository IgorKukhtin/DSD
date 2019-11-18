unit Report_Loyalty_CreaturesPromocode;

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
  TReport_Loyalty_CreaturesPromocodeForm = class(TAncestorReportForm)
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    cxLabel3: TcxLabel;
    dxBarControlContainerItem3: TdxBarControlContainerItem;
    ceUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    dxBarControlContainerItem4: TdxBarControlContainerItem;
    OperDate: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    PaymentSum: TcxGridDBColumn;
    tsPivot: TcxTabSheet;
    cxSplitter1: TcxSplitter;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    dgDate: TcxGridDBChartDataGroup;
    dgUnit: TcxGridDBChartDataGroup;
    serSummaPromo: TcxGridDBChartSeries;
    serCountPromo: TcxGridDBChartSeries;
    grChartLevel1: TcxGridLevel;
    cxDBPivotGrid1: TcxDBPivotGrid;
    pcolOperDate: TcxDBPivotGridField;
    pcolWeek: TcxDBPivotGridField;
    pcolUnitName: TcxDBPivotGridField;
    pcolSummaPromo: TcxDBPivotGridField;
    pcoCountPromo: TcxDBPivotGridField;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actQuasiSchedule: TBooleanStoredProcAction;
    bbQuasiSchedule: TdxBarButton;
    actGridToExcelPivot: TdsdGridToExcel;
    bbGridToExcelPivot: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    FormParams: TdsdFormParams;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Loyalty_CreaturesPromocodeForm: TReport_Loyalty_CreaturesPromocodeForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Loyalty_CreaturesPromocodeForm);

end.
