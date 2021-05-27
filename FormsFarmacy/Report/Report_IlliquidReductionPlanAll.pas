unit Report_IlliquidReductionPlanAll;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TReport_IlliquidReductionPlanAllForm = class(TAncestorReportForm)
    UserCode: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    AmountAll: TcxGridDBColumn;
    AmountSale: TcxGridDBColumn;
    Color_calc: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    cePenalty: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    ceProcGoods: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ceProcUnit: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    AmountStart: TcxGridDBColumn;
    SummaPenalty: TcxGridDBColumn;
    ManDays: TcxGridDBColumn;
    SummaSale: TcxGridDBColumn;
    ProcSaleIlliquid: TcxGridDBColumn;
    cePlanAmount: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    SummaPenaltyCount: TcxGridDBColumn;
    SummaPenaltySum: TcxGridDBColumn;
    DaysWorked: TcxGridDBColumn;
    cePenaltySum: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_IlliquidReductionPlanAllForm);

end.
