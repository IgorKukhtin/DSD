unit ChangeIncomePayment;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore,
  cxDateUtils, dsdDB, cxCurrencyEdit, dsdGuides, cxButtonEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxTextEdit, cxLabel, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons;

type
  TChangeIncomePaymentForm = class(TAncestorDialogForm)
    Код: TcxLabel;
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    deOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    edFrom: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    FromGuides: TdsdGuides;
    cxLabel7: TcxLabel;
    ceSumm: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edChangeIncomePaymentKind: TcxButtonEdit;
    cxLabel10: TcxLabel;
    edComment: TcxTextEdit;
    ChangeIncomePaymentKindGuides: TdsdGuides;
    spGet: TdsdStoredProc;
    spInsertUpdate: TdsdStoredProc;
    actInsertUpdate: TdsdInsertUpdateGuides;
    actFormClose: TdsdFormClose;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChangeIncomePaymentForm: TChangeIncomePaymentForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TChangeIncomePaymentForm);

end.
