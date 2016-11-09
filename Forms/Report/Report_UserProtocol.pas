unit Report_UserProtocol;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox, cxSplitter,
  cxGridChartView, cxGridDBChartView;

type
  TReport_UserProtocolForm = class(TAncestorReportForm)
    UserCode: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    MemberName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    cxLabel3: TcxLabel;
    edBranch: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edUser: TcxButtonEdit;
    cbisDay: TcxCheckBox;
    GuidesUser: TdsdGuides;
    GuidesBranch: TdsdGuides;
    actRefreshIsDay: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbDialog: TdxBarButton;
    Color_Calc: TcxGridDBColumn;
    grChart: TcxGrid;
    grChartDBChartView1: TcxGridDBChartView;
    dgUserName: TcxGridDBChartDataGroup;
    dgOperDate: TcxGridDBChartDataGroup;
    serCount: TcxGridDBChartSeries;
    serMov_Count: TcxGridDBChartSeries;
    serMI_Count: TcxGridDBChartSeries;
    serCount_Prog: TcxGridDBChartSeries;
    serCount_Work: TcxGridDBChartSeries;
    grChartLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_UserProtocolForm);

end.
