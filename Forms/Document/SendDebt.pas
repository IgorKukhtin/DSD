unit SendDebt;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, cxCheckBox;

type
  TSendDebtForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceInvNumber: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cxLabel5: TcxLabel;
    cePaidKindFrom: TcxButtonEdit;
    ceInfoMoneyFrom: TcxButtonEdit;
    ceOperDate: TcxDateEdit;
    PaidKindFromGuides: TdsdGuides;
    InfoMoneyFromGuides: TdsdGuides;
    ceJuridicalFrom: TcxButtonEdit;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    ceContractFrom: TcxButtonEdit;
    cxLabel8: TcxLabel;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    ContractFromGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    ceAmount: TcxCurrencyEdit;
    ContractJuridicalFromGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    ceJuridicalTo: TcxButtonEdit;
    ContractToGuides: TdsdGuides;
    cxLabel7: TcxLabel;
    ceInfoMoneyTo: TcxButtonEdit;
    InfoMoneyToGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    cxLabel11: TcxLabel;
    cePaidKindTo: TcxButtonEdit;
    ceContractTo: TcxButtonEdit;
    PaidKindToGuides: TdsdGuides;
    ContractJuridicalToGuides: TdsdGuides;
    cePartnerFrom: TcxButtonEdit;
    cxLabel12: TcxLabel;
    PartnerFromGuides: TdsdGuides;
    cePartnerTo: TcxButtonEdit;
    cxLabel13: TcxLabel;
    PartnerToGuides: TdsdGuides;
    ceBranchFrom: TcxButtonEdit;
    cxLabel14: TcxLabel;
    BranchFromGuides: TdsdGuides;
    ceBranchTo: TcxButtonEdit;
    cxLabel15: TcxLabel;
    BranchToGuides: TdsdGuides;
    cxLabel16: TcxLabel;
    ceCurrencyValueFrom: TcxCurrencyEdit;
    ceParValueFrom: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    ceCurrencyFrom: TcxButtonEdit;
    cxLabel18: TcxLabel;
    GuidesCurrencyFrom: TdsdGuides;
    cxLabel19: TcxLabel;
    ceAmountCurrencyFrom: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    ceCurrencyValueTo: TcxCurrencyEdit;
    ceParValueTo: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    cxLabel22: TcxLabel;
    ceCurrencyTo: TcxButtonEdit;
    GuidesCurrencyTo: TdsdGuides;
    ceAmountCurrencyTo: TcxCurrencyEdit;
    cxLabel23: TcxLabel;
    cbisCopy: TcxCheckBox;
    RefreshDispatcher: TRefreshDispatcher;
    spGet_AmountCurr: TdsdStoredProc;
    actRefreshAmountCurr: TdsdDataSetRefresh;
    actCheckRight: TdsdExecStoredProc;
    spCheckRight: TdsdStoredProc;
    OpenChoiceFormContractFrom: TOpenChoiceForm;
    macCheckRight_From: TMultiAction;
    OpenChoiceFormContractTo: TOpenChoiceForm;
    macCheckRight_To: TMultiAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSendDebtForm);

end.
