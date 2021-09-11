unit gpReport_PromoInvoice;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxImageComboBox;

type
  TReport_PromoInvoiceForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    InvNumber_promo: TcxGridDBColumn;
    ServiceSumma: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    MovementId: TcxGridDBColumn;
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
    InvNumber_Full_inv: TcxGridDBColumn;
    bbOpenReportForm: TdxBarButton;
    actOpenForm: TdsdOpenForm;
    actGetForm: TdsdExecStoredProc;
    getMovementForm: TdsdStoredProc;
    actOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    cxLabel3: TcxLabel;
    deStart2: TcxDateEdit;
    cxLabel4: TcxLabel;
    deEnd2: TcxDateEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_PromoInvoiceForm);

end.
