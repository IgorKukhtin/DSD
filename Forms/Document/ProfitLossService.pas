unit ProfitLossService;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, cxCheckBox;

type
  TProfitLossServiceForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceInvNumber: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cePaidKind: TcxButtonEdit;
    ceUnit: TcxButtonEdit;
    ceInfoMoney: TcxButtonEdit;
    ceOperDate: TcxDateEdit;
    ceAmountDebet: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    PaidKindGuides: TdsdGuides;
    UnitGuides: TdsdGuides;
    InfoMoneyGuides: TdsdGuides;
    ceJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    ceContract: TcxButtonEdit;
    cxLabel8: TcxLabel;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    ContractGuides: TdsdGuides;
    ceAmountKredit: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel9: TcxLabel;
    ceContractConditionKind: TcxButtonEdit;
    BonusKindGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    ceBonusKind: TcxButtonEdit;
    ContractConditionKindGuides: TdsdGuides;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    ceContractMaster: TcxButtonEdit;
    ContractMasterGuides: TdsdGuides;
    ceContractChild: TcxButtonEdit;
    ContractChildGuides: TdsdGuides;
    ceBonusValue: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TProfitLossServiceForm);

end.
