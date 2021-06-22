unit Report_Balance_grid;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox;

type
  TReport_Balance_gridForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint_ol: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actRefreshUnit: TdsdDataSetRefresh;
    spGetProfitLostParam: TdsdStoredProc;
    actGetProfitLostParam: TdsdExecStoredProc;
    actOpenReport_Account: TdsdOpenForm;
    macReport_Account: TMultiAction;
    actOpenReport_AccountMotion: TdsdOpenForm;
    macReport_AccountMotion: TMultiAction;
    actPrint: TdsdPrintAction;
    actPrintBranch: TdsdPrintAction;
    cbTotal: TcxCheckBox;
    bbReport_Account: TdxBarButton;
    bbReport_AccountMotion: TdxBarButton;
    bbPrintBranch: TdxBarButton;
    bbTotal: TdxBarControlContainerItem;
    AmountKreditEnd: TcxGridDBColumn;
    AmountActiveEnd: TcxGridDBColumn;
    AmountPassiveEnd: TcxGridDBColumn;
    cbGroup: TcxCheckBox;
    bbcbGroup: TdxBarControlContainerItem;
    actPrint2: TdsdPrintAction;
    actPrint3: TdsdPrintAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization

  RegisterClass(TReport_Balance_gridForm);

end.
