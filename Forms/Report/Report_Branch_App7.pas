unit Report_Branch_App7;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus;

type
  TReport_Branch_App7Form = class(TAncestorReportForm)
    CashSummEnd: TcxGridDBColumn;
    JuridicalSummStart: TcxGridDBColumn;
    JuridicalSummEnd: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    JuridicalSummOut: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    CashSummStart: TcxGridDBColumn;
    JuridicalSummIn: TcxGridDBColumn;
    GoodsSummStart: TcxGridDBColumn;
    GoodsSummEnd: TcxGridDBColumn;
    GoodsSummIn: TcxGridDBColumn;
    GoodsSummOut: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    CashSummIn: TcxGridDBColumn;
    CashSummOut: TcxGridDBColumn;
    CashAmount: TcxGridDBColumn;
    GoodsSummSale_SF: TcxGridDBColumn;
    GoodsSummReturnIn_SF: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Branch_App7Form);

end.
