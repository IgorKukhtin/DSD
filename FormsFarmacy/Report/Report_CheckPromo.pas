unit Report_CheckPromo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCurrencyEdit, cxGridChartView, cxGridDBChartView, cxSplitter, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TReport_CheckPromoForm = class(TAncestorReportForm)
    colPlanDate: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colPlanAmount: TcxGridDBColumn;
    colPlanAmountAccum: TcxGridDBColumn;
    TotalAmount: TcxGridDBColumn;
    TotalSumma: TcxGridDBColumn;
    AmountPromo: TcxGridDBColumn;
    SummaPromo: TcxGridDBColumn;
    PercentPromo: TcxGridDBColumn;
    grChartLevel1: TcxGridLevel;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    serTotalSumma: TcxGridDBChartSeries;
    serSummaPromo: TcxGridDBChartSeries;
    serSumma: TcxGridDBChartSeries;
    serPercentPromo: TcxGridDBChartSeries;
    dgDate: TcxGridDBChartDataGroup;
    dgUnit: TcxGridDBChartDataGroup;
    cxSplitter1: TcxSplitter;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_CheckPromoForm);

end.
