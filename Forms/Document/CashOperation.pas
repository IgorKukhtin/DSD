unit CashOperation;

interface

uses
  AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TCashOperationForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    ceCash: TcxButtonEdit;
    ceUnit: TcxButtonEdit;
    ceInfoMoney: TcxButtonEdit;
    ceOperDate: TcxDateEdit;
    ceAmountIn: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    CashGuides: TdsdGuides;
    UnitGuides: TdsdGuides;
    InfoMoneyGuides: TdsdGuides;
    ceObject: TcxButtonEdit;
    ObjectlGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel8: TcxLabel;
    ceContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    ceAmountOut: TcxCurrencyEdit;
    edInvNumber: TcxTextEdit;
    cxLabel9: TcxLabel;
    ceMember: TcxButtonEdit;
    cxLabel11: TcxLabel;
    cePosition: TcxButtonEdit;
    cxLabel12: TcxLabel;
    PersonalGuides: TdsdGuides;
    MemberGuides: TdsdGuides;
    ceServiceDate: TcxDateEdit;
    cxLabel13: TcxLabel;
    ceCurrencyPartnerValue: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    ceParPartnerValue: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    ceCurrency: TcxButtonEdit;
    cxLabel16: TcxLabel;
    ceAmountSumm: TcxCurrencyEdit;
    CurrencyGuides: TdsdGuides;
    cxLabel19: TcxLabel;
    edInvNumberSale: TcxButtonEdit;
    SaleChoiceGuides: TdsdGuides;
    cxLabel17: TcxLabel;
    ceInvoice: TcxButtonEdit;
    cxLabel18: TcxLabel;
    ceComment_Invoice: TcxTextEdit;
    InvoiceGuides: TdsdGuides;
    cxLabel20: TcxLabel;
    ceCurrencyPartner: TcxButtonEdit;
    CurrencyPartnerGuides: TdsdGuides;
    cxLabel21: TcxLabel;
    edCar: TcxButtonEdit;
    GuidesCar: TdsdGuides;
    PopupMenu: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    actOpenPositionForm: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TCashOperationForm);

end.
