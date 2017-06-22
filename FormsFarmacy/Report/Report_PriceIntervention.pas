unit Report_PriceIntervention;

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
  dxSkinsdxBarPainter, cxGridBandedTableView, cxGridDBBandedTableView,DataModul;

type
  TReport_PriceInterventionForm = class(TAncestorReportForm)
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    bbStart: TdxBarControlContainerItem;
    cxLabel3: TcxLabel;
    dxBarControlContainerItem3: TdxBarControlContainerItem;
    ceMarginReport: TcxButtonEdit;
    MarginReportGuides: TdsdGuides;
    dxBarControlContainerItem4: TdxBarControlContainerItem;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actQuasiSchedule: TBooleanStoredProcAction;
    bbQuasiSchedule: TdxBarButton;
    cxLabel4: TcxLabel;
    bb122: TdxBarControlContainerItem;
    bbEnd: TdxBarControlContainerItem;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel8: TcxLabel;
    cePrice1: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    cePrice2: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    cePrice3: TcxCurrencyEdit;
    cePrice4: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    cePrice5: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    cePrice6: TcxCurrencyEdit;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    JuridicalMainName: TcxGridDBBandedColumn;
    UnitName: TcxGridDBBandedColumn;
    Amount: TcxGridDBBandedColumn;
    SummaSale: TcxGridDBBandedColumn;
    Summa: TcxGridDBBandedColumn;
    Color_Amount: TcxGridDBBandedColumn;
    Color_Summa: TcxGridDBBandedColumn;
    Color_SummaSale: TcxGridDBBandedColumn;
    spInsertUpdate: TdsdStoredProc;
    actInsertUpdate: TdsdUpdateDataSet;
    MarginCategoryName: TcxGridDBBandedColumn;
    MarginReportItemOpenForm: TdsdOpenForm;
    bbMarginReportItem: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_PriceInterventionForm: TReport_PriceInterventionForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_PriceInterventionForm);

end.
