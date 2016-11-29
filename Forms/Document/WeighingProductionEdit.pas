unit WeighingProductionEdit;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, cxCheckBox;

type
  TWeighingProductionEditForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    edOperDate: TcxDateEdit;
    GuidesFiller: TGuidesFiller;
    edInvNumber: TcxTextEdit;
    cxLabel12: TcxLabel;
    edWeighingNumber: TcxCurrencyEdit;
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
    cxLabel18: TcxLabel;
    edPartionGoods: TcxTextEdit;
    edisIncome: TcxCheckBox;
    cxLabel10: TcxLabel;
    edDocumentKind: TcxButtonEdit;
    GuidesDocumentKind: TdsdGuides;
    edInvNumber_parent: TcxButtonEdit;
    ParentGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TWeighingProductionEditForm);

end.
