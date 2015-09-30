unit Report_Sold;

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
  cxCurrencyEdit, cxGridChartView, cxGridDBChartView, cxSplitter;

type
  TReport_SoldForm = class(TAncestorReportForm)
    colPlanDate: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colPlanAmount: TcxGridDBColumn;
    colPlanAmountAccum: TcxGridDBColumn;
    FactAmount: TcxGridDBColumn;
    colFactAmountAccum: TcxGridDBColumn;
    colDiffAmount: TcxGridDBColumn;
    colDiffAmountAccum: TcxGridDBColumn;
    colPercentMake: TcxGridDBColumn;
    colPercentMakeAccum: TcxGridDBColumn;
    grChartLevel1: TcxGridLevel;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    serPlanAmount: TcxGridDBChartSeries;
    serPlanAmountAccum: TcxGridDBChartSeries;
    serFactAmount: TcxGridDBChartSeries;
    serFactAmountAccum: TcxGridDBChartSeries;
    dgDate: TcxGridDBChartDataGroup;
    dgUnit: TcxGridDBChartDataGroup;
    cxSplitter1: TcxSplitter;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_SoldForm);

end.
