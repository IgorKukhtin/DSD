unit ProductionUnionTechEdit;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TProductionUnionTechEditForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    ceOperDate: TcxDateEdit;
    ceRealWeight: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceRecipe: TcxButtonEdit;
    ReceiptGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    ceGooods: TcxButtonEdit;
    cxLabel12: TcxLabel;
    ReceiptGoodsGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    ceCount: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ce—uterCount: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    ce—uterCountOrder: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    ceAmountOrder: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cxLabel5: TcxLabel;
    GooodsKindGuides: TdsdGuides;
    ceGooodsKindGuides: TcxButtonEdit;
    ceReceiptCode: TcxTextEdit;
    cxLabel8: TcxLabel;
    ceGooodsKindCompleteGuides: TcxButtonEdit;
    GooodsKindCompleteGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    ceCuterWeight: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edDocumentKind: TcxButtonEdit;
    GuidesDocumentKind: TdsdGuides;
    cxLabel15: TcxLabel;
    ceAmount: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    ceRealWeightMsg: TcxCurrencyEdit;
    ceRealWeightShp: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TProductionUnionTechEditForm);

end.
