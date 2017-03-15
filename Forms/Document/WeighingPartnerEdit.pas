unit WeighingPartnerEdit;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, cxCheckBox;

type
  TWeighingPartnerEditForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    edOperDate: TcxDateEdit;
    GuidesFiller: TGuidesFiller;
    edInvNumber: TcxTextEdit;
    cxLabel12: TcxLabel;
    edWeighingNumber: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    edInvNumberOrder: TcxButtonEdit;
    cxLabel2: TcxLabel;
    edOperDate_parent: TcxDateEdit;
    cxLabel13: TcxLabel;
    edMovementDescName: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edMovementDescNumber: TcxTextEdit;
    MovementDescGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    edStartWeighing: TcxDateEdit;
    cxLabel9: TcxLabel;
    edEndWeighing: TcxDateEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    edFrom: TcxButtonEdit;
    dsdGuidesFrom: TdsdGuides;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edTo: TcxButtonEdit;
    dsdGuidesTo: TdsdGuides;
    cxLabel8: TcxLabel;
    edUser: TcxButtonEdit;
    UserGuides: TdsdGuides;
    cxLabel10: TcxLabel;
    edPaidKind: TcxButtonEdit;
    cxLabel16: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel11: TcxLabel;
    edContractTag: TcxButtonEdit;
    cxLabel20: TcxLabel;
    edVATPercent: TcxCurrencyEdit;
    PaidKindGuides: TdsdGuides;
    ContractGuides: TdsdGuides;
    ContractTagGuides: TdsdGuides;
    cxLabel18: TcxLabel;
    cxLabel19: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    OrderChoiceGuides: TdsdGuides;
    edInvNumber_Parent: TcxButtonEdit;
    ParentGuides: TdsdGuides;
    ceTransport: TcxButtonEdit;
    TransportGuides: TdsdGuides;
    edOperDate_Transport: TcxDateEdit;
    cxLabel14: TcxLabel;
    edPriceWithVAT: TcxCheckBox;
    cxLabel23: TcxLabel;
    edMember: TcxButtonEdit;
    GuidesMember: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TWeighingPartnerEditForm);

end.
