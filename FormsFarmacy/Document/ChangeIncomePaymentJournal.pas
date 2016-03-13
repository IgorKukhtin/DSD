unit ChangeIncomePaymentJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxImageComboBox,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdDB,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC;

type
  TChangeIncomePaymentJournalForm = class(TAncestorJournalForm)
    colFromName: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    colChangeIncomePaymentKindName: TcxGridDBColumn;
    colTotalSumm: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    clReturnOutInvNumber: TcxGridDBColumn;
    clReturnOutInvNumberPartner: TcxGridDBColumn;
    clReturnOutOperDate: TcxGridDBColumn;
    clReturnOutOperDatePartner: TcxGridDBColumn;
    clIncomeOperDate: TcxGridDBColumn;
    clIncomeInvNumber: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChangeIncomePaymentJournalForm: TChangeIncomePaymentJournalForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TChangeIncomePaymentJournalForm);
end.
