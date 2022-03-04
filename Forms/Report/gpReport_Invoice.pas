unit gpReport_Invoice;

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
  TReport_InvoiceForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    NameBeforeName: TcxGridDBColumn;
    ServiceSumma: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    MovementId: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    edJuridical: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edPaidKind: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    actPrint1: TdsdPrintAction;
    actPrint2: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    bbPrint2: TdxBarButton;
    actOpenReportForm: TdsdOpenForm;
    InvNumber_Full: TcxGridDBColumn;
    bbOpenReportForm: TdxBarButton;
    actOpenForm: TdsdOpenForm;
    actGetForm: TdsdExecStoredProc;
    getMovementForm: TdsdStoredProc;
    actOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_InvoiceForm);

end.
