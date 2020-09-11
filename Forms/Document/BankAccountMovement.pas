unit BankAccountMovement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEditDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, dsdAction,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, dsdGuides, cxButtonEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxCurrencyEdit, cxLabel, dxSkinsCore, dxSkinsDefaultPainters;

type
  TBankAccountMovementForm = class(TAncestorEditDialogForm)
    Код: TcxLabel;
    cxLabel1: TcxLabel;
    ceOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    ceBankAccount: TcxButtonEdit;
    GuidesBankAccount: TdsdGuides;
    ceAmountIn: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceAmountOut: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel6: TcxLabel;
    ceObject: TcxButtonEdit;
    lGuidesObject: TdsdGuides;
    cxLabel5: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    ceContract: TcxButtonEdit;
    cxLabel8: TcxLabel;
    GuidesContract: TdsdGuides;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel9: TcxLabel;
    ceCurrency: TcxButtonEdit;
    GuidesCurrency: TdsdGuides;
    edInvNumber: TcxTextEdit;
    cxLabel11: TcxLabel;
    ceCurrencyPartnerValue: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    ceParPartnerValue: TcxCurrencyEdit;
    ceBank: TcxButtonEdit;
    cxLabel13: TcxLabel;
    GuidesBank: TdsdGuides;
    cxLabel4: TcxLabel;
    ceAmountSumm: TcxCurrencyEdit;
    ceUnit: TcxButtonEdit;
    cxLabel14: TcxLabel;
    GuidesUnit: TdsdGuides;
    cxLabel15: TcxLabel;
    ceInvoice: TcxButtonEdit;
    GuidesInvoice: TdsdGuides;
    cxLabel16: TcxLabel;
    ceComment_Invoice: TcxTextEdit;
    cxLabel17: TcxLabel;
    ceServiceDate: TcxDateEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankAccountMovementForm);

end.
