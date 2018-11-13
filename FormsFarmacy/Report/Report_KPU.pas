unit Report_KPU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  AncestorReport, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, Data.DB, cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxPC, cxContainer, cxTextEdit,
  cxLabel, cxCurrencyEdit, cxButtonEdit, Vcl.DBActns, cxMaskEdit, Vcl.ExtCtrls,
  Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod, cxDropDownEdit, cxCalendar,
  dsdGuides, dxBarBuiltInMenu, cxNavigator, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxGridBandedTableView,
  cxGridDBBandedTableView, cxCheckBox, cxBlobEdit, cxMemo;

type
  TReport_KPUForm = class(TAncestorReportForm)
    UserCode: TcxGridDBBandedColumn;
    UserName: TcxGridDBBandedColumn;
    AmountTheFineTab: TcxGridDBBandedColumn;
    actRefreshSearch: TdsdExecStoredProc;
    KPU: TcxGridDBBandedColumn;
    BonusAmountTab: TcxGridDBBandedColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    FactOfManDays: TcxGridDBBandedColumn;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    MarkRatio: TcxGridDBBandedColumn;
    spInsertUpdateMovementItem: TdsdStoredProc;
    actUpdateMainDS: TdsdUpdateDataSet;
    edRecount: TcxCheckBox;
    PrevAverageCheck: TcxGridDBBandedColumn;
    AverageCheck: TcxGridDBBandedColumn;
    AverageCheckRatio: TcxGridDBBandedColumn;
    PositionName: TcxGridDBBandedColumn;
    DateIn: TcxGridDBBandedColumn;
    LateTimeRatio: TcxGridDBBandedColumn;
    CorrectAnswers: TcxGridDBBandedColumn;
    NumberAttempts: TcxGridDBBandedColumn;
    ExamPercentage: TcxGridDBBandedColumn;
    IT_ExamRatio: TcxGridDBBandedColumn;
    ExamResult: TcxGridDBBandedColumn;
    ComplaintsRatio: TcxGridDBBandedColumn;
    ComplaintsNote: TcxGridDBBandedColumn;
    DirectorRatio: TcxGridDBBandedColumn;
    DirectorNote: TcxGridDBBandedColumn;
    FinancPlan: TcxGridDBBandedColumn;
    FinancPlanFact: TcxGridDBBandedColumn;
    FinancPlanRatio: TcxGridDBBandedColumn;
    YuriIT: TcxGridDBBandedColumn;
    OlegIT: TcxGridDBBandedColumn;
    MaximIT: TcxGridDBBandedColumn;
    CollegeITRatio: TcxGridDBBandedColumn;
    CollegeITNote: TcxGridDBBandedColumn;
    VIPDepartRatio: TcxGridDBBandedColumn;
    VIPDepartRatioNote: TcxGridDBBandedColumn;
    Romanova: TcxGridDBBandedColumn;
    Golovko: TcxGridDBBandedColumn;
    ControlRGRatio: TcxGridDBBandedColumn;
    ControlRGNote: TcxGridDBBandedColumn;
    Color_Calc: TcxGridDBBandedColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_KPUForm);

end.
